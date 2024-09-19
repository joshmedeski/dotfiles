class obs_frontend_api extends EventTarget {
	constructor(obs) {
		super();

		// Internals
		this._obs = obs;

		// Data

		{ // Listeners
			this.obs.addEventListener("open", (ev) => {
				this._on_obs_open(ev);
			}, true);
			this.obs.addEventListener("close", (ev) => {
				this._on_obs_close(ev);
			}, true);
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Save a single screen of the current Scene or a specific Source.
	 *
	 * @param {string} (Optional) The source of which to take a screenshot of.
	 *
	 */
	screenshot(source) {
		let parameters = {};

		if (source !== undefined) {
			parameters.source = source;
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.screenshot", (result, error) => {
				if (error !== undefined) {
					reject(error);
				} else {
					resolve(result);
				}
			}, parameters);
		});
	}

	/** Fetch the latest OBS stats
	 */
	get_stats() {
		let parameters = {};

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.stats", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else if (error !== undefined) {
					reject(error);
				} else {
					reject();
				}
			}, parameters);
		});
	}

	// ---------------------------------------------------------------------------------------------- //
	// Events
	// ---------------------------------------------------------------------------------------------- //

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	_on_obs_open(ev) {
		ev.preventDefault();
	}

	_on_obs_close(ev) {
		ev.preventDefault();
	}
}
