// Interface for obs.source

// ---------------------------------------------------------------------------------------------- //
// Enumerations
// ---------------------------------------------------------------------------------------------- //

const EOBSSourceMediaAction = {
	"Play": "play", // Unpause playback.
	"Pause": "pause", // Pause playback.
	"Restart": "restart", // (Re-)Start playback.
	"Stop": "stop", // Stop playback completely.
	"Next": "next", // Seek to next file (if there is any).
	"Previous": "previous", // Seek to previous file (if there is any).
};

const EOBSSourceMediaStatus = {
	"None": "none",
	"Playing": "playing",
	"Opening": "opening",
	"Buffering": "buffering",
	"Paused": "paused",
	"Stopped": "stopped",
	"Ended": "ended",
	"Error": "error",
};

// ---------------------------------------------------------------------------------------------- //
// Source Interface API
// ---------------------------------------------------------------------------------------------- //

class obs_source_api extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Data
		this._sources = new Map();
		this._icons = new Map();

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev);
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev);
		}, true);
		this.obs.addEventListener("obs.source.event.create", (event) => {
			this._on_obs_source_event_create(event);
		}, true);
		this.obs.addEventListener("obs.source.event.destroy", (event) => {
			this._on_obs_source_event_destroy(event);
		}, true);
		this.obs.addEventListener("obs.source.event.rename", (event) => {
			this._on_obs_source_event_rename(event);
		}, true);
		this.obs.addEventListener("obs.source.event.state", (event) => {
			this._on_obs_source_event_state(event);
		}, true);
		this.obs.addEventListener("obs.source.event.media", (event) => {
			this._on_obs_source_event_media(event);
		}, true);
		this.obs.addEventListener("obs.source.event.filter.add", (event) => {
			this._on_obs_source_event_filter_add(event);
		}, true);
		this.obs.addEventListener("obs.source.event.filter.remove", (event) => {
			this._on_obs_source_event_filter_remove(event);
		}, true);
		this.obs.addEventListener("obs.source.event.filter.reorder", (event) => {
			this._on_obs_source_event_filter_reorder(event);
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Map of all currently known sources.
	 *
	 */
	get sources() {
		return new Map(this._sources);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	icon_by_id(id){
		if( this._icons.has(id) ){
			return this._icons.get(id);
		} else {
			return unknown;
		}
	}

	_enumerate_icons() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			throw new Error("OBS Studio is not connected.".lox());
		}

		// Enumerate icons
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.icons", (result, error) => {
				if (error !== undefined) {
					reject(error);
					return;
				}
				if( typeof result === "object" ){
					const new_icons = new Map();
					for(const id in result){
						new_icons.set(id, result[id]);
					}
					// Hardcode in a few extra
					new_icons.set("group", "group");
					new_icons.set("scene", "scene");
					this._icons = new_icons;
					resolve();
				} else {
					reject();
					return;
				}
			})
		})
	}


	_enumerate() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			throw new Error("OBS Studio is not connected.".lox());
		}

		// Enumerate Sources
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.enumerate", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (Array.isArray(result)) {
					// Update our Map of known Sources.
					let sources = new Map();
					for (let state of result) {
						let source = null;

						// Try and find if we already know of a source by a given name.
						if (this._sources.has(state.name)) {
							source = this._sources.get(state.name);
							if (!source.valid) // Ensure that the source is still valid.
								source = null;
						}

						// If we don't, create a new one.
						if (source === null) {
							source = new obs_source(this.obs, this, state);
						}

						// Add it to the list of sources.
						sources.set(source.name, source);
					}
					this._sources = sources;

					// Signal anyone listening that the list of Source has changed.
					this._event_sources();
				} else {
					reject();
					return;
				}
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	/** The list of Sources has changed.
	 *
	 * @argument data A map of all known sources.
	 */
	_event_sources() {
		let ev = new Event("sources", { "bubbles": true, "cancelable": true });
		ev.data = this.sources;
		this.dispatchEvent(ev);
	}

	/** renamed
	 *
	 * @argument data.from The old name
	 * @argument data.to The new name
	 */
	_event_renamed(from, to) {
		let evx = new Event("renamed", { "bubbles": true, "cancelable": true });
		evx.data = {from, to};
		this.dispatchEvent(evx);
	}

	/** The list of Sources has changed.
	 *
	 * @argument data.source The source on which the list of filters changed.
	 */
	_event_filters(source) {
		let ev = new Event("filters", { "bubbles": true, "cancelable": true });
		ev.data = {
			source: this.sources,
		};
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_open(ev) {
		ev.preventDefault();

		// Clear the list of Sources.
		this._sources.clear();

		// Enumerate Icons
		this._enumerate_icons();

		// Enumerate Sources.
		this._enumerate();
	}

	_on_close(ev) {
		ev.preventDefault();
		// Child Sources also listen to the 'close' event, so nothing to do here.

		// Clear the list of Sources.
		this._sources.clear();

		// Signal anyone listening that the list of Source has changed.
		this._event_sources();
	}

	_on_obs_source_event_create(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();

		// Create and add the source.
		let source = new obs_source(this.obs, this, args);
		this._sources.set(source.name, source);

		// Signal anyone listening that the list of Source has changed.
		this._event_sources();
	}

	_on_obs_source_event_destroy(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();

		// Resolve to a source.
		let name = (typeof args.source == "string") ? args.source : args.source[0];
		let source = this._sources.get(name);

		// Inform the source about the event.
		if (source !== undefined) {
			source._on_obs_source_event_destroy(ev);
		}

		// If this affects us, update our list of Sources.
		if (typeof args.source == "string") {
			// Move the Source to a different name.
			this._sources.delete(name);

			// Signal anyone listening that the list of Source has changed.
			this._event_sources();
		}
	}

	_on_obs_source_event_rename(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();

		// Resolve to a source.
		let source = this._sources.get(Array.isArray(args.source) ? args.source[0] : args.from);

		// Inform the source about the rename event.
		if (source !== undefined) {
			source._on_obs_source_event_rename(ev);
		}

		// If this affects us, update our list of Sources.
		if (typeof args.source == "string") {
			// Move the Source to a different name.
			this._sources = this._sources.replaceAt(args.from, args.to);

			// Signal anyone listening that the list of Source has changed.
			this._event_sources();
			this._event_renamed(args.from, args.to);
		}
	}

	_on_obs_source_event_state(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();
		let name = (typeof args.source == "string") ? args.source : args.source[0];
		let source = this._sources.get(name);
		if (source !== undefined)
			source._on_obs_source_event_state(ev);
	}

	_on_obs_source_event_filter_add(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();
		let name = (typeof args.source == "string") ? args.source : args.source[0];
		let source = this._sources.get(name);
		if (source !== undefined)
			source._on_obs_source_event_filter_add(ev);
	}

	_on_obs_source_event_filter_remove(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();
		let name = (typeof args.source == "string") ? args.source : args.source[0];
		let source = this._sources.get(name);
		if (source !== undefined)
			source._on_obs_source_event_filter_remove(ev);
	}

	_on_obs_source_event_filter_reorder(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();
		let name = (typeof args.source == "string") ? args.source : args.source[0];
		let source = this._sources.get(name);
		if (source !== undefined)
			source._on_obs_source_event_filter_reorder(ev);
	}

	_on_obs_source_event_media(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();
		let name = (typeof args.source == "string") ? args.source : args.source[0];
		let source = this._sources.get(name);
		if (source !== undefined)
			source._on_obs_source_event_media(ev);
	}
}

