// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SceneCollectionInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			collection: document.querySelector("#collection"),
			collections: document.querySelector("#collection .sdpi-item-value"),
		};

		this._settings = {};

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_collections = this.initDep("rpc.collections");

		this.initDontBlock("rpc.close");

		this._els.collections.addEventListener("change", (event) => {
			this._on_collection_changed(event);
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

		this.addEventListener(this._dep_collections, (ev) => {
			this._on_rpc_collections(ev);
		});
		this.addEventListener("rpc.collection", (ev) => {
			this._on_rpc_collection(ev);
		});

		this.collections_reset();
		this.check_status();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Internals
	// ---------------------------------------------------------------------------------------------- //
	check_status() {
		if (!this.haveDep(this._dep_settings)) {
			this.show_processing_overlay("Waiting for settings...".lox());
		} else if (!this.haveDep(this._dep_obs)) {
			this.show_processing_overlay("Waiting for OBS...".lox());
		} else if (!this.haveDep(this._dep_collections)) {
			this.show_processing_overlay("Waiting for collections...".lox());
		} else {
			this.hide_overlays();
		}
	}

	apply_settings() {
		this._els.collections.value = this._settings.collection;
	}

	collections_clear() {
		while (this._els.collections.firstElementChild) {
			this._els.collections.removeChild(this._els.collections.firstElementChild);
		}
	}
	collections_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.collections.appendChild(e);
	}

	collections_reset() {
		this.collections_clear();
		if (this._settings.collection !== undefined) {
			this.collections_add(`[${this._settings.collection}]`, this._settings.collection, true, true);
		}
		this.apply_settings();
	}

	collections_update(data) {
		this.collections_clear();

		// data.list holds an ordered Object, which needs to be converted to an array.
		let collections = [];
		for (let item of Object.entries(data.list)) {
			collections.push(item[1]);
		}

		// Does the set contain the selected?
		if (!collections.includes(this._settings.collection)) {
			// If not add it as a special unselectable entry.
			if (this._settings.collection !== undefined) {
				this.collections_add(`[${this._settings.collection}]`, this._settings.collection, true, true);
			}
		}

		// Add all to the list.
		for (let collection of collections) {
			this.collections_add(collection, collection, false);
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

	_on_rpc_collections(event) {
		event.preventDefault();
		this.collections_update(event.data.parameters());
		this.check_status();
	}

	_on_rpc_collection(event) {
		event.preventDefault();
		this.check_status();
	}

	_on_collection_changed(event) {
		this._settings.collection = event.target.value;
		this.notify("settings", this._settings);
		this.call("collection", (res, err) => {
			this.check_status();
		}, {
			"name": this._settings.collection,
		});
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new SceneCollectionInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
