// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class TransitionInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			transition: document.querySelector("#transition"),
			duration: document.querySelector("#duration"),
			duration_value: document.querySelector("#duration .sdpi-item-value"),
			transitions: document.querySelector("#transition .sdpi-item-value"),
		};
		this._settings = {};

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_transitions = this.initDep("rpc.transitions");

		this.initDontBlock("rpc.close");

		this._transitions = new Map();

		this._els.transitions.addEventListener("change", (event) => {
			this._on_transition_changed(event);
		});
		this._els.duration_value.addEventListener("change", (event) => {
			this._on_duration_changed(event);
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
		this.addEventListener(this._dep_transitions, (event) => {
			this._on_rpc_transitions(event);
		});

		this.transitions_reset();
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
		} else if (!this.haveDep(this._dep_transitions)) {
			this.show_processing_overlay("Waiting for transitions...".lox());
		} else {
			this.hide_overlays();
		}
	}

	apply_settings() {
		this._els.transitions.value = this._settings.transition;
		if (!this._settings.duration) {
			this._els.duration_value.value = "";
		} else {
			this._els.duration_value.value = this._settings.duration;
		}
		if (this._transitions.get(this._settings.transition)) {
			// Fixed duration transition, hide duration
			this._els.duration.style.display = "none";
		} else {
			this._els.duration.style.display = "flex";
		}
	}

	transitions_clear() {
		while (this._els.transitions.firstElementChild) {
			this._els.transitions.removeChild(this._els.transitions.firstElementChild);
		}
	}

	transitions_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.transitions.appendChild(e);
	}

	transitions_reset() {
		this.transitions_clear();
		if (this._settings.transition !== undefined) {
			this.transitions_add(`[${this._settings.transition}]`, this._settings.transition, true, true);
		}
		this.apply_settings();
	}

	transitions_update(data) {
		this.transitions_clear();
		const new_transitions = new Map();

		let transitions = data.list;

		// Does the set contain the selected?
		let included = false;
		for (let transition of transitions) {
			if (transition[0] == this._settings.transition) {
				included = true;
				break;
			}
		}
		if (!included) {
			// If not add it as a special unselectable entry.
			if (this._settings.transition !== undefined) {
				this.transitions_add(`[${this._settings.transition}]`, this._settings.transition, true, true);
			}
		}

		for (let transition of transitions) {
			this.transitions_add(transition[0], transition[0], false);
			new_transitions.set(transition[0], transition[1]);
		}

		this._transitions = new_transitions;

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
		this.transitions_reset();
		this.validate();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this.transitions_reset();
		this.validate();
	}

	_on_rpc_transitions(event) {
		event.preventDefault();
		this.transitions_update(event.data.parameters());
		this.validate();
	}

	_on_transition_changed(event) {
		this._settings.transition = event.target.value;
		this.notify("settings", this._settings);
	}

	_on_duration_changed(event) {
		this._settings.duration = parseInt(event.target.value, 10);
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new TransitionInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
