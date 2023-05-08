/* global addDynamicStyles, $SD, Utils */
/* eslint-disable no-extra-boolean-cast */

var onchangeevt = 'onchange'; // 'oninput'; // change this, if you want interactive elements act on any change, or while they're modified
// cache some nodes to improve performance
let sdpiWrapper = document.querySelector('.sdpi-wrapper');

$SD.on('connected', (jsn) => {
    addDynamicStyles($SD.applicationInfo.colors, 'connectElgatoStreamDeckSocket');
    sendValueToPlugin('propertyInspectorConnected', 'property_inspector');
    sdpiWrapper.innerHTML = '';

    new MutationObserver(function () {
        prepareDOMElements();
    }).observe(sdpiWrapper, {
        attributes: true,
        childList: true,
        characterData: true
    });
});

$SD.on('sendToPropertyInspector', (jsn) => {
    const pl = jsn.payload;
    if (pl.hasOwnProperty('error')) {
        sdpiWrapper.innerHTML = `<div class="sdpi-item">
            <details class="message caution">
            <summary class="${pl.hasOwnProperty('info') ? 'pointer' : ''}">${pl.error}</summary>
                ${pl.hasOwnProperty('info') ? pl.info : ''}
            </details>
        </div>`;
    } else if (pl.hasOwnProperty('propertyInspectorDataAsString')) {
        const props = Utils.parseJson(jsn.payload.propertyInspectorDataAsString);
        sdpiWrapper.innerHTML = '';
        Object.entries(props).map(e => sdpiCreateItem(e[1], sdpiWrapper));
    }
});

function initPropertyInspector (initDelay) {
    sdpiWrapper = sdpiWrapper || document.querySelector('.sdpi-wrapper');
    prepareDOMElements(document);
}

// eslint-disable-next-line no-unused-vars
function revealSdpiWrapper () {
    sdpiWrapper && sdpiWrapper.classList.remove('hidden');
}

// our method to pass values to the plugin
function sendValueToPlugin (value, param) {
    // console.log($SD, $SD.readyState, $SD.actionInfo, $SD.uuid, param, value);
    if ($SD.connection && ($SD.connection.readyState === 1)) {
        const json = {
            'action': $SD.actionInfo['action'],
            'event': 'sendToPlugin',
            'context': $SD.uuid,
            'payload': {
                [param]: value
            }
        };
        $SD.connection.send(JSON.stringify(json));
    }
}

if (!isQT) {
    document.addEventListener('DOMContentLoaded', function () {
        initPropertyInspector(100);
    });
}
document.addEventListener('DOMContentLoaded', function () {
    document.body.classList.add(navigator.userAgent.includes("Mac") ? 'mac' : 'win');
});

/** the beforeunload event is fired, right before the PI will remove all nodes */
window.addEventListener('beforeunload', function (e) {
    e.preventDefault();
    sendValueToPlugin('propertyInspectorWillDisappear', 'property_inspector');
    // Don't set a returnValue to the event, otherwise Chromium with throw an error.  // e.returnValue = '';
});

/** CREATE INTERACTIVE HTML-DOM
 * where elements can be clicked or act on their 'change' event.
 * Messages are then processed using the 'handleSdpiItemClick' method below.
 */

function prepareDOMElements (baseElement) {

    baseElement = baseElement || document;
    Array.from(baseElement.querySelectorAll('.sdpi-item-value')).forEach((el, i) => {
        const elementsToClick = ['BUTTON', 'OL', 'UL', 'TABLE', 'METER', 'PROGRESS', 'CANVAS'].includes(el.tagName);
        const evt = elementsToClick ? 'onclick' : onchangeevt || 'onchange';

        /** Look for <input><span> combinations, where we consider the span as label for the input
         * we don't use `labels` for that, because a range could have 2 labels.
        */
        const inputGroup = el.querySelectorAll('input, span');
        if (inputGroup.length === 2) {
            const offs = inputGroup[0].tagName === 'INPUT' ? 1 : 0;
            inputGroup[offs].innerText = inputGroup[1 - offs].value;
            inputGroup[1 - offs]['oninput'] = function () {
                inputGroup[offs].innerText = inputGroup[1 - offs].value;
            };
        }
        /** We look for elements which have an 'clickable' attribute
         * we use these e.g. on an 'inputGroup' (<span><input type="range"><span>) to adjust the value of
         * the corresponding range-control
          */
        Array.from(el.querySelectorAll('.clickable')).forEach((subel, subi) => {
            subel['onclick'] = function (e) {
                handleSdpiItemClick(e.target, subi);
            };
        });
        const cloneEvt = el[evt];
        el[evt] = function (e) {
            if (cloneEvt) cloneEvt()
            handleSdpiItemClick(e.target, i);
        };
    });

    baseElement.querySelectorAll('textarea').forEach(e => {
        const maxl = e.getAttribute('maxlength');
        e.targets = baseElement.querySelectorAll(`[for='${e.id}']`);
        if (e.targets.length) {
            let fn = () => {
                for (let x of e.targets) {
                    x.innerText = maxl ? `${e.value.length}/${maxl}` : `${e.value.length}`;
                }
            };
            fn();
            e.onkeyup = fn;
        }
    });

    baseElement.querySelectorAll('[data-open-url').forEach(e => {
        const value = e.getAttribute('data-open-url');
        e.innerText = e.innerText.lox();
        if (value) {
            e.onclick = () => {
                let path;
                if (value.indexOf('http') !== 0) {
                    path = document.location.href.split('/');
                    path.pop();
                    path.push(value.split('/').pop());
                    path = path.join('/');
                } else {
                    path = value;
                }
                $SD.api.openUrl($SD.uuid, path);
            };
        } else {
            console.log(`${value} is not a supported url`);
        }
    });
}

