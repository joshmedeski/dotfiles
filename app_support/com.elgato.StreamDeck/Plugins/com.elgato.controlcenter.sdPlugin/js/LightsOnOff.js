/* global ControlCenterKey */

var LightsOnOff = function (jsn, options, clr) {
    
    ControlCenterKeyLight.call(this, jsn, options, clr);
    this.type = 'LightsOnOff';
    if (this.isAllDeviceId(['deviceID'])) {
        this.updateKeyAndDevices(false, jsn);
    } else {
    	this.updateKey();
    }
};

LightsOnOff.prototype = Object.create(ControlCenterKeyLight.prototype);
LightsOnOff.prototype.constructor = LightsOnOff;

LightsOnOff.prototype.doAction = function (device, jsn) {
    if (jsn.payload && jsn.payload.isInMultiAction) {
        device.lights.on = Boolean(!jsn.payload.userDesiredState);
    } else {
        device.lights.on = !device.lights.on;
    }
    this.updateKey(device, jsn);
};

LightsOnOff.prototype.updateKey = function(deviceP, jsn) {
    let device = deviceP ? deviceP : this.findDeviceById(this.settings['deviceID']);
    let state = device && device.lights && device.lights['on'] ? 0 : 1;
    if(!device || !device.lights) {
        if(this.isAllDevices(this.settings)) {
            this.cc.devices.forEach((d, i) => {
                if(d.lights) {
                    state = state && d.lights.on;
                }
                if(!device) {
                    device = d;
                }
            });
            state = !state; //finally toggle the current state
        }
    }

    this.sd.api.setState(this.context, state);
    const onoff = state ? 'off' : 'onoff';
    const svg = this.compileSVGString(MDefaultColors.black, null, true, onoff, device, null, null, this.context);
    this.utils.s2c(`data:image/svg+xml, ${escape(svg)}`, null, null, 144, 144, (img, dataUrl) => {
        this.sd.api.setImage(this.context, dataUrl);
    });
    if(this.updateTitle) this.updateTitle();
};


