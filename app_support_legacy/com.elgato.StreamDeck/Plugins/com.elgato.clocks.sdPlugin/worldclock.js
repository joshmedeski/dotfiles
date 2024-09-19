/// <reference path="libs/js/stream-deck.js" />
/// <reference path="libs/js/action.js" />
/// <reference path="libs/js/utils.js" />

// Action Cache
const MACTIONS = {};
const MCOLORRAMP = 75;

// Utils
const minmax = (v = 0, min = 0, max = 100) => Math.min(max, Math.max(min, v));
const cycle = (idx, min, max) => (idx > max ? min : idx < min ? max : idx);
const round = (n) => Math.round((n + Number.EPSILON) * 100) / 100;
// make sure to pass in a hex 7char-length color string (e.g. #336699)
const invertColor = (hexColor) => `#${(Number(`0x1${hexColor.slice(1)}`) ^ 0xFFFFFF).toString(16).slice(1).toUpperCase()}`;
const isLightColor = (hexColor, ramp = 127) => {
    const color = +("0x" + hexColor.slice(1).replace(hexColor.length < 5 && /./g, '$&$&'));
    const [r, g, b] = [color >> 16, color >> 8 & 255, color & 255];  // hex to rgb
    const hsp = Math.sqrt(0.299 * (r * r) + 0.587 * (g * g) + 0.114 * (b * b)); // HSP see: http://alienryderflex.com/hsp.html
    console.log('isLightColor', hexColor, hsp, ramp);
    return (hsp > ramp);
};
const isDarkColor = (hexColor, ramp) => !isLightColor(hexColor, ramp);
const complementaryColor = (color) => {
    const tag = (a, b) => (255 - parseInt(color.substring(a, b), 16)).toString(16).slice(-2);
    return `#${tag(1, 3)}${tag(3, 5)}${tag(5, 7)}`.toUpperCase();
};
const fadeColor = function(col, amt) {
    const min = Math.min,
        max = Math.max;
    const num = parseInt(col.replace(/#/g, ''), 16);
    const r = min(255, max((num >> 16) + amt, 0));
    const g = min(255, max((num & 0x0000ff) + amt, 0));
    const b = min(255, max(((num >> 8) & 0x00ff) + amt, 0));
    return '#' + (g | (b << 8) | (r << 16)).toString(16).padStart(6, 0);
};

// Action Events
const worldClockAction = new Action('com.elgato.worldclock.action')
    .onWillAppear(({context, payload}) => {
        MACTIONS[context] = new WorldClockAction(context, payload);
    })
    .onWillDisappear(({context}) => {
        MACTIONS[context].willDisappear();
        delete MACTIONS[context];
    })
    .onDidReceiveSettings(({context, payload}) => {
        MACTIONS[context].didReceiveSettings(payload);
    })
    .onKeyUp(({context, payload}) => {
        MACTIONS[context].keyUp(payload);
    })
    .onDialPress(({context, payload}) => {
        MACTIONS[context].dialPress(payload);
    })
    .onDialRotate(({context, payload}) => {
        MACTIONS[context].dialRotate(payload);
    })
    .onTouchTap(({context, payload}) => {
        MACTIONS[context].touchTap(payload);
    });

// worldClockAction.onTitleParametersDidChange(({context, payload}) => {
//     // console.log('onTitleParametersDidChange', context, payload);
//     MACTIONS[context].titleParametersDidChange(payload);
// });

class WorldClockAction {
    #cache = {
        svg: '',
        time: 0
    };
    intervall = null;
    saveLock = false;

    constructor (context, payload) {
        this.language = Utils.detectLanguage();
        this.context = context;
        this.isEncoder = payload?.controller === 'Encoder';
        this.settings = {
            ...{
                mode: 0,
                hour12: false,
                locations: [],
                longDateAndTime: false,
                color: '#EFEFEF',
                showTicks: true
            }, ...payload?.settings
        };
        this.dimmedColor = fadeColor(this.settings.color, -50);
        // this.invertedColor = isLightColor(this.color, MCOLORRAMP) ? '#0078FF' : invertColor(this.color);
        this.fontFamily = "Arial, Helvetica, sans-serif";
        this.ticks = '';
        this.size = 48; // default size of the icon is 48
        // $SD.setFeedbackLayout(this.context, './action/customlayout.json');
        this.init();
        this.saveSettings(true); // save settings and update the UI
    }

    init() {
        this.interval = setInterval(() => {
            this.update();
        }, 1000);
    }

    get cache() {
        return this.#cache;
    }

    get color() {
        return this.settings.color;
    }

    set color(value) {
        this.settings.color = value;
        this.dimmedColor = fadeColor(value, -50);
        // this.invertedColor = isLightColor(value, 120) ? '#0078FF' : invertColor(value);FFB100
        // this.invertedColor = isDarkColor(value, MCOLORRAMP) ? invertColor(value) : null;
        this.ticks = ''; // trigger re-rendering of ticks
        this.saveSettings(true);
    }

    get locations() {
        return this.settings.locations;
    }

    set locations(value) {
        this.settings.locations = value;
        this.#cache.svg = '';
        this.saveSettings(true);
    }

    get mode() {
        return this.settings.mode;
    }

    set mode(value) {
        this.settings.mode = minmax(value, 0, this.locations.length - 1);
        this.saveSettings();
    }

    get longDateAndTime() {
        return this.settings.longDateAndTime === true;
    }

    set longDateAndTime(value) {
        this.settings.longDateAndTime = value === true;
        this.saveSettings();
    }

    get hour12() {
        return this.settings.hour12;
    }

    set hour12(value) {
        this.settings.hour12 = value === true;
        this.saveSettings();
    }

    get showTicks() {
        return this.settings.showTicks;
    }

    set showTicks(value) {
        this.settings.showTicks = value === true;
        this.ticks = '';
        this.saveSettings(true);
    }

    get timeOptions() {
        if(this.longDateAndTime) {
            return {hour: 'numeric', minute: '2-digit', second: '2-digit', hour12: this.hour12 === true};
        }
        return {hour: 'numeric', minute: '2-digit', hour12: this.hour12 === true};
    }

    get dateOptions() {
        if(this.longDateAndTime) {
            return {weekday: 'long', year: 'numeric', month: 'numeric', day: 'numeric'};
        }
        return {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'};
    }

    set customNames(value) {
        this.settings.customNames = value;
        this.#cache.svg = '';
        this.saveSettings(true);
    }

    get customNames() {
        return this.settings.customNames || {};
    }

    willDisappear() {
        if(this.interval) clearInterval(this.interval);
    }

    dialRotate(payload) {
        if(this.locations?.length === 0) return;
        const ticks = payload?.ticks || 1;
        console.log('dialRotate:', ticks);
        this.mode = cycle(this.mode + ticks, 0, this.locations.length - 1);
        this.update();
    }

    dialPress(payload) {
        if(payload.pressed === false) {
            this.toggleLongDateAndTime();
        }
    }

    touchTap(payload) {
        if(payload?.hold === false) {
            this.toggleLongDateAndTime();
        }
    }

    keyUp(payload) {
        this.dialRotate();
    }

    compareArray(arr, arr2) {
        return (
            Array.isArray(arr) && Array.isArray(arr2) && arr.length === arr2.length &&
            arr.every((value, index) => value === arr2[index])
        );
    };
    compareObject(obj, obj2) {
        return (
            typeof obj === 'object' && typeof obj2 === 'object' &&
            Object.keys(obj).length === Object.keys(obj2).length &&
            Object.keys(obj).every((key) => {
                return obj[key] === obj2[key];
            })
        );
    };
    compare(obj, obj2) {
        if(obj === undefined || typeof obj2 === undefined) {
            return false;
        }
        if(obj instanceof Date || obj2 instanceof Date) {
            return obj.getTime() === obj2.getTime();
        }
        if(Array.isArray(obj)) {
            return this.compareArray(obj, obj2);
        }
        if(typeof obj === 'object') {
            return this.compareObject(obj, obj2);
        }
        return obj === obj2;
    };

    didReceiveSettings(payload) {
        if(!payload?.settings) return;
        const settings = payload.settings;
        let dirty = false;
        this.saveLock = true;
        const internalProps = ['customNames', 'locations', 'hour12', 'longDateAndTime', 'color', 'showTicks'];
        internalProps.forEach(key => {
            if(settings.hasOwnProperty(key) && !this.compare(settings[key], this[key])) {
                console.log('didReceive settings CHANGED:', key, settings[key], this[key]);
                this[key] = settings[key];
                dirty = true;
            }
        });

        Object.keys(settings).forEach(key => {
            if(!internalProps.includes(key) && settings.hasOwnProperty(key) && !this.compare(settings[key], this[key])) {
                this.settings[key] = settings[key];
                dirty = true;
            }
        });
        // if(dirty) this.update();
        this.saveLock = false;
        this.saveSettings(dirty);
    }

    /**
     * Saves the current settings and optionally updates the UI.
     * @param { boolean } immediateUpdate
     */

    saveSettings(immediateUpdate = false) {
        // see if we temporarily disabled saving (just a performance optimization)
        if(this.saveLock !== true && this.context) {
            // console.log('saveSettings', this.context, this.saveLock, this.settings);
            $SD.setSettings(this.context, this.settings);
            if(immediateUpdate) this.update();
        }
    };

    toggleLongDateAndTime() {
        this.longDateAndTime = !this.longDateAndTime;
        this.update();
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

    onlyRedrawWhenTimeChanges(o) {
        // only redraw if the calculated time-string has changed
        return this.getFromCache('time', o.time, false);
    }

    onlyRedrawWhenSVGChanges(svg) {
        // only redraw if the svg has changed (eg. when the time changes, or hands are rotated by a fraction of a degree)
        return this.getFromCache('svg', svg, false);
    }

    update() {
        const o = this.updateClockSettings();
        const svg = this.makeSvg(o);
        if(this.onlyRedrawWhenSVGChanges(svg) || this.onlyRedrawWhenTimeChanges(o)) {
            const svgWithoutWhitespace = svg.replace(/\>\s+\</g, '><'); // just remove all whitespace to save some bytes
            // const optimizedSVG = SVGUtils.optimizeSVGString(svgWithoutWhitespace);
            // const icon = `data:image/svg+xml;base64,${btoa(svgWithoutWhitespace)}`;
            const icon = `data:image/svg+xml,${svgWithoutWhitespace};`;
            if(this.isEncoder) {
                const size = this.longDateAndTime && this.hour12 === true ? 16 : (this.longDateAndTime || this.hour12) ? 22 : 24;
                const payload = {
                    'title': o.date,
                    'value': {
                        value: o.time,
                        font: {size},
                    },
                    'value2': o.city,
                    icon
                };
                // if(o.seconds % 10 === 0) console.log('payload:', JSON.stringify(payload).length, 'svg:', svg.length, 'svgWithoutWhitespace:', svgWithoutWhitespace?.length);
                $SD.setFeedback(this.context, payload);
            }
            $SD.setTitle(this.context, o.city);
            $SD.setImage(this.context, icon);
        }
    }

    updateClockSettings() {
        const timeZone = this.locations[this.mode] || '';
        const timeZoneChanged = this.getFromCache('timeZone', timeZone, false);
        return this.updateClockSettingsForTimeZone(timeZone, timeZoneChanged);
    }

    /**
    * Creates various date/time related values for the given timezone.
    * @param {string} timeZone e.g. 'Europe/Berlin'
    * @param {boolean} timeZoneChanged  // if timeZone changed, also update daylight savings and city
    * @returns {any}  // returns the value, if returnValue is true, otherwise a boolean
    */

    updateClockSettingsForTimeZone(timeZone = '', timeZoneChanged = false) {
        // this is a quick way to get the current time in the selected timezone
        // but it's not the best way to do it
        // the returend timezone values is not correct, but since we're interested
        // only in the current date/time, it's ok
        const dateForTimeZone = (date, timeZone, locale = 'en-US') => new Date(date.toLocaleString('en-US', {timeZone}));
        const isDaylightSaving = (d) => {
            const firstDayOfYear = new Date(d.getFullYear(), 0, 1).getTimezoneOffset();
            const dayOutSideDST = new Date(d.getFullYear(), 6, 1).getTimezoneOffset();
            const timeZoneOffset = d.getTimezoneOffset();
            const maxOffset = Math.max(firstDayOfYear, dayOutSideDST);
            const dayLightSaving = Math.max(firstDayOfYear, dayOutSideDST) !== d.getTimezoneOffset();
            // console.log({firstDayOfYear, dayOutSideDST, timeZoneOffset, maxOffset, dayLightSaving})
            return dayLightSaving;
        };

        const date = timeZone.length ? new Date(new Date().toLocaleString('en-US', {timeZone})) : new Date();
        const hours = date.getHours();
        const minutes = date.getMinutes();
        const seconds = date.getSeconds();
        // let city = timeZone.length ? timeZone.split("/").pop().replace("_", " ") : '';
        let city = this.updateCity(timeZone);
        if(timeZoneChanged && isDaylightSaving(date)) {
            console.log('isDaylightSaving', date);
            city = `${city} (DST)`;
        }

        const getTimePartsAsJSON = (date) => {
            return Object.fromEntries(new Intl.DateTimeFormat(this.language, this.timeOptions).formatToParts(date).map(e => [e.type, e.value || '']));
        };

        const c = getTimePartsAsJSON(date);

        const result = {
            minDeg: Math.round((minutes + seconds / 60) * 6), // rounding helps to reduce the number of redraws 
            secDeg: seconds * 6,
            hourDeg: ((hours % 12) + minutes / 60) * 360 / 12,
            // time: date.toLocaleTimeString([], this.timeOptions),
            time: `${c.hour}:${c.minute}${c.second ? ':' + c.second : ''}${c.dayPeriod ? ' ' + c.dayPeriod : ''}`,
            date: date.toLocaleDateString([], this.dateOptions),
            weekday: date.toLocaleDateString([], {weekday: 'long'}),
            city,
            hours,
            minutes,
            seconds
        };
        return result;
    }

    updateCity(timezone) {
        // remove empty custom names
        const customNames = Object.fromEntries(Object.entries(this.customNames || {}).filter(([_, v]) => v != ''));
        let city = '';
        if(!timezone) {
            city = '';
        } else {
            if(customNames?.hasOwnProperty(timezone)) {
                city = customNames[timezone];
            } else {
                if(customNames && typeof customNames === 'object' && this.customNames !== customNames) this.settings.customNames = customNames;
                city = timezone.length ? timezone.split("/").pop().replace("_", " ") : '';
            }
        }
        return city;
    }

    makeSvg(o) {
        let scale = this.isEncoder ? 1 : 3;
        const w = this.size * scale;
        const r = w / 2;
        const sizes = {
            hours: round(w / 4.5),
            minutes: round(w / 9),
            seconds: round(w / 36)
        };
        const strokes = {
            hours: round(w / 30),
            minutes: round(w / 36),
            seconds: round(w / 48),
            center: round(w / 24)
        };

        if(this.showTicks) {
            const lineStart = round(w / 20);
            const lineLength = round(w / 8);
            // create ticks only once
            if(!this.ticks.length) {
                const line = `x1="${r}" y1="${lineStart}" x2="${r}" y2="${lineStart + lineLength}"`;
                const ticks = () => {
                    let str = `<g id="ticks" stroke-width="${sizes.seconds}" stroke="${this.dimmedColor}">`;
                    for(let i = 0;i < 12;i++) {
                        str += `<line ${line} transform="rotate(${i * 30}, ${r}, ${r})"></line>`;
                    }
                    str += '</g>';
                    return str;
                };
                this.ticks = ticks();
            }
        }
        let amPmSymbol = '';
        if(this.hour12 === true) {
            const amPmColor = o.hours > 12 ? '#0078FF' : '#FFB100';
            const amPm = o.hours > 12 ? 'PM' : 'AM';
            amPmSymbol = this.isEncoder ? '' : `<text font-family="${this.fontFamily}" text-anchor="middle" x="${r}" y="${r - 5 * scale}" font-size="${8 * scale}" font-weight="800" fill="${amPmColor}">${amPm}</text>`;
        }
        // if you prefer not to use a function to create ticks, see below at makeSvgAlt
        return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${w}" viewBox="0 0 ${w} ${w}">
        ${this.ticks}
        ${amPmSymbol}
        <g stroke="${this.dimmedColor}">
            <line id="hours" x1="${r}" y1="${sizes.hours}" x2="${r}" y2="${r}" stroke-width="${strokes.hours}" transform="rotate(${o.hourDeg}, ${r}, ${r})"></line>
            <line id="minutes" x1="${r}" y1="${sizes.minutes}" x2="${r}" y2="${r}" stroke-width="${strokes.minutes}" transform="rotate(${o.minDeg}, ${r}, ${r})"></line>
            ${this.longDateAndTime ? `<line id="seconds" x1="${r}" y1="${sizes.seconds}" x2="${r}" y2="${r}" stroke-width="${strokes.seconds}" transform="rotate(${o.secDeg}, ${r}, ${r})"></line>` : ''}
        </g>
        <circle cx="${r}" cy="${r}" r="${strokes.center}" fill="${this.color}" />        
    </svg>`;
    };
};


/* SVG */
const SVGUtils = {};
SVGUtils.optimizeSVGString = (svg) => {
    const tmp = svg.replace(/\>\s+\</g, '><');
    const svgEl = SVGUtils.stringToSVG(tmp);
    svgEl.querySelectorAll('*').forEach((e) => {
        e.removeAttribute('id');
    });
    return SVGUtils.svgToString(svgEl);
};

SVGUtils.svgToString = (svg) => {
    if(!svg) return null;
    return svg.outerHTML;
};

SVGUtils.parseSVG = (svg) => {
    const s = new XMLSerializer();
    return s.serializeToString(svg).replaceAll(' xmlns="http://www.w3.org/1999/xhtml"', '');
};

SVGUtils.stringToSVG = (svgString) => {
    // console.log("stringToSVG", typeof svgString, svgString);
    const needsContainer = (s) => {
        if(typeof svgString != "string") {
            if(svgString.startsWith('<?xml') || svgString.startsWith('<svg')) return false;
            return true;
        }
        return false;
    };

    if(!svgString) return null;
    // if(typeof svgString === "string") {
    // svgString = needsContainer(svgString) ?  `<svg>${svgString}</svg>` : svgString; // fix svg fragments
    // }
    // console.log("stringToSVG2", typeof svgString, svgString);
    const doc = new DOMParser().parseFromString(
        svgString,
        "image/svg+xml"
    );
    const svg = doc.querySelector('svg') || {};
    // console.log({doc, svg: svg.firstElementChild.outerHTML});
    return svg;
};
