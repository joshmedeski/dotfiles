/* global ControlCenterKey */

const ControlCenterSlider = function(jsn, options, clr) {

    if (Utils.getProp(options, 'property') == 'lights.temperature') {
        options.allowedDeviceTypes = [DEVICETYPES.KEYLIGHT, DEVICETYPES.KEYLIGHTAIR, DEVICETYPES.RINGLIGHT, DEVICETYPES.KEYLIGHTMINI];
    }

    ControlCenterKeyLight.call(this, jsn, options, clr);
    this.type = 'ControlCenterSlider';
    this.showValuesArr = ['Value','Desired State'];

    // this.dynamicIcon = null;
    this.selectors = {};
    const self = this;
    this.throttledUpdate = Utils.throttle(function(prcnt_dec, vlu) {
        self.updateIcon(prcnt_dec, vlu);
    }, CONFIG.KEYACTIONTHROTTLE);

    this.throttledMessage = Utils.throttle(function(device, prop) {
        self.cc.setDeviceConfiguration(device, prop);
    }, 100);
    this.updateKey();
};

ControlCenterSlider.prototype = Object.create(ControlCenterKeyLight.prototype);
ControlCenterSlider.prototype.constructor = ControlCenterSlider;

ControlCenterSlider.prototype.getPIData = function() {

    const device = this.settings && this.findDeviceById(this.settings['deviceID']);

    return {
        [this.options.id]: {
            type: 'range',
            label: this.options.label,
            id: this.options.property,
            minIcon: this.options.minIcon || '',
            maxIcon: this.options.maxIcon || '',
            reverse: this.options.reverse || false,
            minLabel: typeof this.options.minLabel === 'function' ? String(this.options.minLabel(this, device)) : this.options.minLabel || '',
            maxLabel: typeof this.options.maxLabel === 'function' ? String(this.options.maxLabel(this, device)) : this.options.maxLabel || '',
            default_min: this.options.default_min || 0,
            default_max: this.options.default_max || 100,
            value: {
                min: typeof this.options.min === 'function' ? this.options.min(this, device) : this.getMinValue(device),
                max: typeof this.options.max === 'function' ? this.options.max(this, device) : this.getMaxValue(device),
                value: fix_temperature(this.utils.getProperty(this.settings, this.options.property, this.options.defaultValue))
            },
            callback: this.options.callback || undefined,
            class: this.options.class || undefined,
            labelCallback: this.options.labelCallback || undefined,
            classLabel: this.options.classLabel || undefined,
            callbacks: this.options.callbacks || undefined,
            sendEvent: this.options.sendEvent || undefined,
            device: device,
        }
    };
};

function fix_temperature(v) {
    if (v > 2800) {
        return Math.ceil(Utils.kelvinToMired(v));
    }
    return v;
}

ControlCenterSlider.prototype.doAction = function(device, jsn) {
    this.debugLog('%c%s', this.clr, `ControlCenterSlider:${this.options.label} doAction`);
    const defaultValue = this.utils.getProp(device, this.options.property, this.options.defaultValue);
    const value = Number(this.utils.getProp(jsn.payload, `settings.${this.options.property}`, defaultValue));
    this.utils.setProp(device, this.options.property, value);
};

ControlCenterSlider.prototype.processValues = function(sdpiCollection) {
    if (sdpiCollection['key'] === this.options.property) {
        let value = typeof this.options.setValue === 'function' ? this.options.setValue(sdpiCollection['value'], this.options.property) : sdpiCollection['value'];
        this.utils.setProp(this.settings, sdpiCollection['key'], value);
    } else {
        this.utils.setProp(this.settings, sdpiCollection['key'], sdpiCollection['value']);
    }
};

ControlCenterSlider.prototype.updateControlCenter = function() {
    const value = Number(this.utils.getProperty(this.settings, this.options.property));
    if (value) {
        const device = this.settings && this.findDeviceById(this.settings['deviceID']);
        console.assert(device, '[ControlCenterSlider]:device not found', this.settings['deviceID'], this.settings);
        if (device) {
            let v = typeof this.options.setValue === 'function' ? this.options.setValue(value, this.options.property) : value;
            this.utils.setProp(device, this.options.property, value);
            if (this.throttledMessage) this.throttledMessage(device, this.options.property);
        }
    }
};

ControlCenterSlider.prototype.getValueOfDevice = function(device) {
    if (device) {
        return Number(this.utils.getProperty(device, this.options.property) || 0);
    }
    return 0;
};

// ControlCenterSlider.prototype.getValue = function (device) {
//     return typeof this.options.value === 'function' ? this.options.value(this, device) : Number(this.utils.getProperty(this.settings, this.options.property));
// };

