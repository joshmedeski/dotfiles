/* global Utils */
const MDefaultColors = {
    backgroundColor: '#4E4E61',
    backgroundColor_light: '#C3C3EE', //Utils.fadeColor('#4E4E61', 60),
    warmColor: CONFIG.warmColor || '#FFB165',
    mediumColor: '#FFF2EC',
    coolColor: CONFIG.coolColor || '#94D0EC',
    warm: '#FFD580',
    cool: '#80D5FF',
    coolColorHue: 200,
    warmColorHue: 40,
    black: '#000000',
    white: '#EFEFEF',
    warn: '#E62727',
    hue: 213,
    overlayOpacity: .9
};

const MALLDEVICESID = '00:00:00:00:00:00';
const MGROUPPREFIX = 'g::';

const MGradients = {
    light: {
        startColor: '#7E7E7F',
        stopColor: '#CDCDCE',
        fontColor: '#333366',
    },
    verylight: {
        startColor: '#BBBBBC',
        stopColor: '#DEDEDE',
        fontColor: '#444477',
    },
    lightest: {
        startColor: '#DFDFDF',
        stopColor: '#EFEFFF',
        fontColor: '#555588',
    },
    dark: {
        startColor: '#444466',
        stopColor: '#7F7F7F',
        fontColor: '#DEDEFF',
    },
    verydark: {
        startColor: '#393333',
        stopColor: '#444466',
        fontColor: '#CECEEF',
    },
    darkest: {
        startColor: '#101013',
        stopColor: '#434355',
        fontColor: '#BBBBCC',
    },

    warmest: {
        startColor: '#FF5800',
        stopColor: '#FFF1DB',
        fontColor1: '#FFFDFA', //"#663300"
        fontColor: '#30434D', //"#663300"
    },
    verywarm: {
        startColor: '#FF7733',
        stopColor: '#FFF1DB',
        // fontColor: '#FFFDFA', //"#663300"
        fontColor: '#30434D', //"#663300"
    },
    warm: {
        startColor: '#FFC56C',
        stopColor: '#FFF1DB',
        fontColor: '#553F1B', //"#663300"
    },
    coldest: {
        startColor: '#3C5CDC', // "#7AABC2",
        stopColor: '#AFB5FF',
        fontColor: '#30434D', //"#384F59", //
    },
    cold: {
        startColor: '#869EDD',
        stopColor: '#DBF4EE',
        fontColor: '#30434D', //"#384F59", //
    },
    neutral: {
        startColor: '#CCDEEE',
        stopColor: '#CDF3FF',
        fontColor: '#303030', //"#384F59", //
    },
    red: {
        startColor: '#D92525',
        stopColor: '#FF5353',
        fontColor: '#FFFFFF',
    },
    black: {
        startColor: '#131826',
        stopColor: '#2B344E',
        fontColor: '#FFFFFF',
    },
    off: {
        startColor: '#131826',
        stopColor: '#2B344E',
        fontColor: '#FFFFFF',
    },
    onoff: {
        startColor: '#F7BF00',
        stopColor: '#FFEECD',
        fontColor: '#303030', //"#663300"
    },
};

const BATTERYDISPLAYMODE = {
    off: {
        scale: 1,
        transform: {
            x: 0,
            y: 0
        }
    },
    normal: {
        scale: 2.5,
        transform: {
            x: -208,
            y: 20
        }
    },
    middle: {
        scale: 3,
        transform: {
            x: -260,
            y: 8
        }
    },
    bottomCenter: {
        scale: 1.5,
        transform: {
            x: -92,
            y: 90
        }
    }
};

