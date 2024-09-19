// Copyright © 2022, Corsair Memory Inc. All rights reserved.

const EActionStateOn = 0;
const EActionStateOff = 1;

const EMultiActionStateOff = 1;
const EMultiActionStateOn = 0;

class IAction extends EventTarget {
	constructor(controller, uuid) {
		super();

		// APIs
		this._ctr = controller;
		this._sd = controller.streamdeck;
		this._obs = controller.obs();

		// Status & Data
		this._uuid = uuid; // Unique Class Identifier
		this._contexts = new Map(); // Map of known Contexts and their current Settings.
		this._inspector = null; // Inspector instance.
		// Inspector didAppear / didDisappear messages sometimes come out of order, so we keep a refcount to avoid holding a dangling inspector reference
		this._inspector_refcount = 0;

		// States
		this._states_id_to_name = new Map(); // State Id to Name
		this._states_name_to_id = new Map(); // State Name to Id

		// For synthetic "button held" events
		this._held_contexts = new Map();
		this._held_interval = null;

		// Cached states to avoid sending dupe messages
		this._prev_title = new Map();
		this._prev_image = new Map();

		// Listen to events
		this.addEventListener("willAppear", (event) => {
			this.__iaction_on_willAppear(event);
		}, true);
		this.addEventListener("willDisappear", (event) => {
			this.__iaction_on_willDisappear(event);
		}, true);
		//this.addEventListener("didReceiveSettings", (event) => { this.__on_didReceiveSettings(event); }, true);
		this.addEventListener("propertyInspectorDidAppear", (event) => {
			this.__iaction_on_propertyInspectorDidAppear(event);
		}, true);
		this.addEventListener("propertyInspectorDidDisappear", (event) => {
			this.__iaction_on_propertyInspectorDidDisappear(event);
		}, true);
		this.addEventListener("keyDown", (event) => {
			this.__iaction_on_pressed(event);
		});
		this.addEventListener("keyUp", (event) => {
			this.__iaction_on_released(event);
		});

		// RPC communication between Inspector and Action.
		this._rpc = new RPC("rpc.", this);
		this.rpc.addEventListener("log", (event) => {
			this.__iaction_on_rpc_log(event);
		});
		this.rpc.addEventListener("send", (event) => {
			this.__iaction_on_rpc_send(event);
		});
		this.addEventListener("sendToPlugin", (event) => {
			this.__iaction_on_sendToPlugin(event);
		}, true);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Accessors
	// ---------------------------------------------------------------------------------------------- //

	get controller() {
		return this._ctr;
	}

	get streamdeck() {
		return this._sd;
	}

	get obs() {
		return this._obs;
	}

	/** Unique identifier for this Action class.
	 *
	 */
	get uuid() {
		return this._uuid;
	}

	/** The currently active inspector instance.
	 *
	 * Only one inspector can be active per Action class.
	 *
	 */
	get inspector() {
		return this._inspector;
	}

	/** The RPC instance for the communication between Inspector and Action.
	 *
	 */
	get rpc() {
		return this._rpc;
	}

	/** Map of known contexts and their settings.
	 *
	 */
	get contexts() {
		return new Map(this._contexts);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Functions
	// ---------------------------------------------------------------------------------------------- //

	/** Log a message
	 *
	 */
	log(msg) {
		this.controller.log(`[${this._uuid}] ${msg}`);
	}

	/** Retrieve the read-only status for a given context.
	 *
	 * Note: May create a shallow clone.
	 *
	 *
	 * @param {any} context The context for which to retrieve or store the status.
	 */
	status(context) {
		if (!this._contexts.has(context)) {
			this.log(`Context '${context}' requested status before registration.`);
			this.log(new Error().stack);
			return undefined;
		}

		let o = this._contexts.get(context);
		return o;
	}

	/** Store or retrieve settings for a given context.
	 *
	 * @param {any} context The context for which to retrieve or store the settings.
	 * @param {object} settings An object containing all settings to store. [Optional]
	 * @return {undefined|object} An object if the context is known, otherwise undefined.
	 */
	settings(context, settings = undefined) {
		if (!this._contexts.has(context)) {
			this.log(`Context '${context}' requested settings before registration.`);
			this.log(new Error().stack);
			return undefined;
		}

		let o = this._contexts.get(context);
		if (settings) {
			o.settings = settings;
			this._contexts.set(context, o);
			this.streamdeck.setSettings(context, settings);
		}

		if (o.settings !== undefined) {
			return o.settings;
		}
		return {};
	}

	notify(context, method, parameters = undefined, ...extra) {
		this.rpc.notify(method, parameters, {
			"context": context,
		}, ...extra);
	}

	call(context, method, callback, parameters = undefined, timeout = 10000, ...extra) {
		this.rpc.call(method, callback, parameters, timeout, {
			"context": context,
		}, ...extra);
	}

	reply(context, id, result, error = undefined, ...extra) {
		this.rpc.reply(id, result, error, {
			"context": context,
		}, ...extra);
	}

	getState(context) {
		// Retrieve the stored context information (by-ref).
		let o = this._contexts.get(context);

		// If the state has yet to be set, set the default one.
		if (typeof (o.state) !== "number") {
			o.state = EActionStateOff;
		}

		// Return the actual state.
		return o.state;
	}

	setState(context, state, force = false) {
		// Retrieve the stored context information (by-ref).
		let o = this._contexts.get(context);

		if ((typeof state) == "string") {
			state = this._states_name_to_id.get(state);
		}

		// Verify that the new state is different (and not a forced update).
		if ((o.state === state) && (force === false)) {
			return;
		}

		// Signal Stream Deck to update the specified context.
		this.streamdeck.setState(context, state);

		// Update the stored state.
		o.state = state;
	}

	// TODO: Make these parameters agree with streamdeck.setImage
	setImage(context, state, image, target = 0) {
		if ((typeof state) == "string") {
			state = this._states_name_to_id.get(state);
		}
		const prev_image = this._prev_image.get(context);
		if(target === 0){
			if (image === prev_image[0][state] && image === prev_image[1][state]){
				return;
			}
		} else {
			if (image === prev_image[target-1][state]){
				return;
			}
		}

		this.streamdeck.setImage(context, image, target, state);
		if(target === 0){
			prev_image[0][state] = image;
			prev_image[1][state] = image;
		} else {
			prev_image[target-1][state] = image;
		}
	}

	// TODO: Make these parameters agree with streamdeck.setTitle
	// Sets the title wrapped to max 2 lines 9-ish chars/line
	setTitle(context, state, title, target = 0) {
		if (!title) {
			title = "";
		}
		title = String(title);

		const maxLines = 2;
		const maxWidth = 9;
		// Assume spaces are a bit smaller than a full character
		const space_width = 2/3;

		const parts = title.split(" ");
		let part = 0;
		let lines = [];
		for (let line = 0; line < 2 && part < parts.length; ++line){
			let line = [];
			let length = 0;
			let total_len = 0;
			while(total_len < 9 && part < parts.length){
				if(length > 0 && total_len + space_width + parts[part].length > 9){
					break;
				}
				line.push(parts[part]);
				length += parts[part].length;
				part++;
				total_len = length + (line.length - 1) * space_width;
			}
			lines.push(line.join(" "));
		}
		title = lines.join("\n");


		if ((typeof state) == "string") {
			state = this._states_name_to_id.get(state);
		}
		const prev_title = this._prev_title.get(context);
		if(target === 0){
			if (title === prev_title[0][state] && title === prev_title[1][state]){
				return;
			}
		} else {
			if (title === prev_title[target-1][state]){
				return;
			}
		}

		this.streamdeck.setTitle(context, title, target, state);
		if(target === 0){
			prev_title[0][state] = title;
			prev_title[1][state] = title;
		} else {
			prev_title[target-1][state] = title;
		}

	}

	registerNamedState(name, id) {
		this._states_id_to_name.set(id, name);
		this._states_name_to_id.set(name, id);
	}

	translateStateIdToName(id) {
		return this._states_id_to_name.get(id);
	}

	translateStateNameToId(name) {
		return this._states_name_to_id.get(name);
	}

	setFeedback(context, feedback) {
		return this.streamdeck.setFeedback(context, feedback);
	}

	setFeedbackLayout(context, layout) {
		return this.streamdeck.setFeedbackLayout(context, layout);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Listeners
	// ---------------------------------------------------------------------------------------------- //
	__iaction_on_willAppear(event) { // Track context and load settings.
		let status = {};
		status.state = 0;
		status.isInMultiAction = event.data.isInMultiAction;
		Object.assign(status, event.data.payload);
		this._contexts.set(event.context, status);
		this._prev_image.set(event.context, [[],[]]);
		this._prev_title.set(event.context, [[],[]]);
	}

	__iaction_on_willDisappear(event) { // Untrack context and save settings.
		if (!this._contexts.has(event.context)) {
			return;
		}

		this._held_contexts.delete(event.context);
		this._prev_image.delete(event.context);
		this._prev_title.delete(event.context);

		let o = this._contexts.get(event.context);
		this._contexts.delete(event.context);
		if (!o.settings) {
			return;
		}

		this.streamdeck.setSettings(event.context, o.settings);
	}

	__iaction_on_propertyInspectorDidAppear(event) {
		this._inspector = event.context;
		this._inspector_refcount++;
	}

	__iaction_on_propertyInspectorDidDisappear(event) {
		this._inspector_refcount--;
		if (this._inspector_refcount <= 0) {
			this._inspector = null;
			this._inspector_refcount = 0;
		}
	}

	__iaction_on_sendToPlugin(event) {
		event.preventDefault();
		if (config.debug_inspector) {
			this.log(`RECV <${event.context}> ${JSON.stringifyEx(event.data.payload)}`);
		}
		this._rpc.recv(event.data.payload, {
			"context": event.context,
		});
	}

	__iaction_on_rpc_log(event) {
		// Also log the context if we have one.
		let ctx = "";
		if (event.extra.length > 0) {
			ctx = `<${event.extra[0].context.toString()}>`;
		}

		this.log(`${ctx} ${event.data.toString()}`);
	}

	__iaction_on_rpc_send(event) {
		if (config.debug_inspector) {
			this.log(`SEND <${event.extra[0].context}> ${JSON.stringifyEx(event.data)}`);
		}
		this.streamdeck.sendToPropertyInspector(
			this.uuid,
			event.extra[0].context,
			event.data
		);
	}

	__iaction_button_held(){
		if(this._held_contexts.size == 0){
			clearInterval(this._held_interval);
			this._held_interval = null;
			return;
		}
		this._held_contexts.forEach((value, key)=>{
			let ev = new Event("keyHeld", { "bubbles": true, "cancelable": true });
			ev.context = key;
			ev.device = value.device;
			ev.action = value.action;
			ev.data = value.data;
			this.dispatchEvent(ev);
		})
	}

	__iaction_on_pressed(event){
		let push = true;
		this._held_contexts.set(event.context, event);
		if (!this._held_interval){
			this._held_interval = setInterval(()=>this.__iaction_button_held(), 200);
		}
	}

	__iaction_on_released(event){
		this._held_contexts.delete(event.context);
		if(this._held_contexts.size == 0){
			clearInterval(this._held_interval);
			this._held_interval = null;
			return;
		}
	}
}
