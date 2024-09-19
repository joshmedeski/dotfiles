/* global addDynamicStyles, $SD, Utils */
/* eslint-disable no-extra-boolean-cast */
/* eslint-disable no-else-return */

var onchangeevt = 'onchange'; // 'oninput'; // change this, if you want interactive elements act on any change, or while they're modified
// cache some nodes to improve performance
let sdpiWrapper = document.querySelector('.sdpi-wrapper');
const styles = {};

$SD.on('connected', jsn => {
    addDynamicStyles($SD.applicationInfo.colors, 'connectSocket');
    sendValueToPlugin('propertyInspectorConnected', 'property_inspector');
    sdpiWrapper.innerHTML = '';

    new MutationObserver(function() {
        prepareDOMElements();
    }).observe(sdpiWrapper, {
        attributes: true,
        childList: true,
        characterData: true,
    });
});

$SD.on('sendToPropertyInspector', jsn => {
    const pl = jsn.payload;
    if(pl.hasOwnProperty('error')) {
        sdpiWrapper.innerHTML = `<div class="sdpi-item">
            <details class="message caution">
                <summary class="${pl.hasOwnProperty('info') ? 'pointer' : 'nopointer'}">${pl.error}</summary>
                ${pl.hasOwnProperty('info') ? pl.info : ''}
            </details>
        </div>`;
    } else if(pl.hasOwnProperty('propertyInspectorDataAsString')) {
        const props = Utils.parseJson(jsn.payload.propertyInspectorDataAsString);
        sdpiWrapper.innerHTML = '';
        Object.entries(props).map(e => sdpiCreateItem(e[1], sdpiWrapper));
    }
});

function initPropertyInspector(initDelay) {
    sdpiWrapper = sdpiWrapper || document.querySelector('.sdpi-wrapper');
    prepareDOMElements(document);
}

// eslint-disable-next-line no-unused-vars
function revealSdpiWrapper() {
    sdpiWrapper && sdpiWrapper.classList.remove('hidden');
}

// our method to pass values to the plugin
function sendValueToPlugin(value, param) {
    // console.log($SD, $SD.readyState, $SD.actionInfo, $SD.uuid, param, value);
    if($SD.connection && $SD.connection.readyState === 1) {
        const json = {
            action: $SD.actionInfo['action'],
            event: 'sendToPlugin',
            context: $SD.uuid,
            payload: {
                [param]: value,
                targetContext: $SD.actionInfo['context'],
            },
        };
        // console.log("sendValueToPlugin: ", json, value, param);
        $SD.connection.send(JSON.stringify(json));
    }
}

if(!isQT) {
    document.addEventListener('DOMContentLoaded', function() {
        initPropertyInspector(100);
    });
}
document.addEventListener('DOMContentLoaded', function() {
    document.body.classList.add(navigator.userAgent.includes('Mac') ? 'mac' : 'win');
});

/** the beforeunload event is fired, right before the PI will remove all nodes */
window.addEventListener('beforeunload', function(e) {
    e.preventDefault();
    sendValueToPlugin('propertyInspectorWillDisappear', 'property_inspector');
    // Don't set a returnValue to the event, otherwise Chromium with throw an error.  // e.returnValue = '';
});

/** CREATE INTERACTIVE HTML-DOM
 * where elements can be clicked or act on their 'change' event.
 * Messages are then processed using the 'handleSdpiItemClick' method below.
 */