ControlCenterSlider.prototype.getMinValue = function(device) {
    if (typeof this.options.min === 'function') { return this.options.min(this, device); };
    return typeof this.options.min === 'string' ? this.utils.getProp(device, this.options.min, this.options.default_min) : this.options.min;
};

ControlCenterSlider.prototype.getMaxValue = function(device) {
    if (typeof this.options.max === 'function') { return this.options.max(this, device); };
    return typeof this.options.max === 'string' ? this.utils.getProp(device, this.options.max, this.options.default_max) : this.options.max;
};

ControlCenterSlider.prototype.updateKey = function() {
    const value = Number(this.utils.getProperty(this.settings, this.options.property));
    // console.log('updateKey', value, this.options.property, this.action, this.context);
    if (value) {
        const device = this.settings && this.findDeviceById(this.settings['deviceID']);
        let v = typeof this.options.setValue === 'function' ? this.options.setValue(value, this.options.property) : value;
        // const prcnt = 100 * Utils.rangeToPercent(v, this.getMinValue(device), this.getMaxValue(device));
        if (this.throttledUpdate) this.throttledUpdate(Utils.rangeToPercent(v, this.getMinValue(device), this.getMaxValue(device)), v);
    } else {
        this.updateIcon(0, 0);
    }
    if (this.updateTitle) this.updateTitle();
};

ControlCenterSlider.prototype.updateIcon = function(prcnt_dec, curVal) {

    let svg = '';
    const device = this.settings && this.findDeviceById(this.settings['deviceID']);
    const title = !device ? null : this.utils.getProp(this.settings, this.options.property, '');
    // const quantum = this.options.property === 'lights.temperature' ? 30 : 1;
    const quantum = this.options.property === 'lights.temperature' ? 80 : 1;  // since we now use mireds AND round the K values, we need to round here to 80 (or maybe 75) to get the correct icon
    const prcnt = prcnt_dec * 100;
    if (!device) {
        svg = this.compileSVGString('#800000', null, 'white', false);
    } else {
        const wantValue = this.utils.getProperty(this.settings, this.options.property, null);
        const isValue = this.utils.getProperty(device, this.options.property, null);

        // const sameValue = Math.abs(wantValue - isValue) < quantum; //,  
        const sameValue = Utils.quantizeNumber(wantValue, quantum, { cover: true }) == Utils.quantizeNumber(isValue, quantum, { cover: true });

    	if (this.options.property === 'lights.temperature') {
            let bgColor = Utils.lerpColor(MDefaultColors.warmColor, MDefaultColors.coolColor, prcnt_dec);
            
            let base = prcnt > 70 ? 'warmest' : prcnt < 20 ? 'coldest' : 'neutral';
            if (prcnt > 75) {
                base = 'warmest';
            } else if (prcnt > 60) {
                base = 'verywarm';
            } else if (prcnt > 49) {
                base = 'warm';
            } else if (prcnt > 39) {
                base = 'neutral';
            } else if (prcnt > 20) {
                base = 'cold';
            } else {
                base = 'coldest';
            }
            const overrideColor = {};
            //  const percnt = 1 - Utils.rangeToPercent(this.settings.lights.temperature, device.lights.temperatureMin, device.lights.temperatureMax);
            const percnt = 1 - Utils.rangeToPercent(this.settings.lights.temperature, 2907, 6993);
            // console.log('percnt', percnt, this.settings.lights.temperature, device.lights.temperatureMin, device.lights.temperatureMax);
            // overrideColor.startColor = Utils.lerpColor(MDefaultColors.coolColor, MDefaultColors.warmColor, prcnt_dec);
            overrideColor.startColor = Utils.lerpColor(MDefaultColors.coolColor, MDefaultColors.warmColor, percnt);
            overrideColor.blendColor = '#FFFFFF';
  
            svg = this.compileSVGString(bgColor, `${Utils.roundBy(title, 50)}K`, false, base, device, sameValue, overrideColor);
            
    } else {
            let bgColor = Utils.lerpColor(MDefaultColors.black, MDefaultColors.white, prcnt_dec);
            let base = prcnt > 50 ? 'light' : 'dark';
            if (prcnt > 75) {
                base = 'lightest';
            } else if (prcnt > 59) {
                base = 'verylight';
            } else if (prcnt > 49) {
                base = 'light';
            } else if (prcnt > 39) {
                base = 'dark';
            } else if (prcnt > 19) {
                base = 'verydark';
            } else {
                base = 'darkest';
            }

            svg = this.compileSVGString(bgColor, title + '%', false, base, device, sameValue);
        }
    }
    
    this.utils.s2c(`data:image/svg+xml, ${escape(svg)}`, null, null, 144, 144, (img, dataUrl) => {
        this.sd.api.setImage(this.context, dataUrl);
    });
};
