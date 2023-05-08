// Copyright © 2022, Corsair Memory Inc. All rights reserved.

// TODO:
// - Proper Error handling.
// - Multi-message support (Arrays).
// - get/set upgrades.
// - Sync/Async differentiation.
// - Probably replace this with a proper JSON RPC library.

// TODO: Error Handling

const JSONRPC_PROTOCOL_ID = "2.0";

// ---------------------------------------------------------------------------------------------- //
// JSON RPC 2.0 Error
// ---------------------------------------------------------------------------------------------- //

const EJSONRPCERROR_PARSE_ERROR = -32700;
const EJSONRPCERROR_INVALID_REQUEST = -32600;
const EJSONRPCERROR_METHOD_NOT_FOUND = -32601;
const EJSONRPCERROR_INVALID_PARAMS = -32602;
const EJSONRPCERROR_INTERNAL_ERROR = -32603;
const EJSONRPCERROR_SERVER_ERROR = -32000;
const EJSONRPCERROR_SERVER_ERROR_MAX = -32099;

class JSONRPCError extends Error {
	constructor(p0, p1, p2) {
		super();

		// Initialize default state.
		this._locked = false;
		this._data = new Map();
		this._data.set("code", 0);
		this._data.set("message", "");

		if ((typeof p0) === "undefined") {
			return;
		} else if ((typeof p0) === "object") {
			this.parse(p0);
		} else if (((typeof p0) === "number") && ((typeof p1) === "string")) {
			this.code = p0;
			this.message = p1;
			this.data = p2;
		} else {
			throw SyntaxError("Unknown constructor for JSONRPCError.");
		}
	}

	parse(data) {
		if (this._locked) {
			throw ReferenceError("Attempted to modify an immutable instance.");
		}

		if (data !== undefined) {
			this.code = data.code;
			this.message = data.message;
			this.data = data.data;

			this._locked = true;
		} else {
			throw SyntaxError("Parameter 'data' must be a structured Object.");
		}
	}

	get code() {
		return this._data.get("code");
	}

	set code(value) {
		// Check if immutable.
		if (this._locked) {
			throw ReferenceError("Attempted to modify an immutable instance.");
		}

		// Validate Parameters
		if ((parseInt(value, 10) != value) || isNaN(value)) {
			throw SyntaxError("Value 'code' must be an Integer.");
		}

		this._data.set("code", value);
	}

	get message() {
		return this._data.get("message");
	}

	set message(value) {
		// Check if immutable.
		if (this._locked) {
			throw ReferenceError("Attempted to modify an immutable instance.");
		}

		// Validate Parameters
		if (((typeof value) !== "string") && ((typeof value) !== "String")) {
			throw SyntaxError("Value 'message' must be a String.");
		}

		this._data.set("message", value);
	}

	get data() {
		return this._data.get("data");
	}

	set data(value) {
		// Check if immutable.
		if (this._locked) {
			throw ReferenceError("Attempted to modify an immutable instance.");
		}

		if (value === undefined) {
			this._data.clear("data", value);
		} else {
			this._data.set("data", value);
		}
	}

	compile() {
		return {
			code: this.code,
			message: this.message,
			data: this.data
		};
	}

	// ----------------------------------------------- //
	// JavaScript Base API Support
	// ----------------------------------------------- //
	toString() {
		return JSON.stringifyEx(this);
	}

	serialize() {
		return this.compile();
	}

	static deserialize(data) {
		return new JSONRPCMessage(data);
	}
}

// ---------------------------------------------------------------------------------------------- //
// JSON RPC 2.0 Message (Base Type)
// ---------------------------------------------------------------------------------------------- //

class JSONRPCMessage {
	/** Create a new empty JSON RPC Message.
	 *
	 * Prefer JSONRPCRequest or JSONRPCResponse over this.
	 */
	constructor() {
		this._data = new Object();
		this._data["jsonrpc"] = JSONRPC_PROTOCOL_ID;
		this._data["id"] = undefined;
	}

