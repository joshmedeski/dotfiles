// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class SceneCollectionAction extends IAction {
	constructor(controller) {
		super(controller, "com.elgato.obsstudio.scenecollection");

		// APIs
		this._api = this.obs.frontend_scenecollection;

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

			this.addEventListener("rpc.settings", (event) => {
				this._on_rpc_settings(event);
			});

			// OBS
			this.obs.addEventListener("open", (event) => {
				this._on_obs_open(event);
			});
			this.obs.addEventListener("close", (event) => {
				this._on_obs_close(event);
			});

			// Scene collections

			this._api.addEventListener("collections", (event) => {
				this._on_collections_changed(event);
			});
			this._api.addEventListener("collection", (event) => {
				this._on_collection_changed(event);
			});
			this._api.addEventListener("renamed", (event) => {
				this._on_collection_renamed(event);
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

			this.setTitle(context, 0, settings.collection);
			this.setTitle(context, 1, settings.collection);

			// Check if we are in the correct collection.
			if (this._api.collection === settings.collection) {
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
		// No settings to migrate
	}

	/** Apply any default settings that may be necessary.
	 *
	 */
	_default_settings(settings) {
		// Can't do anything if OBS Studio is not connected.
		if (!this.obs.connected()) return;
	}

	_inspector_refresh() {
		// Don't do anything if there is no inspector.
		if (!this.inspector) return;

		const context = this.inspector;

		this.call(context, "init_inspector", ()=>{
			// Grab relevant information.
			let context = this.inspector;
			let settings = this.settings(context);

			// Inform about current settings.
			this.notify(this.inspector, "settings", settings);

			// Perform different tasks depending on if OBS is available or not.
			if (this.obs.connected()) {
				// We've restored connection to OBS Studio.
				this.notify(this.inspector, "open");

				// Inform about currently available collections.
				this._inspector_refresh_collections();
			} else {
				// OBS Studio is currently not available.
				this.notify(this.inspector, "close");
			}
		});
	}

	_inspector_refresh_collections() {
		if (!this.inspector) return;

		// Prevent mangling of Collection ordering by JSON.stringify.
		let names = [];
		for (let collection of this._api.collections) {
			names.push(collection);
		}
		let collections = Object.fromEntries(names.entries());

		this.notify(this.inspector, "collections", {
			"list": collections
		});
	}

	_inspector_refresh_collection() {
		if (!this.inspector) return;
		this.notify(this.inspector, "collection", {});
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

			// Show an alert if OBS Studio is not running or connected.
			if (!this.obs.connected()) {
				this.streamdeck.showAlert(ev.context);
				return;
			}

			const result = await this._api.switch(settings.collection);
			if (settings.collection === result) {
				if (config.status) {
					this.streamdeck.showOk(ev.context);
				}
			} else {
				if (config.status) {
					this.streamdeck.showAlert(ev.context);
				}
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
			if (ctx == this.inspector){
				this._inspector_refresh();
			}
			this.refresh(ctx);
		}
	}

	_on_rpc_settings(ev) {
		ev.preventDefault();
		let settings = ev.data.parameters();
		this._apply_settings(this.inspector, settings);
	}
}
