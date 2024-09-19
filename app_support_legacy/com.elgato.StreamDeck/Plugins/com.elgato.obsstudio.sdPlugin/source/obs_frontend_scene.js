// Container for obs.frontend.scene

// TODO:
// - Figure out how to handle early failures to update indexes, currently silently fails.
// - Compress obs.frontend.scene to return information for both preview and program without requiring a parameter for it.

class obs_frontend_scene extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status & Data
		this._scenes = new Set();
		this._scene_preview = null;
		this._scene_program = null;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev);
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.scenecollection", (ev) => {
			this._on_scenecollection(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.scenes", (ev) => {
			this._on_scenes(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.scene", (ev) => {
			this._on_scene(ev);
		}, true);
		this.obs.addEventListener("obs.source.event.rename", (ev) => {
			this._on_obs_source_event_rename(ev);
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** List of currently known scenes.
	 *
	 */
	get scenes() {
		return new Set(this._scenes);
	}

	/** The current preview scene. Will match program if studio mode is disabled.
	 *
	 */
	get preview() {
		return this._scene_preview;
	}

	/** The current preview scene. Will match preview if studio mode is disabled.
	 *
	 */
	get program() {
		return this._scene_program;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Change the current preview or program scene to another.
	 *
	 * @param {(string|String)} name The name of the scene to switch to.
	 * @param {boolean} program Should the program scene be changed? Otherwise will change the preview. No change if studio mode is not enabled.
	 * @return A Promise or null.
	 */
	switch(name, program = true) {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			throw new Error("OBS Studio is not connected.".lox());
		}

		// 'name' must be a string.
		if (typeof (name) != "string") {
			throw new Error("string expected");
		}

		if (program == true) {
			return new Promise((resolve, reject) => {
				this.obs.call("obs.frontend.scene", (result, error) => {
					if (result !== undefined) {
						//this._scene_program = result;
						//this._event_scene();
						resolve(result);
					} else {
						reject(error);
					}
				}, {
					program: true,
					scene: name
				});
			});
		} else {
			return new Promise((resolve, reject) => {
				this.obs.call("obs.frontend.scene", (result, error) => {
					if (result !== undefined) {
						//this._scene_preview = result;
						//this._event_scene();
						resolve(result);
					} else {
						reject(error);
					}
				}, {
					program: false,
					scene: name
				});
			});
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	/** scene
	 *
	 * @argument data.preview The name of the current preview scene.
	 * @argument data.program The name of the current program scene.
	 */
	_event_scene() {
		let evx = new Event("scene", { "bubbles": true, "cancelable": true });
		evx.data = {
			preview: this._scene_preview,
			program: this._scene_program,
		};
		this.dispatchEvent(evx);
	}

	/** scenes
	 *
	 * @argument data A set of all Front-End visible scenes.
	 */
	_event_scenes() {
		let evx = new Event("scenes", { "bubbles": true, "cancelable": true });
		evx.data = new Set(this._scenes);
		this.dispatchEvent(evx);
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
	_on_open(ev) {
		ev.preventDefault();

		// Reset information.
		this._scenes = new Set();
		this._scene_preview = null;
		this._scene_program = null;

		// Inform clients about the changes.
		this._event_scene();
		this._event_scenes();

		// Refresh information from OBS.
		this.obs.call("obs.frontend.scene.list", (result, error) => {
			if (result !== undefined) {
				this._scenes = new Set();
				for (let scene of result) {
					this._scenes.add(scene);
				}
				this._event_scenes();
			} else {
				// TODO: How do we handle this?
			}
		});
		this.obs.call("obs.frontend.scene", (result, error) => {
			if (result !== undefined) {
				this._scene_preview = result;
				this._event_scene();
			} else {
				// TODO: How do we handle this?
			}
		}, {
			program: false,
		});
		this.obs.call("obs.frontend.scene", (result, error) => {
			if (result !== undefined) {
				this._scene_program = result;
				this._event_scene();
			} else {
				// TODO: How do we handle this?
			}
		}, {
			program: true,
		});
	}

	_on_close(ev) {
		ev.preventDefault();

		// Reset information.
		this._scenes = new Set();
		this._scene_preview = null;
		this._scene_program = null;

		// Inform clients about the changes.
		this._event_scene();
		this._event_scenes();
	}

	_on_scenecollection(ev) {
		ev.preventDefault();

		// Reset information.
		this._scenes = new Set();
		this._scene_preview = null;
		this._scene_program = null;

		// Refresh information from OBS.
		this.obs.call("obs.frontend.scene.list", (result, error) => {
			if (result !== undefined) {
				this._scenes = new Set();
				for (let scene of result) {
					this._scenes.add(scene);
				}
				this._event_scenes();
			} else {
				// TODO: How do we handle this?
			}
		});
		this.obs.call("obs.frontend.scene", (result, error) => {
			if (result != undefined) {
				this._scene_preview = result;
				this._event_scene();
			} else {
				// TODO: How do we handle this?
			}
		}, {
			program: false,
		});
		this.obs.call("obs.frontend.scene", (result, error) => {
			if (result != undefined) {
				this._scene_program = result;
				this._event_scene();
			} else {
				// TODO: How do we handle this?
			}
		}, {
			program: true,
		});
	}

	_on_scenes(ev) {
		ev.preventDefault();

		this._scenes = new Set();
		for (let scene of ev.data.parameters().scenes) {
			this._scenes.add(scene);
		}

		// Inform clients about the changes.
		this._event_scenes();
	}

	_on_scene(ev) {
		ev.preventDefault();

		let param = ev.data.parameters();
		this._scene_program = param.program;
		this._scene_preview = param.preview;

		// Inform clients about the changes.
		this._event_scene();
	}

	_on_obs_source_event_rename(ev) {
		ev.preventDefault();
		let args = ev.data.parameters();

		// Ignore renames for filters, or other contained objects.
		if (Array.isArray(args["source"])) {
			return;
		}

		// If this affects us, update our active scene.
		if (typeof args.source == "string") {
			// Move the scene to a different name.
			this._scenes = this._scenes.replaceAt(args.from, args.to);

			if (args.from == this._scene_preview){
				this._scene_preview = args.to;
			}
			if (args.from == this._scene_program){
				this._scene_program = args.to;
			}

			// Signal anyone listening that the list of scenes has changed.
			//this._event_scenes();
			this._event_renamed(args.from, args.to);
		}
	}

}
