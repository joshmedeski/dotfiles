// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class FilterStateInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			source: document.querySelector("#source"),
			sources: document.querySelector("#source .sdpi-item-value"),
			filter: document.querySelector("#filter"),
			filters: document.querySelector("#filter .sdpi-item-value"),
		};
		this._settings = {};
		this.sources = new Map();

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_sources = this.initDep("rpc.sources");

		this.initDontBlock("rpc.close");


		this._els.sources.addEventListener("change", (event) => {
			this._on_source_changed(event);
		});
		this._els.filters.addEventListener("change", (event) => {
			this._on_filter_changed(event);
		});

		this.addEventListener(this._dep_settings, (event) => {
			this._on_rpc_settings(event);
		});
		this.addEventListener("rpc.close", (event) => {
			this._on_rpc_close(event);
		});
		this.addEventListener(this._dep_obs, (event) => {
			this._on_rpc_open(event);
		});
		this.addEventListener(this._dep_sources, (event) => {
			this._on_rpc_sources(event);
		});

		this.sources_reset();
		this.filters_reset();
		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get sources() {
		return new Map(this._sources);
	}

	set sources(v) {
		this._sources = v;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	validate() {
		if (!this.haveDep(this._dep_obs)) {
			this.show_processing_overlay("Waiting for OBS...".lox());
		} else if (!this.haveDep(this._dep_settings)) {
			this.show_processing_overlay("Waiting for settings...".lox());
		} else if (!this.haveDep(this._dep_sources)) {
			this.show_processing_overlay("Waiting for sources...".lox());
		} else {
			this.hide_overlays();
		}
	}

	apply_settings() {
		this._els.sources.value = this._settings.source;
		this._els.filters.value = this._settings.filter;
	}

	sources_clear() {
		while (this._els.sources.firstElementChild) {
			this._els.sources.removeChild(this._els.sources.firstElementChild);
		}
	}

	sources_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.sources.appendChild(e);
	}

	sources_reset() {
		this.sources_clear();
		if (this._settings.source !== undefined) {
			this.sources_add(`[${this._settings.source}]`, this._settings.source, true, true);
		}
		this.apply_settings();
	}

	sources_update() {
		this.sources_clear();

		// Does the set contain the selected?
		if (!this.sources.has(this._settings.source)) {
			// If not add it as a special unselectable entry.
			if (this._settings.source !== undefined) {
				this.sources_add(`[${this._settings.source}]`, this._settings.source, true, true);
			}
		}

		// Add all to the list.
		for (let source of this.sources.keys()) {
			this.sources_add(source, source, false);
		}

		// Re-apply settings to elements.
		this.apply_settings();
	}

	filters_clear() {
		while (this._els.filters.firstElementChild) {
			this._els.filters.removeChild(this._els.filters.firstElementChild);
		}
	}

	filters_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.filters.appendChild(e);
	}

	filters_reset() {
		this.filters_clear();
		if (this._settings.filter !== undefined) {
			this.filters_add(`[${this._settings.filter}]`, this._settings.filter, true, true);
		}
		this.apply_settings();
	}

	filters_update() {
		this.filters_clear();

		// ...
		console.log(this.sources, this._settings);
		let filters = this.sources.get(this._settings.source);
		if (!filters) {
			return;
		}

		// Does the set contain the selected?
		if (!filters.includes(this._settings.filter)) {
			// If not add it as a special unselectable entry.
			if (this._settings.filter !== undefined) {
				this.filters_add(`[${this._settings.filter}]`, this._settings.filter, true, true);
			}
		}

		// Add all to the list.
		for (let filter of filters) {
			this.filters_add(filter, filter, false);
		}

		// Re-apply settings to elements.
		this.apply_settings();
	}

	// ---------------------------------------------------------------------------------------------- //
	// RPC
	// ---------------------------------------------------------------------------------------------- //
	_on_rpc_settings(event) {
		event.preventDefault();
		let params = event.data.parameters();
		if (params) {
			this._settings = params;
			this.apply_settings();
		} else {
			throw Error("Missing parameters".lox());
		}
	}

	_on_rpc_close(event) {
		event.preventDefault();
		this.initReset();
		this.sources = new Map();
		this.sources_reset();
		this.filters_reset();
		this.validate();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this.validate();
	}

	_on_rpc_sources(event) {
		event.preventDefault();
		this.sources = new Map(event.data.parameters().list);
		this.sources_update();
		this.filters_update();
		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	_on_source_changed(event) {
		this._settings.source = event.target.value;
		this._settings.filter = undefined;
		this.notify("settings", this._settings);
	}

	_on_filter_changed(event) {
		this._settings.filter = event.target.value;
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new FilterStateInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