const MLONGTOUCHDELAY = 600;
const ControlCenterKey = function(jsn, options, debugColor) {
    let debugLog = this.debugLog = Utils.setDebugOutput(options && options.debug);
    const self = this;
    this.state = {
        dialPress: 0,
        touchTap: 0
    };
    this.utils = window.Utils;

    if(!window.$CC.initialized) {
        window.$CC.initConnection(true);
    }
    // this.curDevice = null;

    this._showValueInTitleProp = '$showvalueintitle';
    this.controller = jsn?.payload?.controller || '';
    // SD+ support
    this.isEncoder = this.controller === 'Encoder';
    this.title = '';
    this.redrawCache = {};
    // this.titleParameters = {};
    // End SD+ support

    this.curImageName = '';
    this.action = jsn.action;
    this.sd = window.$SD;
    this.cc = window.$CC;
    this.imageCache = window.MIMAGECACHE;
    this.context = jsn.context;
    this.settings = {};
    this.listeners = [];
    this.options = options;
    this.timer = null;
    this.actionTriggered = false;
    this.debug = options && options.debug;
    this.lastTime = 0;
    this.repeatDelay = options && options.repeatDelay ? options.repeatDelay : 160;
    const autoRepeat = options && options.autoRepeat ? options.autoRepeat : false;
    let clr;
    this.clr = clr = debugColor || 'color: black; background: silver; font-size: 11px;';

    this.allowedDeviceTypes = (options && options.allowedDeviceTypes) || [DEVICETYPES.KEYLIGHT, DEVICETYPES.KEYLIGHTAIR, DEVICETYPES.RINGLIGHT, DEVICETYPES.KEYLIGHTMINI];

    /** ControlCenter wrappers */
    this.getDeviceIds = this.cc.getDeviceIds.bind(this.cc);
    this.findDeviceById = this.cc.findDeviceById.bind(this.cc);
    this.findDeviceByName = this.cc.findDeviceByName.bind(this.cc);
    this.findDeviceIndex = this.cc.findDeviceIndex.bind(this.cc);

    this.cc.registerKey(this);

    /** ignore all title modifications */


    const setTitleParameters = (jsn) => {
        // this.titleParameters = jsn?.payload?.titleParameters;
        const oldTitle = this.title;
        this.title = jsn?.payload?.title || jsn?.payload?.settings?.name;
        // console.log(this.type + "::setTitleParameters", jsn, this.title != oldTitle, this.title, oldTitle);
        return this.title != oldTitle;
    };

    if(this.isEncoder) {
        this.listeners.push(
            this.sd.on(`${this.action}.titleParametersDidChange`, jsonObj => {
                if(jsonObj['context'] === this.context) {
                    // update key only if something changed
                    if(setTitleParameters(jsonObj)) {
                        this.updateKey(null, false);
                    }
                }
            })
        );
    }

    /**
     * When the key will appear for the first time (e.g. dragged in
     * from the action list) it has no settings. So we initialize it with
     * some default settings.
     *
     * If the key was already defined, it carries it's settings in the
     * payload.
     */

    // console.log('%c%s parseSettings:', 'background-color: red; color: white;font-size:12px;', jsn.action, jsn);

    this.setSettings(this.parseSettings(jsn));

    this.toggleDebugging = function(tof) {
        this.debug = Utils.isUndefined(tof) ? !this.debug : tof === true;
        debugLog = this.debugLog = Utils.setDebugOutput(this.debug);
    };

    this.isAllDevices = function(settings) {
        return (settings && settings.hasOwnProperty('deviceID') && (settings['deviceID'] === MALLDEVICESID));
    };
    this.isAllDeviceId = function(deviceID) {
        return (deviceID && typeof deviceID == 'string' && deviceID.includes(MALLDEVICESID));
    };

    this.isLightStrip = (jsn) => {
        return (jsn && jsn.type) && [DEVICETYPES.LIGHTSTRIP_EVE, DEVICETYPES.LIGHTSTRIP_OLD, DEVICETYPES.LIGHTSTRIP].includes(jsn.type)
            || this.settings && this.settings.type && [DEVICETYPES.LIGHTSTRIP_EVE, DEVICETYPES.LIGHTSTRIP_OLD, DEVICETYPES.LIGHTSTRIP].includes(this.settings.type);
    };

    this.getPiDataDefault = function(dvc) {
        const deviceList = {};
        const deviceID = this.settings['deviceID'];
        const allDevicesSelector = this.isAllDeviceId(deviceID);

        let idx = 0;
        if(!(this.utils.isEmptyString(deviceID) || allDevicesSelector)) {
            const device = this.settings && this.findDeviceById(deviceID);
            console.assert(device, '[ControlCenterKey.getPiDataDefault]:device not found', deviceID, this.settings);
            if(!device) {
                const dName = '<disabled>' + this.settings['name'] || 'Unknown device';
                deviceList[dName] = this.settings['deviceID'] || '-1';
            } else {
                idx = this.findDeviceIndex(deviceID);
                this.cc.getDeviceConfiguration(device);
            }
        }

        this.cc.devices.forEach(e => {
            if(e.type && this.allowedDeviceTypes.includes(e.type)) {
                // check if device has all required features or properties
                if(this.deviceNeedsUpdate && this.deviceNeedsUpdate(e) === true) {
                    // remove devices from temporary list, if a required feature is missing
                    delete deviceList[e];
                    return;
                }
                deviceList[this.utils.fixName(deviceList, e.name)] = e.deviceID;
            }
        });

        idx = Object.values(deviceList).indexOf(deviceID);
        if((this.type == 'LightsOnOff') && (this.cc.devices.length)) {
            deviceList['All'.lox()] = MALLDEVICESID;
            if(allDevicesSelector) {
                idx = Object.values(deviceList).indexOf(MALLDEVICESID);
            }
        }

        return {
            controlcenter_accessory: {
                id: 'deviceID', //intentional string
                type: 'select',
                label: 'Accessory',
                value: deviceList,
                selected: idx > -1 ? idx : 0,
            },
        };
    };

    this.removeListeners = function() {
        this.listeners.forEach(function(e, i) {
            e();
            e = null;
        });
        this.listeners = [];
    };

    this.onWillAppear = function(jsn) {};
    this.onWillDisappear = function(jsn) {
        this.cc.unregisterKey(this);
        this.removeListeners();
    };

    this.checkConnection = function(jsn) {
        if(this.cc && this.cc.isConnected()) return true;

        if(this.sd) {
            console.trace('%s not connected'.lox().sprintf('Control Center'), this.cc, this.cc.connectionInfo());
            this.sd.api.showAlert(jsn.context);
        }
        return false;
    };

    this.hasDevice = function() {
        return this.settings && this.settings.hasOwnProperty('deviceID') && !this.utils.isEmptyString(this.settings.deviceID);
    };

    this.updateKeyAndDevices = function(updateDevices, jsn) {
        if(this.type == 'LightsOnOff') {
            // let colr = 'color:blue;';
            // console.warn('%c%s', colr + 'font-size: 13px;', `updateKeyAndDevices:${MALLDEVICESID}::${this.type}::${updateDevices}`, jsn);
            let onOrOff = true; //this.cc.devices.length > 0;
            if(jsn?.payload && jsn.payload.isInMultiAction) {
                onOrOff = Boolean(jsn.payload.userDesiredState);
            } else {
                this.cc.devices.forEach((d, i) => {
                    if(d.lights) {
                        onOrOff = onOrOff && d.lights.on;
                    }
                });
            }

            if(updateDevices === true) {
                this.cc.devices.forEach((d, i) => {
                    d.lights.on = !onOrOff;
                    this.updateKey && this.updateKey(d);
                    this.cc.setDeviceConfiguration(d, this.options.property);
                });
            } else {
                const alreadyUpdated = [];
                this.cc.registeredKeys.map(e => {

                    // if(alreadyUpdated.indexOf(e.settings.deviceID) === -1) {
                    alreadyUpdated.push(e.settings.deviceID);
                    const isAllDeviceId = this.isAllDeviceId(e.settings.deviceID); //+++andy
                    // console.log('isAllDeviceId:', this.context, e.settings.deviceID, isAllDeviceId);
                    if(isAllDeviceId && e.updateKey) {
                        e.updateKey({
                            deviceID: MALLDEVICESID,
                            lights: {
                                on: onOrOff
                            }
                        });
                    }

                    // }

                });
            }
            return true; //handled updateKey
        };
    };

    this.doDeviceAction = function(jsn) {
        const connected = this.checkConnection(jsn);
        console.assert(connected, 'ControlCenterKey.doDeviceAction:not connected');
        if(!connected) return;
        // if(!this.checkConnection(jsn)) return;

        let settings = this.utils.getProperty(jsn, 'payload.settings');
        console.assert(settings, this.type, jsn);

        /**
         * • If all accessories have lights switched on, the global on/off button state is "on".
         * • If any accessory has lights switched off, the global on/off button state is "off".
         * • Pressing the button always toggles the current state
         */
        if(this.isAllDeviceId(settings['deviceID'])) {
            this.updateKeyAndDevices(true, jsn); // true = update key and devices
            return;
        }
        // search again, device might have been disconnected...
        const device = settings && this.findDeviceById(settings['deviceID']);
        console.assert(device, this.type, settings);

        if(device) {
            let deviceConfigurationCalled = false;
            if(this.doAction) {
                deviceConfigurationCalled = this.doAction(device, jsn);
            } else {
                console.warn('%c%s', clr + 'font-size: 23px;',
                    `NO DOACTION ON this`, this);
            }
            if(!deviceConfigurationCalled) {
                this.cc.setDeviceConfiguration(device, this.options.property);
            }
        } else {
            console.trace(`[cckey] device ${settings['deviceID']} not found`, device, settings, this.settings);
            this.sd.api.showAlert(jsn.context);
        }
    };

    this.onKeyUp = function(jsn) {
        this.clearTimer();
        if(!this.checkConnection(jsn)) return;
        this.keyIsDown = false;
        if(!this.actionTriggered) {
            this.doDeviceAction(jsn);
        }
    };

    this.clearTimer = function() {
        if(this.timer) {
            clearTimeout(this.timer);
            this.timer = null;
        }
    };

    this.onKeyDown = function(jsn) {
        this.clearTimer();
        if(!this.checkConnection(jsn)) return;
        this.actionTriggered = false;
        if(autoRepeat) {
            this.keyIsDown = true;
            const delay = this.currentState === 0 || this.currentState === 1 ? 1000 : this.repeatDelay || 150;
            this.timer = setTimeout(function() {
                if(self.keyIsDown) {
                    self.actionTriggered = true;
                    self.doDeviceAction(jsn);
                    self.onKeyDown(jsn);
                }
            }, delay);
        } else if(this.type === 'Scene') {
            const device = this.settings && this.findDeviceById(this.settings['deviceID']);
            this.keyIsDown = true;
            setTimeout(function() {
                console.log("***** long keypress detected", self.keyIsDown, device);
                if(self.keyIsDown) {
                    if(device?.lights) {
                        device.lights.on = !device.lights.on;
                        if(self.activateScene) {
                            self.activateScene(device, jsn);
                        }
                        self.handleGroupAction(device, jsn, true);
                        self.cc.setDeviceConfiguration(device, 'lights');
                    }
                }
                self.keyIsDown = false;
            }, MLONGTOUCHDELAY);
        }
    };

    this.onDialRotate = function(jsn) {
        this.doDeviceAction(jsn);
    };

    this.onDialDefaultAction = function(jsn, actionType) {
        const device = this.settings && this.findDeviceById(this.settings['deviceID']);
        if(this.onDialAction) {
            this.onDialAction(device, jsn, actionType);
        };
        if(device?.lights) {
            device.lights.on = !device.lights.on;
            this.handleGroupAction(device, jsn, true);
            this.cc.setDeviceConfiguration(device, 'lights');
        }
    };

    this.onDialPress = function(jsn) {
        const pressed = this.utils.getProperty(jsn, 'payload.pressed', false);
        if(pressed == false) {
            if(Date.now() - this.state.dialPress > MLONGTOUCHDELAY) {
                if(this.onDialPressLong) {
                    return this.onDialPressLong(jsn);
                }
            }
            this.onDialDefaultAction(jsn, 'dialPress');
        } else {
            this.state.dialPress = Date.now();
        }
    };

    this.onTouchTap = function(jsn) {
        const hold = jsn?.payload?.hold || false;
        if(!hold) {
            this.onDialDefaultAction(jsn, 'touchTap');
            return;
        } else {
            if(this.onTouchTapLong) {
                return this.onTouchTapLong(jsn);
            }
        }
        if(this.touchTap) {
            this.state.touchTap = Date.now();
            return this.touchTap(jsn);
        }
    };

    /** Add listeners to StreamDeck's default events
     * @willDisappear: sent, when a key is about to appear in software and hardware
     * @sendToPlugin: sent from Property Inspector to plugin, if data changed (or data
     * is initially requested)
     * @keyUp: sent when a key was pressed
     */

    this.listeners.push(
        this.sd.on(`${this.action}.willDisappear`, jsonObj => {
            if(jsonObj['context'] === this.context) {
                self.onWillDisappear(jsonObj);
            }
        })
    );

    // fixDevice is called when a key received empty (persistent) settings
    this.fixDevice = function() {
        // we have already valid settings, make sure they are saved persistently in StreamDeck
        const deviceID = this.settings['deviceID'];
        if(deviceID) {
            this.setSettings();
            return;
        }
        // A key's setting has a 'deviceID' already
        // see if CC has devices
        let device = this.utils.getProperty(this.cc, 'devices.0');
        if(!device) {
            // ControlCenter-Client has no devices (yet)
            return;
        }
        device = this.findFirstAvailableDevice();
        if(!device) {
            // no device of requested device-type found
            return;
        }
        // add 'deviceID' and 'name' to our persistent settings ('name' is only for display purposes)
        this.utils.setProp(this, 'settings.deviceID', device.deviceID);
        this.utils.setProp(this, 'settings.name', device.name || '');
        this.setSettings();
    };

    this.listeners.push(
        this.sd.on(`${this.action}.didReceiveSettings`, jsonObj => {
            if(jsonObj['context'] === this.context) {
                const deviceID = Utils.getProp(jsonObj, 'payload.settings.deviceID', false);
                console.log('didReceiveSettings (payload/settings)', deviceID, this.settings['deviceID']);

                if(!deviceID || deviceID != this.settings['deviceID']) {
                    // key has no settings saved, fix it
                    this.fixDevice();
                }
            }
        })
    );

    // $SD.on('applicationDidLaunch', (eventObj) => {
    this.updatePI = function(msg, dvc) {
        if(this.cc && this.cc.isConnected()) {
            if(this.cc.devices.length === 0) {
                this.sd.api.sendToPropertyInspector(this.context, {
                    error: '%s not found'.lox().sprintf('Accessory'.lox())
                }, this.action);
            } else {
                // if dvc param is passed, device was added
                let device = null;
                if(dvc && typeof dvc === 'object' && (dvc.deviceID == this.settings['deviceID'])) {
                    this.settings.name = dvc.name;
                    device = dvc;
                } else {
                    device = this.findDeviceById(this.settings['deviceID']);
                }

                const piData = Object.assign(
                    this.getPiDataDefault({device: device}),
                    (this.getPIData && this.getPIData()) || {}
                );

                // console.log('%c%s', this.clr, "PIDATA", piData);

                this.sd.api.sendToPropertyInspector(
                    this.context,
                    Object.assign({propertyInspectorDataAsString: JSON.stringify(piData)}, piData),
                    this.action
                );
                return device;
            }
        } else {
            debugLog('%c%s', 'background-color: red; font-size:15px; color:white;', '[updatePI] NOT.connected', this.action);
            this.sd.api.sendToPropertyInspector(this.context, {
                error: 'Please launch %s'.lox().sprintf('Control Center')
            }, this.action);
        }
    };

    this.listeners.push(
        this.sd.on(`${this.action}.sendToPlugin`, jsn => {
            const pl = Utils.getProp(jsn, 'payload.property_inspector', {});
            const piConnected = pl === 'propertyInspectorConnected';
            const targetContext = Utils.getProp(jsn, 'payload.targetContext', 0);
            const showPI = piConnected && targetContext === this.context;
            if(targetContext === this.context) {
                const xtWindowItem = Utils.getProp(jsn, 'payload.showInExternalWindow', {});
                if(xtWindowItem && typeof xtWindowItem === 'string' && xtWindowItem.includes('.html')) {
                    const w = window.open(xtWindowItem, xtWindowItem);
                    w.focus();
                    w.onbeforeunload = function() {
                        w = null;
                    };
                }
            }
            // console.log('sendToPlugin', (showPI || jsn['context'] === this.context),{type: this.type, showPI, context_jsn: jsn.context, context_this: this.context, context_target: targetContext,context_same: jsn.context === this.context, settings:this.settings, jsn});
            if(showPI || jsn['context'] === this.context) {
                const piDataRequest = Object.keys(jsn.payload).length === 0 || piConnected;
                this.cc.propertyInspectorShown = piDataRequest ? this : null;
                if(piDataRequest) {
                    this.updatePI('sendToPlugin');
                } else if(jsn.payload.hasOwnProperty('sdpi_collection')) {
                    const sdpiCollection = jsn.payload['sdpi_collection'];
                    if(sdpiCollection['key'] == 'no_key_found') {
                        console.log('%c%s', 'color: white; background: red; font-size: 15px;', sdpiCollection);
                        return;
                    }
                    if(this.processValues) this.processValues(sdpiCollection);
                    else {
                        // key could be a dot-separated string, e.g. 'lights.brightness', so we set it with our utility
                        this.utils.setProp(this.settings, sdpiCollection.key, sdpiCollection.value);
                    }

                    if(sdpiCollection.hasOwnProperty("key") && sdpiCollection.key === 'deviceID') {
                        const d = this.findDeviceById(sdpiCollection.value);
                        if(d && d.name && this.settings['deviceID']) { //+++andy 2021-12-07
                            this.settings['name'] = d.name;
                            this.settings['type'] = d.type || -1;
                        }
                        // 
                        if(this.type === 'Scene') {
                            this.updatePI('sendToPlugin');
                        }
                    }

                    this.setSettings();
                    if(this.updateKey) this.updateKey();
                    if(this.updateTitle) this.updateTitle();
                    // only update value changes - not for display changes
                    if(!['$showstate', '$showvalueintitle'].includes(sdpiCollection['key'])) {
                        if(this.updateControlCenter) this.updateControlCenter();
                    }
                }
            }
        })
    );

    this.listeners.push(
        this.sd.on(`${this.action}.keyUp`, jsonObj => {
            debugLog('CC:Keyup', jsonObj);
            if(jsonObj['context'] === this.context) {
                self.onKeyUp(jsonObj);
            }
        })
    );

    this.listeners.push(
        this.sd.on(`${this.action}.keyDown`, jsonObj => {
            if(jsonObj['context'] === this.context) {
                self.onKeyDown(jsonObj);
            }
        })
    );

    /* 2022-08-08 SD+ support */

    this.listeners.push(
        this.sd.on(`${this.action}.dialRotate`, (jsonObj) => {
            if(jsonObj['context'] === this.context) {
                try {
                    self.onDialRotate(jsonObj);
                } catch(e) {
                    // console.log('%c%s', 'color: white; background: red; font-size: 11px;', e, self);
                    console.error(e, self);
                }

            }
        })
    );

    this.listeners.push(
        this.sd.on(`${this.action}.dialPress`, (jsonObj) => {
            if(jsonObj['context'] === this.context) {
                self.onDialPress(jsonObj);
            }
        })
    );

    this.listeners.push(
        this.sd.on(`${this.action}.touchTap`, (jsonObj) => {
            if(jsonObj['context'] === this.context) {
                self.onTouchTap(jsonObj);
            }
        })
    );;

    /* End SD+ */

    this.listeners.push(
        this.cc.on('deviceRenamed', (device, name) => {
            if(this.settings.deviceID == device.deviceID) {
                this.settings.name = device.name || '';
            }
            this.updatePI('deviceRenamed');
        })
    );

    this.listeners.push(
        this.cc.on('deviceRemoved', (device, name) => {
            this.updatePI('deviceRemoved');
        })
    );

    this.listeners.push(
        this.cc.on('deviceAdded', (device, name) => {
            // console.log('%c%s', 'background: green; color: white;', 'deviceAdded', device);
            if(device && !this.hasDevice()) {
                this.settings = device;
                // console.log('%c%s', 'background: green; color: white;', 'new deviceAdded', this.settings);
            }
            setTimeout(() => (this.updatePI('deviceAdded', device), 0)); // allow updating first - this just removes some false assertions
        })
    );

    // this.listeners.push(this.cc.on('deviceConfigurationChanged', (device) => {
    //     // this.updateDevice(device);
    // }));

    this.setImage = function(imgName) {
        var self = this;
        if(this.curImageName !== imgName) {
            this.curImageName = imgName;
            const ext = this.sd.applicationInfo.devicePixelRatio > 1 ? '@2x' : '';
            const imgPath = `action/images/${imgName}${ext}.png`;
            if(this.imageCache.hasOwnProperty(imgPath)) {
                this.sd.api.setImage(this.context, this.imageCache[imgPath]);
            } else {
                this.utils.getDataUri(imgPath, function(imgUrl) {
                    self.imageCache[imgPath] = imgUrl;
                    self.sd.api.setImage(self.context, imgUrl);
                });
            }
        }
    };

    this.setFeedback = ({title = '', value = null, indicator = null, icon = null, layoutId = null}) => {
        const payload = {
            event: "setFeedback",
            context: this.context,
            payload: {}
        };

        let tempTitle = null;
        if(value) {
            payload.payload.value = value;
        }
        if(indicator) {
            payload.payload.indicator = indicator;
        }
        if(typeof title === 'string' && title.length > 0) {
            tempTitle = title;
        } else if(this.utils.isDefined(title) && this.utils.isDefined(title.value) && title.value.length) {
            tempTitle = title.value;
        }
        if(tempTitle !== null) {
            payload.payload.title = {value: tempTitle};
        }
        if(icon !== null) {
            payload.payload.icon = {value: icon};
        }
        if(layoutId !== null) {
            this.setFeedbackLayout(layoutId);
        }
    //    console.log("setFeedback", payload, this.context);
        this.sd.api.send(this.context, 'setFeedback', payload);
    };

    this.setFeedbackLayout = (layoutId) => {
        const payload = {
            event: "setFeedbackLayout",
            context: this.context,
            payload: {
                layout: layoutId
            }
        };
        this.sd.api.send(this.context, 'setFeedbackLayout', payload);
        // if(this.lastPayload) {
        //     console.log("had a last payload", this.lastPayload);
        //     this.sd.api.send(this.context, 'setFeedback', this.lastPayload);
        // }
    };

};