function prepareDOMElements(baseElement) {
    const range = document.querySelector('input[type=range]');
    const tooltip = document.querySelector('.sdpi-info-label');
    const tw = tooltip.getBoundingClientRect().width;

    const fn = () => {
        const rangeRect = range.getBoundingClientRect();
        const w = rangeRect.width - tw / 2;
        const percnt = Utils.rangeToPercent(range.value, range.min, range.max);
        if(tooltip.classList.contains('hidden')) {
            tooltip.style.top = '-1000px';
        } else {
            tooltip.style.left = `${rangeRect.left + Math.round(w * percnt) - tw / 4}px`;
            tooltip.style.top = `${rangeRect.top - 32}px`;
        }
    };

    if(range) {
        range.addEventListener(
            'mouseenter',
            function() {
                tooltip.classList.remove('hidden');
                tooltip.classList.add('shown');
                fn();
            },
            false
        );

        range.addEventListener(
            'mouseout',
            function() {
                tooltip.classList.remove('shown');
                tooltip.classList.add('hidden');
                fn();
            },
            false
        );
        range.addEventListener('input', fn, false);
    }

    document.addEventListener(
        'touchstart',
        function(event) {
            console.log('T)OUCH');
            event.preventDefault();
        },
        {passive: false}
    );

    document.documentElement.addEventListener(
        'touchstart',
        function(event) {
            console.log('touch 2', event);
            if(event.touches.length > 1) {
                event.preventDefault();
            }
        },
        false
    );

    baseElement = baseElement || document;

    Array.from(baseElement.querySelectorAll('.sdpi-item-value')).forEach((el, i) => {
        const typ = el.getAttribute('type');

        if(typ == 'color-picker') {
            const clr = {
                hue: el.dataset.hue ? parseInt(el.dataset.hue) : 120,
                saturation: el.dataset.saturation ? parseInt(el.dataset.saturation) / 100 : 1,
                brightness: el.dataset.brightness ? parseInt(el.dataset.brightness) / 100 : 1,
                kelvin: el.dataset.kelvin ? parseInt(el.dataset.kelvin) : 4700,
                mode: el.dataset.mode ? el.dataset.mode : 'color',
            };

            if(tooltip) tooltip.textContent = `${clr.brightness * 100}%`;

            initColorPicker(null, clr, function(jsn) {
                returnValue = {
                    key: 'color-picker',
                    value: jsn,
                };

                const bri = `${parseInt(jsn.lights.brightness)}%`;

                if(tooltip) tooltip.textContent = bri;
                sendValueToPlugin(returnValue, 'sdpi_collection');
            });
            return;
        }
        const elementsToClick = ['BUTTON', 'OL', 'UL', 'TABLE', 'METER', 'PROGRESS', 'CANVAS'].includes(el.tagName);
        const evt = elementsToClick ? 'onclick' : onchangeevt || 'onchange';

        /** Look for <input><span> combinations, where we consider the span as label for the input
         * we don't use `labels` for that, because a range could have 2 labels.
         */
        const inputGroup = el.querySelectorAll('input + span');
        if(inputGroup.length === 2) {
            const offs = inputGroup[0].tagName === 'INPUT' ? 1 : 0;
            inputGroup[offs].textContent = inputGroup[1 - offs].value;
            inputGroup[1 - offs]['oninput'] = function() {
                inputGroup[offs].textContent = inputGroup[1 - offs].value;
            };
        }
        /** We look for elements which have an 'clickable' attribute
         * we use these e.g. on an 'inputGroup' (<span><input type="range"><span>) to adjust the value of
         * the corresponding range-control
         */
        Array.from(el.querySelectorAll('.clickable')).forEach((subel, subi) => {
            subel['onclick'] = function(e) {
                handleSdpiItemClick(e.target, subi);
            };
        });

        el.querySelectorAll('input[type="range"]').forEach(e => {
            let obj = e.dataset.callbackid ? objCache[e.dataset.callbackid] : {};
            // first we map all registered callbacks to a function
            if(e.dataset.callbacks) {
                const a = e.dataset.callbacks.split(',');
                a.map(f => {
                    let c = f.split(':');
                    let evt = c[0];
                    let fn = eval(c[1]);
                    const cloneEvt = e[evt];
                    e[evt] = function() {
                        if(cloneEvt) cloneEvt();
                        fn(obj);
                    };
                });
            }

            e.targets = baseElement.querySelectorAll(`[for='${e.dataset.labelid}']`);

            if(e.targets.length) {
                let tmpFunc;
                const fn = () => {
                    for(const x of e.targets) {
                        const suffix = x.classList.contains('kelvin') ? 'K' : '%';
                        const attr = x.dataset.labelcallback;
                        if(attr) {
                            tmpFunc = eval(`(${attr})`);
                        }
                        if(typeof tmpFunc === 'function') {
                            const vlu = String(Math.round(tmpFunc(e.value)));
                            x.textContent = vlu;
                            if(tooltip) tooltip.textContent = vlu + suffix;
                        } else {
                            x.textContent = e.value;
                            if(tooltip) tooltip.textContent = e.value + suffix;
                        }
                    }
                };
                // set the value
                fn();
                const evt = 'oninput';
                const cloneEvt = e[evt];
                e[evt] = function(e) {
                    if(cloneEvt) cloneEvt();
                    e[evt] = fn();
                };
            }
        });
        const evtTmp = el.dataset.sendevent ? el.dataset.sendevent : evt;
        const cloneEvt = el[evtTmp];
        el[evtTmp] = function(e) {
            if(cloneEvt) cloneEvt();
            handleSdpiItemClick(e.target, i);
        };
    });

    baseElement.querySelectorAll('textarea').forEach(e => {
        const maxl = e.getAttribute('maxlength');
        e.targets = baseElement.querySelectorAll(`[for='${e.id}']`);
        if(e.targets.length) {
            let fn = () => {
                for(let x of e.targets) {
                    x.textContent = maxl ? `${e.value.length}/${maxl}` : `${e.value.length}`;
                }
            };
            fn();
            e.onkeyup = fn;
        }
    });
    baseElement.querySelectorAll('[data-localize]').forEach(e => {
        if(e.dataset.localize) {
            e.textContent = e.dataset.localize.lox();
            e.classList.remove('hidden');
        }
    });

    baseElement.querySelectorAll('[data-open-url').forEach(e => {
        const value = e.getAttribute('data-open-url');
        if(value) {
            e.onclick = () => {
                let path = '';
                if(value.split('/')[0].includes('.html')) {
                    // just a direct link to a local file inside the plugin's folder e.g. 'readme.html'
                    sendValueToPlugin(value, 'showInExternalWindow');
                } else if(value.indexOf('http') !== 0) {
                    path = document.location.href.split('/');
                    path.pop();
                    path.push(value.split('/').pop());
                    path = path.join('/');
                } else {
                    path = value;
                }
                if(path !== '') {
                    $SD.api.openUrl($SD.uuid, path);
                }
            };
        } else {
            console.log(`${value} is not a supported url`);
        }
    });
}

