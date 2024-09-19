let MSETTINGS = {
    locations: []
};

let id = -1;


const messageToPI = (locations) => {
    if(id > -1 && window.opener) {
        window.opener.postMessage({
            "event": "locationChanged",
            id,
            locations
        }, '*');
    }
    id++;
};

const proxify = (obj, ...listeners) => {
    return new Proxy(obj, {
        set: function(obj, prop, value) {
            listeners.forEach(fn => fn({...obj, [prop]: value}, obj, prop, value));
            obj[prop] = value;
            return true;
        }
    });
};


const settingsProxy = proxify(MSETTINGS,
    (items, oldObj, key, value) => {
        showLocations(items.locations);
        updateLocationTree(items.locations);
        messageToPI(items.locations);
    }
);

// used in external window
const updateLocationTree = (locations) => {
    const zonesEl = document.getElementById('zones');
    zonesEl.querySelectorAll(`input[type="checkbox"]`).forEach((el) => {
        el.checked = locations.indexOf(el.value) > -1;
    });
};

const addValue = (v) => {
    const idx = settingsProxy.locations.findIndex(item => item == v);
    console.log('addValue', v, idx);
    if(idx == -1) {
        settingsProxy.locations = [...settingsProxy.locations, v];
    };
};

const removeValue = (v) => {
    console.log('removeValue', v);
    settingsProxy.locations = settingsProxy.locations.filter((zone) => zone !== v);
};

const removeItem = (e) => {
    if(e?.target?.value) {
        removeValue(e.target.value);
    }
};

const showLocations = (locations) => {
    document.querySelector('.currentSelection').innerHTML = locations.map((zone, i) => {
        const [state, city] = zone.split("/");
        return `<div class="selected">${city.replace(/_/g, ' ')}<button class="close-box" value="${zone}" onClick="removeItem(event)">x</button></div>`;
    }).join('');
};

function changed(e) {
    // console.log('changed', e.target.checked, e.target.value);
    if(e.target.checked) {
        addValue(e.target.value);
    } else {
        removeValue(e.target.value);
    }
}

const applyFilter = (e) => {
    // console.log('apply filter', e.target.value);
    doLoad(e.target.value);
};

const createIDFromLocation = (location) => {
  return location && typeof location === 'string' ? location.replace(/[^a-zA-Z ]/g, "").toLowerCase() : '';
};

const splitValue = (location) => { // was splitValue
  if(typeof location === 'object') return [location.timezone, location.city, location.timezone.split("/")[0]];
  let arr = location.split("/");
  return arr.length === 2 ? arr : [arr[1], arr[2]];
};

const doLoad = (inFilterValue = undefined) => {
    let externalSettings = ('XSETTINGS' in window) ? XSETTINGS : {locations:['Europe/Berlin', 'America/New_York', 'America/Los_Angeles']};
    let filterValue = inFilterValue;
    if(!filterValue) {
        const zoneFilter = document.getElementById('zoneFilter');
        filterValue = zoneFilter.value;
    }
    const zonesEl = document.getElementById('zones');
    console.log("doLoad::FILTER", filterValue, settingsProxy, settingsProxy.locations, locations);
    if(settingsProxy.locations.length === 0) {
        settingsProxy.locations = externalSettings.locations;
    }

    const isUsed = (zone) => settingsProxy.locations?.includes(zone);
    const zoneItem = (zone, i) => {
        let arr = zone.split("/");
        const [state, city] = arr.length === 2 ? arr : [arr[1], arr[2], ''];
        const id = createIDFromLocation(zone);
        return `<div class="sdpi-item" id="${i}">
        <div class="sdpi-item-value">
            <div class="sdpi-item-child">
                <input id="${id}" type="checkbox" ${isUsed(zone) ? 'checked' : ''} value="${zone}" onChange="changed(event)">
                    <label for="${id}" class="sdpi-item-label"><span></span>${city.replace('_', ' ')} <smaller>(${state})</smaller></label>
            </div>
        </div>
    </div>`;
    };
    console.log('doLoad::MSETTINGS', locations);

    const locs = filterValue ? locations.filter((location) => {
        const [state, city] = location.split("/");
        return city.toLowerCase().includes(filterValue.toLowerCase()) || city.replace('_', ' ').toLowerCase().includes(filterValue.toLowerCase());
    }) : locations;

    if(filterValue) {
        zonesEl.innerHTML = `${locs.map((location, i) => {
            return `${zoneItem(location, i)}`;
        }).join('')}`;
    } else {
        let lastState = '';
        zonesEl.innerHTML = `${locs.map((location, i) => {
            const [state, city] = location.split("/");
            const differentState = (state !== lastState);
            lastState = state;
            if(i > 0 && differentState) {
                return `</details><details class="state ${state}"><summary>${state}</summary>${zoneItem(location, i)}`;
            }
            return `${differentState ? `<details class="state ${state}"><summary>${state}</summary>` : ''}${zoneItem(location, i)}`;
        }).join('')}</details>`;
    }
};

setTimeout(function() {
    doLoad();
}, 0);

window.addEventListener("message", (event) => {
    console.log('***** MESSAGE RECEIVED **** ', event);
    if(event.data.type === "settings") {
        MSETTINGS = event.data.settings;
        doLoad();
    }
}, false);
