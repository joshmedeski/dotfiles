// Copyright © 2022, Corsair Memory Inc. All rights reserved.

function JSONReviver(key, value) {
	if (value instanceof Object) {
		if (value.__class !== undefined) {
			let type = eval(value.__class);
			if (typeof (type.deserialize) === "function") {
				return type.deserialize(value.__value);
			} else {
				return type.constructor(value.__value);
			}
		} else {
			return value;
		}
	} else {
		return value;
	}
}

function JSONReplacer(key, value) {
	if (value instanceof Object) {
		if (typeof (value.serialize) === "function") {
			return {
				__class: value.constructor.name,
				__value: value.serialize()
			};
		}
		return value;
	} else {
		return value;
	}
}

JSON.stringifyEx = function (value, space) {
	return JSON.stringify(value, JSONReplacer, space);
};

JSON.parseEx = function (value) {
	return JSON.parse(value, JSONReviver);
};

// Class Support: Map
Map.prototype.serialize = function () {
	return [...this];
};
Map.deserialize = function (value) {
	return new Map(value);
};
