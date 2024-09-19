/** Container for obs.frontend.replaybuffer
 *
 * TODO:
 * - Prevent multiple calls from updating the same state.
 * - Group multiple queries for the same property into one.
 */
class obs_frontend_replaybuffer extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status
		this._starting = false;
		this._stopping = false;
		this._active = false;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev); 
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev); 
		}, true);
		this.obs.addEventListener("obs.frontend.event.replaybuffer", (ev) => {
			this._on_obs_frontend_event_replaybuffer(ev); 
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Check if the Replay Buffer is currently active.
	 *
	 * @return true if active, otherwise false
	 */
	get active() {
		return this._active;
	}

	/** Check if the Replay Buffer is currently starting.
	 *
	 * @return true if starting, otherwise false
	 */
	get starting() {
		return this._starting;
	}

	/** Check if the Replay Buffer is currently stopping.
	 *
	 * @return true if stopping, otherwise false
	 */
	get stopping() {
		return this._stopping;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Check if the Replay Buffer is currently enabled.
	 *
	 * @return A Promise which resolves with a boolean, true if it is enabled, otherwise false.
	 */
	enabled() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.replaybuffer.enabled", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Start the Replay Buffer if it is enabled and not already active.
	 *
	 * @return A Promise which resolves with a boolean, true if successful, otherwise false.
	 */
	start() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is the Replay Buffer currently active?
		if (this.active) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.replaybuffer.start", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Stop the Replay Buffer if it is enabled and active.
	 *
	 * @return A Promise which resolves with a boolean, true if successful, otherwise false.
	 */
	stop() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is the Replay Buffer currently inactive?
		if (!this.active) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.replaybuffer.stop", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Save the Replay Buffer if it is enabled and active.
	 *
	 * @return A Promise which resolves with a boolean, true if successful, otherwise false.
	 */
	save() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is the Replay Buffer currently inactive?
		if (!this.active) {
			return new Promise((resolve, reject) => {
				resolve(false);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.replaybuffer.save", (result, error) => {
				if (result !== undefined) {
					if (result === true) {
						this._event_saving(); // No OBS event for this.
					}
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	/** status
	 *
	 * @argument data.active
	 * @argument data.starting
	 * @argument data.stopping
	 */
	_event_status() {
		let ev = new Event("status", { "bubbles": true, "cancelable": true });
		ev.data = {
			active: this.active,
			starting: this.starting,
			stopping: this.stopping,
		};
		this.dispatchEvent(ev);
	}

	/** saving
	 * Is the recording currently paused or not?
	 * @argument data true if paused, otherwise false.
	 */
	_event_saving() {
		let ev = new Event("saving", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	/** saved
	 * Is the recording currently paused or not?
	 * @argument data true if paused, otherwise false.
	 */
	_event_saved() {
		let ev = new Event("saved", { "bubbles": true, "cancelable": true });
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_open(ev) {
		ev.preventDefault();
		this._active = false;
		this._starting = false;
		this._stopping = false;
		this._event_status();

		this.obs.call("obs.frontend.replaybuffer.active", (result, error) => {
			if (result) {
				this._active = result;
			} else {
				this._active = false;
			}
			this._event_status();
		});
	}

	_on_close(ev) {
		ev.preventDefault();
		this._active = false;
		this._starting = false;
		this._stopping = false;
		this._event_status();
	}

	_on_obs_frontend_event_replaybuffer(ev) {
		ev.preventDefault();
		const pars = ev.data.parameters();

		const state = pars["state"];
		switch (state) {
		case "STARTING":
			this._starting = true;
			this._event_status();
			break;
		case "STARTED":
			this._starting = false;
			this._active = true;
			this._event_status();
			break;
		case "STOPPING":
			this._stopping = true;
			this._event_status();
			break;
		case "STOPPED":
			this._stopping = false;
			this._active = false;
			this._event_status();
			break;
		case "SAVED":
			this._event_saved();
			break;
		}
	}
}
