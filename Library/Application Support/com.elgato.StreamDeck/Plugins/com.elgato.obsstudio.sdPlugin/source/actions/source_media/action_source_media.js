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
const ESourceMediaAction_PlayPause = "play_pause";
const ESourceMediaAction_PlayStop = "play_stop";
const ESourceMediaAction_PlayRestart = "play_restart";
const ESourceMediaAction_Stop = "stop";

class SourceMediaAction extends IAction {
	// ---------------------------------------------------------------------------------------------- //
	// Statics
	// ---------------------------------------------------------------------------------------------- //

	// Should be static to the SourceMediaAction class.
	static MediaStatus = {
		Active: [EOBSSourceMediaStatus.Playing, EOBSSourceMediaAction.Opening, EOBSSourceMediaStatus.Buffering, EOBSSourceMediaStatus.Paused],
		Playing: [EOBSSourceMediaStatus.Playing, EOBSSourceMediaAction.Opening, EOBSSourceMediaStatus.Buffering],
		Paused: [EOBSSourceMediaStatus.Paused],
		Stopped: [EOBSSourceMediaStatus.None, EOBSSourceMediaStatus.Stopped, EOBSSourceMediaStatus.Ended, EOBSSourceMediaStatus.Error],
	};

	// ---------------------------------------------------------------------------------------------- //
	// Dynamics
	// ---------------------------------------------------------------------------------------------- //

