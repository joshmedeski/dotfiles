/* global $SD */
$SD.on('connected', jsn => {
    console.log('%c[app.js connected]', 'color: #f66; font-size: 13px;font-weight: bold;', jsn);
    // $SD.loadLocalization('./');
    $SD.on('com.elgato.clocks.action.willAppear', jsonObj => action.onWillAppear(jsonObj));
    $SD.on('com.elgato.clocks.action.sendToPlugin', jsonObj => action.onSendToPlugin(jsonObj));
    $SD.on('com.elgato.clocks.action.didReceiveSettings', jsonObj => action.onDidReceiveSettings(jsonObj));
    $SD.on('com.elgato.clocks.action.willDisappear', jsonObj => action.onWillDisappear(jsonObj));
    $SD.on('com.elgato.clocks.action.keyDown', jsonObj => action.onKeyDown(jsonObj));
    $SD.on('com.elgato.clocks.action.keyUp', jsonObj => action.onKeyUp(jsonObj));
    $SD.on('com.elgato.clocks.action.dialRotate', jsonObj => action.onDialRotate(jsonObj));
    $SD.on('com.elgato.clocks.action.dialPress', jsonObj => action.onDialPress(jsonObj));
    $SD.on('com.elgato.clocks.action.touchTap', jsonObj => action.onTouchTap(jsonObj, true));
});

/**
 * Dear fellow developers
 * The code in this plugin is highly experimental and not meant to be used as a reference for anything.
 * Please keep that in mind when reading this code.
 * It contains excerpts, snippets and features from other plugins and experiments
 * and it will most likely significantly change in the future.
 * The original idea was to create a plugin that allows you to create your own clock face 
 * and host it on your own server, database or anywhere else.
 * If it becomes popular, we might make it into a proper plugin :) 
 */

const MGLOBALDATA = {
    fontPath: 'action/fontstyles/fonts/',
    clockFacesPath: `../../clockFaces/`,
    fontStylesPath: `../../clockFaces/fontstyles.json`
};

const defaultSettings = {
    clock_style: {
        id: "default",
        type: "default"
    },
    seconds: {
        $hideLayer: true
    },
    date: {
        $hideLayer: true
    },
    locations: [],
    customNames: {},
};

const clockFacesPath = `${$SD.data.__parentdir}/ClockFaces/`;
const fontStylesPath = `${clockFacesPath}/fontstyles.json`;
MGLOBALDATA.clockFacesPath = clockFacesPath;
MGLOBALDATA.fontStylesPath = fontStylesPath;

console.log({
    clockFacesPath,
    fontStylesPath
})


const logIf = (ctx, ...args) => {
    if(ctx == 'd60c5765202e62bff61f89ad535cb490') {
        console.log(...args);
    }
};
// const getFromLocalStorage = (key = MSTORAGEKEY, defaultValue = []) => {
//     return localStorage[key] ? JSON.parse(localStorage[key]) : defaultValue;
// };
// const MSTORAGEKEY = 'com.elgato.clocks.settings';
// const MPERSISTENTSETTINGS = {
//     locations: getFromLocalStorage(MSTORAGEKEY, {}),
// };

// const proxify = (obj, ...listeners) => {
//     return new Proxy(obj, {
//         set: function(obj, prop, value) {
//             console.log('proxify.set', obj, prop, value);
//             listeners.forEach(fn => fn({...obj, [prop]: value}, obj));
//             obj[prop] = value;
//             return true;
//         }
//     });
// };

// const MSETTINGSPROXY = proxify(MPERSISTENTSETTINGS, (items, oldObj) => {
//         console.log('**** settingsProxy', items, oldObj);
//     }
// );

// const MSTORAGE = {
//     storage: localStorage,
//     state: {},
//     setItem(key, value) {
//         this.storage.setItem(MSTORAGEKEY, JSON.stringify(value));
//     },
//     getItem(key) {
//         console.log("getItem", key, this);
//         const value = this.storage.getItem(MSTORAGEKEY);
//         return (typeof value !== 'object') ? JSON.parse(value) : value;
//         // return this.data.hasOwnProperty(key) ? JSON.stringify(this.data[key]) : '';
//     },
// }

const presetsObj = {
    presets: {},
    fontStyles: {}
};

presets.forEach(p => presetsObj.presets[p.id] = p);
fontStyles.forEach(p => presetsObj.fontStyles[p.id] = p);

const insertItem = (arr, item) => {
    const index = arr.findIndex(a => a.id !== 'default' && a.name.localeCompare(item.name) === 1);
    if(index > -1 ? arr.splice(index, 0, item) : arr.push(item));
};

