let throttledUpdate = null;
let isMouseDown = false;
let run = () => {};
let MGROUPS = {
    'default': []
};
const KSTOREKEYGROUPS = 'elgato_cc_obs_docks_groups';
const KSTOREKEYACTIVETAB = 'elgato_cc_obs_docks_activetab';

const $CC = new ControlCenterClient({debug: false});

const getFromLocalStorage = (key = 'elgato_cc_obs_docks_groups', defaultValue = []) => {
    return localStorage[key] ? JSON.parse(localStorage[key]) : defaultValue;
};

const getGroups = () => {
    return getFromLocalStorage(KSTOREKEYGROUPS);
};

const addToGroup = (deviceID) => {
    const groups = getGroups();
    if(!groups.includes(deviceID)) {
        groups.push(deviceID);
        localStorage[KSTOREKEYGROUPS] = JSON.stringify(groups);
    }
    MGROUPS.default = groups;
    run();
    return groups;
};

const removeFromGroup = (deviceID) => {
    const groups = getGroups();
    const changed = Utils.removeFromArray(groups, deviceID);
    localStorage[KSTOREKEYGROUPS] = JSON.stringify(groups);
    MGROUPS.default = groups;
    return changed;
};

const handleGroup = (deviceID, addOrRemove) => {
    if(addOrRemove === true) {
        addToGroup(deviceID);
    } else {
        removeFromGroup(deviceID);
    }
    run();
};

window.addEventListener('DOMContentLoaded', (event) => {
    $CC && $CC.initConnection(true);
    MGROUPS.default = getGroups();
    const elDevices = document.querySelector('.devices');
    const elGroups = document.querySelector('.groups');
    const elGroupTitle = document.querySelector('#tab_group');
    const active_tab = localStorage[KSTOREKEYACTIVETAB] || '#tab_devices';
    activateTabs();
    clickTabSelector(active_tab);

    run = () => {
        elDevices.innerHTML = cc_listDevices($CC.devices, true);
        const groupedDevices = $CC.devices.filter(e => MGROUPS.default.includes(e.deviceID));
        elGroups.innerHTML = cc_listDevices(groupedDevices, false);
        groupedDevices.length ? elGroups.classList.remove('hidden') : elGroups.classList.add('hidden');
        elGroupTitle.innerHTML = groupedDevices.length ? `Group (${groupedDevices.length})` : 'Group';
    };

    document.addEventListener("mousedown", function(e) {
        isMouseDown = true;
    }, false);
    document.addEventListener("mouseup", function(e) {
        isMouseDown = false;
    }, false);

    if(!throttledUpdate) throttledUpdate = Utils.throttle(run, 100);

});

$CC.on('deviceConfigurationChanged', (jsn) => {
    if(throttledUpdate && !isMouseDown) throttledUpdate();
});

function initConnection() { // this is only needed for the demo to initialize ControlCenter via button click
    console.log("------initConnection");
    // $CC.initConnection(true);
}

function color(device) {
    return device.lights && device.lights.hue && device.lights.saturation ?
        `<div type="color" class="sdpi-item" id="Color_${device.deviceID}">
    <div class="sdpi-item-label">Color</div>
    <input type="color" class="sdpi-item-value" value="${hsv2hex(device.lights.hue, device.lights.saturation / 100, (device.lights.brightness || 1) / 100)}">
    <span>${hsv2hex(device.lights.hue, device.lights.saturation / 100, (device.lights.brightness || 1) / 100)}</span>
  </div>`
        : '';
}

/* OBS DOCKS & STANDALONE */

const makeIcon = (device, sceneElements, currentSceneId) => `data:image/svg+xml;base64,${btoa(makeSceneSVG(device, sceneElements, currentSceneId))}`;

function cc_listDevices(devices, addToGroup = false) {
    return Object.values(devices).map(device => {
        const id = `${device.deviceID}__${Utils.randomString(8)}`;
        const inGroup = getGroups().find(group => group.includes(device.deviceID));
        return `<div class="sdpi-wrapper device" data-deviceID="${device.deviceID}">
        <button class="add-to-group ${addToGroup && !inGroup ? '' : 'strikethrough'}" onclick="handleGroup('${device.deviceID}', ${addToGroup && !inGroup})">${'&#128279;'}</button>
          ${cc_checkbox(device)}
          <div class="inner">
          ${device.type == 70 && device.firmwareVersionBuild > 212 && device.favoriteScenes ? cc_scenes(device) : cc_slider_temperature(device)}
          ${cc_slider_property(device)}
          </div>
          </div>`;
    }).join("");
};

