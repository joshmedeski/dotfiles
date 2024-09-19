/** ELGEvents
 * Publish/Subscribe pattern to quickly signal events to
 * the plugin, property inspector and data.
 */

const ELGEvents = {
	eventEmitter: function (name, fn) {
		const eventList = new Map();

		const on = (name, fn) => {
			if (!eventList.has(name)) eventList.set(name, ELGEvents.pubSub());

			return eventList.get(name).sub(fn);
		};

		const has = name => eventList.has(name);

		const emit = (name, data) => eventList.has(name) && eventList.get(name).pub(data);

		return Object.freeze({on, has, emit, eventList});
	},

	pubSub: function pubSub() {
		const subscribers = new Set();

		const sub = fn => {
			subscribers.add(fn);
			return () => {
				subscribers.delete(fn);
			};
		};

		const pub = data => subscribers.forEach(fn => fn(data));
		return Object.freeze({pub, sub});
	}
};

const EventEmitter = ELGEvents.eventEmitter();