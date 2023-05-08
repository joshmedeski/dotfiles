/* global ControlCenterKey */

var Battery = function(jsn, options, clr) {

    options.allowedDeviceTypes = [DEVICETYPES.KEYLIGHTMINI];

    ControlCenterKeyLight.call(this, jsn, options, clr);
    this.blinkInterval = 0;
    this.blinkCount = 0;
    this.type = 'Battery';
    this.showBatteryLevelLabel = this.settings.showBatteryLevelLabel || CONFIG.showBatteryLevelLabel || false;
    if(this.isAllDeviceId(['deviceID'])) {
        // this.updateKeyAndDevices(false);
    } else {
        this.updateKey();
    }
};

Battery.prototype = Object.create(ControlCenterKeyLight.prototype);
Battery.prototype.constructor = Battery;

Battery.prototype.getPIData = function() {
    return {
        showBatteryLevelLabel: {
            type: 'checkbox',
            label: this.options.label || 'Show Label',
            id: 'showBatteryLevelLabel',
            value: ['showBatteryLevelLabel'],
            selected: [this.settings.showBatteryLevelLabel ? 'showBatteryLevelLabel' : ''],
            showValue: false
        }
    };
};

Battery.prototype.processValues = function(sdpiCollection) {
    if(sdpiCollection['key'] === 'showBatteryLevelLabel') {
        this.showBatteryLevelLabel = sdpiCollection.checked;
        this.utils.setProp(this.settings, sdpiCollection['key'], sdpiCollection.checked);
        this.setSettings();
    }
};

Battery.prototype.doAction = function(device, jsn) {
    this.showBatteryLevelLabel = !this.showBatteryLevelLabel;
    this.updateKey(device);
};

const isCharging = (device) => {
    return device && device.battery && device.battery.connectedToPowerSupply;
};

const MAXBLINKCOUNT = CONFIG.MAXBLINKCOUNT || 6;
const MAXBLINKSPEED = CONFIG.MAXBLINKSPEED || 600;

Battery.prototype.updateKey = function(deviceP) {
    let device = deviceP ? deviceP : this.findDeviceById(this.settings['deviceID']);
    const svg = this.compileSVGString(MDefaultColors.black, null, true, null, device);
    this.updateStreamDeckImage(svg);

    // console.log(this.blinkInterval, device ? device.battery : 'no device for battery', svg, Utils.stringToHTML(svg).querySelector('#background'));

    if(device && !isCharging(device)) {

        if(device.battery && device.battery.level < 20 && this.blinkInterval === 0) {
            this.blinkCount = 0;
            const svgNode = Utils.stringToHTML(svg);
            const bg = svgNode.querySelector('#background');
            if(bg) {
                this.blinkInterval = setInterval(() => {
                    if(this.blinkCount % 2 === 0) {
                        bg.setAttribute('fill', '#ff0000');
                    } else {
                        bg.setAttribute('fill', '#4E4A61');
                    }

                    this.utils.s2c(`data:image/svg+xml, ${escape(svgNode.outerHTML)}`, null, null, 144, 144, (img, dataUrl) => {
                        this.sd.api.setImage(this.context, dataUrl);
                    });

                    this.blinkCount++;
                    if(this.blinkCount > MAXBLINKCOUNT) {
                        clearInterval(this.blinkInterval);
                        this.blinkInterval = 0;
                        this.blinkCount = 0;
                        this.utils.s2c(`data:image/svg+xml, ${escape(svg)}`, null, null, 144, 144, (img, dataUrl) => {
                            this.sd.api.setImage(this.context, dataUrl);
                        });
                    }
                }, MAXBLINKSPEED);

            }
        }
    }

    if(this.updateTitle) this.updateTitle();
};