const loadExternalClocks = async (externalClockFacesArray) => {
    // const externalClockFaces = externalClockFacesArray && Array.isArray(externalClockFacesArray) ? externalClockFacesArray : await Utils.loadJSON(`${MGLOBALDATA.clockFacesPath}fontstyles.json`, []);
    const externalClockFaces = await Utils.loadJSON(`${MGLOBALDATA.clockFacesPath}fontstyles.json`, []);
    externalClockFaces.forEach(face => {
        face.file = `${MGLOBALDATA.clockFacesPath}${face.file || face.id}`;
        face.external = true;
        const meta = Utils.loadJSON(`${face.file}/_info.json`, false);
        meta.then(info => {
            if(info?.hasOwnProperty('preset')) {
                face.preset = info.preset;
            }
            if(info === false) {
                console.warn('Problem loading external font face:', face.id, info)
                face.hasError = true;
            };
        });
        const hasThisStyle = fontStyles.some(f => f.id == face.id);
        console.assert('loadExternalClocks', face.id, 'was not found in fontStyles', fontStyles);
        if(!hasThisStyle) {
            fontStyles.push(face);
            presetsObj.fontStyles[face.id] = face;
        }
    });

};

loadExternalClocks();

const getPrivateData = (clock, asString = false) => {
    const privateData = {};
    Object.keys(clock).filter(e => !e.startsWith('$') && !e.startsWith('__') && !clock.hasOwnProperty(`__${e}`)).map(e => {
        privateData[e] = clock[e];
    });
    // if for testing purposes we need a private property
    // we can add it here
    // if(clock.hasOwnProperty('$topOffset')) {
    //     privateData.$topOffset = clock.$topOffset;
    // }

    return asString ? JSON.stringify(privateData) : privateData;
};

const clockTypes = {
    'presets': 'clock_flex',
    'fontStyles': 'clock_font',
    'activity': 'activity',
    'electric': 'electric',
    'default': 'clock_font'
};

const getClockType = (clock) => {
    if(clock.hasOwnProperty('type')) {
        return clock.type;
    }
    if(clock.hasOwnProperty('clock_style')) {
        return clock.clock_style.type;
    }
    return 'default';
};

const getClockTemplate = (clock) => {
    if(clock.hasOwnProperty('template')) {
        return clock.template;
    }
    return clockTypes[getClockType(clock)];
};

