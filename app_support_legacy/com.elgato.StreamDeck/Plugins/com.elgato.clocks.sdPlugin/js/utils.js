const Utils = {};
Utils.setDbg = (inPrefix = 'Utils', inColor = '#0f0') => {
    const prefix = `%c[${inPrefix}]`;
    const errorPrefix = `%c[${inPrefix} Error]`;
    const color = `color: ${inColor}`;
    const dbgFn = (message, ...args) => {
        console.log(prefix, color, message, ...args);
    };
    dbgFn.error = (message, ...args) => {
        console.error(errorPrefix, color, message, ...args);
    };
    return dbgFn;
};

Utils.dbg = console.log.bind(
    console,
    '%c [Utils]',
    'color: #66c',
);

Utils.initDbg = (options = {debug: true, prefix: 'Utils', color: '#0c0'}) => {
    const color = options.color || Utils.getRandomLightColor();
    const prefix = options.prefix || '[DEBUG]';
    let fn = () => {};
    if(options.debug) {
        fn = console.log.bind(
            console,
            `%c ${prefix}`,
            `color: ${color}`
        );
        fn.info = console.info.bind(
            console,
            `%c ${prefix}[INFO]`,
            `color: ${color}`
        );
    } else {
        fn.info = () => {};
    }
    fn.error = console.error.bind(
        console,
        `%c ${prefix}`,
        `color: 'red'`
    );
    return fn;
};

Utils.cycle = (idx, max) =>  (idx > max ? 0 : idx < 0 ? max : idx);

// Utils.dbg = (message, ...args) => {
//     console.log('%c[Utils]', 'color: #995', message, ...args);
// };

// Utils.proxify = (obj, callback, deleteCallback) => {
//     const pLog = (message, ...args) => {
//         // return;
//         console.log('%c[Proxy]', 'color: #797', message, ...args);
//     };
//     const compareArray = (arr, arr2) => {
//         return (
//             Array.isArray(arr) && Array.isArray(arr2) && arr.length === arr2.length &&
//             arr.every((value, index) => value === arr2[index])
//         );
//     };
//     const compareObject = (obj, obj2) => {
//         return (
//             typeof obj === 'object' && typeof obj2 === 'object' &&
//             Object.keys(obj).length === Object.keys(obj2).length &&
//             Object.keys(obj).every((key) => {
//                 return obj[key] === obj2[key];
//             })
//         );
//     };
//     const compare = (obj, obj2) => {
//         if(Array.isArray(obj)) {
//             return compareArray(obj, obj2);
//         }
//         if(typeof obj === 'object') {
//             return compareObject(obj, obj2);
//         }
//         return obj === obj2;
//     };

//     const handler = {
//         get: (o, k, receiver) => {
//             if(!(k in o)) {
//                 // console.log('[proxify]::Not found in Proxy', k, o, receiver);
//                 // o[k] = new Proxy({}, handler);  // shield, if we  must ensure a value e.g when setting 'a.b.c.d = <something>'
//                 // o[k] = Utils.proxify({}, handler);  // shield, if we  must ensure a value e.g when setting 'a.b.c.d = <something>'
//                 // o[k] = Utils.proxify({}, callback, deleteCallback);  // shield, if we  must ensure a value e.g when setting 'a.b.c.d = <something>'
//                 // o[k] = Utils.proxify({}, callback, deleteCallback); 
//                 console.log('Proxy::create new prop', k, o, o[k], callback, typeof callback);
//                 if(callback && typeof callback === 'function') callback(o, k, o[k]);

//                 return o[k];
//                 return false;
//             }
//             const value = Reflect.get(o, k, receiver);
//             pLog('get', k in o, k, value);
//             if(value && typeof value === 'object' && !(k in o)) {
//                 pLog('proxifying new value', k in o, k, value);
//                 return Utils.proxify(value, callback, deleteCallback); //new Proxy(value, handler);
//             }
//             return value;
//         },
//         set: (o, k, v, receiver) => {
//             pLog('set', k in o, k, v, o, receiver);
//             let res = false;
//             let equal = false;
//             if(Array.isArray(o[k]) && Array.isArray(v)) {
//                 equal = compareArray(o[k], v);
//             } else if(typeof o[k] === 'object' && typeof v === 'object') {
//                 equal = compareObject(o[k], v);
//             } else {
//                 equal = o[k] === v;
//             }
//             // let equal = Array.isArray(o[k]) ? compareArray(o[k], v) : o[k] === v;

