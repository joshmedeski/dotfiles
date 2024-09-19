// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class ProfileInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			profile: document.querySelector("#profile"),
			profiles: document.querySelector("#profile .sdpi-item-value"),
		};

		this._settings = {};

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_profiles = this.initDep("rpc.profiles");

		this.initDontBlock("rpc.close");

		this._els.profiles.addEventListener("change", (event) => {
			this._on_profile_changed(event);
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

		this.addEventListener(this._dep_profiles, (ev) => {
			this._on_rpc_profiles(ev);
		});
		this.addEventListener("rpc.profile", (ev) => {
			this._on_rpc_profile(ev);
		});

		this.profiles_reset();
		this.check_status();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Internals
	// ---------------------------------------------------------------------------------------------- //
	check_status() {
		if (!this.haveDep(this._dep_obs)) {
			this.show_processing_overlay("Waiting for OBS...".lox());
		} else if (!this.haveDep(this._dep_settings)) {
			this.show_processing_overlay("Waiting for settings...".lox());
		} else if (!this.haveDep(this._dep_profiles)) {
			this.show_processing_overlay("Waiting for profiles...".lox());
		} else {
			this.hide_overlays();
		}
	}

	apply_settings() {
		this._els.profiles.value = this._settings.profile;
	}

	profiles_clear() {
		while (this._els.profiles.firstElementChild) {
			this._els.profiles.removeChild(this._els.profiles.firstElementChild);
		}
	}
	profiles_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.profiles.appendChild(e);
	}

	profiles_reset() {
		this.profiles_clear();
		if (this._settings.profile !== undefined) {
			this.profiles_add(`[${this._settings.profile}]`, this._settings.profile, true, true);
		}
		this.apply_settings();
	}

	profiles_update(data) {
		this.profiles_clear();

		// data.list holds an ordered Object, which needs to be converted to an array.
		let profiles = [];
		for (let item of Object.entries(data.list)) {
			profiles.push(item[1]);
		}

		// Does the set contain the selected?
		if (!profiles.includes(this._settings.profile)) {
			// If not add it as a special unselectable entry.
			if (this._settings.profile !== undefined) {
				this.profiles_add(`[${this._settings.profile}]`, this._settings.profile, true, true);
			}
		}

		// Add all to the list.
		for (let profile of profiles) {
			this.profiles_add(profile, profile, false);
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
		this.check_status();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this.check_status();
	}

	_on_rpc_profiles(event) {
		event.preventDefault();
		this.profiles_update(event.data.parameters());
		this.check_status();
	}

	_on_rpc_profile(event) {
		event.preventDefault();
		this.check_status();
	}

	_on_profile_changed(event) {
		this._settings.profile = event.target.value;
		this.notify("settings", this._settings);
		this.call("profile", (res, err) => {
			this.check_status();
		}, {
			"name": this._settings.profile,
		});
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new ProfileInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