const sliderCallback = (obj, styleId) => {
    const percnt = Utils.rangeToPercent(event.target.value, event.target.min, event.target.max);
    let thumbColor, label;

    if(label) {
        label.textContent = event.target.value;
    }

    if(obj.id === 'lights.brightness') {
        thumbColor = Utils.lerpColor('000000', sliderCallback.thumbColor || 'ffffff', percnt);
    } else {
        thumbColor = Utils.lerpColor('94d0ec', 'ffb165', percnt);
    }

    if(styles.hasOwnProperty(event.target.dataset.styleid)) {
        styles[event.target.dataset.styleid].textContent = `input[type="range"][data-styleId="${event.target.dataset.styleid
            }"]::-webkit-slider-thumb {background-image: none; background-color: ${thumbColor};}`;
    }
};

function handleSdpiItemClick(e, idx) {
    /** Following items are containers, so we won't handle clicks on them */
    if(['OL', 'UL', 'TABLE'].includes(e.tagName)) {
        return;
    }

    /** SPANS are used inside a control as 'labels'
     * If a SPAN element calls this function, it has a class of 'clickable' set and is thereby handled as
     * clickable label.
     */

    if(e.tagName === 'SPAN') {
        const inp = e.parentNode.querySelector('input');
        var tmpValue;

        // if there's no attribute set for the span, try to see, if there's a value in the textContent
        // and use it as value
        if(!e.hasAttribute('value')) {
            tmpValue = Number(e.textContent);
            if(typeof tmpValue === 'number' && tmpValue !== null) {
                e.setAttribute('value', 0 + tmpValue); // this is ugly, but setting a value of 0 on a span doesn't do anything
                e.value = tmpValue;
            }
        } else {
            tmpValue = Number(e.getAttribute('value'));
        }

        if(inp && tmpValue !== undefined) {
            inp.value = tmpValue;
        } else return;
    }

    const selectedElements = [];
    const isList = ['LI', 'OL', 'UL', 'DL', 'TD'].includes(e.tagName);
    const sdpiItem = e.closest('.sdpi-item');
    const sdpiItemGroup = e.closest('.sdpi-item-group');
    let sdpiItemChildren = isList
        ? sdpiItem.querySelectorAll(e.tagName === 'LI' ? 'li' : 'td')
        : sdpiItem.querySelectorAll('.sdpi-item-child > input');

    if(isList) {
        const siv = e.closest('.sdpi-item-value');
        if(!siv.classList.contains('multi-select')) {
            for(let x of sdpiItemChildren) x.classList.remove('selected');
        }
        if(!siv.classList.contains('no-select')) {
            e.classList.toggle('selected');
        }
    }

    if(sdpiItemGroup && !sdpiItemChildren.length) {
        for(let x of ['input', 'meter', 'progress']) {
            sdpiItemChildren = sdpiItemGroup.querySelectorAll(x);
            if(sdpiItemChildren.length) break;
        }
    }

    if(e.selectedIndex) {
        idx = e.selectedIndex;
    } else {
        sdpiItemChildren.forEach((ec, i) => {
            if(ec.classList.contains('selected')) {
                selectedElements.push(ec.textContent);
            } else if(ec.checked) {
                selectedElements.push(ec.value);
            }
            if(ec === e) {
                idx = i;

                if(!['radio', 'checkbox'].includes(ec.type)) {
                    selectedElements.push(ec.value);
                } else {
                    e._value = selectedElements;
                }
            }
        });
    }

    const checkKey = (e, key) => {
        return e[key] && e[key].charAt(0) !== '_' ? e[key] : null;
    };

    const returnValue = {
        key: checkKey(e, 'key') ? e.key : checkKey(e, 'id') ? e.id : sdpiItem.id || 'no_key_found',
        value: isList
            ? e.textContent
            : e._value
                ? e._value
                : e.value
                    ? e.type === 'file'
                        ? decodeURIComponent(e.value.replace(/^C:\\fakepath\\/, ''))
                        : e.value
                    : e.getAttribute('value'),
        group: sdpiItemGroup ? sdpiItemGroup.id : false,
        index: idx,
        selection: selectedElements,
        checked: e.checked,
    };

    /** Just simulate the original file-selector:
     * If there's an element of class '.sdpi-file-info'
     * show the filename there
     */
    if(e.type === 'file') {
        const info = sdpiItem.querySelector('.sdpi-file-info');
        if(info) {
            const s = returnValue.value.split('/').pop();
            info.textContent = s.length > 28 ? s.substr(0, 10) + '...' + s.substr(s.length - 10, s.length) : s;
        }
    }
    // console.log({returnValue});
    sendValueToPlugin(returnValue, 'sdpi_collection');
}

