class obs_frontend_transition_api extends EventTarget {
	constructor(obs) {
		super();

		// Internals
		this._obs = obs;

		// Data
		this._transition = undefined;
		this._transition_duration = undefined;
		// Transitions is now a map of name:bool(true if fixed-duration transition)
		this._transitions = new Map();

		{ // Listeners
			this.obs.addEventListener("open", (ev) => {
				this._on_obs_open(ev);
			}, true);
			this.obs.addEventListener("close", (ev) => {
				this._on_obs_close(ev);
			}, true);
		}

		{ // Transitions
			this.obs.addEventListener("obs.frontend.event.transition", (ev) => {
				this._on_obs_frontend_transition(ev);
			});
			this.obs.addEventListener("obs.frontend.event.transition.duration", (ev) => {
				this._on_obs_frontend_transition_duration(ev);
			});
			this.obs.addEventListener("obs.frontend.event.transitions", (ev) => {
				this._on_obs_frontend_transitions(ev);
			});
			this.obs.addEventListener("obs.frontend.event.transition.rename", (ev) => {
				this._on_obs_frontend_transition_rename(ev);
			});
		}
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get obs() {
		return this._obs;
	}

	get transition() {
		return this._transition;
	}

	get transition_duration() {
		return this._transition_duration;
	}

	get transitions() {
		return new Map(this._transitions);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	_set_transition(data) {
		this._transition = data;
		this._event_transition();
	}

	_set_transition_duration(data) {
		this._transition_duration = data;
		this._event_transition_duration();
	}

	_set_transitions(data) {
		this._transitions = new Map();
		for (let value of data) {
			this._transitions.set(value.name, value.fixed);
		}
		this._event_transitions();
	}

	enumerate() {
		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.transition.list", (result, error) => {
				if (result !== undefined) {
					resolve(result);
				} else if (error !== undefined) {
					reject(error);
				} else {
					reject();
				}
			});
		});
	}

	/** Retrieve or change the active transition.
	 *
	 * @param {string} (Optional) The transition which should be made active.
	 * @param {int} (Optional) The desired duration of the transition in ms
	 */
	active_transition(transition, duration) {
		let parameters = {};

		if (transition !== undefined) {
			parameters.transition = transition;
		}
		if (duration !== undefined) {
			parameters.duration = duration;
		}

		return new Promise((resolve, reject) => {
			this.obs.call("obs.frontend.transition", (result, error) => {
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

	/** transition
	 *
	 * @argument {string} data The name of the new transition
	 */
	_event_transition() {
		let ev = new Event("transition", { "bubbles": true, "cancelable": true });
		ev.data = this.transition;
		this.dispatchEvent(ev);
	}

	/** transition_duration
	 *
	 * @argument {int} data The new transition duration
	 */
	_event_transition_duration() {
		let ev = new Event("transition", { "bubbles": true, "cancelable": true });
		ev.data = this.transition_duration;
		this.dispatchEvent(ev);
	}

	/** transitions
	 *
	 * @argument {Map(string, bool)} data A set of available transitions.
	 */
	_event_transitions() {
		let ev = new Event("transitions", { "bubbles": true, "cancelable": true });
		ev.data = this.transitions;
		this.dispatchEvent(ev);
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
	_on_obs_open(ev) {
		ev.preventDefault();
		this._set_transition(undefined);
		this._set_transitions([]);
		this.enumerate().then((result) => {
			this._set_transitions(result);
		});
		this.active_transition().then((result) => {
			this._set_transition(result.transition);
			this._set_transition_duration(result.duration);
		});
	}

	_on_obs_close(ev) {
		ev.preventDefault();
		this._set_transition(undefined);
		this._set_transition_duration(undefined);
		this._set_transitions([]);
	}

	_on_obs_frontend_transition(ev) {
		ev.preventDefault();
		const pars = ev.data.parameters();
		this._set_transition(pars.transition);
	}
	_on_obs_frontend_transition_duration(ev) {
		ev.preventDefault();
		const pars = ev.data.parameters();
		this._set_transition_duration(pars.duration);
	}

	_on_obs_frontend_transitions(ev) {
		ev.preventDefault();
		const pars = ev.data.parameters();
		this._set_transitions(pars.transitions);
	}

	_on_obs_frontend_transition_rename(ev) {
		ev.preventDefault();

		const pars = ev.data.parameters();
		const from = pars.from;
		const to = pars.to;

		if (this._transition == from){
			this._transition = to;
		}

		this._transitions = this._transitions.replaceAt(from, to);

		this._event_renamed(from, to);
	}
}