function handleSdpiItemClick (e, idx) {
    /** Following items are containers, so we won't handle clicks on them */
    if (['OL', 'UL', 'TABLE'].includes(e.tagName)) { return; }
    // console.log('--- handleSdpiItemClick ---', e, `type: ${e.type}`, e.tagName, `inner: ${e.innerText}`);

    /** SPANS are used inside a control as 'labels'
     * If a SPAN element calls this function, it has a class of 'clickable' set and is thereby handled as
     * clickable label.
     */

    if (e.tagName === 'SPAN') {
        const inp = e.parentNode.querySelector('input');
        if (inp && e.hasAttribute('value')) {
            inp.value = e.getAttribute('value');
        } else return;
    }

    const selectedElements = [];
    const isList = ['LI', 'OL', 'UL', 'DL', 'TD'].includes(e.tagName);
    const sdpiItem = e.closest('.sdpi-item');
    const sdpiItemGroup = e.closest('.sdpi-item-group');
    let sdpiItemChildren = isList ? sdpiItem.querySelectorAll((e.tagName === 'LI' ? 'li' : 'td')) : sdpiItem.querySelectorAll('.sdpi-item-child > input');

    if (isList) {
        const siv = e.closest('.sdpi-item-value');
        if (!siv.classList.contains('multi-select')) {
            for (let x of sdpiItemChildren) x.classList.remove('selected');
        }
        if (!siv.classList.contains('no-select')) {
            e.classList.toggle('selected');
        }
    }

    if (sdpiItemGroup && !sdpiItemChildren.length) {
        for (let x of ['input', 'meter', 'progress']) {
            sdpiItemChildren = sdpiItemGroup.querySelectorAll(x);
            if (sdpiItemChildren.length) break;
        }
    };

    if (e.selectedIndex) {
        idx = e.selectedIndex;
    } else {
        sdpiItemChildren.forEach((ec, i) => {
            if (ec.classList.contains('selected')) {
                selectedElements.push(ec.innerText);
            };
            if (ec === e) {
                idx = i;
                selectedElements.push(ec.value);
            };
        });
    };

    const returnValue = {
        key: e.id && e.id.charAt(0) !== '_' ? e.id : sdpiItem.id,
        value: isList ? e.innerText : e.hasAttribute('_value') ? e.getAttribute('_value') : (e.value ? (e.type === 'file' ? decodeURIComponent(e.value.replace(/^C:\\fakepath\\/, '')) : e.value) : e.getAttribute('value')),
        group: sdpiItemGroup ? sdpiItemGroup.id : false,
        index: idx,
        selection: selectedElements,
        checked: e.checked
    };

    /** Just simulate the original file-selector:
     * If there's an element of class '.sdpi-file-info'
     * show the filename there
     */
    if (e.type === 'file') {
        const info = sdpiItem.querySelector('.sdpi-file-info');
        if (info) {
            const s = returnValue.value.split('/').pop();
            info.innerText = s.length > 28 ? s.substr(0, 10) + '...' + s.substr(s.length - 10, s.length) : s;
        }
    }
    // console.log(returnValue);
    sendValueToPlugin(returnValue, 'sdpi_collection');
}

/** TEMPLATES */

const createSdpiItem = (obj) => {
    obj.id = obj['id'] || Utils.randomString(8); // window.btoa(new Date().getTime().toString()).substr(4, 16);
    obj.rnd = `_${Utils.randomString(8)}_`;
    const sdpiItemValue = getTemplate(obj);

    return `<div class="sdpi-item" ${obj.type ? `type="${obj.type}"` : ''} id="${obj.id}">
    <div class="sdpi-item-label">${obj.label.lox() || ''}</div>
    ${sdpiItemValue}
    </div>`;
};

// eslint-disable-next-line no-unused-vars
function toggleDisabled (e) {
    const el = event.target;
    const opt = el[el.selectedIndex].innerText;
    const dis = opt.indexOf('<disabled>') === 0;
    if (dis) {
        el.classList.add('disabled');
    } else {
        el.classList.remove('disabled');
    }
}

