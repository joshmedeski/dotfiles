// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SourceAudioMuteInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._settings = {};
		this._inMultiAction = false;

		// Ordered Dependencies
		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_sources = this.initDep("rpc.sources");
		this.initDontBlock("rpc.close");

		// Add listeners for RPC events.
		this.addEventListener(this._dep_obs, (event) => { this._on_rpc_open(event) });
		this.addEventListener(this._dep_settings, (event) => { this._on_rpc_settings(event) });
		this.addEventListener(this._dep_sources, (event) => { this._on_rpc_sources(event) });
		this.addEventListener("rpc.close", (event) => { this._on_rpc_close(event) });

		// Acquire element references.
		this._els = {};
		this._els.type = {};
		this._els.type.set = document.querySelector("#type #type_set");
		this._els.type.adjust = document.querySelector("#type #type_adjust");
		this._els.type.mute = document.querySelector("#type #type_mute");
		this._els.source = document.querySelector("#source select");
		this._els.style = document.querySelector("#style select");
		this._els.styleContainer = document.querySelector("#style");
		this._els.step = document.querySelector("#step input");
		this._els.stepContainer = document.querySelector("#step");
		this._els.volume = document.querySelector("#volume input");
		this._els.volumeContainer = document.querySelector("#volume");
		this._els.mode = document.querySelector("#mode select");
		this._els.modeContainer = document.querySelector("#mode");

		// Listen to necessary events.
		this._els.type.set.addEventListener("change", (event) => { this._onTypeChange(event) });
		this._els.type.adjust.addEventListener("change", (event) => { this._onTypeChange(event) });
		this._els.type.mute.addEventListener("change", (event) => { this._onTypeChange(event) });
		this._els.type.set.addEventListener("input", (event) => { this._onTypeInput(event) });
		this._els.type.adjust.addEventListener("input", (event) => { this._onTypeInput(event) });
		this._els.type.mute.addEventListener("input", (event) => { this._onTypeInput(event) });
		this._els.source.addEventListener("change", (event) => { this._onSourceChange(event) });
		this._els.style.addEventListener("change", (event) => { this._onStyleChange(event) });
		this._els.step.addEventListener("change", (event) => { this._onStepChange(event) });
		this._els.volume.addEventListener("change", (event) => { this._onVolumeChange(event) });
		this._els.mode.addEventListener("change", (event) => { this._onModeChange(event) });

		this.addSliderTooltip(this._els.volume, (value)=>{
			value = percentToDBFS(value);
			if (value == Number.NEGATIVE_INFINITY){
				return "-inf dB";
			}
			return value.toFixed(1) + " dB";
		});
		this.addSliderTooltip(this._els.step, (value)=>{
			if(value >= 0){
				value += 1;
			}
			return (value < 0 ? "" : "+") + parseInt(value) + " dB";
		});

		// Start the whole thing.
		this.initialize();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	initialize() {
		this._els.type.mute.dispatchEvent(new Event('input', { 'bubbles': true }));

		this.sources_reset();
		this.validate();
	}

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
		this.reset_modes();

		let type = this._settings.getProperty("type", "mute");
		this._els.type.set.checked = (type == "set");
		if (this._els.type.set.checked)
			this._els.type.set.dispatchEvent(new Event('input', { 'bubbles': true }));
		this._els.type.adjust.checked = (type == "adjust");
		if (this._els.type.adjust.checked)
			this._els.type.adjust.dispatchEvent(new Event('input', { 'bubbles': true }));
		this._els.type.mute.checked = (type == "mute");
		if (this._els.type.mute.checked)
			this._els.type.mute.dispatchEvent(new Event('input', { 'bubbles': true }));
		this._els.source.value = this._settings.getProperty("source", undefined);
		this._els.style.value = this._settings.getProperty("style", "static");
		this._els.step.value = this._settings.getProperty("step", 0.0);
		this._els.volume.value = this._settings.getProperty("volume", 0.0);
		this._els.mode.value = this._settings.getProperty("mode", "toggle");

	}

	reset_modes(){
		if(this._settings.isInMultiAction == this._inMultiAction){
			return;
		}
		this._inMultiAction = this._settings.isInMultiAction;

		while (this._els.mode.firstElementChild) {
			this._els.mode.removeChild(this._els.mode.firstElementChild);
		}

		let list;
		if (this._settings.isInMultiAction === false) {
			list = [["toggle", "Toggle Mute".lox()], ["mute", "Push to Mute".lox()], ["talk", "Push to Talk".lox()]]
		} else {
			list = [["toggle", "Toggle Mute".lox()], ["setmute", "Mute".lox()], ["setunmute", "Unmute".lox()]]
		}
		let selected = this._settings.getProperty("mode", list[0][0]);
		for(const item of list){
			if(item[0] == selected){
				selected = "";
				item.push(true);
			} else {
				item.push(false);
			}
		}
		if (selected != ""){
			list[0][2] = true;
		}

		for(const item of list){
			let e = document.createElement("option");
			e.textContent = item[1].truncateOption();
			e.value = item[0];
			e.selected = item[2];
			this._els.mode.appendChild(e);
		}
	}

	sources_clear() {
		while (this._els.source.firstElementChild) {
			this._els.source.removeChild(this._els.source.firstElementChild);
		}
	}

	sources_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.source.appendChild(e);
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

		// data.list holds an ordered Object, which needs to be converted to an array.
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
			this._have_settings = true;
			this.apply_settings();
		} else {
			throw Error("Missing parameters");
		}
	}

	_on_rpc_close(event) {
		event.preventDefault();
		this._have_obs = false;
		this.validate();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this._have_obs = true;
		this._have_sources = false;
		this.sources_reset();
		this.validate();
	}

	_on_rpc_sources(event) {
		event.preventDefault();
		this._have_sources = true;
		this.sources_update(event.data.parameters());
		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //
	_onTypeChange(event) {
		this._settings.type = event.target.value;
		this.notify("settings", this._settings);
	}

	_onTypeInput(event) {
		if (this._els.type.set.checked) {
			this._els.styleContainer.style.display = "none";
			this._els.stepContainer.style.display = "none";
			this._els.volumeContainer.style.display = "";
			this._els.modeContainer.style.display = "none";
		} else if (this._els.type.adjust.checked) {
			if (this._settings.isInMultiAction === true) {
				this._els.styleContainer.style.display = "none";
			} else {
				this._els.styleContainer.style.display = "";
			}
			this._els.stepContainer.style.display = "";
			this._els.volumeContainer.style.display = "none";
			this._els.modeContainer.style.display = "none";
		} else if (this._els.type.mute.checked) {
			this._els.styleContainer.style.display = "none";
			this._els.stepContainer.style.display = "none";
			this._els.volumeContainer.style.display = "none";
			this._els.modeContainer.style.display = "";
		}
	}

	_onSourceChange(event) {
		this._settings.source = event.target.value;
		this.notify("settings", this._settings);
	}

	_onStyleChange(event) {
		this._settings.style = event.target.value;
		this.notify("settings", this._settings);
	}

	_onStepChange(event) {
		this._settings.step = parseFloat(event.target.value);
		this.notify("settings", this._settings);
	}

	_onVolumeChange(event) {
		this._settings.volume = parseFloat(event.target.value);
		this.notify("settings", this._settings);
	}

	_onModeChange(event) {
		this._settings.mode = event.target.value;
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new SourceAudioMuteInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