ControlCenterKey.prototype.handleGroupAction = function(device, jsn, onOff) {
    if(!this.title || !this.title.startsWith(MGROUPPREFIX)) return;
    const groupName = this.title.split(' ')[0];
    // allDevicesOfAllowedType
    // Allow all groups of the same name, which are in the list of allowed device types for this action (e.g. brightness && temperature)
    // const allowedGroups = this.cc.registeredKeys.filter(e => e.allowedDeviceTypes.some(r => this.allowedDeviceTypes.includes(r)));
    // const targets = allowedGroups.filter(k => k !== this && k.title.startsWith(groupName));

    // const allowedDeviceTypes = this.allowedDeviceTypes;
    // const targets =  this.cc.registeredKeys.filter(e => {
    //         const isAllowedType = e.allowedDeviceTypes.some(r => allowedDeviceTypes.includes(r));
    //         return isAllowedType && e !== this && e.title.startsWith(groupName)
    //     })

    // Only allow all groups of the same type (e.g. brightness)
    const targets = this.cc.registeredKeys.filter(e => (e !== this) && (e.type == this.type) && e.title.startsWith(groupName));
    //  console.log('GROUPS', this.title, {groupName, targets});
    if(targets && targets.length) {
        if(onOff) {
            // create a temp array to remove duplicates
            const deviceIdSet = new Set();
            targets.forEach(target => deviceIdSet.add(target.settings['deviceID']));
            // console.log('deviceIdSet', deviceIdSet);
            deviceIdSet.forEach(id => {
                const d = this.findDeviceById(id);
                if(d) {
                    d.lights.on = device.lights.on;
                    this.cc.setDeviceConfiguration(d, 'lights');
                }
            });
            targets.forEach(target => {target.updateKey(null, false);});
        } else {
            targets.forEach(target => {
                // allDevicesOfAllowedType
                // target.doAction(device2, jsn, true);
                const groupedDevice = target.settings && target.findDeviceById(target.settings['deviceID']);
                // console.log("calling target", target.title, device2, this.options.property, prop);
                if(groupedDevice) {
                    let prop = Utils.getProp(device, this.options.property, false);
                    if(prop !== false) {
                        Utils.setProp(groupedDevice, this.options.property, prop);
                        this.cc.setDeviceConfiguration(groupedDevice, 'lights');
                    }
                }
                target.updateKey(null, false);
            });
        }
    }
};

ControlCenterKey.prototype.setSettings = function(sts, jsn) {
    if(sts) this.settings = sts;
    this.sd.api.setSettings(this.context, this.settings);
};

ControlCenterKey.prototype.addToSettings = function(key, value) {
    if(!this.settings) {this.settings = {};};
    this.settings[key] = value;
};

