let MSETTINGS = {};
const MGLOBALDATA = {
    debug: false,
    clocks: null,
    CLOCKFACETYPE: 'clockface',
    CLOCKDIGITSTYPE: 'clockdigits',
    ACTIVITYTYPE: 'activity',
    SEGMENTSTYPE: 'segments',
    groups: {
        'presets': 'Analog',
        'fontStyles': 'Digital',
        'activity': 'Other',
        'segments': 'Other',
    },
    clockFacesPath: `../../../clockFaces/`,
    fontStylesPath: `../../../clockFaces/fontstyles.json`
};

const pathArr = location.pathname.split("/");
const pluginsPathIndex = pathArr.findIndex(f => f.endsWith('sdPlugin'))-1;
const pluginsRootPath = pathArr.slice(0, pluginsPathIndex).join("/");
MGLOBALDATA.rootPath = pluginsRootPath;
MGLOBALDATA.clockFacesPath = `${pluginsRootPath}/ClockFaces/`;
MGLOBALDATA.fontStylesPath = `${pluginsRootPath}/ClockFaces/fontstyles.json`;

const activity = {
    id: "activity",
    name: "Activity",
    type: "activity",
    template: "actvity"
};

const segments = [
    {
        "id": "7-segment-mode0",
        "name": "7 Segments",
        "type": "segments",
        "template": "segments",
        "preset": {
            "mode": 0
        }
    }, {
        "id": "7-segment-mode1",
        "name": "7 Segments rounded",
        "type": "segments",
        "template": "segments",
        "preset": {
            "mode": 1
        }
    },
    {
        "id": "7-segment-mode2",
        "name": "Narrow dots",
        "type": "segments",
        "template": "segments",
        "preset": {
            "mode": 2
        }
    },
    {
        "id": "7-segment-mode3",
        "name": "Wide dots",
        "type": "segments",
        "template": "segments",
        "preset": {
            "mode": 3
        }
    },
    {
        "id": "14-segment-mode4",
        "name": "14 Segments",
        "type": "segments",
        "template": "segments",
        "preset": {
            "mode": 4
        }
    },
    {
        "id": "14-segment-mode4narrow",
        "name": "14 Segments (no colons)",
        "type": "segments",
        "template": "segments",
        "preset": {
            "mode": 4,
            "time.stripColons": true
        }
    }
];

const requiredProperties = {
    'colons.flashColons': false,
    'date.showWeekday': false,
    'date.$hideLayer': true,
    'date.long': false,
    // 'time.color': '#ffffff',
    // 'hours.color': '#ff00ff',
    'time.hour12': false,
    'seconds.$hideLayer': true,
    'dial.useCountdown': true
};

const dbg = MGLOBALDATA.debug !== true ? () => {} : console.log.bind(
    console,
    '%c [PI]',
    'color: #66c',
);

dbg.error = console.error.bind(
    console,
    '%c [PI]',
    'color: #c66',
);
dbg.info = console.info.bind(
    console,
    '%c [PI]',
    'color: #CB6',
);

const targetProperty = 'clock_style';
loadTemplateData('clock_flex');
loadTemplateData('clock_font');
loadTemplateData('activity');
loadTemplateData('segments');

let externalClockFaces = [];
// fontStyles.sort((a,b) => a.name > b.name ? 1 : -1)
// fontStyles.sort((a,b) => a.name.localeCompare(b.name))

const insertItem = (arr, item) => {
    const index = arr.findIndex(a => a.id !== 'default' && a.name.localeCompare(item.name) === 1);
    if(index > -1 ? arr.splice(index, 0, item) : arr.push(item));
};

const insertItemAt = (arr, index, item) => {
    arr.splice(index, 0, item);
};

const loadExternalClocks = async (targetArray) => {
    externalClockFaces = await Utils.loadJSON(`${MGLOBALDATA.fontStylesPath}`, []);
    externalClockFaces.forEach(face => {
        face.file = `${MGLOBALDATA.clockFacesPath}${face.file || face.id}`;
        const meta = Utils.loadJSON(`${face.file}/_info.json`, 'json');
        meta.then(info => {
            if(info?.hasOwnProperty('preset')) {
                face.preset = info.preset;
            }
        });
        insertItem(targetArray, face);
    });
};

// const loadExternalClocks = async () => {
//     externalClockFaces = await Utils.loadJSON(MGLOBALDATA.fontStylesPath, 'json');
//     externalClockFaces.forEach(face => {
//         insertItem(fontStyles, face);
//     });
// }

loadExternalClocks(fontStyles);

