// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Filter Visibility Action

Toggles the enabled state of a filter.

State:
- Enabled/On if the configured source is unmuted.
- Disabled/Off if the configured source is muted.

State Progression:
- Pressed:
	1. If we are not connected to OBS, show error.
	2. If the source is muted, unmute and turn button "On".
	3. In all other cases, mute the source and turn button "Off".
- obs.source.event.mute:
	1. If the source is muted, turn button "Off".
	2. If the source is unmuted, turn button "On".
- Refresh:
	1. If OBS is not connected, turn button "Off".
	2. If the source does not exist, turn button "Off".
	3. If the source is muted, turn button "Off".
	4. If the source is unmuted, turn button "On".

States:
- EActionOn: OBS is connected, Source exists, and Source is unmuted.
- EActionOff: OBS is disconnected, Source doesn't exist, or Source is unmuted.
*/

class FilterStateAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.filter.state");

		// APIs
		this._api_source = this.obs.source_api;

		this._refresh_debouncer = new debouncer(50);

		{ // RPC
			this.addEventListener("rpc.settings", (event) => {
				this._on_rpc_settings(event);
			});
			this.addEventListener("rpc.source.filters", (event) => {
				this._on_rpc_source(event);
			});
		}

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
			this.obs.addEventListener("obs.source.event.rename", (event) => {
				this._on_obs_source_event_rename(event);
			});
			this.obs.addEventListener("obs.source.event.state", (event) => {
				this._on_obs_source_event_state(event);
			});

			// Source API
			this._api_source.addEventListener("sources", (event) => {
				this._on_sources_changed(event);
			});
			this._api_source.addEventListener("filters", (event) => {
				this._on_filters_changed(event);
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
			let settings = this.settings(context);

			// Disable the item if OBS is not connected.
			if (!this.obs.connected()) {
				this.setState(context, EActionStateOff);
				return;
			}

			// Check if the source exists.
			let source = this._api_source.sources.get(settings.source);
			if (source === undefined) {
				this.setState(context, EActionStateOff);
				return;
			}

			// Check if the filter exists.
			let filter = source.filters.get(settings.filter);
			if (filter === undefined) {
				this.setState(context, EActionStateOff);
				return;
			}


			this.setTitle(context, 0, filter.name);
			this.setTitle(context, 1, filter.name);


			// Update context according to current status.
			this.setState(context, filter.enabled ? EActionStateOn : EActionStateOff);
		} else {
			// Refresh all contexts.
			this._refresh_debouncer.call(()=>{
				for (let ctx of this.contexts.keys()) {
					this.refresh(ctx);
				}
			})
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
			this._inspector_refresh();
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
		// Can't do anything if OBS Studio is not connected.
		if (!this.obs.connected()) return;

		if ((settings.source === undefined) || (typeof (settings.source) !== "string")) {
			settings.source = undefined;
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
			if (this.obs.connected()) {
				this.notify(this.inspector, "open");
				this._inspector_refresh_sources();
			} else {
				// OBS Studio is currently not available.
				this.notify(this.inspector, "close");
			}
		});
	}

	_inspector_refresh_sources() {
		if (!this.inspector) return;

		// Generate a list of sources which has filters.
		let sources = new Map();
		for (let source of this._api_source.sources) {
			if (source[1].filters.size == 0)
				continue;

			sources.set(source[0], Array.from(source[1].filters.keys()));
		}

		this.notify(this.inspector, "sources", {
			"list": Array.from(sources.entries())
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //

	_on_willAppear(ev) {
		ev.preventDefault();
		let settings = this.settings(ev.context);
		this._apply_settings(ev.context, settings);
	}

	_on_propertyInspectorDidAppear(ev) {
		ev.preventDefault();
		this._inspector_refresh();
	}

	async _on_pressed(ev) {
		ev.preventDefault();

		try {
			let settings = this.settings(ev.context);

			// What state does the user want the button to be in?
			let desiredState = false;
			if (ev.data.payload.isInMultiAction == true) {
				desiredState = (ev.data.payload.userDesiredState == EActionStateOff) ? false : true;
			} else {
				desiredState = (ev.data.payload.state == EActionStateOn) ? false : true;
			}

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				// This also automatically reverts the state of the action.
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if the source no longer exists.
			let source = this._api_source.sources.get(settings.source);
			if (source === undefined) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if the filter no longer exists.
			let filter = source.filters.get(settings.filter);
			if (filter === undefined) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// If everything went well, try and update the visible state.
			let result = await filter.set_enabled(desiredState);
			if (filter.enabled != desiredState) {
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

	_on_sources_changed(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh_sources();
	}

	_on_filters_changed(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh_sources();
	}

	_on_obs_source_event_state(ev) {
		ev.preventDefault();
		this.refresh();
	}

	_on_obs_source_event_rename(ev) {
		let args = ev.data.parameters();

		if (Array.isArray(args.source)) {
			for (let context of this.contexts.keys()) {
				let settings = this.settings(context);
				if (settings.filter == args.from) {
					settings.filter = args.to;
					this._apply_settings(context, settings);
					this.refresh(context);
				}
			}

		} else {
			for (let context of this.contexts.keys()) {
				let settings = this.settings(context);
				if (settings.source == args.from) {
					settings.source = args.to;
					this._apply_settings(context, settings);
					this.refresh(context);
				}
			}
			this._inspector_refresh_sources();

		}
	}

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}
}
