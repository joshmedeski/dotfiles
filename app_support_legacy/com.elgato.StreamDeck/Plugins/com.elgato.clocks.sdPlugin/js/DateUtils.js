class DateUtils {
    #cache = {
        locations: [],
        timeZone: ''
    };
    _lastUpdate = 0;
    _minimumUpdateDelay = 500;
    dateOptions = {
        long: {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'},
        short: {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'},
        veryshort: {year: 'numeric', month: 'short', day: 'numeric'},
        narrow: {weekday: 'narrow', year: 'numeric', month: 'short', day: 'numeric'}
    };

    timeOptions = {
        short: {hour: '2-digit', minute: '2-digit'},
        long: {hour: '2-digit', minute: '2-digit', second: '2-digit'}
    };

    hour12 = false;
    dbg = console.log.bind(
        console,
        `%c [DateUtils]`,
        'color: #cc9',
    );

    constructor () {
        // if(this instanceof DateUtils) {
        //     throw Error('DialUtils cannot be instantiated.');
        // }
        this._settings = this.updateClockSettings();
    }

    get timeIsRipe() {
        return this._lastUpdate + this._minimumUpdateDelay < Date.now();
    }
    get settings() {
        return this.timeIsRipe ? this.updateClockSettings() : this._settings;
    }
    set settings(obj) {
        this._settings = obj;
        return this._settings;
    }

    get cache() {
        return this.#cache;
    }

    // set cache(obj) {
    //     this.#cache = obj;
    // }

    get locations() {
        return this.cache.locations || [];
    }

    set locations(obj) {
        this.#cache.locations = Array.isArray(obj) ? obj : [];
        return this.#cache.locations;
    }

    get timeZone() {
        // return this.cache.timeZone || 'America/New_York';
        return this.#cache.timeZone || '';
    }
    set timeZone(obj) {
        this.#cache.timeZone = obj;
    }

    /**
	 * Checks, if the value for the given key has changed.
	 * @param { string } key
     * @param { any } value
     * @returns { boolean }
	 */

    changedInCache(key, value) {
        return this.#cache.hasOwnProperty(key) && this.#cache[key] !== value;
    }

    /**
	 * Checks, if the value for the given key has changed. If so, the value is updated in the cache and the new value is returned.
	 * @param {string} key
     * @param {any} value
     * @param {boolean} returnValue  // specify, if the value should be returned or just a boolean to indicate, if the value has changed
     * @returns {any}  // returns the value, if returnValue is true, otherwise a boolean
	 */

    getFromCache(key, value, returnValue = true) {
        const hasProperty = this.#cache.hasOwnProperty(key);
        if(!hasProperty || (hasProperty && this.#cache[key] !== value)) {
            this.#cache[key] = value;
            return returnValue ? value : true;
        }
        return returnValue ? this.#cache[key] : false;
    }

    cycle(idx, max) {
        return (idx > max ? 0 : idx < 0 ? max : idx);
    }
    updateClockSettings(timeZone = '') {
        this.dbg('updateClockSettings', this.timeIsRipe);
        const dateForTimeZone = (date, timeZone, locale = 'en-US') => new Date(date.toLocaleString('en-US', {timeZone}));
        const date = timeZone.length ? new Date(new Date().toLocaleString('en-US', {timeZone})) : new Date();
        const hours = date.getHours();
        const minutes = date.getMinutes();
        const seconds = date.getSeconds();
        const offs = 0;
        this._lastUpdate = date.getTime();
        // const m = Math.round((minutes + seconds / 60) * 6); // rounding helps to reduce the number of redraws 

        this.settings = {
            minutes,
            seconds,
            hours,
            dateString: date.toLocaleDateString(),
            dateObj: {
                long: date.toLocaleDateString([], this.dateOptions.long),
                short: date.toLocaleDateString([], this.dateOptions.short),
                narrow: date.toLocaleDateString([], this.dateOptions.narrow)
            },
            timeString: date.toLocaleTimeString(),
            timeObj: {
                long: date.toLocaleTimeString([], {...this.timeOptions.long, hour12: this.hour12}),
                short: date.toLocaleTimeString([], {...this.timeOptions.short, hour12: this.hour12})
            },
            weekday: date.toLocaleDateString([], {weekday: 'long'}),
            minDeg: (minutes + seconds / 60) * 6 + offs,
            secsDeg: seconds * 6 + offs,
            hourDeg: ((hours % 12) + minutes / 60) * 360 / 12 + offs,
            minsDeg: (minutes + seconds / 60) * 6 + offs,
            hoursDeg: ((hours % 12) + minutes / 60) * 360 / 12 + offs
        };
        return this.settings;
    };

}

// const ELGDATEUTILS = new DateUtils();
