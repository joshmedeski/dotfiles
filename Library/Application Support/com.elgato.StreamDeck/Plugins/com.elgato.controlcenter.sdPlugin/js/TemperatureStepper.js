/* global Utils, ControlCenterKey */

const TemperatureStepper = function(jsn, options, clr) {

    options.allowedDeviceTypes = [DEVICETYPES.KEYLIGHT, DEVICETYPES.KEYLIGHTAIR, DEVICETYPES.RINGLIGHT, DEVICETYPES.KEYLIGHTMINI];

    ControlCenterKeyLight.call(this, jsn, options, clr);

    this.type = 'TemperatureStepper';
    this.miredMode = false;  // this is obsolete anyway, because we now use a mix of Kelving and Mired values 
    let defaultStep = 5;
    // as discussed with @nicco, a step size of <50K for the temperature stepper doesn't make sense, 
    // because the value is rounded to 50K steps in CC.app
    // - but removing the option will likely break existing setups
    if(this.isEncoder) {
        this.values = [50, 100, 200, 500];
        defaultStep = 1;
    } else {
        this.values = [-500, -200, -100, -50, 50, 100, 200, 500];
    }
    this.showStatesArr = [];
    if(!this.options.values) {this.options.values = this.values;}
    if(!this.settings.step) this.settings['step'] = defaultStep;

    this.throttledUpdate = this.utils.throttle((device, value, title, brightness, newValue, bgColor, base) => {
        this.updateDial({value, title, brightness, newValue, bgColor, device}, true); // initialize dial
        this.updateStreamDeckImageIfChanged(device, value, title, brightness, newValue, bgColor, base);
    }, CONFIG.DIALACTIONTHROTTLE);

    this.updateKey();
};

TemperatureStepper.prototype = Object.create(ControlCenterKeyLight.prototype);
TemperatureStepper.prototype.constructor = TemperatureStepper;

TemperatureStepper.prototype.getPIData = function() {
    return {
        step: {
            type: 'select',
            label: this.options.label || 'Step Size',
            id: 'step',
            value: this.options.values,
            valueSuffix: 'K',
            selected: Number(this.settings.step),
            convert: true
        }
    };
};

TemperatureStepper.prototype.formatValue = function(value, forXML) {
    const sValue = Utils.isNumber(value) ? String(value) : value;
    if(forXML) {
        return value < 0 ? String(sValue).replace('-', '&#x2745; ') : `&#x263C; ${sValue}`;
    }
    return value < 0 ? String(sValue).replace('-', '❅ ') : `☼ ${sValue}`;
};

TemperatureStepper.prototype.doAction = function(device, jsn, stopGroupMessaging = false) {
    const selectedItem = Number(this.settings.step);
    let v = selectedItem < this.options.values.length ? this.options.values[selectedItem] : this.options.defaultValue || 0;
    const ticks = jsn?.payload?.ticks || 1;
    if(this.isEncoder) {
        v *= ticks;
    }
    const value = this.miredMode
        ? Utils.kelvinToMired(Number(device.lights.temperature)) + v
        : Number(device.lights.temperature) - v;

    // get the K values for the min and max values
    const min = this.getMin(device);
    const max = this.getMax(device);
    const roundedKelvinValue = Math.round(value / 50) * 50;
    const roundedV = Math.min(max, Math.max(min, roundedKelvinValue));
    this.utils.setProp(device, this.options.property, roundedV);
    this.updateKey(device, false);
    if(!stopGroupMessaging) this.handleGroupAction(device, jsn);
};

TemperatureStepper.prototype.updateKey = function(dvc, changeValue = false) {
    const device = this.settings && this.findDeviceById(this.settings['deviceID']);
    // console.log("TemperatureStepper::updateKey", device, changeValue);

    let bgColor = '#EFEFEF';
    const step = Number(this.settings.step);
    const v = step < this.options.values.length ? this.options.values[step] : this.options.defaultValue || 0;
    let tmprtr = this.utils.getProperty(device, 'lights.temperature', 0);
    tmprtr = Math.round(tmprtr / 50) * 50;
    let title = this.isEncoder ? device?.name || '' : `${this.formatValue(v, true)} K`;
    let base = v < 0 ? 'cold' : 'warm';
    let value = "--";
    let brightness = '--';
    let newValue = "--";
    if(device) {
        if(changeValue) {
            value = this.miredMode ? Utils.kelvinToMired(tmprtr) + v : tmprtr - v;
        } else {
            value = this.miredMode ? Utils.kelvinToMired(tmprtr) : tmprtr;
        }

        const min = this.getMin(device);
        const max = this.getMax(device);
        const mired_min = this.getMin(device, true);
        const mired_max = this.getMax(device, true);
        newValue = Math.min(max, Math.max(min, value));
        // calculate mired values
        const mired_value = Utils.kelvinToMired(tmprtr);

        const mired_newValue = Math.min(mired_max, Math.max(mired_min, mired_value));
        brightness = Utils.rangeToPercent(mired_newValue, mired_max, mired_min); // flip min/max
        bgColor = Utils.lerpColorWithScale(MDefaultColors.warmColor, MDefaultColors.coolColor, brightness);
    } else {
        title = null;
        bgColor = '#800000';
    }
    this.throttledUpdate(device, value, title, brightness, newValue, bgColor, base);
};

TemperatureStepper.prototype.getMax = function(device, returnMired = false) {
    if(this.miredMode || returnMired) {
        return Math.floor(Utils.kelvinToMired(2907));
    }
    return 6993;

   /*
    if(this.miredMode || returnMired) {
        const v = Utils.getProp(device, 'lights.temperatureMin', 2900);
        return Math.floor(Utils.kelvinToMired(v));
    }
   
    const v = Utils.getProp(device, 'lights.temperatureMax', 7000);
    return Math.ceil(v);
    */
};

TemperatureStepper.prototype.getMin = function(device, returnMired = false) {
    if(this.miredMode || returnMired) {
        return Math.ceil(Utils.kelvinToMired(6993));
    }
    return 2907;
    /*
    if(this.miredMode || returnMired) {
        const v = Utils.getProp(device, 'lights.temperatureMax', 7000);
        return Math.ceil(Utils.kelvinToMired(v));
    }
    const v = Utils.getProp(device, 'lights.temperatureMin', 2900);
    return Math.floor(v);
    */
};

TemperatureStepper.prototype.updateDial = function(o, bInitialize = false) {
    if(this.isEncoder) {
        const isValidValue = (v) => (v != null && !isNaN(v)) === true;

        let opacity = o.device?.lights?.on ? 1 : CONFIG.DIALACTIONOFF_OPACITY;
        let title = {
            value: o.device?.name || null,
            opacity,
        };

        let value = {
            value: isValidValue(o.newValue) ? `${Math.round(o.newValue / 50) * 50} K` : '--',
            opacity,
        };

        let indicator = {
            value: isValidValue(o.brightness) ? 100 - o.brightness * 100 : 0,
            opacity,
            border_w: 0,
            bar_bg_c: `0:${MDefaultColors.coolColor},1:${MDefaultColors.warmColor}`,
        };

        this.setFeedback({title, value, indicator});
    }
};