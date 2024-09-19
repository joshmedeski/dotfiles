STREAMDECK.template('Clock Flex', {
    id: 'clockflex',
    version: '0.1.0',
    category: 'clocks',
    controllers: ['Keypad', 'Encoder'],
    interval: 1000,
    layout: () => `${this.updateClockSettings()}<g  transform="translate(${this.isEncoder ? (this.width / 4) + position.offsetLeft ?? 0 : position.offsetLeft ?? 0} ${position.offsetTop ?? 0}) scale(${(!this.isEncoder ? .36 : .25) * position.scale ?? 1.00})">
        ${face.$hideLayer !== true ? `<g fill="${face.color || 'transparent'}">${this.getPropertyForPath(face, `<circle  cx="100" cy="100" r="${face.radius}"/>`)}</g>` : ''}
        ${$ticksArray}
        ${$amPmSymbol}
        ${hours.$hideLayer !== true ? `<g id="hours" stroke="${hours.color}" fill="${hours.color}" transform="rotate(${$hourDeg}, 100, 100)">${svgHand(hours)}</g>` : ''}
        ${minutes.$hideLayer !== true ? `<g id="minutes" stroke="${minutes.color}" fill="${minutes.color}" transform="rotate(${$minDeg}, 100, 100)">${svgHand(minutes)} </g>` : ''}
        ${seconds.$hideLayer !== true ? `<g id="seconds" stroke="${seconds.color}" stroke-width="${seconds.width || 'none'}" fill="${seconds.color}" transform="rotate(${$secsDeg}, 100, 100)">${svgHand(seconds)}</g>` : ''}
        </g>
  ${date.$hideLayer === true ? '' : `<text fill="${date.color}" font-size="${date.fontSize}" text-anchor="end" x="${this.width - 2}" y="${this.height - fontSize / 3}">${$dateString}</text>`}
  ${date.showWeekday !== true ? '' : `<text fill="${date.color}" text-anchor="start" font-size="${date.fontSize}" x="0" y="${this.height - fontSize / 3}">${$weekday}</text>`}
  ${$city.length < 1 ? '' : `<text fill="${date.color}" text-anchor="start" font-size="${date.fontSize}" x="6" y="${date.fontSize + 2}">${$city}</text>`}
  `,
    data: {
        date: {
            color: '#cccccc',
            fontSize: 9,
            long: false,
            showWeekday: false,
            $hideLayer: true,
        },
        time: {
            hour12: false,
        },
        face: {
            color: '#000',
            radius: 100,
            inset: 18,
            $hideLayer: false,
        },
        hours: {
            color: '#dddddd',
            width: 6,
            length: 90,
            $hideLayer: false,
        },
        minutes: {
            color: '#eeeeee',
            width: 4,
            length: 80,
            $hideLayer: false,
        },
        seconds: {
            color: '#ffffff',
            width: 2,
            length: 70,
            $hideLayer: false,
        },
        ticks: {
            color: '#ccc',
            width: 3,
            length: 12,
            $hideLayer: true,
        },
        fiveMinutes: {
            color: '#ccc',
            width: 2,
            length: 16,
            $hideLayer: false,
        },
        quarters: {
            color: '#ccc',
            width: 2,
            length: 18,
            $hideLayer: false,
        },
        // ring: {},
        settings: {
            // offsetTop: 0,
            // offsetLeft: 0,
        },
        position: {
            offsetTop: 0,
            offsetLeft: 0,
            scale: 1.00
        },
        $secs: 0,
        $secsDeg: 0,
        $minDeg: 0,
        $hourDeg: 0,
        $ticksArray: [],
        $weekday: '',
        svgHand: (o, defaultLength = 90, inset = 110, offset = 10) => o.hand ?? `<line stroke-linecap="round" stroke-width="${o.width || 'none'}" x1="100" y1="${inset - offset - (o.length || defaultLength)}" x2="100" y2="${inset}"></line>`,
        $dateString: '',
        $dateOptions: {
            long: {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'},
            short: {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'},
            narrow: {weekday: 'narrow', year: 'numeric', month: 'short', day: 'numeric'}
        },
        $timezone: '',
        $city: '',
        $amPmSymbol: '',
        mode: 0
    },
    on: {
        initialized: function(jsn) {
            this.createTicksArray();
            this.$dbg("--- CLOCK_FLEX_INITIALIZED ---", this.context, this.data.mode, this.data.locations && Object.values(this.data.locations));
            this.updateCity();
            const modeIdx = this.$getMode();
            if(modeIdx !== this.data.mode) {
                this.data.mode = modeIdx;
                console.log('mode changed', this.data.mode, this.context);
            }
            console.log('INITIALIZED', this.context, this.data.mode, this.data.$city, this.data.$timezone);
        },
        changed: function(prop, value) {
            const isPath = prop.includes('.');
            console.log('changed', prop, value, isPath);
            if(isPath) {
                // if(prop.startsWith('ticks')) {
                this.createTicksArray();
                // }
            }
        },
        clicked: function() {
            this.data.backgroundColor = this.data.backgroundColor == this.defaults.backgroundColor ? 'red' : this.defaults.backgroundColor;
        },
        pressed: function() {
            this.data.backgroundColor = Utils.getRandomColor();  //'#000066';
        },
        touchTap: function(jsn) {
            // this.$dbg('touchTap', this.id, jsn);
            console.log('touchTap', this.context, {...this.data});
            this.$changeMode(this.data.mode + 1);
        },
        rotated: function(jsn) {
            // console.log('------- rotated', {...this.data});
            this.$changeMode(this.data.mode + (jsn?.payload?.ticks || 1));
        }
    },
    methods: {
        $changeMode(newMode) {
            const loc = this.getLocations();
            if(!Array.isArray(loc)) return;
            const m = this.utils.cycle(newMode, loc?.length - 1);
            this.$dbg("new mode:", newMode, m, loc[m]);
            if(m !== this.data.mode) {
                this.data.mode = m;
                this.emit('saveSettings', {$timezone: this.data.$timezone, mode: this.data.mode});
            }
            this.updateLayout(true);
            // this.$showLabel();
        },
        getPropertyForPath: function(obj, defaultValue) {
            const field = this.isEncoder ? 'Encoder' : 'Keypad';
            return obj?.hasOwnProperty(field) ? obj[field] : defaultValue;
        },
        exportSettings: function(asString = false) {
            const privateData = {};
            Object.keys(this.options.data).filter(e => !e.startsWith('$') && !e.startsWith('__') && !this.options.data.hasOwnProperty(`__${e}`)).map(e => {
                privateData[e] = this.data[e];
            });
            return asString ? JSON.stringify(privateData) : privateData;
        },
        acceptAuxData: function(auxData) {
            const privateData = Object.keys(this.options.data).filter(e => !e.startsWith('$') && !e.startsWith('__') && !this.options.data.hasOwnProperty(`__${e}`));
            console.log('acceptAuxData', auxData, 'privateData', privateData);

            let success = false;
            privateData.forEach(d => {
                const h = auxData.hasOwnProperty(d);
                console.log('clock_flex: acceptAuxData', this.id, this.context, d, h, this.data[d], " => ", auxData[d]);
                if(h) {
                    this.data[d] = {...auxData[d]};
                    success = true;
                }
            });
            if(success) this.createTicksArray();
        },
        createTicksArray: function() {
            let props = {};
            const showElement = (e, i) => {
                if(i % 15 === 0 && !this.data.quarters.$hideLayer) {
                    props = this.data.quarters;
                    return !this.data.quarters.$hideLayer;
                }
                if(i % 5 === 0 && !this.data.fiveMinutes.$hideLayer) {
                    props = this.data.fiveMinutes;
                    return !this.data.fiveMinutes.$hideLayer;
                }
                props = this.data.ticks;
                return !this.data.ticks.$hideLayer;
            };
            const y2offs = Number(this.data.face.inset ?? 20);
            const tmpArray = [];
            new Array(60).fill(0).forEach((_, i) => {
                const show = showElement(_, i);
                if(show) {
                    tmpArray.push(`<line x1="100" y1="${y2offs}" x2="100" y2="${y2offs + props.length}" stroke="${props.color}" stroke-width="${props.width}" transform="rotate(${i * 6}, 100, 100)" />`);
                }
            });
            this.data.$ticksArray = tmpArray.length ? `<g stroke-linecap="butt">${tmpArray.join(" ")}</g>` : '';

        },
        updateClockSettings: function(inOffs = 0) {
            const timeZone = this.getTimeZone();
            const date = timeZone.length ? new Date(new Date().toLocaleString('en-US', {timeZone})) : new Date();
            this.data.$timezone = timeZone;
            this.updateCity();
            const hours = date.getHours();
            const minutes = date.getMinutes();
            const seconds = date.getSeconds();
            this.data.$secs = seconds;

            if(this.data.time.hour12 === true) {
                // default for key = height = 72
                // default for encoder = height = 50
                const [scale, hScale, vScale] = this.isEncoder ? [1, 2, 4] : [1, 3, 3];
                const fontSize = this.isEncoder ? vScale * 8 : vScale * 9;
                const timeColor = this.data.time?.color;
                // const amPmColor = hours > 12 ? '#0078FF' : '#FFB100';
                const amPmColor = hours > 12 ? timeColor || '#0078CC' : timeColor || '#CCB100';
                const amPm = hours > 12 ? 'PM' : 'AM';
                this.data.$amPmSymbol = `<text text-anchor="middle" x="${hScale * this.width / 2 - 2}" y="${vScale * this.height / 2 - fontSize / scale + 2}" font-size="${fontSize}" font-weight="800" fill="${amPmColor}">${amPm}</text>`;
            } else {
                this.data.$amPmSymbol = '';
            }
            const offs = inOffs ?? 0;
            this.data.$minDeg = (minutes + seconds / 60) * 6 + offs;
            this.data.$secsDeg = seconds * 6 + offs;
            this.data.$hourDeg = ((date.getHours() % 12) + minutes / 60) * 360 / 12 + offs;
            this.data.$dateString = this.data.date.long == true ? date.toLocaleDateString([], this.data.$dateOptions.long) : date.toLocaleDateString();
            const weekday = date.toLocaleDateString([], {weekday: 'long'});
            if(weekday && weekday !== this.data.$weekday) this.data.$weekday = weekday;
            return '';
        }
    }
});