//             if(!equal || !(k in o)) {
//                 pLog('set:not equal:', k, v, callback);
//                 res = Reflect.set(o, k, v, receiver);
//                 if(callback && typeof callback === 'function') callback(o, k, v);
//             }
//             return res === true;
//         },
//         deleteProperty(o, k) {
//             if(k in o) {
//                 delete o[k];
//                 if(deleteCallback && typeof deleteCallback === 'function') deleteCallback(o, k);
//             }
//         }
//     };
//     const p = new Proxy(obj, handler);
//     // if(callback) callback(p);
//     return p;
// };

Utils.printf = (str, ...args) => {
    return str.replace(/{(\d+)}/g, (match, number) => {
        return typeof args[number] != 'undefined' ? args[number] : match;
    });
};

Utils.padNum = (num, padCount = 2) => {
    return num.toString().padStart(padCount, '0');
};

Utils.rs = Utils.randomString = (len = 8) => [...Array(len)].map(i => (~~(Math.random() * 36)).toString(36)).join('');
Utils.minmax = (v = 0, min = 0, max = 100) => Math.min(max, Math.max(min, v));
Utils.getRandomColor = function() {
    return '#' + (((1 << 24) * Math.random()) | 0).toString(16).padStart(6, 0); // just a random color padded to 6 characters
};
Utils.getRandomLightColor = () => {
    const hx = () => Math.floor(((1 + Math.random()) * Math.pow(16, 2)) / 2).toString(16).padStart(2, '0').slice(-2);
    return `#${[0,1,2].map(hx).join('')}`;
};

Utils.loadJSON = (path, defaultReturn = {}) => {
    return new Promise((resolve, reject) => {
        Utils.fetchXhr(path, 'json')
            .then((response) => {
                if(response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok.');
            })
            .then((json) => {
                resolve(json);
            })
            .catch((error) => {
                reject(error);
            });
    }).catch((error) => {
        console.info(error);
        return defaultReturn;
    });
};

Utils.fetchXhr = (path = '', type = 'arraybuffer') => {
    return new Promise(function(resolve, reject) {
        const req = new XMLHttpRequest();
        req.withCredentials = false; // should be default anyway
        req.responseType = type;
        req.onload = () => {
            resolve({
                ok: true,
                status: 200,
                [type]: () => Promise.resolve(req.response),
                // arrayBuffer: () => Promise.resolve(req.response),
                // blob: () => Promise.resolve(req.response)
            });
        };

        ['abort', 'error'].forEach((evt) => {req.addEventListener(evt, (error) => {reject(error);});});
        req.open('GET', path);
        req.send();
    });
};

Utils.isBoolean = (v) => {
    return typeof v === 'boolean' || v == 'true' || v == true || v == '1';
};

Utils.isAFunction = (newLayout) => {
    const detectFunctionRegExp = new RegExp(/^(?:[\s]+)?(?:const|let|var|)?(?:[a-z0-9.]+(?:\.prototype)?)?(?:\s)?(?:[a-z0-9-_]+\s?=)?\s?(?:[a-z0-9]+\s+\:\s+)?(?:function\s?)?(?:[a-z0-9_-]+)?\s?\(.*\)\s?(?:.+)?([=>]:)?\{(?:(?:[^}{]+|\{(?:[^}{]+|\{[^}{]*\})*\})*\}(?:\s?\(.*\)\s?\)\s?)?)?(?:\;)?/);

    let isAFunction = typeof newLayout === 'function' || newLayout.startsWith('()') || newLayout.startsWith('function');
    if(!isAFunction) {
        isAFunction = detectFunctionRegExp.test(newLayout);
    }
    return isAFunction;
};

