// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SourceAudioMuteAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.mixeraudio");

		// APIs
		this._api_source = this.obs.source_api;

		// Track which contexts have which icon to avoid redundant setImage traffic
		this._icon_refs = new Map();

		this._refresh_debouncer = new debouncer(50, 150);

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
			this.addEventListener("keyHeld", (event) => {
				this._on_held(event);
			});

			// OBS
			this.obs.addEventListener("open", (event) => {
				this._on_obs_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._on_obs_close(event);
			});
			this.obs.addEventListener("obs.source.event.state", (event) => {
				this._on_obs_source_event_state(event);
			});
			this.obs.addEventListener("obs.source.event.rename", (event) => {
				this._on_obs_source_event_rename(event);
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

			let abort = ()=>{
				if (this.status(context).isInMultiAction !== true) {
					this.setImage(context, 0, "");
					this.setImage(context, 1, "");
				}
				this.setState(context, EActionStateOff);
			}

			// Disable the item if OBS is not connected.
			if (!this.obs.connected()) {
				abort();
				return;
			}

			// Check if the source exists.
			let source = this._api_source.sources.get(settings.source);
			if (source === undefined) {
				abort()
				return;
			}

			if (this.status(context).isInMultiAction !== true) {
				const disableTitle = this._refresh_icon(context, settings, source);

				let title = source.name;
				if(disableTitle){
					title = "";
				}
				this.setTitle(context, 0, title);
				this.setTitle(context, 1, title);
			}

			// Update context according to current mute status.
			this.setState(context, source.audio_state.muted ? EActionStateOff : EActionStateOn);
		} else {
			// Refresh all contexts.
			this._refresh_debouncer.call(()=>{
				for (let ctx of this.contexts.keys()) {
					this.refresh(ctx);
				}
			})
		}
	}

	_refresh_icon(context, settings, source) {
		let iconRef = "mute";

		// Wrapped in a function to avoid building / copying an SVG unnecessarily
		let setIcons = ()=>{
			this.setImage(context, 0, "resources/actions/com.elgato.obsstudio.mixeraudio/on.png");
			this.setImage(context, 1, "resources/actions/com.elgato.obsstudio.mixeraudio/off.png");
		}

		let disableTitle = false;
		switch(settings.type){
			case "set":
				iconRef = "set";
				setIcons = ()=>{
					this.setImage(context, 0, "resources/actions/com.elgato.obsstudio.mixeraudio/set/on.png");
					this.setImage(context, 1, "resources/actions/com.elgato.obsstudio.mixeraudio/set/off.png");
				}
				break;
			case "adjust":
				{
					let db = Math.round(toDBFS(source.audio_state.volume) * 10) / 10;
					const percentage = (100 - DBFSToPercent(db) * 100).toFixed(0);


					let orientation = 0;
					switch (settings.style) {
						case "static":
							break;
						case "sliderVertical":
							orientation = 1;
							break;
						case "sliderHorizontal":
							orientation = 2;
							break;
					}
					const isTop = settings.step >= 0;
					if( orientation != 0){
						setIcons = ()=>{
							this.setImage(context, 0, this.getSVG({orientation, value: percentage, isTop, bgColor: "#5e8b8b"}).encodeSVG());
							this.setImage(context, 1, this.getSVG({orientation, value: percentage, isTop, bgColor: "#263838"}).encodeSVG());
						}
						disableTitle = isTop;
						iconRef = `adjust:${orientation}:${percentage}:${isTop}`;
					} else {
						// Static icon
						iconRef = `adjust_static:${isTop}`;
						if (isTop){
							setIcons = ()=>{
								this.setImage(context, 0, "resources/actions/com.elgato.obsstudio.mixeraudio/adjust_up/on.png");
								this.setImage(context, 1, "resources/actions/com.elgato.obsstudio.mixeraudio/adjust_up/off.png");
							}
						} else {
							setIcons = ()=>{
								this.setImage(context, 0, "resources/actions/com.elgato.obsstudio.mixeraudio/adjust_down/on.png");
								this.setImage(context, 1, "resources/actions/com.elgato.obsstudio.mixeraudio/adjust_down/off.png");
							}
						}
					}
				}
				break;
			case "mute":
				default:
				switch (settings.mode) {
					case "mute":
						setIcons = ()=>{
							this.setImage(context, 0, "resources/actions/com.elgato.obsstudio.mixeraudio/push_mute/on.png");
							this.setImage(context, 1, "resources/actions/com.elgato.obsstudio.mixeraudio/push_mute/off.png");
						}
						iconRef = "ptm";
						break;
					case "talk":
						setIcons = ()=>{
							this.setImage(context, 0, "resources/actions/com.elgato.obsstudio.mixeraudio/push_talk/on.png");
							this.setImage(context, 1, "resources/actions/com.elgato.obsstudio.mixeraudio/push_talk/off.png");
						}
						iconRef = "ptt";
						break;
					case "toggle":
					default:
						iconRef = "mute";
						break;
				}
				break;
		}

		if( this._icon_refs.get(context) != iconRef){
			this._icon_refs.set(context, iconRef);
			setIcons();
		}

		return disableTitle;
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
		// Migrate required information over to the new settings.

		let collection = "";
		if (typeof (settings.sceneCollection) !== "undefined") {
			collection = String(settings.sceneCollection);
			delete settings.sceneCollection;
		}

		if (typeof (settings.sceneId) !== "undefined") {
			delete settings.sceneId;
		}

		if (typeof (settings.sceneItemId) !== "undefined") {
			delete settings.sceneItemId;
		}

		if (typeof (settings.sourceId) !== "undefined") {
			settings.source = String(settings.sourceId);
			delete settings.sourceId;
			if (settings.source == "") {
				delete settings.source;
			}

			// Strip collection name from scene.
			if (settings.source.startsWith(collection)) {
				settings.source = settings.source.substring(collection.length);
			}
		}
	}

	/** Apply any default settings that may be necessary.
	 *
	 */
	_default_settings(settings) {
		// Can't do anything if OBS Studio is not connected.
		if (!this.obs.connected()) return;

		switch (settings.type) {
			case "set":
			case "adjust":
			case "mute":
			case "monitor":
				break;
			default:
				settings.type = "mute";
		}

		if ((settings.source === undefined) || (typeof (settings.source) !== "string")) {
			settings.source = undefined;
		}

		switch (settings.style) {
			case "static":
			case "sliderVertical":
			case "sliderHorizontal":
				break;
			default:
				settings.style = "static";
		}

		if (typeof (settings.step) !== "number") {
			settings.step = parseFloat(settings.step);
		}
		if (isNaN(settings.step) || !isFinite(settings.step)) {
			settings.step = 1.0;
		}

		if (typeof (settings.volume) !== "number") {
			settings.volume = parseFloat(settings.volume);
		}
		if (isNaN(settings.volume) || !isFinite(settings.volume)) {
			settings.volume = 0.5;
		}

		switch (settings.mode) {
			case "toggle":
			case "mute":
			case "talk":
			case "setmute":
			case "setunmute":
				break;
			default:
				settings.mode = "toggle";
		}
	}

	_inspector_refresh() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		// Grab relevant information.
		let context = this.inspector;
		let settings = this.settings(context);

		this.call(context, "init_inspector", () => {
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

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //

	_on_willAppear(ev) {
		ev.preventDefault();
		this._icon_refs.delete(ev.context);
		let settings = this.settings(ev.context);
		settings.isInMultiAction = ev.data.payload.isInMultiAction;
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

			switch (settings.getProperty("type")) {
				case "set":
					this._actionTypeSet(true, ev, settings, source);
					break;
				case "adjust":
					this._actionTypeAdjust(true, ev, settings, source);
					break;
				case "mute":
					this._actionTypeMute(true, ev, settings, source);
					break;
			}
		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	async _on_held(ev) {
		ev.preventDefault();
		try {
			let settings = this.settings(ev.context);
			if (settings.getProperty("type") != "adjust"){
				return;
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

			this._actionTypeAdjust(true, ev, settings, source);

		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	async _on_released(ev) {
		ev.preventDefault();
		try {
			let settings = this.settings(ev.context);

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

			switch (settings.getProperty("type")) {
				case "set":
					this._actionTypeSet(false, ev, settings, source);
					break;
				case "adjust":
					this._actionTypeAdjust(false, ev, settings, source);
					break;
				case "mute":
					this._actionTypeMute(false, ev, settings, source);
					break;
			}
		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	async _actionTypeSet(pushed, ev, settings, source) {
		if (pushed) {
			let value = settings.getProperty("volume", .8);
			value = fromDBFS(percentToDBFS(value));
			let result = await source.set_audio_volume(value);
			if (config.status)
				this.streamdeck.showOk(ev.context);
		}
	}

	async _actionTypeAdjust(pushed, ev, settings, source) {
		if (pushed) {
			let value = settings.getProperty("step", 0.0);
			// We're pretending zero doesn't exist
			if (value >= 0){
				value++;
			}
			let result = await source.adjust_audio_volume(value, "dB");
			if (config.status)
				this.streamdeck.showOk(ev.context);
		}
	}

	async _actionTypeMute(pushed, ev, settings, source) {
		switch (settings.mode) {
			case "toggle":
				return this._actionTypeMuteModeToggle(pushed, ev, settings, source);
			case "mute":
				return this._actionTypeMuteModePushToMute(pushed, ev, settings, source);
			case "talk":
				return this._actionTypeMuteModePushToTalk(pushed, ev, settings, source);
			case "setmute":
				return this._actionTypeMuteModeSet(pushed, ev, settings, source);
			case "setunmute":
				return this._actionTypeMuteModeSet(pushed, ev, settings, source);
		}
	}

	async _actionTypeMuteModeToggle(pushed, ev, settings, source) {
		if (pushed) {
			// What state does the user want the button to be in?
			let desiredState = false;
			desiredState = (ev.data.payload.state === EActionStateOn);

			// If everything went well, try and update the muted state.
			let result = await source.set_audio_muted(desiredState);
			if (source.audio_state.muted != desiredState) {
				this.streamdeck.showAlert(ev.context);
			} else {
				if (config.status)
					this.streamdeck.showOk(ev.context);
			}
		}
	}

	async _actionTypeMuteModeSet(pushed, ev, settings, source) {
		if (pushed) {
			await source.set_audio_muted(settings.mode == "setmute");
			if (config.status)
				this.streamdeck.showOk(ev.context);
		}
	}

	async _actionTypeMuteModePushToMute(pushed, ev, settings, source) {
		if (pushed) {
			await source.set_audio_muted(true);
			if (config.status)
				this.streamdeck.showOk(ev.context);
		} else {
			await source.set_audio_muted(false);
			if (config.status)
				this.streamdeck.showOk(ev.context);
		}
	}

	async _actionTypeMuteModePushToTalk(pushed, ev, settings, source) {
		if (pushed) {
			await source.set_audio_muted(false);
			if (config.status)
				this.streamdeck.showOk(ev.context);
		} else {
			await source.set_audio_muted(true);
			if (config.status)
				this.streamdeck.showOk(ev.context);
		}
	}

	_on_obs_open(ev) {
		ev.preventDefault();
		this._icon_refs.clear();
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

	_on_obs_source_event_state(ev) {
		ev.preventDefault();
		this.refresh();
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

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}


	/** Returns the image to use for faders
	 * @param {object} options
	 * @param {int} options.orientation 1 for vertical, 2 for horizontal
	 * @param {float} options.value The value of the slider, from 0 to 100
	 * @param {bool} options.isTop True if this is the high end of the slider
	 * @param {string} options.bgColor The color of the background
	 * @returns {string} The final SVG image
	 */
	getSVG(options) {
		// Borrowed almost verbatim from the Wave Link plugin
        if (!options && options.orientation == 0)
            return;

        const height = options.value / 100;

        const horizontal = `<g transform="rotate(90 144 144) ${options.isTop ? 'translate(0,144)' : ''}">`;
        const vertical = `<g id="slider" transform="${options.isTop ? 'translate(0)' : 'translate(0,-144)'}">`
        const sliderBody = options.orientation == 1 ? vertical : options.orientation == 2 ? horizontal : '';

        if (sliderBody == '')
            return;

        const faderWidth = 232;
        const radius = 8;
        const innerLow = 28;  // note: element #bar needs a 1px offset to avoid a 'blip' when drawing the fill inside of the fader
        const thumbWidth = innerLow + radius*2;
        const h = height * (faderWidth + innerLow - radius*2);
        // <text fill="white" text-anchor="middle" x="20" y="20">${height}</text>

        // Background:

        const slider = `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="144" height="144" viewBox="0 0 144 144">
                            <defs>
                                <path id="path-3" d="M14,0 C21.7319865,0 28,6.2680135 28,14 L28,230 C28,237.731986 21.7319865,244 14,244 C6.2680135,244 0,237.731986 0,230 L0,14 C0,6.2680135 6.2680135,0 14,0 Z M14,6 C11.790861,6 9.790861,6.8954305 8.34314575,8.34314575 C6.8954305,9.790861 6,11.790861 6,14 L6,230 C6,232.209139 6.8954305,234.209139 8.34314575,235.656854 C9.790861,237.104569 11.790861,238 14,238 C16.209139,238 18.209139,237.104569 19.6568542,235.656854 C21.1045695,234.209139 22,232.209139 22,230 L22,14 C22,11.790861 21.1045695,9.790861 19.6568542,8.34314575 C18.209139,6.8954305 16.209139,6 14,6 Z"/>
                            </defs>
                            ${sliderBody}
                                <polygon id="background" fill="${options.bgColor}" fill-rule="nonzero" points="-72 72 216 72 216 216 -72 216" transform="rotate(-90 72 144)"/>
                                    <g id="back" transform="translate(58 22)">
                                        <use xlink:href="#path-3" id="slider" fill="#FFF"/>
                                    </g>
                                    <rect id="bar" x="64" y="${1+ innerLow + h}" rx="${radius}" width="${radius*2}" height="${faderWidth - h}" fill="#FFF"></rect>
                                    <g transform="translate(0 ${-thumbWidth + height * faderWidth})">
                                        <circle id="cut" cx="72" cy="74" r="26" fill="${options.bgColor}" mask="url(#mask-2)"/>
                                        <path id="ring" fill="#FFF" d="M72,54 C83.045695,54 92,62.954305 92,74 C92,85.045695 83.045695,94 72,94 C60.954305,94 52,85.045695 52,74 C52,62.954305 60.954305,54 72,54 Z M72,60 C64.2680135,60 58,66.2680135 58,74 C58,81.7319865 64.2680135,88 72,88 C79.7319865,88 86,81.7319865 86,74 C86,66.2680135 79.7319865,60 72,60 Z"/>
                                    </g>
                                </g>
                            </svg>`;

        return slider;
    }
}