ControlCenterKey.prototype.findFirstAvailableDevice = function() {
    const dvc = this.cc.devices.find(d => {
        if(this.allowedDeviceTypes.includes(d.type)) {
            if(this.deviceNeedsUpdate && this.deviceNeedsUpdate(d) === true) {
                return false;
            }
            return true;
        }
        return false;
    });
    // console.log("findFirstAvailableDevice:dvc", dvc);
    return dvc;
    // return this.cc.devices.find(d => this.allowedDeviceTypes.includes(d.type));
};

ControlCenterKey.prototype.parseSettings = function(jsn) {
    /** see, if we already have some settings (device) saved
     * if not, create a default set of settings
     * (in this case) just grab the first device of ControlCenter
     */

    let settings = Utils.getProp(jsn, 'payload.settings', {});

    /** If there are no settings, create default settings and
     * pre-select the first device in ControlCenter (if any) */
    if(Object.keys(settings).length === 0) {
        const defaultValue = this.utils.getProp(this.options, this.options.property, this.options.defaultValue || null);
        if(defaultValue) {
            this.utils.setProp(this.settings, this.options.property, defaultValue);
        }
        // If CC is already running, get the first device (if any)
        const device = this.findFirstAvailableDevice();
        if(device) {
            settings = Object.assign(this.settings, {
                deviceID: device.deviceID,
                name: device.name,
                type: device.type
            });
        }
    } else {
        if(settings['deviceID']) {
            const dvc = this.findDeviceById(settings['deviceID']);
            if(dvc && dvc.name) {
                settings['name'] = dvc.name;
                settings['type'] = dvc.type || -1;
            }
        }
    }

    if(!settings) {
        settings = {
            // deviceID: '',
            // name: 'Untitled'
        };
    }
    return settings;
};

ControlCenterKey.prototype._callback = (o, prop, v) => {
    return o && o.hasOwnProperty(prop) ? o[prop](v) : v;
};

ControlCenterKey.prototype._callOption = function(prop, v) {
    const fn = this.utils.getProp(this, `options.callback.${prop}`, null);
    return typeof fn === 'function' ? fn(v) : v;
};

ControlCenterKey.prototype.hasCallbackFor = function(prop) {
    return typeof this.utils.getProp(this, `options.callback.${prop}`, {}) === 'function';
};

ControlCenterKey.prototype.updateTitle = function(valueType, inDevice) {};

ControlCenterKey.prototype.updateStreamDeckImage = function(svg) {
    if(svg) {
        this.utils.s2c(`data:image/svg+xml, ${escape(svg)}`, null, null, 144, 144, (img, dataUrl) => {
            this.sd.api.setImage(this.context, dataUrl);
        });
    }
};

ControlCenterKey.prototype.updateStreamDeckImageIfChanged = function(device, value, title, brightness, newValue, bgColor, base) {
    const svg = this.compileSVGString(bgColor, title, true, base, device);
    if(svg !== this.redrawCache.svg) {
        this.updateStreamDeckImage(svg);
        this.redrawCache.svg = svg;
        // } else {
        //     console.log('SVG didnt change', this.context);
    }
};

ControlCenterKey.prototype.updateStreamDeckImageIfSVGChanged = function(svg) {
    if(svg !== this.redrawCache.svg) {
        this.updateStreamDeckImage(svg);
        this.redrawCache.svg = svg;
        return true;
    }
    return false;
};

ControlCenterKey.prototype.createLightStripSVG = (options) => {
    const stripColor = {
        fill: '#fff',
        stroke: '#555',
        opacity: .7 // if fill = white, then light grey - '1' for white
    };

    const isConnected = ~~($CC && $CC.isConnected());

    return `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="144" height="144" viewBox="0 0 144 144">
         <defs>
            <filter id="b_2g-a" width="116%" height="122.2%" x="-8%" y="-8.9%" filterUnits="objectBoundingBox">
                <feOffset dy="2" in="SourceAlpha" result="shadowOffsetOuter1"/>
                <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="3"/>
                <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 1 0"/>
            </filter>
          </defs>
          <g fill="none" fill-rule="evenodd">
            <rect id="background" width="144" height="144" fill="${options.backgroundColor}" rx="24"/>
            <path id="strip-with-shadow" fill="black" opacity="0.6" transform="scale (1.02)" filter="url(#b_2g-a)" d="M10.1342655,90.1133333 C10.6462655,92.1328889 12.6408244,93.9007542 15.7668924,94.0060431 L16.0632655,94.011 L132,94 L131.998599,98.7424333 L132,108 L16.0595988,108.014667 C12.3155829,108.014667 10.1089896,105.663109 10.0060362,103.252151 L10.0022655,103.075667 L10.0022655,90.1536667 L10.1342655,90.1133333 Z M126,50 C129.768822,50 129.950783,51.830099 129.959556,52.0098761 L129.96,52.024 L129.96,52.024 C130.114,53.5493333 129.879333,54.708 127.118333,55.632 L126.993667,55.6782917 L126.993667,55.6782917 L126.88,55.7273333 L29,92 L28.9285,91.9967917 L28.9285,91.9967917 L16.2583333,91.9963333 C14.0546667,91.9963333 11.9426667,90.6653333 11.8216667,88.4946667 C11.7593333,87.358 11.5613333,84.9233333 15.5323333,83.53 C15.5323333,83.53 15.8382433,83.42902 16.1961283,83.288539 L16.317,83.2403333 L105.202667,50 L126,50 Z M128.0611,34 C130.429514,34 131.902372,35.363843 132.176047,36.8737237 L132.200767,37.036 L132.178767,50.585 C132.178767,50.585 132.171433,50.8306667 132.123767,50.6436667 C131.760088,49.2807531 130.410382,48.0878441 128.303841,48.00135 L128.057433,47.9963333 L12,48 L12,34 L128.0611,34 Z" ></path>
            <g transform="translate(10 34)">
              <path opacity="${stripColor.opacity}" fill="${stripColor.fill}" stroke="${stripColor.stroke}" d="M0.134265481,56.1133333 C0.646265481,58.1328889 2.6408244,59.9007542 5.76689236,60.0060431 L6.06326548,60.011 L122,60 L121.998599,64.7424333 L122,74 L6.05959881,74.0146667 C2.31558294,74.0146667 0.108989593,71.663109 0.00603617696,69.252151 L0.00226548085,69.0756667 L0.00226548085,56.1536667 L0.134265481,56.1133333 Z M116,16 C119.768822,16 119.950783,17.830099 119.959556,18.0098761 L119.96,18.024 L119.96,18.024 C120.114,19.5493333 119.879333,20.708 117.118333,21.632 L116.993667,21.6782917 L116.993667,21.6782917 L116.88,21.7273333 L19,58 L18.9285,57.9967917 L18.9285,57.9967917 L6.25833333,57.9963333 C4.05466667,57.9963333 1.94266667,56.6653333 1.82166667,54.4946667 C1.75933333,53.358 1.56133333,50.9233333 5.53233333,49.53 C5.53233333,49.53 5.83824333,49.42902 6.19612833,49.288539 L6.317,49.2403333 L95.2026667,16 L116,16 Z M118.0611,-2.84217094e-14 C120.429514,-2.84217094e-14 121.902372,1.36384304 122.176047,2.87372373 L122.200767,3.036 L122.178767,16.585 C122.178767,16.585 122.171433,16.8306667 122.123767,16.6436667 C121.760088,15.2807531 120.410382,14.0878441 118.303841,14.00135 L118.057433,13.9963333 L2,14 L2,-2.84217094e-14 L118.0611,-2.84217094e-14 Z" />
              <path opacity="${isConnected || 0.2}" id="mini-leds" fill="${options.state == 'off' ? options.startColor : options.color}" stroke="#444" d="M38,62 L38,72 L28,72 L28,62 L38,62 Z M53,62 L53,72 L43,72 L43,62 L53,62 Z M83,62 L83,72 L73,72 L73,62 L83,62 Z M113,62 L113,72 L103,72 L103,62 L113,62 Z M23,62 L23,72 L13,72 L13,62 L23,62 Z M98,62 L98,72 L88,72 L88,62 L98,62 Z M89.6520325,20.7272108 L92.5189761,28.1958543 L84.4279458,31.3017097 L81.5610021,23.8330663 L89.6520325,20.7272108 Z M77.6520325,25.0908973 L80.5189761,32.5595407 L72.4279458,35.6653962 L69.5610021,28.1967528 L77.6520325,25.0908973 Z M20.6520325,46.0908973 L23.5189761,53.5595407 L15.4279458,56.6653962 L12.5610021,49.1967528 L20.6520325,46.0908973 Z M32.6520325,41.7272108 L35.5189761,49.1958543 L27.4279458,52.3017097 L24.5610021,44.8330663 L32.6520325,41.7272108 Z M44.6520325,36.7272108 L47.5189761,44.1958543 L39.4279458,47.3017097 L36.5610021,39.8330663 L44.6520325,36.7272108 Z M101.652033,15.7272108 L104.518976,23.1958543 L96.4279458,26.3017097 L93.5610021,18.8330663 L101.652033,15.7272108 Z M98,2 L98,12 L88,12 L88,2 L98,2 Z M113,2 L113,12 L103,12 L103,2 L113,2 Z M83,2 L83,12 L73,12 L73,2 L83,2 Z M38,2 L38,12 L28,12 L28,2 L38,2 Z M23,2 L23,12 L13,12 L13,2 L23,2 Z M53,2 L53,12 L43,12 L43,2 L53,2 Z"/>
           </g>
            ${options.overlay}
          </g>
    </svg>`;
};