Utils.rectInBounds = (rect, bounds, scaleMode) => {
    var hScale = bounds.width / rect.width;
    var vScale = bounds.height / rect.height;
    if(scaleMode == "fit") return Math.min(vScale, hScale);
    if(scaleMode == "width") return hScale;
    if(scaleMode == "height" || hScale > vScale) return vScale;
    return hScale;
};

Utils.rectToBounds = (rect, bounds) => {
    var rectRatio = rect.width / rect.height;
    var boundsRatio = bounds.width / bounds.height;

    var newDimensions = {};

    // Rect is more landscape than bounds - fit to width
    if(rectRatio > boundsRatio) {
        newDimensions.width = bounds.width;
        newDimensions.height = rect.height * (bounds.width / rect.width);
    }
    // Rect is more portrait than bounds - fit to height
    else {
        newDimensions.width = rect.width * (bounds.height / rect.height);
        newDimensions.height = bounds.height;
    }

    return newDimensions;
};


Utils.getElementOffset = (el) => {
    let left = 0;
    let top = 0;
    if(el) {
        while(el && !isNaN(el.offsetLeft) && !isNaN(el.offsetTop)) {
            left += el.offsetLeft - el.scrollLeft;
            left += el.offsetTop - el.scrollTop;
            el = el.offsetParent;
        }
    }
    return {left, top, l: left, t: top};
};

Utils.getElementCoords = (el) => {
    const rect = el.getBoundingClientRect();
    return {
        top: rect.top + window.pageYOffset,
        right: rect.right + window.pageXOffset,
        bottom: rect.bottom + window.pageYOffset,
        left: rect.left + window.pageXOffset,
        width: rect.width,
        height: rect.height
    };
};

/* UTILS */

Utils.diff = (a, b) => {
    const isDate = d => d instanceof Date;
    const isEmpty = o => Object.keys(o).length === 0;
    const isObject = o => o != null && typeof o === 'object';
    const hasOwnProperty = (o, ...args) => Object.prototype.hasOwnProperty.call(o, ...args);
    const isEmptyObject = (o) => isObject(o) && isEmpty(o);

    // https://github.com/mattphillips/deep-object-diff/blob/main/src/diff.js
    const diff = (lhs, rhs) => {
        if(lhs === rhs) return {}; // equal return no diff

        if(!isObject(lhs) || !isObject(rhs)) return rhs; // return updated rhs

        const l = lhs;
        const r = rhs;

        const deletedValues = Object.keys(l).reduce((acc, key) => {
            if(!hasOwnProperty(r, key)) {
                acc[key] = undefined;
            }
            return acc;
        }, {});

        return Object.keys(r).reduce((acc, key) => {
            if(!hasOwnProperty(l, key)) {
                acc[key] = r[key]; // return added r key
                return acc;
            }

            const difference = diff(l[key], r[key]);

            // If the difference is empty, and the lhs is an empty object or the rhs is not an empty object
            if(isEmptyObject(difference) && !isDate(difference) && (isEmptyObject(l[key]) || !isEmptyObject(r[key])))
                return acc; // return no diff

            acc[key] = difference; // return updated key
            return acc; // return updated key
        }, deletedValues);
    };

    return diff(a, b);
};

Utils.diffString = (a, b) => {
    if(!a || !b) return '';
    let diff = "";
    b.split('').forEach(function(val, i) {
        if(val != a.charAt(i))
            diff += val;
    });
    return diff;
};

Utils.getProp = (jsn, str, defaultValue = {}, sep = '.') => {
    const arr = str.split(sep);
    return arr.reduce((obj, key) => (obj && obj.hasOwnProperty(key) ? obj[key] : defaultValue), jsn);
};

Utils.setProp2 = function(obj, value, propPath) { // use 'function' to avoid falsy 'this'
    const [head, ...rest] = propPath.split('.');
    !rest.length
        ? obj[head] = value
        : this.setProp2(obj[head], value, rest.join('.'));
};