function cc_scenes(device, prop = 'sceneId') {
    let s = '';
    if(device.type == 70 && device.firmwareVersionBuild > 212) {
        const id = `${device.deviceID}__${Utils.randomString(8)}`;
        const currentSceneId = device?.lights?.sceneId;
        return `<div class="sdpi-item" type="scene" id="ID_sceneId_${id}">
                <div class="sdpi-item-value previewContainer"><span class="pcIcon"></span>
                <span class="sdpi-item-value scenes">
                ${device.favoriteScenes.map(scene => `<img value="${scene.id}" id="${id}" ${onMouseUpEvt(id, prop)} src="${makeIcon(device, scene.sceneElements, scene.id == currentSceneId)}"  />`).join("")}
                </span>
          </div></div>`;
    }
    return s;

}

function cc_slider_temperature(device, prop = 'temperature') {
    if(!device.lights) return '';
    const settings = {
        maxLabel: 2900,
        minLabel: 7000,
        // max: 2900,
        // min: 7000,
        min: 2900,
        max: 7000,
        // maxLabel: Math.floor(Utils.getProp(device, 'lights.temperatureMin', 2900) / 50) * 50,
        // minLabel: Math.ceil(Utils.getProp(device, 'lights.temperatureMax', 7000) / 50) * 50,
        // max: Math.floor(Utils.kelvinToMired(Utils.getProp(device, 'lights.temperatureMin', 2900))),
        // min: Math.ceil(Utils.kelvinToMired(Utils.getProp(device, 'lights.temperatureMax', 7000))),
        value1: Utils.miredToKelvin(Utils.getProp(device, 'lights.temperature', 4700)),
        value: Utils.getProp(device, 'lights.temperature', 4700)
    };

    const id = `${device.deviceID}__${Utils.randomString(8)}`;
    // console.log("temperature", settings, device.lights);
    return device.lights ? `<div class="sdpi-item" type="range" id="ID_temperature_${id}">
        <div class="sdpi-item-value" ${onMouseUpEvt(id, prop)}>
            <span class="icon-cooler" value="${settings.min}" ></span>
            <input id="${id}" type="range" ${onInputEvt(id, prop)} class="colortemperature" max-width="" :176px="" min="${settings.min}" max="${settings.max}" value="${settings.value}"}>
            <span class="icon-warmer" value="${settings.max}" ></span>
        </div></div>`
        : '';
}

//  <label for="${device.deviceID}" class="rangeLabel percent">${device.lights[prop]}</label>
function cc_slider_property(device, prop = 'brightness') {
    const id = `${device.deviceID}__${Utils.randomString(8)}`;
    // testStyling(id);
    return device.lights ? `<div class="sdpi-item" type="range" id="ID_${id}">
        <div class="sdpi-item-value">
            <span class="icon-darker" value="3" ${onMouseUpEvt(id, prop)}></span>
            <input id="${id}" type="range" for="${id}" ${onInputEvt(id, prop)} class="colorbrightness" max-width="" :176px="" min="3" max="100" value="${device.lights[prop]}">
            <span class="icon-brighter" value="100" ${onMouseUpEvt(id, prop)}></span>
        </div></div>`
        : '';
}

function cc_checkbox(device, prop = 'on') {
    const id = `${device.deviceID}__${Utils.randomString(8)}`;
    return device.lights ? `<div type="checkbox" class="sdpi-item" id="ID_${id}">
        <div class="sdpi-item-value">
            <div class="sdpi-item-child">
                <input id="${id}" type="checkbox" ${onClickEvt(id, prop)}  value="${device.lights[prop]}" ${device.lights[prop] ? 'checked' : ''}>
                <label for="${id}" class="sdpi-item-label bold"><span></span>${device.name}</label>
            </div>
        </div>
    </div>`
        : '';
}

