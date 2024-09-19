STREAMDECK.template('segments', {
    id: 'segments',
    version: '0.1.0',
    controllers: ['Encoder'],
    category: 'Segments',
    interval: 1000,
    version: '0.1.0',
    layout: () => `
    ${$activities[mode](this)}
    ${(false && date.$hideLayer !== true || date.$showWeekday === true) && `${$backRect(this,true)}`}
    ${date.$hideLayer !== true && `<text fill="${date.color}" text-anchor="end" x="${this.width-4}" y="${this.height - fontSize / 3}">${$dateString}</text>`}
    ${date.showWeekday === true && `<text  fill="${date.color}" text-anchor="start" font-size="${date.fontSize}" x="4" y="${this.height - fontSize / 3}">${date.showWeekday === true ? $weekday : ''}</text>`}
    ${showModeLabel === true && `<circle fill="#330000"  cx="${this.width - 10}" cy="${this.height - 10}" r="10" /><text fill="#ffffff" text-anchor="middle" font-size="${date.fontSize}" x="${this.width - 10}" y="${this.height - 10 + date.fontSize / 3}">${mode}</text>`}
    `,
    data: {
        title: 'Segments',
        fontSize: 7,
        $activities: [
            (me) => me.$drawSevenSegmentString(true, 0),
            (me) => me.$drawSevenSegmentString(true, 1),
            (me) => me.$drawSevenSegmentString(true, 2),
            (me) => me.$drawSevenSegmentString(true, 3),
            (me) => me.$drawSegmentChar1422x36B(true)
        ],
        mode: 0,
        showModeLabel: false,
        backlitOpacity: 0.15,
        time: {
            color: '#00AA00',
            stripColons: false,
            $hideLayer: true,
        },
        seconds: {
            $hideLayer: true,
        },
        date: {
            color: '#FFFFFF',
            long: false,
            fontSize: 8,
            showWeekday: false,
            $hideLayer: true,
        },
        colons: {
            flashColons: false
        },
        $weekday: new Date().toLocaleDateString([], {weekday: 'long'}),
        $dateString: new Date().toLocaleDateString([], {month: 'short', day: 'numeric', year: 'numeric'}),
        $backRect: (me, bottom = false) => `<rect rx="2" opacity="0.4" x="0" y="${bottom ? me.height - me.data.fontSize - 2 : 0}" width="${me.width}" height="${me.data.fontSize + 4}" fill="black" stroke="black" stroke-width="1" />`
    },
    on: {
        initialized: function() {
            this.__hideLabel = this.utils.debounce((something) => {
                this.data.showModeLabel = false;
            }, 800);
            this.__saveSettings = this.utils.debounce((something) => {
                if(this.sd && this.options?.payload?.settings) {
                    this.utils.setProp(this.options.payload.settings, 'mode', this.data.mode);
                    if(this.data.time?.stripColons !== undefined) {
                        this.utils.setProp(this.options.payload.settings, 'time.stripColons', this.data.time.stripColons);
                    }
                    // console.log('SEGMENTS::__saveSettings', this.context, this.sd, this.utils, this.options.payload.settings);
                    this.sd.setSettings(this.context, this.options.payload.settings);
                }
            }, 1000);
        },
        rotated: function(jsn) {
            this.$changeMode(this.data.mode + (jsn?.payload?.ticks || 1));
        },
        clicked: function(jsn) {
            if(jsn.payload?.long === true) {
                this.data.time.stripColons = !this.data.time.stripColons;
                return;
            }
            if(!this.isEncoder) {
                this.$changeMode(this.data.mode + 1);
            }
            this.data.date.showWeekday = !this.data.date.showWeekday;
            this.data.date.$hideLayer = !this.data.date.showWeekday;
        },
        changed: function(prop, eventName) {
            // do something on property change
        }
    },
    methods: {
        $changeMode(newMode) {
            const m = this.utils.cycle(newMode, this.data.$activities.length - 1);
            if(m !== this.data.mode) {
                this.data.mode = m;
                this.__saveSettings && this.__saveSettings();
            }
            this.$showLabel();
        },
        $showLabel() {
            this.data.showModeLabel = true;
            this.__hideLabel(this.data.showModeLabel);
        },
        $drawSegmentChar1422x36B(onlyContent = false) {
            const segments14 = this.$tables.segments14;
            if(!segments14) return;
            let scale, timeString, topOffset, date = new Date();

            if(this.data.seconds.$hideLayer) {
                scale = this.isEncoder ? 0.8 : 0.54;
                timeString = date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
                topOffset = this.isEncoder ? 14 : 48;
            } else {
                scale = this.isEncoder ? 0.5 : 0.34;
                timeString = date.toLocaleTimeString();
                topOffset = this.isEncoder ? 36 : 88;
            }

            timeString = (!this.data.colons?.flashColons || date.getSeconds() % 2 == 0) ? timeString : timeString.replaceAll(':', ' ');
            this.data.$weekday = date.toLocaleDateString([], {weekday: 'long'});
            this.data.$dateString = date.toLocaleDateString();

            if(this.data.time.stripColons) {
                timeString = timeString.replace(/:/g, '');
                if(this.isEncoder) {
                    scale += 0.15;
                    topOffset -= this.data.seconds.$hideLayer ? 6 : 15;
                } else {
                    scale += 0.13;
                    topOffset -= this.data.seconds.$hideLayer ? 18 : 32;
                }
            }

            if(this.data.time.stripColons === true && this.data.date.$hideLayer !== true || this.data.date.$showWeekday === true) topOffset -= 2;

            let charWidth = 25;
            const fillColor = this.data.time?.color ?? '#00AA00';
            const backlitOpacity = this.data.backlitOpacity || '0.15';
            const digitId = 'digit1422x36B';
            const polygons = {
                "A1": "3 0 2 1 5 4 10.5 4 10.5 1 9.5 0",
                "A2": "19 0 20 1 17 4 11.5 4 11.5 1 12.5 0",
                "B": "21 16.5 22 15 22 3 21 2 18 5 18 15",
                "C": "21 19.5 22 21 22 33 21 34 18 31 18 21",
                "D1": "3 36 2 35 5 32 10.5 32 10.5 35 9.5 36",
                "D2": "19 36 20 35 17 32 11.5 32 11.5 35 12.5 36",
                "E": "1 19.5 0 21 0 33 1 34 4 31 4 21",
                "F": "1 16.5 0 15 0 3 1 2 4 5 4 15",
                "G1": "1 18 5 16 10 16 10 20 5 20",
                "G2": "21 18 17 20 12 20 12 16 17 16",
                "H": "5 5 6.5 5 8 8 10 15 8.5 15 5 10",
                "I": "12.5 5 12.5 8 11 15 9.5 8 9.5 5",
                "J": "17 5 15.5 5 14 8 12 15 13.5 15 17 10",
                "K": "5 31 6.5 31 8 28 10 21 8.5 21 5 26",
                "L": "12.5 31 12.5 28 11 21 9.5 28 9.5 31",
                "M": "17 31 15.5 31 14 28 12 21 13.5 21 17 26",
            };
            const polys = Object.keys(polygons).reduce((accumulator, value, index) => ({...accumulator, [value]: `<polygon points="${polygons[value]}"/>`}), {});
            polys["DP"] = '<circle cx="21.25" cy="35.25" r="1"/>';
            const polyKeys = Object.keys(polys);
            const createdDefs = Object.values(polys).join('');

            const createSVGChar = (char, charNum = 0, ignoreFirstBit = 1) => {
                const useSegmentsArr = segments14[char];
                const arr = polyKeys.map((key) => useSegmentsArr.includes(key) ? polys[key] : false).filter(e => e !== false);
                return `<g transform="translate(${charNum * charWidth})"><use y="0" href="#${digitId}" /><g stroke="none" stroke-width="1" fill-rule="evenodd">${arr.join('')}</g></g>`;
            };

            const createSVGArray = (inString = '') => [...inString].map((e, i) => createSVGChar(e, i, 1));
            const svgArr = createSVGArray(timeString);
            return `<g transform="scale(${scale}) translate(0 ${topOffset})"  fill="${fillColor}" ><defs><g id="${digitId}" opacity="${backlitOpacity}">${createdDefs}</g></defs>${svgArr.join('')}</g>`;
        },

        $drawSevenSegmentString(onlyContent = false) {
            let charWidth = 28;
            const digitId = `digit-seven`;
            const segmentId = `segment-seven`;
            const segments7 = this.$tables.segments7;
            const fillColor = this.data.time?.color ?? '#00AA00';
            const backlitOpacity = this.data.backlitOpacity || '0.15';
            let scale, timeString, topOffset, date = new Date();
            if(this.data.seconds.$hideLayer) {
                scale = this.isEncoder ? 0.7 : 0.5;
                timeString = date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
                topOffset = this.isEncoder ? 14 : 48;
            } else {
                scale = this.isEncoder ? 0.45 : 0.31;
                timeString = date.toLocaleTimeString();
                topOffset = this.isEncoder ? 33 : 92;
            }

            if(this.data.time.stripColons) {
                timeString = timeString.replace(/:/g, '');
                if(this.isEncoder) {
                    scale += 0.15;
                    topOffset -= this.data.seconds.$hideLayer ? 6 : 15;
                } else {
                    scale += 0.12;
                    topOffset -= this.data.seconds.$hideLayer ? 18 : 30;
                }
            }

            const segmentsArr = [
                `<use class="1" y="0" href="#${segmentId}" />`,
                `<use class="2" transform="rotate(90 12 12)" href="#${segmentId}" />`,
                `<use class="3" transform="rotate(90 2 22)" href="#${segmentId}" />`,
                `<use class="4" y="40" href="#${segmentId}" />`,
                `<use class="5" transform="rotate(90 -8 12)" href="#${segmentId}" />`,
                `<use class="6" transform="rotate(90 2 2)" href="#${segmentId}" />`,
                `<use class="7" y="20" href="#${segmentId}" />`,
            ];

            const bg = this.isEncoder ? '' : `<rect x="0" y="0" width="${this.width}" height="${this.height}"></rect>`;
            const createSVGChar = (char, charNum = 0, ignoreFirstBit = 1) => {
                const mtrx = Array.isArray(char) ? char : [...segments7[char]];
                const arr = mtrx.map((e, i) => e == '1' ? i : -1).filter(e => e > -1).map(idx => segmentsArr[idx - ignoreFirstBit]);
                return `<g transform="translate(${charNum * charWidth})"><use y="0" href="#${digitId}" /><g stroke="none" stroke-width="1">${arr.join('')}</g></g>`;
                // return `<g transform="translate(${charNum * charWidth})"><use y="0" href="#${digitId}" /><g stroke="none" stroke-width="1" fill="${fillColor}" fill-rule="evenodd">${arr.join('')}</g></g>`;
            };

            const createSVGArray = (inString = '') => [...inString].map((e, i) => createSVGChar(e, i, 1));
            const svgArr = createSVGArray(timeString);
            let oneSegment;
            const compileSegment = (offs, r, s, y) => {
                return `<circle cx="${s * 2 + offs}" cy="${y}" r="${r}"></circle><circle cx="${s * 4 + 0}" cy="${y}" r="${r}"></circle><circle cx="${s * 6 - offs}" cy="${y}" r="${r}"></circle>`;
            };
            switch(this.data.mode) {
                case 0:
                    oneSegment = `<rect x="5" y="0" width="14" height="4"></rect>`;
                    break;
                case 1:
                    oneSegment = `<rect rx="2" x="3" y="0" width="18" height="4"></rect>`;
                    break;
                case 2:
                    oneSegment = compileSegment(1, 2.25, 3, 2);
                    break;
                case 3:
                    oneSegment = compileSegment(0, 2.25, 3, 1.5);
                    break;
                default:
                    oneSegment = `<rect  fill="red" x="5" y="0" width="14" height="4"></rect>`;
            }
            const createdDefs = `<defs>
                <g id="${segmentId}">${oneSegment}</g>
                <g id="${digitId}" stroke="none" stroke-width="1" opacity="${backlitOpacity}" fill-rule="evenodd">
                
                ${segmentsArr.join('')}</g>
            </defs>`;
            return `<g transform="scale(${scale}) translate(0 ${topOffset})" fill="${fillColor}" fill-rule="evenodd">${createdDefs}${svgArr.join('')}</g>`;
        },

    },
    $tables: {
        segments14: {
            "0": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "J", "K"],
            "1": ["B", "C"],
            "2": ["A1", "A2", "B", "D1", "D2", "E", "G1", "G2"],
            "3": ["A1", "A2", "B", "C", "D1", "D2", "G1", "G2"],
            "4": ["B", "C", "F", "G1", "G2"],
            "5": ["A1", "A2", "C", "D1", "D2", "F", "G1", "G2"],
            "6": ["A1", "A2", "C", "D1", "D2", "E", "F", "G1", "G2"],
            "7": ["A1", "A2", "B", "C"],
            "8": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2"],
            "9": ["A1", "A2", "B", "C", "D1", "D2", "F", "G1", "G2"],
            "◰": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "I"],
            "◱": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "L"],
            "◲": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G2", "L"],
            "◳": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G2", "I"],
            "◫": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "I", "L"],
            "◨": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G2", "I", "J", "L", "M"],
            "◧": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "H", "I", "K", "L"],
            "◩": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "H", "I", "J", "K"],
            "◪": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G2", "J", "K", "L", "M"],
            "⬒": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2", "K", "L", "M"],
            "⬓": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2", "H", "I", "J"],
            "◿": ["B", "C", "D1", "D2", "J", "K"],
            "▪": ["D1", "D2", "E", "F", "H", "M"],
            "◸": ["A1", "A2", "E", "F", "J", "K"],
            "◹": ["A1", "A2", "B", "C", "H", "M"],
            "▶": ["E", "F", "G1", "H", "K"],
            "◀": ["B", "C", "G2", "J", "M"],
            "↕": ["H", "I", "J", "K", "L", "M"],
            "‼": ["B", "C", "I", "L", "DP"],
            "¶": ["A1", "A2", "B", "C", "F", "G1", "G2", "I", "L"],
            "§": ["A1", "A2", "C", "D1", "D2", "F", "G1", "G2", "H", "M"],
            "▬": ["C", "D1", "D2", "E", "G1", "G2", "K", "L", "M"],
            "↨": ["D1", "D2", "H", "I", "J", "K", "L", "M"],
            "↑": ["K", "L", "M"],
            "↓": ["H", "I", "J"],
            "→": ["G1", "H", "K"],
            "←": ["G2", "J", "M"],
            "∟": ["D1", "D2", "E"],
            "↔": ["G1", "G2", "H", "J", "K", "M"],
            "▲": ["D1", "D2", "K", "L", "M"],
            "▼": ["A1", "A2", "H", "I", "J"],
            " ": [],
            "!": ["B", "C", "DP"],
            "\"": ["B", "F"],
            "#": ["D1", "D2", "E", "F", "G1", "G2", "I", "L"],
            "$": ["A1", "A2", "C", "D1", "D2", "F", "G1", "G2", "I", "L"],
            "%": ["A1", "C", "D2", "F", "G1", "G2", "I", "J", "K", "L"],
            "&": ["A1", "D1", "D2", "E", "F", "G1", "H", "J", "M"],
            "'": ["B"],
            "(": ["J", "M"],
            ")": ["H", "K"],
            "*": ["G1", "G2", "H", "I", "J", "K", "L", "M"],
            "+": ["G1", "G2", "I", "L"],
            ",": ["D1"],
            "-": ["G1", "G2"],
            ".": ["DP"],
            "/": ["J", "K"],
            ":": ["G1", "D1"],
            ";": ["A1", "K"],
            "<": ["J", "M"],
            "=": ["D1", "D2", "G1", "G2"],
            ">": ["H", "K"],
            "?": ["A2", "B", "G2", "L", "DP"],
            "@": ["A1", "A2", "B", "C", "D1", "D2", "E", "G1", "L"],
            "A": ["A1", "A2", "B", "C", "E", "F", "G1", "G2"],
            "B": ["A1", "A2", "B", "C", "D1", "D2", "G2", "I", "L"],
            "C": ["A1", "A2", "D1", "D2", "E", "F"],
            "D": ["A1", "A2", "B", "C", "D1", "D2", "I", "L"],
            "E": ["A1", "A2", "D1", "D2", "E", "F", "G1"],
            "F": ["A1", "A2", "E", "F", "G1"],
            "G": ["A1", "A2", "C", "D1", "D2", "E", "F", "G2"],
            "H": ["B", "C", "E", "F", "G1", "G2"],
            "I": ["A1", "A2", "D1", "D2", "I", "L"],
            "J": ["B", "C", "D1", "D2", "E"],
            "K": ["E", "F", "G1", "J", "M"],
            "L": ["D1", "D2", "E", "F"],
            "M": ["B", "C", "E", "F", "H", "J"],
            "N": ["B", "C", "E", "F", "H", "M"],
            "O": ["A1", "A2", "B", "C", "D1", "D2", "E", "F"],
            "P": ["A1", "A2", "B", "E", "F", "G1", "G2"],
            "Q": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "M"],
            "R": ["A1", "A2", "B", "E", "F", "G1", "G2", "M"],
            "S": ["A1", "A2", "C", "D1", "D2", "F", "G1", "G2"],
            "T": ["A1", "A2", "I", "L"],
            "U": ["B", "C", "D1", "D2", "E", "F"],
            "V": ["E", "F", "J", "K"],
            "W": ["B", "C", "E", "F", "K", "M"],
            "X": ["H", "J", "K", "M"],
            "Y": ["H", "J", "L"],
            "Z": ["A1", "A2", "D1", "D2", "J", "K"],
            "[": ["A2", "D2", "I", "L"],
            "\\": ["H", "M"],
            "]": ["A1", "D1", "I", "L"],
            "^": ["K", "M"],
            "_": ["D1", "D2"],
            "`": ["H"],
            "a": ["D1", "D2", "E", "G1", "L"],
            "b": ["C", "D1", "D2", "E", "F", "G1", "G2"],
            "c": ["D1", "D2", "E", "G1", "G2"],
            "d": ["B", "C", "D1", "D2", "E", "G1", "G2"],
            "e": ["D1", "D2", "E", "G1", "K"],
            "f": ["A2", "G1", "G2", "I", "L"],
            "g": ["D2", "E", "G1", "K", "M"],
            "h": ["C", "E", "F", "G1", "G2"],
            "i": ["A1", "D1", "D2", "G1", "L"],
            "j": ["A2", "C", "D1", "D2", "G2"],
            "k": ["E", "F", "G1", "G2", "M"],
            "l": ["A1", "D2", "I", "L"],
            "m": ["C", "E", "G1", "G2", "L"],
            "n": ["C", "E", "G1", "G2"],
            "o": ["C", "D1", "D2", "E", "G1", "G2"],
            "p": ["C", "D1", "G2", "L", "M"],
            "q": ["C", "D1", "D2", "E", "G1", "G2", "M"],
            "r": ["E", "G1", "G2"],
            "s": ["D1", "D2", "G2", "M"],
            "t": ["D2", "G1", "G2", "I", "L"],
            "u": ["C", "D1", "D2", "E"],
            "v": ["E", "K"],
            "w": ["C", "E", "K", "M"],
            "x": ["G1", "G2", "K", "M"],
            "y": ["C", "D1", "D2", "M"],
            "z": ["D1", "G1", "K"],
            "{": ["A2", "D2", "G1", "I", "L"],
            "|": ["I", "L"],
            "}": ["A1", "D1", "G2", "I", "L"],
            "~": ["F", "H", "J"],
            "⌂": ["D1", "D2", "K", "M"],
            "̈": ["C", "E"],
            "æ": ["A2", "B", "D1", "E", "G1", "G2", "H", "I", "L", "M"],
            "⧖": ["A1", "A2", "D1", "D2", "H", "I", "J", "K", "M"],
            "⧗": ["A1", "A2", "D1", "D2", "H", "J", "K", "L", "M"],
            "€": ["A1", "D1", "E", "F", "G1", "J", "M"],
            "“": ["C", "L"],
            "”": ["F", "I"],
            "´": ["J"],
            "Æ": ["A1", "A2", "D2", "E", "F", "G1", "G2", "I", "L"],
            "⌐": ["A1", "A2", "F"],
            "¬": ["A1", "A2", "B"],
            "¢": ["A1", "A2", "D1", "D2", "E", "F", "I", "L"],
            "£": ["A2", "D1", "D2", "G1", "G2", "I", "L"],
            "¥": ["G1", "G2", "H", "J", "L"],
            "₧": ["A1", "D2", "E", "F", "G1", "G2", "I", "L", "M"],
            "ƒ": ["A2", "D1", "G1", "G2", "I", "L"],
            "▖": ["D1", "E", "G1", "K", "L"],
            "▗": ["C", "D2", "G2", "L", "M"],
            "▘": ["A1", "F", "G1", "H", "I"],
            "▙": ["A1", "C", "D1", "D2", "E", "F", "G1", "G2", "H", "I", "K", "L", "M"],
            "▚": ["A1", "C", "D2", "F", "G1", "G2", "H", "I", "L", "M"],
            "▛": ["A1", "A2", "B", "D1", "E", "F", "G1", "G2", "H", "I", "J", "K", "L"],
            "▜": ["A1", "A2", "B", "C", "D2", "F", "G1", "G2", "H", "I", "J", "L", "M"],
            "▝": ["A2", "B", "G2", "I", "J"],
            "▞": ["A2", "B", "D1", "E", "G1", "I", "G2", "J", "K", "L"],
            "▟": ["A2", "B", "C", "D1", "D2", "E", "G1", "G2", "I", "J", "K", "L", "M"],
            "▤": ["A1", "A2", "D1", "D2", "G1", "G2"],
            "▵": ["B", "C", "E", "F", "I", "L"],
            "▦": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2", "I", "L"],
            "▧": ["A2", "B", "D1", "E", "H", "M"],
            "▨": ["A1", "C", "D2", "F", "J", "K"],
            "▩": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "H", "J", "K", "M"],
            "░": ["A2", "D1", "H", "J", "K", "M"],
            "▒": ["A1", "A2", "D1", "D2", "G1", "G2", "H", "J", "K", "M"],
            "▓": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2", "H", "J", "K", "M"],
            "│": ["I", "L"],
            "┤": ["G1", "I", "L"],
            "╡": ["A1", "G1", "I", "L"],
            "╢": ["B", "C", "E", "F", "G1"],
            "╖": ["C", "G1", "G2", "E"],
            "╕": ["A1", "G1", "I", "L"],
            "╣": ["B", "C", "E"],
            "║": ["B", "C", "E", "F"],
            "╗": ["A1", "A2", "B", "C", "E"],
            "╝": ["B", "G1", "G2"],
            "╜": ["B", "G1", "F", "G2"],
            "╛": ["A1", "G1", "I"],
            "┐": ["G1", "L"],
            "└": ["G2", "I"],
            "┴": ["G1", "G2", "I"],
            "┬": ["G1", "G2", "L"],
            "├": ["G2", "I", "L"],
            "─": ["G1", "G2"],
            "┼": ["G1", "G2", "I", "L"],
            "╞": ["A2", "G2", "I", "L"],
            "╟": ["B", "C", "E", "F", "G2"],
            "╚": ["F", "G1", "G2"],
            "╔": ["A1", "A2", "C", "E", "F"],
            "╩": ["G1", "G2"],
            "╦": ["A1", "A2", "C", "E"],
            "╠": ["C", "E", "F"],
            "═": ["A1", "A2", "G1", "G2"],
            "╬": ["C", "E"],
            "╧": ["A1", "A2", "G1", "G2", "I"],
            "╨": ["B", "F", "G1", "G2"],
            "╤": ["A1", "A2", "G1", "G2", "L"],
            "╥": ["C", "E", "G1", "G2"],
            "╙": ["B", "F", "G1", "G2"],
            "╘": ["A2", "G2", "I"],
            "╒": ["A2", "G2", "I", "L"],
            "╓": ["C", "E", "G1", "G2"],
            "╫": ["B", "C", "E", "F", "G1", "G2"],
            "╪": ["A1", "A2", "G1", "G2", "I", "L"],
            "┘": ["G1", "I"],
            "┌": ["G2", "L"],
            "█": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2", "H", "I", "J", "K", "L", "M"],
            "▄": ["C", "D1", "D2", "E", "G1", "G2", "K", "L", "M"],
            "▌": ["A1", "D1", "E", "F", "G1", "H", "I", "K", "L"],
            "▐": ["A2", "B", "C", "D2", "G2", "I", "J", "L", "M"],
            "▀": ["A1", "A2", "B", "F", "G1", "G2", "H", "I", "J"],
            "α": ["A1", "D1", "E", "F", "I", "J", "L", "M"],
            "ß": ["A2", "B", "C", "D2", "G2", "I", "K"],
            "Γ": ["A1", "A2", "E", "F"],
            "π": ["G1", "G2", "K", "M"],
            "Σ": ["A1", "A2", "D1", "D2", "H", "K"],
            "σ": ["D1", "E", "G1", "G2", "L"],
            "µ": ["B", "E", "F", "G1", "G2"],
            "τ": ["A1", "A2", "I", "M"],
            "Φ": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "I", "L"],
            "Θ": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2"],
            "Ω": ["A1", "A2", "G1", "G2", "H", "J"],
            "δ": ["A1", "A2", "C", "D1", "D2", "E", "G1", "G2", "H"],
            "∞": ["B", "C", "E", "F", "H", "J", "K", "M"],
            "φ": ["A2", "B", "F", "G1", "G2", "I", "L"],
            "ε": ["A1", "D1", "E", "F", "G1"],
            "Π": ["A1", "A2", "B", "C", "E", "F"],
            "≡": ["A1", "A2", "D1", "D2", "G1", "G2"],
            "±": ["D1", "D2", "G1", "G2", "I", "L"],
            "≥": ["D1", "D2", "H", "K"],
            "≤": ["D1", "D2", "J", "M"],
            "⌠": ["A1", "E", "F", "I"],
            "⌡": ["B", "C", "D2", "L"],
            "÷": ["A2", "D2", "G1", "G2"],
            "≈": ["C", "F", "H", "J", "K", "M"],
            "°": ["A2", "B", "G2", "I"],
            "√": ["A2", "B", "I"],
            "ⁿ": ["A2", "G2", "J"],
            "²": ["E", "G2", "K"],
            "▣": ["A1", "A2", "B", "C", "D1", "D2", "E", "F", "G1", "G2", "H", "I", "J", "K", "L", "M", "DP"],
            "�": ["A1", "A2", "D1", "D2", "E", "F", "G1", "G2"]
        },
        segments7: {
            '0': '01111110',
            '1': '00110000',
            '2': '01101101',
            '3': '01111001',
            '4': '00110011',
            '5': '01011011',
            '6': '01011111',
            '7': '01110000',
            '8': '01111111',
            '9': '01111011',
            'a': '01110111',
            'b': '00011111',
            'c': '01001110',
            'd': '00111101',
            'e': '01101111',
            'f': '01000111',
            'g': '01011110',
            'h': '00010111',
            'i': '00000100',
            'j': '00111100',
            'k': '01010111',
            'l': '00001110',
            'm': '00010101',
            'n': '00010110',
            'o': '00011101',
            'p': '01100111',
            'q': '01110011',
            'r': '00000110',
            's': '01011011',
            't': '00001111',
            'u': '00011110',
            'v': '00011110',
            'w': '00011110',
            'x': '00011110',
            'y': '00011110',
            'z': '00011110',
            'A': '01110111',
            'B': '00011111',
            'C': '01001110',
            'D': '00111101',
            'E': '01001111',
            'F': '01000111',
            'G': '01011110',
            'H': '00010111',
            'I': '00000100',
            'J': '00111100',
            'K': '01010111',
            'L': '00001110',
            'M': '00010101',
            'N': '00010110',
            'O': '00011101',
            'P': '01100111',
            'Q': '01110011',
            'R': '00000110',
            'S': '01011011',
            'T': '00001111',
            'U': '00011110',
            'V': '00011110',
            'W': '00011110',
            'X': '00011110',
            'Y': '00011110',
            'Z': '00011110',
            '-': '00000001',
            '_': '00001000',
            ' ': '00000000',
            '.': '10000000',
            ':': '10000000',
            ',': '10000000',
            ';': '10000000',
        },
    },
});


