// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SceneInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			scene: document.querySelector("#scene"),
			scenes: document.querySelector("#scene .sdpi-item-value"),
			target: document.querySelector("#target"),
			targets: document.querySelector("#target .sdpi-item-value"),
		};
		this._settings = {};
		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_scenes = this.initDep("rpc.scenes");
		this.initDontBlock("rpc.close");

		this._shadow_scenes = null;

		this._els.scenes.addEventListener("change", (event) => {
			this._on_scene_change(event);
		});
		this._els.targets.addEventListener("change", (event) => {
			this._on_target_change(event);
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
		this.addEventListener(this._dep_scenes, (event) => {
			this._on_rpc_scenes(event);
		});
		this.addEventListener("rpc.studiomode", (event) => {
			this._on_rpc_studiomode(event);
		});

		this.reset_scenes();
		this.validate();
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
		this.validate();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this.reset_scenes();
		this.validate();
	}

	_on_rpc_scenes(event) {
		event.preventDefault();
		const params = event.data.parameters();

		this.scenes(params.list);
		this.validate();
	}

	_on_rpc_studiomode(event) {
		event.preventDefault();
		if (event.data.parameters().state) {
			this._els.target.style.removeProperty("display");
		} else {
			this._els.target.style.setProperty("display", "none");
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Internals
	// ---------------------------------------------------------------------------------------------- //
	validate() {
		if (!this.haveDep(this._dep_obs)) {
			this.show_processing_overlay("Waiting for OBS...".lox());
		} else if (!this.haveDep(this._dep_settings)) {
			this.show_processing_overlay("Waiting for settings...".lox());
		} else if (!this.haveDep(this._dep_scenes)) {
			this.show_processing_overlay("Waiting for scenes...".lox());
		} else {
			this.hide_overlays();
		}
	}

	apply_settings() {
		this._els.targets.value = this._settings.target;
		this._els.scenes.value = this._settings.scene;
	}

	clear_scenes() {
		while (this._els.scenes.firstElementChild) {
			this._els.scenes.removeChild(this._els.scenes.firstElementChild);
		}
	}

	add_scene(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.scenes.appendChild(e);
	}

	reset_scenes() {
		this.clear_scenes();
		if (this._settings.scene) {
			this.add_scene(`[${this._settings.scene}]`, this._settings.scene, true, true);
		}
		this.apply_settings();
	}

	scenes(data) {
		this.clear_scenes();
		this._shadow_scenes = data;

		// Check if the currently selected scene is an option, if not add it.
		let have_setting = false;
		for (let kv of data) {
			if (kv == this._settings.scene) {
				have_setting = true;
			}
		}

		if (!have_setting && this._settings.scene) {
			this.add_scene(`[${this._settings.scene}]`, this._settings.scene, true, true);
		}

		// Add all known scenes to the list.
		for (let kv of data) {
			this.add_scene(kv, kv, false);
		}

		// Re-apply settings to elements.
		this.apply_settings();
	}

	_on_scene_change(event) {
		this._settings.scene = event.target.value;
		this.notify("settings", this._settings);
	}

	_on_target_change(event) {
		this._settings.target = event.target.value;
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new SceneInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