var action = {
    type: 'com.elgato.clocks.action',
    data: {},
    cache: {},
    settings: {},
    removePropertyFromSettings: function(jsn, prop = 'locations') {
        if(jsn.hasOwnProperty(prop)) {
            const cachedProp = jsn[prop];
            delete jsn[prop];
            return cachedProp;
        }
        return false;
        // return jsn.hasOwnProperty(prop) && delete jsn[prop];
    },
    saveSettings: function(jsn) { // called from the plugin's action template
        const settings = this.settings[jsn.context] || {};
        // console.log('%c[$saveSettings]', 'color: #3bF', jsn.context, settings);
        $SD.setSettings(jsn.context, settings);
    },
    onDidReceiveSettings: function(jsn, ignore = false) {
        const settings = jsn.payload.settings;
        this.settings[jsn.context] = settings;
        let clock = this.cache[jsn.context];
        // console.log('%c[onDidReceiveSettings 1]', 'color: #3b9', jsn.context, settings, settings.clock_style.id, clock._preset?.id);
        if(settings.hasOwnProperty('clock_style')) {
            if(settings.clock_style.id !== clock._preset?.id) {
                const type = settings?.clock_style?.type || 'default';
                // console.log('%c settings:clock_id', 'font-size: 20px', settings.clock_style.id, 'clock: preset.id', clock._preset?.id, 'type:', type);
                const origData = this.data[jsn.context];
                jsn.payload.controller = origData.payload.controller;
                return this.newClock(jsn);
            }
        }
        clock = this.cache[jsn.context];
        console.assert(clock, '%c[$onDidReceiveSettings] has no clock', 'color: #3b9', jsn.context, clock);
        if(!clock) return;
        clock.changeProps(settings);
        clock.updateCity(settings.customNames);
    },

    newClock: function(jsn) {
        // if we have a clock, destroy it
        let clock = this.cache[jsn.context];
        // console.log("newClock", jsn.context, clock, jsn);
        if(clock) {
            clock.sd = null;
            clock.destroy();
            delete this.cache[jsn.context];
            clock = null;
        };
        // load our cached settings
        let settings = this.settings[jsn.context];
        let clockType = getClockTemplate(settings.clock_style);
        let templateLoader;
        let preset;
        let font = false;
        if(clockType === 'clock_flex') {
            preset = presetsObj.presets[settings.clock_style.id];
            templateLoader = new ELGSDTemplateLoader({template: clockType, preset});
        } else if(clockType === 'activity') {
            templateLoader = new ELGSDTemplateLoader({template: 'activity', dynamicActionPath: './action/templates/'});
        } else {
            font = presetsObj.fontStyles[settings.clock_style.id];
            if(!font) console.warn( `Clockface "${settings.clock_style?.id}" not found!`, settings.clock_style, settings);
            templateLoader = new ELGSDTemplateLoader({template: clockType, preset: font});
        };

        templateLoader.loaded().then(() => {
            Utils.merge(templateLoader.templateData.data, settings);
            let clock = new DynamicActionClock({...templateLoader.templateData, ...jsn});
            clock._preset = preset ?? font;
            clock.sd = $SD;
            if(clock._preset?.hasError === true) {
                const tmp = settings.clock_style?.id;
                if(tmp && tmp.includes('.')) {
                    const tmpName = tmp.split(".").slice(-2,-1).join("")
                    clock.showMessage(`Font face "${Utils.capitalize(tmpName)}" incomplete!`, 2500);
                } else {
                    clock.showMessage(`Error loading font face!`, 5000);
                }
            }
            clock.on('saveSettings', (oSettings) => { // called from the clock with its own settings
                this.settings[jsn.context] = {...this.settings[jsn.context], ...oSettings};
                this.saveSettings(jsn);
            });
            this.cache[jsn.context] = clock;
            if(font && clockType === 'clock_font') {
                clock.$updateFont(font.file, font?.external === true).then(() => {
                    clock.updateLayout(true);
                    messageToWindow(jsn);
                });
            } else {
                clock.updateLayout(true);
                messageToWindow(jsn);
            };
            clock.on('updatedStreamDeck', (e) => {
                if(isWindowOpen()) {
                    if(e.context == $EXTERNALWINDOW.context) {
                        // console.log('%c[changed]', 'color: #9fa', clock.context, e, jsn.payload.controller);
                        $EXTERNALWINDOW.postMessage({event: 'updatePreview', data: e.previews[jsn.payload.controller]}, '*');
                    }
                }
            });
            return clock;
        });
    },

    onWillAppear(jsn) {
        // console.log('%c[$onWillAppear]', 'color: #44B', jsn.context, jsn.payload.settings);
        this.data[jsn.context] = jsn;
        let settings = jsn.payload.settings;
        if(settings.hasOwnProperty('locations') && !Array.isArray(settings.locations)) {
            settings.locations = [];
        };
        if(!settings.hasOwnProperty('clock_style')) {
            settings = defaultSettings;
            this.settings[jsn.context] = settings;
            this.saveSettings(jsn);  // save the default settings
        } else {
            this.settings[jsn.context] = settings;
        }
        this.newClock(jsn);
    },

    onWillDisappear(jsn) {
        let found = this.cache[jsn.context];
        if(found) {
            // remove the clock from the cache
            found.destroy && found.destroy();
            delete this.cache[jsn.context];
        }
        if(isWindowMine(jsn.context)) {
            $EXTERNALWINDOW.close();
        }
    },

    onKeyDown(jsn) {
        this.cache[jsn.context]?.onKeyDown(jsn);
    },

    onKeyUp(jsn) {
        this.cache[jsn.context]?.onKeyUp(jsn);
    },

    onDialRotate(jsn) {
        this.cache[jsn.context]?.onDialRotate(jsn);
    },

    onDialPress(jsn) {
        this.cache[jsn.context]?.onDialPress(jsn);
    },

    onTouchTap(jsn, tapped) {
        this.cache[jsn.context]?.onTouchTap(jsn, tapped);
        if(jsn?.payload?.hold === true) {
            if(isWindowClosed()) {
                this.onOpenWindow(jsn);
            } else {
                if(jsn.context !== $EXTERNALWINDOW.context) {
                    $EXTERNALWINDOW.close();
                    $EXTERNALWINDOW = null;
                    this.onOpenWindow(jsn);
                }
            }
        }
    },

    onSendToPlugin(jsn) {
        // console.log("got message from PI:", jsn, jsn?.payload);
        if(jsn?.payload.hasOwnProperty('loadExternalClocks') && Array.isArray(jsn.payload.loadExternalClocks)) {
            const externalClockFaces = jsn.payload.loadExternalClocks;
            const hasMissingFontStyle = externalClockFaces.some((face) => !fontStyles.some((f) => f.id === face.id));
            if(hasMissingFontStyle) {
                console.log('missing font styles, loading them');
                loadExternalClocks(externalClockFaces);
            }
        } else if(jsn?.payload === 'openWindow') {
            this.onOpenWindow(jsn);
        } else if(jsn?.payload.hasOwnProperty('showMessage')) {
            const clock = this.cache[jsn.context];
            if(clock) {
                clock.showMessage(jsn.payload.showMessage, 3500);
            }
        } else if(jsn?.payload.hasOwnProperty('hideMessage')) {
            const clock = this.cache[jsn.context];
            if(clock) {
                clock.hideMessage();
            }
        }
    },

    onOpenWindow: function(jsn) {
        openWindow(this.data[jsn.context]);
    }
};