/** TEMPLATES */

const createSdpiItem = obj => {
    obj.id = obj['id'] || Utils.randomString(8); // window.btoa(new Date().getTime().toString()).substr(4, 16);
    obj.rnd = `_${Utils.randomString(8)}_`;
    const sdpiItemValue = getTemplate(obj);
    if(obj.type == 'template') return sdpiItemValue;

    return `<div class="sdpi-item" ${obj.type ? `type="${obj.type}"` : ''} id="${obj.id}">
    <div class="sdpi-item-label">${obj.label.lox() || ''}</div>
    ${sdpiItemValue}
    </div>`;
};

// eslint-disable-next-line no-unused-vars
function toggleDisabled(e) {
    const el = event.target;
    const opt = el[el.selectedIndex].textContent;
    const dis = opt.indexOf('<disabled>') === 0;
    if(dis) {
        el.classList.add('disabled');
    } else {
        el.classList.remove('disabled');
    }
}

// eslint-disable-next-line no-unused-vars
const isDisabled = (obj, isArr = 1) => {
    console.log('isDisabled', Object.entries(obj.value)[obj.selected][1 - isArr].indexOf('<disabled>') === 0);
};

const prepareSDPIData = obj => {
    obj.styl = '';
    const starr = [];

    if(!!obj.minIcon || !!obj.maxIcon) {
        let mrgin = !!obj.minIcon ? 4 : 0;
        mrgin = !!obj.maxIcon ? mrgin + 4 : mrgin;
        const w = 224 - 40 - mrgin;
        obj.styl = `style="max-width: ${w}px"`;
        starr.push(`max-width :${w}px`);
    } else if(!!obj.minLabel || !!obj.maxLabel) {
        const mt = Math.floor(Utils.measureText(`${obj.minLabel}${obj.maxLabel}`));
        if(mt > 0) {
            let mrgin = !!obj.minLabel ? 4 : 0;
            mrgin = !!obj.maxLabel ? mrgin + 4 : mrgin;
            const w = 224 - mt - mrgin;
            obj.styl = `style="max-width: ${w}px"`;
            starr.push(`max-width :${w}px`);
        }
    }

    obj.styl = starr.join(';');
    return obj;
};

const objCache = {};