ControlCenterKey.prototype.createBatterySVG = (options, device) => {
    let batteryDisplay = BATTERYDISPLAYMODE.normal;
    if(CONFIG.hasOwnProperty('batteryDisplayMode')) {
        const mode = CONFIG.batteryDisplayMode;
        if(typeof mode === 'string') {
            if(BATTERYDISPLAYMODE.hasOwnProperty(CONFIG.batteryDisplayMode)) {
                batteryDisplay = BATTERYDISPLAYMODE[CONFIG.batteryDisplayMode];
            }
        } else if(typeof mode === 'object' && mode.hasOwnProperty('scale')) {
            batteryDisplay = mode;
        }
    }

    return `<svg xmlns="http://www.w3.org/2000/svg" width="144" height="144" viewBox="0 0 144 144">
    <defs>
        <radialGradient id="radialGradient-1" cx="77.367%" cy="25.045%" r="62.254%" fx="77.367%" fy="25.045%" gradientTransform="matrix(-.47069 .54754 -.30799 -.83678 1.215 .036)">
            <stop offset="0%" stop-color="#FFF"/>
            <stop offset="100%" stop-color="#2B2B2B"/>
        </radialGradient>
        <filter id="shadow" width="116%" height="122.2%" x="-8%" y="-8.9%" filterUnits="objectBoundingBox">
                <feOffset dy="2" in="SourceAlpha" result="shadowOffsetOuter1"/>
                <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="1"/>
                <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 1 0"/>
            </filter>
    </defs>
    <g id="KeyLightIcon" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
        <rect id="background" width="144" height="144" x="0" y="0" fill="${options.backgroundColor}" fill-rule="nonzero" rx="24"/>
        ${batteryStatusSVG(options, device, batteryDisplay)}
    </g>
</svg>`;
};

const getStopColor = (options, showOverlayGradient) => {
    return showOverlayGradient ? Utils.lerpColor(options.stopColor, options.blendColor || '#CCCCCC', CONFIG.gradientBlendAmount || .6) : options.stopColor;
};

function icon_multipleDevices(options, device, ctx) {
    const showOverlayGradient = CONFIG.showOverlayGradient || false;
    const tmpStopColor = getStopColor(options, showOverlayGradient);
    const body = `
    <rect id="shbody" width="100" height="63" x="0" y="0" fill="#000" filter="url(#shadow)" opacity=".5" fill-rule="nonzero" rx="8"/>
    <path id="body" fill="url(#radialGradient-1)" stroke="#000" stroke-opacity=".5" d="M6,0 L94,0 C97.313708,0 100,2.6862915 100,6 L100,57 C100,60.313708 97.313708,63 94,63 L6,63 C2.6862915,63 0,60.313708 0,57 L0,6 C0,2.6862915 2.6862915,0 6,0 Z"/>    
    <path id="content" fill="${options.startColor}" d="M8,4 L92,4 C94.209139,4 96,5.790861 96,8 L96,55 C96,57.209139 94.209139,59 92,59 L8,59 C5.790861,59 4,57.209139 4,55 L4,8 C4,5.790861 5.790861,4 8,4 Z"/>
    <path id="overlay" fill="url(#linearGradient-2)" d="M9,5 L91,5 C93.209139,5 95,6.790861 95,9 L95,54 C95,56.209139 93.209139,58 91,58 L9,58 C6.790861,58 5,56.209139 5,54 L5,9 C5,6.790861 6.790861,5 9,5 Z" opacity=".5"/>`;

    return `<svg xmlns="http://www.w3.org/2000/svg" width="144" height="144" viewBox="0 0 144 144">
    <defs>
        <radialGradient id="radialGradient-1" cx="77.367%" cy="25.045%" r="57.665%" fx="77.367%" fy="25.045%" gradientTransform="matrix(-.50815 .59111 -.3724 -.80659 1.26 -.005)">
            <stop offset="0%" stop-color="#FFF"/>
            <stop offset="100%" stop-color="#2B2B2B"/>
        </radialGradient>
        <linearGradient id="linearGradient-2" x1="14.22%" x2="58.991%" y1="73.651%" y2="29.575%">
        <stop offset="0%" stop-color="${options.startColor}"/>
        <stop offset="100%" stop-color="${tmpStopColor}"/>
        </linearGradient>
        <filter id="shadow" width="116%" height="122.2%" x="-8%" y="-8.9%" filterUnits="objectBoundingBox">
                <feOffset dy="2" in="SourceAlpha" result="shadowOffsetOuter1"/>
                <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="3"/>
                <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 1 0"/>
            </filter>
    </defs>
    <g id="keylights_all" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
        <rect id="background" width="144" height="144" x="0" y="0" fill="${options.backgroundColor}" fill-rule="nonzero" rx="24"/>
        <g id="all" fill-rule="nonzero" transform="translate(10 31)">
            <g transform="translate(24 2)" opacity="0.6">${body}</g>
            <g transform="translate(14 10)" opacity="0.8">${body}</g>
            <g transform="translate(2 20)">${body}</g>
        </g>
        <g id="icon_onoff" transform="translate(-12 10)">
        ${options.textOrIcon}
        </g>
    </g>
</svg>`;
}

function icon_keyLightMini(options, device) {
    const showOverlayGradient = CONFIG.showOverlayGradient || false;
    const tmpStopColor = getStopColor(options, showOverlayGradient);
    const showMiniBattery = device && device.hasOwnProperty('battery') && CONFIG.showMiniBattery;
    return `<svg xmlns="http://www.w3.org/2000/svg" width="144" height="144" viewBox="0 0 144 144">
    <defs>
        <filter id="shadow" width="116%" height="122.2%" x="-8%" y="-8.9%" filterUnits="objectBoundingBox">
                <feOffset dy="2" in="SourceAlpha" result="shadowOffsetOuter1"/>
                <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="3"/>
                <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 1 0"/>
            </filter>
        <radialGradient id="radialGradient-1" cx="77.367%" cy="25.045%" r="57.665%" fx="77.367%" fy="25.045%" gradientTransform="matrix(-.50815 .59111 -.3724 -.80659 1.26 -.005)">
            <stop offset="0%" stop-color="#CCC"/>
            <stop offset="100%" stop-color="#2B2B2B"/>
        </radialGradient>
        <linearGradient id="linearGradient-2" x1="13.785%" x2="58.991%" y1="74.079%" y2="29.575%">
        <stop offset="0%" stop-color="${options.startColor}"/>
        <stop offset="100%" stop-color="${tmpStopColor}"/>
        </linearGradient>
    </defs>
        <rect id="background" width="144" height="144" x="0" y="0" fill="${options.backgroundColor}" rx="24"/>
        <path id="bg" fill="#000" filter="url(#shadow)" d="M28,41 L116,41 C119.313708,41 122,43.6862915 122,47 L122,98 C122,101.313708 119.313708,104 116,104 L28,104 C24.6862915,104 22,101.313708 22,98 L22,47 C22,43.6862915 24.6862915,41 28,41 Z" opacity=".5"/>
        <path id="body" fill="url(#radialGradient-1)" stroke="#000" stroke-opacity=".4" d="M28,41 L116,41 C119.313708,41 122,43.6862915 122,47 L122,98 C122,101.313708 119.313708,104 116,104 L28,104 C24.6862915,104 22,101.313708 22,98 L22,47 C22,43.6862915 24.6862915,41 28,41 Z"/>
        <path id="content" fill="${options.startColor}" d="M30,45 L114,45 C116.209139,45 118,46.790861 118,49 L118,96 C118,98.209139 116.209139,100 114,100 L30,100 C27.790861,100 26,98.209139 26,96 L26,49 C26,46.790861 27.790861,45 30,45 Z"/>
        ${showOverlayGradient ? '<path opacity=".6" id="overlay" fill="url(#linearGradient-2)" d="M31,46 L113,46 C115.209139,46 117,47.790861 117,50 L117,95 C117,97.209139 115.209139,99 113,99 L31,99 C28.790861,99 27,97.209139 27,95 L27,50 C27,47.790861 28.790861,46 31,46 Z"/>' : ''}
        ${options.textOrIcon}
        ${showMiniBattery ? batteryStatusSVG(options, device, BATTERYDISPLAYMODE.off, true) : ''}
</svg>`;
}

function icon_keyLightAir(options, device) {
    const showOverlayGradient = CONFIG.showOverlayGradient || false;
    const tmpStopColor = getStopColor(options, showOverlayGradient);
    return `<svg xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink" width="144" height="144" viewBox="0 0 144 144">
    <defs>
        <radialGradient id="radialGradient-1" cx="77.367%" cy="25.045%" r="117.339%" fx="77.367%" fy="25.045%" gradientTransform="scale(-1 -.3) rotate(-75.539 -.7 .706)">
            <stop offset="0%"/>
            <stop offset="100%" stop-color="#2B2B2B"/>
        </radialGradient>
        <radialGradient id="radialGradient-2" cx="77.367%" cy="25.045%" r="45.872%" fx="77.367%" fy="25.045%" gradientTransform="matrix(-.63879 .74307 -.7093 -.6692 1.446 -.157)">
            <stop offset="0%" stop-color="#FFF"/>
            <stop offset="100%" stop-color="#2B2B2B"/>
        </radialGradient>
        <path id="path-3" d="M57,30 L87,30 C103.016258,30 116,42.9837423 116,59 L116,85 C116,101.016258 103.016258,114 87,114 L57,114 C40.9837423,114 28,101.016258 28,85 L28,59 C28,42.9837423 40.9837423,30 57,30 Z"/>
        <filter id="filter-4" width="117%" height="117.9%" x="-8.5%" y="-6.5%" filterUnits="objectBoundingBox">
            <feMorphology in="SourceAlpha" operator="dilate" radius=".5" result="shadowSpreadOuter1"/>
            <feOffset dy="2" in="shadowSpreadOuter1" result="shadowOffsetOuter1"/>
            <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="2"/>
            <feComposite in="shadowBlurOuter1" in2="SourceAlpha" operator="out" result="shadowBlurOuter1"/>
            <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 0.5 0"/>
        </filter>
        <linearGradient id="linearGradient-5" x1="13.785%" x2="58.991%" y1="112.319%" y2="-2.862%">
        <stop offset="0%" stop-color="${options.startColor}"/>
        <stop offset="100%" stop-color="${tmpStopColor}"/>
        </linearGradient>
    </defs>
    <g id="KeyLight-Air" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
        <rect id="background" width="144" height="144" fill="${options.backgroundColor}" rx="24"/>
        <polygon id="inner" fill="url(#radialGradient-1)" fill-rule="nonzero" points="66 104 78 104 78 144 66 144"/>
        <g id="body" fill-rule="nonzero">
            <use xlink:href="#path-3" fill="#000" filter="url(#filter-4)"/>
            <use xlink:href="#path-3" fill="url(#radialGradient-2)" stroke="#000" stroke-opacity=".391"/>
        </g>
        <path id="content" fill="${options.startColor}" fill-rule="nonzero" d="M58,35 L86,35 C99.8071187,35 111,46.1928813 111,60 L111,84 C111,97.8071187 99.8071187,109 86,109 L58,109 C44.1928813,109 33,97.8071187 33,84 L33,60 C33,46.1928813 44.1928813,35 58,35 Z"/>
        ${showOverlayGradient ? '<path id="overlay" fill="url(#linearGradient-5)" fill-rule="nonzero" d="M58,36 L86,36 C99.254834,36 110,46.745166 110,60 L110,84 C110,97.254834 99.254834,108 86,108 L58,108 C44.745166,108 34,97.254834 34,84 L34,60 C34,46.745166 44.745166,36 58,36 Z"/>' : ''} 
    </g>
    ${options.textOrIcon}
</svg>`;
}

