// Copyright © 2022, Corsair Memory Inc. All rights reserved.

const OBS_PROTOCOL = "streamdeck-obs";
const OBS_PORTS = [28186, 39726, 34247, 42206, 38535, 40829, 40624];

const OBS_AUDIO_VOLUME_DB_MIN = -96.0;

// TODO:
// - Switch to well tested JSON-RPC library (or write our own).
// - Support notify/call grouping.
// - Verification for messages.
// - Errors

// Use addEventListener('notify.<name>' to listen to notifications).

class OBS extends EventTarget {
	constructor(controller) {
		super();
		this.PING_INTERVAL = 30000;

		this._ctr = controller;
		this._calls = new Map();
		this._ping = new Date().getTime();
		this._tryping = undefined;
		this._tryconnect = undefined;
		this._connected = false;
		this._connecting = undefined;
		this._initializing = true;
		this._probing_obs = false;
		this._ws = null;
		this._ws_pending = {};
		this._application_info;
		this._remote_version = null;
		this._connection_tries = 0;

		// Queue messages until OBS is loaded
		this._message_queue = [];
		this._obs_loaded = false;

		{ // RPC
			this._rpc = new RPC("", this);
			this._rpc.addEventListener("log", (event) => {
				this.log(event.data);
			});
			this._rpc.addEventListener("send", (event) => {
				this._rpc_on_send(event);
			});
		}

		// Sub-classes
		this._frontend_recording = new obs_frontend_recording(this);
		this._frontend_replaybuffer = new obs_frontend_replaybuffer(this);
		this._frontend_scene = new obs_frontend_scene(this);
		this._frontend_scenecollection = new obs_frontend_scenecollection(this);
		this._frontend_profile = new obs_frontend_profile(this);
		this._frontend_streaming = new obs_frontend_streaming(this);
		this._frontend_virtualcam = new obs_frontend_virtualcam(this);
		this._frontend_studiomode = new obs_frontend_studiomode(this);
		this._frontend_transition = new obs_frontend_transition_api(this);
		this._frontend_api = new obs_frontend_api(this);
		this._source_api = new obs_source_api(this);
		this._scene_api = new obs_scene_api(this);
	}

