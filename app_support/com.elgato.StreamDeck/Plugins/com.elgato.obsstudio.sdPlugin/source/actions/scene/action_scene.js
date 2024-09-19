// Copyright © 2022, Corsair Memory Inc. All rights reserved.

/* Scene Action

Switches the current preview or program scene to the configured scene, leaving
the scene collection as is. If the current preview or program scene is already
the configured one, does nothing.

State:
- Enabled/On if the current preview/program scene matches the configured scene.
- Disabled/Off if the current preview/program scene does not match the configured scene.

*/

class SceneAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.scene");

		// APIs
		this._api_studiomode = this.obs.frontend_studiomode;
		this._api_scene = this.obs.frontend_scene;

		{ // RPC
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

			// Studio Mode
			this._api_studiomode.addEventListener("status", (event) => {
				this._inspector_refresh_studiomode();
			});

			// Scene
			this._api_scene.addEventListener("scenes", (event) => {
				this._on_s_scenes(event);
			});
			this._api_scene.addEventListener("scene", (event) => {
				this._on_s_scene(event);
			});

			this._api_scene.addEventListener("renamed", (event) => {
				this._on_renamed(event);
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

			// Disable the item if OBS is not connected.
			if (!this.obs.connected()) {
				this.setState(context, EActionStateOff);
				return;
			}

			let scene = settings.target == "program" ? this._api_scene.program : this._api_scene.preview;


			this.setTitle(context, 0, settings.scene);
			this.setTitle(context, 1, settings.scene);

			if (scene == settings.scene) {
				this.setState(context, EActionStateOn);
			} else {
				this.setState(context, EActionStateOff);
			}
		} else {
			// Refresh all contexts.
			for (let ctx of this.contexts.keys()) {
				this.refresh(ctx);
			}
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

		let collection = "";
		if (typeof (settings.sceneCollection) !== "undefined") {
			collection = String(settings.sceneCollection);
			delete settings.sceneCollection;
		}

		if (typeof (settings.sceneId) !== "undefined") {
			settings.scene = String(settings.sceneId);
			delete settings.sceneId;

			// Strip collection name from scene.
			if (settings.scene.startsWith(collection)) {
				settings.scene = settings.scene.substring(collection.length);
			}
		}

		if (typeof (settings.sceneItemId) !== "undefined") {
			delete settings.sceneItemId;
		}

		if (typeof (settings.sourceId) !== "undefined") {
			delete settings.sourceId;
		}
	}

	/** Apply any default settings that may be necessary.
	 *
	 */
	_default_settings(settings) {
		// Can't do anything if OBS Studio is not connected.
		if (!this.obs.connected()) return;

		if ((settings.scene === undefined) || (typeof (settings.scene) !== "string")) {
			settings.scene = undefined;
		}

		if ((settings.target === undefined) || (typeof (settings.target) !== "string")) {
			settings.target = "preview";
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

				// Inform about currently available scenes.
				this._inspector_refresh_scenes();

				// Inform about studio mode.
				this._inspector_refresh_studiomode();
			} else {
				// OBS Studio is currently not available.
				this.notify(this.inspector, "close");
			}
		});
	}

	_inspector_refresh_scenes() {
		if (!this.inspector) return;
		this.notify(this.inspector, "scenes", {
			"list": Array.from(this._api_scene.scenes),
		});
	}

	_inspector_refresh_studiomode() {
		if (!this.inspector) return;
		this.notify(this.inspector, "studiomode", {
			"state": this._api_studiomode.enabled
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
		let settings = this.settings(ev.context);

		// 1. Show an alert if OBS Studio is not running or connected.
		if (!this.obs.connected()) {
			// This also automatically reverts the state of the action.
			this.streamdeck.showAlert(ev.context);
			return;
		}

		// 2. Short circuit if the target scene is already active
		if (settings.target == "program") {
			if (this._api_scene.program == settings.scene) {
				return;
			}
		} else {
			if (this._api_scene.preview == settings.scene) {
				return;
			}
		}

		// 3. Change the active scene in Preview or Program.
		try {
			let scene = await this._api_scene.switch(settings.scene, settings.target == "program");
			if (scene != settings.scene) {
				if (config.status) // TODO: Always shown.
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

		this.refresh(ev.context);
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

	_on_s_scenes(ev) {
		ev.preventDefault();
		this._inspector_refresh_scenes();
	}

	_on_s_scene(ev) {
		ev.preventDefault();
		this.refresh();
	}

	_on_renamed(ev) {
		ev.preventDefault();

		for (let ctx of this.contexts.keys()) {
			let settings = this.settings(ctx);
			if (settings.scene == ev.data.from){
				settings.scene = ev.data.to;
				this.settings(ctx, settings);
			}
			if (ctx == this.inspector){
				this._inspector_refresh();
			}
			this.refresh(ctx);
		}
	}

	_on_rpc_settings(event) {
		event.preventDefault();
		let settings = event.data.parameters();
		this._apply_settings(this.inspector, settings);
	}
}
