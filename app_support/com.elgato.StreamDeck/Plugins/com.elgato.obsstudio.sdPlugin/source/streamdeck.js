// Copyright © 2022, Corsair Memory Inc. All rights reserved.

// ToDo:
// - Transition away from 'sd.EVENTNAME' to 'EVENTNAME', as Stream Deck events don't overlap with ours.

class StreamDeckMessageEvent extends Event {
	constructor(message, name, options) {
		super(name, options);

		this._raw = message;
		this._event = message.event;
		this._action = message.action;
		this._device = message.device;
		this._context = message.context;
		this._payload = message.payload;
	}

	get raw() {
		return this._raw;
	}

	get data() {
		return this._raw;
	}

	get event() {
		return this._event;
	}

	get action() {
		return this._action;
	}

	get device() {
		return this._device;
	}

	get context() {
		return this._context;
	}

	get payload() {
		return this._payload;
	}
}

class StreamDeck extends EventTarget {
	constructor(port, UUID, registerEvent, appInfo, actionInfo) {
		super();

		// Unique identifier of this Plugin or Property Inspector.
		this._uuid = UUID;

		// Information about the Application that is running us.
		this._appInfo = appInfo;

		// Information about the Action this Property Inspector belongs to. Empty is not a Property Inspector.
		this._actionInfo = actionInfo;

		// The port for WebSocket connections.
		this._port = port;

		// Name of the event to register ourselves to Stream Deck.
		this._registerEvent = registerEvent;

		// Todo: Remove legacy things.
		this._streamdeck = {
			port: port,
			uuid: UUID,
			event: registerEvent,
			info: appInfo
		};

		{ // Localization
			this.log(appInfo);
			this.log(registerEvent);
			this.log(UUID);
			this.log(`lang ${registerEvent}`);
			const lang = appInfo && appInfo.application && appInfo.application.language;
			this.log(`lang ${lang}`);

			if (lang) {
				loadLocalization(lang, registerEvent === "registerPropertyInspector" ? "../../../" : "../", () => {
					this.dispatchEvent(new Event("localizationLoaded", { "bubbles": true, "cancelable": true }));
					relocalize();
				});
			}
		}

		{ // Socket & Networking
			this._reconnect();
		}

		window.StreamDeck = this;
	}

	get appInfo() {
		return this._appInfo;
	}

	get uuid() {
		return this._uuid;
	}