$PI.on('connected', (jsn) => {
    dbg.info('connected', jsn, jsn.actionInfo?.payload?.settings);
    const action = jsn.uuid;
    const o = jsn.appInfo?.plugin;
    if(o) {
        // MGLOBALDATA.version = `${o.uuid || ''}\nVersion:\n${o.version || ''}`;
        MGLOBALDATA.version = `Clocks:\nVersion:\n${o.version || ''}`;
    }

    // $PI.onDidReceiveSettings('com.elgato.clocks.action', ({context, payload}) => {
    $PI.onDidReceiveSettings('com.elgato.clocks.action', (jsn) => {
        adjustPI(jsn);
        populateClocksSelector(jsn);
        initLocations();
    });

    // $PI.loadLocalization('../').then(localization => {
        initPI(jsn.actionInfo);
        adjustPI(jsn.actionInfo);
        populateClocksSelector(jsn.actionInfo);
        initLocations();
        $PI.localizationLoaded.then(localizeUI);
        const versionInfoEl = document.querySelector('.versioninfo');
        if(versionInfoEl) {
            versionInfoEl.setAttribute('title', MGLOBALDATA.version);
        }
        activateTabs(MSETTINGS.activeTab);
        const el = document.querySelector('.sdpi-wrapper');
        el.classList.remove('hidden');
        setTimeout(() => {
            measureTabs();
            activateTitles();
        }, 100);
    // });
    if(externalClockFaces?.length > 0) {
        $PI.sendToPlugin({loadExternalClocks: externalClockFaces});
    }

});

// $PI.on('com.elgato.clocks.action.didReceiveSettings', jsn => {
//     console.log('PI (outside connected)', jsn);
// });

function measureTabs(baseElement) {
    const allTabs = Array.from(document.querySelectorAll('.tab'));
    let totalWidth = 0;
    allTabs.forEach((el, i) => {
        totalWidth += Math.round(el.getBoundingClientRect().width);
    });
    const styleId = '#sdpi-tab-adjustments';
    const node = document.getElementById(styleId) || document.createElement('style');
    node.setAttribute('id', styleId);
    node.innerHTML = `.tabs:after {min-width: ${228 - totalWidth}px;}`;
    document.head.appendChild(node);
}

function activateTabs(activeTab) {
    // const allTabs = Array.from(document.querySelectorAll('.tab'));
    const allTabs = document.querySelectorAll('.tab');
    let activeTabEl = null;
    allTabs.forEach((el, i) => {
        el.onclick = () => clickTab(el);
        if(el.dataset?.target === activeTab) {
            activeTabEl = el;
        }
    });
    if(activeTabEl) {
        clickTab(activeTabEl);
    } else if(allTabs.length) {
        clickTab(allTabs[0]);
    }
}

function clickTab(clickedTab) {
    const allTabs = Array.from(document.querySelectorAll('.tab'));
    allTabs.forEach((el, i) => el.classList.remove('selected'));
    clickedTab.classList.add('selected');
    activeTab = clickedTab.dataset?.target;
    allTabs.forEach((el, i) => {
        if(el.dataset.target) {
            const t = document.querySelector(el.dataset.target);
            if(t) {
                t.style.display = el == clickedTab ? 'block' : 'none';
            }
        }
    });
    MSETTINGS.activeTab = activeTab;
    saveSettings(); // remember active tab
}

function empty(node) {
    if(!node) return;
    while(node.firstChild) {
        node.removeChild(node.firstChild);
    }
}

function saveSettings(value, param, jsn) {
    // <input id="dateshowLayer" type="checkbox" data-setting="date.$hideLayer" value="!date.$hideLayer" onchange="saveSettings(event.target.checked ? false: true, 'date.$hideLayer')">
    if(MSETTINGS && param) Utils.setProp(MSETTINGS, param, value);
    if(!$PI.websocket && jsn) {
        const commandToSend = {context: jsn.context, path: param, value};
        console.error('PI COMMAND:', commandToSend);
        sendUpdateMessage(commandToSend);
    }
    if(!Array.isArray(MSETTINGS.locations)) {
        console.trace('saveSettings is not an array', MSETTINGS.locations);
    }
    $PI.setSettings(MSETTINGS);
}

function sendMessageToPlugin(msg, type = 'showMessage') {
    return; // TODO: remove +++andy
    if(msg == '') {
        type = 'hideMessage';
    }
    // console.log('sendMessageToPlugin', {[type]: msg});
    $PI.sendToPlugin({[type]: msg});
}

function sendToPlugin(msg) {
    $PI.sendToPlugin({showMessage: msg});
}