	constructor(controller) {
		super(controller, "com.elgato.obsstudio.source.media");

		// Action States
		this.registerNamedState("active", 0);
		this.registerNamedState("inactive", 1);
		this.registerNamedState(EOBSSourceMediaAction.Play, 0); // Replaces "active"
		this.registerNamedState(EOBSSourceMediaAction.Pause, 1); // Replaces "inactive"
		this.registerNamedState(EOBSSourceMediaAction.Stop, 2);
		this.registerNamedState(EOBSSourceMediaAction.Restart, 3);

		// APIs
		this._api_source = this.obs.source_api;

		// Update Interval
		this._update_interval = {};
		this._reset_timeout = {};

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
			this.obs.addEventListener("obs.source.event.media", (event) => {
				this._on_obs_source_event_media(event);
			});

			// Source API
			this._api_source.addEventListener("sources", (event) => {
				this._on_sources_changed(event);
			});
			this._api_source.addEventListener("renamed", (event) => {
				this._on_renamed(event);
			});
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	// Converts time to MM:SS
	// time is the position in ms, end is the duration in ms, countup is whether we count up (true) or down (false)
	_format_time(time, duration, countup=true){
		let prefix = "";
		let hours = Math.floor(time/1000/60/60);
		if(!countup || hours > 0){
			prefix = "-";
			time = duration - time;
		}
		time = Math.floor(time/1000);
		const seconds = String(time % 60).padStart(2, "0");;
		time = Math.floor(time/60);
		const minutes = String(time % 60);//.padStart(2, "0");
		hours = Math.floor(time/60);
		if (hours > 0){
			//return `${prefix}${hours}:${minutes}:${seconds}`;
			return "??:??"
		}
		return `${prefix}${minutes}:${seconds}`;
	}

	setBothTitles(context, title) {
		this.setTitle(context, 0, title);
		this.setTitle(context, 1, title);
	}


	/** Update the media info in the title
	 *
	 * @param {any} context The context to update
	 * @param {any} settings The settings object for the context
	 * @param {any} media_state The media_state to base the update off of
	 */
	_updateMediaInfo(context, settings, media_state){
		const count_up = settings.countdown == "up";

		let wasPlaying = false;
		if( this._update_interval[context] ){
			clearInterval(this._update_interval[context]);
			delete this._update_interval[context];
			wasPlaying = true;
		}
		if( this._reset_timeout[context] ){
			clearTimeout(this._reset_timeout[context]);
			delete this._reset_timeout[context];
		}
		// Escape if the user changed the count type
		if (settings.countdown == "none"){
			this.setBothTitles(context, settings.source);
			return;
		}

		let formatted_time = this._format_time(media_state.time[0], media_state.time[1], count_up);
		switch (media_state.status){
		case "playing":
			const interval = ()=>{
				this.obs.log(JSON.stringify(media_state));
					const now = Date.now();
					const formatted_time = this._format_time(now - media_state.msgTime + media_state.time[0], media_state.time[1], count_up);
					this.setBothTitles(context, formatted_time);
				};
			this._update_interval[context] = setInterval(interval, 500);
			if (media_state.time[0] == 0){
				// Weird edge case when scrubbing
				this._reset_timeout[context] = setTimeout(()=>{
					interval();
					delete this._reset_timeout[context];
				}, 200);
			} else {
				interval();
			}
			break;
		case "opening":
			this.setBothTitles(context, "...");
			break;
		case "buffering":
			this.setBothTitles(context, "(" + formatted_time + ")");
			break;
		case "paused":
			this.setBothTitles(context, formatted_time);
			break;
		case "ended":
			if( wasPlaying ){
				this.setBothTitles(context, "Finished".lox());
				this._reset_timeout[context] = setTimeout(()=>{
					this.setBothTitles(context, settings.source);
					delete this._reset_timeout[context];
				}, 2000);
				break;
			}
		case "stopped":
		case "none":
			this.setBothTitles(context, settings.source);
			break;
		case "error":
			this.setBothTitles(context, "Error".lox());
			this._reset_timeout[context] = setTimeout(()=>{
				this.setBothTitles(context, settings.source);
				delete this._reset_timeout[context];
			}, 2000);
			break;

		}
	}

	/** Refresh the status of a specific context, or all contexts if none specified.
	 *
	 * @param {any} context The context to refresh, or undefined if refreshing all contexts.
	 */
	refresh(context) {
		if (context !== undefined) {
			// Ignore any context that is inside of a multi-action.
			const status = this.status(context);
			if (status && status.isInMultiAction === true) {
				return;
			}

			// Disable the item if OBS is not connected.
			if (!this.obs.connected()) {
				this.setState(context, "inactive");
				return;
			}

			let settings = this.settings(context);

			// Check if the source exists.
			let source = this._api_source.sources.get(settings.source);
			if (source === undefined) {
				this.setState(context, "inactive");
				return;
			}

			const media_state = source.media_state;
			if (media_state.status == "playing" && media_state.time[0] == 0 && media_state.time[1] == 0){
				// Weird edge case, but this is probably a source that has no valid media
				media_state.status = "none";
			}
			if( media_state && !settings.isInMultiAction){
				this._updateMediaInfo(context, settings, media_state);
			}

			// Update Status
			switch (settings.action) {
			case ESourceMediaAction_PlayPause:
				if (SourceMediaAction.MediaStatus.Playing.includes(source.media_state.status)) {
					this.setState(context, "active");
				} else {
					this.setState(context, "inactive");
				}
				break;
			case ESourceMediaAction_PlayStop:
				if (SourceMediaAction.MediaStatus.Playing.includes(source.media_state.status)) {
					this.setState(context, "active");
				} else {
					this.setState(context, "inactive");
				}
				break;
			case ESourceMediaAction_PlayRestart:
				if (SourceMediaAction.MediaStatus.Playing.includes(source.media_state.status)) {
					this.setState(context, "active");
				} else {
					this.setState(context, "inactive");
				}
				break;
			case ESourceMediaAction_Stop:
				if (SourceMediaAction.MediaStatus.Playing.includes(source.media_state.status)) {
					this.setState(context, "active");
				} else {
					this.setState(context, "inactive");
				}
				break;
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
		// Try to migrate any old settings to the new layout.
		this._migrate_settings(settings);

		// Apply default settings to any missing entries.
		this._default_settings(settings);

		// Store the settings to Stream deck.
		this.settings(context, settings);

		// Refresh the context.
		this.refresh(context);

		// Update the open inspector if it is for this action.
		if (this.inspector == context) {
			this.notify(this.inspector, "settings", settings);
			this._inspector_refresh();
		}

		this.setBothTitles(context, settings.source);

		// If not in a multi-action, update button images.
		if (this.status(context).isInMultiAction !== true) {
			switch (settings.action) {
			case ESourceMediaAction_PlayPause:
				this.setImage(context, "active", "resources/actions/source.media/pause-on.png");
				this.setImage(context, "inactive", "resources/actions/source.media/play-off.png");
				break;
			case ESourceMediaAction_PlayStop:
				this.setImage(context, "active", "resources/actions/source.media/stop-on.png");
				this.setImage(context, "inactive", "resources/actions/source.media/play-off.png");
				break;
			case ESourceMediaAction_PlayRestart:
				this.setImage(context, "active", "resources/actions/source.media/start-on.png");
				this.setImage(context, "inactive", "resources/actions/source.media/play-off.png");
				break;
			case ESourceMediaAction_Stop:
				this.setImage(context, "active", "resources/actions/source.media/stop-on.png");
				this.setImage(context, "inactive", "resources/actions/source.media/stop-off.png");
				break;
			}
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

		if ((settings.action === undefined) || (typeof (settings.action) !== "string")) {
			settings.action = "play_stop";
		}

		if ((settings.countdown === undefined) || (typeof (settings.countdown) !== "string")) {
			settings.countdown = "none";
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
		let sources = [];
		for (let source of this._api_source.sources) {
			if (!source[1].output_flags.get("controllable_media")) {
				continue;
			}

			sources.push(source[0]);
		}

		this.notify(this.inspector, "sources", {
			"list": sources
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //

	_on_willAppear(ev) {
		ev.preventDefault();
		let settings = this.settings(ev.context);
		settings.isInMultiAction = ev.data.payload.isInMultiAction ? true : false;
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

			// Convert settings/state into a proper command to OBS.
			let media_action = EOBSSourceMediaAction.Stop;
			let media_status = [];
			let media_promise = undefined;
			if (ev.data.payload.isInMultiAction === true) {
				media_action = this.translateStateIdToName(ev.data.payload.userDesiredState);
			} else {
				if (SourceMediaAction.MediaStatus.Paused.includes(source.media_state.status)) {
					if (settings.action === ESourceMediaAction_Stop) {
						media_action = EOBSSourceMediaAction.Stop;
					} else {
						media_action = EOBSSourceMediaAction.Play;
					}
				} else if (SourceMediaAction.MediaStatus.Playing.includes(source.media_state.status)) {
					if (settings.action === ESourceMediaAction_PlayPause) {
						media_action = EOBSSourceMediaAction.Pause;
					} else if (settings.action === ESourceMediaAction_PlayRestart) {
						media_action = EOBSSourceMediaAction.Restart;
					} else {
						media_action = EOBSSourceMediaAction.Stop;
					}
				} else {
					if (settings.action === ESourceMediaAction_Stop) {
						media_action = EOBSSourceMediaAction.Stop;
					} else {
						media_action = EOBSSourceMediaAction.Restart;
					}
				}
			}
			switch (media_action) {
			case EOBSSourceMediaAction.Stop:
				media_status = SourceMediaAction.MediaStatus.Stopped;
				media_promise = source.control_media(EOBSSourceMediaAction.Stop);
				break;
			case EOBSSourceMediaAction.Play:
				media_status = SourceMediaAction.MediaStatus.Playing;
				// For better user-experience, it's better to have Play behave like Restart when
				// when the media source has not started playback or was stopped. Otherwise Play
				// only allows unpausing the media source, which is not what people expect.
				if ([EOBSSourceMediaStatus.Paused, EOBSSourceMediaStatus.Playing, EOBSSourceMediaStatus.Opening, EOBSSourceMediaStatus.Buffering].includes(source.media_state.status)) {
					media_promise = source.control_media(EOBSSourceMediaAction.Play);
				} else {
					media_promise = source.control_media(EOBSSourceMediaAction.Restart);
				}
				break;
			case EOBSSourceMediaAction.Pause:
				media_status = SourceMediaAction.MediaStatus.Paused;
				media_promise = source.control_media(EOBSSourceMediaAction.Pause);
				break;
			case EOBSSourceMediaAction.Restart:
				media_status = SourceMediaAction.MediaStatus.Playing;
				media_promise = source.control_media(EOBSSourceMediaAction.Restart);
				break;
			}

			// If everything went well, try and update the state.
			await media_promise;
			if (!media_status.includes(source.media_state.status)) {
				if (config.status)
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

	_on_obs_source_event_media(ev) {
		ev.preventDefault();
		// Only refresh the sources that need the media event
		let params = ev.data.parameters();
		if (params){
			for (let ctx of this.contexts.keys()) {
				let settings = this.settings(ctx);
				if (settings.source == params.source){
					this.refresh(ctx);
				}
			}
		}

	}

	_on_renamed(ev) {
		ev.preventDefault();

		for (let ctx of this.contexts.keys()) {
			let settings = this.settings(ctx);
			if (settings.source == ev.data.from){
				settings.source = ev.data.to;
				this.settings(ctx, settings);
			}
			if (ctx == this.inspector){
				this._inspector_refresh();
			}
			this.refresh(ctx);
		}
	}

	async _on_rpc_source(ev) {
		ev.preventDefault();

		// 1. Check if we are connected with OBS Studio.
		if (!this.obs.connected()) {
			// If not, send an error
			let err = JSONRPCError(EJSONRPCERROR_INTERNAL_ERROR, "Disconnected from OBS Studio.".lox());
			this.reply(this.inspector, rpc.id(), undefined, err.compile());
			return;
		}

		//
		this._inspector_refresh_filters();

		// Reply to call
		let reply = new JSONRPCResponse();
		reply.result(true);
		this.reply(ev.extra[0].context, ev.data.id(), reply.compile());
	}

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}
}
