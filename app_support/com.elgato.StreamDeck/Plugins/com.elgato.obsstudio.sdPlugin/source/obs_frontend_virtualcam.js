/** Container for obs.frontend.virtualcam
 *
 * TODO:
 * - Prevent multiple calls from updating the same state.
 * - Group multiple queries for the same property into one.
 */
class obs_frontend_virtualcam extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status
		this._active = false;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev);
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev);
		}, true);
		this.obs.addEventListener("obs.frontend.event.virtualcam", (ev) => {
			this._on_obs_frontend_event_virtualcam(ev);
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Is the virtualcam active?
	 */
	get active() {
		return this._active;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Start the virtualcam, if it is not already active.
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
			this.obs.call("obs.frontend.virtualcam.start", (result, error) => {
				if (result !== undefined) {
					this._active = result;
					this._event_status();
					resolve(result);
				} else {
					reject(error);
				}
			});
		});
	}

	/** Stop the virtualcam, if it is active.
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

		// Is it currently inactive?
		if (!this.active) {
			return new Promise((resolve, reject) => {
				resolve(true);
			});
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.virtualcam.stop", (result, error) => {
				if (result !== undefined) {
					this._active = result;
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

	/** status
	 *
	 * @argument data.active
	 */
	_event_status() {
		let ev = new Event("status", { "bubbles": true, "cancelable": true });
		ev.data = {
			active: this.active,
		};
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_open(ev) {
		ev.preventDefault();

		// Reset object state.
		this._active = false;

		// Inform all clients that it is currently inactive.
		this._event_status();

		this.obs.call("obs.frontend.virtualcam.active", (result, error) => {
			if (result !== undefined) {
				this._active = result;
			} else {
				this._active = false;
				// TODO: How do we handle this?
			}
			this._event_status();
		});
	}

	_on_close(ev) {
		ev.preventDefault();

		this._active = false;

		this._event_status();
	}

	_on_obs_frontend_event_virtualcam(ev) {
		ev.preventDefault();
		const prm = ev.data.parameters();

		const state = prm["state"];
		switch (state) {
		case "STARTED":
			this._active = true;
			this._event_status();
			break;
		case "STOPPED":
			this._active = false;
			this._event_status();
			break;
		}
	}
}
