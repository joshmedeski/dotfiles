// This is a subset of the common.js used in other Elgato plugins. Expand/replace as needed

// don't change this to let or const, because we rely on var's hoisting
// eslint-disable-next-line no-use-before-define, no-var
var $localizedStrings = $localizedStrings || {};

/* eslint no-extend-native: ["error", { "exceptions": ["String"] }] */
String.prototype.lox = function () {
	var a = String(this);
	try {
		a = $localizedStrings[a] || a;
	} catch (b) { }
	return a;
};

String.prototype.sprintf = function (inArr) {
	let i = 0;
	const args = inArr && Array.isArray(inArr) ? inArr : arguments;
	return this.replace(/%s/g, function () {
		return args[i++];
	});
};

// eslint-disable-next-line no-unused-vars
const sprintf = (s, ...args) => {
	let i = 0;
	return s.replace(/%s/g, function () {
		return args[i++];
	});
};

const Utils_readJson = function (file, callback, async = true) {
	var req = new XMLHttpRequest();
	req.onerror = function (e) {
		// Utils.log(`[Utils][readJson] Error while trying to read  ${file}`, e);
	};
	req.overrideMimeType("application/json");
	req.open("GET", file, async);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			// && req.status == "200") {
			if (callback) callback(req.responseText);
		}
	};
	req.send(null);
};
const Utils_parseJson = function (jsonString) {
	if (typeof jsonString === "object") return jsonString;
	try {
		const o = JSON.parseEx(jsonString);

		// Handle non-exception-throwing cases:
		// Neither JSON.parseEx(false) or JSON.parseEx(1234) throw errors, hence the type-checking,
		// but... JSON.parseEx(null) returns null, and typeof null === "object",
		// so we must check for that, too. Thankfully, null is falsey, so this suffices:
		if (o && typeof o === "object") {
			return o;
		}
	} catch (e) { }

	return false;
};

const loadLocalization = (lang, pathPrefix, cb) => {
	Utils_readJson(`${pathPrefix}${lang}.json`, function (jsn) {
		const manifest = Utils_parseJson(jsn);
		$localizedStrings = manifest && manifest.hasOwnProperty("Localization") ? manifest["Localization"] : {};
		if (cb && typeof cb === "function") cb();
	});
};

const relocalize = () => {
	const root = document.getRootNode();
	const descend = (node, localizedParent) => {
		const localize = (node.getAttribute && node.getAttribute("localize")) !== undefined;

		if (node.nodeType === node.TEXT_NODE && (localize || localizedParent)) {
			node.textContent = node.textContent.lox();
		} else if (node.placeholder && localize !== undefined) {
			node.placeholder = node.placeholder.lox();
		} else {
			node.childNodes.forEach(child => {
				descend(child, localize);
			});
		}
	};
	descend(root);
};

// Helper to truncate entries in select inputs
String.prototype.truncateOption = function () {
	var a = String(this);
	if( a.length < config.truncateOptions ){
		return a;
	}
	return a.substr(0, config.truncateOptions) + "…";
};

// In-place implementations to replace keys in sets/maps since we care about ordering
Set.prototype.replaceAt = function(from, to){
	const newSet = new Set();
	this.forEach((v)=>{
		if (v != from){
			newSet.add(v);
		} else {
			newSet.add(to);
		}
	})
	return newSet;
}

Map.prototype.replaceAt = function(from, to){
	const newMap = new Map();
	this.forEach((v, k)=>{
		if (k != from){
			newMap.set(k, v);
		} else {
			newMap.set(to, v);
		}
	})
	return newMap;
}

class debouncer {
	constructor(timeout, maxDuration = null) {
		this.timeout_time = timeout;
		this.max_duration = maxDuration;
		this.timeout_ref = null;
		this.deadline = null;
		this.scheduled_time = null;
	}
	_call_nolimit(fn){
		if (this.timeout_ref != null) {
			clearTimeout(this.timeout_ref);
		}
		this.timeout_ref = setTimeout(() => {
			this.timeout_ref = null;
			fn();
		}, this.timeout_time);
	}

	_call_limit(fn){
		if (this.timeout_ref != null) {
			clearTimeout(this.timeout_ref);
			if (this.scheduled_time > this.deadline){
				fn();
				this.deadline = null;
			}
		}
		if (!this.deadline){
			this.deadline = Date.now() + this.max_duration;
		}
		this.scheduled_time = Date.now() + this.timeout_time;
		this.timeout_ref = setTimeout(() => {
			this.timeout_ref = null;
			this.deadline = null;
			this.scheduled_time = null;
			fn();
		}, this.timeout_time);
	}

	call(fn) {
		if(this.max_duration){
			return this._call_limit(fn);
		} else {
			return this._call_nolimit(fn);
		}
	}
}

// Helper to guarantee a value is retrieved from an Object.
Object.prototype.getProperty = function (name, defaultValue = undefined) {
	if (this[name] !== undefined) {
		return this[name];
	}
	return defaultValue;
}

String.prototype.encodeSVG = function(){
	return "data:image/png;base64," + btoa(this);
}
