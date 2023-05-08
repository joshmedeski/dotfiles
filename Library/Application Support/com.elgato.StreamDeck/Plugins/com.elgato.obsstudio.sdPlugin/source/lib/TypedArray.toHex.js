// Copyright 2020 Michael Fabian 'Xaymar' Dirks
// BSD 3-Clause

// Adapted from: https://blog.xaymar.com/2020/12/08/fastest-uint8array-to-hex-string-conversion-in-javascript/

// Pre-Init
const LUT_HEX_4b = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
const LUT_HEX_8b = new Array(0x100);
for (let n = 0; n < 0x100; n++) {
	LUT_HEX_8b[n] = LUT_HEX_4b[(n >>> 4) & 0xF] + LUT_HEX_4b[n & 0xF];
}

let typedarray_toHex_raw = function() {
	let out = "";
	for (let idx = 0, edx = this.length; idx < edx; idx++) {
		out += LUT_HEX_8b[this[idx]];
	}
	return out;
};
let typedarray_toHex = function() {
	let buf = new Uint8Array(this.buffer);
	return typedarray_toHex_raw.call(buf);
};

if (Uint8Array)
	Uint8Array.prototype.toHex = typedarray_toHex_raw;
if (Int8Array)
	Int8Array.prototype.toHex = typedarray_toHex;
if (Uint16Array)
	Uint16Array.prototype.toHex = typedarray_toHex;
if (Int16Array)
	Int16Array.prototype.toHex = typedarray_toHex;
if (Uint32Array)
	Uint32Array.prototype.toHex = typedarray_toHex;
if (Int32Array)
	Int32Array.prototype.toHex = typedarray_toHex;
if (Float32Array)
	Float32Array.prototype.toHex = typedarray_toHex;
if (Float64Array)
	Float64Array.prototype.toHex = typedarray_toHex;
if (BigInt64Array)
	BigInt64Array.prototype.toHex = typedarray_toHex;
if (BigUint64Array)
	BigUint64Array.prototype.toHex = typedarray_toHex;
