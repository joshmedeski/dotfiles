// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SceneItemVisibilityInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._els = {
			collection: document.querySelector("#collection"),
			collections: document.querySelector("#collection .sdpi-item-value"),
			scene: document.querySelector("#scene"),
			scenes: document.querySelector("#scene .sdpi-item-value"),
			item: document.querySelector("#item"),
			items: document.querySelector("#item .sdpi-item-value"),
		};
		this._settings = {};
		this._in_correct_scene_collection = false;
		this._active_collection = "";

		this._dep_obs = this.initDep("rpc.open");
		this._dep_settings = this.initDep("rpc.settings");
		this._dep_collection = this.initDep("rpc.collection");
		this._dep_scenes = this.initDep("rpc.scenes");
		this._dep_items = this.initDep("rpc.items");

		this.initDontBlock("rpc.close");

		//this._els.collections.addEventListener("change", (ev) => { this._on_collection_changed(ev); });
		this._els.scenes.addEventListener("change", (ev) => {
			this._on_scene_changed(ev);
		});
		this._els.items.addEventListener("change", (ev) => {
			this._on_item_changed(ev);
		});

		this.addEventListener(this._dep_settings, (ev) => {
			this._on_rpc_settings(ev);
		});
		this.addEventListener("rpc.close", (ev) => {
			this._on_rpc_close(ev);
		});
		this.addEventListener(this._dep_obs, (ev) => {
			this._on_rpc_open(ev);
		});
		this.addEventListener("rpc.collections", (ev) => {
			this._on_rpc_collections(ev);
		});
		this.addEventListener(this._dep_collection, (ev) => {
			this._on_rpc_collection(ev);
		});
		this.addEventListener(this._dep_scenes, (ev) => {
			this._on_rpc_scenes(ev);
		});
		this.addEventListener(this._dep_items, (ev) => {
			this._on_rpc_items(ev);
		});

		this.collections_reset();
		this.scenes_reset();
		this.items_reset();
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
		} else if (!this.haveDep(this._dep_scenes)) {
			this.show_processing_overlay("Waiting for scenes...".lox());
		} else if (!this.haveDep(this._dep_items)) {
			this.show_processing_overlay("Waiting for sources...".lox());
		} else {
			this.hide_overlays();
		}
	}

	apply_settings() {
		if (!this._settings.toplevelscene) {
			this._settings.toplevelscene = this._settings.scene;
		}

		//this._els.collections.value = this._settings.collection;
		this._els.scenes.value = this._settings.scene;
		//this._els.items.value = this._settings.sceneitemid;
		this._els.collections.textContent = this._settings.collection;

		this._in_correct_scene_collection =
			!this._settings.collection ||
			this._settings.collection === this._active_collection;

		if (!this._in_correct_scene_collection) {
			this._els.collections.classList.add("warning");
			this._els.collections.title = "Action is not configured for the active scene collection".lox();

			// If we are not in the same scene collection, select it as an alien entry.
			this._els.items.value = JSON.stringify([this._settings.sceneitemscene, `${this._settings.sceneitemid}`]);
		} else {
			this._els.collections.classList.remove("warning");
			this._els.collections.title = "";

			// If we are in the same scene collection, proceed as normal.
			this._els.items.value = JSON.stringify([this._settings.sceneitemscene, this._settings.sceneitemid]);
		}
	}

	collections_clear() {
		return;
		while (this._els.collections.firstElementChild) {
			this._els.collections.removeChild(this._els.collections.firstElementChild);
		}
	}

	collections_add(name, value, disabled = false, selected = false) {
		return;
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

		// Convert the array into a Set.
		let collections = data.list;

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

	scenes_clear() {
		while (this._els.scenes.firstElementChild) {
			this._els.scenes.removeChild(this._els.scenes.firstElementChild);
		}
	}

	scenes_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.scenes.appendChild(e);
	}

	scenes_reset() {
		this.scenes_clear();
		if (this._settings.scene !== undefined) {
			this.scenes_add(`[${this._settings.scene}]`, this._settings.scene, true, true);
		}
		this.apply_settings();
	}

	scenes_update(data) {
		this.scenes_clear();

		// Convert the array into a Set.
		let scenes = data.list;

		// Does the set contain the selected scene?
		if (this._in_correct_scene_collection && !scenes.includes(this._settings.scene)) {
			// If we're in the correct scene collection, then we should ensure the
			// selected scene actually belongs to the current scene collection and isn't
			// dirty from another collection
			this._settings.scene = this._settings.toplevelscene;
			this.notify("settings", this._settings);
			this.call("scene", (res, err) => {
				this.validate();
			}, {
				"name": this._settings.scene,
			});
		}
		// Check again to see if the scene is present
		if (!scenes.includes(this._settings.scene)) {
			// If not, add it as a special unselectable entry.
			if (this._settings.scene !== undefined) {
				this.scenes_add(`[${this._settings.scene}]`, this._settings.scene, true, true);
			}
		}

		// Add all to the list.
		for (let scene of scenes) {
			this.scenes_add(scene, scene, false);
		}

		// Re-apply settings to elements.
		this.apply_settings();
	}

	items_clear() {
		while (this._els.items.firstElementChild) {
			this._els.items.removeChild(this._els.items.firstElementChild);
		}
	}

	items_add(name, value, disabled = false, selected = false) {
		let e = document.createElement("option");
		e.textContent = name.truncateOption();
		e.value = value;
		e.disabled = disabled;
		e.selected = selected;
		this._els.items.appendChild(e);
	}

	name_bracket_or_unknown() {
		const name = this._settings.sceneitemname;
		if (name === undefined) {
			return "Unknown (Load collection %s to load)".lox().sprintf(this._settings.collection);
		}
		return `[${name}]`;
	}

	items_reset() {
		this.items_clear();
		if ((this._settings.sceneitemscene !== undefined) && (this._settings.sceneitemid !== undefined)) {
			this.items_add(this.name_bracket_or_unknown(),
				JSON.stringifyEx([this._settings.sceneitemscene, `${this._settings.sceneitemid}`]),
				true, true);
		}
		this.apply_settings();
	}

	items_update(data) {
		this.items_clear();

		// data.list is Map[Key, Value], where:
		// - Key is [Scene Name, Scene Item Id]
		// - value is `Item Name`

		// Is the currently selected item in the new list?
		if ((!this._in_correct_scene_collection) || (!data.list.has(JSON.stringifyEx([this._settings.sceneitemscene, this._settings.sceneitemid])))) {
			if ((this._settings.sceneitemscene !== undefined) && (this._settings.sceneitemid !== undefined)) {
				this.items_add(this.name_bracket_or_unknown(),
					JSON.stringifyEx([this._settings.sceneitemscene, `${this._settings.sceneitemid}`]),
					true, true);
			}
		}

		// Add all items to the drop-down.
		for (let item of data.list.entries()) {
			this.items_add(item[1], item[0], false);
		}

		// Re-apply settings to elements.
		this.apply_settings();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_rpc_settings(ev) {
		ev.preventDefault();
		let params = ev.data.parameters();
		if (params) {
			this._settings = params;
			this.apply_settings();
		} else {
			throw Error("Missing parameters");
		}
	}

	_on_rpc_close(ev) {
		ev.preventDefault();
		this.initReset();
		this.validate();
	}

	_on_rpc_open(ev) {
		ev.preventDefault();

		this.collections_reset();
		this.scenes_reset();
		this.items_reset();
		this.validate();
	}

	_on_rpc_collections(ev) {
		ev.preventDefault();
		this.collections_update(ev.data.parameters());
		this.validate();
	}

	_on_rpc_collection(ev) {
		ev.preventDefault();
		this.resetDep(this._dep_scenes);
		this.scenes_reset();
		this.resetDep(this._dep_items);
		this.items_reset();
		const params = ev.data.parameters();
		if (params.collection) {
			this._active_collection = params.collection;
		}
		this.validate();
	}

	_on_rpc_scenes(ev) {
		ev.preventDefault();
		this.scenes_update(ev.data.parameters());
		this.validate();
	}

	_on_rpc_items(ev) {
		ev.preventDefault();
		this.items_update(ev.data.parameters());
		this.validate();
	}

	_on_collection_changed(ev) {
		//this._settings.collection = ev.target.value;
		this.notify("settings", this._settings);
		this.show_processing_overlay("Changing collection...".lox());
		this.call("collection", (res, err) => {
			this.validate();
		}, {
			"name": this._settings.collection,
		});
	}

	_on_scene_changed(ev) {
		this._settings.scene = ev.target.value;
		this.notify("settings", this._settings);
		this.resetDep(this._dep_items);
		this.items_reset();
		this.validate();
		this.call("scene", (res, err) => {
			this.validate();
		}, {
			"name": this._settings.scene,
		});
	}

	_on_item_changed(ev) {
		let key = JSON.parseEx(ev.target.value);
		if (typeof (key[1]) == "number") {
			// Update the settings with the new information.
			this._settings.collection = this._active_collection;
			//this._settings.scene = this._settings.scene;

			this._settings.toplevelscene = this._settings.scene;
			this._settings.sceneitemscene = key[0];
			this._settings.sceneitemid = key[1];
			this._settings.sceneitemname = ev.target[ev.target.selectedIndex].text;
		} else {
			// Don't change things if this is the old value.
		}
		this.notify("settings", this._settings);
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new SceneItemVisibilityInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
