/** reaches out for a magical global localization object, hopefully loaded by $SD and swaps the string **/
String.prototype.lox = function () {
	var a = String(this);
	try {
		a = $localizedStrings[a] || a;
	} catch (b) {
	}
	return a;
};

String.prototype.sprintf = function (inArr) {
	let i = 0;
	const args = inArr && Array.isArray(inArr) ? inArr : arguments;
	return this.replace(/%s/g, function () {
		return args[i++];
	});
};

WebSocket.prototype.sendJSON = function (jsn, log) {
	if (log) {
		console.log('SendJSON', this, jsn);
	}
	// if (this.readyState) {
	this.send(JSON.stringify(jsn));
	// }
};
