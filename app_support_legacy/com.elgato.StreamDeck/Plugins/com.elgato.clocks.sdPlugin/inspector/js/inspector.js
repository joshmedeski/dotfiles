const colorregex = /^#([A-F0-9]{3}|[A-F0-9]{6})$/i;
const tabs = ['template']; // ['template',co 'ntext', 'settings', 'export'];
let activeTab = null;
let clockData = null;
const MHASPI = false;
let isAltKeyDown = false;

const checkKey = (e, up) => {
    if(up !== true && e.key === 'Alt') {
        isAltKeyDown = true;
    } else if(e.key === 'Alt') {
        isAltKeyDown = false;
    }
};

window.addEventListener("keydown", e => checkKey(e, false));
window.addEventListener("keyup", e => checkKey(e, true));

const isBoolean = function(vlu) {
    return vlu === true || vlu === false || vlu == 'true' || vlu == 'false'; // || toString.call(obj) === '[object Boolean]';
};

const typeOfValue = function(vlu, value) {
    if(vlu === null || vlu === undefined) return 'nulltext';
    if(vlu === true || vlu === false || vlu == 'true' || vlu == 'false') return 'checkbox';
    const t = typeof vlu;
    if(t === 'object') return 'object';
    if(t === 'boolean') return 'checkbox';
    if(t === 'number' || (parseInt(vlu) == vlu)) return 'number';
    if(t === 'function') return 'function';
    if(t === 'string') {
        if(value.includes('_textarea')) return 'textarea';
        if(vlu.startsWith('<?xml')) return 'svg';
        if(vlu.startsWith('data:image')) return 'image';
        if(colorregex.test(vlu)) return 'color';
    }
    return 'text';
};

function isInt(n) {
    return n % 1 === 0;
}

function isFloat(n) {
    return Number(n) === n && n % 1 !== 0;
}

function TreeItemJSON(model, isRoot, member = null, value, inParent, readonly = false) {
    // if(member == 'debug') member = null;
    const type = readonly == 'true' ? 'text' : typeOfValue(model, value);
    let step = 1;
    if(type === 'textarea' && typeof value === 'string' && value.includes("_textarea")) {
        value = value.replace('_textarea', '');
    } else if(type === 'number') {
        step = isFloat(model) || value === "scale" ? 0.1 : 1;
    }
    // console.log(model, 'v', value, type, 'i/f', isInt(model), isFloat(model), step);
    return {
        $template: '#json-item-template',
        type,
        step,
        readonly,
        isRoot,
        open: false || isRoot,
        get parent() {
            return {name: this.name, member, model, parent: inParent};
        },
        get displayName() {
            const nme = (member ?? value);
            const str = nme.charAt(0) == '$' ? nme.substring(1) : nme;
            return Utils.splitCamelCase(str);
        },
        get name() {
            return member ?? value;
        },
        get getModel() {
            return member ? model[member] : model;
        },
        get isFolder() {
            return typeof this.getModel == 'object';
        },
        get isSVG() {
            return this.type == 'svg';
        },
        get isImage() {
            return this.type == 'image';
        },
        get test() {
            if(this.type == 'checkbox') {
                return this.getModel == 'true' || this.getModel == true;
            } else {
                return 'nix';
            }
        },
        get itemType() {
            return this.type;
        },
        get isTextArea() {
            return this.type === 'textarea';
        },
        get isFloat() {

        },
        updateModel(evt) {
            let tmpParent = this.parent;
            if(evt.target.readonly) return true;
            let newValue = evt.target.value;
            if(evt.target.type == 'number' || typeof tmpParent.parent.model[value] === 'number') {
                if(isAltKeyDown) {
                    evt.preventDefault();
                    evt.stopPropagation();
                    let oldValue = tmpParent.parent.model[value];
                    const difference = evt.target.value - oldValue;
                    newValue = Math.round((oldValue + difference * 10) * 10) / 10;
                } else {
                    newValue = Number(evt.target.value);
                }
                if(evt.target.name === 'scale') {
                    newValue = Utils.minmax(newValue, 0.1, 3);
                }

            } else if(evt.target.type == 'checkbox' || typeof tmpParent.parent.model[value] === 'boolean') {
                newValue = !(evt.target.value == 'true');
                evt.target.value = newValue;
            }
            // this will update the store model
            tmpParent.parent.model[value] = newValue;  // current.parent.model[value] = i;

            let tmpModel;
            let j = 0;
            const path = [];
            while(tmpParent && j++ < 100) {
                path.unshift(tmpParent.name);
                tmpModel = tmpParent.model;
                tmpParent = tmpParent.parent;
            }
            const fullPathToProperty = path.join('.');
            // at this point tmpModel is the model to update and is equivalent to store.data
            // remove template from path
            path.shift();
            const templatePath = path.join('.');
            const prop = {};
            // console.log("setting", templatePath, newValue, prop, fullPathToProperty);
            Utils.setProp(prop, templatePath, newValue);
            const commandToSend = {context: store.data.context.context, path: templatePath, value: newValue, prop};
            sendUpdateMessage(commandToSend);
            return path;
        },
        toggle() {
            if(this.isFolder) {
                this.open = !this.open;
            }
        },
        log(inItem, value) {
            let item = inItem;
            if(inItem instanceof Event) {
                console.log("log", inItem.target.value);
                item = inItem.target.value;
            }
            // const type = getType(this.getModel);
            const valuem = this.getModel;
            console.log({item, value, valuem});
        }
    };
}