/* eslint no-unreachable: 0 */
function getTemplate(obj) {
    // console.log(obj);
    const tmpId = Utils.randomString(8);

    if(obj.func) {
        // console.log('---FUNCTIONS---', obj.func);
        Object.keys(obj.func).forEach((e,i) => {
            // console.log("installing", i,e,  obj.func[e]);
            window[e] = eval(obj.func[e]);
        })
    }

    if(obj.callbacks) {
        // console.log('---CALLBACKS---', obj.callbacks, obj);
       let callbackArray = [];
        const cbs = obj.callbacks.map(e => {
            callbackArray.push(`${e.when}:${e.name}`);
        });
        obj.cbcks = `data-callbackid="${tmpId}" data-callbacks="${callbackArray.join(',')}"`;
        objCache[tmpId] = obj;
    }

    const isArr = Number(Array.isArray(obj.value));

    switch(obj.type) {
        case 'template':
            return obj.value;
            break;

        case 'select':
            obj.selected = Math.abs(obj.selected);
            const lng = Object.keys(obj.value).length;
            const sel = obj.selected < lng ? String(Object.entries(obj.value)[obj.selected][isArr]) : '';
            const isDisabledItem = !Utils.isEmptyString(sel) && sel.indexOf('<disabled>') === 0 ? 'disabled' : '';
            const convert = value => {
                const sValue = Utils.isNumber(value) ? String(value) : value;
                return value < 0 ? String(sValue).replace('-', '❅ ') : `☼ ${sValue}`;
            };
            const rpl = obj.convert;
            const typeLabel = (obj.typeLabel || 'Accessory').lox();
            if(obj.value && Object.keys(obj.value).length == 0) {
                return `<select class="sdpi-item-value" disabled="disabled" style="color:white;opacity:0.5"><option>${'%s not found'.lox().sprintf(typeLabel)}</option></select>`;
            } else {

                return `<select onchange="toggleDisabled()" class="sdpi-item-value ${isDisabledItem}">${Object.entries(
                    obj.value
                )
                    .map((e, i) => {
                        return `<option value="${e[1 - isArr]}" ${obj.selected === i ? 'selected="selected"' : ''} ${String(e[isArr]).indexOf('<disabled>') === 0 ? 'disabled="disabled"' : ''
                            }>${rpl ? convert(e[isArr]) : e[isArr]} ${obj.valueSuffix || ''}</option>`;
                    })
                    .join('')}</select>`;

            }

            break;

        case 'radio':
        case 'checkbox':
            const showValue = obj.hasOwnProperty('showValue') ? obj.showValue : true;

            return `<div class="sdpi-item-value">${Object.entries(obj.value)
                .map(
                    (e, i) => `
                <div class='sdpi-item-child'>
                    <input type="${obj.type}" id="${obj.rnd + String(i)}" name="${obj.rnd}" value="${e[isArr]}" ${obj.selected.includes(e[isArr]) ? 'checked="checked"' : ''
                        }>
                    <label for="${obj.rnd + String(i)}" class="sdpi-item-label"><span></span>${showValue ? String(e[isArr]).lox() : ''
                        }</label>
                </div>`
                )
                .join('')}</div>`;
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
            prepareSDPIData(obj);
            let stylId = Utils.randomString(8);

            if(obj.callbacks) {
                // console.log(obj);
                const percnt = Utils.rangeToPercent(obj.value.value, obj.value.min, obj.value.max);

                if(obj.device) {
                    const l = obj.device.lights;
                    // const percnt = 1 - Utils.rangeToPercent(l.temperature, l.temperatureMin, l.temperatureMax);
                    const percnt = 1 - Utils.rangeToPercent(l.temperature, 2907, 6993);
                    const bgColor = Utils.lerpColor('94d0ec', 'ffb165', percnt);
                    const n = Utils.injectStyle(
                        `input[type="range"][data-styleId="${stylId}"]::-webkit-slider-runnable-track {background-color: ${bgColor};}`,
                        stylId
                    );
                    sliderCallback.thumbColor = bgColor;
                }

                let thumbColor;
                if(obj.id === 'lights.brightness') {
                    thumbColor = Utils.lerpColor('000000', sliderCallback.thumbColor || 'ffffff', percnt);
                } else {
                    thumbColor = Utils.lerpColor('94d0ec', 'ffb165', percnt);
                }
                let styleNode = Utils.injectStyle(
                    `input[type="range"][data-styleId="${stylId}"]::-webkit-slider-thumb {background-image: none; background-color: ${thumbColor};}`,
                    stylId
                );
                styles[stylId] = styleNode;
            }

            if(obj.reverse) {
                return `<div class="sdpi-item-value">
                ${!!obj.maxLabel || !!obj.maxIcon
                        ? `<span class="clickable ${obj.maxIcon || ''}" value="${obj.value.max || 100}">${obj.maxIcon ? '' : obj.maxLabel || obj.value.max || 100
                        }</span>`
                        : ''
                    }
                <input type="range" data-styleId="${stylId}" ${obj.styl} ${obj.callback ||
                    ''} class="reverse" min="${obj.value.min || 0}" max="${obj.value.max || 100}" value="${obj.value
                        .value || 50}">
                ${!!obj.minLabel || !!obj.minIcon
                        ? `<span class="clickable ${obj.minIcon || ''}" value="${obj.value.min || 0}">${obj.minIcon ? '' : obj.minLabel || obj.value.min || 0
                        }</span>`
                        : ''
                    }
            <label for="${stylId}ID" data-labelcallback="${obj.labelCallback ||
                    ''}" class="rangeLabel ${obj.classLabel || ''}">&nbsp;</label>
            </div>`;
            } else {
                return `<div class="sdpi-item-value" data-sendevent="${obj.sendEvent ? obj.sendEvent : ''}">
                ${!!obj.minLabel || !!obj.minIcon
                        ? `<span class="clickable ${obj.minIcon || ''}" value="${obj.value.min || 0}">${obj.minIcon ? '' : obj.minLabel || obj.value.min || 0
                        }</span>`
                        : ''
                    }
                <input type="range" ${obj.test ? obj.test : ''} ${obj.cbcks ? obj.cbcks : ''
                    } data-labelID="${stylId}ID" data-styleId="${stylId}" ${obj.class ? 'class = ' + obj.class : ''} ${obj.styl
                    }  min="${obj.value.min || 0}" max="${obj.value.max || 100}" value="${obj.value.value || 50}">
                ${!!obj.maxLabel || !!obj.maxIcon
                        ? `<span class="clickable ${obj.maxIcon || ''}" value="${obj.value.max || 100}">${obj.maxIcon ? '' : obj.maxLabel || obj.value.max || 100
                        }</span>`
                        : ''
                    }
                <label for="${stylId}ID" data-labelcallback="${obj.labelCallback ||
                    ''}" class="rangeLabel ${obj.classLabel || ''}">&nbsp;</label>
                </div>`;
            }
            break;

        case 'range reverse':
            break;

        default:
            return '<input class="sdpi-item-value" type="text" value="">';
            break;
    }
}

