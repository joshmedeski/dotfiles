// Copyright © 2022, Corsair Memory Inc. All rights reserved.

class RecordPauseInspector extends IInspector {
	constructor(uPort, uUUID, uEvent, uInfo, uActionInfo) {
		super(uPort, uUUID, uEvent, uInfo, uActionInfo);

		this._dep_obs = this.initDep("rpc.open");
		this.initDontBlock("rpc.close");

		this._is_recording = false;

		this.addEventListener("rpc.close", (event) => {
			this._on_rpc_close(event);
		});
		this.addEventListener(this._dep_obs, (event) => {
			this._on_rpc_open(event);
		});
		this.addEventListener("rpc.recording", (event) => {
			this._on_rpc_recording(event);
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

	_on_rpc_recording(event) {
		event.preventDefault();
		this._is_recording = event.data.parameters().active;
		this.validate();
	}

	// ---------------------------------------------------------------------------------------------- //
	// Internals
	// ---------------------------------------------------------------------------------------------- //
	validate() {
		this.clear_messages();

		if (!this.haveDep(this._dep_obs)) {
			this.show_processing_overlay("Waiting for OBS...".lox());
		}
		else {
			this.hide_overlays();
			if (!this._is_recording) {
				this.add_hint("To pause a recording start recording first.".lox());
			}
		}

	}
}

let instance = null;
function connectElgatoStreamDeckSocket(inPort, inPluginUUID, inRegisterEvent, inInfo, inActionInfo) {
	try {
		instance = new RecordPauseInspector(inPort, inPluginUUID, inRegisterEvent, JSON.parseEx(inInfo), JSON.parseEx(inActionInfo));
	} catch (ex) {
		console.error(ex, ex.stack);
	}
}
