function fromDBFS(v) {
	return Math.pow(10, v / 20);
}
function toDBFS(v) {
	return 20 * Math.log10(v);
}
function percentToDBFS(value) {
	const offset = 6;
	const limit = 96;
	if (value <= 0) return -Infinity;
	if (value >= 1) return 0.;
	let n = limit + offset;
	return -(n * Math.pow(n / offset, -value)) + offset;
}

function DBFSToPercent(value) {
	const offset = 6;
	const limit = 96;
	if (value <= -limit) return 0.;
	if (value >= 0) return 1.;
	let n = limit + offset;
	let n10 = Math.log10(n);
	return (n10 - Math.log10(-value + offset)) / (n10 - Math.log10(offset));
}