function getPrivateData(data, asString = false) {
    const obj = {};
    const excl = ['settings', 'fontName'];
    const pFilter = e => {
        if(data[e] && typeof data[e] == 'object' && Object.keys(data[e]).length === 0) return false;
        return !e.startsWith('$') && !e.startsWith('__') && !data.hasOwnProperty(`__${e}`) && !excl.includes(e);
    };
    Object.keys(data).filter(pFilter).map(e => {
        obj[e] = data[e];
    });
    return asString ? JSON.stringify(obj) : obj;
}

const store = PetiteVue.reactive({
    data: {},
    previewsvg: '',
    setData(data) {
        Object.assign(this.data, data);
    }
});

PetiteVue.createApp({
    TreeItemJSON,
    data: store.data
}).mount();

// /* MESSAGING */

var MContext = -1;

function sendUpdateMessage(cmd) {
    const bc = window.opener;
    bc?.postMessage({event: 'updateData', data: cmd});
}

function showHideLoader(tof) {
    const el = document.querySelector('.loader');
    el && (tof === true) ? el.classList.add('show') : el.classList.remove('show');
}

var $localizedStrings = {};

function resetStore(data) {
    store.data.context = {};
    store.data.template = {};
}

function toExport(inData, asJson) {
    const data = {...inData};
    const template = {...data.clock_style} ?? {};
    // console.log("Template::: ", data, data.clock_style, template);
    delete data.clock_style;
    template.preset = {...data};
    if(asJson) return JSON.stringify(template, null, 4);
    return exportData;
}

function fillStore(data) {
    $localizedStrings = data.localization;
    showHideLoader(true);

    const action = data.action;
    const controller = action?.payload?.controller ?? 'Keypad';
    // remove superflous data from inspector
    clockData = getPrivateData(action.clock);  // clockData = action.clock;
    console.log('fillStore', action.clock, clockData);

    store.data.context = action;
    store.data.previews = [action.clock.previews[controller].b64];
    store.data.svgs = [action.clock.previews[controller].svg];
    delete clockData.clock_style;
    delete clockData.previews;
    delete clockData.activeTab;
    delete clockData.fontColor; //+++andy
    const locations = clockData.hasOwnProperty('locations') && Array.isArray(clockData.locations) ? [...clockData.locations] : false;
    if(locations) {
        if(!clockData.hasOwnProperty('customNames') || typeof clockData.customNames !== 'object') {
            clockData.customNames = {};
        }
        locations.forEach((loc, i) => {
            if(!clockData.customNames[`${loc}`]) {
                clockData.customNames[`${loc}`] = loc.split("/").pop().replace("_", " ") || '';
            }
        });
    }
    delete clockData.locations;
    const sts = action?.payload?.settings || {};
    store.data.template = clockData;
    store.data.settings = sts;
    const exp = toExport(sts, true);
    store.data.export = {settings_textarea: exp};

    if(activeTab === null) activateTabs();
    showHideLoader(false);
    if(MHASPI) {
        initPI(action, data.localization);
    }
}

function loaded(inData) {
    console.log("DATA:loaded", inData, remoteData);
    const data = inData || remoteData;
    resetStore(data);
    setTimeout(() => {
        fillStore(data);
        const listEl = document.querySelector('.list');
        if(listEl) listEl.classList.remove('hidden');;
    }, 10);
}

function activateTabs(baseElement) {
    const allTabs = Array.from(document.querySelectorAll('.tab'));
    allTabs.forEach((el, i) => {
        el.onclick = () => clickTab(el);
        if(i === 0) clickTab(el);
    });
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
}


/** HELPERS */

const containsUnicode = (s) => {
    return /[^\u0000-\u00ff]/.test(s);
};
const utoa = (data) => {
    return btoa(unescape(encodeURIComponent(data)));
};

const messageFromWindow = (evt) => {
    // console.log("got message from window", evt.data?.event, evt.data);
    if(!evt.data) return;
    const event = evt.data.event;
    const data = evt.data.data;
    switch(event) {
        case 'updateSettings':
            store.data.settings = data;
            const exp = toExport(data, true);
            store.data.export = {settings_textarea: exp};
            store.data.export = {settings_textarea: JSON.stringify(data, null, 4)};
            break;
        case 'updatePreview':
            // const s = JSON.stringify(data.svg);
            // console.log("updatePreview", s);
            store.data.previews = [data.b64];
            store.data.svgs = [data.svg];
            // store.data.svgs = [s];
            break;
        case 'updateData':
            const {context, path, value} = data;
            loaded(data);
            break;
    }
};

window.addEventListener('message', messageFromWindow);