	/** Parse a JSON RPC Message from data.
	 *
	 * @param {object} data An [object] that contains a valid serialization of a JSON RPC Message.
	 * @throws [TypeError] if data is not an object.
	 * @throws [Error] if data is not a valid message.
	 */
	parse(data) {
		if (typeof data === "object") {
			let old_data = this._data;
			this._data = data;
			try {
				this.validate();
			} catch (ex) {
				this._data = old_data;
				throw ex;
			}
		} else {
			throw new TypeError("data must be an object.");
		}
	}

	id(value) {
		if (value !== undefined) {
			if ((typeof value == "number") || (typeof value == "string") || (value instanceof String)) {
				this._data["id"] = value;
			} else {
				throw new TypeError("id must be a number, string or String.");
			}
		} else {
			return this._data["id"];
		}
	}

	clear_id() {
		this._data["id"] = undefined;
	}

	validate() {
		if (this._data["jsonrpc"] != JSONRPC_PROTOCOL_ID) {
			throw new Error("Unknown JSON RPC protocol Id.");
		}
	}

	compile() {
		this.validate();
		return this._data;
	}
}

// ---------------------------------------------------------------------------------------------- //
// JSON RPC 2.0 Request
// ---------------------------------------------------------------------------------------------- //

/** A JSON RPC request.
 *
 */
class JSONRPCRequest extends JSONRPCMessage {
	/** Create a JSON RPC Request, optionally from a serialized message.
	 *
	 * @param {object|undefined} data An optional [object] that contains all the required information for this type of message.
	 */
	constructor(data) {
		super();
		this._data["method"] = "";
		this._data["params"] = undefined;

		if (data != undefined) {
			this.parse(data);
		}
	}

	method(value) {
		if (value !== undefined) {
			if ((typeof value === "string") || (value instanceof String)) {
				this._data["method"] = value;
			} else {
				throw new TypeError("method must be a string or String.");
			}
		} else {
			return this._data["method"];
		}
	}

	parameters(value) {
		if (value !== undefined) {
			if ((typeof value === "object") || (value instanceof Array) || (value instanceof Object)) {
				this._data["params"] = value;
			} else {
				throw new TypeError("params must be a string or String.");
			}
		} else {
			return this._data["params"];
		}
	}

	clear_params() {
		this._data["params"] = undefined;
	}

	validate() {
		super.validate();
		// TODO: Validation
	}

	// ----------------------------------------------- //
	// JavaScript Base API Support
	// ----------------------------------------------- //
	toString() {
		return JSON.stringifyEx(this);
	}

	serialize() {
		return this.compile();
	}

	static deserialize(data) {
		return new JSONRPCMessage(data);
	}
}

// ---------------------------------------------------------------------------------------------- //
// JSON RPC 2.0 Response
// ---------------------------------------------------------------------------------------------- //

/** As response to a previous JSON RPC request.
 *
 */
class JSONRPCResponse extends JSONRPCMessage {
	/** Create a JSON RPC Response, optionally from a serialized message.
	 *
	 * @param {object|undefined} data An optional [object] that contains all the required information for this type of message.
	 */
	constructor(data) {
		super();
		this._data["result"] = undefined;
		this._data["error"] = undefined;

		if (data != undefined) {
			this.parse(data);
		}
	}

	result(value) {
		if (value !== undefined) {
			this._data["result"] = value;
			this._data["error"] = undefined;
		} else {
			return this._data["result"];
		}
	}

	error(value) {
		if (value !== undefined) {
			if ((typeof value === "object") || (value instanceof Object)) {
				this._data["error"] = value;
				this._data["result"] = undefined;
			} else {
				throw new TypeError("error must be a object.");
			}
		} else {
			return this._data["error"];
		}
	}

	validate() {
		super.validate();
		// TODO: Validation
	}

	// ----------------------------------------------- //
	// JavaScript Base API Support
	// ----------------------------------------------- //
	toString() {
		return JSON.stringifyEx(this);
	}

	serialize() {
		return this.compile();
	}

