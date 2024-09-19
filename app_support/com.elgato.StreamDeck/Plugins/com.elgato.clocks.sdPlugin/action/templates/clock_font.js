STREAMDECK.template('clock_with_font', {
    id: 'clock_with_font',
    version: '0.1.0',
    category: 'clocks',
    controllers: ['Keypad', 'Encoder'],
    interval: 1000,
    __audioContext: null,
    __countdown: null,
    // layout: () => `${this.isDefaultClock() ? mode == 1 ? this.$textMode() : `
    layout: () => `${this.isDefaultClock() ? `
    <g transform="translate(${position.offsetLeft || 0} ${position.offsetTop || 0}) scale(${position.scale || 1.00})">
        <text font-size="${defaultClockSize(this.data)}" text-anchor="middle" x="${this.width / 2}" y="${this.height / 2 + defaultClockSize(this.data)/ 3}">${this.$updateTimeString()}</text>
    </g>
        `
        :
        `<g transform="translate(${position.offsetLeft || 0} ${position.offsetTop || 0}) scale(${position.scale || 1.00})">
        <g transform="scale(${this.getAProperty('scale')}) translate(${this.getAProperty('leftOffset')} ${$topOffset})">
            ${hours.$hideLayer === true ? '' : `
            <g fill="${hours.color}" transform="translate(${$translatex[1]})">${$digits[0]}</g>
            <g fill="${hours.color}" transform="translate(${$translatex[2]})">${$digits[1]}</g>
            `}

            ${colons.$hideLayer !== true ? `
            ${!colons.flashColons || $tempSeconds % 2 == 0 ? `<g fill="${colons.color}" transform="translate(${$translatex[3]})">${$digits[10]}</g>` : ''}
            ` : ''}

            ${minutes.$hideLayer === true ? '' : `
            <g fill="${minutes.color}" transform="translate(${$translatex[4]})">${$digits[2]}</g>
            <g fill="${minutes.color}" transform="translate(${$translatex[5]})">${$digits[3]}</g>
            `}

            ${seconds.$hideLayer === true ? '' : `
            ${colons.$hideLayer !== true && (!colons.flashColons || $tempSeconds % 2 == 0) ? `<g fill="${colons.color}" transform="translate(${$translatex[6]})">${$digits[10]}</g>` : ''}
            <g fill="${seconds.color}" transform="translate(${$translatex[7]})">${$digits[4]}</g>
            <g fill="${seconds.color}" transform="translate(${$translatex[8]}, 0)">${$digits[5]} </g>`}
        </g></g>
    `}
    ${date.$hideLayer === true ? '' : `<text fill="${date.color}" font-size="${date.fontSize}" text-anchor="end" x="${this.width - (this.isEncoder ? 2 : 4)}" y="${this.height - fontSize / 3}">${$dateString}</text>`}
    ${date.showWeekday !== true ? '' : `<text fill="${date.color}" text-anchor="start" font-size="${date.fontSize}" x="${this.isEncoder ? 1 : 3}" y="${this.height - fontSize / 3}">${$weekday}</text>`}
    ${grid.$hideLayer === true ? '' : `<g fill="${grid.color || '#000A00'}" transform="scale (0.5)" stroke-width="0" stroke="none" >${$grid}</g>`}
    ${$city.length < 1 ? '' : `<text fill="${date.color}" font-size="${date.fontSize}" text-anchor="${time.hour12 == true ? 'start' : 'middle'}" x="${time.hour12 == true ? 4 : this.width / 2}" y="${date.fontSize}">${$city}</text>`}
    ${this.data.time.hour12 !== true ? '' : `<text fill="${date.color}" text-anchor="middle" font-size="${date.fontSize}" x="${this.width - 12}" y="${date.fontSize}">${$ampm}</text>`}
    ${this.$hasCountdown() !== true ? '' : `<rect fill="#000" width="${this.width}" height="${date.fontSize + 1}"></rect><text fill="${date.color}" text-anchor="middle" font-size="${date.fontSize}" x="${this.width / 2}" y="${date.fontSize}">${$countdown}</text>`}
    `,
    data: {
        time: {
            // fontName: '',
            fontSize: 20,
            hour12: false,
        },
        date: {
            color: '#FFFFFF',
            long: false,
            fontSize: 8,
            showWeekday: false,
            $hideLayer: true,
        },
        hours: {
            color: '#FFFFFF',
            $hideLayer: false,
        },
        minutes: {
            color: '#FFFFFF',
            $hideLayer: false,
        },
        seconds: {
            color: '#FFFFFF',
            $hideLayer: true,
        },
        colons: {
            color: '#FFFFFF',
            flashColons: false,
            $hideLayer: false,
        },
        grid: {
            color: '#000000',
            $hideLayer: true,
        },
        dial: {
            useCountdown: false,
        },
        position: {
            offsetTop: 0,
            offsetLeft: 0,
            scale: 1.00,
        },
        leftOffset: 0,
        topOffset: 0,
        $hour12Offset: 8,
        defaultClockSize: (o) => (o.seconds.$hideLayer !== true || o.time.hour12 == true ? o.time.fontSize - o.$hour12Offset : o.time.fontSize) - (o.seconds.$hideLayer !== true && o.time.hour12 == true ? 2 : 0),
        /* private properties */
        // Note: data properties starting with a '$' (dollar sign) are considered private and will not be shown in the UI
        $leftOffset: 0,
        $topOffset: 0,
        $tempSeconds: 0,
        $translatex: [0, 4, 27, 49, 70, 93, 114, 136, 159],
        $timeOptions: {hour: 'numeric', minute: '2-digit'},
        $dateOptions: {
            long: {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'},
            short: {weekday: 'short', year: '2-digit', month: 'short', day: 'numeric'},
            veryshort: {month: '2-digit', year: '2-digit', day: '2-digit'}
        },
        $scale: 1,
        $digits: {},
        $dateString: '',
        $grid: '',
        scale: {}, // font-definitions on file may load their own scale (e.g. ingriddarling)
        // settings: {
        //     countdown: null // placeholder to hold countdown instance (if any)

        // },
        $countdown: '',  // placeholder for countdown string (if there is one)
        $weekday: '',
        $supportedFeatures: [],
        mode: 0,
        $city: '',
        $timezone: '',
        $ampm: '',
        $message: '',
        dial: null
    },
    on: {
        initialized: function(jsn) {
            // console.log("--- CLOCK_FONT_INITIALIZED ---", this.context, this.data.fontName, this.data.mode, this.data.locations && Object.values(this.data.locations));
            this.data.$hour12Offset = $SD.appInfo.application.platform === 'mac' ? 6 : 8;
            this.data.$supportedFeatures = this.data.clock_style?.id === 'default' ? ['countdown'] : [];
            this.data.$timezone = this.getTimeZone();
            this.updateCity();
            this.presetdigits = Array.from(Array(10)).reduce((accumulator, value, index) => ({...accumulator, [index]: ''}), {});
            const field = this.data.seconds.$hideLayer === true ? 'default' : 'withSeconds';
            ['leftOffset', 'scale', 'topOffset', 'translatex'].forEach((p) => {
                const internalProperty = `$${p}`;
                const newVal = this.getPropertyForController(this.data, p, this.controller, this.data[internalProperty], field);
                if(newVal != this.data[internalProperty]) {
                    this.data[internalProperty] = newVal;
                }
            });

        },
        // will update event is sent right before the template gets updated
        // this is a good place to update the data object
        willUpdate: function(data) {
            if(this.isDefaultClock()) return;
            // console.log("--- CLOCK_FONT_INITIALIZED ---", this.data.fontName, this.data.topOffset, this.data.$topOffset);
            const d = this.newDate(true);
            this.$updateDateString(d);

            let hours = d.getHours();
            const minutes = d.getMinutes();
            const seconds = d.getSeconds();
            if(this.data.colons?.flashColons) this.data.$tempSeconds = seconds;
            this.data.$ampm = hours >= 12 ? 'pm' : 'am';
            hours = this.data.time.hour12 ? (hours > 12 ? hours - 12 : hours) : hours;

            this.data.$digits = {
                0: this.data.time.hour12 && hours < 10 ? '' : this.$getDigit(hours, 0),
                1: this.$getDigit(hours, 1),
                2: this.$getDigit(minutes, 0),
                3: this.$getDigit(minutes, 1),
                4: this.$getDigit(seconds, 0),
                5: this.$getDigit(seconds, 1),
                10: this.presetdigits[10]
            };

            const getProps = (num, idx, arr) => {
                if(idx === 1) {
                    return num < 10 ? arr[num.toString()[0]] : arr[num.toString()[1]];
                } else {
                    return num < 10 ? arr[0] : arr[num.toString()[0]];
                }
            };
            if(this.$digitProperties) {
                let offs = 0;
                const translatex = [0, 0];
                const separatorWidth = this.$digitProperties[10].width;
                [hours, minutes, seconds].forEach((num, idx) => {
                    [0, 1].forEach((num2, idx2) => {
                        offs += getProps(num, num2, this.$digitProperties).width;
                        translatex.push(offs);
                    });
                    offs += separatorWidth;
                    translatex.push(offs);
                });
                this.data.$translatex = translatex;
            }
        },
        changed: function(prop, value) {
            if(this.isDefaultClock())  return;
            if(!prop.startsWith('$')) {
                const src = prop.includes('.') ? prop.split('.')[0] : prop;
                // changing seconds require a redraw of the clock (to hide/show the seconds)
                if(prop === 'seconds' || src==='seconds') {
                    this.$applySettings('seconds');
                }
                const field = this.data.seconds.$hideLayer === true ? 'default' : 'withSeconds';
                ['leftOffset', 'scale', 'topOffset', 'translatex'].forEach((p) => {
                    const internalProperty = `$${p}`;
                    const newVal = this.getPropertyForController(this.data, p, this.controller, this.data[internalProperty], field);
                    if(newVal !== this.data[internalProperty]) {
                        this.$dbg('changed::', p, internalProperty, this.controller, 'new:', newVal, 'old:', this.data[internalProperty]);
                        this.data[internalProperty] = newVal;
                    }
                });

                if(prop.startsWith('grid.')) {
                    this.data.$grid = this.$drawGrid(this.data.grid);
                }
            }
            // before using the settings of a clock-style, we are looking, if the clock's svg has some extra instructions/properties
            // and update the font here (this is no longer used, but kept for backward compatibility)
            if(typeof prop === 'string' && this.data.__extras?.hasOwnProperty(prop)) {
                this.$updateExtras(prop);
            }
        },
        clicked: function() {
            this.$dbg('clicked', this.id, {...this.data});
            console.log('++++clicked', this.context, this.id, `city:${this.data.$city}`, this.data.$timezone, {...this.data});
            if(this.$hasCountdown()) {
                this.$reset();
            } else {
                if(!this.$changeMode(this.data.mode + 1, true)) { //see, if we can change the mode
                    const newValue = !this.data.date.$hideLayer;
                    this.data.backgroundColor = this.defaults.backgroundColor;
                    this.data.date.$hideLayer = newValue;
                    this.data.date.showWeekday = !newValue;
                }

            }
        },
        // counterpart of 'keyDown', emitted when a dial is pressed
        pressed: function() {
            this.$dbg('pressed', this.name, {...this.data});
            const bgc = this.data.backgroundColor;
            console.log(this.context, bgc);
            this.data.backgroundColor = '#111133';
            setTimeout(() => {
                this.data.backgroundColor = bgc;
            }, 1000);
        },
        longDown: function(jsn) {
            this.$dbg('longDown', this.id, jsn);
            // this.data.mode = 1-this.data.mode;
        },
        longPressed: function(jsn) {
            this.$dbg('longPressed', this.id, jsn);
            // this.data.mode = 1-this.data.mode;
        },
        touchTap: function(jsn) {
            this.$dbg('touchTap', this.id, jsn);
            this.$changeMode(this.data.mode + 1);
        },
        rotated: function(jsn) {
            // console.log('------- rotated', this.data.dial?.useCountdown, {...this.data}, jsn.payload?.settings?.locations, this.data.locations, this.locations);
            if(this.data.$supportedFeatures.includes('countdown') && this.data.dial?.useCountdown === true) {
                if(!this.__audioContext) this.__audioContext = Utils.createAudioContext(50, 880);
                const countDownDefaultDelay = 5; // seconds=== 10000 ms
                const countDownDefaultTime = countDownDefaultDelay * 1000; // 10 seconds
                let countDownTime = this.$hasCountdown() ? this.__countdown : new Date();
                const ticks = jsn.payload.ticks || 0;
                const date = new Date();
                const newTime = Math.round(Math.abs(date - countDownTime.getTime()) / countDownDefaultTime) * (countDownDefaultTime + countDownDefaultTime / 100);  // round to next countDownDefaultDelay seconds
                const r = date.getTime() + newTime + ticks * countDownDefaultTime; // countDownDefaultDelay seconds
                countDownTime.setTime(r);
                this.__countdown = countDownTime;
                this.$updateCountDown();
            } else {
                this.$changeMode(this.data.mode + (jsn?.payload?.ticks || 1));
            }
            this.updateLayout(true); // immediately update - since we don't update a property directly and thus don't trigger an update
        }
    },
    methods: {
        $getSettings() {
            if(!this.data) return {};
            const tmpSettings = {};
            if(this.data.$timezone) tmpSettings.$timezone = this.data.$timezone;
            if(this.data.mode) tmpSettings.mode = Number(this.data.mode);
            if(this.data.dial?.useCountdown) tmpSettings.dial = {useCountdown: this.data.dial.useCountdown};
            return tmpSettings;
        },
        $changeMode(newMode, suppressMessage = false) {
            const useCountdown = this.data.dial?.useCountdown === true;
            if(useCountdown === true) return console.log("can't change mode when countdown is active");
            const loc = this.getLocations();
            if(!Array.isArray(loc)) return;
            const m = this.utils.cycle(newMode, loc?.length - 1);
            if(!Array.isArray(loc) || loc.length === 0) {
                if(suppressMessage === true) return false;
                if(!this.data.$message.length) this.showMessage('Add locations in the PI \n to use this feature');
                return false;
            };
            if(m !== this.data.mode) {
                this.data.mode = m;
                this.emit('saveSettings', this.$getSettings());
            }
            this.updateLayout(true);
            return true;
        },
        $hasCountdown() {
            return this.data.$supportedFeatures.includes('countdown') && this.__countdown !== null && this.__countdown instanceof Date;
        },
        getAProperty(property) {
            const field = this.data.seconds.$hideLayer === true ? 'default' : 'withSeconds';
            return this.data[property]?.[this.controller]?.[field] ?? this.data[property]?.[field] ?? this.data['$' + property];
        },
        getPropertyForController(options, property, controller, defaultValue, field = 'default') {
            return options[property]?.[controller]?.[field] ?? options[property]?.[field] ?? defaultValue;
        },
        $applySettings(prop = 'seconds', autoLock = false) {
            const getPropertyForController = this.getPropertyForController;
            const options = this.options?.settings;  // this.options.settings
            // console.log('%c[clock_font]::$applySettings:', 'color:#0099ff', prop, options, autoLock, this.controller, options?.scale?.[this.controller], this.data[prop].$hideLayer, options?.scale?.[this.controller]?.withSeconds, options?.scale?.withSeconds);
            if(typeof options == 'object') {
                if(autoLock) this.updateLock = true;
                if(options.hasOwnProperty('colons')) {
                    this.data.colons.color = options.colons.color;
                }
                if(this.data[prop].$hideLayer === true) {
                    this.data.$scale = getPropertyForController(options, 'scale', this.controller, 0.7);
                    this.data.$leftOffset = getPropertyForController(options, 'leftOffset', this.controller, 12);
                    this.data.$topOffset = getPropertyForController(options, 'topOffset', this.controller, 15);
                } else {
                    this.data.$scale = getPropertyForController(options, 'scale', this.controller, 0.5, 'withSeconds');
                    this.data.$leftOffset = getPropertyForController(options, 'leftOffset', this.controller, 4, 'withSeconds');
                    this.data.$topOffset = getPropertyForController(options, 'topOffset', this.controller, 25, 'withSeconds');
                }
                if(autoLock) this.updateLock = false;
            } else {
                console.warn("applySettings::no settings found");
            }
            return options;
        },
        $updateExtras(prop) {
            this.$dbg("updateExtras", prop, this.data.__extras);
            const extras = this.data.__extras;
            if(!extras) {
                console.error("updateExtras::no __extras found", extras);
                return;
            };
            if(!extras.hasOwnProperty(prop)) {
                console.error("updateExtras::no __extras for prop", prop);
                return;
            };
            if(!this.__presetdigits) {
                console.error("updateExtras::no preset digits");
            }
            let pd = this.__presetdigits;
            Object.entries(extras).forEach((extraEntries) => {
                const [extraKey, extraValue] = extraEntries;
                const {searchTerm, property} = extraValue;
                const value = this.data[extraKey];
                if(searchTerm && property && value) {
                    this.$dbg("updateExtras:replacing", searchTerm, 'with', `${property}="${value}"`);
                    pd = Object.values(pd).map((e, i) => {
                        return e.replaceAll(searchTerm, `${property}="${value}"`);
                    });
                }
            });
            this.presetdigits = pd;
        },
        isSupported(feature = 'countdown') {
            return this.data.$supportedFeatures.includes(feature);
        },
        isDefaultClock() {
            return (this.data.fontName && this.data.fontName !== '') ? false : true;
        },
        $reset() {
            if(this.data.backgroundColor !== this.defaults.backgroundColor) {
                this.__countdown = null;
                this.data.backgroundColor = this.defaults.backgroundColor;
            }
        },

        newDate: function() {
            const timeZone = this.getTimeZone(); //(this.locations && this.locations[this.data.mode]) || '';
            if(timeZone !== this.data.$timezone) {
                this.data.$timezone = timeZone;
                this.updateCity();
            }
            return timeZone.length ? new Date(new Date().toLocaleString('en-US', {timeZone})) : new Date();
        },

        $updateCountDown(inDate) {
            const date = inDate || new Date();
            if(this.$hasCountdown()) {
                // const diffTime = Math.abs(this.data.settings.countdown - date);
                const diffTime = (this.__countdown - date);
                if(diffTime >= 0) {
                    const date2 = new Date(diffTime);
                    date.setTime(date.getTime() + diffTime + 1);
                    const tme = `Timer:  ${Utils.padNum(date2.getUTCHours())} : ${Utils.padNum(date2.getUTCMinutes())} : ${Utils.padNum(date2.getSeconds())}`;
                    this.data.$countdown = (tme);
                } else {
                    this.updateLock = true;
                    this.__countdown = null;
                    setTimeout(() => {
                        this.data.backgroundColor = this.defaults.backgroundColor;
                    }, 3000);
                    if(this.__audioContext) {
                        Utils.playAudioContext(this.__audioContext);
                    }
                    setTimeout(() => {
                        this.data.backgroundColor = 'green';
                        this.updateLayout(true);
                        this.updateLock = false;
                    }, 2);
                }
            }
        },
        $drawGrid(settings = {}) {
            const gridArray = [];
            let gridSize = settings.gridSize ?? 5;
            let gridLineWidth = settings.lineWidth ?? 1;
            let gridTopOffset = settings.topOffset ?? 0;
            const w = this.width * 2;
            const h = this.height * 2;
            let i = -1;
            while(++i * gridSize + gridTopOffset < w) {
                gridArray.push(`<rect x="${i * gridSize + gridTopOffset}" y="0" width="${gridLineWidth}" height="${h}"></rect>`);
            }
            // console.log("calculated", this.context, i, "grid lines", w / (gridSize + gridTopOffset));
            i = -1;
            while(++i * gridSize + gridTopOffset < h) {
                gridArray.push(`<rect x="0" y="${i * gridSize + gridTopOffset}" width="${w}" height="${gridLineWidth}"></rect>`);
            }
            // this.data.$grid = gridArray.join('');
            return gridArray.join('');
        },
        $updateDateString(date) {
            const isCountdownSupported = this.isSupported('countdown');
            // if(!isCountdownSupported || (isCountdownSupported && (this.__countdown === null))) {
            const w = new Date().toLocaleDateString([], {weekday: this.isEncoder ? 'long' : 'short'});
            if(w && w !== this.data.$weekday) this.data.$weekday = w;
            // }
            const s = date.toLocaleDateString([], this.data.date.long == true ? this.data.$dateOptions.long : this.data.$dateOptions.veryshort);
            if(s !== this.data.$dateString) this.data.$dateString = s;
        },
        $getTimePartsAsJSON(date) {
            let timeOpts;
            if(this.data.seconds.$hideLayer !== true) {
                timeOpts = {hour: 'numeric', minute: '2-digit', second: '2-digit', hour12: this.data.time.hour12 === true};
            } else {
                timeOpts = {hour: 'numeric', minute: '2-digit', hour12: this.data.time.hour12 === true};
            }
            return Object.fromEntries(new Intl.DateTimeFormat(this.language, timeOpts).formatToParts(date).map(e => [e.type,e.value || '']));
        },
        $updateTimeString(useSettings = false) {
            const date = this.newDate();
            if(this.$hasCountdown()) {
                this.$updateCountDown();
            } else {
                this.$updateDateString(date);
            }
            const c = this.$getTimePartsAsJSON(date);
            const spacer = (!this.data.colons?.flashColons || date.getSeconds() % 2 == 0) ? ':' : ' ';
            return `${c.hour}${spacer}${c.minute}${c.second ? `${spacer}${c.second}` : ''}${c.dayPeriod ? ' ' + c.dayPeriod : ''}`;
            const s = date.toLocaleTimeString([], this.data.seconds.$hideLayer !== true ? {hour12: this.data.time.hour12 == true} : {...this.data.$timeOptions, hour12: this.data.time.hour12 == true});
            return (!this.data.colons?.flashColons || date.getSeconds() % 2 == 0) ? s : s.replaceAll(':', ' ');
        },
        $getDigit(num, idx) {
            if(idx === 1) {
                return num < 10 ? this.presetdigits[num.toString()[0]] : this.presetdigits[num.toString()[1]];
            } else {
                return num < 10 ? this.presetdigits[0] : this.presetdigits[num.toString()[0]];
            }
        },
        $updateFont: async function(inFontName, external) {

            if(!inFontName || !inFontName.length) {
                this.data.fontName = '';
                return Promise.resolve('');
            }

            const fontPath = external ? '' : MGLOBALDATA.fontPath;
            const fontBasePath = `${fontPath}${inFontName}/`;

            // console.log("updateFont", inFontName, fontPath, fontBasePath);

            const loadFont = (fontName) => {
                const font = `${fontPath}${fontName}`;
                return Utils.fetchXhr(font, 'text').then(e => {
                    return e && e.ok ? e.text() : Promise.reject(e);
                });
            };

            const loadFontInfoJson = async (fontName) => {
                // console.log("FONTCHECK", inFontName.split(".").pop());
                if(inFontName.split(".").pop() == 'svg') {
                    return Promise.resolve(false);
                };
                return Utils.fetchXhr(`${fontBasePath}_info.json`, 'json').then(e => {
                    return e && e.ok ? e.json() : {};
                }).catch(e => {
                    console.warn("error loading font info", inFontName, e);
                });
            };

            const checkIfFontIsFromFiles = async (fontName) => {
                const e = await Utils.fetchXhr(`${fontPath}${fontName}/0.svg`, 'text').catch(console.error);
                return e && e.ok;
            };

            this.isFilebased = false;
            let fontInfoJson = await loadFontInfoJson(inFontName);
            // console.log('fontInfoJson', fontInfoJson, inFontName, fontBasePath);
            // if _info.json is not found, try to fix it with default values
            // an error message is shown nevertheless
            if(fontInfoJson === undefined) {
                console.warn(inFontName, '_info.json not found, using default values');
                fontInfoJson = {
                    "scale": {
                        "default": 1,
                        "withSeconds": 0.7,
                        "Keypad": {
                            "default": 0.7,
                            "withSeconds": 0.5
                        }
                    }
                };
            }
            if(fontInfoJson) {
                this.isFilebased = true;
                this.options.settings = {...fontInfoJson, ...this.options.settings};
                const allP = [];
                for(let i = 0;i <= 10;i++) {
                    const font = `${fontBasePath}/${i}.svg`;
                    allP.push(Utils.fetchXhr(font, 'text').then(e => {
                        return e && e.ok ? e.text() : Promise.reject(e);
                    }));
                }
                return Promise.all(allP).then((all) => {
                    const presetdigits = [];
                    let offs = 0;
                    let $digitProperties = [];
                    let width, height;
                    all.forEach((svgString, i) => {
                        const doc = new DOMParser().parseFromString(
                            svgString,
                            "image/svg+xml"
                        );
                        const svg = doc.querySelector('svg') || {};
                        let g = svg.getElementById(i);
                        if(!g) {
                            g = svg.querySelector('svg > g');
                        }
                        // we need an id for the number
                        if(!g) return;
                        width = parseInt(svg.getAttribute('width'));
                        height = parseInt(svg.getAttribute('height'));
                        offs += width;
                        if(g.hasAttribute('fill')) {
                            g.removeAttribute('fill');
                        }
                        const number = g.querySelector('#number,#colon');
                        if(number) {
                            number.removeAttribute('fill');
                            number.removeAttribute('stroke');
                        }
                        g.setAttribute('width', width);
                        $digitProperties[i] = {width, height};
                        presetdigits[i] = g.outerHTML.replace('xmlns="http://www.w3.org/2000/svg" ', '');
                    });
                    this.updateLock = true;
                    this.data.fontName = inFontName;
                    this.$digitProperties = $digitProperties;
                    this.presetdigits = presetdigits;
                    if(!this.$applySettings(undefined, false)) {
                        const scale = this.data.seconds.$hideLayer === true ? 1 : 0.7;
                        this.data.$scale = scale;
                        this.data.topOffset = this.data.seconds.$hideLayer === true ? this.height / 2 - height / 2 : this.height / 2;
                        this.data.leftOffset = this.data.seconds.$hideLayer === true ? 6 : 0;
                    }
                    this.updateLock = false;
                });
            }

            const fontName = inFontName.includes('.') ? inFontName : `${inFontName}.svg`;
            return loadFont(fontName).then(svgString => {
                const doc = new DOMParser().parseFromString(
                    svgString,
                    "image/svg+xml"
                );
                const svg = doc.querySelector('svg') || {};
                if(svg) {
                    this.updateLock = true;
                    if(svg.hasAttribute('translatex')) {
                        this.data.$translatex = JSON.parse(svg.getAttribute('translatex'));
                    }
                    this.presetdigits = [];
                    this.svgElements = [];
                    this.svgElement = svg;
                    for(let i = 0;i <= 10;i++) {
                        const svgEl = svg.getElementById(i);
                        const s = svgEl.outerHTML.replace('xmlns="http://www.w3.org/2000/svg" ', '');
                        this.presetdigits[i] = s;
                        this.svgElements[i] = svgEl;
                    }
                    this.__presetdigits = [...this.presetdigits];
                    const extraAttrs = 'extras';
                    if(svg.hasAttribute(extraAttrs)) {
                        const extras = svg.getAttribute(extraAttrs).split(',');
                        if(extras) {
                            // console.log("-------------------- EXTRAS::", extras);
                            if(typeof extras === 'object' && Array.isArray(extras)) {
                                const extrasObj = {};
                                extras.forEach((e, i) => {
                                    const [ext, searchTerm] = e.split(':');
                                    const [property, value] = searchTerm.split('=');
                                    if(ext, searchTerm, property, value) {
                                        extrasObj[ext] = {property, value, searchTerm: `${property}="${value}"`};
                                    }
                                });
                                this.data.__extras = extrasObj;
                                Object.entries(extrasObj).forEach((e) => {
                                    const oldE = this.data[e[0]];
                                    if(!this.data.hasOwnProperty(e[0])) {
                                        this.data[e[0]] = e[1].value;
                                        // console.log("setting", e[0], "to", e[1].value, "old value", oldE);
                                    } else {
                                        // console.log("skipping", e[0], "old value", oldE);
                                        this.data[e[0]] = '';
                                        this.data[e[0]] = oldE;
                                    }
                                });
                            }
                        }
                    }
                    this.updateLock = false;
                    this.data.fontName = fontName;
                }
            }).catch(e => {
                console.error("Font not found:", fontName);
            });
        }
    }
});

