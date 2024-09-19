let $EXTERNALWINDOW = null;

const timeLocations = [
    "America/New_York",
    "America/Chicago",
    "America/Denver",
    "America/Los_Angeles",
    "America/Anchorage",
    "Asia/Jerusalem",
    "Asia/Kabul",
    "Asia/Shanghai",
    "Asia/Tokyo",
    "Europe/London",
    "Europe/Berlin",
    "Europe/Kiev",
    "Australia/Sydney",
    "Australia/Perth",
    "Australia/Darwin",
    "Pacific/Honolulu"
];

function openWindow(windowName) {
    // const url = windowName == 'city-finder' ? '../cityPicker/index.html' : '../../locationPicker/locationPicker.html';
    const pathArr = location.pathname.split("/");
    const rootIdx = pathArr.findIndex(f => f.endsWith('sdPlugin'))+1;
    const path = pathArr.slice(0, rootIdx).join("/");
    console.log('path', path);
    const url = `${path}/action/locationPicker/locationPicker.html`;
    // const url = windowName == 'city-finder' ? '../cityPicker/index.html' : '../action/locationPicker/locationPicker.html';
    if(!$EXTERNALWINDOW || $EXTERNALWINDOW.closed) {
        $EXTERNALWINDOW = window.open(url);
        $EXTERNALWINDOW.XSETTINGS = MSETTINGS;
        $EXTERNALWINDOW.postMessage(MSETTINGS, '*');
    }
}

const createIDFromLocation = (location) => {
    // return location.replace(/\s/g, '-').toLowerCase();
    return location && typeof location === 'string' ? location.replace(/[^a-zA-Z ]/g, "").toLowerCase() : '';
};

const removeCurrent = (el) => {
    el && el.classList.remove('current');
};

const addCurrent = (el) => {
    const parent = el.parentElement;
    parent && parent.classList.add('current');
};

const updateLocationTreeSelector = () => {
    const zonesEl = document.getElementById('zones');
    if(!zonesEl) return console.warn('no zonesEl');
    zonesEl.querySelectorAll('.sdpi-item-child.current').forEach(removeCurrent);
    const tzName = createIDFromLocation(MSETTINGS.$timezone);
    if(!tzName) return console.warn('no timezone found', MSETTINGS.$timezone, MSETTINGS);
    const newSel = zonesEl.querySelectorAll(`#${tzName}`);
    if(!newSel) return console.warn('no timezone-element found', newSel, MSETTINGS.$timezone, MSETTINGS);
    newSel.forEach(addCurrent);
};

function updateLocationTree() {
    const zonesEl = document.getElementById('zones');
    if(!zonesEl) return;
    const getLabel = (i) => i === 0 ? 'Cities'.lox() : '';
    const isUsed = (zone) => MSETTINGS.locations?.includes(zone);
    const currentLocation = createIDFromLocation(MSETTINGS.$timezone);
    if(!Array.isArray(MSETTINGS.locations)) {
        console.trace('MSETTINGS.locations is not an array', MSETTINGS.locations);
    }
    const getCustomName = (loc) => MSETTINGS.customNames?.hasOwnProperty(loc) ? MSETTINGS.customNames[loc] : '';  // or : loc.split("/").pop().replace("_", " ") || '';
    const zones = timeLocations.map((zone, i) => {
        let arr = zone.split("/");
        const [state, city] = arr.length === 2 ? arr : [arr[1], arr[2]];
        const id = createIDFromLocation(zone);
        const label = getLabel(i);
        return `<div class="sdpi-item" id="${i}">
            <div class="sdpi-item-label ${i == 0 ? '' : 'empty'}">${label}</div>
                <div class="sdpi-item-value">
                    <div class="sdpi-item-child ${id == currentLocation ? 'current' : ''}">
                        <input id="${id}" data-setting="locations" type="checkbox" ${isUsed(zone) ? 'checked' : ''} onChange="changeSetting(event.target)" value="${zone}">
                        <label for="${id}" class="sdpi-item-label" title="TimeLocation: ${zone}"><span></span>${city.replace('_', ' ')} <smaller>(${state})</smaller></label>
                        <input class="display-inline" data-setting="customName" data-location="${zone}" id="${id}customname" type="text" value="${getCustomName(zone)}" onChange="changeSetting(event.target)" title="Add a custom name for this location." />
                    </div>
                </div>
            </div>`;
    });
    zones.push(`<div class="sdpi-item">
        <div class="sdpi-item-label empty"></div>
            <div class="sdpi-item-value">
                <div class="sdpi-item-child">
                    <button id="button-inside" class="sdpi-item-value insidebutton" onclick="openWindow()" title="Show more timezones in a window.">Show more...</button>
                </div>
            </div>
       </div>`);
    // <button id="city-finder" class="sdpi-item-value insidebutton" onclick="openWindow('city-finder')">Find city...</button>
    zonesEl.innerHTML = zones.join('');
    setTimeout(updateLocationTreeSelector, 100)
}

const addTimeLocationIfMissing = (arrOfLocations, addToBeginning = false) => {
    if(!Array.isArray(arrOfLocations)) return;
    arrOfLocations?.forEach((location) => {
        if(!timeLocations.includes(location)) {
            (addToBeginning === true) ? timeLocations.unshift(location) : timeLocations.push(location);
        } else {
            adjustLocations(location);
        }
    });
};