function icon_ringLight(options, device) { //andy
    const showOverlayGradient = CONFIG.showOverlayGradient || false;
    const tmpStopColor = getStopColor(options, showOverlayGradient);
    return `
    <svg xmlns="http://www.w3.org/2000/svg" width="144" height="144" viewBox="0 0 144 144">
    <defs>
        <filter id="shadow" width="117%" height="117.9%" x="-8.5%" y="-6.5%" filterUnits="objectBoundingBox">
        <feOffset dy="2" in="shadowSpreadOuter1" result="shadowOffsetOuter1"/>
        <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="3"/>
        <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 0.4 0"/>
    </filter>
        <radialGradient id="radialGradient-1" cx="77.367%" cy="25.045%" r="122.065%" fx="77.367%" fy="25.045%" gradientTransform="scale(-.25 -1) rotate(-16.215 -2.919 13.577)">
            <stop offset="0%"/>
            <stop offset="100%" stop-color="#2B2B2B"/>
        </radialGradient>
        <radialGradient id="radialGradient-2" cx="77.367%" cy="25.045%" r="44.95%" fx="77.367%" fy="25.045%">
            <stop offset="0%"/>
            <stop offset="100%" stop-color="#0000FF"/>
        </radialGradient>
        <linearGradient id="linearGradient-3" x1="20.297%" x2="75.825%" y1="96.784%" y2="13.238%">
        <stop offset="0%"/>
        <stop offset="100%" stop-color="${tmpStopColor}"/>
    </linearGradient>
    </defs>
    <g id="RingLight" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
    <rect id="background" width="144" height="144" fill="${options.backgroundColor}" rx="24"/>
        <path id="bodybg" fill="#000000" opacity=".6" fill-rule="nonzero" d="M72,8 C107.346224,8 136,36.653776 136,72 C136,107.346224 107.346224,136 72,136 C36.653776,136 8,107.346224 8,72 C8,36.653776 36.653776,8 72,8 Z M72,26 C46.5949015,26 26,46.5949015 26,72 C26,97.4050985 46.5949015,118 72,118 C97.4050985,118 118,97.4050985 118,72 C118,46.5949015 97.4050985,26 72,26 Z"/>
        <polygon id="inner" fill="url(#radialGradient-1)" fill-rule="nonzero" points="58 104 86 104 106 121 38 121"/>
        <path id="body" fill="url(#radialGradient-2)" filter="url(#shadow)"  opacity="1" fill-rule="nonzero" d="M72,8 C107.346224,8 136,36.653776 136,72 C136,107.346224 107.346224,136 72,136 C36.653776,136 8,107.346224 8,72 C8,36.653776 36.653776,8 72,8 Z M72,26 C46.5949015,26 26,46.5949015 26,72 C26,97.4050985 46.5949015,118 72,118 C97.4050985,118 118,97.4050985 118,72 C118,46.5949015 97.4050985,26 72,26 Z"/>
        <path id="light" fill="${options.startColor}" fill-rule="nonzero" d="M72,10 C106.241654,10 134,37.7583455 134,72 C134,106.241654 106.241654,134 72,134 C37.7583455,134 10,106.241654 10,72 C10,37.7583455 37.7583455,10 72,10 Z M72,23 C44.9380473,23 23,44.9380473 23,72 C23,99.0619527 44.9380473,121 72,121 C99.0619527,121 121,99.0619527 121,72 C121,44.9380473 99.0619527,23 72,23 Z"/>
        ${showOverlayGradient ? '<path id="overlay" opacity=".35" fill="url(#linearGradient-3)" fill-rule="nonzero" d="M72,10 C106.241654,10 134,37.7583455 134,72 C134,106.241654 106.241654,134 72,134 C37.7583455,134 10,106.241654 10,72 C10,37.7583455 37.7583455,10 72,10 Z M72,23 C44.9380473,23 23,44.9380473 23,72 C23,99.0619527 44.9380473,121 72,121 C99.0619527,121 121,99.0619527 121,72 C121,44.9380473 99.0619527,23 72,23 Z" />' : ''}
        ${options.textOrIcon}
    </g>
</svg>`;
    /* <text id="45" fill="#FFFFFF" font-family="Arial-BoldMT, Arial" font-size="20" font-weight="bold"><tspan x="50%" y="40" text-anchor="middle">${device?.lights?.brightness || 'XX'}</tspan></text>
    ${console.log(options, device)} */
}

