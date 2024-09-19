/** The entirety of the obs.scene API
 *
 * TODO:
 * - Determine if these events are useful:
 *   - item_select
 *   - item_deselect
 *   - item_locked
 *   - item_transform
 *   - reorder
 *   - refresh
 * - Handle scene collection changes gracefully.
 */



class obs_scene_api extends EventTarget {
	constructor(obs) {
		super();

		// Internals
		this._obs = obs;

		//this._debounce_items = new debouncer(50);
		//this._debounce_enumerate = new debouncer(50);
		//this._debounce_enumerate_list = new Set();

		// Data
		this._scenes = new Map();

		{ // Listeners
			this.obs.addEventListener("open", (ev) => {
				this._on_obs_open(ev);
			}, true);
			this.obs.addEventListener("close", (ev) => {
				this._on_obs_close(ev);
			}, true);

			this.obs.addEventListener("obs.source.event.create", (ev) => {
				this._on_obs_source_event_create(ev);
			}, true);
			this.obs.addEventListener("obs.source.event.destroy", (ev) => {
				this._on_obs_source_event_destroy(ev);
			}, true);
			this.obs.addEventListener("obs.source.event.rename", (ev) => {
				this._on_obs_source_event_rename(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.reorder", (ev) => {
				this._on_obs_scene_event_reorder(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.item.add", (ev) => {
				this._on_obs_scene_event_item_add(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.item.remove", (ev) => {
				this._on_obs_scene_event_item_remove(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.item.locked", (ev) => {
				this._on_obs_scene_event_item_locked(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.item.visible", (ev) => {
				this._on_obs_scene_event_item_visible(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.item.transform", (ev) => {
				this._on_obs_scene_event_item_transform(ev);
			}, true);
			this.obs.addEventListener("obs.scene.event.enumerate_required", (ev) => {
				this._on_obs_enumerate_required(ev);
			}, true);
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Map of all currently known scenes.
	 */
	get scenes() {
		return new Map(this._scenes);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	enumerate() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			throw new Error("OBS Studio is not connected.".lox());
		}

		if (this._enumeration) {
			return this._enumeration;
		}

		// Enumerate Sources
		this._enumeration = new Promise((resolve, reject) => {
			let promises = [];
			this.obs.call("obs.source.enumerate", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (Array.isArray(result)) {
					// Update our Map of known Sources.
					let scenes = new Map();
					for (let state of result) {
						let scene = null;

						// Skip everything which isn't a scene or group.
						if (!["scene", "group"].includes(state.id_unversioned))
							continue;

						// Try and find if we already know of a source by a given name.
						if (this._scenes.has(state.name)) {
							scene = this._scenes.get(state.name);
							if (!scene.valid) // Ensure that the source is still valid.
								scene = null;
						}

						// If we don't, create a new one.
						if (scene === null) {
							scene = new obs_scene(this.obs, this, state.name, (state.id_unversioned === "group"));
						}
						promises.push(scene.enumerate());

						// Add it to the list of sources.
						scenes.set(scene.name, scene);
					}
					this._scenes = scenes;

					// Signal anyone listening that the list of Source has changed.
					this._event_scenes();

					Promise.all(promises).then(() => {
						this._event_scenes();

						resolve();
					});
				} else {
					reject();
					return;
				}
			});
		}).finally(() => {
			this._enumeration = undefined;
		});

		return this._enumeration;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	/** scenes
	 *
	 * @argument data A map of all known scenes.
	 */
	_event_scenes() {
		let ev = new Event("scenes", { "bubbles": true, "cancelable": true });
		ev.data = this.scenes;
		this.dispatchEvent(ev);
	}

	_event_items() {
		//this._debounce_items.call(() => {
		let ev = new Event("items", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
		//})
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

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_obs_open(ev) {
		ev.preventDefault();

		// Refresh all scenes.
		this._scenes.clear();
		this.enumerate();
	}

	_on_obs_close(ev) {
		ev.preventDefault();
		this._scenes.clear();
		this._event_scenes();
	}

	_on_obs_enumerate_required(ev) {
		ev.preventDefault();

		// Refresh all scenes.
		this._scenes.clear();
		this.enumerate().then(() => {
			for (const scene of this._scenes) {
				scene[1]._enumerate();
			}
		});
	}

	_on_obs_source_event_create(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();

		// Ignore anything that is not classified as a scene.
		if (prms["type"] !== "scene") {
			return;
		}

		// Create a new scene object and track it.
		let scene = new obs_scene(this.obs, this, prms["name"], (prms["id_unversioned"] === "group"));
		this._scenes.set(prms["name"], scene);
		this._event_scenes();
	}

	_on_obs_source_event_destroy(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();

		// Ignore renames for filters, or other contained objects.
		if (Array.isArray(prms["source"])) {
			return;
		}

		// Do we know about this source? (Is it a scene?)
		if (this._scenes.has(prms["source"])) {
			let scene = this._scenes.get(prms["source"]);
			this._scenes.delete(prms["source"]);
			scene._on_obs_source_event_destroy(ev);

			// Inform about scene list changes.
			this._event_scenes();
		}
	}

	_on_obs_source_event_rename(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();

		// Ignore renames for filters, or other contained objects.
		if (Array.isArray(args["source"])) {
			return;
		}
		// Pass down the rename event to all scenes.
		for (let scene of this._scenes) {
			scene[1]._on_obs_source_event_rename(ev);
		}

		// If this affects us, update our list of scenes.
		if (typeof args.source == "string") {
			// Move the scene to a different name.
			this._scenes = this._scenes.replaceAt(args.from, args.to);

			// Signal anyone listening that the list of scenes has changed.
			//this._event_scenes();
			this._event_renamed(args.from, args.to);
		}
	}

	_on_obs_scene_event_reorder(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();

		const scene = this._scenes.get(prms.scene);
		const original_items = scene.items;

		const items = new Map();
		for (const id of prms.items) {

			if (!Array.isArray(id)) {
				const item = original_items.get(id);
				item._scene = scene;
				items.set(id, item);
			} else if (id.length > 0) {
				const group_item = original_items.get(id[0]);
				const group = this._scenes.get(group_item.name);
				if (!group) {
					// Bad data sent from the plugin? Maybe a race condition?
					continue;
				}
				items.set(id[0], group_item);
				const new_group_items = new Map();
				for (const group_id of id) {
					if (group_id === id[0]) {
						continue;
					}
					const item = original_items.get(group_id);
					item._scene = group;
					new_group_items.set(group_id, item);
				}
				group._items = new_group_items;
				group._event_items();
			}
		}
		scene._items = items;
		scene._event_items();
	}

	_on_obs_scene_event_item_add(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();
		let scene = prms["item"][0];
		if (this._scenes.has(scene)) {
			this._scenes.get(scene)._on_obs_scene_event_item_add(ev);
		}
	}

	_on_obs_scene_event_item_remove(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();
		let scene = prms["item"][0];
		if (this._scenes.has(scene)) {
			this._scenes.get(scene)._on_obs_scene_event_item_remove(ev);
		}
	}

	_on_obs_scene_event_item_locked(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();
		let scene = prms["item"][0];
		if (this._scenes.has(scene)) {
			this._scenes.get(scene)._on_obs_scene_event_item_locked(ev);
		}
	}

	_on_obs_scene_event_item_visible(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();
		let scene = prms["item"][0];
		if (this._scenes.has(scene)) {
			this._scenes.get(scene)._on_obs_scene_event_item_visible(ev);
		}
	}

	_on_obs_scene_event_item_transform(ev) {
		ev.preventDefault();
		let prms = ev.data.parameters();
		let scene = prms["item"][0];
		if (this._scenes.has(scene)) {
			this._scenes.get(scene)._on_obs_scene_event_item_transform(ev);
		}

		// Hack to work around the fact that item_add and item_remove aren't issued
		/*this._debounce_enumerate_list.add(scene);
		this._debounce_enumerate.call(
			() => this.enumerate().
				then(() => {
					for (const scene of this._debounce_enumerate_list) {
						if (this._scenes.has(scene)) {
							this._scenes.get(scene).enumerate();
						}
					}
					this._debounce_enumerate_list.clear();
				})
		);*/
	}

}

class obs_scene extends EventTarget {
	constructor(obs, api, name, is_group) {
		super();

		// Internals
		this._obs = obs;
		this._api = api;
		this._valid = true;
		this._name = name;
		this._is_group = is_group;

		// items
		this._items = new Map();

		{ // Listeners
			this.obs.addEventListener("close", (ev) => {
				this._on_obs_close(ev);
			}, true);
		}

		// Automatically enumerate scene items.
		this.enumerate();
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

	/** Is the scene object still valid?
	 *
	 */
	get valid() {
		return this._valid;
	}

	/** The unique name of the scene.
	 *
	 */
	get name() {
		if (!this.valid) {
			throw new ReferenceError("The source is no longer valid.".lox());
		}
		return this._name;
	}

	/** Is the scene a group?
	 *
	 */
	get group() {
		if (!this.valid) {
			throw new ReferenceError("The source is no longer valid.".lox());
		}
		return this._is_group;
	}

	/** Map of only top-level contained items.
	 *
	 * @return Map<number, obs_scene_item> Map of scene items.
	 */
	get items() {
		if (!this.valid) {
			throw new ReferenceError("The source is no longer valid.".lox());
		}
		return new Map(this._items);
	}

	/** Map of all currently contained items.
	 *
	 * @return Map<number, obs_scene_item> Map of scene items.
	 */
	get all_items() {
		if (!this.valid) {
			throw new ReferenceError("The source is no longer valid.".lox());
		}

		let items = new Map();
		for (let item of this._items) {
			items.set(item[0], item[1]);
			if (!item[1].group) continue;

			let scene = this.api.scenes.get(item[1].name);
			if (!scene) continue;

			for (let gitem of scene.items) {
				items.set(gitem[0], gitem[1]);
			}
		}
		return items;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	enumerate() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			throw new Error("OBS Studio is not connected.".lox());
		}

		if (this._enumeration) {
			return this._enumeration;
		}

		// Enumerate Sources
		this._enumeration = new Promise((resolve, reject) => {
			this.obs.call("obs.scene.items", (result, error) => {
				// The reply may happen after other notifications, so we must
				// ensure that data is not duplicated and instead re-used.
				if (error !== undefined) {
					reject(error);
					return;
				} else if (Array.isArray(result)) {
					// Update our Map of known Sources.
					let items = new Map();
					for (let state of result) {
						let item = new obs_scene_item(this.obs, this, state);

						// Add the item to the new map.
						items.set(item.id, item);
					}
					this._items = items;

					// Signal anyone listening that the list of Source has changed.
					this._event_items();

					resolve();
				} else {
					reject();
					return;
				}
			}, {
				scene: this.name,
			});
		}).finally(() => {
			this._enumeration = undefined;
		});

		return this._enumeration;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	_event_status() {
		let ev = new Event("status", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	_event_rename(old_name, new_name) {
		let ev = new Event("rename", { "bubbles": true, "cancelable": true });
		ev.data = [old_name, new_name];
		this.dispatchEvent(ev);
	}

	_event_items() {
		this._api._event_items();
		let ev = new Event("items", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_obs_close(ev) {
		this._on_obs_source_event_destroy(ev);
	}

	_on_obs_source_event_destroy(ev) {
		this._valid = false;
		this._event_status();
		for (let item of this._items) {
			item[1]._on_obs_scene_event_item_remove(ev);
		}
	}

	_on_obs_source_event_rename(ev) {
		let args = ev.data.parameters();
		// Check if the name belongs to us.
		if (this._name == args["from"]) {
			this._name = args["to"];
			this._event_rename(args.from, args.to);
		}
		// Check if any known item has this name.
		for (let item of this._items) {
			if (item[1].name == args["from"]) {
				item[1]._on_obs_source_event_rename(ev);
			}
		}
	}

	_on_obs_scene_event_item_add(ev) {
		let args = ev.data.parameters();
		let item = new obs_scene_item(this.obs, this, args.state);
		this._items.set(item.id, item);
		this._event_items();
	}

	_on_obs_scene_event_item_remove(ev) {
		let args = ev.data.parameters();
		let item = this._items.get(args["item"][2]);
		if (item !== undefined) {
			this._items.delete(item.id);
			item._on_obs_scene_event_item_remove(ev);
			this._event_items();
		}
	}

	_on_obs_scene_event_item_locked(ev) {
		let args = ev.data.parameters();
		let item = this._items.get(args["item"][2]);
		if (item !== undefined) {
			item._on_obs_scene_event_item_locked(ev);
		}
	}

	_on_obs_scene_event_item_visible(ev) {
		let args = ev.data.parameters();
		let item = this._items.get(args["item"][2]);
		if (item !== undefined) {
			item._on_obs_scene_event_item_visible(ev);
		}
	}

	_on_obs_scene_event_item_transform(ev) {
		let args = ev.data.parameters();
		let item = this._items.get(args["item"][2]);
		if (item !== undefined) {
			item._on_obs_scene_event_item_transform(ev);
		}
	}
}

class obs_scene_item extends EventTarget {
	// Contains:
	// - name
	// - transform
	// - status
	//   - locked
	//   - visible
	constructor(obs, scene, state) {
		super();

		// Internals
		this._obs = obs;
		this._scene = scene;
		this._valid = true;

		// Data
		this._id = state.id;
		this._name = state.name;
		this._group = state.group;
		this._visible = state.visible;
		this._locked = state.locked;
		this._transform = state.transform;

		{ // Listeners
			this.obs.addEventListener("close", (ev) => {
				this._on_obs_close(ev);
			}, true);
		}
	}

	update(state) {
		// Hack: Update sceneitem info. When changing a scene collection,
		// our scene item info is polluted with incorrect visible/locked flag
		// since they just get stuck with default values on create and we
		// don't get separate updates for the flags after the fact
		this._visible = state.visible;
		this._locked = state.locked;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Is this object still a valid representation of a Scene Item?
	 *
	 * A number of things can happen that could cause an object to be invalid.
	 *
	 */
	get valid() {
		return this._valid;
	}

	/** Parent Scene
	 */
	get scene() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._scene;
	}

	/** Unique Identifier for this scene item.
	 *
	 * Uniqueness only guaranteed within the same scene.
	 */
	get id() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._id;
	}

	/** The name of the source this item represents.
	 */
	get name() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._name;
	}

	/** Is this a group or just a normal item?
	 */
	get group() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._group;
	}

	/** Is the item locked?
	 */
	get locked() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._locked;
	}

	/** Is the item visible?
	 */
	get visible() {
		if (!this.valid)
			throw ReferenceError("Source is invalid.".lox());
		return this._visible;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	set_visible(state) {
		// Is this object still valid?
		if (!this.valid) {
			return new Promise((resolve, reject) => {
				reject(new ReferenceError("Source is invalid.".lox()));
			});
		}

		// Are the parameters of the correct type?
		if ((typeof state) != "boolean") {
			return new Promise((resolve, reject) => {
				reject(new TypeError("'state' must be boolean"));
			});
		}

		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		if (state == this.visible) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.scene.item.visible", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else {
					reject(error);
				}
			}, {
				item: [this.scene.name, this.name, this.id],
				visible: state
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	_event_status() {
		let ev = new Event("status", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	_event_rename(old_name, new_name) {
		let ev = new Event("rename", { "bubbles": true, "cancelable": true });
		ev.data = [old_name, new_name];
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_obs_close(ev) {
		this._on_obs_scene_event_item_remove(ev);
	}

	_on_obs_source_event_rename(ev) {
		let prms = ev.data.parameters();
		if (this._name == prms["from"]) {
			let old_name = this.name;
			this._name = prms["to"];
			this._event_rename(old_name, this.name);
		}
	}

	_on_obs_scene_event_item_remove(ev) {
		this._valid = false;
		this._event_status();
	}

	_on_obs_scene_event_item_locked(ev) {
		let prms = ev.data.parameters();
		this._locked = prms["state"]["locked"];
		this._event_status();
	}

	_on_obs_scene_event_item_visible(ev) {
		let prms = ev.data.parameters();
		this._visible = prms["state"]["visible"];
		this._event_status();
	}

	_on_obs_scene_event_item_transform(ev) {
		let prms = ev.data.parameters();
		this._transform = prms["state"]["transform"];
		this._event_status();
	}
}
