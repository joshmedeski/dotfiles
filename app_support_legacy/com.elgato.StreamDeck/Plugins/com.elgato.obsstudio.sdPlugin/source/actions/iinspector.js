// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class IInspector extends EventTarget {
	constructor(uPort, uUUID, uEvent, uApplicationInfo, uActionInfo) {
		super();

		// Set members to their default state.
		this._appInfo = uApplicationInfo;
		this._actionInfo = uActionInfo;
		this._action = this._actionInfo.action;
		this._context = uUUID; //this._ainfo.context;

		this._initOrder = [];
		this._initialized = 0;
		this._actionQueue = [];
		this._unserialized = new Set();

		{ // Set up StreamDeck connection.
			this._streamdeck = new StreamDeck(uPort, uUUID, uEvent, uApplicationInfo, uActionInfo);
			this.streamdeck.addEventListener("open", (ev) => {
				this._iinspector_on_streamdeck_open(ev);
			});
			this.streamdeck.addEventListener("close", (ev) => {
				this._iinspector_on_streamdeck_close(ev);
			});
			this.streamdeck.addEventListener("error", (ev) => {
				this._iinspector_on_streamdeck_error(ev);
			});

			// This is necessary for RPC communication.
			this.streamdeck.addEventListener("sendToPropertyInspector", (event) => {
				this._iinspector_on_streamdeck_sendToInspector(event);
			});
		}

		{ // Action RPC
			this._rpc = new RPC("rpc.", this);
			this.rpc.addEventListener("log", (event) => {
				this._iinspector_on_rpc_log(event);
			});
			this.rpc.addEventListener("send", (event) => {
				this._iinspector_on_rpc_send(event);
			});
			this.addEventListener("rpc.init_inspector", (event) =>{
				this._iinspector_on_init_inspector(event);
			})
			this.initDontBlock("rpc.init_inspector");
		}

		// Initialize things.
		this._iinspector_initialize_overlays();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Overlay
	// ---------------------------------------------------------------------------------------------- //
	_iinspector_initialize_overlays() {
		this._overlays = {};
		this._overlay = document.createElement("div");
		this._overlay.classList.add("overlay");
		document.querySelector("body").appendChild(this._overlay);

		{ // Processing Overlay
			let eContainer = document.createElement("div");
			eContainer.classList.add("processing");
			this._overlay.appendChild(eContainer);

			let eSpinner = document.createElement("div");
			eSpinner.classList.add("icon");
			eContainer.appendChild(eSpinner);

			let eSpinnerItem = document.createElement("div");
			eSpinnerItem.classList.add("item");
			eSpinner.appendChild(eSpinnerItem);

			let eText = document.createElement("div");
			eText.classList.add("text");
			eText.textContent = "Sample Text";
			eContainer.appendChild(eText);

			this._overlays["processing"] = {
				"container": eContainer,
				"text": eText,
			};
		}

		{ // Warning Overlay
			let eContainer = document.createElement("div");
			eContainer.classList.add("warning");
			this._overlay.appendChild(eContainer);

			let eIcon = document.createElement("div");
			eIcon.classList.add("icon");
			eIcon.textContent = "⚠";
			eContainer.appendChild(eIcon);

			let eText = document.createElement("div");
			eText.classList.add("text");
			eText.textContent = "Sample Text";
			eContainer.appendChild(eText);

			this._overlays["warning"] = {
				"container": eContainer,
				"text": eText,
			};
		}

		{ // Error Overlay
			let eContainer = document.createElement("div");
			eContainer.classList.add("error");
			this._overlay.appendChild(eContainer);

			let eIcon = document.createElement("div");
			eIcon.classList.add("icon");
			eIcon.textContent = "❌";
			eContainer.appendChild(eIcon);

			let eText = document.createElement("div");
			eText.classList.add("text");
			eText.textContent = "Sample Text";
			eContainer.appendChild(eText);

			this._overlays["error"] = {
				"container": eContainer,
				"text": eText,
			};
		}

		this.hide_overlays();
	}

	hide_overlays() {
		this._overlay.style.setProperty("display", "none");
		this._overlays["processing"].container.style.setProperty("display", "none");
		this._overlays["warning"].container.style.setProperty("display", "none");
		this._overlays["error"].container.style.setProperty("display", "none");
	}

	show_processing_overlay(text) {
		this.hide_overlays();
		this._overlays["processing"].text.innerHTML = text;
		this._overlays["processing"].container.style.removeProperty("display");
		this._overlay.style.removeProperty("display");
	}

	show_warning_overlay(text) {
		this.hide_overlays();
		this._overlays["warning"].text.innerHTML = text;
		this._overlays["warning"].container.style.removeProperty("display");
		this._overlay.style.removeProperty("display");
	}

	show_error_overlay(text) {
		this.hide_overlays();
		this._overlays["error"].text.innerHTML = text;
		this._overlays["error"].container.style.removeProperty("display");
		this._overlay.style.removeProperty("display");
	}

	// ---------------------------------------------------------------------------------------------- //
	// Warnings/Hints API
	// ---------------------------------------------------------------------------------------------- //
	_iinspector_create_message(type, text, selector) {
		// Create the message itself.
		let eMessage = document.createElement("div");
		eMessage.classList.add("message");
		eMessage.classList.add(type);
		eMessage.innerHTML = text;

		// Insert it into the DOM.
		let container = document.querySelector(".sdpi-wrapper");
		if (selector !== undefined) {
			let target = container.querySelector(selector);
			if ((target !== undefined) && (target !== null))
				container.insertBefore(eMessage, target);
		} else {
			container.appendChild(eMessage);
		}

		return eMessage;
	}

	clear_messages() {
		let els = document.querySelectorAll(".message");
		for (let el of els) {
			el.parentElement.removeChild(el);
		}
	}

	add_hint(text, before_selector) {
		this._iinspector_create_message("hint", text, before_selector);
	}

	add_warning(text, before_selector) {
		this._iinspector_create_message("warning", text, before_selector);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Stream Deck API
	// ---------------------------------------------------------------------------------------------- //
	get streamdeck() {
		return this._streamdeck;
	}

	log(message) {
		this.streamdeck.log(`[${this._actionInfo.action}] ${message.toString()}`);
	}

	_iinspector_on_streamdeck_open(event) {
		let ev = new Event("open", { "bubbles": true });
		ev.data = event;
		this.dispatchEvent(ev);
		this.log("Ready to Work.");
	}

	_iinspector_on_streamdeck_close(event) {
		let ev = new Event("close", { "bubbles": true });
		ev.data = event;
		this.dispatchEvent(ev);
	}

	_iinspector_on_streamdeck_error(event) {
		let ev = new Event("error", { "bubbles": true });
		ev.data = event;
		this.dispatchEvent(ev);
	}

	_iinspector_on_streamdeck_sendToInspector(event) {
		event.preventDefault();
		if (config.debug_inspector) {
			this.log(`RECV ${JSON.stringifyEx(event.payload)}`);
		}
		this._rpc.recv(event.payload);
	}
	_iinspector_on_init_inspector(event){
		event.preventDefault();
		this.initReset();
		this.reply(event.data.id(), "OK");
	}

	// ---------------------------------------------------------------------------------------------- //
	// RPC Messaging
	// ---------------------------------------------------------------------------------------------- //
	get rpc() {
		return this._rpc;
	}

	notify(method, parameters = undefined, ...extra) {
		this._rpc.notify(method, parameters, {
			"context": this._context,
		}, ...extra);
	}

	call(method, callback, parameters = undefined, timeout = 10000, ...extra) {
		this._rpc.call(method, callback, parameters, timeout, {
			"context": this._context,
		}, ...extra);
	}

	reply(id, result, error = undefined, ...extra) {
		this._rpc.reply(id, result, error, {
			"context": this._context,
		}, ...extra);
	}

	// This function handles log information from the RPC handler.
	_iinspector_on_rpc_log(event) {
		this.log(`${event.data}`);
	}

	// This function handles network sends from the RPC handler.
	_iinspector_on_rpc_send(event) {
		if (config.debug_inspector) {
			this.log(`SEND ${JSON.stringifyEx(event.data)}`);
		}
		this.streamdeck.sendToPlugin(event.data);
	}

	_tryEvent(type, callback, ...args){
		if (this._initialized >= this._initOrder.length || this._unserialized.has(type)){
			// Just pass through if everything is already initialized
			return callback(...args);
		}

		for(const init of this._initOrder ){
			if (init.initialized){
				if (init.type == type){
					return callback(...args);
				}
				continue;
			}
			if (init.type != type){
				this._actionQueue.push(()=>{
					return this._tryEvent(type, callback, ...args);});
				return;
			}
			try{
				init.initialized = true;
				this._initialized++;
				const result = callback(...args);
				const queue = this._actionQueue;
				this._actionQueue = [];
				for(const action of queue){
					action();
				}
				return result;
			}
			catch (e){
				init.initialized = false;
				this._initialized--;
				this.log("Unable to initialise " + type);
			}
			return;
		}
	}

	addEventListener(type, callback, options){
		if( typeof type == "object" && type.type){
			type = type.type;
		}

		return super.addEventListener(type, (...args)=>{
			this._tryEvent(type, callback, ...args);
		}, options);
	}

	// initDep will let us specify a sequence of init message dependencies that must arrive in a serial fashion.
	// The order of processing is the order that the deps are declared
	// All messages will be held in a queue until either:
	// - A message of that type has already been handled
	// - All message types in the init queue have been handled
	initDep(type){
		for(const init of this._initOrder){
			if(init.type == type){
				throw new Error("That message type is already in the init list!");
			}
		}

		const dep = {
			type: type,
			initialized: false
		};

		this._initOrder.push(dep);
		return dep;
	}

	haveDep(dep) {
		return dep.initialized;
	}

	resetDep(...deps) {
		const args = [];
		for(const dep of deps){
			args.push(dep.type);
		}
		return this.initResetSpecific(...args);
	}

	resetAfterDep(dep, includeSelf = false) {
		return this.initReset(dep.type, includeSelf);
	}

	// initDontBlock prevents a given event type from being blocked
	initDontBlock(type){
		this._unserialized.add(type);
	}

	// Reset the init state for the specified message type.
	// If resetFollowing is true, reset all subsequent messages in the queue.
	// If no type is given, reset the whole queue.
	initReset(type, resetSelf = true, resetFollowing = true){
		let resetting = true;
		if(type){
			resetting = false;
		}

		for(const init of this._initOrder ){
			if(!resetting && init.type == type){
				resetting = true;
			}
			if (resetting){
				if( resetSelf || init.type != type ) {
					init.initialized = false;
				}
				if (!resetFollowing) {
					break;
				}
			}
		}

		let initialized = 0;
		for(const init of this._initOrder ){
			if(init.initialized){
				initialized++;
			}
		}

		this._initialized = initialized;
	}

	// Reset the init state for several specific types.
	initResetSpecific(...types){
		for(const init of this._initOrder ){
			for( const type of types){
				if( init.type == type ){
					init.initialized = false;
				}
			}
		}

		let initialized = 0;
		for(const init of this._initOrder ){
			if(init.initialized){
				initialized++;
			}
		}

		this._initialized = initialized;
	}

	addSliderTooltip(slider, textFn) {
		if (typeof textFn != "function"){
			textFn = (value)=>{
				return value;
			}
		}
		const adjustSlider = slider;
		const tooltip = document.querySelector('.sdpi-info-label');

		// Add clickable labels
		const parent = slider.parentNode;
		if (parent){
			const clickables = parent.getElementsByClassName("clickable");
			for( const clickable of clickables){
				const value = clickable.getAttribute("x-value");
				if (value){
					clickable.addEventListener('click', (event)=>{
						slider.value = value;
						let ev = new Event("change", { "bubbles": true, "cancelable": true });
						slider.dispatchEvent(ev);
					})
				}
			}
		}

		tooltip.textContent = textFn(parseFloat(adjustSlider.value));

		const fn = () => {
			const tw = tooltip.getBoundingClientRect().width;
			const rangeRect = adjustSlider.getBoundingClientRect();
			const w = rangeRect.width - tw / 2;
			const percnt = (adjustSlider.value - adjustSlider.min) / (adjustSlider.max - adjustSlider.min);
			if (tooltip.classList.contains('hidden')) {
				tooltip.style.top = '-1000px';
			} else {
				tooltip.style.left = `${rangeRect.left + Math.round(w * percnt) - tw / 4}px`;
				tooltip.textContent = textFn(parseFloat(adjustSlider.value));
				tooltip.style.top = `${rangeRect.top - 30}px`;
			}
		}

		if (adjustSlider) {
			adjustSlider.addEventListener(
				'mouseenter',
				function() {
					tooltip.classList.remove('hidden');
					tooltip.classList.add('shown');
					fn();
				},
				false
			);

			adjustSlider.addEventListener(
				'mouseout',
				function() {
					tooltip.classList.remove('shown');
					tooltip.classList.add('hidden');
					fn();
				},
				false
			);

			adjustSlider.addEventListener('input', fn, false);
		}
	}
}