	get actionInfo() {
		return this._actionInfo;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Networking
	// ---------------------------------------------------------------------------------------------- //
	_connect() {
		if (this._socket && (this._socket.readyState <= 1)) {
			// There is already a Socket connecting to the remote.
			return;
		}

		this._socket = new WebSocket("ws://localhost:" + this._port);
		this._socket.addEventListener("open", (ev) => {
			this._on_open(ev);
		});
		this._socket.addEventListener("close", (ev) => {
			this._on_close(ev);
		});
		this._socket.addEventListener("error", (ev) => {
			this._on_error(ev);
		});
		this._socket.addEventListener("message", (ev) => {
			this._on_message(ev);
		});
	}

	_disconnect() {
		if (this._socket && (this._socket.readyState == 1)) {
			this._socket.close();
		}
		this._socket = undefined;

		if (this._socket_delay) {
			window.clearTimeout(this._socket_delay);
		}
		this._socket_delay = undefined;
	}

	_reconnect() {
		this._disconnect();
		this._connect();
	}

	_on_open(event) {
		// See config.websocket_open_delay for this mess.
		this._socket_delay = window.setTimeout(() => {
			this._socket_delay = undefined;
			try {
				this.send({
					"event": this._registerEvent,
					"uuid": this.uuid,
				});

				{ // Event
					let ev = new Event("open", { "bubbles": true });
					ev.data = event;
					this.dispatchEvent(ev);
				}

			} catch (ex) {
				this.log(ex, "error");
			}
		}, config.websocket_open_delay);
	}

	_on_close(event) {
		try {
			this.disconnect();

			{ // Event
				let ev = new Event("close", { "bubbles": true });
				ev.data = event;
				this.dispatchEvent(ev);
			}
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_on_error(event) {
		try {
			{ // Event
				let ev = new Event("error", { "bubbles": true });
				ev.data = event;
				this.dispatchEvent(ev);
			}

			this._reconnect();
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_on_message(event) {
		try {
			let msg = JSON.parseEx(event.data);
			let key = "sd." + msg.event;

			if (config.debug_streamdeck) {
				this.log(`[StreamDeck] RECV ${event.data}`);
			}

			let uncaught = this.dispatchEvent(new StreamDeckMessageEvent(msg, msg.event, {
				"bubbles": true,
				"cancelable": config.debug
			}));
			let uncaught2 = this.dispatchEvent(new StreamDeckMessageEvent(msg, `sd.${msg.event}`, {
				"bubbles": true,
				"cancelable": config.debug
			}));
			if ((uncaught && uncaught2) && config.debug) {
				this.log(`[StreamDeck] Unhandled message '${msg.event}'.`);
			}
		} catch (ex) {
			console.error(ex, ex.stack);
		}
	}

	_send(raw) { // Send raw information.
		this._socket.send(raw);
	}

	connect() {
		this.log("This function is deprecated and does nothing.", "warn");
	}

	disconnect() {
		this.log("This function is deprecated and does nothing.", "warn");
	}

	send(data) {
		if (!this._socket) {
			throw new Error("Socket not open.");
		} else if (this._socket.readyState !== 1) {
			throw new Error("Socket not ready.");
		}

		data = JSON.stringifyEx(data);
		if (config.debug_streamdeck) {
			this.log(`[StreamDeck] SEND ${data}`);
		}
		this._send(data);
		return true;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Stream Deck Generic API
	// ---------------------------------------------------------------------------------------------- //
	setSettings(context, payload) {
		return this.send({
			"event": "setSettings",
			"context": context,
			"payload": payload
		});
	}

	getSettings(context) {
		return new Promise((resolve, reject) => {
			let timeout = undefined;
			let controller = new AbortController();

			// Ensure that we at most spend up to the configured time out on this.
			timeout = window.setTimeout(() => {
				// Prevent the event from being fired.
				controller.abort();
				reject(new Error(`Communication with Stream Deck timed out after ${config.streamdeck_timeout}ms.`));
			}, config.streamdeck_timeout);

			// Listen to the received events
			this.addEventListener("didReceiveSettings", (event) => {
				if (event.context == context) {
					window.clearTimeout(timeout);
					resolve(event.payload);
				}
			}, {
				"capture": true,
				"signal": controller.signal,
			});

			// Send the message that we want to get the settings of a context.
			try {
				this.send({
					"event": "getSettings",
					"context": context
				});
			} catch (ex) {
				controller.abort();
				reject(ex);
				return;
			}
		});
	}

	setGlobalSettings(payload) {
		return this.send({
			"event": "setGlobalSettings",
			"context": this.uuid,
			"payload": payload
		});
	}

	getGlobalSettings() {
		return new Promise((resolve, reject) => {
			let timeout = undefined;
			let controller = new AbortController();

			// Ensure that we at most spend up to the configured time out on this.
			timeout = window.setTimeout(() => {
				// Prevent the event from being fired.
				controller.abort();
				reject(new Error(`Communication with Stream Deck timed out after ${config.streamdeck_timeout}ms.`));
			}, config.streamdeck_timeout);

			// Listen to the received events
			this.addEventListener("didReceiveGlobalSettings", (event) => {
				window.clearTimeout(timeout);
				resolve(event.payload.settings);
			}, {
				"capture": true,
				"signal": controller.signal,
			});

			// Send the message that we want to get the settings of a context.
			try {
				this.send({
					"event": "getGlobalSettings",
					"context": this.uuid
				});
			} catch (ex) {
				controller.abort();
				reject(ex);
				return;
			}
		});
	}

	openURL(url) {
		return this.send({
			"event": "openUrl",
			"payload": {
				"url": url
			}
		});
	}

	/** Log a message to Stream Deck's log files.
	 *
	 * Prefer using StreamDeck.log() instead of this, as StreamDeck.log() provides more info.
	 *
	 * @param {string|String} message
	 * @returns
	 */
	logMessage(message) {
		message = JSON.stringifyEx({
			"event": "logMessage",
			"payload": {
				"message": message
			}
		});
		return this._send(message);
	}

	/** Log a message to Stream Deck's log files and console.
	 *
	 * @param {string|String} message
	 * @returns
	 */
	log(message, level) {
		let text = (new Error()).stack.substring(5);
		if (level == "debug") {
			console.debug(message, text);
		} else if (level == "error") {
			console.error(message, text);
		} else if (level == "warn") {
			console.warn(message, text);
		} else {
			console.log(message);
		}

		if (this._socket && this._socket.readyState == 1) {
			return this.logMessage(message);
		} else {
			return false;
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Stream Deck Plugin API
	// ---------------------------------------------------------------------------------------------- //
	setTitle(context, title, target, state) {
		return this.send({
			"event": "setTitle",
			"context": context,
			"payload": {
				"title": title,
				"target": target,
				"state": state
			}
		});
	}

	setImage(context, image, target, state) {
		return this.send({
			"event": "setImage",
			"context": context,
			"payload": {
				"image": image,
				"target": target,
				"state": state
			}
		});
	}

	setFeedback(context, payload) {
		return this.send({
			"event": "setFeedback",
			"context": context,
			"payload": payload
		})
	}

	setFeedbackLayout(context, layout) {
		return this.send({
			"event": "setFeedbackLayout",
			"context": context,
			"payload": {
				"layout": layout,
			}
		});
	}

	showAlert(context) {
		return this.send({
			"event": "showAlert",
			"context": context
		});
	}

	showOk(context) {
		return this.send({
			"event": "showOk",
			"context": context
		});
	}

	setState(context, state) {
		return this.send({
			"event": "setState",
			"context": context,
			"payload": {
				"state": state
			}
		});
	}

	switchToProfile(device, profile) {
		return this.send({
			"event": "switchToProfile",
			"context": this.uuid,
			"device": device,
			"payload": {
				"profile": profile
			}
		});
	}

	sendToPropertyInspector(action, context, payload) {
		return this.send({
			"event": "sendToPropertyInspector",
			"action": action,
			"context": context,
			"payload": payload
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Stream Deck Inspector API
	// ---------------------------------------------------------------------------------------------- //
	sendToPlugin(payload) {
		return this.send({
			"event": "sendToPlugin",
			"action": this.actionInfo.action,
			"context": this.uuid,
			"payload": payload
		});
	}
}