// ---------------------------------------------------------------------------------------------- //
// Source API
// ---------------------------------------------------------------------------------------------- //

class obs_source extends EventTarget {
	constructor(obs, api, state, parent) {
		super();

		// Keep a few references.
		this._obs = obs; // OBS API
		this._api = api; // obs.source API

		// Listeners
		this.obs.addEventListener("close", (ev) => {
			this._on_obs_close(ev);
		});

		// Data
		this._valid = true;
		this._parent = parent;
		this._filters = new Map();
		this._state(state);

		// Enumerate Filters
		if (this._parent === undefined) {
			// Only do this if this isn't already a Filter.
			this._enumerate();
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	get api() {
		return this._api;
	}

	/** Is this object still a valid representation of a Source?
	 *
	 * A number of things can happen that could cause an object to be invalid.
	 *
	 */
	get valid() {
		return this._valid;
	}

	/** Source Class Identifier
	 */
	get id() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._id;
	}

	/** Source Class Type
	 */
	get type() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._type;
	}

	/** Source Class Output Flags
	 */
	get output_flags() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return new Map(this._output_flags);
	}

	/** Parent Source, if any.
	 */
	get parent() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._parent;
	}

	/** Versioned Source Class Identifier
	 */
	get versioned_id() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._id_versioned;
	}

	/** Unique Name
	 */
	get name() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._name;
	}

	/** Is the Source enabled?
	 */
	get enabled() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._enabled;
	}

	/** Is the Source active?
	 */
	get active() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._active;
	}

	/** Current Size of the Source
	 */
	get size() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return [this._size[0], this._size[1]];
	}

	/** Base Size of the Source
	 */
	get base_size() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return [this._size[2], this._size[3]];
	}

	/** Flags
	 */
	get flags() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return new Map(this._flags);
	}

	/**
	 */
	get audio_state() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._audio;
	}

	/**
	 */
	get media_state() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._media;
	}

	/** Get the list of filters this source has.
	 *
	 * @return {Map<string, obs_source>}
	 */
	get filters() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return new Map(this._filters);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	_invalidate() {
		// Flag as invalid.
		this._valid = false;

		// Invalidate all filters still remaining.
		if (this._filters !== undefined) {
			for (let filter of this._filters) {
				filter[1]._invalidate();
			}
		}

		// Clear all stored data.
		this._id = undefined;
		this._id_versioned = undefined;
		this._type = undefined;
		this._output_flags = undefined;
		this._name = undefined;
		this._enabled = undefined;
		this._active = undefined;
		this._visible = undefined;
		this._size = undefined;
		this._flags = undefined;
		this._flags = undefined;
		this._audio = undefined;
		this._media = undefined;
		this._filters = undefined;
	}

	_state(state) {
		// Source Class
		this._id = state.id_unversioned;
		this._id_versioned = state.id;
		this._type = state.type;
		this._output_flags = state.output_flags !== undefined ? state.output_flags : state.outputflags;
		this._output_flags = new Map(Object.entries(this._output_flags));

		// Source Instance
		this._name = state.name;
		this._enabled = state.enabled;
		this._active = state.active;
		this._visible = state.visible;
		this._size = state.size;
		this._flags = new Map(Object.entries(state.flags));
		this._audio = state.audio;
		this._media = state.media;
		if(this._media){
			this._media.msgTime = Date.now();
		}
	}

	_media_state(state) {
		this._media = state.media;
		this._media.msgTime = Date.now();
	}

	_enumerate() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			throw new Error("OBS Studio is not connected.".lox());
		}

		// Enumerate Sources
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.filters", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Update our Map of known Filters.
					let filters = new Map();
					for (let state of result) {
						let filter = null;

						// Try and find if we already know of a source by a given name.
						if (this._filters.has(state.name)) {
							filter = this._filters.get(state.name);
							if (!filter.valid) // Ensure that the source is still valid.
								filter = null;
						}

						// If we don't, create a new one.
						if (filter === null) {
							filter = new obs_source(this.obs, this.api, state, this);
						}

						// Add it to the list of Filters.
						filters.set(filter.name, filter);
					}
					this._filters = filters;

					// Signal anyone listening that the list of Filters has changed.
					this._event_filters();

					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, { source: this.name });
		});
	}

	set_enabled(enabled) {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update "enabled" status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.state", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				enabled: enabled
			});
		});
	}

	adjust_audio_volume(volume, unit = "%") {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update volume status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.state", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				volume: {
					value: volume,
					unit: unit
				}
			});
		});
	}

	set_audio_volume(volume) {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update "enabled" status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.state", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				volume: volume
			});
		});
	}

	set_audio_muted(muted) {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update "enabled" status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.state", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				muted: muted
			});
		});
	}

	set_audio_balance(balance) {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update "enabled" status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.state", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				balance: balance
			});
		});
	}

	control_media(action) {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update "enabled" status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.media", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				action: action
			});
		});
	}

	seek_media(time_in_seconds) {
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Update "enabled" status.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.media", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					// Nothing to do here, we should get an event for the actual update before the reply happens.
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				time: time_in_seconds
			});
		});
	}

	/** Calls 'obs.source.properties' asynchronously.
	 *
	 * See documentation for 'obs.source.properties'.
	 *
	 * @return A Promise that resolves to an Array of Property objects.
	 */
	properties() {
		// obs.source.properties
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Query properties
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.properties", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
			});
		});
	}

	/** Calls 'obs.source.settings' asynchronously
	 *
	 * See documentation for 'obs.source.settings'.
	 * @param settings See documentation for 'obs.source.settings'. (Optional)
	 *
	 * @return A Promise that resolves to the exact settings used by a source.
	 */
	settings(settings) {
		// obs.source.settings
		// Ensure this is a valid object.
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());

		// Is OBS Studio connected?
		if (!this.obs.connected())
			throw Error("OBS Studio is not connected.".lox());

		// Query properties
		return new Promise((resolve, reject) => {
			this.obs.call("obs.source.settings", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (result !== undefined) {
					resolve(result);
					return;
				} else {
					reject();
					return;
				}
			}, {
				source: (this.parent ? [this.parent.name, this.name] : this.name),
				settings: settings,
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	/** State has changed.
	 *
	 */
	_event_state() {
		let ev = new Event("state", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	/** Media State has changed.
	 *
	 */
	_event_media_state() {
		let ev = new Event("media_state", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	/** Filters have been added, removed or reordered.
	 *
	 */
	_event_filters() {
		let ev = new Event("filters", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
		this._api._event_filters(this);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_obs_close(ev) {
		this._invalidate();

		// Signal to anyone listening that the state has changed.
		this._event_state();
	}

	_on_obs_source_event_destroy(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 1)) {
			// Update for us directly.
			this._invalidate();

			// Signal to anyone listening that the state has changed.
			this._event_state();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Reseolve the reference to a filter.
			let filter = this._filters.get(args.source[0]);

			// Inform the filter itself about the update.
			filter._on_obs_source_event_destroy(ev);
		}
	}

	_on_obs_source_event_rename(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 1)) {
			// Update for us directly.
			this._name = args.to;

			// Signal to anyone listening that the state has changed.
			this._event_state();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Resolve the reference to a filter.
			let filter = this._filters.get((args.source.length == 1) ? args.from : args.source[0]);

			// Inform the filter itself about the update.
			if (filter !== undefined) {
				filter._on_obs_source_event_rename(ev);
			}

			// If the source reference is now only one element long, update our own filter list.
			if (args.source.length == 1) {
				this._filters.delete(args.from);
				this._filters.set(args.to, filter);

				// Signal anyone listening that the filters have changed.
				this._event_filters();
			}
		}
	}

	_on_obs_source_event_state(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 1)) {
			// Update for us directly.
			this._state(args.state);

			// Signal to anyone listening that the state has changed.
			this._event_state();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Resolve to a filter and inform it about the update.
			let filter = this._filters.get(args.source[0]);
			filter._on_obs_source_event_state(ev);
		}
	}

	_on_obs_source_event_media(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 1)) {
			// Update for us directly.
			this._media_state(args);

			// Signal to anyone listening that the state has changed.
			this._event_media_state();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Resolve to a filter and inform it about the update.
			let filter = this._filters.get(args.source[0]);
			filter._on_obs_source_event_media(ev);
		}
	}

	_on_obs_source_event_filter_add(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 1)) {
			// Add the filter to the end of the Map.
			let filter = new obs_source(this._obs, this._obs_source_api, args["filter"], this);
			this._filters.set(filter.name, filter);

			// Signal anyone listening that the filters have changed.
			this._event_filters();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Resolve to a filter and inform it about the update.
			let filter = this._filters.get(args.source[0]);
			filter._on_obs_source_event_filter_add(ev);
		}
	}

	_on_obs_source_event_filter_remove(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 2)) {
			let name = (typeof args.source == "string") ? args.source : args.source[1];

			// Remove filter and invalidate it.
			let filter = this._filters.get(name);
			if (filter !== undefined)
				filter._invalidate();
			this._filters.delete(name);

			// Signal anyone listening that the filters have changed.
			this._event_filters();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Resolve to a filter and inform it about the update.
			let filter = this._filters.get(args.source[0]);
			filter._on_obs_source_event_filter_remove(ev);
		}
	}

	_on_obs_source_event_filter_reorder(ev) {
		let args = ev.data.parameters();

		if ((typeof (args.source) == "string") || (args.source.length == 1)) {
			let order = args["filter"];

			// Generate a new Map with the updated order.
			let filters = new Map();
			for (let filter of order) {
				filters.set(filter, this._filters.get(filter));
			}
			this._filters = filters;

			// Signal anyone listening that the filters have changed.
			this._event_filters();
		} else {
			// Update for a filter that is private to us.

			// Shift the reference array left by 1 (remove ourselves from the array).
			args.source.shift();

			// Resolve to a filter and inform it about the update.
			let filter = this._filters.get(args.source[0]);
			filter._on_obs_source_event_filter_reorder(ev);
		}
	}
}
