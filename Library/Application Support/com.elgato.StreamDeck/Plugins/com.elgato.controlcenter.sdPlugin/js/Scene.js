/* global ControlCenterKey */

const DIALMODES = {
    switchScenes: 'switchScenes',
};

var Scene = function(jsn, options, clr) {
    options.allowedDeviceTypes = [DEVICETYPES.LIGHTSTRIP];
    ControlCenterKeyLight.call(this, jsn, options, clr);
    const defaults = Object.freeze({
        fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif",
        fontSize: this.isEncoder ? 20 : 24,
        fontWeight: 'bold',
        fontColor: '#ffffff',
        backgroundColor: 'transparent'
    });
    this.initIcons();
    this.updateCounter = 0;
    this.lastSVG = '';
    this.type = 'Scene';
    this.options.property = 'lights.sceneId';
    this.favoriteProperty = 'favoriteScenes';
    // const fontDefinition = `font-family="${defaults.fontFamily}" font-size="${defaults.fontSize}" font-weight="${defaults.fontWeight}"`;
    this.fontDefinition = ''; // atm. no text is used in the svg
    this.clippedMin = 3;
    let defaultStep = 10;
    if(this.isEncoder) {
        this.values = [1, 2, 5, 10, 20, 50];
        defaultStep = 1;
    } else {
        this.values = [-100, -50, -20, -10, -5, -2, -1, 1, 2, 5, 10, 20, 50, 100];
    }
    if(!this.settings.step) this.settings['step'] = this.values.indexOf(defaultStep) || defaultStep;
    this.defaultValue = this.values[defaultStep];

    const tmpDebug = false; // && this.context === '65717b3dc833d2171be2a99f26ebd44e';
    if(tmpDebug) {
        this.dbg = console.log.bind(
            console,
            `%c [${this.type} ${this.context}]`,
            'color: #65A',
        );
        this.dbg.warn = console.warn.bind(
            console,
            `%c [${this.type} ${this.context}]`,
            'color: #f96',
        );

    } else {
        this.dbg = () => {};
        this.dbg.warn = () => {};
    }

    // this.toggleDebugging(true);
    // this.dbg = () => {};
    // this.dbg.warn = () => {};
    this.getMode();

    this.throttledUpdate = this.utils.throttle((svg) => {
        this.updateStreamDeckImageIfSVGChanged(svg);
    }, CONFIG.DIALACTIONTHROTTLE);

    this.throttledSetDeviceConfiguration = this.utils.throttle((device, prop) => {
        this.cc.setDeviceConfiguration(device, prop);
    }, CONFIG.DIALACTIONTHROTTLE * 3); // TODO: check if this helps with the flickering

    // this.throttledFeedback = this.utils.debounce(payload => {    
    //     this.sd.api.send(this.context, 'setFeedback', payload);
    // }, 3);

    let device = this.findDeviceById(this.settings['deviceID']);
    const currentProperty = this.utils.getProperty(device, this.options.property, -1);
    const currentPropertySettings = this.utils.getProperty(this.settings, this.options.property, -1);

    this.dbg('initializing', this.options.property, {currentProperty, currentPropertySettings, settings: this.settings, device});

    if(currentPropertySettings === -1 && currentProperty !== -1) {
        // console.log(`--------- saving ${currentProperty} to ${this.options.property}`);
        this.utils.setProp(this.settings, this.options.property, currentProperty);
        this.setSettings();
    }
    this.setFeedbackLayout('$B1');

    this.updateKey(device, jsn);
};

Scene.prototype = Object.create(ControlCenterKeyLight.prototype);
Scene.prototype.constructor = Scene;

Scene.prototype.getMode = function() {
    const tmpSetting = this.utils.getProperty(this.settings, DIALMODES.switchScenes, false);
    this.switchScenes = Array.isArray(tmpSetting) ? tmpSetting.includes(DIALMODES.switchScenes) : tmpSetting;
    return this.switchScenes;
};