// eslint-disable-next-line no-unused-vars
const isDisabled = (obj, isArr = 1) => {
    console.log('isDisabled', Object.entries(obj.value)[obj.selected][1 - isArr].indexOf('<disabled>') === 0);
};

const calcRangeWidth = (obj) => {
    let styl = '';
    if (!!obj.minLabel || !!obj.maxLabel) {
        const mt = Math.floor(Utils.measureText(`${obj.minLabel}${obj.maxLabel}`));
        if (mt > 0) {
            let mrgin = !!obj.minLabel ? 4 : 0;
            mrgin = !!obj.maxLabel ? mrgin+4 : mrgin;
            const w = 224 - mt - mrgin;
            styl = `style="max-width: ${w}px"`;
        }
    }
    return styl;
};

/* eslint no-unreachable: 0 */
function getTemplate (obj) {
    const isArr = Number(Array.isArray(obj.value));
    switch (obj.type) {
    case 'select':
        const isDisabledItem = Object.entries(obj.value)[obj.selected][isArr].indexOf('<disabled>') === 0 ? 'disabled' : '';
        return `<select onchange="toggleDisabled()" class="sdpi-item-value ${isDisabledItem}">${Object.entries(obj.value).map((e, i) => `<option value="${e[1 - isArr]}" ${obj.selected === i ? 'selected="selected"' : ''} ${e[isArr].indexOf('<disabled>') === 0 ? 'disabled="disabled"' : ''}>${e[isArr]}</option>`).join('')}</select>`;
        break;

    case 'radio':
    case 'checkbox':
        return `<div class="sdpi-item-value">${Object.entries(obj.value).map((e, i) => `<div class='sdpi-item-child'>
            <input type="${obj.type}" id="${obj.rnd + String(i)}" name="${obj.rnd}" value="${e[1 - isArr]}" ${obj.selected.includes(e[isArr]) ? 'checked="checked"' : ''}>
            <label for="${obj.rnd + String(i)}" class="sdpi-item-label"><span></span>${e[isArr].lox()}</label>
        </div>`).join('')}</div>`;
        break;

    case 'list':
        return `<div class="sdpi-item" ${obj.type ? `class="${obj.type}"` : ''} id="${obj.id}">
        <div class="sdpi-item-label">${obj.label || ''}</div>
        <ul class="sdpi-item-value ${obj.selectionType ? obj.selectionType : ''}">
                ${obj.value.map(e => `<li>${e}</li>`).join('')}
            </ul>
        </div>`;
        break;

    case 'range':
        const styl = calcRangeWidth(obj);
        if (obj.reverse) {
            return `<div class="sdpi-item-value">
                ${!!obj.maxLabel ? `<span class="clickable" value="${obj.value.max || 100}">${obj.maxLabel || obj.value.max || 100}</span>` : ''}
                <input type="range" ${styl} class="reverse" min="${obj.value.min || 0}" max="${obj.value.max || 100}" value="${obj.value.value || 50}">
                ${!!obj.minLabel ? `<span class="clickable" value="${obj.value.min || 0}">${obj.minLabel || obj.value.min || 0}</span>` : ''}
            </div>`;
        } else {
            return `<div class="sdpi-item-value">
                ${!!obj.minLabel ? `<span class="clickable" value="${obj.value.min || 0}">${obj.minLabel || obj.value.min || 0}</span>` : ''}
                <input type="range" ${styl} min="${obj.value.min || 0}" max="${obj.value.max || 100}" value="${obj.value.value || 50}">
                ${!!obj.maxLabel ? `<span class="clickable" value="${obj.value.max || 100}">${obj.maxLabel || obj.value.max || 100}</span>` : ''}
            </div>`;
        }
        break;

    case 'range reverse':

        break;

    default:
        return `<input class="sdpi-item-value" type="text" value="">`;
        break;
    }
};

function sdpiCreateItem (obj, el, cb) {
    if (el) {
        const newEl = document.createElement('div');
        newEl.innerHTML = createSdpiItem(obj);
        el.appendChild(newEl.firstChild);
    }
}

// eslint-disable-next-line no-unused-vars
function localizeUI () {
    const el = document.querySelector('.sdpi-wrapper');
    Array.from(el.querySelectorAll('sdpi-item-label')).forEach(e => {
        e.innerHTML = e.innerHTML.replace(e.innerText, localize(e.innerText));
    });
    Array.from(el.querySelectorAll('*:not(script)')).forEach(e => {
        if (e.childNodes && e.childNodes.length > 0 && e.childNodes[0].nodeValue && typeof e.childNodes[0].nodeValue === 'string') {
            e.childNodes[0].nodeValue = localize(e.childNodes[0].nodeValue);
        }
    });
};