// function localize(s) {
//     if(typeof s === 'undefined') return '';
//     let str = String(s);
//     try {
//         str = $localizedStrings[str] || str;
//     } catch(b) {}
//     return str;
// };



function localizeUI() {
    // const localize = $PI.localize.bind($PI);
    console.log('localizeUI', $PI.localization);
    const el = document.querySelector('.sdpi-wrapper');
    const selectors = Array.from(el.querySelectorAll('.sdpi-item-label'));
    selectors.forEach(e => {
        const s = e.innerText.trim();
        e.innerHTML = e.innerHTML.replace(s, $PI.localize(s));
    });
    Array.from(el.querySelectorAll('*:not(script)')).forEach(e => {
        if(selectors.includes(e)) return;
        if(e.childNodes && e.childNodes.length > 0 && e.childNodes[0].nodeValue && typeof e.childNodes[0].nodeValue === 'string') {
            e.childNodes[0].nodeValue = $PI.localize(e.childNodes[0].nodeValue);
        }
    });
}

function initPI(jsn) {
    const controller = (jsn?.payload?.controller || 'Keypad').toLowerCase();
    document.body.classList.add(controller);
    /** Localization */
    // if($localizedStrings && Object.keys($localizedStrings).length > 0) {
    //     localizeUI();
    // }
    // $PI.on('localizationChanged', () => console.log('localizationChanged', $PI.localization));
    // $PI.localizationLoaded.then(console.log('localizationLoaded', $PI.localization));
    
    const allclocksSelector = document.querySelector(".allclocksSelector");
    allclocksSelector.onchange = (e) => {
        const opt = e.target.options[e.target.selectedIndex];
        const clk = MGLOBALDATA.clocks[e.target.value];
        // console.log("'allclocksSelector changed:", e.target.selectedIndex, clk, {
        //     id: e.target.value,
        //     type: opt.getAttribute(targetProperty),
        //     template: clk && clk.template,
        // });
        const locations = (MSETTINGS?.locations && Array.isArray(MSETTINGS.locations)) ? MSETTINGS.locations : [];
        const time = MSETTINGS?.time || {};
        const $timezone = MSETTINGS?.$timezone || '';
        const customNames = MSETTINGS?.customNames || {};
        MSETTINGS = {$timezone, locations, time, customNames};
        ['mode', 'time.stripColons'].forEach(e => {
            const p = clk?.preset?.[e];
            if(p) {
                Utils.setProp(MSETTINGS, e, p);
            }
        });
        // save clock_id settings
        saveSettings({
            id: e.target.value,
            type: opt.getAttribute(targetProperty),
            template: clk && clk.template,
            mode: clk && clk.preset && clk.preset.mode,
        }, targetProperty, jsn);

        adjustBody(allclocksSelector);
        loadDataForStyle(e.target.value);
    };

    // adjustPI(jsn);
    // populateClocksSelector(jsn);
};

function adjustBody(el) {
    dbg('adjustBody', el, el.options, el.selectedIndex);
    if(el.selectedIndex > -1) {
        const style = el.options[el.selectedIndex].getAttribute(targetProperty);
        document.body.classList.remove('fontStyles', 'presets', 'activity', 'segments');
        document.body.classList.add(style);
    }
}

function loadTemplateData(templateId = 'clock_flex') {
    if(!MGLOBALDATA[templateId]) {
        const templateLoader = new ELGSDTemplateLoader({template: templateId, dynamicActionPath: '../action/templates/'});
        templateLoader.loaded().then((template) => {
            MGLOBALDATA[templateId] = template;
        });
    }
    return MGLOBALDATA[templateId];
}

function loadClockData(clockId) {
    dbg('loadClockData', clockId);
    if(!MGLOBALDATA.clocks) {
        const presetFontsObj = {};
        fontStyles.forEach(p => presetFontsObj[p.id] = {...p, clock_type: MGLOBALDATA.CLOCKDIGITSTYPE, template: "clock_font"});
        const presetsObj = {};
        presets.forEach(p => {
            if(!p.preset?.date?.long) Utils.setProp(p, 'preset.date.long', false);
            presetsObj[p.id] = {...p, clock_type: MGLOBALDATA.CLOCKFACETYPE, template: "clock_flex"};
        });
        const activityObj = {
            'activity': {...activity, clock_type: MGLOBALDATA.ACTIVITYTYPE, template: "activity"}
        };
        const segmentsObj = {};
        segments.forEach(s => {
            segmentsObj[s.id] = {...s, clock_type: MGLOBALDATA.SEGMENTSTYPE, template: "segments"};
        });

        MGLOBALDATA.clocks = {
            ...presetsObj,
            ...presetFontsObj,
            ...activityObj,
            ...segmentsObj
        };
    }
    return MGLOBALDATA.clocks[clockId];
}