// since we have multiple values to consider, we need to override the default
Scene.prototype.processValues = function(sdpiCollection) {
    // console.log("processValues", sdpiCollection);
    let dirty = false;
    if(sdpiCollection.key === 'changeDialMode') {
        this.dbg.warn(sdpiCollection.key, sdpiCollection.value, sdpiCollection.value.includes(DIALMODES.switchScenes));
        this.utils.setProp(this.settings, DIALMODES.switchScenes, sdpiCollection.value.includes(DIALMODES.switchScenes));
        dirty = true;
    } else if(sdpiCollection.key === 'deviceID') {
        const sameDevice = this.settings['deviceID'] == sdpiCollection.value;
        this.settings['deviceID'] = sdpiCollection.value;
        const newDevice = this.findDeviceById(sdpiCollection.value);
        if(!sameDevice) { // device changed, so we need to update the sceneId
            const newSceneId = newDevice?.favoriteScenes[0]?.id || '';
            this.utils.setProp(this.settings, 'lights.sceneId', newSceneId);
        }
        dirty = true;
    } else if(sdpiCollection.key === DIALMODES.switchScenes) {
        this.utils.setProp(this.settings, sdpiCollection.key, sdpiCollection.checked);
        dirty = true;
    } else {
        ['lights.sceneId', 'step'].forEach(key => {
            if(sdpiCollection.key == key) {
                this.utils.setProp(this.settings, sdpiCollection.key, sdpiCollection.value);
                dirty = true;
            }
        });
    }

    if(dirty) {
        this.setSettings();
        this.getMode();
    }
};

Scene.prototype.onDialAction = function(device, jsn, actionType) {
    let executeAction = true;
    if(device?.lights?.on) {
        executeAction = CONFIG.activateSceneWhenSwitchingOff;
    }
    if(executeAction) {
        this.doAction(device, jsn);
    }
};

Scene.prototype.onDialPressLong = function(jsn) {
    console.log('onDialPressLong', jsn);
    const device = this.findDeviceById(this.settings['deviceID']);
    // this.doAction(device, jsn);
    this.activateScene(device, jsn);
    this.cc.setDeviceConfiguration(device, this.options.property);
};

Scene.prototype.onTouchTapLong = function(jsn) {
    this.onDialPressLong(jsn);
};

Scene.prototype.deviceNeedsUpdate = function(inDevice) {
    let device = inDevice || this.findDeviceById(this.settings['deviceID']);
    if(!device) return false; // no device, no update needed
    if(!device.hasOwnProperty('firmwareVersionBuild')) return true; // no firmwareVersionBuild property, update needed
    if(parseInt(device.firmwareVersionBuild) < 230) { // firmwareVersionBuild < 230, update needed
        return true;
    }
    return false;
};

Scene.prototype.activateScene = function(device, jsn) {
    // const device = this.findDeviceById(this.settings['deviceID']);
    if(!device) return false;
    if(!device.lights?.on) return false;
    const favoriteProperty = this.utils.getProperty(device, this.favoriteProperty, []);
    const sceneId = this.utils.getProperty(this.settings, this.options.property, favoriteProperty[0]?.id);
    if(!sceneId) {
        this.sd.api.showAlert(jsn.context);
        return false;
    };
    this.dbg('activating scene', {device});
    this.utils.setProp(device, this.options.property, sceneId);
    // this.cc.setDeviceConfiguration(device, this.options.property);
    return true;
};


