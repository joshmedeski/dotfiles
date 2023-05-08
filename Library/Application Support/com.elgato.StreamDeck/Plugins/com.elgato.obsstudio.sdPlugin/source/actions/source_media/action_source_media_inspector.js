// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SourceMediaInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			source: document.querySelector("#source"),
			sources: document.querySelector("#source .sdpi-item-value"),
			action: document.querySelector("#action"),
			actions: document.querySelector("#action .sdpi-item-value"),
			count: document.querySelector("#countdown"),
			count_none: document.querySelector("#count_none"),
			count_up: document.querySelector("#count_up"),
			count_down: document.querySelector("#count_down"),
			heading: document.querySelector("#help_header"),
			message: document.querySelector("#help_message"),
		};
		this._settings = {};

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_sources = this.initDep("rpc.sources");

		this.initDontBlock("rpc.close");

		this._els.sources.addEventListener("change", (event) => {
			this._on_source_changed(event);
		});
		this._els.actions.addEventListener("change", (event) => {
			this._on_action_changed(event);
		});
		this._els.count_none.addEventListener("change", (event) => {
			this._on_countdown_changed(event, "none");
		});
		this._els.count_up.addEventListener("change", (event) => {
			this._on_countdown_changed(event, "up");
		});
		this._els.count_down.addEventListener("change", (event) => {
			this._on_countdown_changed(event, "down");
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
		this.validate();
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
		this._els.actions.value = this._settings.action;
		const radio = this._els["count_" + this._settings.countdown];
		if(radio){
			radio.checked = true;
		}

		if (this._settings.isInMultiAction === true) {
			this._els.action.style.display = "none";
			this._els.count.style.display = "none";
			this._els.heading.style.display = "none";
			this._els.message.style.display = "none";
		}

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

	sources_update(data) {
		this.sources_clear();

		let sources = data.list;

		// Does the set contain the selected?
		if (!sources.includes(this._settings.source)) {
			// If not add it as a special unselectable entry.
			if (this._settings.source !== undefined) {
				this.sources_add(`[${this._settings.source}]`, this._settings.source, true, true);
			}
		}

		// Add all to the list.
		for (let source of sources) {
			this.sources_add(source, source, false);
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
			throw Error("Missing parameters");
		}
	}

	_on_rpc_close(event) {
		event.preventDefault();
		this.initReset();
		this.sources_reset();
		this.validate();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this.sources_reset();
		this.validate();
	}

	_on_rpc_sources(event) {
		event.preventDefault();
		this.sources_update(event.data.parameters());
		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	_on_source_changed(event) {
		// The 'source' field was changed.

		// Update settings
		this._settings.source = event.target.value;
		this._settings.filter = undefined;
		this.notify("settings", this._settings);
	}

	_on_action_changed(event) {
		this._settings.action = event.target.value;
		this.notify("settings", this._settings);
	}

	_on_countdown_changed(event, value) {
		if (event.target.checked){
			this._settings.countdown = value;
		}
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new SourceMediaInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
