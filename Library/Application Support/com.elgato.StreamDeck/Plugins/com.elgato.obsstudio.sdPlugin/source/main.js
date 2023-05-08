// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class plugin extends EventTarget {
	constructor(uPort, uUUID, uRegisterEvent, uApplicationInfo, uActionInfo) {
		super();

		// Set members to their default state.
		this._actions = new Map();
		this._connecting = undefined;
		this._connected = false;
		this._applicationInfo = uApplicationInfo;

		{ // Set up OBS Studio client.
			this._obs = new OBS(this);
			this._obs.addEventListener("open", (ev) => {
				this._on_obs_open(ev);
			});
			this._obs.addEventListener("close", (ev) => {
				this._on_obs_close(ev);
			});
			this._obs.addEventListener("error", (ev) => {
				this._on_obs_error(ev);
			});
		}

		{ // Set up Stream Deck client.
			this._sd = new StreamDeck(uPort, uUUID, uRegisterEvent, uApplicationInfo, uActionInfo);
			this.streamdeck.addEventListener("open", (ev) => {
				this._on_streamdeck_open(ev);
			});
			this.streamdeck.addEventListener("close", (ev) => {
				this._on_streamdeck_close(ev);
			});
			this.streamdeck.addEventListener("error", (ev) => {
				this._on_streamdeck_error(ev);
			});

			// Listen to any StreamDeck events we might be interested in.
			this.streamdeck.addEventListener("applicationDidLaunch", (ev) => {
				this._applicationDidLaunch(ev);
			});
			this.streamdeck.addEventListener("applicationDidTerminate", (ev) => {
				this._applicationDidTerminate(ev);
			});

			// Stream Deck: Action Events
			this.streamdeck.addEventListener("keyDown", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("keyUp", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("touchTap", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("dialPress", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("dialRotate", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("willAppear", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("willDisappear", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("didReceiveSettings", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("titleParametersDidChange", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("propertyInspectorDidAppear", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("propertyInspectorDidDisappear", (ev) => {
				this._actionEvent(ev);
			});
			this.streamdeck.addEventListener("sendToPlugin", (ev) => {
				this._actionEvent(ev);
			});
		}

		// Load all actions.
		for (let act of [
			FilterStateAction,
			RecordAction,
			RecordPauseAction,
			ReplayBufferAction,
			ReplayBufferSaveAction,
			SceneCollectionAction,
			ProfileAction,
			SceneAction,
			SceneItemVisibilityAction,
			ScreenshotAction,
			SourceAudioMuteAction,
			SourceAudioVolumeAction,
			SourceMediaAction,
			StreamAction,
			VirtualCamAction,
			StudioModeAction,
			TransitionStudioAction,
			TransitionAction,
		]) {
			try {
				let instance = new act(this);
				this._actions.set(instance.uuid, instance);
			} catch (ex) {
				console.log(ex.stack);
			}
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// StreamDeck
	// ---------------------------------------------------------------------------------------------- //
	_on_streamdeck_open(event) {
		{ // Event
			let ev = new Event("open", { "bubbles": true });
			ev.data = event;
			this.dispatchEvent(ev);
		}

		this.log("Ready to Work.");
	}

	_on_streamdeck_close(event) {
		{ // Event
			let ev = new Event("close", { "bubbles": true });
			ev.data = event;
			this.dispatchEvent(ev);
		}
	}

	_on_streamdeck_error(event) {
		{ // Event
			let ev = new Event("error", { "bubbles": true });
			ev.data = event;
			this.dispatchEvent(ev);
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// StreamDeck Events
	// ---------------------------------------------------------------------------------------------- //
	_applicationDidLaunch(event) {
		event.preventDefault();
		this.log("OBS Studio has launched, attempting to connect...");
		this.log(`${JSON.stringifyEx(event)}`);
		if (!this._obs.connected()) {
			this._obs.try_connect();
		}
	}

	_applicationDidTerminate(event) {
		event.preventDefault();
		if (!this._obs.connected()) {
			this._obs.cancel_try_connect();
		}
		//this._obs.disconnect();
		//this.log(`OBS Studio has quit, stopping any attempts at connecting...`);
	}

	_actionEvent(event) {
		event.preventDefault();
		try {
			let action = this._actions.get(event.action);
			if (action == undefined) {
				this.log(`Unknown action '${event.action}' received event '${event.event}' for context '${event.context}' on device '${event.device}'.`);
				return;
			}

			// Publish Event to Action.
			//!ToDo: Upgrade to 'new Event(event.type, event)'
			let ev = new Event(event.type, { "bubbles": true, "cancelable": config.debug });
			ev.data = event.data;
			ev.event = event.event;
			ev.device = event.device;
			ev.action = event.action;
			ev.context = event.context;
			if (action.dispatchEvent(ev) && config.debug) {
				this.log(`Action '${event.action}' did not handle event '${event.event}' for context '${event.context}' on device '${event.device}'.`);
			}
		} catch (ex) {
			this.log(`${event.event} Handler threw exception:` + ex.stack);
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// OBS Events we are interested in.
	// ---------------------------------------------------------------------------------------------- //
	_on_obs_open(event) {
		this.log("Connected with OBS Studio.");
		this._obs_was_connected = true;
	}

	_on_obs_error(event) {
		if (this._obs.connected) {
			this.log(`Unexpected error occured while communicating with OBS Studio: ${event.data.data}`);
		}
	}

	_on_obs_close(event) {
		if (this._obs_was_connected) {
			this.log("Disconnected from OBS Studio.");
			this._obs_was_connected = false;
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Our functionality.
	// ---------------------------------------------------------------------------------------------- //
	obs() {
		return this._obs;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Stream Deck
	// ---------------------------------------------------------------------------------------------- //
	get streamdeck() {
		return this._sd;
	}

	log(message) {
		this.streamdeck.log(message);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inApplicationInfo, inActionInfo) {
	try {
		instance = new plugin(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inApplicationInfo), JSON.parseEx(inActionInfo || "{}"));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
