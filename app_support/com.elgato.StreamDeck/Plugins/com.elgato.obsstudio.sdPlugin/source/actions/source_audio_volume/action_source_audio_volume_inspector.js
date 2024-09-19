// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SourceAudioVolumeInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			source: document.querySelector("#source"),
			sources: document.querySelector("#source .sdpi-item-value"),
			step: document.querySelector("#step"),
			steps: document.querySelector("#step .sdpi-item-value input"),
		};
		this._settings = {};

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_sources = this.initDep("rpc.sources");

		this.initDontBlock("rpc.close");

		this._els.sources.addEventListener("change", (event) => {
			this._on_source_changed(event);
		});
		this._els.steps.addEventListener("change", (event) => {
			this._on_step_changed(event);
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

		this.addSliderTooltip(this._els.steps, (value)=>{
			return "+/- " + value + " dB";
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
		if (typeof (this._settings.source) == "string") {
			this._els.sources.value = this._settings.source;
		} else {
			this._els.sources.value = "";
		}
		if (typeof (this._settings.step) == "number") {
			this._els.steps.value = `${this._settings.step.toFixed(1)}`;
		} else {
			this._els.steps.value = "1.0";
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
		} else {
			this.sources_add("", "", true, true);
		}
		this.apply_settings();
	}

	sources_update(data) {
		this.sources_clear();

		// data.list holds an ordered Object, which needs to be converted to an array.
		let sources = data.list;

		// Does the set contain the selected?
		if (!sources.includes(this._settings.source)) {
			// If not add it as a special unselectable entry.
			if (this._settings.source !== undefined) {
				this.sources_add(`[${this._settings.source}]`, this._settings.source, true, true);
			} else {
				this.sources_add("", "", true, true);
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

	_on_source_changed(event) {
		this._settings.source = event.target.value;
		this.notify("settings", this._settings);
	}

	_on_step_changed(event) {
		this._settings.step = parseFloat(event.target.value);
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new SourceAudioVolumeInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
