// Copyright 2021 Corsair GmbH

class TransitionAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.transition");

		// APIs
		this._api = this._obs.frontend_transition;

		{ // RPC
			this.addEventListener("rpc.settings", (event) => {
				this._on_rpc_settings(event);
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

			// API
			this._api.addEventListener("transition", (event) => {
				this._on_transition(event);
			});
			this._api.addEventListener("transitions", (event) => {
				this._on_transitions(event);
			});
			this._api.addEventListener("renamed", (event) => {
				this._on_transition_renamed(event);
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

			const fixed = this._api.transitions.get(settings.transition);
			const duration = settings.duration <= 0 || fixed ? 0 : settings.duration;
			let on = this._api.transition === settings.transition;

			if (duration > 0) {
				on = on && this._api.transition_duration === settings.duration;
			}

			this.setTitle(context, 0, settings.transition);
			this.setTitle(context, 1, settings.transition);

			if (on) {
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
		// Can't do anything if OBS Studio is not connected.
		if (!this.obs.connected()) return;

		if ((typeof settings.transition) !== "string") {
			settings.transition = undefined;
		}

		// 50 is OBS's minimum transition duration
		if ((typeof settings.duration) !== "number" || settings.duration < 50) {
			settings.duration = 0;
		}
		/*
				if ((typeof settings.fixed) !== "boolean") {
					settings.fixed = false;
				}*/
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
				// We've restored connection to OBS Studio.
				this.notify(this.inspector, "open");
				this._inspector_refresh_transitions();
			} else {
				// OBS Studio is currently not available.
				this.notify(this.inspector, "close");
			}
		});
	}

	_inspector_refresh_transitions() {
		if (!this.inspector) return;

		this.notify(this.inspector, "transitions", {
			"list": Array.from(this._api.transitions)
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

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			const fixed = this._api.transitions.get(settings.transition);
			const try_duration = settings.duration <= 0 || fixed ? undefined : settings.duration;

			let res = await this._api.active_transition(settings.transition,
				try_duration);

			let success = res && res.transition === settings.transition;

			if (try_duration && try_duration > 0) {
				success = success && res.duration === settings.duration;
			}

			if (!success) {
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

	_on_transition(ev) {
		ev.preventDefault();
		this.refresh();
	}

	_on_transitions(ev) {
		ev.preventDefault();
		this._inspector_refresh_transitions();
	}

	_on_transition_renamed(ev) {
		ev.preventDefault();

		for (let ctx of this.contexts.keys()) {
			let settings = this.settings(ctx);
			if (settings.transition == ev.data.from){
				settings.transition = ev.data.to;
				this.settings(ctx, settings);
			}
			this.refresh(ctx);
			if (ctx == this.inspector){
				this._inspector_refresh();
			}
		}
	}

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}
}
