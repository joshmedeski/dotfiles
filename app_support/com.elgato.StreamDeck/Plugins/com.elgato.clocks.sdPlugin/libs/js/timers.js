/* global ESDTimerWorker */
/*eslint no-unused-vars: "off"*/
/*eslint-env es6*/

let ESDTimerWorker = new Worker(URL.createObjectURL(
	new Blob([timerFn.toString().replace(/^[^{]*{\s*/, '').replace(/\s*}[^}]*$/, '')], {type: 'text/javascript'})
));
ESDTimerWorker.timerId = 1;
ESDTimerWorker.timers = {};
const ESDDefaultTimeouts = {
	timeout: 0,
	interval: 10
};

Object.freeze(ESDDefaultTimeouts);

function _setTimer(callback, delay, type, params) {
	const id = ESDTimerWorker.timerId++;
	ESDTimerWorker.timers[id] = {callback, params};
	ESDTimerWorker.onmessage = (e) => {
		if (ESDTimerWorker.timers[e.data.id]) {
			if (e.data.type === 'clearTimer') {
				delete ESDTimerWorker.timers[e.data.id];
			} else {
				const cb = ESDTimerWorker.timers[e.data.id].callback;
				if (cb && typeof cb === 'function') cb(...ESDTimerWorker.timers[e.data.id].params);
			}
		}
	};
	ESDTimerWorker.postMessage({type, id, delay});
	return id;
}

function _setTimeoutESD(...args) {
	let [callback, delay = 0, ...params] = [...args];
	return _setTimer(callback, delay, 'setTimeout', params);
}

function _setIntervalESD(...args) {
	let [callback, delay = 0, ...params] = [...args];
	return _setTimer(callback, delay, 'setInterval', params);
}

function _clearTimeoutESD(id) {
	ESDTimerWorker.postMessage({type: 'clearTimeout', id}); //     ESDTimerWorker.postMessage({type: 'clearInterval', id}); = same thing
	delete ESDTimerWorker.timers[id];
}

window.setTimeout = _setTimeoutESD;
window.setInterval = _setIntervalESD;
window.clearTimeout = _clearTimeoutESD; //timeout and interval share the same timer-pool
window.clearInterval = _clearTimeoutESD;

/** This is our worker-code
 *  It is executed in it's own (global) scope
 *  which is wrapped above @ `let ESDTimerWorker`
 */

function timerFn() {
	/*eslint indent: ["error", 4, { "SwitchCase": 1 }]*/

	let timers = {};
	let debug = false;
	let supportedCommands = ['setTimeout', 'setInterval', 'clearTimeout', 'clearInterval'];

	function log(e) {
		console.log('Worker-Info::Timers', timers);
	}

	function clearTimerAndRemove(id) {
		if (timers[id]) {
			if (debug) console.log('clearTimerAndRemove', id, timers[id], timers);
			clearTimeout(timers[id]);
			delete timers[id];
			postMessage({type: 'clearTimer', id: id});
			if (debug) log();
		}
	}

	onmessage = function (e) {
		// first see, if we have a timer with this id and remove it
		// this automatically fulfils clearTimeout and clearInterval
		supportedCommands.includes(e.data.type) && timers[e.data.id] && clearTimerAndRemove(e.data.id);
		if (e.data.type === 'setTimeout') {
			timers[e.data.id] = setTimeout(() => {
				postMessage({id: e.data.id});
				clearTimerAndRemove(e.data.id); //cleaning up
			}, Math.max(e.data.delay || 0));
		} else if (e.data.type === 'setInterval') {
			timers[e.data.id] = setInterval(() => {
				postMessage({id: e.data.id});
			}, Math.max(e.data.delay || ESDDefaultTimeouts.interval));
		}
	};
}