ControlCenterKey.prototype.createKeyLightSVG = (options, device, me) => {
    const showOverlayGradient = CONFIG.showOverlayGradient || false;
    const tmpColor = Utils.lerpColor(options.startColor, '#FFFFFF', CONFIG.gradientBlendAmount || .6);

    if(device) {
        if(device.type == DEVICETYPES.KEYLIGHTMINI) {
            return icon_keyLightMini(options, device);
        } else if(device.type == DEVICETYPES.KEYLIGHTAIR) {
            return icon_keyLightAir(options, device);
        } else if(device.type == DEVICETYPES.RINGLIGHT) {
            return icon_ringLight(options, device);
        }
    }

    return `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="144" height="144" viewBox="0 0 144 144">
      <defs>
       <path id="body" d="M117.486933,5.98157119 C112.289454,1.30432599 104.70647,0.814208152 98.0772687,0.511053371 C90.5804199,0.168815917 83.0762183,0.0906505727 75.5741174,0.0378361509 C68.0699157,-0.014978271 60.5667645,-0.0192034247 53.0625628,0.0684685156 C45.7526888,0.154027879 38.4270586,0.139239841 31.1213863,0.415987411 C27.460672,0.554361197 23.7989073,0.814208152 20.1718065,1.35080268 C17.0667645,1.81028815 13.915504,2.41871029 11.0510082,3.75597145 C5.18441153,6.49703994 1.97852918,12.5009834 0.719075395,18.6454133 C-0.00676494085,22.1850358 -0.0550842686,25.7595159 0.0321006054,29.3572343 C0.12243674,33.0827636 0.158151026,36.8093492 0.200167832,40.5359348 C0.285251866,47.9827683 0.226428336,55.4454461 0.448066992,62.8891107 C0.62138632,68.7219355 1.37243674,74.6360944 4.48273086,79.6988849 C7.73378128,84.9919463 12.9354619,87.5787967 18.9176048,88.5262874 C26.0678149,89.6586286 33.4491174,89.6227148 40.6697056,89.7568634 C44.7684451,89.8329162 48.8661342,89.8339725 52.9648737,89.861436 C59.1697056,89.9015749 65.3776888,90.0072038 71.5814704,89.9322073 C78.9942855,89.8434791 86.4113023,89.8160156 93.823067,89.6375028 C100.477479,89.476947 107.976428,89.3987816 113.98168,86.1253438 C118.692815,83.5564503 121.667605,78.8052649 123.179159,73.751981 C125.076218,67.4047438 124.591975,60.6951997 124.667605,54.1546617 C124.753739,46.6845898 124.872437,39.214518 124.923907,31.7444462 C124.972227,24.8067437 125.045756,17.0683746 121.375588,10.9081005 C120.335672,9.16099938 119.006891,7.34840842 117.486933,5.98157119 Z"/>
      <filter id="shadow" width="116%" height="122.2%" x="-8%" y="-8.9%" filterUnits="objectBoundingBox">
        <feOffset dy="2" in="SourceAlpha" result="shadowOffsetOuter1"/>
        <feGaussianBlur in="shadowOffsetOuter1" result="shadowBlurOuter1" stdDeviation="3"/>
        <feColorMatrix in="shadowBlurOuter1" values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 1 0"/>
      </filter>
    
      <radialGradient id="b_2g-c" cx="77.381%" cy="25.022%" r="53.085%" fx="77.381%" fy="25.022%" gradientTransform="matrix(-.55199 .64211 -.26856 -.4453 1.268 -.135)"><stop offset="0%" stop-color="#FFF"/><stop offset="100%" stop-color="#2B2B2B"/></radialGradient>
      <linearGradient id="b_2g-d" x1="6.252%" x2="96.06%" y1="73.869%" y2="29.756%"><stop offset="0%" stop-color="#141414"/><stop offset="100%" stop-color="#121212"/></linearGradient>
      <linearGradient id="b_2g-e" x1="50%" x2="95.003%" y1="100%" y2="0%">
        <stop offset="0%" stop-color="${options.startColor}"/>
        <stop offset="100%" stop-color="${showOverlayGradient ? tmpColor : options.startColor}"/>
      </linearGradient>
      </defs>
      <g fill="none" fill-rule="evenodd">
        <rect id="background" width="144" height="144" fill="${options.backgroundColor}" rx="24"/>
           <g fill-rule="nonzero" transform="translate(10.021 27.012)"><use fill="#000" filter="url(#shadow)" xlink:href="#body"/></g>
          <path fill="url(#b_2g-c)" fill-rule="nonzero" stroke="#000" stroke-opacity=".391" d="M117.152602,6.35335505 L117.152469,6.35323554 C112.943177,2.56526621 107.952326,1.46316435 98.054467,1.01053318 C91.6605601,0.718645953 85.7011549,0.609142388 75.5705985,0.537823768 C67.3856386,0.480218183 60.0681368,0.486656188 53.0684147,0.568434269 C51.5075506,0.586703605 50.25701,0.598038476 47.4487526,0.621018589 C45.4156146,0.63765586 44.5146517,0.645440957 43.3866043,0.656740562 C38.4218215,0.706472593 34.7451628,0.779073057 31.1402727,0.91563059 C27.0465842,1.07037066 23.5532174,1.35599758 20.2449996,1.84541643 C16.3363372,2.42382199 13.6995612,3.0713225 11.2626616,4.20896463 C6.04821339,6.64532776 2.59760448,11.9707736 1.20888318,18.745854 C0.582771124,21.799143 0.42389461,24.8860135 0.53195368,29.3451139 C0.599517515,32.1314967 0.631581494,34.3602617 0.687232228,39.3738598 C0.693650746,39.9521073 0.693650746,39.9521073 0.7001352,40.5302224 C0.724196976,42.6361879 0.735165875,44.3219375 0.753622912,48.1134704 C0.759908477,49.4046814 0.762806123,49.9776332 0.766839107,50.6944419 C0.795891277,55.8580742 0.842816439,59.3468618 0.9478464,62.8742601 C1.15941899,69.9944461 2.22965795,75.0762452 4.90878327,79.4371993 C7.86811754,84.2553153 12.6321302,87.0245203 18.9958126,88.0324417 C22.7565847,88.6280155 26.7202535,88.9338986 31.7453118,89.0854886 C33.4585822,89.1371725 34.8158563,89.1631587 37.9178792,89.2112761 C39.2825563,89.2324445 39.911578,89.2426922 40.6789816,89.2569495 C42.5176316,89.2910659 44.4220301,89.3119262 46.8205114,89.3273811 C47.63844,89.3326515 48.293038,89.3361721 49.7654216,89.3435681 C51.3668348,89.3516123 52.0783924,89.3554849 52.9681081,89.3614464 C54.3445671,89.3703507 55.4452025,89.379788 57.9232557,89.4027739 C59.4350343,89.4167969 60.1076572,89.4228598 60.9477865,89.4297729 C65.3206877,89.4657558 68.4628777,89.4698709 71.575486,89.4322431 C73.3586503,89.4108994 74.7859734,89.3963699 77.9945655,89.3656232 C79.7291829,89.349001 80.4987992,89.3414924 81.461745,89.3315951 C86.5496818,89.2793005 90.1956541,89.2247243 93.8110066,89.1376483 C94.0623482,89.1316165 94.0623482,89.1316165 94.3146138,89.1256393 C97.8075674,89.0429586 99.2923112,88.9888924 101.215987,88.8427733 C106.390107,88.4497559 110.378192,87.5201324 113.742313,85.686364 C117.997856,83.3658962 121.077508,79.0332898 122.700099,73.6087996 C123.803647,69.9165138 124.155867,66.1760821 124.17072,60.4290379 C124.17253,59.7286266 124.170915,59.166564 124.164995,57.9068329 C124.156145,56.0234841 124.155599,55.1900093 124.167638,54.1488967 C124.191064,52.1172454 124.211538,50.4920191 124.258903,46.8353785 C124.28411,44.8892954 124.295226,44.0243844 124.308794,42.9432794 C124.365467,38.4275453 124.401123,35.0494693 124.423919,31.7409639 C124.424405,31.6713295 124.424405,31.6713295 124.424891,31.6016322 C124.448975,28.1504703 124.436853,26.5488552 124.338175,24.5826108 C124.058102,19.0018815 123.074912,14.7372593 120.945939,11.1638378 C119.805938,9.24859044 118.50827,7.57245227 117.152602,6.35335505 Z" transform="translate(10.021 27.012)"/>
          <path fill="url(#b_2g-d)" d="M130.579343,64.304132 C130.535565,70.459794 130.493977,76.6165567 130.427217,82.7711181 C130.36374,88.7209678 130.800418,95.0681344 129.012118,100.817675 C128.188011,103.465721 126.861561,105.906854 124.820448,107.806492 C122.726802,109.755656 120.033408,110.611924 117.283104,111.121502 C111.490282,112.194588 105.521257,112.25292 99.6507304,112.393797 C87.7247188,112.681054 75.8162181,112.543479 63.8945843,112.65464 C57.8193993,112.71077 51.687304,112.530272 45.6154024,112.315655 C39.6945322,112.10654 33.7894,112.127574 27.9162687,111.222758 C19.7941176,109.971457 13.5332602,106.327262 13.5332602,84.3042555 C13.5332602,62.2812493 13.3756622,72.1183999 13.2815411,66.0265727 C13.2344806,62.9415878 13.2005533,72.4945996 13.2005533,56.7716179 C13.2005533,41.0486362 17.9558824,33.7074316 29.9934982,32.8093304 C42.0311141,31.9112292 35.6954823,32.3041545 38.5563242,32.1995974 C50.7614156,31.7549545 62.9785458,31.5766571 75.1923926,31.5447397 C81.3201102,31.5282307 87.4467334,31.5898644 93.574451,31.6636046 C99.664958,31.7362443 105.866002,31.7318419 111.930243,32.3250659 C117.553428,32.8753665 123.483054,33.5016085 127.041048,38.4598165 C130.46005,43.2243188 130.619836,49.3700754 130.61327,55.0084549 C130.609987,58.1066471 130.600137,61.2048392 130.579343,64.304132 Z"/>
          <path fill="url(#b_2g-e)" d="M128.878953,64.6126736 C128.836858,70.5285 128.796868,76.4453842 128.732673,82.3601528 C128.671635,88.0781857 129.091533,94.1780553 127.37195,99.7035831 C126.579511,102.248457 125.304031,104.594479 123.341349,106.420103 C121.328154,108.293325 118.738256,109.116231 116.093634,109.605955 C110.523407,110.637232 104.783746,110.693291 99.1388002,110.828679 C87.6710561,111.104744 76.2201501,110.972529 64.7566155,111.079359 C58.9148749,111.133302 53.0184107,110.959836 47.1798272,110.753581 C41.4864717,110.552614 35.8110065,110.564249 30.1607984,109.703265 C27.5887908,109.310851 24.9715311,108.712182 22.7994265,107.204931 C20.6399504,105.7072 19.0824335,103.459546 18.138452,101.021502 C16.0315948,95.5837648 16.4451786,89.5537047 16.3304696,83.8335564 C16.2126035,77.9790778 16.1789274,72.1224837 16.0884231,66.268005 C16.0431709,63.3032166 16.046328,60.3384282 16.0105472,57.3736398 C15.9758188,54.5273161 15.9284619,51.6757037 16.297846,48.8473612 C16.9629477,43.7565561 19.1108477,38.4277642 24.0412305,36.1779943 C26.5743001,35.0219067 29.4209779,34.6643974 32.1582085,34.3449661 C34.8943868,34.0265924 37.6410888,33.8594727 40.3920004,33.7589893 C52.1281004,33.3316706 63.8757766,33.16032 75.6202956,33.1296461 C81.5125503,33.1137803 87.4037526,33.1730126 93.2960072,33.2438798 C99.1524811,33.3136893 105.115245,33.3094584 110.946462,33.8795694 C116.353571,34.4084292 122.055346,35.0102718 125.476621,39.7752991 C128.764244,44.3541678 128.917891,50.2604747 128.911577,55.6791729 C128.90842,58.6566539 128.898948,61.6341349 128.878953,64.6126736 Z"/>
        ${options.textOrIcon}
      </g>
    </svg>`;
};

// const batteryLevels = {
//     'charging': [
//         [95, '<path fill="#24D40E" d="M5.268,0 L0,0 L0,10 L6.76,10 L7.16,8 L4,8 C3.28,8 2.614,7.612 2.26,6.986 C1.904,6.358 1.914,5.588 2.286,4.972 L5.268,0 Z M13.24,0 L12.84,2 L16,2 C16.72,2 17.386,2.388 17.74,3.014 C18.096,3.642 18.086,4.412 17.714,5.028 L14.732,10 L20,10 L20,0 L13.24,0 Z"/>'],
//         [80, '<path fill="#D8D8D8" d="M5.268,0 L0,0 L0,10 L6.76,10 L7.16,8 L4,8 C3.28,8 2.614,7.612 2.26,6.986 C1.904,6.358 1.914,5.588 2.286,4.972 L5.268,0 Z M13.24,0 L12.84,2 L16,2 C16.72,2 17.386,2.388 17.74,3.014 C18.096,3.642 18.086,4.412 17.714,5.028 L14.732,10 L20,10 L20,0 L13.24,0 Z"/>'],
//         [60, '<path fill="#D8D8D8" d="M5.268,0 L0,0 L0,10 L6.76,10 L7.16,8 L4,8 C3.28,8 2.614,7.612 2.26,6.986 C1.904,6.358 1.914,5.588 2.286,4.972 L4.268,0 Z M16,10 L14.732,10 L16,7.888 L16,10 Z M16,2 L12.84,2 L13.24,0 L16,0 L16,2 Z"/>'],
//         [-40, '<path fill="#D8D8D8" d="M5.268,0 L0,0 L0,10 L6.76,10 L7.16,8 L4,8 C3.28,8 2.614,7.612 2.26,6.986 C1.904,6.358 1.914,5.588 2.286,4.972 L5.268,0 Z"/>'],
//         [20, '<path fill="#D8D8D8" d="M5.268,0 L0,0 L0,10 L6.76,10 L7.16,8 L4,8 C3.28,8 2.614,7.612 2.26,6.986 C1.904,6.358 1.914,5.588 2.286,4.972 L5.268,0 Z"/>'],
//         [0, '<path fill="#F20D0D" d="M4,2.112 L4,0 L0,0 L0,10 L4,10 L4,8 C3.28,8 2.614,7.612 2.26,6.986 C1.904,6.358 1.914,5.588 2.286,4.972 L4,2.112 Z"/>'],