function loadDataForStyle(clock_id) {
    const id = clock_id ?? MSETTINGS?.clock_style?.id;
    dbg("loadDataForStyle:clock_style", id);
    if(!id) return console.warn("loadDataForStyle:clock_style: no id");
    const clockData = loadClockData(id);
    if(!clockData) return console.warn("loadDataForStyle:clock_style: no data for id", id);
    adjustExtendedProperties(id, clockData);

    // now all styles have a preset, load its template
    const templateData = loadTemplateData(clockData.template);

    // merge stored clock data with settings
    // create a copy to not modify the original
    const tempSettings = {...MSETTINGS};
    delete tempSettings.clock_style;

    const flattenedSettings = Utils.flatten(tempSettings);
    let flattenedPresetSettings;
    if(id == 'default') {
        flattenedPresetSettings = {...requiredProperties, mode: 0, ...Utils.flatten(clockData.preset), ...flattenedSettings};
    } else if(clockData.type == 'segments') {
        flattenedPresetSettings = {...requiredProperties, mode: 0, 'time.stripColons': false, ...flattenedSettings};
    } else if(clockData.preset) {
        flattenedPresetSettings = {...requiredProperties, ...Utils.flatten(clockData.preset), ...flattenedSettings};
    } else {
        flattenedPresetSettings = {...requiredProperties, ...flattenedSettings};
    }

    Object.keys(flattenedPresetSettings).forEach(k => {
        const els = document.querySelectorAll(`[data-setting="${k}"]`);
        els.forEach(el => {
            dbg(`[data-setting="${k}"]`, el.value, flattenedPresetSettings[k], !flattenedPresetSettings[k], el.type, el);
            if(el.type === 'checkbox') {
                const bool = el.value && el.value.startsWith('!') ? !flattenedPresetSettings[k] : flattenedPresetSettings[k];
                el.checked = Array.isArray(bool) ? bool.length > 0 : bool;
            } else {
                el.value = flattenedPresetSettings[k];
            }
            el.onchange = () => {
                sendMessageToPlugin('');
                changeSetting(el);
            };
        });
    });

    const updateColorSelector = (selector, property, data, cb) => {
        // console.log('updateColorSelector_0', selector, property, data, cb);
        if(!data) return;
        const el = document.querySelector(selector);
        if(el) {
            let hc = flattenedPresetSettings[property];

            if(hc == undefined) {
                hc = Utils.getProp(data, property, -1);
                if(hc !== -1) {
                    el.value = hc;
                }
            }

            el.onchange = (e) => {
                if(cb(e.target.value, data)) {
                    $PI.setSettings(MSETTINGS);
                }
            };
        }
    };

    const updateProps = (propsArr, data, value) => {
        let success = false;
        propsArr.forEach(prop => {
            if(data.hasOwnProperty(prop) && data[prop].hasOwnProperty('color')) {
                Utils.setProp(MSETTINGS, `${prop}.color`, value);
                success = true;
            }
        });
        Utils.setProp(MSETTINGS, `fontColor`, value);
        return success;
    };

    updateColorSelector('#digitColor', 'hours.color', templateData?.data, (value, data) => {
        return updateProps(['time', 'hours', 'minutes', 'seconds', 'colons'], data, value);
    });

    updateColorSelector('#timeColor', 'time.color', templateData?.data, (value, data) => {
        return updateProps(['time', 'hours', 'minutes', 'seconds', 'colons'], data, value);
    });

    updateColorSelector('#dateColor', 'date.color', templateData?.data, (value, data) => {
        let success = false;
        const prop = 'date';
        if(data.hasOwnProperty(prop) && data[prop].hasOwnProperty('color')) {
            Utils.setProp(MSETTINGS, `${prop}.color`, value);
            success = true;
        }
        return success;
    });

    updateColorSelector('#faceColor', 'face.color', templateData?.data, (value, data) => {
        let success = false;
        const prop = 'face';
        if(data.hasOwnProperty(prop) && data[prop].hasOwnProperty('color')) {
            Utils.setProp(MSETTINGS, `${prop}.color`, value);
            success = true;
        }
        return success;
    });

}

