// Container for obs.frontend.profile

// TODO:
// - Figure out how to handle early failures to update indexes, currently silently fails.

class obs_frontend_profile extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status & Data
		this._profiles = new Set();
		this._profile = null;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev);
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.profiles", (ev) => {
			this._on_profiles(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.profile", (ev) => {
			this._on_profile(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.profile.renamed", (ev) => {
			this._on_profile_renamed(ev);
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** List of currently known profiles.
	 */
	get profiles() {
		return new Set(this._profiles);
	}

	/** The name of the currently active profile.
	 */
	get profile() {
		return this._profile;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Change the current profile to another.
	 *
	 * @param {(string|String)} new_profile The name of the profile to switch to.
	 * @return A Promise or null.
	 */
	switch(new_profile) {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// 'new_profile' must be a string.
		if (typeof (new_profile) != "string") {
			return new Promise((resolve, reject) => {
				reject(new Error("'new_profile' must be a string.'"));
			});
		}

		// If the current profile is the same as the new profile, do nothing.
		if (this.profile == new_profile) {
			return new Promise((resolve, reject) => {
				resolve(this.profile);
			});
		}

		// Call the remote side and ask for the profile to be changed.
		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.profile", (result, error) => {
				if (result !== undefined) {
					this._profile = result;
					resolve(result);
				} else {
					reject(error);
				}
			}, {
				"profile": new_profile
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //
	// All arguments are stored within the data property of the event itself.

	/** profile
	 *
	 * @argument data The name of the currently active profile.
	 */
	_event_profile() {
		let evx = new Event("profile", { "bubbles": true, "cancelable": true });
		evx.data = this._profile;
		this.dispatchEvent(evx);
	}

	/** profiles
	 *
	 * @argument data A set of all known profiles.
	 */
	_event_profiles() {
		let evx = new Event("profiles", { "bubbles": true, "cancelable": true });
		evx.data = new Set(this._profiles);
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
		this._profiles = new Set();
		this._profile = null;

		// Refresh data from OBS
		this.obs.call("obs.frontend.profile.list", (result, error) => {
			if (result !== undefined) {
				this._profiles = new Set();
				for (let profile of result) {
					this._profiles.add(profile);
				}
				this._event_profiles();
			} else {
				// TODO: How do we handle this?
			}
		});
		this.obs.call("obs.frontend.profile", (result, error) => {
			if (result !== undefined) {
				this._profile = result;
				this._event_profile();
			} else {
				// TODO: How do we handle this?
			}
		});
	}

	_on_close(ev) {
		ev.preventDefault();

		// Reset information.
		this._profiles = new Set();
		this._profile = null;

		// Inform clients about the changes.
		this._event_profile();
		this._event_profiles();
	}

	_on_profiles(ev) {
		ev.preventDefault();

		this._profiles = new Set();
		for (let profile of ev.data.parameters().profiles) {
			this._profiles.add(profile);
		}

		// Inform clients about the changes.
		this._event_profiles();
	}

	_on_profile(ev) {
		ev.preventDefault();

		this._profile = ev.data.parameters().profile;

		// Inform clients about the changes.
		this._event_profile();
	}

	_on_profile_renamed(ev) {
		ev.preventDefault();

		const pars = ev.data.parameters();
		const from = pars.from;
		const to = pars.to;

		if(from == this._profile){
			this._profile = to;
		}

		this._profiles = this._profiles.replaceAt(from, to);

		// Inform clients about the changes.
		this._event_renamed(from, to);
	}
}
