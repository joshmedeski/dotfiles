// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Start / Stop Replay Buffer Action

Toggles the Replay Buffer feature.

State:
- Enabled if the replay buffer is running.
- Disabled if the replay buffer is inactive.

State Progression:
- Pressed:
	1. Get the action target state
	2. Check if OBS is connected, otherwise become "Disabled", show error and then break.
	3. Enable / Disable replay buffer according to target state.
	4. If success, become "Enabled"/"Disabled" according to target state, otherwise become "Disabled", show error and then break.
- obs.frontend.source.event.replaybuffer:
	1. Refresh all replay buffer actions.
- Refresh:
	1. Check if OBS is connected, otherwise show error and then break.
	2. Retrieve current replay buffer state.
	3. If success, become "Enabled"/"Disabled" according to state, otherwise become "Disabled", show error and then break.

States:
- EActionOn: OBS is connected, Replay Buffer is running.
- EActionOff: OBS is disconnected or Replay Buffer is inactive.
*/

class ReplayBufferAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.replaybuffer");

		// APIs
		this._api = this.obs.frontend_replaybuffer;

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
				this._on_obs_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._on_obs_close(event);
			});

			// Replay Buffer
			this._api.addEventListener("status", (event) => {
				this._on_rb_status(event);
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

	_inspector_refresh() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		const context = this.inspector;

		this.call(context, "init_inspector", ()=>{
			if (!this.obs.connected()) {
				this.notify(this.inspector, "close");
			} else {
				this.notify(this.inspector, "open");

				// Check if the Replay Buffer is enabled.
				this._api.enabled().then((result) => {
					this.notify(this.inspector, "replaybuffer", {
						"enabled": result
					});
				}, (error) => {
					this.notify(this.inspector, "replaybuffer", {
						"enabled": false
					});
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
			let settings = this.settings(ev.context);
			let desiredState = false;
			if (ev.data.payload.isInMultiAction === true) {
				desiredState = (ev.data.payload.userDesiredState === EActionStateOn);
			} else {
				desiredState = (ev.data.payload.state === EActionStateOff);
			}

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Start/Stop the Replay Buffer
			let promise;
			if (desiredState) {
				promise = this._api.start();
			} else {
				promise = this._api.stop();
			}
			let result = await promise;
			if (this._api.active != desiredState) {
				if (config.status) // TODO: Always shown.
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
		//this.refresh(ev.context);
	}

	_on_obs_open(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_on_obs_close(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_on_rb_status(ev) {
		ev.preventDefault();
		this.refresh();
	}
}