// Remove element from 'fromIndex' and insert the element at toIndex in arr;
const moveElementFromTo = (arr, fromIndex, toIndex) => {
    arr.splice(toIndex, 0, arr.splice(fromIndex, 1)[0]);
    return arr;
};

const adjustLocations = (location) => {
    if(timeLocations.includes(location)) {
        const idx = timeLocations.indexOf(location);
        if(idx > -1) {
            return moveElementFromTo(timeLocations, idx, 0);
        }
    }
};

const setProperty = function(jsonObj, path, value) {
    const names = path.split('.');
    let jsn = jsonObj;

    // createNestedObject(jsn, names, values);
    // If a value is given, remove the last name and keep it for later:
    var targetProperty = arguments.length === 3 ? names.pop() : false;

    // Walk the hierarchy, creating new objects where needed.
    // If the lastName was removed, then the last object is not set yet:
    for(var i = 0;i < names.length;i++) {
        jsn = jsn[names[i]] = jsn[names[i]] || {};
    }

    // If a value was given, set it to the target property (the last one):
    if(targetProperty) jsn = jsn[targetProperty] = value;

    // Return the last object in the hierarchy:
    return jsn;
};

const removeDotSeparatedProperties = function(obj) {
    if(typeof obj !== 'object') return;
    Object.keys(obj).filter(k => k.includes('.')).forEach(k => delete obj[k]); // remove dot-separated keys
}

const changeSetting = (el) => {
    // console.log("changeSetting", el, el.dataset, el.id);
    const setting = el.dataset?.hasOwnProperty('setting') ? el.dataset.setting : el.id;
    if(!setting) return;
    
    if(setting == 'customName') {
        const location = el.dataset?.hasOwnProperty('location') ? el.dataset.location : false;
        if(!location) return console.warn('no location', el.dataset, el);
        if(!MSETTINGS.customNames) MSETTINGS.customNames = {};
        const currentLocation = MSETTINGS.customNames[location];
        if(el.value?.length) {
            MSETTINGS.customNames[location] = el.value;
        } else {
            delete MSETTINGS.customNames[location];
        }
    } else if(el.type === 'color') {
        // MSETTINGS[setting] = el.value;
        // avoid setting dot-separated properties and undefined values
        setProperty(MSETTINGS, setting, bool);
    } else if(el.type === 'checkbox') {
        if(setting === 'locations') {
            if(!MSETTINGS[setting]) MSETTINGS[setting] = [];
            if(el.checked) {
                if(!MSETTINGS[setting].includes(el.value)) {
                    MSETTINGS[setting].push(el.value);
                }
            } else {
                const idx = MSETTINGS[setting].indexOf(el.value);
                if(idx > -1) {
                    MSETTINGS[setting].splice(idx, 1);
                }
            }
        } else {
            const bool = el.value && el.value.startsWith('!') ? !el.checked : el.checked;
            // MSETTINGS[setting] = bool;
           setProperty(MSETTINGS, setting, bool); // avoid setting dot-separated properties and undefined values
        }
    }
    removeDotSeparatedProperties(MSETTINGS);
    // console.log('changeSetting', MSETTINGS);
    $PI.setSettings(MSETTINGS);
};

const updateUI = (uiElement) => {
    // console.log("updateUI", uiElement);
    const locationsWrapper = uiElement ? uiElement : document.querySelector('.locations-wrapper');
    if(!locationsWrapper) return console.log('locations-wrapper not found');
    locationsWrapper.querySelectorAll(`input[type="checkbox"], input[type="color"]`).forEach((el) => {
        const setting = el.dataset?.hasOwnProperty('setting') ? el.dataset.setting : el.id;
        if(setting === 'locations') {
            if(!MSETTINGS[setting]) MSETTINGS[setting] = [];
            el.checked = MSETTINGS[setting].includes(el.value);
        } else if(setting === 'color') {
            el.value = MSETTINGS[setting];
        } else {
            el.checked = MSETTINGS[setting] === true;
        }
        if(setting !== 'locations') el.onchange = () => changeSetting(el);
    });
};

const initLocations = (uiElement) => {
    const resolvedTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
     // see if we have our resolved timezone in our locations - and if yes: move it to the beginning
    //  adjustLocations(resolvedTimeZone);

     // see if we have any locations in the settings which are not in our default list
     // and add them to the beginning of the list (second parameter)
    if(MSETTINGS.locations) {
        addTimeLocationIfMissing(MSETTINGS.locations, true);
    };
    adjustLocations(resolvedTimeZone);

     // TIME ZONES
     updateLocationTree();
     // END TIME ZONES

     updateUI(uiElement);
};

window.addEventListener("message", (event) => {
    // console.log('***** MESSAGE RECEIVED **** ', event.data, MSETTINGS.locations);
    if(event.data.event === 'locationChanged') {
        addTimeLocationIfMissing(event.data.locations);
        MSETTINGS.locations = Array.isArray(event.data.locations) ? event.data.locations : [];
        updateLocationTree();
        $PI.setSettings(MSETTINGS);
    }
}, false);
