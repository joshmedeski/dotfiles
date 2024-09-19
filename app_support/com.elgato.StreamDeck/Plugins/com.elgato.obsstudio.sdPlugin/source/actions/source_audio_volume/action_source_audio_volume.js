// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SourceAudioVolumeAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.mixeraudio.volume");

		// APIs
		this._api_source = this.obs.source_api;

		this._refresh_debouncer = new debouncer(20, 50);

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
			this.addEventListener("touchTap", (event) => {
				this._on_touch_tap(event);
			});
			this.addEventListener("dialPress", (event) => {
				this._on_dial_press(event);
			});
			this.addEventListener("dialRotate", (event) => {
				this._on_dial_rotate(event);
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
				return;
			}

			// Check if the source exists.
			let source = this._api_source.sources.get(settings.source);
			if (source === undefined) {
				return;
			}

			// Generate the update for the touch display.
			let feedback = {};

			// - Title
			feedback.title = source.name;

			// - Icon
			if (source.audio_state.muted) {
				feedback.icon = "./resources/actions/source.audio.volume/off.svg";
			} else {
				feedback.icon = "./resources/actions/source.audio.volume/on.svg";
			}

			// - Indicator
			{
				let db = Math.round(toDBFS(source.audio_state.volume) * 10) / 10;
				if ((db == Number.NEGATIVE_INFINITY) || (db <= OBS_AUDIO_VOLUME_DB_MIN)) {
					feedback.indicator = 0;
					feedback.value = `-Inf dB`;
				} else {
					feedback.indicator = (DBFSToPercent(db) * 100).toFixed(0);
					feedback.value = `${db.toFixed(1)} dB`;
				}
			}

			this.setTitle(context, 0, source.name);
			this.setTitle(context, 1, source.name);


			// Send update.
			this.setFeedback(context, feedback);
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
		}
	}

	/** Migrate settings from older versions to newer versions.
	 *
	 */
	_migrate_settings(settings) {
	}

	/** Apply any default settings that may be necessary.
	 *
	 */
	_default_settings(settings) {
		if ((typeof (settings.step) !== "number") || (settings.step === undefined)) {
			settings.step = 1.0;
		}

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
				// We've restored connection to OBS Studio.
				this.notify(this.inspector, "open");

				// Inform about currently available scenes.
				this._inspector_refresh_sources();
			} else {
				// OBS Studio is currently not available.
				this.notify(this.inspector, "close");
			}
		});
	}

	_inspector_refresh_sources() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		// Prevent mangling of Source ordering by JSON.stringifyEx.
		let names = [];
		for (let source of this._api_source.sources) {
			// Skip over all sources which do not have any audio output.
			if (source[1].output_flags.get("audio") !== true)
				continue;

			names.push(source[0]);
		}
		names.sort((a, b) => a.localeCompare(b, undefined, { numeric: true, sensitivity: "base" }));

		this.notify(this.inspector, "sources", {
			"list": names
		});
	}

	async toggleMute(context) {
		let settings = this.settings(context);

		// Abort if not connected to OBS Studio.
		if (!this.obs.connected()) {
			this.streamdeck.showAlert(context);
			return;
		}

		// Show an alert if the source no longer exists.
		let source = this._api_source.sources.get(settings.source);
		if (source === undefined) {
			this.streamdeck.showAlert(context);
			return;
		}

		// If everything went well, try and update the muted state.
		await source.set_audio_muted(!source.audio_state.muted);
	}

	async adjustVolume(context, multiplier) {
		let settings = this.settings(context);

		// Abort if not connected to OBS Studio.
		if (!this.obs.connected()) {
			this.streamdeck.showAlert(context);
			return;
		}

		// Show an alert if the source no longer exists.
		let source = this._api_source.sources.get(settings.source);
		if (source === undefined) {
			this.streamdeck.showAlert(context);
			return;
		}

		await source.adjust_audio_volume(settings.step * multiplier, "dB");
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

	_on_obs_source_event_rename(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();

		if (Array.isArray(args.source)) {
			return;
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

	_on_obs_source_event_state(ev) {
		ev.preventDefault();
		this.refresh();
	}

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}

	async _on_pressed(ev) {
		ev.preventDefault();
		await this.toggleMute(ev.context);
	}

	async _on_released(ev) {
		ev.preventDefault();
	}

	async _on_touch_tap(ev) {
		ev.preventDefault();
		await this.toggleMute(ev.context);
	}

	async _on_dial_press(ev) {
		ev.preventDefault();
		if (!ev.data.payload.pressed) {
			return;
		}
		await this.toggleMute(ev.context);
	}

	async _on_dial_rotate(ev) {
		ev.preventDefault();
		await this.adjustVolume(ev.context, ev.data.payload.ticks);
	}
}
