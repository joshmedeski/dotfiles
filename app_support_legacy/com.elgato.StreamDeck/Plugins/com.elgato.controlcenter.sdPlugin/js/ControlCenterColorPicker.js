/* global ControlCenterKey */

var ControlCenterColorPicker = function(jsn, options, clr) {

    options.allowedDeviceTypes = [DEVICETYPES.LIGHTSTRIP_EVE, DEVICETYPES.LIGHTSTRIP_OLD, DEVICETYPES.LIGHTSTRIP];

    clr = clr || 'color: white; background: blue; font-size: 13px;';
    ControlCenterKeyLight.call(this, jsn, options, clr);

    this.type = 'ColorPicker';
    this.id = `colorpicker_${this.utils.randomString(8)}`;

    /**
     * hue:         1 -360  (0 seems to be a problem in LightStrips)
     * saturation:  0 - 100
     * brightness:  0 - 100
     */

    this.throttledUpdate = this.utils.throttle(device => {
        device = device || this.settings && this.findDeviceById(this.settings['deviceID']);
        this.utils.s2c(`data:image/svg+xml, ${escape(this.compileSVGString(null, null, true, "", device))}`, null, null, 144, 144, (img, dataUrl) => {
            this.sd.api.setImage(this.context, dataUrl);
        });
    }, CONFIG.KEYACTIONTHROTTLE);

    this.throttledDeviceConfiguration = this.utils.throttle((device, prop) => {
        this.cc.setDeviceConfiguration(device, 'lights');
    }, 200);
    this.updateKey();
};

ControlCenterColorPicker.prototype = Object.create(ControlCenterKeyLight.prototype);
ControlCenterColorPicker.prototype.constructor = ControlCenterColorPicker;

ControlCenterColorPicker.prototype.doAction = function(device, jsn) {

    let payload_settings = this.utils.getProperty(jsn, 'payload.settings');

    device.lights.hue = Number(payload_settings.lights.hue);
    device.lights.saturation = Number(payload_settings.lights.saturation);
    device.lights.brightness = Number(payload_settings.lights.brightness);

    this.cc.setDeviceConfiguration(device, 'lights');
    this.updateKey(device);
    return true; // setDeviceConfiguration called
};

ControlCenterColorPicker.prototype.processValues = function(sdpiCollection) {
    if(sdpiCollection['key'] === 'color-picker') { // this.options.property) {
        // console.log('%c%s', this.clr, `processValues:COLORPICKER ${this.settings['deviceID']}`, this.settings);
        const device = this.settings && this.findDeviceById(this.settings['deviceID']);

        Object.entries(sdpiCollection.value).map(e => {
            const key = e[0];
            if(key == 'lights') {
                if(device) device.lights = e[1];
                this.settings.lights = e[1];
            } else {
                this.settings[key] = e[1];
            }
        });

        this.setSettings();

        if(device) {
            this.cc.setDeviceConfiguration(device, 'lights');
        }
    } else {
        this.utils.setProp(this.settings, sdpiCollection['key'], sdpiCollection['value']);
    }
};

ControlCenterColorPicker.prototype.updateKey = function(deviceP) {
    if(this.updateTitle) this.updateTitle();
    if(this.throttledUpdate) this.throttledUpdate(deviceP);
};

ControlCenterColorPicker.prototype.getPIData = function() {
    const device = this.settings && this.findDeviceById(this.settings['deviceID']);

    return {
        colorpicker: {
            type: 'template',
            label: this.options.label,
            id: this.options.property,
            value: this.getTemplate(),
            device: device,
        },
    };
};

// this is defined globally - should move to utils at some point
// input: h,s,v in [|
let hsv2rgb = (h, s, v, f = (n, k = (n + h / 60) % 6) => v - v * s * Math.max(Math.min(k, 4 - k, 1), 0)) => [f(5), f(3), f(1)];

// r,g,b are in [0-1]
let rgb2hex = (r, g, b) => "#" + [r, g, b].map(x => Math.round(x * 255).toString(16).padStart(2, 0)).join('');

// input hex with or without leading '#', out: rgb in [0,255]
let hex2rgb = (hex) => {
    const a = parseInt(hex.replace('#', ''), 16), r = (a >> 16) & 255, g = (a >> 8) & 255, b = a & 255; return [r, g, b];
};

let hsv2hex = (h, s, b) => rgb2hex(...hsv2rgb(h, s, b));


ControlCenterColorPicker.prototype.getTemplate = function() {
    const device = this.findDeviceById(this.settings['deviceID']);

    let mode, klvn;
    if(this.settings.hasOwnProperty('colorpicker')) {
        mode = this.utils.getProp(this.settings, 'colorpicker.mode', null);
        klvn = this.utils.getProp(this.settings, 'colorpicker.kelvin', null);

        this.settings.mode = mode;
        this.settings.kelvin = klvn;
        delete this.settings.colorpicker;
    }

    if(!mode) {
        mode = this.settings.mode || 'color';
    }

    if(!klvn) {
        klvn = this.settings.kelvin || 4700;
    }

    const hue = this.utils.getProp(this.settings, 'lights.hue', this.utils.getProp(device, 'lights.hue', MDefaultColors.hue));
    const saturation = this.utils.getProp(this.settings, 'lights.saturation', this.utils.getProp(device, 'lights.saturation', 100));
    const brightness = this.utils.getProp(this.settings, 'lights.brightness', this.utils.getProp(device, 'lights.brightness', 100));
    if(!this.settings || !this.settings.lights) {
        this.settings.lights = {
            hue: Number(hue),
            saturation: Number(saturation),
            brightness: Number(brightness),
        };
        this.setSettings();
    }

    const tpl = `<div class="sdpi-item" data-settings=${JSON.stringify(this.settings)}>
        <div class="sdpi-item-label"}>${"Color".lox()}</div>
        <div class="sdpi-item-value double ${mode}"  data-mode="${mode}" data-hue=${hue} data-saturation=${saturation} data-brightness=${brightness} data-kelvin=${klvn}  type="color-picker" id="${this.id}">
            <!--span class="loupe"></span-->

            <div class="color-picker spectrum">
                <div class="spectrum-overlay"></div>
                <div class="color-spot"></div>
            </div>
            <div class="color-options">
               <input type="color" class="color-chip">
               <div class="color-mode-switch">
                   <div class="rectangle spektrum"></div>
                   <div class="rectangle white"></div>
               </div>
            </div>
        </div>
    </div>

    <div type="range" class="sdpi-item" for="${this.id}">
        <div class="sdpi-item-label">${"Brightness".lox()}</div>
        <div class="sdpi-item-value">
            <input id="lights.brightness" class="floating-tooltip colorbrightness" data-suffix="%" type="range" min="0" max="100" value=100>
        </div>
    </div>`;
    return tpl;
};