Scene.prototype.doAction = function(device, jsn) {
    if(jsn.payload && jsn.payload.isInMultiAction) return;
    this.dbg("doAction", this.settings, jsn);
    const favoriteProperty = this.utils.getProperty(device, this.favoriteProperty, []);
    const sceneId = this.utils.getProperty(this.settings, this.options.property, favoriteProperty[0]?.id);
    if(!sceneId) return this.sd.api.showAlert(jsn.context);

    if(this.switchScenes) {
        const numScenes = favoriteProperty?.length ?? 0;

        if(this.isEncoder && jsn.payload?.ticks) {
            const idx = favoriteProperty.findIndex(scene => scene.id === sceneId);
            let nextIndex = -1;
            if(jsn.payload.ticks != 0) {
                nextIndex = this.utils.cycle(idx + jsn.payload.ticks, 0, numScenes - 1);
            }
            const nextSceneId = favoriteProperty[nextIndex]?.id || -1;
            if(nextSceneId !== -1) {
                this.utils.setProp(device, this.options.property, nextSceneId);
                this.utils.setProp(this.settings, this.options.property, nextSceneId);
                this.cc.setDeviceConfiguration(device, 'lights');
                this.setSettings();
                this.updatePI('Scene', device);
            }
        } else {
            this.utils.setProp(device, this.options.property, sceneId);
        }
    } else {
        if(!this.isEncoder) {
            this.utils.setProp(device, this.options.property, sceneId);
        } else {
            const stepSize = this.values[this.settings?.step];
            const selectedItem = Number(this.settings.step);
            let v = selectedItem < this.values.length ? this.values[selectedItem] : this.defaultValue || 0;
            const ticks = jsn?.payload?.ticks || 1;
            if(this.isEncoder) {
                v *= ticks;
            }
            const value = this.utils.minmax(Number(device.lights.brightness) + v, this.clippedMin, 100);
            // console.log('doAction', device?.lights?.on, {selectedItem, stepSize, v, value}, {settings: this.settings, device, sceneId}, jsn);
            if(jsn?.payload?.ticks) { // encoder was rotated
                this.utils.setProp(device, 'lights.brightness', Math.min(100, Math.max(0, value)));
            } else if(jsn?.payload?.pressed === false) {
                if(!device?.lights?.on) {
                    this.utils.setProp(device, this.options.property, sceneId);
                }
            };
            this.cc.setDeviceConfiguration(device, 'lights');
        }
    }
    this.updateKey(device, jsn);
    // this.cc.setDeviceConfiguration(conf, 'lights');
    // this.updateKey(device);
    // return true; // setDeviceConfiguration called
};

Scene.prototype.updateKey = function(deviceP, jsn) {
    this.dbg('updateKey', deviceP, this.settings);
    const untitled = 'Untitled'.lox();
    let device = deviceP ? deviceP : this.findDeviceById(this.settings['deviceID']);
    const favoriteProperty = device ? device[this.favoriteProperty] || [] : [];
    // no scenes found
    let hasFavoriteProperties = favoriteProperty.length > 0;
    let scene = null;

    if(hasFavoriteProperties) {
        const sceneId = this.utils.getProperty(this.settings, this.options.property, favoriteProperty[0]?.id);
        scene = favoriteProperty.find((scene) => scene.id === sceneId);
    }

    const sceneName = scene && scene.name.length ? scene.name : untitled;
    const forceNonEncoder = true;
    const svg = this.createSceneSVG(forceNonEncoder, !device || !scene, this.isEncoder ? 1 : 0.6);
    if(!svg) return;
    const xx = this.utils.getProperty(this.settings, this.options.property, false);
    if(xx == false) {
        this.dbg.warn(`---------> Property missing ${this.context} : ${this.options.property}`);
        this.dbg({settings: this.settings, device});
    }

    if(this.isEncoder) {
        // const leftOffs = forceNonEncoder ? 0 : -50;
        const utoa = (data) => btoa(unescape(encodeURIComponent(data)));

        const isValidValue = (v) => v && v != null && !isNaN(v);
        const brightness = this.utils.minmax(Number(device?.lights?.brightness), this.clippedMin, 100);
        let opacity = device?.lights?.on ? 1 : CONFIG.DIALACTIONOFF_OPACITY;
        let bgColor = '#FFFFFF';
        if(device) {
            // console.log('updateKey', device?.deviceID, device?.lights?.sceneId, {scene, lights: device?.lights});
            // const sceneElements = scene?.sceneElements || this.getSceneElements(device);
            const sceneElements = this.getSceneElements(device);
            const colorObj = sceneElements.length ? {lights: sceneElements[0]} : device?.lights;

            // if(device.lights?.sceneId != scene?.id) return;
            
            const lights = {
                hue: Number(this.utils.getProp(colorObj, 'lights.hue', MDefaultColors.hue)),
                sat: Number(this.utils.getProp(colorObj, 'lights.saturation', 100) / 100),
                bri: Number(this.utils.getProp(colorObj, 'lights.brightness', 100) / 100)
            };
            const targetColor = hsv2hex(lights.hue, lights.sat, 1); // LEDs
            bgColor = Utils.lerpColorWithScale(MDefaultColors.black, targetColor, 1);
        }

        const payload = {
            title: sceneName,
            indicator: {
                value: isValidValue(brightness) ? brightness : 0,
                opacity,
                bar_bg_c: `0:${MDefaultColors.black},1:${bgColor}`
            },
            value: {
                value: isValidValue(brightness) ? `${brightness} %` : '--',
                opacity,
            }
        };
        if(this.redrawCache !== svg) {
            payload.icon = `data:image/svg+xml;,${svg};`;
            this.throttledUpdate(svg);
        };
        // this.dbg.warn("setFeedback", this.updateCounter, JSON.stringify(payload).length, this.context);
        this.sd.api.send(this.context, 'setFeedback', {payload});
        // this.throttledFeedback({payload});
    } else {
        // check if svg has changed and throttle updates
        if(this.redrawCache !== svg) {
            this.dbg.warn("svgChanged on KEY", this.updateCounter);
            this.throttledUpdate(svg);
        }
        this.sd.api.setTitle(this.context, sceneName);
    }
};

