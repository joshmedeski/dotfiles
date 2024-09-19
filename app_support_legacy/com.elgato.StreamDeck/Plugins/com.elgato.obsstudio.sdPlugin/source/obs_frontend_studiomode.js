/** Container for obs.frontend.studiomode
 *
 * TODO:
 * - Prevent multiple calls from updating the same state.
 * - Group multiple queries for the same property into one.
 * - Listen to profile changes once implemented
 */
class obs_frontend_studiomode extends EventTarget {
	constructor(obs) {
		super();

		// Keep a reference to the OBS controller.
		this._obs = obs;

		// Status
		this._enabled = false;

		// Listeners
		this.obs.addEventListener("open", (ev) => {
			this._on_open(ev); 
		}, true);
		this.obs.addEventListener("close", (ev) => {
			this._on_close(ev); 
		}, true);
		this.obs.addEventListener("obs.frontend.event.studiomode", (ev) => {
			this._on_obs_frontend_event_studiomode(ev); 
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	/** Check if Studio Mode is enabled.
	 *
	 * @return true if active, otherwise false
	 */
	get enabled() {
		return this._enabled;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Change the state of "Studio Mode".
	 *
	 * @return A Promise which resolves with a boolean, true if it is enabled, otherwise false.
	 */
	state(state = undefined) {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}

		if (this.enabled == state) {
			return new Promise((resolve, reject) => {
				resolve(this.enabled);
			});
		}

		if (state !== undefined) {
			return new Promise((resolve, reject) => {
				this.obs.call("obs.frontend.studiomode", (result, error) => {
					if (result !== undefined) {
						resolve(result);
					} else {
						reject(error);
					}
				}, {
					"enabled": state
				});
			});
		} else {
			return new Promise((resolve) => {
				resolve(this.enabled); 
			});
		}
	}

	/** Enable "Studio Mode"
	 *
	 * @return A Promise which resolves with a boolean, true if it is enabled, otherwise false.
	 */
	enable() {
		return this.state(true);
	}

	/** Disable "Studio Mode"
	 *
	 * @return A Promise which resolves with a boolean, true if it is enabled, otherwise false.
	 */
	disable() {
		return this.state(false);
	}

	/** Transition "Preview" into "Program"
	 *
	 * @return A Promise which resolves with a boolean, true if successful, false if not
	 */
	transition() {
		// Is OBS Studio connected?
		if (!this.obs.connected()) {
			return new Promise((resolve, reject) => {
				reject(new Error("OBS Studio is not connected.".lox()));
			});
		}
		// Is Studio mode active?
		if (this.enabled !== true) {
			return new Promise((resolve, reject) => {
				reject(new Error("Studio mode is not enabled.".lox()));
			});
		}
		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.transition_studio", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else {
					reject(error);
				}
			},
			{});
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	/** status
	 *
	 * @argument data.enabled
	 */
	_event_status() {
		let ev = new Event("status", { "bubbles": true, "cancelable": true });
		ev.data = {
			enabled: this.enabled,
		};
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_open(ev) {
		ev.preventDefault();
		this._enabled = false;
		this._event_status();

		this.obs.call("obs.frontend.studiomode", (result, error) => {
			if (result) {
				this._enabled = result;
			} else {
				this._enabled = false;
			}
			this._event_status();
		});
	}

	_on_close(ev) {
		ev.preventDefault();
		this._enabled = false;
		this._event_status();
	}

	_on_obs_frontend_event_studiomode(ev) {
		ev.preventDefault();
		const pars = ev.data.parameters();

		const state = pars["state"];
		switch (state) {
		case "ENABLED":
			this._enabled = true;
			this._event_status();
			break;
		case "DISABLED":
			this._enabled = false;
			this._event_status();
			break;
		}
	}
}
