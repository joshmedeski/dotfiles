/* global ELGEvents, simple_jsonrpc, Utils */
/* eslint no-unused-expressions: 2,
  no-undef: "error",
  curly: 0,
  no-caller: 0,
  wrap-iife: 0,
  one-var: 0,
  no-var: 0,
  vars-on-top: 0
*/

const DEVICETYPES = {
    KEYLIGHT: 53,
    LIGHTSTRIP_EVE: 54,
    LIGHTSTRIP_OLD: 57,
    LIGHTSTRIP: 70,
    KEYLIGHTAIR: 200,
    RINGLIGHT: 201,
    KEYLIGHTMINI: 202,
};

/**
 * ControlCenterClient containing all required code to establish
 * communication with ControlCenter-Software
 */
// eslint-disable-next-line no-unused-vars
var ControlCenterClient = function(settings) {
    'use strict';
    // settings.debug = true;
    var host = settings.host || '127.0.0.1', // 'localhost',
        port = settings.port || 1804,
        websocket = null,
        jrpc = null,
        events = null,
        self = this,
        clr = 'color: white; background: blue; font-size: 12px;',
        checkTimeout = 0,
        checkInterval = 0,
        debugLog = this.debugLog = Utils.setDebugOutput((settings && settings.debug) || false),
        debug = (settings && settings.debug) || false;

    this.applicationInfo = {};
    this.devices = [];
    this.events = events = ELGEvents.eventEmitter();
    // eslint-disable-next-line
    this.rpc = jrpc = new simple_jsonrpc();
    this.on = events.on;
    this.emit = events.emit;
    this.initialized = false;
    this.propertyInspectorShown = null;
    this.registeredKeys = [];
    this.registerKey = k => {
        if(this.registeredKeys.includes(k)) return;
        this.registeredKeys.push(k);
    };
    this.unregisterKey = k => {
        let l = this.registeredKeys.length;
        const idx = this.registeredKeys.indexOf(k);
        if(idx > -1) {
            this.registeredKeys.splice(idx, 1);
        }
    };

    this.logKeys = () => this.registeredKeys.map(e => console.log(e.settings));

    this.checkConnection = tryAgain => (!websocket || websocket.readyState === 3) && this.initConnection(tryAgain);
    this.isConnected = () => websocket && websocket.readyState === 1;
    this.connectionInfo = () => websocket;

    this.on('reconnect', function() {
        debugLog('RECONNECTION EVENT SENT');
        if(port < 1814) {
            // port++;
        } else {
            port = 1804;
        }
        debugLog('NEXT PORT: ' + port);
        // self.initConnection(true);
    });

    this.toggleDebugging = function(tof) {
        debug = Utils.isUndefined(tof) ? !this.debug : tof === true;
        debugLog = this.debugLog = Utils.setDebugOutput(debug);
        this.registeredKeys.map(e => e.toggleDebugging(debug));
    };

    this.test = function() {
        this.debugLog(new Date().toLocaleTimeString());
    };

    this.clearTimers = function() {
        if(checkInterval) {
            clearInterval(checkInterval);
            checkInterval = null;
        }
        if(checkTimeout) {
            clearTimeout(checkTimeout);
            checkTimeout = null;
        }
    };

    this.invalidateConnection = function() {
        if(self.propertyInspectorShown) {
            self.propertyInspectorShown.updatePI('invalidateConnection');
        }
        self.registeredKeys.map(d => d.updateKey && d.updateKey());
    };

    this.initConnection = function(tryAgain, _cb) {
        debugLog('%c%s', 'color: white; background: red; font-size: 13px;', `[ccc][ws][initConnection]ws://${host}:${port} tryAgain:${tryAgain}`, websocket);
        try {
            if(websocket) websocket == null;
            // try initializing websocket
            websocket = new WebSocket(`ws://${host}:${port}`);

            websocket.onopen = function() {
                var clr = 'background-color: red; font-size: 30px; color: white;';
                debugLog('%c%s', clr, 'websocket connected!');
                self.clearTimers();
                setTimeout(() => self.initCCRPC(), 500);
            };

            websocket.onclose = function(evt) {
                console.warn(`[cclient::websocket.onclose] WEBSOCKET CLOSED -> reason:', ${WEBSOCKETERROR(evt)}`);
                self.clearTimers();
                self.initialized = false;
                if(tryAgain === true) {
                    checkTimeout = setTimeout(() => self.checkConnection(false), 2500);
                }
                events.emit('deviceConfigurationChanged', {});
            };

            websocket.onerror = function(evt) {
                console.warn(`[ccclient] websocket.onerror:${SOCKETERRORS[websocket.readyState] || 'unknown error'}`, evt);
                self.initialized = false;
                events.emit('connectionError', {
                    connection: websocket,
                    port: port,
                    error: evt.target.readyState,
                });
                events.emit('deviceConfigurationChanged', {});
            };

            websocket.onmessage = function(evt) {
                jrpc.messageHandler(evt.data);
            };

            /** If connection couldn't be established, try again in a short while
             * this helps avoiding connection failures due to flakey network or
             * short connection drops
             * */
            // we try just once...
            if(tryAgain === true) {
                checkTimeout = setTimeout(() => this.checkConnection(false), 5000);
            }

            // if we want to try multiple times
            // checkInterval = setInterval(this.checkConnection, 5000);

            this.initialized = true;
            if(_cb) _cb();
        } catch(error) {
            console.warn('Websocket Error', error);
        }
    };

    this.initCCRPC = function() {
        debugLog('%c%s', clr, 'ccwebsocket: websocket.onopen');
        jrpc.toStream = function(msg) {
            debugLog('[ccc_client::toStream] sending', msg, JSON.parse(msg));
            try {
                websocket.send(msg);
            } catch(error) {
                console.warn('[jrpc] ERROR when trying to send message to the stream. Code: ', error);
            }
        };

        jrpc.on('applicationClosing', (deviceID, lights) => {
            debugLog('[jsonrpc] applicationClosing');
            self.invalidateConnection();
        });

        jrpc.on('deviceAdded', ['deviceID', 'type', 'name', 'firmwareVersion', 'firmwareVersionBuild'], (deviceID, type, name, firmwareVersion, firmwareVersionBuild) => {
            debugLog('[jsonrpc] deviceAdded', deviceID, type, name);
            let device = self.findDeviceById(deviceID);
            if(!device) {
                device = {
                    deviceID,
                    type,
                    name,
                    firmwareVersion,
                    firmwareVersionBuild
                };
                self.devices.push(device);
            }

            Object.values(self.devices).map(device => self.getDeviceConfiguration(device));
            events.emit('deviceAdded', {deviceID, type, name, firmwareVersion, firmwareVersionBuild});
        });

        jrpc.on('deviceRenamed', ['deviceID', 'type', 'name', 'firmwareVersion', 'firmwareVersionBuild'], (deviceID, type, name, firmwareVersion, firmwareVersionBuild) => {
            debugLog('[jsonrpc] deviceRenamed', deviceID, name, type);
            self.setDeviceProperty(deviceID, 'name', name);
            events.emit('deviceRenamed', {deviceID, type, name, firmwareVersion, firmwareVersionBuild});
        });

        jrpc.on('deviceRemoved', ['deviceID', 'type', 'name', 'firmwareVersion', 'firmwareVersionBuild'], (deviceID, type, name, firmwareVersion, firmwareVersionBuild) => {
            const cachedDevice = self.findDeviceById(deviceID);
            if(cachedDevice) self.devices.splice(self.devices.indexOf(cachedDevice), 1);
            debugLog('[jsonrpc] deviceRemoved', deviceID, type, name, self.devices);
            events.emit('deviceRemoved', {deviceID, type, name, firmwareVersion, firmwareVersionBuild});
        });

        jrpc.on('deviceConfigurationChanged', ['deviceID', 'lights', 'battery', 'favoriteColors', 'favoriteScenes', 'firmwareVersion', 'firmwareVersionBuild'], (deviceID, lights, battery, favoriteColors, favoriteScenes, firmwareVersion, firmwareVersionBuild) => {
            const cachedDevice = self.setDeviceProperty(deviceID, 'lights', lights);
            debugLog('[jsonrpc] deviceConfigurationChanged', deviceID, lights, 'BATTERY', battery, 'favoriteColors', favoriteColors, 'favoriteScenes', favoriteScenes, cachedDevice);
            if(battery) self.setDeviceProperty(deviceID, 'battery', battery);
            if(favoriteScenes) self.setDeviceProperty(deviceID, 'favoriteScenes', favoriteScenes);
            if(favoriteColors) self.setDeviceProperty(deviceID, 'favoriteColors', favoriteColors);
            if(firmwareVersion) self.setDeviceProperty(deviceID, 'firmwareVersion', firmwareVersion);
            if(firmwareVersionBuild) self.setDeviceProperty(deviceID, 'firmwareVersionBuild', firmwareVersionBuild);
            events.emit('deviceConfigurationChanged', cachedDevice);
        });

        jrpc.call('getApplicationInfo').then(function(result) {
            debugLog('[jsonrpc] getApplicationInfo', result);
            self.applicationInfo = result;
            if(self.propertyInspectorShown) {
                self.propertyInspectorShown.updatePI('getApplicationInfo');
            }
            events.emit('connected', {
                connection: websocket,
                port: port,
                applicationInfo: result,
                rpcClient: jrpc,
            });
            self.getDevices();
        });
    };

    this.setDeviceProperty = function(deviceID, prop, value) {
        debugLog('[ccclient] setDeviceProperty', deviceID, prop, value);
        const cachedDevice = self.findDeviceById(deviceID);
        if(cachedDevice) cachedDevice[prop] = value;
        return cachedDevice;
    };

    this.setDeviceProperties = function(deviceID, props) {
        debugLog('[ccclient] setDeviceProperties', deviceID, props);
        const cachedDevice = self.findDeviceById(deviceID);
        if(cachedDevice) Object.entries(props).map(e => (cachedDevice[e[0]] = e[1]));
    };

    this.getDeviceNames = function() {
        return Object.values(this.devices).map(e => e.name);
    };

    this.getDeviceIds = function() {
        return Object.values(this.devices).map(e => e.deviceID);
    };

    this.findDeviceIndex = function(deviceID) {
        return this.devices.findIndex(o => o.deviceID === deviceID);
    };

    this.findDeviceById = function(deviceID) {
        return this.devices.find(o => o.deviceID === deviceID);
    };

    this.findDeviceByName = function(nme) {
        return this.devices.find(o => o.name === nme);
    };

    this.getApplicationInfo = function() {
        debugLog('[ccc] calling getApplicationInfo');
        jrpc.call('getApplicationInfo').then(function(applicationInfo) {
            debugLog('%c%s',
                'color: red; background: yellow; font-size: 11px;',
                '[jsonrpc] getApplicationInfo', applicationInfo, self);
            self.applicationInfo = applicationInfo;
            events.emit('getApplicationInfo', applicationInfo);
        });
    };

    this.updateUnassignedKeys = function(dvc) {
        if(!dvc) return;
        self.registeredKeys.map(e => {
            if(!Utils.getProp(e, 'settings.deviceID', false)) {
                debugLog('[ccc::updateUnassignedKeys]:', Utils.getProp(e, 'settings.deviceID', false), e.settings);
                const device = self.devices.find(d => e.allowedDeviceTypes.includes(d.type));
                if(device) {
                    debugLog('[ccc::updateUnassignedKeys]:FOUND DEVICE ', device, dvc);
                    Utils.setProp(e, 'settings.deviceID', device.deviceID);
                    Utils.setProp(e, 'settings.name', device.name || '');
                    e.setSettings();
                } else {
                    console.trace('[ccc::updateUnassignedKeys]:--->>> NO CORRESPONDING DEVICETYPE FOUND', e);
                }
            }
        });
    };

    this.getDevices = function() {
        jrpc.call('getDevices').then(function(data) {
            if(data) {
                self.devices = data;
                if(self.devices.length) {
                    self.updateUnassignedKeys(self.devices[0]);
                }
                debugLog('%c%s', 'color: black; background: yellow; font-size: 11px;', '[jsonrpc] getDevices', data);
                Object.values(self.devices).map(device => {
                    self.getDeviceConfiguration(device);
                });
            } else {
                self.devices = [];
            }
        });
    };

    this.getDeviceConfiguration = function(forDevice, callback) {
        jrpc.call('getDeviceConfiguration', {deviceID: forDevice['deviceID']}).then(function(data) {
            if(!data.hasOwnProperty('lights')) {
                console.warn('********** getDeviceConfiguration: data has no lights **********');
            }

            Object.entries(data).forEach(e => {
                const [key, value] = e;
                if(key === 'lights') {
                    forDevice[key] = value || {};
                } else if(value !== null) {
                    forDevice[key] = value;
                };
            });

           events.emit('deviceConfigurationChanged', forDevice);
            if(callback) callback(forDevice);
        });
    };

    this.setDeviceConfiguration = function(forDevice, prop) {
        debugLog('[jsonrpc] setDeviceConfigurationForDevice:', forDevice['deviceID'], ` property:${prop}`, forDevice['lights']);
        let device = {'deviceID': forDevice['deviceID']};

        // if just a single property is about to get updated
        // extract it from the passed device node (or return null - if something went wrong)
        let value = prop ? Utils.getProp(forDevice, prop, null) : null;

        // value could be 'false', so be sure to check against null
        if(value !== null) {
            if(typeof value === 'object') {
                for(let x in value) {
                    Utils.setProp(device, `${prop}.${x}`, value[x]);
                }
            } else {
                Utils.setProp(device, prop, value);
            }
        } else {
            // fallback
            const lights = JSON.parse(JSON.stringify(forDevice['lights'])); // deep clone of 'lights', since we're removing stuff
            const ignore = ['temperatureMax', 'temperatureMin']; // remove non-wanted constants (hacky, but ¯\_(ツ)_/¯ )
            Object.keys(lights).map(ignoredProp => (ignore.includes(ignoredProp) ? delete lights[ignoredProp] : 0));
            device['lights'] = lights;
        }
        if(device?.lights?.hasOwnProperty('hue')) {
            device.lights.hue = Math.max(device.lights.hue, 1);
        }

        debugLog('[jsonrpc] setDeviceConfiguration:send:', device);
        jrpc.call('setDeviceConfiguration', device).then(function(result) {
            // console.log(!result, '[jsonrpc] setDeviceConfiguration -> result:', result);
        });
    };
};