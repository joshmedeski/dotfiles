// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Pause / Unpause Recording Action

Toggles the Pause Recording feature.

State:
- Enabled if Recording is not on pause.
- Disabled if Recording is on pause.

State Progression:
- Pressed:
	1. Get the action target state
	2. Check if OBS is connected, otherwise become "Disabled", show error and then break.
	3. Check if Recording is active, otherwise become "Disabled", show error and then break.
	4. Pause / Unpause recording according to target state.
	5. If success, become "Enabled"/"Disabled" according to target state, otherwise become "Disabled", show error and then break.
- obs.frontend.source.event.recording:
	1. Refresh all record actions.
- Refresh:
	1. Check if OBS is connected, otherwise show error and then break.
	2. Check if Recording is active, otherwise become "Disabled" and then break.
	3. Retrieve current pause recording state.
	4. If success, become "Enabled"/"Disabled" according to state, otherwise become "Disabled", show error and then break.

States:
- EActionOn: OBS is connected, OBS is recording, Recording is not on pause.
- EActionOff: OBS is disconnected or OBS is not recording or Recording is on pause.
*/

class RecordPauseAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.record.pause");

		this._api = this.obs.frontend_recording;

		{ // Listeners
			// Stream Deck
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

			// Check if the recording is active
			if (!this._api.active) {
				this.setState(context, EActionStateOff);
				return;
			}

			// Update pause recording state
			if (this._api.paused) {
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

	/** Refresh any open inspectors.
	 *
	 */
	_inspector_refresh() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		const context = this.inspector;

		this.call(context, "init_inspector", ()=>{
			if (!this.obs.connected()) {
				this.notify(this.inspector, "close");
			} else {
				this.notify(this.inspector, "open");

				// Check if OBS is recording.
				this.notify(this.inspector, "recording", {
					"active": this._api.active
				});
			}
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_willAppear(ev) {
		ev.preventDefault();
		this.refresh(ev.context);
	}

	_on_propertyInspectorDidAppear(ev) {
		ev.preventDefault();
		this._inspector_refresh();
	}

	async _on_pressed(ev) {
		ev.preventDefault();

		try {
			let desiredState = false;
			if (ev.data.payload.isInMultiAction == true) {
				desiredState = (ev.data.payload.userDesiredState === EActionStateOn);
			} else {
				desiredState = (ev.data.payload.state === EActionStateOff);
			}

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if recording is currently inactive.
			if (!this._api.active) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Pause or Unpause the recording.
			let promise;
			if (desiredState) {
				promise = this._api.pause();
			} else {
				promise = this._api.unpause();
			}
			let result = await promise;
			if (this._api.paused != desiredState) {
				this.streamdeck.showAlert(ev.context);
			} else {
				if (config.status)
					this.streamdeck.showOk(ev.context);
			}
		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	_on_released(ev) {
		ev.preventDefault();
	}

	_obs_on_open(ev) {
		ev.preventDefault();

		// Refresh all buttons
		for (let ctx of this._contexts.entries()) {
			this.refresh(ctx[0]);
		}

		// Update Inspector
		this._inspector_refresh();
	}

	_obs_on_close(ev) {
		ev.preventDefault();

		// Refresh all buttons
		for (let ctx of this._contexts.entries()) {
			this.refresh(ctx[0]);
		}

		// Update Inspector
		this._inspector_refresh();
	}

	_on_rec_status(ev) {
		ev.preventDefault();
		this.refresh();
	}
}
