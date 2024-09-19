// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Start / Stop Recording Action

Toggles the Recording feature.

State:
- Enabled if OBS is currently recording.
- Disabled if OBS is not recording.

State Progression:
- Pressed:
	1. Check if OBS is connected, otherwise become "Disabled", show error and then break.
	2. Get the action target state
	3. Make the request, right now or in 3s if long-press is enabled
- Request:
	1. Enable / Disable recording according to target state.
	2. If success, become "Enabled"/"Disabled" according to target state, otherwise become "Disabled", show error and then break.
- obs.frontend.source.event.recording:
	1. Refresh all record actions.
- Refresh:
	1. Check if OBS is connected, otherwise show error and then break.
	2. Retrieve current recording state.
	3. If success, become "Enabled"/"Disabled" according to state, otherwise become "Disabled", show error and then break.

States:
- EActionOn: OBS is connected, OBS is recording.
- EActionOff: OBS is disconnected or OBS is not recording.
*/

class RecordAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.record");

		this._timer = undefined;

		this._api = this.obs.frontend_recording;

		{ // Listeners
			// Stream Deck Events
			this.addEventListener("willAppear", (event) => {
				this._on_willAppear(event);
			});
			this.addEventListener("propertyInspectorDidAppear", (event) => {
				this._on_propertyInspectorDidAppear(event);
			});
			this.addEventListener("keyDown", (event) => {
				this._on_pressed(event);
			});
			this.addEventListener("keyUp", (event) => {
				this._on_released(event);
			});

			// RPC
			this.addEventListener("rpc.settings", (event) => {
				this._on_rpc_settings(event);
			});

			// OBS
			this.obs.addEventListener("open", (event) => {
				this._obs_on_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._obs_on_close(event);
			});

			// Recording
			this._api.addEventListener("status", (event) => {
				this._on_rec_status(event);
			});
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Refresh the status of a specific context, or all contexts if none specified.
	 *
	 * @param {any} context The context to refresh, or undefined if refreshing all contexts.
	 */
	refresh(context) {
		if (context !== undefined) {
			// Disable the item if OBS is not connected.
			if (!this.obs.connected()) {
				this.setState(context, EActionStateOff);
				return;
			}

			if (this._api.active) {
				this.setState(context, EActionStateOn);
			} else {
				this.setState(context, EActionStateOff);
			}
		} else {
			// Refresh all contexts.
			for (let ctx of this.contexts.keys()) {
				this.refresh(ctx);
			}
		}
	}

	async _request(context, targetState) {
		// Start or Stop the recording.
		let promise;
		if (targetState) {
			promise = this._api.start();
		} else {
			promise = this._api.stop();
		}
		let result = await promise;
		if (this._api.active != targetState) {
			if (config.status)
				this.streamdeck.showAlert(context);
		} else {
			if (config.status)
				this.streamdeck.showOk(context);
		}
	}

	_apply_settings(context, settings) {
		// 1. Save settings.
		this.settings(context, settings);

		// 2. Update any available inspectors.
		if (this.inspector) {
			this.notify(this.inspector, "settings", settings);
		}

		// 3. Refresh the action.
		this.refresh(context);
	}

	/** Refresh any open inspectors.
	 *
	 */
	_inspector_refresh() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		// Grab relevant information.
		let context = this.inspector;
		let settings = this.settings(context);

		this.call(context, "init_inspector", ()=>{
			// Inform about current settings.
			this.notify(this.inspector, "settings", settings);

			// Perform different tasks depending on if OBS is available or not.
			if (!this.obs.connected()) {
				this.notify(this.inspector, "close");
			} else {
				this.notify(this.inspector, "open");
			}
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //

	_on_willAppear(event) {
		event.preventDefault();

		let settings = this.settings(event.context);
		settings.isInMultiAction = event.data.payload.isInMultiAction;
		this._apply_settings(event.context, settings);

		for (let ctx of this._contexts.entries()) {
			this.refresh(ctx[0]);
		}
	}

	_on_propertyInspectorDidAppear(event) {
		event.preventDefault();

		// Update Inspector
		this._inspector_refresh();
	}

	async _on_pressed(ev) {
		ev.preventDefault();

		try {
			let settings = this.settings(ev.context);
			let desiredState = false;
			if (ev.data.payload.isInMultiAction == true) {
				desiredState = (ev.data.payload.userDesiredState === EActionStateOn);
			} else {
				desiredState = (ev.data.payload.state === EActionStateOff);
			}

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				// This also automatically reverts the state of the action.
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Handle Long Press setting
			if (settings.longpress === true) {
				this._timer = setTimeout(() => {
					this._request(ev.context, desiredState);
					this._timer = null;
				}, 3000);
			} else {
				this._request(ev.context, desiredState);
			}
		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	_on_released(ev) {
		ev.preventDefault();
		let settings = this.settings(ev.context);
		if ((settings.longpress === true) && (this._timer !== null)) {
			clearTimeout(this._timer);
			this._timer = null;
			this.streamdeck.showAlert(ev.context);
		}
	}

	_on_rpc_settings(event) {
		event.preventDefault();
		let settings = event.data.parameters();
		this._apply_settings(this.inspector, settings);
	}

	_obs_on_open(event) {
		event.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_obs_on_close(event) {
		event.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_on_rec_status(event) {
		event.preventDefault();
		this.refresh();
	}
}
