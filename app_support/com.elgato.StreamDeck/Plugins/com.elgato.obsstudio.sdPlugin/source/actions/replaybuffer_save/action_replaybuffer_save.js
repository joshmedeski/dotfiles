// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Save Replay Buffer Action

Save the recorded Replay Buffer.

State Progression:
- Pressed:
	1. Check if OBS is connected, otherwise show error and then break.
	2. Check if replay buffer is active, otherwise show error and then break.
	3. Save replay buffer.
	4. If success, show ok, otherwise show error and then break.
*/

class ReplayBufferSaveAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.replaybuffer.save");

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
				this._obs_on_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._obs_on_close(event);
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
						"enabled": result,
						"active": this._api.active
					});
				}, (error) => {
					this.notify(this.inspector, "replaybuffer", {
						"enabled": false,
						"active": false
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
		this.refresh();
	}

	_on_propertyInspectorDidAppear(ev) {
		ev.preventDefault();

		// Update Inspector
		this._inspector_refresh();
	}

	async _on_pressed(ev) {
		ev.preventDefault();

		try {
			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if Replay Buffer is inactive.
			if (!this._api.active) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Save Replay Buffer
			let result = await this._api.save();
			if (result !== true) {
				this.streamdeck.showAlert(ev.context);
			} else {
				this.streamdeck.showOk(ev.context);
			}
		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	async _on_released(ev) {
		ev.preventDefault();
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

	_on_rb_status(ev) {
		ev.preventDefault();
		this._inspector_refresh();
		this.refresh();
	}
}
