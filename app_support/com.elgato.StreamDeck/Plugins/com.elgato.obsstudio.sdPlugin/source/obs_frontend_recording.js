/** Container for obs.frontend.recording
 *
 * TODO:
 * - Prevent multiple calls from updating the same state.
 * - Group multiple queries for the same property into one.
 */
class obs_frontend_recording extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status
		this._starting = false;
		this._stopping = false;
		this._active = false;
		this._paused = false;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev); 
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev); 
		}, true);
		this.obs.addEventListener("obs.frontend.event.recording", (ev) => {
			this._on_obs_frontend_event_recording(ev); 
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Is the recording active?
	 */
	get active() {
		return this._active;
	}

	/** Is the recording paused?
	 */
	get paused() {
		return this._paused;
	}

	/** Is the recording starting (inactive -> active)?
	 */
	get starting() {
		return this._starting;
	}

	/** Is the recording stopping (active -> inactive)?
	 */
	get stopping() {
		return this._stopping;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Start the recording, if it is not already active.
	 *
	 * @return A Promise or null.
	 */
	start() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is it already active?
		if (this.active) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.recording.start", (result, error) => {
				if (result !== undefined) {
					this._active = result;
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Stop the recording, if it is active.
	 *
	 * @return A Promise or null.
	 */
	stop() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is the Recording currently inactive?
		if (!this.active) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.recording.stop", (result, error) => {
				if (result !== undefined) {
					this._active = !result;
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Paused the Recording if it is active and not paused.
	 *
	 * @return A Promise which resolves with a boolean, true if successful, otherwise false.
	 */
	pause() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is the Recording currently active?
		if (!this.active) {
			return new Promise((resolve, reject) => {
				resolve(false);
			});
		}

		// Is the Recording currently active and paused?
		if (this.active && this.paused) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.recording.pause", (result, error) => {
				if (result !== undefined) {
					this.paused = result;

					// Inform all clients that it is currently inactive.
					this._event_status();

					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Unpause the Recording if it is paused.
	 *
	 * @return A Promise which resolves with a boolean, true if successful, otherwise false.
	 */
	unpause() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		// Is the Recording currently active?
		if (!this.active) {
			return new Promise((resolve, reject) => {
				resolve(false);
			});
		}

		// Is the Recording currently active and unpaused?
		if (this.active && !this.paused) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.recording.unpause", (result, error) => {
				if (result !== undefined) {
					this.paused = !result;

					// Inform all clients that it is currently inactive.
					this._event_status();

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

	/** active
	 * Is the recording currently active or not?
	 *
	 * @argument data.active
	 * @argument data.starting
	 * @argument data.stopping
	 * @argument data.paused
	 */
	_event_status() {
		let ev = new Event("status", { "bubbles": true, "cancelable": true });
		ev.data = {
			active: this.active,
			paused: this.paused,
			starting: this.starting,
			stopping: this.stopping,
		};
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
		this._paused = false;

		// Inform all clients that it is currently inactive.
		this._event_status();

		// Refresh state from OBS Studio
		this.obs.call("obs.frontend.recording.active", (result, error) => {
			if (result !== undefined) {
				this._active = result;
			} else {
				this._active = false;
			}
			this._event_status();
		});
		this.obs.call("obs.frontend.recording.paused", (result, error) => {
			if (result !== undefined) {
				this._paused = result;
			} else {
				this._paused = false;
			}
			this._event_status();
		});
	}

	_on_close(ev) {
		ev.preventDefault();

		this._active = false;
		this._starting = false;
		this._stopping = false;
		this._paused = false;

		// Inform all clients that it is currently inactive.
		this._event_status();
	}

	_on_obs_frontend_event_recording(ev) {
		ev.preventDefault();
		const prm = ev.data.parameters();

		const state = prm["state"];
		switch (state) {
		case "STARTING":
			this._active = false;
			this._starting = true;
			this._event_status();
			break;
		case "STARTED":
			this._starting = false;
			this._active = true;
			this._paused = false;
			this._event_status();
			break;
		case "STOPPING":
			this._active = true;
			this._stopping = true;
			this._event_status();
			break;
		case "STOPPED":
			this._active = false;
			this._stopping = false;
			this._paused = false;
			this._event_status();
			break;
		case "PAUSED":
			this._paused = true;
			this._event_status();
			break;
		case "UNPAUSED":
			this._paused = false;
			this._event_status();
			break;
		}
	}
}