Utils.setProp = function(jsonObj, path, value) {
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

Utils.flatten = function(obj, prefix = '') {
    return Object.keys(obj).reduce((acc, k) => {
        const pre = prefix.length ? `${prefix}.` : '';
        if(typeof obj[k] === 'object' && obj[k] !== null && Object.keys(obj[k]).length > 0) {
            Object.assign(acc, Utils.flatten(obj[k], pre + k));
        } else {
            acc[pre + k] = obj[k];
        }
        return acc;
    }, {});
};

/**
* Performs a deep merge of objects and returns new object. Does not modify
* objects (immutable) and merges arrays via concatenation.
*
* @param {...object} objects - Objects to merge
* @returns {object} New object with merged key/values
* https://stackoverflow.com/questions/27936772/how-to-deep-merge-instead-of-shallow-merge
*/
Utils.combine = function(...objects) {
    // const isObject = obj => obj && typeof obj === 'object';
    const isObject = obj => obj && typeof obj === 'object' && !Array.isArray(obj);
    // const isObject = obj => (obj+"") === "[object Object]";
    return objects.reduce((prev, obj) => {
        // if(!isObject(obj)) return prev;
        Object.keys(obj).forEach(key => {
            const pVal = prev[key];
            const oVal = obj[key];

            if(Array.isArray(pVal) && Array.isArray(oVal)) {
                // prev[key] = pVal.concat(...oVal);
                prev[key] = [...pVal, ...oVal].filter((element, index, array) => array.indexOf(element) === index);
            }
            else if(isObject(pVal) && isObject(oVal)) {
                prev[key] = Utils.combine(pVal, oVal);
            }
            else {
                prev[key] = oVal;
            }
        });

        return prev;
    }, {});
};

Utils.merge = function(current, updates) {
    for(key of Object.keys(updates)) {
        if(!current.hasOwnProperty(key) || typeof updates[key] !== 'object') current[key] = updates[key];
        else Utils.merge(current[key], updates[key]);
    }
    return current;
};

Utils.copyToClipboardOld = str => {
    if(navigator && navigator.clipboard && navigator.clipboard.writeText)
        return navigator.clipboard.writeText(str);
    return Promise.reject('The Clipboard API is not available.');
};

Utils.isValidDate = (...val) => !Number.isNaN(new Date(...val).valueOf());
Utils.dateToTime = date => date.toTimeString().slice(0, 8);

Utils.detectLanguage = (defaultLang = 'en-US') =>
    navigator.language ||
    (Array.isArray(navigator.languages) && navigator.languages[0]) ||
    defaultLang;

Utils.splitCamelCase = str => str.replace(/([a-z])([A-Z])/g, '$1 $2');
// .replace(/([A-Z])/g, ' $1')
//     .replace(/^./, function(str){ return str.toUpperCase(); })

Utils.utf8_to_latin1 = (s) => unescape(encodeURIComponent(s));

Utils.capitalize = (string) => string.charAt(0).toUpperCase() + string.slice(1);

Utils.stripSpecials = (s) => s.replace(/[` ~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, '').trim();
Utils.xor = (s, key='123456') => Array.from(s,(c, i) => String.fromCharCode(c.charCodeAt() ^ key.charCodeAt(i % key.length))).join('');
Utils.encodeString = (s) => encodeURIComponent(s);
Utils.decodeString = (s) => decodeURIComponent(s);
Utils.copyToClipboard = async (text='', targetSelector, fn) => {
    const el = targetSelector && document.querySelector(targetSelector);
    console.log("copyToClipboard", text, targetSelector, el);
    let msg = '';
    try {
      await navigator.clipboard.writeText(text);
      msg = 'Successfully copied to clipboard';
     
    } catch (err) {
      console.error('Copying to clipboard failed: ', err);
      msg = 'Copying to clipboard failed: ';
    }
    if(el) {
        document.querySelector(targetSelector).innerText = msg;
        setTimeout(() => {
            el.innerText = text;
            if(fn) fn(text);
        }, 1500);
      }
  }
  Utils.isJsonString = (text) => {
    if (typeof text !== "string") {
        return false;
    }
    try {
        JSON.parse(text);
        return true;
    } catch (error) {
        return false;
    }
}
/* SVG */
// Utils.stringToSVG(`<svg>${app.store.state.layouts[10].layout}</svg>`)
Utils.stringToSVG = (svgString) => {
    // console.log("stringToSVG", typeof svgString, svgString);
    const needsContainer = (s) => {
        if(typeof svgString != "string") {
            if(svgString.startsWith('<?xml') || svgString.startsWith('<svg')) return false;
            return true;
        }
        return false;
    };

    if(!svgString) return null;
    // if(typeof svgString === "string") {
    // svgString = needsContainer(svgString) ?  `<svg>${svgString}</svg>` : svgString; // fix svg fragments
    // }
    // console.log("stringToSVG2", typeof svgString, svgString);
    const doc = new DOMParser().parseFromString(
        svgString,
        "image/svg+xml"
    );
    const svg = doc.querySelector('svg') || {};
    // console.log({doc, svg: svg.firstElementChild.outerHTML});
    return svg;
};

Utils.svgToString = (svg) => {
    if(!svg) return null;
    return svg.outerHTML;
};

Utils.parseSVG = (svg) => {
    const s = new XMLSerializer();
    return s.serializeToString(svg).replaceAll(' xmlns="http://www.w3.org/1999/xhtml"', '');
};

Utils.nodeListToString = (nodeList) => {
    return Array.from(nodeList).reduce((prev, cur) => prev + cur.outerHTML, "");
    //    return Array.from(nodeList).reduce((prev, cur) => console.log({prev,cur}) || prev + cur.outerHTML, s)
};

Utils.s2c = (svg, inCanvas, inContext, w, h, callback) => {
    const img = new Image();
    img.onload = function() {
        let cnv = inCanvas || document.createElement('canvas');
        let ctx = inContext || cnv.getContext('2d');
        cnv.width = w || img.naturalWidth;
        cnv.height = h || img.naturalHeight;
        ctx.clearRect(0, 0, cnv.width, cnv.height);
        ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, w, h);
        // console.log("img w/h:", w, h, img.naturalWidth, img.naturalHeight);
        if(callback) callback(this, cnv.toDataURL('image/png'));
    };
    img.src = svg;
};

Utils.rectToPath = (rect) => {
    const x = parseFloat(rect.left, 10);
    const y = parseFloat(rect.top, 10);
    const width = parseFloat(rect.width, 10);
    const height = parseFloat(rect.height, 10);

    if(x < 0 || y < 0 || width < 0 || height < 0) {
        return '';
    }

    return 'M' + x + ',' + y + 'L' + (x + width) + ',' + y + ' ' + (x + width) + ',' + (y + height) + ' ' + x + ',' + (y + height) + 'z';
};

Utils.boundsToPath = (left, top, width, height) => {
    return Utils.rectToPath({left, top, width, height});
};

// const pointInRect = (p, r) => r.x <= p.x && p.x <= r.x + r.width && r.y <= p.y && p.y <= r.y + r.height;
// const pointInRect2 = function(x, y, r) {
//     // console.log(x, y, r, r.y + r.height, r.x <= x, x <= r.x + r.width, r.y <= y, y <= r.y + r.height);
//     return r.x <= x && (x <= r.x + r.width) && r.y <= y && (y <= r.y + r.height);
// };


/* HTML VERIFICATION  */

Utils.isValidType = (obj) => {
    let isHTMLElement = obj instanceof HTMLElement ||
        obj instanceof DocumentFragment ||
        obj instanceof Document ||
        obj instanceof DocumentType ||
        obj instanceof Node ||
        obj instanceof Window ||
        obj instanceof HTMLDocument ||
        obj instanceof CanvasRenderingContext2D ||
        obj instanceof SVGElement ||
        obj instanceof HTMLCollection ||
        obj instanceof HTMLAllCollection ||
        obj instanceof NodeList ||
        obj instanceof NamedNodeMap ||
        obj instanceof HTMLOptionsCollection ||
        obj instanceof HTMLFormElement ||
        obj instanceof HTMLSelectElement ||
        obj instanceof HTMLInputElement ||
        obj instanceof HTMLTextAreaElement ||
        obj instanceof HTMLButtonElement ||
        obj instanceof HTMLAnchorElement;
    const ok = obj !== null && typeof obj != 'function' && typeof obj === 'object' && !(isHTMLElement);
    if(typeof obj == 'function') {
        isHTMLElement = false;
    }
    return {ok, isHTMLElement};
};


/* UTILS */

// Utils.stringToHTML = (htmlString, type='div') => {
//     const div = document.createElement(type);
//     div.innerHTML = htmlString.trim();
//     return div.firstChild; 
//   }

Utils.stringToHTML = (html, all = false, type = 'div') => {
    var template = document.createElement('template');
    template.innerHTML = html.trim();
    return all ? template.content : template.content.firstChild;
};

Utils.getUrlParameter = function(name) {
    const nameA = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    const regex = new RegExp('[\\?&]' + nameA + '=([^&#]*)');
    const results = regex.exec(location.search.replace(/\/$/, ''));
    return results === null ? null : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

Utils.getUrlParameters = (url) => Object.fromEntries(url.split('?')[1].split('&').map(e => e.split('=')));

Utils.getURLParametersAsObject = url =>
    (url.match(/([^?=&]+)(=([^&]*))/g) || []).reduce(
        (a, v) => (
            (a[v.slice(0, v.indexOf('='))] = v.slice(v.indexOf('=') + 1)), a
        ),
        {}
    );

Utils.randomUUID = () => crypto.randomUUID();

Utils.generateUUID = function() {
    return new Array(4)
        .fill(0)
        .map(() => Math.floor(Math.random() * Number.MAX_SAFE_INTEGER).toString(16))
        .join("-");
};

Utils.generateUUIDCrypto = () =>
    ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, c =>
        (
            c ^
            (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))
        ).toString(16)
    );

Utils.nextMidnight = (offset) => {
    const now = new Date();
    const midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
    if(offset) {
        midnight.setTime((midnight.getTime() - 1000 * 60 * 60 * 1) + 1 * 1000); // 1 hour offset + 1 second to count to 00:00:00 instead of 23:59:59
    }
    return midnight;
};


function getColor(str) {
    // if(!Utils.MCTX) {console.log('no mctx - creating a temp context');};
    if(!Utils.MCTX) Utils.MCTX = document.createElement("canvas").getContext("2d");
    Utils.MCTX.fillStyle = str;
    // console.log("Utils.getColor", str, Utils.MCTX.fillStyle);
    return Utils.MCTX.fillStyle;
}

// Utils.getColor = (str) => {
//     if(!Utils.__tempCtx) Utils.__tempCtx = document.createElement("canvas").getContext("2d");
//     Utils.__tempCtx.canvas.fillStyle = str;
//     console.log("Utils.getColor", str, " => ", Utils.__tempCtx.canvas.fillStyle, Utils.__tempCtx);
//     return Utils.__tempCtx.canvas.fillStyle;
// };

Utils.getColor = getColor;

Utils.invertColor = (hexColor) => `#${(Number(`0x1${hexColor.slice(1)}`) ^ 0xFFFFFF).toString(16).slice(1).toUpperCase()}`;


Utils.test = () => {
    console.log("Utils.test()", this, Utils);
};

Utils.readFile = (file, type = "text") => {
    return new Promise(function(resolve, reject) {
        const reader = new FileReader();
        reader.onload = function(e) {
            if(type == 'text') {
                resolve(e.target.result);
            } else {
                const img = new Image();
                img.onload = function() {
                    // doc.innerHTML = `<img src="${e.target.result}" width="${this.width}" height="${this.height}" x="0" y="0" />`;
                    resolve(e.target.result);
                };
                img.src = e.target.result;
            }

        };
        if(type == 'text') {
            reader.readAsText(file);
        } else {
            reader.readAsDataURL(file);
        }
    });
};

Utils.download = (data, filename, type) => {
    const file = new Blob([data], {type: type});
    if(window.navigator.msSaveOrOpenBlob) // IE10+
        window.navigator.msSaveOrOpenBlob(file, filename);
    else { // Others
        const a = document.createElement("a"),
            url = URL.createObjectURL(file);
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }, 0);
    }
};

Utils.downloadViaXhr = (url, filename) => {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = 'blob';
    xhr.onload = function(e) {
        if(this.status == 200) {
            const blob = this.response;
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = filename;
            link.click();
        }
    };
    xhr.send();
};

// function download (url, name, opts) {
//     var xhr = new XMLHttpRequest()
//     xhr.open('GET', url)
//     xhr.responseType = 'blob'
//     xhr.onload = function () {
//       saveAs(xhr.response, name, opts)
//     }
//     xhr.onerror = function () {
//       console.error('could not download file')
//     }
//     xhr.send()
//   }


Utils.scaleImage = (src, w, h) => {
    return new Promise(function(resolve, reject) {
        const img = new Image();
        img.onload = function() {
            const canvas = document.createElement('canvas');
            canvas.width = w;
            canvas.height = h;
            const ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0, w, h);
            resolve(canvas.toDataURL('image/png'));
        };
        img.src = src;
    });
};

