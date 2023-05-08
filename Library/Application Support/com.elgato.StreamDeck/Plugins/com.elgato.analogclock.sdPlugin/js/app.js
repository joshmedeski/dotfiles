/* global $SD */
$SD.on('connected', conn => connected(conn));

function connected(jsn) {
    debugLog('Connected Plugin:', jsn);

    /** subscribe to the willAppear event */
    $SD.on('com.elgato.analogclock.action.willAppear', jsonObj =>
        action.onWillAppear(jsonObj)
    );
    $SD.on('com.elgato.analogclock.action.didReceiveSettings', jsonObj =>
        action.onDidReceiveSettings(jsonObj)
    );
    $SD.on('com.elgato.analogclock.action.willDisappear', jsonObj =>
        action.onWillDisappear(jsonObj)
    );
    $SD.on('com.elgato.analogclock.action.keyUp', jsonObj =>
        action.onKeyUp(jsonObj)
    );
}

var action = {
    type: 'com.elgato.analogclock.action',
    cache: {},

    onDidReceiveSettings: function(jsn) {
        console.log("onDidReceiveSettings", jsn);
        const settings = jsn.payload.settings;
        const clock = this.cache[jsn.context];
        if(!settings || !clock) return;

        if(settings.hasOwnProperty('clock_index')) { /* if there's no clock-definitions, so simply do nothing */
            /* set the appropriate clockface index as choosen from the popupmenu in PI */
            const clockIdx = Number(settings.clock_index);
            if(clock) {
                clock.setClockFaceNum(clockIdx);
                this.cache[jsn.context] = clock;
            }
        }
        if(settings.hasOwnProperty('clock_type')) { /* if there's no clock-definitions, so simply do nothing */
            if(clock) {
                clock.setClockType(settings.clock_type);
            }
        }

    },

    onWillAppear: function(jsn) {

        if(!jsn.payload || !jsn.payload.hasOwnProperty('settings')) return;

        console.log('onWillAppear', jsn.payload.settings);

        const clock = new AnalogClock(jsn);
        // cache the current clock
        this.cache[jsn.context] = clock;
        this.onDidReceiveSettings(jsn);

    },

    onWillDisappear: function(jsn) {
        let found = this.cache[jsn.context];
        if(found) {
            // remove the clock from the cache
            found.destroyClock();
            delete this.cache[jsn.context];
        }
    },

    onKeyUp: function(jsn) {
        const clock = this.cache[jsn.context];
        /** Edge case +++ */
        if(!clock) this.onWillAppear(jsn);
        else clock.toggleClock();
    }

};

function AnalogClock(jsonObj) {
    var jsn = jsonObj,
        context = jsonObj.context,
        clockTimer = 0,
        clock = null,
        clockface = clockfaces[0],
        currentClockFaceIdx = 0,
        origContext = jsonObj.context,
        canvas = null,
        demo = false,
        count = Math.floor(Math.random() * Math.floor(10)),
        type = 'analog';


    function isDemo() {
        return demo;
    }

    function createClock(settings) {
        canvas = document.createElement('canvas');
        canvas.width = 144;
        canvas.height = 144;
        clock = new Clock(canvas);
        clock.setColors(clockface.colors);
        clock.type = type;
        toggleClock();
    }

    function toggleClock() {

        if(clockTimer === 0) {
            clockTimer = setInterval(function(sx) {

                if(demo) {
                    let c = -1;
                    if(count % 21 == 6) {
                        c = 0;
                    } else if(count % 21 === 3) {
                        c = 1;
                    } else if(count % 21 === 9) {
                        c = 2;
                    } else if(count % 21 === 12) {
                        c = 3;
                    } else if(count % 21 === 15) {
                        c = 4;
                    } else if(count % 21 === 18) {
                        c = 5;
                    }

                    if(c !== -1) {
                        setClockFaceNum(c, demo);
                    } else {
                        drawClock();
                    }
                } else {
                    drawClock();
                }

                count++;
            }, 1000);
        } else {
            window.clearInterval(clockTimer);
            clockTimer = 0;
        }
    }

    function drawClock(jsn) {
        clock.drawClock();
        clockface.text === true && $SD.api.setTitle(context, new Date().toLocaleTimeString(), null);
        $SD.api.setImage(
            context,
            clock.getImageData()
        );
    }

    function setClockFace(newClockFace, isDemo) {
        clockface = newClockFace;
        demo = clockface.demo || isDemo;
        clock.setColors(clockface.colors);
        clockface.text !== true && $SD.api.setTitle(context, '', null);
        drawClock();
    }

    function setClockFaceNum(idx, isDemo) {
        currentClockFaceIdx = idx < clockfaces.length ? idx : 0;
        this.currentClockFaceIdx = currentClockFaceIdx;
        setClockFace(clockfaces[currentClockFaceIdx], isDemo);
    }

    function setClockType(type) {
        clock.type = type;
        this.drawClock();
    }

    function getClockType() {
        clock.type;
    }

    function destroyClock() {
        if(clockTimer !== 0) {
            window.clearInterval(clockTimer);
            clockTimer = 0;
        }
    }

    createClock();

    return {
        clock: clock,
        clockTimer: clockTimer,
        clockface: clockface,
        currentClockFaceIdx: currentClockFaceIdx,
        name: name,
        drawClock: drawClock,
        toggleClock: toggleClock,
        origContext: origContext,
        setClockFace: setClockFace,
        setClockFaceNum: setClockFaceNum,
        destroyClock: destroyClock,
        demo: demo,
        isDemo: isDemo,
        setClockType: setClockType,
        getClockType: getClockType
    };
}