Scene.prototype.getSceneId = function(device) {
    let sceneId = this.utils.getProperty(this.settings, 'lights.sceneId', false);
    if(!sceneId) { // no scene set in settings, use first scene in device - if any
        sceneId = device ? this.utils.getProperty(device, 'lights.sceneId', false) : false;
        if(!sceneId) { // device had no scene set, use first scene in favoriteProperty - if any
            const favoritePropertyArray = this.utils.getProperty(device, this.favoriteProperty, []);  // try to get all favoriteScenes
            sceneId = favoritePropertyArray[0]?.id ?? false;
        }
    }
    return sceneId;
};

Scene.prototype.getPIData = function() {
    let device = this.findDeviceById(this.settings['deviceID']);
    this.debugLog('getPIData', this.context, device);
    if(!device) return;
    const untitled = 'Untitled'.lox();

    let hasSavedSceneId = this.settings?.lights?.hasOwnProperty('sceneId');
    let sceneId = null;
    let idx = -1;

    const favoritePropertyArray = this.utils.getProperty(device, this.favoriteProperty, []);
    const sceneList = {};

    // no sceneId found in settings, use first scene in device - if any
    if(!hasSavedSceneId) {
        sceneId = this.getSceneId(device);
        if(sceneId === false) {
            sceneId = 'No Scene'.lox();
        } else {
            this.utils.setProp(this.settings, 'lights.sceneId', sceneId);
            idx = favoritePropertyArray.findIndex(scene => scene.id === sceneId);
        }

    } else {
        sceneId = this.settings.lights.sceneId;
        idx = favoritePropertyArray.findIndex(scene => scene.id === sceneId);
        if(idx === -1) { // scene was not found
            if(sceneId == false) {
                sceneId = 'No Scene'.lox();
            }
            console.warn('scene not found::sceneId', sceneId, sceneId == false);
            const dName = `<disabled> ${sceneId}`;
            sceneList[dName] = sceneId;
            idx = 0;
        }
    }

    favoritePropertyArray.forEach((scene, index) => {
        sceneList[this.utils.fixName(sceneList, scene.name, untitled)] = scene.id;
    });

    const piData = {
        sceneId: {
            type: 'select',
            label: this.options.label || 'Scene'.lox(),
            id: this.options.property || 'lights.sceneId',
            value: sceneList,
            selected: idx,
            typeLabel: 'Scene'
        }
    };

    if(this.isEncoder) {
        const prefix = this.isEncoder ? '' : '+';
        const dialModeKeys = Object.keys(DIALMODES);
        const hasSetting = Object.keys(this.settings).some(e => dialModeKeys.includes(e));
        // Force to switchScenes mode if no setting is found
        if(!hasSetting) {
            this.settings[DIALMODES.switchScenes] = true;
            this.switchScenes = true;
            this.setSettings();
        }
        const rotateDialToSwitchScenes = this.settings?.[DIALMODES.switchScenes];
        const selectedStep = Number(this.settings.step);
        const dialModes = ['change-brightness', 'rotate-scenes'];

        piData.template = {
            type: 'template',
            func: {
                swapClassesCallback: ((evt, selector, setClass, remClass) => {
                    const el = document.querySelector(selector);
                    if(el) swapClass(el, setClass, remClass);
                }).toString(),
                swapClass: ((el, c1, c2) => {
                    if(!el) return;
                    el.classList.remove(c1);
                    el.classList.add(c2);
                }).toString(),
            },
            value: `<div type="radio" class="sdpi-item" id="changeDialMode">
            <div class="sdpi-item-label">${'Dial Action'.lox()}</div>
            <div class="sdpi-item-value ">
                <div class="sdpi-item-child">
                    <input id="_callback-rdio2" type="radio" value="${DIALMODES.switchScenes}" name="rdio" onchange="swapClassesCallback(event, '.scenemodeselect', '${dialModes[1]}', '${dialModes[0]}')" ${rotateDialToSwitchScenes ? 'checked' : ''}>
                    <label for="_callback-rdio2" class="sdpi-item-label"><span></span>${'Switch Scenes'.lox()}</label>
                </div>
                <div class="sdpi-item-child">
                    <input id="_callback-rdio1" type="radio" name="rdio" value="changebrightness" onchange="swapClassesCallback(event, '.scenemodeselect', '${dialModes[0]}', '${dialModes[1]}')" ${!rotateDialToSwitchScenes ? 'checked' : ''}>
                    <label for="_callback-rdio1" class="sdpi-item-label"><span></span>${'Brightness'.lox()}</label>
                </div>
            </div>
        </div>
        <div class="scenemodeselect ${rotateDialToSwitchScenes ? dialModes[0] : dialModes[1]}">
            <div class="sdpi-item scenes" id="step">
                <div class="sdpi-item-label">${'Step'.lox()}</div>
                <select class="sdpi-item-value select">
                    ${this.values.map((e, i) => `<option ${selectedStep === i ? 'selected' : ''} value="${i}">${e > 0 ? `${prefix}${e}` : e}%</option>`).join('')}
                </select>
            </div>
        </div>`
        };
    }
    return piData;
};