function adjustExtendedProperties(clockStyle, clockData) {
    dbg("adjustExtendedProperties:clockStyle", clockStyle);
    const el = document.querySelectorAll('.withexceptions').forEach(el => {
        if(!el) return;
        if(clockData.clock_type === 'segments') {
            el.classList.add('default');
        } else {
            el.classList.remove('default');
        }
        if(clockStyle === 'default') {
            el.classList.remove('hidden');
        } else {
            el.classList.add('hidden');
        }

    });
}

function adjustPI(jsn) {
    dbg("adjustPI:jsn", jsn);

    MSETTINGS = jsn.payload.settings;

    const clocks = {
        presets,
        fontStyles,
        activity: [activity],
        segments
    };
    const allclocksSelector = document.querySelector(".allclocksSelector");
    Object.keys(clocks).forEach(f => {
        let el = document.querySelector(`#${f}`);
        if(!el) {
            const groupName = MGLOBALDATA.groups[f] ?? f;
            let optgroup = allclocksSelector.querySelector(`#${groupName}`);
            if(!optgroup) {
                optgroup = document.createElement('optgroup');
                optgroup.id = groupName;
                optgroup.label = Utils.capitalize(groupName);
                allclocksSelector.appendChild(optgroup);
            }
            el = optgroup;
            // } else {
            //     empty(el);
        }
        empty(el);
        Object.values(clocks[f]).map(e => {
            let option = document.createElement('option');
            option.setAttribute('value', e.id);
            option.setAttribute(targetProperty, f);
            option.setAttribute('label', $PI.localize(e.name));
            el.appendChild(option);
        });
    });

    const clockStyle = MSETTINGS?.clock_style?.id;
    loadDataForStyle(clockStyle);
    updateLocationTreeSelector();
}

function populateClocksSelector(jsn) {
    const oClockSelector = document.querySelector(".allclocksSelector");
    if(!oClockSelector) return;
    let idx = -1;
    if(jsn?.payload?.settings) {
        if(jsn.payload.settings.hasOwnProperty(targetProperty)) {
            const val = jsn.payload.settings[targetProperty]?.id ?? -1;
            idx = Array.from(oClockSelector.options).findIndex(e => e.value == val);
        }
    }
    if(oClockSelector.selectedIndex !== idx) {
        oClockSelector.selectedIndex = idx;
    };
    adjustBody(oClockSelector);
}


function activateTitles() {
    // document.querySelectorAll('.sdpi-item input,.sdpi-item select, .sdpi-item .tab').forEach(el => {
    document.querySelectorAll('[title]').forEach(el => {
        const e = el?.title ? el : el?.parentElement?.title ? el.parentElement : el.closest('.sdpi-item');
        if(e) {
            e.onmouseover = () => {
                sendMessageToPlugin(e.title || '', 'showMessage');
            };
            e.onmouseout = () => {
                sendMessageToPlugin(e.title || '', 'hideMessage');
            };
        }
    });
}

function copySettings(targetSelector) {
    const s = JSON.stringify(MSETTINGS);
    console.log('copySettings', s);
    Utils.copyToClipboard(s, targetSelector, () => {
        console.log('copySettings:done');
        checkLoadButton();
    });
   
}

function loadSettings(targetSelector) {
    const el = document.querySelector(targetSelector);
    if (!el) return console.error("loadSettings:targetSelector not found", targetSelector);
    const inJsonOrString = el.value;
    if(!inJsonOrString) return console.error("loadSettings:targetSelector is empty", el);
    const jsn = typeof inJsonOrString === 'object' ? inJsonOrString : JSON.parse(inJsonOrString);
    // console.log("loadSettings:s", jsn);
    MSETTINGS = jsn;
    $PI.setSettings(MSETTINGS);
}

const checkLoadButton = (s) => {
    const loadButton = document.querySelector('#loadButton');
    if(!loadButton) return;
    const inJsonOrString = s || document.querySelector('#settingsarea').value;
    loadButton.disabled = (inJsonOrString.length < 10 || !Utils.isJsonString(inJsonOrString));
};

document.addEventListener("DOMContentLoaded", function(event) {
    const loadButton = document.querySelector('#loadButton');
    if(!loadButton) return;
    loadButton.disabled = true;
    document.querySelector('#settingsarea').addEventListener('input', e => {
        checkLoadButton(e.target.value);
    });
    // sendMessageToPlugin('CLOSED PI', 'showMessage');
});

window.addEventListener("beforeunload", function(e) {
    sendMessageToPlugin(''); // signal plugin that the PI is about to close
});

// DOESNT' WORK
// window.addEventListener("onunload", function(e) {
//     sendMessageToPlugin('CLOSED PI', 'showMessage');
// });