	log(msg) {
		this._ctr.log(`[OBS] ${msg}`);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Connection
	// ---------------------------------------------------------------------------------------------- //
	connect() {
		if (!this._ws) {
			this._message_queue = [];
			this._connected = false;
			this._initializing = true;
			try {
				this._obs_loaded = false;
				this._probing_obs = true;
				this._connection_tries += 1;
				// Attempt to connect to all valid ports in our range
				// Add a small delay between connections to give a slight chance to short circuit unnecessary connection attempts
				let timeoutMs = 200; // Start with a small delay to give slow computers a chance
				for (let portIdx = 0; portIdx < OBS_PORTS.length; ++portIdx) {
					const port = OBS_PORTS[portIdx];
					const ws = {
						socket: null,
						timeout: null,
						onOpen: ev => this._on_pending_open(ev, port),
						onClose: ev => this._on_pending_close(ev, port),
						port: port,
					};

					ws.timeout = setTimeout(() => {
						ws.timeout = null;
						ws.socket = new WebSocket(`ws://127.0.0.1:${port}`, [OBS_PROTOCOL]);
						ws.socket.addEventListener("open", ws.onOpen);
						ws.socket.addEventListener("close", ws.onClose);
					}, timeoutMs);
					timeoutMs += config.obs_connection_attempt_delay_port;

					if (this._ws_pending[port]) {
						const ows = this._ws_pending[port];
						if (ows.timeout) {
							clearTimeout(ows.timeout);
						}
						if (ows.socket) {
							// Ensure an asyncronous close() won't fire the onClose event and remove the new ws_pending entry
							ows.socket.removeEventListener("close", ows.onClose);
							ows.socket.close();
						}
					}
					this._ws_pending[port] = ws;
				}
			} catch (ex) {
				this.log(ex.toString());
			}
		}
	}

	disconnect() {
		// Cancel any automated tasks.
		this.cancel_try_ping();
		this.abort_connecting();

		// Terminate the WebSocket client by removing the reference to it.
		if (this._ws && (this._ws instanceof WebSocket)) {
			this._ws.close();
		}
		this._obs_loaded = false;
		this._initializing = false;
		this._ws = null;
	}

	try_connect() {
		// TODO: Consider moving this into the parent class.
		this._tryconnect = window.setTimeout(() => {
			this.connect();
		}, config.obs_connection_attempt_delay * (this._connection_tries + 1));
	}

	cancel_try_connect() {
		window.clearTimeout(this._tryconnect);
		this._tryconnect = undefined;
		this._probing_obs = false;
	}

	connecting() {
		return (this._connecting) || this._initializing || ((this._ws) && (this._ws.readyState == 0));
	}

	abort_connecting() {
		if (this._connecting) {
			window.clearTimeout(this._connecting);
			this._connecting = undefined;
			this._initializing = false;
		}
	}

	connected() {
		return (!this.connecting()) && (this._ws && (this._ws.readyState === 1));
	}

	_try_flush_queue(){
		if (this._obs_loaded && this.connected()){
			let ev = new Event("open", { "bubbles": true });
			ev.data = event;
			this.dispatchEvent(ev);

			const old_queue = this._message_queue;
			this._message_queue = [];
			for(const old_msg of old_queue){
				this._rpc.recv(old_msg);
			}
			return true;
		}
		return false;
	}

	_on_pending_open(event, port) {
		this._probing_obs = false;
		for (const i in this._ws_pending) {
			const ws = this._ws_pending[i];
			if (port != ws.port) {
				if (ws.timeout) {
					clearTimeout(ws.timeout);
				}
				if (ws.socket) {
					ws.socket.close();
				}
			} else {
				ws.socket.removeEventListener("open", ws.onOpen);
				ws.socket.removeEventListener("close", ws.onClose);
				this._ws = ws.socket;
				delete this._ws_pending[port];

				this._ws.addEventListener("open", (ev) => {
					this._on_open(ev);
				});
				this._ws.addEventListener("error", (ev) => {
					this._on_error(ev);
				});
				this._ws.addEventListener("close", (ev) => {
					this._on_close(ev);
				});

				// RPC Message Handling
				this._ws.addEventListener("message", (ev) => {
					this._rpc_on_message(ev);
				});
				this._on_open(event);
			}
		}
	}

	_on_pending_close(event, port) {
		delete this._ws_pending[port];
		if (this._probing_obs) {
			for (const i in this._ws_pending) {
				// If any connection is outstanding, we need to wait for it to complete
				if (this._ws_pending.hasOwnProperty(i)){
					return;
				}
			}
			this.try_connect();
		}
	}

	_on_open(event) {
		// Work around a bug in the Chromium version used by Stream Deck which might leave
		// connected WebSockets in a quantum state of both. This is a serious problem which
		// requires a fix on the Chromium side.

		this._connected = true;

		try {
			this._connecting = window.setTimeout(() => {
				try {
					this._connecting = undefined;
					this._connection_tries = 0;

					if (config.debug) {
						this.log("Connected to OBS Studio plugin.");
					}

					// TODO: Stop connection attempt loop?

					// Begin automatic ping loop to keep alive connection.
					this.try_ping();
					this.send_version();

					this._initializing = false;

					// Attempt to flush any pending messages while waiting to load OBS
					this._try_flush_queue();

				} catch (ex) {
					console.error(ex, ex.stack);
				}
			}, config.websocket_open_delay);
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_on_error(event) {
		try {
			let was_connected = this._connected == true;
			let was_connecting = !!this._connecting;

			this.disconnect();

			if (was_connecting) {
				if (config.debug) {
					this.log("Failed to fully establish connection with OBS Studio plugin.");
				}
			} else if (was_connected) {
				if (config.debug) {
					this.log("Lost connection with OBS Studio plugin due to an error. Reconnecting...");
				}

				{ // Events
					let ev = new Event("error", { "bubbles": true });
					ev.data = event;
					this.dispatchEvent(ev);
				}
			}
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_on_close(event) {
		try {
			// Cancel all pending calls immediately.
			this._rpc.cancel();

			// Clear out the websocket.
			this._ws = null;

			// Stop pinging the remote side.
			window.clearInterval(this._ping);

			this._obs_loaded = false;
			this._initializing = false;

			// If we were connected, notify any listeners.
			if (this._connected) {
				if (config.debug) {
					this.log("Connection was closed.");
				}

				{ // Events
					let ev = new Event("close", { "bubbles": true });
					ev.data = event;
					this.dispatchEvent(ev);
				}
			}

			// Repeat try-connect until cancelled.
			if (this._tryconnect) {
				this.try_connect();
			}
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_parse_version(v){
		if(v.length != 4){
			return 0;
		}
		return v[0] * 1000000000 + v[1] * 1000000 + v[2] * 1000 + v[3];
	}

	send_version() {
		if (!this._connected) {
			return;
		}

		this.call("version", (payload) => {
			this.log("Got version")
			if(payload && payload.semver){
				this._remote_version = this._parse_version(payload.semver);
			}
			if( !this._remote_version || this._remote_version < this._parse_version([5,4,0,13])){
				// Force OBS to be loaded if the OBS plugin is older than the version that provides synthetic loaded messages
				this.log("Old OBS")
				this._obs_loaded = true;
				this._try_flush_queue();
			}
		}, { "version": this._ctr && this._ctr._applicationInfo && this._ctr._applicationInfo.plugin && this._ctr._applicationInfo.plugin.version });
	}

	// ---------------------------------------------------------------------------------------------- //
	// Ping
	// ---------------------------------------------------------------------------------------------- //
	ping() {
		if (!this._connected) {
			return;
		}

		this._ping = new Date().getTime();
		this.call("ping", (r, e) => {
			this._on_pong(r, e);
		});
	}

	try_ping() {
		this._tryping = window.setTimeout(() => {
			try {
				this.ping();
			} catch (ex) {
				console.error(ex, ex.stack);
			}
		}, this.PING_INTERVAL);
	}

	cancel_try_ping() {
		window.clearTimeout(this._tryping);
	}

	_on_pong(result, error) {
		this._ping = (new Date().getTime() - this._ping); // Inaccurate, but we can't do anything about it.
		if ((result !== undefined) || error) {
			if (config.debug) {
				this.log(`Ping: ${this._ping}ms`);
			}
		} else {
			if (config.debug) {
				this.log("Ping: Timed out");
			}
		}

		// Enqueue a new ping attempt.
		if (this._tryping) {
			this.try_ping();
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// RPC
	// ---------------------------------------------------------------------------------------------- //
	_rpc_on_message(event) {
		try {
			if (config.debug_obs) {
				this.log(`RECV ${event.data}`);
			}
			let msg = JSON.parseEx(event.data);

			if (msg.method && !this._obs_loaded){
				if (msg.method == "obs.frontend.event.loaded"){
					event.preventDefault();
					this._obs_loaded = true;
					this._message_queue.unshift(msg);
					this._try_flush_queue();
				}
				else {
					this._message_queue.push(msg);
				}
			} else {
				this._rpc.recv(msg);
			}
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_rpc_on_send(event) {
		let dat = JSON.stringifyEx(event.data);
		if (config.debug_obs) {
			this.log(`SEND ${dat}`);
		}
		this._ws.send(dat);
	}

	notify(method, parameters = undefined) {
		this._rpc.notify(method, parameters);
	}

	call(method, callback, parameters = undefined, timeout = 300000) {
		return this._rpc.call(method, callback, parameters, timeout);
	}

	reply(id, result, error = undefined) {
		return this._rpc.reply(id, result, error);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Modern API
	// ---------------------------------------------------------------------------------------------- //
	get frontend_recording() {
		return this._frontend_recording;
	}

	get frontend_replaybuffer() {
		return this._frontend_replaybuffer;
	}

	get frontend_streaming() {
		return this._frontend_streaming;
	}

	get frontend_virtualcam() {
		return this._frontend_virtualcam;
	}

	get frontend_studiomode() {
		return this._frontend_studiomode;
	}

	get frontend_scene() {
		return this._frontend_scene;
	}

	get frontend_scenecollection() {
		return this._frontend_scenecollection;
	}

	get frontend_profile() {
		return this._frontend_profile;
	}

	get frontend_transition() {
		return this._frontend_transition;
	}

	get frontend_api() {
		return this._frontend_api;
	}

	get source_api() {
		return this._source_api;
	}

	get scene_api() {
		return this._scene_api;
	}
}