// <input type="range" data-labelID="${stylId}ID" data-styleId="${stylId}" ${obj.class ? "class = " + obj.class : ''} ${obj.styl}  ${obj.callback || ''} min="${obj.value.min || 0}" max="${obj.value.max || 100}" value="${obj.value.value || 50}">

function sdpiCreateItem(obj, el, cb) {
    if(el) {
        if(obj.type == 'template') {
            el.insertAdjacentHTML('beforeend', createSdpiItem(obj));
        } else {
            const newEl = document.createElement('div');
            newEl.innerHTML = createSdpiItem(obj);
            el.appendChild(newEl.firstChild);
        }
    }
}

// eslint-disable-next-line no-unused-vars
function localizeUI() {
    const el = document.querySelector('.sdpi-wrapper') || document;
    let t;
    Array.from(el.querySelectorAll('sdpi-item-label')).forEach(e => {
        t = e.textContent.lox();
        if(e !== t) {
            e.innerHTML = e.innerHTML.replace(e.textContent, t);
        }
    });
    Array.from(el.querySelectorAll('*:not(script)')).forEach(e => {
        if(
            e.childNodes &&
            e.childNodes.length > 0 &&
            e.childNodes[0].nodeValue &&
            typeof e.childNodes[0].nodeValue === 'string'
        ) {
            t = e.childNodes[0].nodeValue.lox();
            if(e.childNodes[0].nodeValue !== t) {
                e.childNodes[0].nodeValue = t;
            }
        }
    });
}

function toggleCpHeight(e) {
    const el = document.querySelector('[type="color-picker"]');
    if(!el) return;

    const arr = ['single', 'double', 'triple'];
    const otherSize = event.altKey ? 'triple' : 'double';
    const isSingleHeight = el.classList.contains('single');
    arr.forEach(e => el.classList.remove(e));

    if(isSingleHeight) {
        el.classList.add(otherSize);
    } else {
        el.classList.add('single');
    }
}