Scene.prototype.createSceneSVG = function(forceNonEncoder = null, sceneOff = false, inScale = 0.6) {
    let sceneElements = [];
    let lights_on = true;
    let iconColor = 'white';
    let isCurrentScene = false;
    let displayBrightness = 1;
    // if(true) {
    //     const isEncoder2 = forceNonEncoder ? false : this.isEncoder;
    //     const w2 = isEncoder2 ? 200 : 144;
    //     const h2 = isEncoder2 ? 100 : 144;
    //     const svgdbg = `<svg xmlns="http://www.w3.org/2000/svg" width="${w2}" height="${h2}"></svg>`;
    //     return svgdbg;
    // }

    if(sceneOff) {
        // draw 4 segments in greyscales
        sceneElements = Array.from(Array(4).keys()).map(i => ({hue: 359, brightness: 80 - i * 10, saturation: 100 - i * 10}));
        displayBrightness = 0.5;
    } else {

        let device = this.findDeviceById(this.settings['deviceID']);
        if(!device) return console.error("[createSceneSVG]: no device", this.settings['deviceID']);

        lights_on = this.utils.getProperty(device, 'lights.on', false);
        iconColor = lights_on ? 'white' : '#333333';

        const sceneId = this.getSceneId(device);
        if(!sceneId) {
            console.warn('[createSceneSVG]:: sceneId is not found', {device, settings: this.settings});
            return;
        }

        // this should no longer happen, because we bail out, if no sceneId is found
        const favoriteProperty = device[this.favoriteProperty] ?? [];
        if(!favoriteProperty.length) return console.warn(`No ${this.favoriteProperty} found.`, device);

        // use the sceneId to find the scene
        const scene = favoriteProperty.find((scene) => scene.id === sceneId);
        if(!scene) return console.warn(`No scene with id '${sceneId}' found.`);

        // let's see, if the sceneId is the one currently set in the device
        const deviceSceneId = this.utils.getProperty(device, this.options.property, -1);
        isCurrentScene = sceneId == deviceSceneId;

        sceneElements = scene?.sceneElements || [device.lights];
        // in previous versions, the sceneElements carried some <null> pointers in its array - filter them out
        sceneElements = sceneElements.filter(s => s && typeof s === 'object');

        this.dbg("[createSceneSVG]::has sceneElements", scene, scene.sceneElements);

        let sceneName = '';
        if(!scene) {
            console.warn(`[createSceneSVG]::No scene with id '${sceneId}' found. Returning...`, {[this.favoriteProperty]: favoriteProperty, sceneElements, device, settings: this.settings});
            return;
        } else {
            sceneName = scene && scene.name?.length ? scene.name : scene.id;
        }
    } // end if sceneOff

    const isEncoder = forceNonEncoder ? false : this.isEncoder;
    // draw the scene
    const numSceneElements = sceneElements.length;
    const w = isEncoder ? 200 : 144;
    const h = isEncoder ? 100 : 144;
    // const scl = forceNonEncoder ? 1 : isEncoder ? 1 : 0.6;
    // const scl = inScale || 1;
    const scl = this.isEncoder ? 1 : 0.6;
    const x = isEncoder ? w / 2 : h / 2;
    const strokeWidth = isEncoder ? 2 : 1;
    const onOffScale = isEncoder ? 1 : 1.25 / scl;
    const currentIndicatorRadius = this.isEncoder ? 8 : 6;
    const currentIndicatorOffset = this.isEncoder ? currentIndicatorRadius * 2 : currentIndicatorRadius * 2 + 8;
    const topOffset = isEncoder ? h / 2 : h / 3;
    let dimSceneColors = lights_on ? 1 : 0.5;

    // allow tweaking the dimming of the scene colors
    if(CONFIG.dimSceneColorsIfNotCurrentScene) {
        const dimmedSceneColorOpacity = CONFIG.dimmedSceneColorOpacity || 0.5;
        const dimmedSceneColorOpacityIfCurrent = lights_on ? 1 : CONFIG.dimmedSceneColorOpacityIfCurrent || 0.75;
        dimSceneColors = CONFIG.dimSceneColorsIfNotCurrentScene ? isCurrentScene ? dimmedSceneColorOpacityIfCurrent : dimmedSceneColorOpacity : lights_on ? 1 : dimmedSceneColorOpacity;
    }

    const radius = h / 2;
    const start = 90;
    const end = 450;
    const step = (end - start) / numSceneElements;
    const colors = sceneElements.map((color, i) => {
        const r = hsv2rgb(color.hue, color.saturation / 100, displayBrightness).map(n => Math.round(n * 255));
        return `rgb(${r[0]}, ${r[1]}, ${r[2]})`;
    });
    const paths = [`<g transform="scale(-1,1) translate(${-w},0)">`];
    const centerColor = sceneOff ? '#330000' : 'black'; //lights_on ? 'yellow' :'black';
    const centerScale = 0.6;

    const overlayIcon = this.switchScenes ? this.MICONS.switchSceneIcon : this.MICONS.brightnessAdjustIcon;

    if(numSceneElements <= 1) {
        paths.push(`<circle cx="${x}" cy="${radius}" r="${radius - 5}" fill="${colors[0]}" />`);
    } else {
        for(let i = 0;i < numSceneElements;i++) {
            const startAngle = start + (i * step);
            paths.push(`<path d="${this.createSegmentPath(x, radius, h, startAngle, startAngle + step)}" fill="${colors[i]}" stroke-width="${strokeWidth}" stroke="black"/>`);
        }
    }
    // ${false && isCurrentScene && !isEncoder ? `<rect x="0" y="0" width="${w}" height="${h}" fill="${MDefaultColors.backgroundColor_light}"/>` : ''};
    let dimmedCircle = '';
    if(!CONFIG.dimSceneColorsIfNotCurrentScene && isCurrentScene) {
        dimmedCircle = `<circle cx="${currentIndicatorOffset - currentIndicatorRadius / 2}" cy="${currentIndicatorOffset - currentIndicatorRadius / 2}" r="${currentIndicatorRadius}" fill="#579B09" />`;
    };

    paths.push(`</g>`);
    const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" ${this.fontDefinition}>
    <g transform="translate(${w / 2},${topOffset}) scale(${scl},${scl}) translate(${-w / 2},${-topOffset})">
        <circle cx="${x}" cy="${radius}" r="${radius - strokeWidth}" fill="black" opacity="0.4" />
        <g opacity="${dimSceneColors}">
            ${paths.join('')}
        </g>
        <circle cx="${x}" cy="${radius}" r="${radius * centerScale}" fill="${centerColor}" />
        ${sceneOff ? this.MICONS.questionMarkIcon : overlayIcon}
    </g>
    ${dimmedCircle}
    </svg>`;
    // console.log(svg.length, svg);
    return svg;
};

Scene.prototype.createSegmentPath = (x, y, diameter, startAngle, endAngle) => {
    const degrees_to_radians = Math.PI / 180;
    const radius = diameter / 2;
    const r = radius - 5;
    const x1 = (Math.cos(degrees_to_radians * endAngle) * r) + x;
    const y1 = (-Math.sin(degrees_to_radians * endAngle) * r) + y;
    const x2 = (Math.cos(degrees_to_radians * startAngle) * r) + x;
    const y2 = (-Math.sin(degrees_to_radians * startAngle) * r) + y;
    return `M${x} ${y} ${x1} ${y1} A${r} ${r} 0 0 1 ${x2} ${y2}Z`;
};

Scene.prototype.initIcons = function() {
    const overlayIconColor = '#DDDDDD';
    const onOffIcon = `<path fill="${overlayIconColor}" d="M61.2808112,60.4011574 L63.6547242,65.1503045 C61.9969912,67.1431721 61,69.7051538 61,72.5 C61,78.8512857 66.1487143,84 72.5,84 C78.8512857,84 84,78.8512857 84,72.5 C84,70.0632508 83.2421257,67.8035162 81.9492311,65.9436503 L84.3905995,61.0604419 C87.2449864,64.0266545 89,68.0583797 89,72.5 C89,81.61262 81.61262,89 72.5,89 C63.387314,89 56,81.61262 56,72.5 C56,67.719897 58.0326764,63.4145435 61.2808112,60.4011574 Z M75,54 L75,69 L70,69 L70,54 L75,54 Z" ></path>`;
    const switchSceneIcon = `<path fill="${overlayIconColor}" d="M72.5,56 C81.61262,56 89,63.387314 89,72.5 C89,81.61262 81.61262,89 72.5,89 C63.387314,89 56,81.61262 56,72.5 C56,63.387314 63.387314,56 72.5,56 Z M72.5,61 C66.1487143,61 61,66.1487143 61,72.5 C61,78.8512857 66.1487143,84 72.5,84 C78.8512857,84 84,78.8512857 84,72.5 C84,66.1487143 78.8512857,61 72.5,61 Z M72.5365946,40 C87.9044577,40 100.781224,50.6666388 104.166985,65.0002514 L108,65 L101.5,78 L95,65 L99.0014174,64.9999316 C95.7367591,53.457429 85.1243664,45 72.5365946,45 C60.3149374,45 49.9554227,52.9726158 46.3751438,64.0007543 L50,64 L43.5,77 L37,64 L41.1593948,64.0000794 C44.895966,50.1732485 57.5282546,40 72.5365946,40 Z" id="rotate1"></path>`;
    const questionMarkIcon = `<path fill="${overlayIconColor}" d="M70.4174528,81.6769126 C72.3915094,81.6769126 73.1556604,80.2964481 73.1556604,78.2739071 C73.1556604,74.9030055 74.3018868,73.1051913 78.3455189,70.6974044 C82.4209906,68.2254098 85,64.7581967 85,59.7178962 C85,52.8476776 79.3962264,48 71.5,48 C65.3867925,48 60.7063679,50.6646175 58.8278302,55.2233607 C58.254717,56.4754098 58,57.5669399 58,58.9474044 C58,60.6168033 58.8915094,61.579918 60.5153302,61.579918 C61.9481132,61.579918 62.6485849,60.9699454 63.1898585,59.011612 C64.240566,55.159153 67.0424528,53.0081967 71.2771226,53.0081967 C75.9575472,53.0081967 79.0778302,55.8333333 79.0778302,60.0068306 C79.0778302,63.2814208 77.6450472,65.3681694 73.9516509,67.647541 C69.5896226,70.2800546 67.5837264,73.1372951 67.5837264,77.4713115 L67.5837264,78.3702186 C67.5837264,80.2001366 68.4433962,81.6769126 70.4174528,81.6769126 Z M70.3856132,95 C72.4551887,95 74.0153302,93.3948087 74.0153302,91.3401639 C74.0153302,89.2534153 72.4551887,87.6803279 70.3856132,87.6803279 C68.3478774,87.6803279 66.7558962,89.2534153 66.7558962,91.3401639 C66.7558962,93.3948087 68.3478774,95 70.3856132,95 Z" id="questionMarkIcon"></path>`;
    const brightnessAdjustIcon = `<path fill="${overlayIconColor}" d="M72.5,93 C73.8806667,93 75,94.07456 75,95.4 L75,102.6 C75,103.92544 73.8806667,105 72.5,105 C71.1193333,105 70,103.92544 70,102.6 L70,95.4 C70,94.07456 71.1193333,93 72.5,93 Z M90.1420114,86.7107038 L95.2892962,91.8576651 C96.2369013,92.8052702 96.2369013,94.3416911 95.2892962,95.2892962 C94.3416911,96.2369013 92.8052702,96.2369013 91.8576651,95.2892962 L86.7107038,90.1420114 C85.7630987,89.1944063 85.7630987,87.6579854 86.7107038,86.7107038 C87.6579854,85.7630987 89.1944063,85.7630987 90.1420114,86.7107038 Z M57.2893285,86.7107038 C58.2368905,87.6579854 58.2368905,89.1944063 57.2893285,90.1420114 L52.1421343,95.2892962 C51.1945723,96.2369013 49.6582335,96.2369013 48.7106715,95.2892962 C47.7631095,94.3416911 47.7631095,92.8052702 48.7106715,91.8576651 L53.8578657,86.7107038 C54.8054277,85.7630987 56.3417665,85.7630987 57.2893285,86.7107038 Z M72.5,56 C81.61262,56 89,63.387314 89,72.5 C89,81.61262 81.61262,89 72.5,89 C63.387314,89 56,81.61262 56,72.5 C56,63.387314 63.387314,56 72.5,56 Z M72.5,60.95 C66.1211,60.95 60.95,66.1211 60.95,72.5 C60.95,78.8789 66.1211,84.05 72.5,84.05 C78.8789,84.05 84.05,78.8789 84.05,72.5 C84.05,66.1211 78.8789,60.95 72.5,60.95 Z M102.6,70 C103.92544,70 105,71.1193333 105,72.5 C105,73.8806667 103.92544,75 102.6,75 L95.4,75 C94.07456,75 93,73.8806667 93,72.5 C93,71.1193333 94.07456,70 95.4,70 L102.6,70 Z M48.6,70 C49.925472,70 51,71.1193333 51,72.5 C51,73.8806667 49.925472,75 48.6,75 L41.4,75 C40.074528,75 39,73.8806667 39,72.5 C39,71.1193333 40.074528,70 41.4,70 Z M95.2892962,48.7106715 C96.2369013,49.6582335 96.2369013,51.1945723 95.2892962,52.1421343 L90.1423349,57.2893285 C89.1947298,58.2368905 87.6583089,58.2368905 86.7107038,57.2893285 C85.7630987,56.3417665 85.7630987,54.8054277 86.7107038,53.8578657 L91.8579886,48.7106715 C92.8055937,47.7631095 94.3416911,47.7631095 95.2892962,48.7106715 Z M52.1421343,48.7106715 L57.2893285,53.8578657 C58.2368905,54.8054277 58.2368905,56.3417665 57.2893285,57.2893285 C56.3417665,58.2368905 54.8054277,58.2368905 53.8578657,57.2893285 L48.7106715,52.1421343 C47.7631095,51.1945723 47.7631095,49.6582335 48.7106715,48.7106715 C49.6582335,47.7631095 51.1945723,47.7631095 52.1421343,48.7106715 Z M72.5,39 C73.8806667,39 75,40.074528 75,41.4 L75,48.6 C75,49.925472 73.8806667,51 72.5,51 C71.1193333,51 70,49.925472 70,48.6 L70,41.4 C70,40.074528 71.1193333,39 72.5,39 Z" ></path>`;

    this.MICONS = {
        onOffIcon,
        switchSceneIcon,
        questionMarkIcon,
        brightnessAdjustIcon
    };

};