// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Start / Stop Streaming Action

Toggles the Streaming feature.

State:
- Enabled if OBS is currently streaming.
- Disabled if OBS is not streaming.

State Progression:
- Pressed:
	1. Check if OBS is connected, otherwise become "Disabled", show error and then break.
	2. Get the action target state
	3. Make the request, right now or in 3s if long-press is enabled
- Request:
	1. Enable / Disable recording according to target state.
	2. If success, become "Enabled"/"Disabled" according to target state, otherwise become "Disabled", show error and then break.
- obs.frontend.source.event.streaming:
	1. Refresh all streaming actions.
- Refresh:
	1. Check if OBS is connected, otherwise show error and then break.
	2. Retrieve current streaming state.
	3. If success, become "Enabled"/"Disabled" according to state, otherwise become "Disabled", show error and then break.

States:
- EActionOn: OBS is connected, OBS is streaming.
- EActionOff: OBS is disconnected or OBS is not streaming.
*/

class StreamAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.stream");

		this._timer = null;
		this._api = this.obs.frontend_streaming;

		{ // RPC
			this.addEventListener("rpc.settings", (event) => {
				this._on_rpc_settings(event);
			});
		}

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

			// OBS
			this.obs.addEventListener("open", (event) => {
				this._obs_on_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._obs_on_close(event);
			});

			// Streaming
			this._api.addEventListener("status", (event) => {
				this._on_stream_status(event);
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

			if (this._api.active || this._api.starting) {
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
		// Start or Stop the stream.
		let promise;
		if (targetState) {
			promise = this._api.start();
		} else {
			promise = this._api.stop();
		}
		let result = await promise;
		if (this._api.active == targetState) {
			if (config.status)
				this.streamdeck.showOk(context);
		}
	}

	/** Apply and store settings to a context.
	 *
	 */
	_apply_settings(context, settings) {
		// 1. Try to migrate any old settings to the new layout.
		this._migrate_settings(settings);

		// 2. Apply default settings to any missing entries.
		this._default_settings(settings);

		// 3. Store the settings to Stream deck.
		this.settings(context, settings);

		// 4. Refresh the context.
		this.refresh(context);

		// 5. Update the open inspector if it is for this action.
		if (this.inspector == context) {
			this.notify(this.inspector, "settings", settings);
		}
	}

	/** Migrate settings from older versions to newer versions.
	 *
	 */
	_migrate_settings(settings) {
		// No settings to migrate
	}

	/** Apply any default settings that may be necessary.
	 *
	 */
	_default_settings(settings) {
		// Not in a multi-action by default.
		if (settings.isInMultiAction === undefined) {
			settings.isInMultiAction = false;
		}

		// By default, disable long press interaction.
		if (settings.longpress === undefined) {
			settings.longpress = false;
		}
	}

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

	_on_willAppear(ev) {
		ev.preventDefault();

		let settings = this.settings(ev.context);
		settings.isInMultiAction = ev.data.payload.isInMultiAction;
		this._apply_settings(ev.context, settings);

		this.refresh();
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

			// Handle Long Press setting
			if ((ev.data.payload.isInMultiAction !== true) && (settings.longpress === true)) {
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

	async _on_released(ev) {
		ev.preventDefault();
		if (this._timer !== null) {
			clearTimeout(this._timer);
			this._timer = null;
			this.streamdeck.showAlert(ev.context);
		}
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

	_on_stream_status(event) {
		event.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_on_rpc_settings(event) {
		event.preventDefault();
		this._apply_settings(this.inspector, event.data.parameters());
	}
}
