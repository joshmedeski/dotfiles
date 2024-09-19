/* global Utils, ControlCenterKey */

const BrightnessStepper = function(jsn, options, clr) {
    ControlCenterKeyLight.call(this, jsn, options, clr);
    this.type = 'BrightnessStepper';
    this.initialized = false;
    let defaultStep = 10;
    this.clippedMin = 3;
    if(this.isEncoder) {
        this.values = [1, 2, 5, 10, 20, 50];
        defaultStep = 1;
    } else {
        this.values = [-100, -50, -20, -10, -5, -2, -1, 1, 2, 5, 10, 20, 50, 100];
    }
    this.showStatesArr = [];
    if(!this.options.values) {this.options.values = this.values;}
    if(!this.settings.step) this.settings['step'] = this.values.indexOf(defaultStep) || defaultStep;

    this.throttledUpdate = this.utils.throttle((device, value, title, brightness, newValue, bgColor, base) => {
        this.updateDial({value, title, brightness, newValue, device}, true); // initialize dial
        this.updateStreamDeckImageIfChanged(device, value, title, brightness, newValue, bgColor, base);
    }, CONFIG.DIALACTIONTHROTTLE);

    this.updateKey();
};

BrightnessStepper.prototype = Object.create(ControlCenterKeyLight.prototype);
BrightnessStepper.prototype.constructor = BrightnessStepper;

BrightnessStepper.prototype.getPIData = function() {
    const prefix = this.isEncoder ? '' : '+';
    return {
        step: {
            min: this.options.min || 3,
            type: 'select',
            label: this.options.label || 'Step Size',
            id: 'step',
            value: this.options.values.map(e => e > 0 ? `${prefix}${e}` : e),
            valueSuffix: '%',
            selected: Number(this.settings.step),
        }
    };
};

BrightnessStepper.prototype.doAction = function(device, jsn, stopGroupMessaging = false) {
    // console.log("BrightnessStepper::doAction", device, this.context);
    const selectedItem = Number(this.settings.step);
    let v = selectedItem < this.options.values.length ? this.options.values[selectedItem] : this.options.defaultValue || 0;
    const ticks = jsn?.payload?.ticks || 1;
    if(this.isEncoder) {
        v *= ticks;
    }
    const value = this.utils.minmax(Number(device.lights.brightness) + v, this.clippedMin, 100);
    this.utils.setProp(device, this.options.property, Math.min(100, Math.max(0, value)));
    this.updateKey(device, false);
    if(!stopGroupMessaging) this.handleGroupAction(device, jsn);
};

BrightnessStepper.prototype.updateKey = function(dvc, changeValue = true) {
    // console.trace('BrightnessStepper::updateKey', this.context);
    const device = this.settings && this.findDeviceById(this.settings['deviceID']);
    let bgColor = MDefaultColors.white;
    const step = Number(this.settings.step);
    const v = step < this.options.values.length ? this.options.values[step] : this.options.defaultValue || 0;
    let title = this.isEncoder ? device?.name || '' : v > 0 ? `+${v}%` : `${v}%`;
    let base = v > 0 ? 'verylight' : 'verydark';
    let value = "--";
    let brightness = '--';
    let newValue = "--";
    if(v > 50) {
        base = 'lightest';
    } else if(v < -50) {
        base = 'darkest';
    }
    if(device) {
        const b = this.utils.minmax(this.utils.getProperty(device, 'lights.brightness', 0), this.clippedMin, 100);
        newValue = changeValue ? this.utils.minmax(Number(b) + v) : this.utils.minmax(Number(b), this.clippedMin, 100);
        brightness = Utils.transformValue(newValue, 0, 100) / 100;
        bgColor = Utils.lerpColor(MDefaultColors.black, MDefaultColors.white, brightness);
    } else {
        title = null;
        bgColor = "#800000";
    }
    this.throttledUpdate(device, value, title, brightness, newValue, bgColor, base);
};

BrightnessStepper.prototype.updateDial = function(o, bInitialize = false) {
    if(this.isEncoder) {
        const isValidValue = (v) => v && v != null && !isNaN(v);

        let opacity = o.device?.lights?.on ? 1 : CONFIG.DIALACTIONOFF_OPACITY;
        const tmprt = this.utils.getProperty(o.device, 'lights.temperature', 0);
        const brightness = Utils.rangeToPercent(tmprt, 2900, 7000);
        const bgColor = Utils.lerpColorWithScale(MDefaultColors.warmColor, MDefaultColors.coolColor, brightness);

        let title = {
            value: o.device?.name || null,
            opacity
        };

        let indicator = {
            value: isValidValue(o.brightness) ? o.brightness * 100 : 0,
            opacity,
            // border_w: 0,
            // bar_bg_c: "0:#000000,1:#ffffff"
            bar_bg_c: `0:${MDefaultColors.black},1:${bgColor}`
        };

        let value = {
            value: isValidValue(o.newValue) ? `${o.newValue} %` : '--',
            opacity,
        };

        // console.log("+++++BrightnessStepper::updateDial", o.device?.lights?.temperature, lightsTemperature, `0:${MDefaultColors.black},1:${lightsTemperature}`);
        this.setFeedback({title, value, indicator});
    }
};