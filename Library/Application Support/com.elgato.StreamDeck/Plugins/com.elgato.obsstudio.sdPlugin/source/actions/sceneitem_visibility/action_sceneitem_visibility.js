// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Scene Item Visibility Action
- Toggle the visibility of an item in a scene.
- User can select the scene and item for which this state change should happen.

States:
- Enabled: The item is visible and exists, the scene exists, and the collection matches.
- Disabled: The item is invisible or does not exist, or the scene does not exist, or the scene collection does not exist.

State Progression:
- keyUp:
	1. Verify that the collection matches, the scene exists, and the item exists, otherwise break and show error.
	2. If the item is invisible, make it visible then become "Enabled", and show ok then break.
	3. If the item is visible, make it invisible then become "Disabled", and show ok then break.
- refresh:
	1. Check if OBS is connected, if not become "Disabled" and break.
	2. Check if the collection matches, if not become "Disabled" and break.
	3. Check if the scene and item exist, if not become "Disabled" and break.
	4. Check if the item is visible, if not become "Disabled" and break.
	5. Become "Enabled".
- event.visible:
	2. If the item is visible then become "Enabled".
	3. If the item is invisible then become "Disabled".
*/

/* Settings:
 * - collection: {string} Active collection when the item was selected.
 * - scene: {string} Name of the scene in which the scene item is. Might be dirtied by user mutations.
 * - toplevelscene: {string} Name of the top level scene where the scene item actually is.
 * - sceneitemscene: {string} Actual name of the scene or group in which the scene item is.
 * - sceneitemid: {number} Unique Item id in the scene.
 * - sceneitemname: {string} Buffered name of the selected scene item if it doesn't exist.
 */

class SceneItemVisibilityAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.source");

		// APIs
		this._api_scenecollection = this.obs.frontend_scenecollection;
		this._api_scene = this.obs.scene_api;
		this._api_scene_fe = this.obs.frontend_scene;
		this._api_source = this.obs.source_api;

		this._refresh_debouncer = new debouncer(10);

		this.registerNamedState("active", 0);
		this.registerNamedState("inactive", 1);

		{ // RPC
			this.addEventListener("rpc.collection", (event) => {
				this._on_rpc_collection(event);
			});
			this.addEventListener("rpc.scene", (event) => {
				this._on_rpc_scene(event);
			});
			this.addEventListener("rpc.settings", (event) => {
				this._on_rpc_settings(event);
			});
		}

		{ // Listeners
			// Stream Deck
			this.addEventListener("willAppear", (event) => {
				this._on_willAppear(event);
			});
			this.addEventListener("propertyInspectorDidAppear", (event) => {
				this._on_propertyInspectorDidAppear(event);
			});
			this.addEventListener("keyDown", (event) => {
				this._on_pressed(event);
			});
			this.addEventListener("keyUp", (event) => {
				this._on_released(event);
			});

			// OBS
			this.obs.addEventListener("open", (event) => {
				this._on_obs_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._on_obs_close(event);
			});
			this.obs.addEventListener("obs.source.event.rename", (event) => {
				this._on_scene_items_changed(event);
			});
			this.obs.addEventListener("obs.scene.event.item.add", (event) => {
				this._on_scene_items_changed(event);
			});
			this.obs.addEventListener("obs.scene.event.item.remove", (event) => {
				this._on_scene_items_changed(event);
			});
			this.obs.addEventListener("obs.scene.event.item.visible", (event) => {
				this._on_scene_items_changed(event);
			});

			// Scene Collection
			this._api_scenecollection.addEventListener("collections", (event) => {
				this._on_collections_changed(event);
			});
			this._api_scenecollection.addEventListener("collection", (event) => {
				this._on_collection_changed(event);
			});
			this._api_scenecollection.addEventListener("renamed", (event) => {
				this._on_collection_renamed(event);
			});

			// Scene API
			this._api_scene_fe.addEventListener("scenes", (event) => {
				this._on_scenes_changed(event);
			});
			this._api_scene.addEventListener("scenes", (event) => {
				this._on_scenes_changed(event);
			});
			this._api_scene.addEventListener("items", (event) => {
				this._on_scene_items_changed(event);
			});
			this._api_scene.addEventListener("renamed", (event) => {
				this._on_scene_renamed(event);
			});
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Refresh the status of a specific context, or all contexts if none specified.
	 *
	 * @param {any} context The context to refresh, or undefined if refreshing all contexts.
	 */
	refresh(context) {
		if (context !== undefined) {
			let settings = this.settings(context);

			let setAborted = ()=>{
				this.setState(context, EActionStateOff);
			}

			if (this.status(context).isInMultiAction !== true) {
				this.setTitle(context, 0, settings.sceneitemname);
				this.setTitle(context, 1, settings.sceneitemname);
				setAborted = ()=>{
					this.setState(context, EActionStateOff);
					if (settings.icon){
						this.setImage(context, "active", "resources/actions/scene.item.visibility/sources/" + settings.icon + "/on.png");
						this.setImage(context, "inactive", "resources/actions/scene.item.visibility/sources/" + settings.icon + "/off.png");
					} else {
						this.setImage(context, "active");
						this.setImage(context, "inactive");
					}
				}
			}


			// Disable the item if OBS is not connected.
			if (!this.obs.connected()) {
				setAborted();
				return;
			}

			// Check if we are in the correct collection.
			if (this._api_scenecollection.collection !== settings.collection) {
				setAborted();
				return;
			}

			// Check if the scene exists.
			let scene = this._api_scene.scenes.get(settings.sceneitemscene);
			if (scene === undefined) {
				setAborted();
				return;
			}

			// Check if the scene item exists.
			let item = scene.items.get(settings.sceneitemid);
			if (item === undefined) {
				setAborted();
				return;
			}

			let settingsChanged = false;

			if (this.status(context).isInMultiAction !== true){
				let source = this._api_source.sources.get(item.name)
				if (source !== undefined){
					let icon = this._api_source.icon_by_id(source.id);
					if (settings.icon != icon){
						settings.icon = icon;
						settingsChanged = true;
					}
					this.setImage(context, "active", "resources/actions/scene.item.visibility/sources/" + icon + "/on.png");
					this.setImage(context, "inactive", "resources/actions/scene.item.visibility/sources/" + icon + "/off.png");
				}
			}

			if (settings.sceneitemname != item.name) {
				settings.sceneitemname = item.name;
				settingsChanged = true;
			}

			if ( settingsChanged){
				this._apply_settings(context, settings);
			}


			// Update context according to current item state.
			this.setState(context, item.visible ? EActionStateOn : EActionStateOff);
		} else {
			// Refresh all contexts.
			this._refresh_debouncer.call(()=>{
				for (let ctx of this.contexts.keys()) {
					this.refresh(ctx);
				}
			})
		}
	}

	/** Apply and store settings to a context.
	 *
	 */
	_apply_settings(context, settings) {
		// 1. Try to migrate any old settings to the new layout.
		this._migrate_settings(settings);

		// 2. Apply default settings to any missing entries.
		this._default_settings(settings);

		// 3. Store the settings to Stream deck.
		this.settings(context, settings);

		// 4. Refresh the context.
		this.refresh(context);

		// 5. Update the open inspector if it is for this action.
		if (this.inspector == context) {
			this.notify(this.inspector, "settings", settings);
		}
	}

	/** Migrate settings from older versions to newer versions.
	 *
	 */
	_migrate_settings(settings) {
		// Migrate required information over to the new settings.

		// settings.collection
		if (typeof (settings.sceneCollection) !== "undefined") {
			settings.collection = String(settings.sceneCollection);
			delete settings.sceneCollection;
			if (settings.collection == "") {
				delete settings.collection;
			}
		}

		// settings.scene
		if (typeof (settings.sceneId) !== "undefined") {
			settings.scene = String(settings.sceneId);
			delete settings.sceneId;
			if (settings.scene == "") {
				delete settings.scene;
			}

			// Strip collection name from scene.
			if (settings.scene.startsWith(settings.collection)) {
				settings.scene = settings.scene.substring(settings.collection.length);
			}
		}

		// settings.sceneitemid
		if (typeof (settings.sceneItemId) !== "undefined") {
			settings.sceneitemid = parseInt(`${settings.sceneItemId}`, 10);
			if (isNaN(settings.sceneitemid)) {
				settings.sceneitemid = undefined;
			}
			settings.sceneitemname = "Unknown (Load collection %s to load)".lox().sprintf(settings.collection);
			settings.sceneitemscene = settings.scene;
			delete settings.sceneItemId;
		}

		// settings.sceneitemname
		if ((typeof (settings.sourceId) !== "undefined") && (typeof (settings.sceneitemid) === "number")) {
			settings.sceneitemname = settings.sourceId;
			delete settings.sourceId;
		}

		// settings.sceneitemscene
		if (typeof (settings.sceneitemscene) === "undefined") {
			settings.sceneitemscene = settings.scene;
		}
	}

	/** Apply any default settings that may be necessary.
	 *
	 */
	_default_settings(settings) {
		// Can't do anything if OBS Studio is not connected.
		if (!this.obs.connected()) return;

		// settings.collection
		if (typeof (settings.collection) !== "string") {
			settings.collection = this._api_scenecollection.collection;
		}

		if (typeof (settings.scene) !== "string") {
			if (this.obs.connected()) {
				// Pick the first scene we can find.
				let scenes = this._api_scene_fe.scenes;
				if (scenes.size > 0) {
					settings.scene = scenes.values().next().value.name;
				}
			}
		}

		// settings.sceneitemid, settings.sceneitemname, settings.sceneitemscene
		if (typeof (settings.sceneitemid) !== "number") {
			if (this.obs.connected()) {
				// If there is a scene selected, ...
				if (typeof (settings.scene) === "string") {
					let scene = this._api_scene.scenes.get(settings.scene);
					let items = scene.items;
					// ... and it has items in it, ...
					if (items.size > 0) {
						// ... default to it.
						const item = items.keys().next().value;
						settings.sceneitemid = item.id;
						settings.sceneitemscene = settings.scene;
						settings.sceneitemname = item.name;
					}
				}
			}
		}

		// settings.sceneitemscene
		if (typeof (settings.sceneitemscene) !== "string") {
			settings.sceneitemscene = settings.scene;
		}
	}

	_inspector_refresh() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		// Grab relevant information.
		let context = this.inspector;
		let settings = this.settings(context);

		this.call(context, "init_inspector", ()=>{
			// Inform about current settings.
			this.notify(this.inspector, "settings", settings);

			// Perform different tasks depending on if OBS is available or not.
			if (this.obs.connected()) {
				// We've restored connection to OBS Studio.
				this.notify(this.inspector, "open");

				// Inform about current collection.
				this._inspector_refresh_collection();

				// Inform about currently available scenes.
				this._inspector_refresh_scenes();

				// Inform about currently available items.
				this._inspector_refresh_items();
			} else {
				// OBS Studio is currently not available.
				this.notify(this.inspector, "close");
			}
		});
	}

	_inspector_refresh_collections() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		this.notify(this.inspector, "collections", {
			"list": Array.from(this._api_scenecollection.collections)
		});
	}

	_inspector_refresh_collection() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		this.notify(this.inspector, "collection", {
			"collection": this._api_scenecollection.collection
		});
		this._inspector_refresh_scenes();
		this._inspector_refresh_items();
	}

	_inspector_refresh_scenes() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		let scenes = this._api_scene_fe.scenes;
		this.notify(this.inspector, "scenes", {
			"list": Array.from(scenes)
		});
	}

	async _enumerate_tree(scene, itemMap, tree) {
		// names for entries should be:
		// [group > ] item name

		await scene.enumerate();
		for (let item of scene.items) {
			// This is reversed as we reverse the Map later, so it ends up correct.
			if (item[1].group === true) {
				let new_scene = this._api_scene.scenes.get(item[1].name);
				if (new_scene) {
					await this._enumerate_tree(new_scene, itemMap, [...tree, new_scene.name]);
				}
			}

			itemMap.set(
				JSON.stringifyEx([scene.name, item[0]]),
				[...tree, item[1].name].reduce((previousValue, currentValue, currentIndex, array) => {
					if (previousValue) {
						return `${previousValue} 〉 ${currentValue}`;
					} else {
						return currentValue;
					}
				})
			);
		}
	}

	_inspector_refresh_items() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		let context = this.inspector;
		let settings = this.settings(context);

		// Check if the scene exists.
		let scene = this._api_scene.scenes.get(settings.scene);
		if (scene === undefined) {
			this.notify(this.inspector, "items", {
				"list": new Map(),
			});
			return;
		}

		// Give the Inspector a list of items in the set scene.
		let items = new Map();
		this._enumerate_tree(scene, items, []).then(() => {
			// Reverse to match OBS Studio UI
			let ritems = new Map([...items].reverse());

			this.notify(this.inspector, "items", {
				"list": ritems,
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //

	_on_willAppear(ev) {
		ev.preventDefault();
		let settings = this.settings(ev.context);
		this._apply_settings(ev.context, settings);
	}

	_on_propertyInspectorDidAppear(ev) {
		ev.preventDefault();
		this._inspector_refresh();
	}

	async _on_pressed(ev) {
		ev.preventDefault();

		try {
			let settings = this.settings(ev.context);
			let desiredState = false;
			if (ev.data.payload.isInMultiAction === true) {
				desiredState = (ev.data.payload.userDesiredState === EActionStateOn);
			} else {
				desiredState = (ev.data.payload.state === EActionStateOff);
			}

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				// This also automatically reverts the state of the action.
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if the scene collection is different from the one we expect.
			if (this._api_scenecollection.collection !== settings.collection) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if the scene no longer exists.
			let scene = this._api_scene.scenes.get(settings.sceneitemscene ? settings.sceneitemscene : settings.scene);
			if (scene === undefined) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// Show an alert if the scene item no longer exists.
			let item = scene.items.get(settings.sceneitemid);
			if (item === undefined) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			// If everything went well, try and update the scene item visibility.
			let result = await item.set_visible(desiredState);
			if (item.visible !== desiredState) {
				this.streamdeck.showAlert(ev.context);
			} else {
				if (config.status)
					this.streamdeck.showOk(ev.context);
			}
		} catch (ex) {
			this.streamdeck.showAlert(ev.context);
			return;
		}
	}

	_on_released(ev) {
		ev.preventDefault();
	}

	_on_obs_open(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_on_obs_close(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh();
	}

	_on_collections_changed(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh_collections();
	}

	_on_collection_changed(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh_collection();
	}

	_on_collection_renamed(ev) {
		ev.preventDefault();

		for (let ctx of this.contexts.keys()) {
			let settings = this.settings(ctx);
			if (settings.collection == ev.data.from){
				settings.collection = ev.data.to;
				this.settings(ctx, settings);
			}
			this.refresh(ctx);
			if (ctx == this.inspector){
				this._inspector_refresh_collection();
			}
		}
	}

	_on_scenes_changed(ev) {
		ev.preventDefault();
		this.refresh();
		this._inspector_refresh_scenes();
	}

	_on_scene_items_changed(ev) {
		ev.preventDefault();
		this.refresh();
		//this._inspector_refresh_items();
	}

	_on_scene_renamed(ev) {
		ev.preventDefault();

		for (let ctx of this.contexts.keys()) {
			let settings = this.settings(ctx);
			let update = false;
			if (settings.scene == ev.data.from){
				settings.scene = ev.data.to;
				update = true;
			}
			if (settings.sceneitemscene == ev.data.from){
				settings.sceneitemscene = ev.data.to;
				update = true;
			}
			if (update){
				this.settings(ctx, settings);
			}

			this.refresh(ctx);
			if (ctx == this.inspector){
				this._inspector_refresh();
			}
		}
	}

	async _on_rpc_collection(ev) {
		ev.preventDefault();

		// 1. Check if we are connected with OBS Studio.
		if (!this.obs.connected()) {
			// If not, send an error
			let err = JSONRPCError(EJSONRPCERROR_INTERNAL_ERROR, "Disconnected from OBS Studio.".lox());
			this.reply(this.inspector, rpc.id(), undefined, err.compile());
			return;
		}

		// 2. Change the current scene collection and update scenes.
		let reply = new JSONRPCResponse();
		this._api_scenecollection.switch(ev.data.parameters().name).then((res) => {
			reply.result(res);
			this.reply(ev.extra[0].context, ev.data.id(), reply.compile());
		}, (err) => {
			// TODO: This seems wrong!
			reply.error((new JSONRPCError(EJSONRPCERROR_INTERNAL_ERROR, "RPC call failed.", err)).compile());
			this.reply(ev.extra[0].context, ev.data.id(), reply.compile());
		});
	}

	_on_rpc_scene(ev) {
		ev.preventDefault();
		this._inspector_refresh_items();
	}

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}
}