const onInputEvt = (id, prop) => `oninput="valueChanged(event,'${id}', 'lights.${prop}')" onchange="run()"`;
const onMouseUpEvt = (id, prop) => `onmouseup="valueChanged(event,'${id}', 'lights.${prop}')"`;
const onClickEvt = (id, prop) => `onclick="valueChanged(event,'${id}', 'lights.${prop}')"`;
const getTargetId = (deviceID) => deviceID.split("__").shift();

function valueChanged(e, deviceID, prop) {

    const el = document.querySelector(`#${deviceID}`);
    if(!el) return;
    const targetId = getTargetId(e.target.id || deviceID);
    const foundDevice = $CC.findDeviceById(targetId);
    const value = e.target.value || e.target.getAttribute('value');
    if(foundDevice) {
        switch(prop) {
            case 'lights.temperature':
                // newValue = Math.round(Utils.miredToKelvin(value));
                newValue = Math.round(value);

                // console.log('temperature', value, newValue, Utils.miredToKelvin(value));

                break;
            case 'lights.on':
                newValue = e.target.checked;
                break;
            default:
                newValue = value;
        }

        const groups = el.closest('.groups');
        // console.log("groups", `.groups #${deviceID}`, deviceID, targetId, groups);

        if(groups) {
            MGROUPS.default.forEach(g => {
                const dvc = $CC.findDeviceById(g);
                if(dvc) {
                    Utils.setProp(dvc, prop, newValue);
                    // $CC.setDeviceConfiguration(dvc, prop);
                    $CC.setDeviceConfiguration(dvc);
                }
            });
        } else {
            Utils.setProp(foundDevice, prop, newValue);
            $CC.setDeviceConfiguration(foundDevice);
        }
    }
}

/* TABS */

function activateTabs(baseElement) {
    const allTabs = Array.from(document.querySelectorAll('.tab'));
    allTabs.forEach((el, i) => {
        if(i === 0) el.classList.add('selected');
        el.onclick = () => clickTab(el);
        if(el.classList.contains('selected')) clickTab(el);
    });
}

function clickTab(clickedTab) {
    const allTabs = Array.from(document.querySelectorAll('.tab'));
    allTabs.forEach((el, i) => el.classList.remove('selected'));
    clickedTab.classList.add('selected');
    localStorage[KSTOREKEYACTIVETAB] = `#${clickedTab.id}`;
    allTabs.forEach((el, i) => {
        if(el.dataset.target) {
            const t = document.querySelector(el.dataset.target);
            if(t) {
                t.style.display = el == clickedTab ? 'block' : 'none';
            }
        }
    });
}

function clickTabSelector(selector) {
    const tab = document.querySelector(selector);
    if(tab) clickTab(tab);
}

let thumbStyle = Utils.injectStyle('', 'andywashere');

function testStyling(id) {
    setTimeout(() => {
        console.log('********** STREAMDECK UPDATING COLOR **********');
        const s = document.querySelector(':root');
         s.style.setProperty('--sdpi-thumbcolor', Utils.getRandomColor());
        // ['--f7-searchbar-inline-input-font-size', '--f7-searchbar-input-font-size', '--kc-title-size'].forEach(e => {
        //     s.style.setProperty(e, '12px');
        // });
        // ['--kc-thumbnail-size'].forEach(e => {
        //     s.style.setProperty(e, '48px');
        // });
    // }, 50);

    const sel = `[type="range"][for="${id}"].colorbrightness`;
    const colorbrightness = document.querySelector(sel);
    if(colorbrightness) {
        const stylId = `stylefor_${id}`;
        if(thumbStyle) {
            const hex = Utils.getRandomColor();
            const baseColor_hx = Utils.getRandomColor();
            thumbStyle.innerHTML += `
            input#${id}[type="range"]::-webkit-slider-thumb {background-color: ${hex};}
            input#${id}[type="range"]::-webkit-slider-runnable-track {background-color: ${baseColor_hx};}
        `;
            // thumbStyle.innerHTML += `
            //     input[type="range"][data-styleId="${stylId}"]::-webkit-slider-thumb {background-color: ${hex};}
            //     input[type="range"][data-styleId="${stylId}"]::-webkit-slider-runnable-track {background-color: ${baseColor_hx};}
            // `;
        }
    }
    }, 80);
}