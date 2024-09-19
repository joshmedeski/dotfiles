// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Enable / Disable Studio Mode Action

Toggles the Studio Mode feature.

State:
- Enabled if the studio mode is enabled.
- Disabled if the studio mode is disabled.

State Progression:
- Pressed:
	1. Get the action target state
	2. Check if OBS is connected, otherwise become "Disabled", show error and then break.
	3. Enable / Disable studio mode according to target state.
	4. If success, become "Enabled"/"Disabled" according to target state, otherwise become "Disabled", show error and then break.
- obs.frontend.source.event.studiomode:
	1. Refresh all studio mode actions.
- Refresh:
	1. Check if OBS is connected, otherwise show error and then break.
	2. Retrieve current studio mode state.
	3. If success, become "Enabled"/"Disabled" according to state, otherwise become "Disabled", show error and then break.

States:
- EActionOn: OBS is connected, Studio Mode is enabled.
- EActionOff: OBS is disconnected or Studio Mode is disabled.
*/

class StudioModeAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.studiomode");

		this._api = this.obs.frontend_studiomode;

		{ // Stream Deck Events
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
		}

		{ // OBS Studio Events
			this.obs.addEventListener("open", (event) => {
				this._on_obs_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._on_obs_close(event);
			});
		}

		{ // OBS Front-End Events
			this._api.addEventListener("status", (event) => {
				this._on_sm_status(event);
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

			if (this._api.enabled) {
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

			// Enable/Disable Studio Mode
			let promise;
			if (desiredState) {
				promise = this._api.enable();
			} else {
				promise = this._api.disable();
			}
			let result = await promise;
			if (this._api.enabled != desiredState) {
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

	async _on_released(ev) {
		ev.preventDefault();
		this.refresh(ev.context);
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

	_on_sm_status(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}
}
