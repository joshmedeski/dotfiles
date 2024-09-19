// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class ReplayBufferInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);


		this._dep_obs = this.initDep("rpc.open");

		this.initDontBlock("rpc.close");

		this._have_replaybuffer = false;

		this.addEventListener("rpc.close", (event) => {
			this._on_rpc_close(event);
		});
		this.addEventListener(this._dep_obs, (event) => {
			this._on_rpc_open(event);
		});
		this.addEventListener("rpc.replaybuffer", (event) => {
			this._on_rpc_replaybuffer(event);
		});

		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// RPC
	// ---------------------------------------------------------------------------------------------- //
	_on_rpc_close(event) {
		event.preventDefault();
		this.initReset();
		this.validate();
	}

	_on_rpc_open(event) {
		event.preventDefault();
		this.validate();
	}

	_on_rpc_replaybuffer(event) {
		event.preventDefault();
		this._have_replaybuffer = event.data.parameters().enabled;
		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Internals
	// ---------------------------------------------------------------------------------------------- //
	validate() {
		this.clear_messages();

		if (!this.haveDep(this._dep_obs)) {
			this.show_processing_overlay("Waiting for OBS...".lox());
		} else{
			if (!this._have_replaybuffer) {
				this.add_warning("Replay Buffer is not enabled!".lox());
			}
			this.hide_overlays();
		}
	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new ReplayBufferInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
