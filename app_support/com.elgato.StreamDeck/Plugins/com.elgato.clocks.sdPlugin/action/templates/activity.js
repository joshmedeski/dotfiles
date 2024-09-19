STREAMDECK.template('activity', {
    id: 'activity',
    version: '0.1.0',
    controllers: ['Encoder'],
    category: 'Activity',
    interval: 1000,
    layout: () => `${date.showWeekday === true && `<text fill="${date.color}"  font-size="${date.fontSize}" x="4" y="11">{{$weekday}}</text>`}
    <circle fill="none" r="${$activities[0].radius}" cx="${this.width / 2}" cy="${this.height / 2}" stroke="#ff0000" stroke-width="${mode == 0 ? lineWidth + .5 : lineWidth}" stroke-linecap="${$lineCap}" stroke-dashoffset="${$activities[0].$strokeDashoffset}" stroke-dasharray="${$activities[0].$strokeDasharray}"/>
    <circle fill="none" r="${$activities[1].radius}" cx="${this.width / 2}" cy="${this.height / 2}" stroke="#00ff00" stroke-width="${mode == 1 ? lineWidth + .5 : lineWidth}" stroke-linecap="${$lineCap}" stroke-dashoffset="${$activities[1].$strokeDashoffset}" stroke-dasharray="${$activities[1].$strokeDasharray}"/>
    <circle fill="none" r="${$activities[2].radius}" cx="${this.width / 2}" cy="${this.height / 2}" stroke="#0000ff" stroke-width="${mode == 2 ? lineWidth + .5 : lineWidth}" stroke-linecap="${$lineCap}" stroke-dashoffset="${$activities[2].$strokeDashoffset}"  stroke-dasharray="${$activities[2].$strokeDasharray}"/>
    ${seconds.$hideLayer !== true && `<text fill="${time.color}" text-anchor="middle" font-size="${date.fontSize}" x="${this.width / 2}" y="${this.height / 2 + date.fontSize / 3}">${this.data.$subtitle} </text>`}
    ${date.$hideLayer !== true && `<text fill="${date.color}" font-size="${date.fontSize}"  x="4" y="${this.height - date.fontSize / 2}">${$settings[mode].name}</text>`}
    `,
    data: {
        title: 'Activity',
        $subtitle: '',
        fontSize: 7,
        $lineCap: 'round',  // notes: line-cap: butt, round, square
        $activities: [],
        $settings: [{
            name: 'red',
        }, {
            name: 'yellow',
        }, {
            name: 'blue',
        }],
        mode: 0,
        lineWidth: 8,
        showText: true,
        time: {
            color: '#FFFFFF',
            $hideLayer: true,
        },
        seconds: {
            $hideLayer: true,
        },
        date: {
            color: '#FFFFFF',
            long: false,
            fontSize: 9,
            showWeekday: false,
            $hideLayer: true,
        },
        $weekday: '',
        $dateOptions: {
            long: {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'},
            short: {weekday: 'short', year: '2-digit', month: 'short', day: 'numeric'},
            veryshort: {month: '2-digit', year: '2-digit', day: '2-digit'}
        }
    },
    on: {
        initialized: function() {
            this.data.lineWidth = this.width < 100 ? 8 : 4;
            this.priv_setValue(); // initialize the dialaction object
        },
        rotated: function(jsn) {
            this.priv_setValue(0, jsn?.payload?.ticks || 1);
        },
        clicked: function() {
            if(this.dialStack) {
                this.dialStack?.next();
            } else {
                this.data.mode = (this.data.mode + 1) % this.data.$activities.length;
            }
            // console.log('was clicked', this.data.title, this.data.mode, this.data.$activities.length);
        },
        changed: function(prop, eventName) {
            if(this.context == '7a87da544d9ce672dc7359405eb7aa7a') {
                console.log("ACTIVITY::Changed: ", prop, eventName);
            }
        },
        willUpdate: function() {
            const data = this.data;
            const offs = 0;
            const offs2 = data.$lineCap == 'butt' ? 0 : data.lineWidth / 2;
            const date = new Date();
            data.$settings[0].name = date.toLocaleDateString([], this.data.$dateOptions.veryshort);
            data.$settings[1].name = date.toLocaleDateString([], this.data.$dateOptions.short);
            data.$settings[2].name = date.toLocaleDateString([], this.data.$dateOptions.long);
            data.$weekday = date.toLocaleDateString([], {weekday: 'long'});
            const minutes = date.getMinutes();
            const seconds = date.getSeconds();
            const hours = date.getHours();
            const modes = [100 / 60 * seconds + offs, 100 / 60 * (minutes + seconds / 60) + offs, 100 / 12 * ((hours % 12) + minutes / 60)]; //.map(e => Math.ceil(e));
            modes.forEach((e, i) => {
                data.$activities[i] = this.calcDashArray(e, data.$activities[i].radius, i, offs2);
            });
            data.$subtitle = date.toLocaleTimeString();
        }
    },
    methods: {
        calcDashArray(inValue, radius, activitiesIndex, offs = 0) {
            let value = Math.abs(parseInt(inValue));
            if(!isNaN(value)) {
                if(value > 100) value %= 100;
                const circumference = 2 * Math.PI * radius + offs;
                let d = parseInt(value * circumference / 100);
                return {
                    radius,
                    value,
                    $strokeDasharray: `${d}  ${circumference - d}`,
                    $strokeDashoffset: circumference / 4  // start at top
                };
            }
            return this.data.$activities[activitiesIndex];
        },

        priv_setValue(inValue, inTicks) {  // install this helper function to the dialaction object
            const useAutoUpdate = true;
            if(inTicks) {
                if(useAutoUpdate) {
                    this.set('$activities', this.data.mode, this.calcDashArray(this.data.$activities[this.data.mode].value + inTicks, this.data.$activities[this.data.mode].radius, this.data.mode));
                } else {
                    this.data.$activities[this.data.mode] = this.calcDashArray(this.data.$activities[this.data.mode].value + inTicks, this.data.$activities[this.data.mode].radius, this.data.mode);
                    this.update(true);
                }
            } else {
                const lineWidth = this.data.lineWidth;
                const r = this.height / 2 - lineWidth;
                this.data.$activities = [r, r - lineWidth, r - lineWidth * 2].map((r, i) => this.calcDashArray(inValue || Math.round(Math.random() * 100), r, i));
            }
        }
    }
});