Utils.throttle = function(fn, threshold = 250, context) {
    let last, timer;
    return function() {
        var ctx = context || this;
        var now = new Date().getTime(),
            args = arguments;
        if(last && now < last + threshold) {
            clearTimeout(timer);
            timer = setTimeout(function() {
                last = now;
                fn.apply(ctx, args);
            }, threshold);
        } else {
            last = now;
            fn.apply(ctx, args);
        }
    };
};

Utils.debounce = (callback, time = 800) => {
    let timer;
    return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => callback(...args), time);
    };
};

Utils.beep = () => {
    const audio = new Audio('data:audio/wav;base64,UklGRjIAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YQAAAAA=');
    audio.play();
};

Utils.beep2 = () => {
    (new
        Audio(
            "data:audio/wav;base64,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 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////VEFHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU291bmRib3kuZGUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMjAwNGh0dHA6Ly93d3cuc291bmRib3kuZGUAAAAAAAAAACU="
        )).play();
};

Utils.vbeep = (ms = 50, frequency = 660, volume = 0.2, type = 'square', callback) => {
    const context = new AudioContext();
    const oscillator = context.createOscillator();
    const gainNode = context.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(context.destination);

    if(volume) {gainNode.gain.value = volume;}
    if(frequency) {oscillator.frequency.value = frequency;}
    if(type) {oscillator.type = type;}
    if(callback) {oscillator.onended = callback;}

    oscillator.start(context.currentTime);
    oscillator.stop(context.currentTime + (ms / 1000));
}