//     ],
//     'notcharging': [
//         [80, '<rect width="20" height="10" x="0" y="0" fill="#D8D8D8"/>'],
//         [60, '<rect width="16" height="10" x="0" y="0" fill="#D8D8D8"/>'],
//         [40, '<rect width="12" height="10" x="0" y="0" fill="#D8D8D8"/>'],
//         [20, '<rect width="8" height="10" x="0" y="0" fill="#D8D8D8"/>'],
//         [0, '<rect width="4" height="10" x="0" y="0" fill="#F20D0D"/>']
//     ]
// };

const batteryStatusSVG = (options = {}, device, inScales = null, mini = false) => {
    let scales = !inScales || !inScales.hasOwnProperty('scale') ? BATTERYDISPLAYMODE.off : inScales;
    let miniIconColor = '#D8D8D8';
    const loadingIndicatorMaxFillWidth = 24;

    if(options.hasOwnProperty('backgroundColor')) {
        const bri = Utils.getBrightness(options.backgroundColor);
        miniIconColor = bri > 128 ? '#333' : '#D8D8D8';
    }

    const batteryBodyPath = `<path id="notConnectedToPowerSupply" fill="${miniIconColor}" d="M124,14 C124,12.896 123.104,12 122,12 L98,12 C96.896,12 96,12.896 96,14 L96,28 C96,29.104 96.896,30 98,30 L122,30 C123.104,30 124,29.104 124,28 L124,14 Z M122,14 L98,14 L98,28 L122,28 L122,14 Z M126,18 L126,24 C127.104,24 128,23.104 128,22 L128,20 C128,18.896 127.104,18 126,18 Z"/>`;
    if(!device || !device.battery) return `<g transform="translate(${scales.transform.x} ${scales.transform.y}) scale (${scales.scale})">${batteryBodyPath}</g>`;

    let deviceBatteryLevel = 20; //device.battery.level;
    let lvl = Math.round(device.battery.level / 5) * 5;  // (battery.level).toFixed(2)

    if(device.battery.bypassMode) {
        return mini ?
            `<path id="bypassMode" fill="${miniIconColor}" d="M99.875,19.042 L96,19.042 L96,22.958 L99.875,22.958 L99.875,24 C99.875,26.208 101.611,28 103.75,28 L118,28 L118,14 L103.75,14 C101.611,14 99.875,15.792 99.875,18 L99.875,19.042 Z M128,16 L120,16 L120,26 L128,26 L128,16 Z M109.347437,21.312 L116,22.556 L116,21 L107.840063,16.334 L107.840063,20.688 L102,19.444 L102,21 L109.347438,25.666 L109.347437,21.312 Z M124,22 L122,22 L122,24 L124,24 L124,22 Z M124,18 L122,18 L122,20 L124,20 L124,18 Z"/>`
            : `<g transform="translate(${scales.transform.x} ${scales.transform.y}) scale (${scales.scale})"><path id="bypassMode" fill="#D8D8D8" d="M99.875,19.042 L96,19.042 L96,22.958 L99.875,22.958 L99.875,24 C99.875,26.208 101.611,28 103.75,28 L118,28 L118,14 L103.75,14 C101.611,14 99.875,15.792 99.875,18 L99.875,19.042 Z M128,16 L120,16 L120,26 L128,26 L128,16 Z M109.347437,21.312 L116,22.556 L116,21 L107.840063,16.334 L107.840063,20.688 L102,19.444 L102,21 L109.347438,25.666 L109.347437,21.312 Z M124,22 L122,22 L122,24 L124,24 L124,22 Z M124,18 L122,18 L122,20 L124,20 L124,18 Z"/></g>`;
    }

    const showBatteryLevelLabel = options.showBatteryLevelLabel === true;
    let ovrly = showBatteryLevelLabel ?
        `<text id="45" fill="#FFFFFF" font-family="Arial-BoldMT, Arial" font-size="20" font-weight="bold"><tspan x="50%" y="40" text-anchor="middle">${lvl}%</tspan></text>`
        : '';

    // const orig = `<g transform="translate(${scales.transform.x} ${scales.transform.y}) scale (${scales.scale})"><path id="connectedToPowerSupply" fill="${miniIconColor}" d="M107.668,12 L106.468,14 L98,14 L98,28 L106.36,28 L106.038,29.608 C106.012,29.738 106,29.87 106,30 L106,30 L98,30 C96.896,30 96,29.104 96,28 L96,28 L96,14 C96,12.896 96.896,12 98,12 L98,12 L107.668,12 Z M122,12 C123.104,12 124,12.896 124,14 L124,14 L124,28 C124,29.104 123.104,30 122,30 L122,30 L112.332,30 L113.532,28 L122,28 L122,14 L113.64,14 L113.962,12.392 C113.988,12.262 114,12.13 114,12 L114,12 Z M112,12 L110.4,20 L116,20 L110,30 L108,30 L109.6,22 L104,22 L110,12 L112,12 Z M126,18 C127.104,18 128,18.896 128,20 L128,20 L128,22 C128,23.104 127.104,24 126,24 L126,24 Z"/>`;
    const batteryBody = `<path id="battery" fill="${miniIconColor}" fill-rule="nonzero" d="M122,12 C123.104,12 124,12.896 124,14 L124,14 L124,28 C124,29.104 123.104,30 122,30 L122,30 L98,30 C96.896,30 96,29.104 96,28 L96,28 L96,14 C96,12.896 96.896,12 98,12 L98,12 Z M123,13 L97,13 L97,29 L123,29 L123,13 Z M126,18 C127.104,18 128,18.896 128,20 L128,20 L128,22 C128,23.104 127.104,24 126,24 L126,24 Z"/>`;
    const connectedToPowerSupply = `<path id="connectedToPowerSupply" fill="#FFF" fill-rule="nonzero" stroke="#4E4E61" d="M111.732408,9.5 L113.646624,9.5 L111.046624,19.5 L116.934259,19.5 L108.267592,32.5 L106.353376,32.5 L108.953376,22.5 L103.065741,22.5 L111.732408,9.5 Z"/>`;

    if(lvl <= 20) {
        miniIconColor = '#F20D0D';
    } else if(device.battery.level > 95 && device.battery.connectedToPowerSupply === true) {
        miniIconColor = '#24D40E';
    }
    const cappedDeviceBatteryLevel = device.battery.level > 20 ? Math.min(device.battery.level + 0.001, 100) : device.battery.level;
    return `<g transform="translate(${scales.transform.x} ${scales.transform.y}) scale (${scales.scale})">
        ${batteryBody}
        <g id="charging" transform="translate(98 14)">
            <rect width="${Math.floor(Math.ceil(cappedDeviceBatteryLevel / 20) * 20 * loadingIndicatorMaxFillWidth / 100)}" height="14" x="0" y="0" fill="${miniIconColor}" />
        </g>
        ${device.battery.connectedToPowerSupply ? connectedToPowerSupply : ''}
        </g>${ovrly}`;
    // <rect width="${Math.floor(Math.ceil(lvl / 20) * 20 * 24) / 100}" height="14" x="0" y="0" fill="${lvl < 20 ? '#F20D0D' : `${device.battery.connectedToPowerSupply ? miniIconColor : '#24D40E'}`}" />
    // const originalVersion = (device.battery.connectedToPowerSupply) ?
    //     `${orig}
    //     <g id="charging" transform="translate(100 16)">
    //         ${batteryLevels.charging.find(e => e[0] < lvl)}
    //         <rect width="${Math.floor(Math.ceil(lvl / 20) * 20 * 20) / 100}" height="10" x="0" y="0" fill="${lvl < 20 ? '#F20D0D' : `${miniIconColor}`}"/>
    //     </g></g>${ovrly}`
    //     :
    //     `<g transform="translate(${scales.transform.x} ${scales.transform.y}) scale (${scales.scale})">${batteryBodyPath}
    //     <g id="notCharging" transform="translate(100 16)">
    //         <rect width="${Math.floor(Math.ceil(lvl / 20) * 20 * 20) / 100}" height="10" x="0" y="0" fill="${lvl < 20 ? '#F20D0D' : `${miniIconColor}`}"/>
    //     </g></g>${ovrly}`;
};

// eslint-disable-next-line no-unused-vars
// const logJSON = (jsn, fromWhere) => {
//     const jj = JSON.stringify(jsn);
//     fromWhere && console.log('%c%s', 'background-color:black; color:lightgreen;font-size:15px;', `---------- ${fromWhere} -----------`);
//     console.log(JSON.parse(jj));
// };

// const logJSON2 = (s, fromWhere) => {
//     if(s.hasOwnProperty('0') && s.hasOwnProperty('1')) {
//         console.log('%c%s', 'background-color:red;color:white;font-size:23px; font-weight: bold;', `**** ${fromWhere} ****`);
//         logJSON(s);
//         console.trace(s);
//     }
// };