/** 
 * ELGEventEmitter
 * Simple Pub/Sub Emitter
 */

/* eslint max-classes-per-file: ["error", 2] */
class ELGEventEmitter {
    constructor (id, debug = false) {

        // super({prefix: id, debug});
        // console.log('ELGEventEmitter', {prefix: id, debug});
        const eventList = new Map();
        const ALLEVENTS = "*";

        eventList.hasWildcard = function(name, data) {
            for(const [key, value] of this) {
                if(key !== ALLEVENTS && key.includes(ALLEVENTS) && new RegExp(`^${key.split(/\*+/).join('.*')}$`).test(name)) {
                    // console.log("WILDCARD... search: FOUND::", name, "=>", key);
                    if(data) value.pub(data, name);
                    else return true;
                }
            }
        };

        this.on = (name, fn) => {
            if(!eventList.has(name)) eventList.set(name, ELGEventEmitter.pubSub());
            return eventList.get(name).sub(fn);
        };

        this.has = name => eventList.has(name);
        this.hasMatch = name => eventList.has(name) || eventList.hasWildcard(name);
        this.emit = (name, data, ...values) => {
            eventList.has(name) && eventList.get(name).pub(data, ...values);
            eventList.has(ALLEVENTS) && eventList.get(ALLEVENTS).pub(data, ...values);
            eventList.hasWildcard(name, data);
        };
        this.eventList = eventList;

        return this;
    }

    static pubSub() {
        const subscribers = new Set();

        const sub = fn => {
            subscribers.add(fn);
            return () => {
                console.log("unsubscribe", fn);
                subscribers.delete(fn);
            };
        };

        const pub = (data,...values) => subscribers.forEach(fn => fn(data, ...values));
        return Object.freeze({pub, sub});
    }
}

/** 
 * Poller
 * Easy polling
 */

class Poller extends ELGEventEmitter {
    constructor (timeout = 2000) {
        super();
        this.timeout = timeout;
        this.timer = null;
        this.lastTime = 0;
    }

    poll() {
        this.lastTime = Date.now();
        this.timer = setTimeout(() => this.emit('poll'), this.timeout);
    }

    startPolling() {
        this.poll();
    }

    stopPolling() {
        clearTimeout(this.timer);
        this.timer = null;
    }

    onPoll(cb) {
        this.on('poll', () => {
            if(cb) cb(Date.now() - this.lastTime);
            this.poll();
        });
    }
}

const EventEmitter = new ELGEventEmitter();