	static deserialize(data) {
		return new JSONRPCMessage(data);
	}
}

// ---------------------------------------------------------------------------------------------- //
// Abstract RPC Handler
// ---------------------------------------------------------------------------------------------- //

/** Abstract RPC messaging handler.
 *
 * Does not implement networking, instead relies on events to push the responsibility to other parties.
 */
class RPC extends EventTarget {
	/** Create a new RPC handler.
	 *
	 * @param {(string|String)} [prefix] Prefix to prepend to any event names.
	 * @param {EventTarget} [event_target] An optional EventTarget on which events should be dispatched.
	 */
	constructor(prefix, event_target) {
		super();

		this._calls = new Map();
		this._prefix = prefix !== undefined ? prefix : "rpc.";
		this._target = event_target !== undefined ? event_target : this;

		// Add receive handler.
		this.addEventListener("recv", (event) => {
			this._on_recv(event);
		});
	}

	_on_recv(event) {
		if (!event.data) {
			throw SyntaxError("Invalid call to recv()");
		}

		if ((event.data.result !== undefined) || (event.data.error !== undefined)) {
			// This is a Response
			let message = new JSONRPCResponse(event.data);
			let message_id = message.id();
			if (message_id != undefined) {
				if (this._calls.has(message_id)) {
					let callback_object = this._calls.get(message_id);
					window.clearTimeout(callback_object.timeout);
					this._calls.delete(message_id);
					try {
						callback_object.callback(message.result(), message.error(), ...event.extra);
					} catch (ex) {
						this.log(`Callback for '${message_id}' caused exception:\n` + ex.stack, ...event.extra);
					}
				} else {
					// Received response for unknown invalid id.
					this.log(`Received response for unknown id '${message_id}'.`, ...event.extra);
				}
			} else {
				// Received response with no id.
				this.log("Received response with no id.", ...event.extra);
			}
		} else {
			// This is a Request
			let message = new JSONRPCRequest(event.data);

			// Try to call any handlers for this request.
			try {
				let ev = new Event(`${this._prefix}${message.method()}`, { "bubbles": true, "cancelable": true });
				ev.data = message;
				ev.extra = event.extra;
				if (this._target.dispatchEvent(ev) && config.debug) {
					let id = message.id();
					if (id) {
						this.log(`RPC call with id '${id}' for method '${message.method()}' was not handled.`, ...event.extra);
					} else {
						this.log(`RPC notification for method '${message.method()}' was not handled.`, ...event.extra);
					}
				}
			} catch (ex) {
				this.log("Request failed with exception: \n" + ex.stack, ...event.extra);
			}
		}
	}

	_on_timeout(cbo, id, callback, extra) {
		// Remove the call from the active call list.
		if (this._calls.has(id)) {
			this._calls.delete(id);
		}

		// Do the whole callback thing, but with both arguments undefined.
		callback(undefined, undefined, ...extra);
	}