Utils.createAudioContext = (ms = 50, frequency = 660, volume = 0.2, type = 'square', callback) => {
    const context = new AudioContext();
    return context;
}

Utils.playAudioContext = (context, ms = 50, frequency = 660, volume = 0.2, type = 'square', callback) => {
    if(!context) return;
    const oscillator = context.createOscillator();
    const gainNode = context.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(context.destination);

    gainNode.gain.value = volume;
    oscillator.frequency.value = frequency;
    oscillator.type = type;
    if(callback) {oscillator.onended = callback;}
    oscillator.start(oscillator.context.currentTime);
    oscillator.stop(oscillator.context.currentTime + (ms / 1000));
}



/*  ---  TESTS --- */
/*
const matches = (obj, source) => Object.keys(source).every(key => obj.hasOwnProperty(key) && obj[key] === source[key]);

function getDifference(array1, array2) {
    return array1.filter(object1 => {
        return !array2.some(object2 => {
            return object1.id === object2.id;
        });
    });
}

async scaleImage(fileImage: Object, originalWidth: number, originalHeight: number) {

  return new Promise((resolve) => {

    const imageURL = URL.createObjectURL(fileImage);

    const image = new Image();

    image.onload = () => {
      const scaleFactor = Math.max(originalWidth, originalHeight) / 1000;

      const canvas = document.createElement('canvas');
      canvas.width = originalWidth;
      canvas.height = originalHeight;

      const scaledWidth = Math.floor(originalWidth / scaleFactor);
      const scaledHeight = Math.floor(originalHeight / scaleFactor);

      const ctx = canvas.getContext('2d');
      ctx.drawImage(image, 0, 0, scaledWidth, scaledHeight);

      const base64 = canvas.toDataURL('image/jpeg');
      resolve(base64.substr(23));
    }

    image.src = imageURL;

  });
}

*/

