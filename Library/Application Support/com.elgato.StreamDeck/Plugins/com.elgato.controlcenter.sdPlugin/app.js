/* global $CC, Utils, ControlCenterSlider, LightsOnOff, $SD, initializeControlCenterClient */

const loadPreferences = () => {
    Utils.readFile('../../controlcenterPrefs.json').then(jsn => {
        console.log("CONFIG LOADED", jsn);
        for(const j in jsn) {
            CONFIG[j] = jsn[j];
        }
    });
}

loadPreferences();


$SD.on('connected', (conn) => connected(conn));

function connected(jsn) {

    /** subscribe to the willAppear event */
    $SD.on('com.elgato.controlcenter.battery.willAppear', (jsonObj) => battery.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.lights-on-off.willAppear', (jsonObj) => lightsOnOff.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.brightness-slider.willAppear', (jsonObj) => brightnessSlider.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.brightness-stepper.willAppear', (jsonObj) => brightnessStepper.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.temperature-stepper.willAppear', (jsonObj) => temperatureStepper.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.temperature-slider.willAppear', (jsonObj) => temperatureSlider.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.color-picker.willAppear', (jsonObj) => colorPicker.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.scene.willAppear', (jsonObj) => scene.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.debug.willAppear', (jsonObj) => debugLight.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.color-panel.willAppear', (jsonObj) => colorPanel.onWillAppear(jsonObj));
    $SD.on('com.elgato.controlcenter.layout-switcher.willAppear', (jsonObj) => layoutSwitcher.onWillAppear(jsonObj));
    

    $SD.on('applicationDidLaunch', (eventObj) => {
        // console.log('%c%s', 'background: blue; color: white;', `${eventObj.event} : ${eventObj.payload.application}`);
        if($CC && !$CC.initialized) {
            setTimeout(() => $CC.initConnection(() => {}), 2000);
        }
    });
    // $SD.on('applicationDidTerminate', (eventObj) => console.log('%c%s', 'background: blue; color: white;', `${eventObj.event} : ${eventObj.payload.application}`));
    $SD.on('applicationDidTerminate', (eventObj) => $CC.invalidateConnection());
    $SD.on('systemDidWakeUp', (eventObj) => {
        setTimeout(() => {
            // console.log('%c%s', 'background: blue; color: white;', 'systemDidWakeUp');
            // $CC.toggleDebugging(true);
            if($CC) $CC.checkConnection(true);
        }, 2000);
    });
    initializeControlCenterClient();

};

/** ACTIONS */
/**
 * LIGHTS ON/OFF SWITCH
 * subclass defined in ControlCenterKey.js
 */

const isRegisteredKey = function(jsn) {
    return Utils.getProp(jsn, 'payload.isInMultiAction', false) ? $CC.registeredKeys.find(o => o.context === jsn.context) : false;
};

const lightsOnOff = {
    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new LightsOnOff(jsn, {
                property: 'lights.on',
            });
        }
    },
};

const battery = {
    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new Battery(jsn, {property: 'lights.on'});
        }
    },
};


/**
 * COLOR STRIP
 */


const colorPicker = {
    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new ControlCenterColorPicker(jsn, {
                property: 'lights.on',
            });
        }
    },
};

const scene = {
    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new Scene(jsn, {property: 'lights.sceneId'});
        }
    },
};


/**
 * BRIGHTNESS SLIDER
 * subclass defined in ControlCenterKey.js
 * */

const brightnessSlider = {

    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new ControlCenterSlider(jsn, {
                min: 3,
                max: 100,
                defaultValue: 50,
                label: 'Brightness',
                id: 'brightness',
                property: 'lights.brightness',
                minLabel: '',
                maxLabel: '',
                minIcon: 'icon-darker',
                maxIcon: 'icon-brighter',
                class: 'colorbrightness',
                classLabel: 'percent',
                sendEvent: 'oninput',
                callbacks: [
                    {
                        name: 'sliderCallback',
                        when: 'oninput',
                    }
                ],

            });
        }
    },
};

const temperatureSlider = {

    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new ControlCenterSlider(jsn, {
                maxLabel: (me, device) => {
                    // const v = me.utils.getProp(device, 'lights.temperatureMin', 2900);
                    // return Math.floor(v / 50) * 50;
                    return 2900;
                },
                minLabel: (me, device) => {
                    // const v = me.utils.getProp(device, 'lights.temperatureMax', 7000);
                    // return Math.ceil(v / 50) * 50;
                    return 6993;
                },
                max: (me, device) => {
                    // const v = me.utils.getProp(device, 'lights.temperatureMin', 2900);
                    // return Math.floor(Utils.kelvinToMired(v));
                    return Math.floor(Utils.kelvinToMired(2907));
                },
                min: (me, device) => {
                    // const v = me.utils.getProp(device, 'lights.temperatureMax', 7000);
                    // return Math.ceil(Utils.kelvinToMired(v));
                    return Math.ceil(Utils.kelvinToMired(6993));
                },
                value: (me, device) => {
                    const v = me.utils.getProp(device, 'lights.temperature', 4700);
                    return Utils.miredToKelvin(v);
                },
                setValue: (value, key) => {
                    switch(key) {
                        case 'lights.temperature':
                            return Math.round(Utils.miredToKelvin(value));
                        default:
                            return value;
                    }
                },
                defaultValue: 4700,
                default_min: 2900,
                default_max: 7000,
                label: 'Temperature',
                id: 'temperature',
                class: 'colortemperature',
                property: 'lights.temperature',
                reverse: false,
                minIcon: 'icon-cooler',
                maxIcon: 'icon-warmer',
                labelCallback: (function(v) {return Utils.kelvinToMired(v, 50);}).toString(),
                classLabel: 'kelvin',
                sendEvent: 'oninput',
                callbacks: [
                    {
                        name: 'sliderCallback',
                        when: 'oninput',
                    }
                ],
            });
        }
    },
};


const brightnessStepper = {

    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new BrightnessStepper(jsn, {
                defaultValue: 10,
                label: 'Step Size',
                id: 'brightness',
                property: 'lights.brightness',
                autoRepeat: true,
            });
        }
    },
};

const temperatureStepper = {

    onWillAppear: function(jsn) {
        if(!isRegisteredKey(jsn)) {
            // eslint-disable-next-line no-unused-vars
            const ccKey = new TemperatureStepper(jsn, {
                defaultValue: 4700,
                default_min: 2900,
                default_max: 7000,
                label: 'Step Size',
                id: 'temperature',
                property: 'lights.temperature',
                autoRepeat: true,
            });
        }
    },
};