	_on_abort(cbo, id, callback, extra) {
		// Remove the call from the active call list.
		if (this._calls.has(id)) {
			this._calls.delete(id);
		}

		// Kill any pending timeouts for this immediately.
		window.clearTimeout(cbo.timeout);

		// Signal the callback that an error has occured, or we timed out.
		callback(undefined, new JSONRPCError(EJSONRPCERROR_INTERNAL_ERROR, cbo.abortable.signal.reason, undefined), ...extra);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Logging
	// ---------------------------------------------------------------------------------------------- //
	log(message, ...extra) {
		let ev = new Event("log", { "bubbles": true });
		ev.data = message;
		ev.extra = extra;
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// Networking
	// ---------------------------------------------------------------------------------------------- //
	recv(data, ...extra) {
		let ev = new Event("recv", { "bubbles": true });
		ev.data = data;
		ev.extra = extra;
		this.dispatchEvent(ev);
	}

	send(data, ...extra) {
		let ev = new Event("send", { "bubbles": true });
		ev.data = data;
		ev.extra = extra;
		this.dispatchEvent(ev);
	}

	// ---------------------------------------------------------------------------------------------- //
	// RPC
	// ---------------------------------------------------------------------------------------------- //
	/** Notify the remote of an event.
	 *
	 * @param {(string|String)} method Method to call on the remote.
	 * @param {(Object|Array)} [parameters] Parameters to send to the remote.
	 */
	notify(method, parameters = undefined, ...extra) {
		if (!((method instanceof String) || (typeof method == "string"))) {
			throw TypeError("method must be a String or string.");
		}
		if (parameters && !((parameters instanceof Object) || Array.isArray(parameters))) {
			throw TypeError("parameters must be a Object or Array.");
		}

		let message = new JSONRPCRequest();
		message.clear_id();
		message.method(method);
		if (parameters) {
			message.parameters(parameters);
		}

		this.send(message.compile(), ...extra);
	}

	/** Call a function on the remote process.
	 *
	 * @param {(string|String)} method Method to call on the remote.
	 * @param {function} callback Callback to call for the response to this message. Should be in the format 'function(result, error)' where result is the returned result, and error is a JSON-RPC 2.0 error object.
	 * @param {(Object|Array)} [parameters] Parameters to send to the remote.
	 * @param {int} [timeout] Timeout after which the call forcefully fails.
	 * @return {*} The unique Id for this call, used to identify which callback to call. OR undefined if not connected
	 */
	call(method, callback, parameters = undefined, timeout = 10000, ...extra) {
		if (!((method instanceof String) || (typeof method == "string"))) {
			throw TypeError("method must be a String or string.");
		}
		if (typeof callback != "function") {
			throw TypeError("callback must be a Function.");
		}
		if (parameters && !((parameters instanceof Object) || Array.isArray(parameters))) {
			throw TypeError("parameters must be a Object or Array.");
		}

		// Generate a unique identifier local to this RPC handler.
		let id = uuid(); // Use the function from uuid.js

		// Create a new JSON-RPC Request.
		let message = new JSONRPCRequest();
		message.id(id);
		message.method(method);
		if (parameters !== undefined) {
			message.parameters(parameters);
		}

		// Submit RPC request.
		this.send(message.compile(), ...extra);

		// Build callback object and start timeout.
		let callback_object = {
			"callback": callback,
			"abortable": new AbortController(),
			"timeout": null,
			"extra": extra
		};
		callback_object.timeout = window.setTimeout(() => {
			this._on_timeout(callback_object, id, callback, extra);
		}, timeout);
		callback_object.abortable.signal.addEventListener("abort", () => {
			this._on_abort(callback_object, id, callback, extra);
		});

		// Insert callback into known list.
		this._calls.set(id, callback_object);

		// Return the id of the call.
		return id;
	}

	/** Send a reply for a call.
	 *
	 *
	 */
	reply(id, result, error = undefined, ...extra) {
		if ((typeof id != "number") && (typeof id != "string") && !(id instanceof String)) {
			throw TypeError("id must be number, string or String.");
		}
		if ((result == undefined) && (error == undefined)) {
			throw SyntaxError("result or error must be provided.");
		}
		if (result && error) {
			throw SyntaxError("result can't be provided if error is also provided.");
		}
		if (error && (typeof error != "object") && !(error instanceof Object)) {
			throw TypeError("error must be an Object.");
		}

		let rpc = new JSONRPCResponse();
		rpc.id(id);
		if (result !== undefined) {
			rpc.result(result);
		} else {
			rpc.error(error);
		}

		this.send(rpc.compile(), ...extra);
	}

	/** Cancel a running call and run their handlers.
	 *
	 * @param {undefined|any} id The id of the handler to cancel, or undefined to cancel all.
	 */
	cancel(id = undefined) {
		if (id !== undefined) {
			let cbo = this._calls.get(id);
			if (cbo !== undefined) {
				cbo.abortable.abort();
			} else {
				throw new ReferenceError("Unknown call id.");
			}
		} else {
			for (let cbo of this._calls.entries()) {
				cbo[1].abortable.abort();
			}
		}
	}
}