/* EXTERNAL WINDOW */

let $EXTERNALWINDOW = null;

const isWindowOpen = () => $EXTERNALWINDOW && !$EXTERNALWINDOW.closed;
const isWindowClosed = () => !$EXTERNALWINDOW || $EXTERNALWINDOW.closed;
const isWindowMine = (ctx) => isWindowOpen() && ($EXTERNALWINDOW.context == ctx);

const openWindow = (jsn) => {
    $EXTERNALWINDOW = window.open('inspector/inspector.html?context=' + jsn.context, '_blank');
    messageToWindow(jsn, null, true);
    return $EXTERNALWINDOW;
};

function messageToWindow(jsn, event = 'updateData', attach) {
    if(isWindowClosed()) return;
    const ctx = action.cache[jsn.context];
    if(ctx) {
        const d = getPrivateData(ctx.getData());
        jsn.clock = JSON.parse(JSON.stringify(d));
        delete jsn.clock.leftOffset;
        delete jsn.clock.topOffset;
        delete jsn.clock.scale;
        delete jsn.clock.$hour12Offset;
        // delete jsn.clock.locations; // locations is not editable
        delete jsn.clock.mode; // mode is not editable
        delete jsn.clock.dial; // dial is not editable
        jsn.clock.previews = ctx.previews;
    }

    const data = {action: jsn, localization: $localizedStrings};

    // console.log("sending data to  window", data);
    if(attach) {
        $EXTERNALWINDOW.context = jsn.context;
        $EXTERNALWINDOW.remoteData = data;
    } else {
        $EXTERNALWINDOW.postMessage({event, data}, '*');
    }
};

const messageFromWindow = (evt) => {
    // console.log('%c[messageFromWindow]', 'color: #6F6', evt, evt.data?.event, evt.data);
    if(!evt.data) return;
    const event = evt.data.event;
    const data = evt.data.data;
    switch(event) {
        case 'updateData':
            const {context, path, value, prop} = data;
            const clock = action.cache[context];
            const settings = action.settings[context];
            if(clock) {
                if(path == 'clock_style') {
                    const jsn = {...action.data[context]};
                    // console.log('%c[messageFromWindow path=="clock_style"]', 'color: #6F6', {context, path, value, prop, jsn});
                    const currentClockStyleId = jsn?.payload?.settings?.clock_style?.id;
                    if(currentClockStyleId !== value.id) {
                        // console.log('%c[messageFromWindow changing clock style from"]', 'color: #6F6', currentClockStyleId, "to", value?.id);
                        delete jsn.clock;
                        settings['clock_style'] = value;
                    }
                    jsn.settings = settings;
                    return action.newClock(jsn);
                }

                Utils.merge(settings, prop);
                // changeProp(settings, prop, value, true);
                // console.log('mfw:p/settings:', prop, settings.customNames);
                if(prop.hasOwnProperty('customNames')) {
                    const empties = Object.fromEntries(Object.entries(prop.customNames).filter(([o, v]) => v == ''));
                    if(empties) {
                        Object.keys(empties).forEach(v => {
                            // console.log('deleting', v, 'from customNames because it is empty');
                            delete settings.customNames[v];
                        });
                    }
                    clock.updateCity(settings.customNames);

                };
                action.settings[context] = settings;
                action.saveSettings({context}); // save settings received from external window
                clock.setUpdateLock(true);
                clock.changeProp(prop, value);
                clock.setUpdateLock(false);
                const result = clock.updateLayout(true);
                if($EXTERNALWINDOW) {
                    if(result.hasOwnProperty('data')) {
                        delete result.data;
                    }
                    $EXTERNALWINDOW.postMessage({event: 'updatePreview', data: result}, '*');
                    $EXTERNALWINDOW.postMessage({event: 'updateSettings', data: settings}, '*');
                }
            }
            break;
    }
};

window.addEventListener('message', messageFromWindow);
