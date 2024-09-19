// Container for obs.frontend.scenecollection

// TODO:
// - Figure out how to handle early failures to update indexes, currently silently fails.

class obs_frontend_scenecollection extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status & Data
		this._collections = new Set();
		this._collection = null;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev);
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.scenecollections", (ev) => {
			this._on_scenecollections(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.scenecollection", (ev) => {
			this._on_scenecollection(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.scenecollection.renamed", (ev) => {
			this._on_scenecollection_renamed(ev);
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** List of currently known scene collections.
	 */
	get collections() {
		return new Set(this._collections);
	}

	/** The name of the currently active scene collection.
	 */
	get collection() {
		return this._collection;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Change the current scene collection to another.
	 *
	 * @param {(string|String)} new_collection The name of the scene collection to switch to.
	 * @return A Promise or null.
	 */
	switch(new_collection) {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// 'new_collection' must be a string.
		if (typeof (new_collection) != "string") {
			return new Promise((resolve, reject) => {
				reject(new Error("'new_collection' must be a string.'"));
			});
		}

		// If the current collection is the same as the new collection, do nothing.
		if (this.collection == new_collection) {
			return new Promise((resolve, reject) => {
				resolve(this.collection);
			});
		}

		// Call the remote side and ask for the scene collection to be changed.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.scenecollection", (result, error) => {
				if (result !== undefined) {
					this._collection = result;
					resolve(result);
				} else {
					reject(error);
				}
			}, {
				"collection": new_collection
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //
	// All arguments are stored within the data property of the event itself.

	/** collection
	 *
	 * @argument data The name of the currently active collection.
	 */
	_event_collection() {
		let evx = new Event("collection", { "bubbles": true, "cancelable": true });
		evx.data = this._collection;
		this.dispatchEvent(evx);
	}

	/** collections
	 *
	 * @argument data A set of all known collections.
	 */
	_event_collections() {
		let evx = new Event("collections", { "bubbles": true, "cancelable": true });
		evx.data = new Set(this._collections);
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
		this._collections = new Set();
		this._collection = null;

		// Refresh data from OBS
		this.obs.call("obs.frontend.scenecollection.list", (result, error) => {
			if (result !== undefined) {
				this._collections = new Set();
				for (let collection of result) {
					this._collections.add(collection);
				}
				this._event_collections();
			} else {
				// TODO: How do we handle this?
			}
		});
		this.obs.call("obs.frontend.scenecollection", (result, error) => {
			if (result !== undefined) {
				this._collection = result;
				this._event_collection();
			} else {
				// TODO: How do we handle this?
			}
		});
	}

	_on_close(ev) {
		ev.preventDefault();

		// Reset information.
		this._collections = new Set();
		this._collection = null;

		// Inform clients about the changes.
		this._event_collection();
		this._event_collections();
	}

	_on_scenecollections(ev) {
		ev.preventDefault();

		this._collections = new Set();
		for (let collection of ev.data.parameters().collections) {
			this._collections.add(collection);
		}

		// Inform clients about the changes.
		this._event_collections();
	}

	_on_scenecollection(ev) {
		ev.preventDefault();

		this._collection = ev.data.parameters().collection;

		// Inform clients about the changes.
		this._event_collection();
	}

	_on_scenecollection_renamed(ev) {
		ev.preventDefault();

		const pars = ev.data.parameters();
		const from = pars.from;
		const to = pars.to;

		if(from == this._collection){
			this._collection = to;
		}

		this._collections = this.collections.replaceAt(from, to);

		// Inform clients about the changes.
		this._event_renamed(from, to);
	}
}
