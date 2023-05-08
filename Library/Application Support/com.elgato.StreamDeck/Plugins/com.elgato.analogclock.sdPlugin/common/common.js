/* global $SD, $localizedStrings */
/* exported, $localizedStrings */
/* eslint no-undef: "error",
  curly: 0,
  no-caller: 0,
  wrap-iife: 0,
  one-var: 0,
  no-var: 0,
  vars-on-top: 0,
  quotes: ["error", "single"]
*/
/*eslint-env es6*/

// don't change this to let or const, because we rely on var's hoisting
// eslint-disable-next-line no-use-before-define, no-var
var $localizedStrings = $localizedStrings || {},
    REMOTESETTINGS = REMOTESETTINGS || {},
    DestinationEnum = Object.freeze({
        HARDWARE_AND_SOFTWARE: 0,
        HARDWARE_ONLY: 1,
        SOFTWARE_ONLY: 2
    }),
    // eslint-disable-next-line no-unused-vars
    isQT = navigator.appVersion.includes('QtWebEngine'),
    debug = debug || false,
    debugLog = function () {};

const setDebugOutput = debug => (debug === true ? console.log.bind(window.console) : function() {});
debugLog = setDebugOutput(debug);

// Create a wrapper to allow passing JSON to the socket
WebSocket.prototype.sendJSON = function (jsn, log) {
    if (log) {
        console.log('SendJSON', this, jsn);
    }
    // if (this.readyState) {
    this.send(JSON.stringify(jsn));
    // }
};

/* eslint no-extend-native: ["error", { "exceptions": ["String"] }] */
String.prototype.lox = function () {
    var a = String(this);
    try {
        a = $localizedStrings[a] || a;
    } catch (b) {}
    return a;
};

String.prototype.sprintf = function (inArr) {
    let i = 0;
    const args = inArr && Array.isArray(inArr) ? inArr : arguments;
    return this.replace(/%s/g, function () {
        return args[i++];
    });
};

// eslint-disable-next-line no-unused-vars
const sprintf = (s, ...args) => {
    let i = 0;
    return s.replace(/%s/g, function () {
        return args[i++];
    });
};

const loadLocalization = (lang, pathPrefix, cb) => {
    Utils.readJson(`${pathPrefix}${lang}.json`, function (jsn) {
        const manifest = Utils.parseJson(jsn);
        $localizedStrings = manifest && manifest.hasOwnProperty('Localization') ? manifest['Localization'] : {};
        debugLog($localizedStrings);
        if(cb && typeof cb === 'function') cb();
    });
};

var Utils = {
    sleep: function(milliseconds) {
        return new Promise(resolve => setTimeout(resolve, milliseconds));
    },
    isUndefined: function (value) {
        return typeof value === 'undefined';
    },
    isObject: function (o) {
        return typeof o === 'object' && o !== null && o.constructor && o.constructor === Object;
    },
    isPlainObject: function (o) {
        return typeof o === 'object' && o !== null && o.constructor && o.constructor === Object;
    },
    isArray: function (value) {
        return Array.isArray(value);
    },
    isNumber: function (value) {
        return typeof value === 'number' && value !== null;
    },
    isInteger (value) {
        return typeof value === 'number' && value === Number(value);
    },
    isString (value) {
        return typeof value === 'string';
    },
    isImage (value) {
        return value instanceof HTMLImageElement;
    },
    isCanvas (value) {
        return value instanceof HTMLCanvasElement;
    },
    isValue: function (value) {
        return !this.isObject(value) && !this.isArray(value);
    },
    isNull: function (value) {
        return value === null;
    },
    toInteger: function (value) {
        const INFINITY = 1 / 0,
            MAX_INTEGER = 1.7976931348623157e308;
        if (!value) {
            return value === 0 ? value : 0;
        }
        value = Number(value);
        if (value === INFINITY || value === -INFINITY) {
            const sign = value < 0 ? -1 : 1;
            return sign * MAX_INTEGER;
        }
        return value === value ? value : 0;
    }
};
Utils.minmax = function (v, min = 0, max = 100) {
    return Math.min(max, Math.max(min, v));
};

Utils.unique = function(arr) {
    return Array.from(new Set(arr));
};

Utils.transformValue = function(prcnt, min, max) {
    return Math.round(((max - min) * prcnt) / 100 + min);
};

Utils.rangeToPercent = function(value, min, max) {
    return (value - min) / (max - min);
};

Utils.percentToRange = function(percent, min, max) {
    return (max - min) * percent + min;
};

Utils.setDebugOutput = debug => {
    return debug === true ? console.log.bind(window.console) : function() {};
};

Utils.randomComponentName = function (len = 6) {
    return `${Utils.randomLowerString(len)}-${Utils.randomLowerString(len)}`;
};

Utils.shuffleArray = arr => {
    let i, j, tmp;
    for(i = arr.length - 1;i > 0;i--) {
        j = Math.floor(Math.random() * (i + 1));
        tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
    return a;
};

Utils.randomElementFromArray = arr => {
    return arr[Math.floor(Math.random() * arr.length)];
};

Utils.arrayToObject = (arr, key) => {
    arr.reduce((obj, item) => {
        obj[item[key]] = item;
        return obj;
    }, {});
};

Utils.randomString = function (len = 8) {
    return Array.apply(0, Array(len))
        .map(function () {
            return (function (charset) {
                return charset.charAt(Math.floor(Math.random() * charset.length));
            })('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
        })
        .join('');
};

Utils.rs = function (len = 8) {
    return [...Array(len)].map(i => (~~(Math.random() * 36)).toString(36)).join('');
};

Utils.randomLowerString = function (len = 8) {
    return Array.apply(0, Array(len))
        .map(function () {
            return (function (charset) {
                return charset.charAt(Math.floor(Math.random() * charset.length));
            })('abcdefghijklmnopqrstuvwxyz');
        })
        .join('');
};

Utils.capitalize = function (str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
};

Utils.generateID = (len = 4, num = Number.MAX_SAFE_INTEGER) => {
    return Array.from(new Array(len))
        .map(() => Math.floor(Math.random() * num).toString(16))
        .join("-");
};

Utils.measureText = (text, font) => {
    const canvas = Utils.measureText.canvas || (Utils.measureText.canvas = document.createElement('canvas'));
    const ctx = canvas.getContext('2d');
    ctx.font = font || 'bold 10pt system-ui';
    return ctx.measureText(text).width;
};

Utils.fixName = (d, dName) => {
    let i = 1;
    const base = dName;
    while (d[dName]) {
        dName = `${base} (${i})`;
        i++;
    }
    return dName;
};

Utils.isEmptyString = str => {
    return !str || str.length === 0;
};

Utils.isBlankString = str => {
    return !str || /^\s*$/.test(str);
};

Utils.log = function () {};
Utils.count = 0;
Utils.counter = function () {
    return (this.count += 1);
};
Utils.getPrefix = function () {
    return this.prefix + this.counter();
};

Utils.prefix = Utils.randomString() + '_';

Utils.getUrlParameter = function (name) {
    const nameA = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    const regex = new RegExp('[\\?&]' + nameA + '=([^&#]*)');
    const results = regex.exec(location.search.replace(/\/$/, ''));
    return results === null ? null : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

Utils.debounce = function (func, wait = 100) {
    let timeout;
    return function (...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            func.apply(this, args);
        }, wait);
    };
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

Utils.getRandomColor = function () {
    return '#' + (((1 << 24) * Math.random()) | 0).toString(16).padStart(6, 0); // just a random color padded to 6 characters
};

/*
    Quick utility to lighten or darken a color (doesn't take color-drifting, etc. into account)
    Usage:
    fadeColor('#061261', 100); // will lighten the color
    fadeColor('#200867'), -100); // will darken the color
*/

Utils.fadeColor = function (col, amt) {
    const min = Math.min, max = Math.max;
    const num = parseInt(col.replace(/#/g, ''), 16);
    const r = min(255, max((num >> 16) + amt, 0));
    const g = min(255, max((num & 0x0000ff) + amt, 0));
    const b = min(255, max(((num >> 8) & 0x00ff) + amt, 0));
    return '#' + (g | (b << 8) | (r << 16)).toString(16).padStart(6, 0);
};

Utils.lerpColorWithScale = function(startColor, targetColor, amount, scale = 0.5) {
    if(amount < scale) {
        return Utils.lerpColor(startColor, '#FFF2EC', amount * 2);
}
    return Utils.lerpColor('#FFF2EC', targetColor, amount);
};

Utils.lerpColor = function (startColor, targetColor, amount) {
    const ah = parseInt(startColor.replace(/#/g, ''), 16);
    const ar = ah >> 16;
    const ag = (ah >> 8) & 0xff;
    const ab = ah & 0xff;
    const bh = parseInt(targetColor.replace(/#/g, ''), 16);
    const br = bh >> 16;
    var bg = (bh >> 8) & 0xff;
    var bb = bh & 0xff;
    const rr = ar + amount * (br - ar);
    const rg = ag + amount * (bg - ag);
    const rb = ab + amount * (bb - ab);

    return (
        '#' +
        (((1 << 24) + (rr << 16) + (rg << 8) + rb) | 0)
            .toString(16)
            .slice(1)
            .toUpperCase()
    );
};

Utils.hexToRgb = function (hex) {
    const match = hex.replace(/#/, '').match(/.{1,2}/g);
    return {
        r: parseInt(match[0], 16),
        g: parseInt(match[1], 16),
        b: parseInt(match[2], 16)
    };
};

Utils.rgbToHex = (r, g, b) => '#' + [r, g, b].map(x => {
    return x.toString(16).padStart(2, 0);
}).join('');


Utils.nscolorToRgb = function (rP, gP, bP) {
    return {
        r : Math.round(rP * 255),
        g : Math.round(gP * 255),
        b : Math.round(bP * 255)
    };
};

Utils.nsColorToHex = function (rP, gP, bP) {
    const c = Utils.nscolorToRgb(rP, gP, bP);
    return Utils.rgbToHex(c.r, c.g, c.b);
};

Utils.miredToKelvin = function (mired) {
    return Math.round(1e6 / mired);
};

Utils.kelvinToMired = function(kelvin, roundTo) {
    return roundTo ? Utils.roundBy(Math.round(1e6 / kelvin), roundTo) : Math.round(1e6 / kelvin);
};

Utils.roundBy = function(num, x) {
    return Math.round((num - 10) / x) * x;
};

Utils.quantizeNumber = function(val, quantum, {cover = false} = {}) {
    if(!quantum) {
        return 0;
    }
    var remainder = val % quantum;
    // I'm intentionally not using Math.sign so that no polyfill is
    // required to use this library in legacy environments.
    var sign = val >= 0 ? 1 : -1;
    var mod = cover && remainder ? quantum : 0;
    return val - remainder + sign * mod;
};

Utils.getBrightness = function (hexColor) {
    // http://www.w3.org/TR/AERT#color-contrast
    if (typeof hexColor === 'string' && hexColor.charAt(0) === '#') {
        var rgb = Utils.hexToRgb(hexColor);
        return (rgb.r * 299 + rgb.g * 587 + rgb.b * 114) / 1000;
    }
    return 0;
};

Utils.readJson = function (file, callback) {
    var req = new XMLHttpRequest();
    req.onerror = function (e) {
        // Utils.log(`[Utils][readJson] Error while trying to read  ${file}`, e);
    };
    req.overrideMimeType('application/json');
    req.open('GET', file, true);
    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            // && req.status == "200") {
            if (callback) callback(req.responseText);
        }
    };
    req.send(null);
};

Utils.readFile = function(url) {
    return new Promise(function(resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.onload = function() {
            //resolve(new Response(xhr.responseText, {status: xhr.status}))
            resolve(xhr.responseText);
        };
        xhr.onerror = function() {
            reject(new TypeError('Local request failed'));
        };
        xhr.open('GET', url);
        xhr.send(null);
    });
};

Utils.loadScript = function (url, callback) {
    const el = document.createElement('script');
    el.src = url;
    el.onload = function () {
        callback(url, true);
    };
    el.onerror = function () {
        console.error('Failed to load file: ' + url);
        callback(url, false);
    };
    document.body.appendChild(el);
};

Utils.createInlineWorker = (fn) => {
    const fnAsString = fn.toString().replace(/^[^{]*{\s*/, '').replace(/\s*}[^}]*$/, '');
    return new Worker(URL.createObjectURL(
        new Blob([fnAsString], {type: 'text/javascript'})
    ));
};

Utils.parseJson = function (jsonString) {
    if (typeof jsonString === 'object') return jsonString;
    try {
        const o = JSON.parse(jsonString);

        // Handle non-exception-throwing cases:
        // Neither JSON.parse(false) or JSON.parse(1234) throw errors, hence the type-checking,
        // but... JSON.parse(null) returns null, and typeof null === "object",
        // so we must check for that, too. Thankfully, null is falsey, so this suffices:
        if (o && typeof o === 'object') {
            return o;
        }
    } catch (e) {}

    return false;
};

Utils.parseJSONPromise = function (jsonString) {
    // fetch('/my-json-doc-as-string')
    // .then(Utils.parseJSONPromise)
    // .then(heresYourValidJSON)
    // .catch(error - or return default JSON)

    return new Promise((resolve, reject) => {
        try {
            const o = JSON.parse(jsonString);
            if(o && typeof o === 'object') {
                resolve(o);
            } else {
                resolve({});
            }
        } catch (e) {
            reject(e);
        }
    });
};


Utils.getProperty = function (obj, dotSeparatedKeys, defaultValue) {
    if(arguments.length > 1 && typeof dotSeparatedKeys !== 'string') return undefined;
    if (typeof obj !== 'undefined' && typeof dotSeparatedKeys === 'string') {
        const pathArr = dotSeparatedKeys.split('.');
        pathArr.forEach((key, idx, arr) => {
            if (typeof key === 'string' && key.includes('[')) {
                try {
                    // extract the array index as string
                    const pos = /\[([^)]+)\]/.exec(key)[1];
                    // get the index string length (i.e. '21'.length === 2)
                    const posLen = pos.length;
                    arr.splice(idx + 1, 0, Number(pos));

                    // keep the key (array name) without the index comprehension:
                    // (i.e. key without [] (string of length 2)
                    // and the length of the index (posLen))
                    arr[idx] = key.slice(0, -2 - posLen); // eslint-disable-line no-param-reassign
                } catch (e) {
                    // do nothing
                }
            }
        });
        // eslint-disable-next-line no-param-reassign, no-confusing-arrow
        obj = pathArr.reduce((o, key) => (o && o[key] !== 'undefined' ? o[key] : undefined), obj);
    }
    return obj === undefined ? defaultValue : obj;
};

Utils.getProp = (jsn, str, defaultValue = {}, sep = '.') => {
    const arr = str.split(sep);
    return arr.reduce((obj, key) => (obj && obj.hasOwnProperty(key) ? obj[key] : defaultValue), jsn);
};

Utils.setProp = function (jsonObj, path, value) {
    const names = path.split('.');
    let jsn = jsonObj;

    // createNestedObject(jsn, names, values);
    // If a value is given, remove the last name and keep it for later:
    var targetProperty = arguments.length === 3 ? names.pop() : false;

    // Walk the hierarchy, creating new objects where needed.
    // If the lastName was removed, then the last object is not set yet:
    for (var i = 0; i < names.length; i++) {
        jsn = jsn[names[i]] = jsn[names[i]] || {};
    }

    // If a value was given, set it to the target property (the last one):
    if (targetProperty) jsn = jsn[targetProperty] = value;

    // Return the last object in the hierarchy:
    return jsn;
};

Utils.stringToHTML = function(html, all = false) {
    var template = document.createElement('template');
    template.innerHTML = html.trim();
    return all ? template.content : template.content.firstChild;
};

Utils.stringToHTMLDiv = function(html, className) {
    var template = document.createElement('div');
    if(className) template.classList.add(className);
    template.innerHTML = html.trim();
    return template;
};


Utils.getDataUri = function(url, callback, inCanvas, inFillcolor, w, h, clearCtx) {
    var image = new Image();

    image.onload = function () {
        const canvas = inCanvas && Utils.isCanvas(inCanvas) ? inCanvas : document.createElement('canvas');

        canvas.width = w || this.naturalWidth; // or 'width' if you want a special/scaled size
        canvas.height = h || this.naturalHeight; // or 'height' if you want a special/scaled size

        const ctx = canvas.getContext('2d');
        if(clearCtx) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }
        if (inFillcolor) {
            ctx.fillStyle = inFillcolor;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
        }
        ctx.drawImage(image, 0, 0);
        // Get raw image data
        // callback && callback(canvas.toDataURL('image/png').replace(/^data:image\/(png|jpg);base64,/, ''));

        // ... or get as Data URI
        callback(canvas.toDataURL('image/png'));
    };

    image.src = url;
};

Utils.s2c = function(svg, inCanvas, inContext, w, h, cb) {
    var img = new Image();
    img.src = svg;
    img.onload = function() {
        let cnv = inCanvas || document.createElement('canvas');
        let ctx = inContext || cnv.getContext('2d');
        cnv.width = w || image.naturalWidth;
        cnv.height = h || image.naturalHeight;
        ctx.clearRect(0, 0, cnv.width, cnv.height);
        ctx.drawImage(img, 0, 0);
        if(cb) cb(this, cnv.toDataURL('image/png'));
    };
};

Utils.drawStringToCanvas = (text, size = 400, inCanvas) => {
    const canvas = inCanvas ? inCanvas : document.createElement('canvas');
    const tempCtx = canvas.getContext('2d');
    tempCtx.clearRect(0, 0, canvas.width, canvas.height);
    tempCtx.font = `${size}px Helvetica`;
    tempCtx.fontWeight = 'bold';
    tempCtx.lineHeight = size;
    tempCtx.fillStyle = '#d8d8d8';
    tempCtx.textAlign = 'center';
    tempCtx.textBaseline = 'middle';
    // tempCtx.fillText(`${text}`, canvas.width / 2, canvas.height / 2);

    // var text = 'All the world \'s a stage, and all the men and women merely players. They have their exits and their entrances; And one man in his time plays many parts.';
    // wrapText(tempCtx, text, 0, 0, 144);
    Utils.wrapText(tempCtx, text, canvas.width / 2, canvas.height / 2, canvas.width);


};

Utils.wrapText = (ctx, text, x = 0, y = 0, maxWidth = 144) => {
    const words = text.split(' ');
    let line = '';
    let metrics;

    for(let i = 0;i < words.length;i++) {
        let tmpStr = words[i];
        metrics = ctx.measureText(tmpStr);
        while(metrics.width > maxWidth) {
            tmpStr = tmpStr.substring(0, tmpStr.length - 1);
            metrics = ctx.measureText(tmpStr);
        }

        if(words[i] != tmpStr) {
            words.splice(i + 1, 0, words[i].substr(tmpStr.length));
            words[i] = tmpStr;
        }

        tmpStr = words.length > 1 ? `${line}${words[i]} ` : `${line}${words[i]}`;
        metrics = ctx.measureText(tmpStr);
        // console.log("len:", words.length, metrics);

        if(metrics.width > maxWidth && i > 0) {
            y -= ctx.lineHeight / 2;
            ctx.fillText(line, x, y);
            line = `${words[i]} `;
            y += ctx.lineHeight;
        }
        else {
            // console.log(tmpStr, metrics.width, x, maxWidth);
            // x = (metrics.width + x) / 2;
            line = tmpStr;
        }
    }
    ctx.fillText(line, x, y);
};

Utils.getFontSize = (options = {}) => { //thx gifshot! :)
    // var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    /* needs {
        text: options.title, // the text to measure
        width: options.width || window.innerWidth, // maximum available width
        minFontSize: options.minFontSize, //minimum acceptable font size
    }
    */
    if(!document.body || options.resizeFont === false) {
        return options.fontSize;
    }

    var fontSize = parseInt(options.fontSize, 10) || 13;
    var minFontSize = parseInt(options.minFontSize, 10) || 6;
    var div = document.createElement('div');
    var span = document.createElement('span');

    div.setAttribute('width', options.width);
    div.appendChild(span);

    span.innerHTML = options.title || options.text || '';
    span.style.fontSize = fontSize + 'px';
    span.style.textIndent = '-9999px';
    span.style.visibility = 'hidden';

    document.body.appendChild(span);

    while((span.offsetWidth > options.width) && (fontSize >= minFontSize)) {
        span.style.fontSize = --fontSize + 'px';
    }

    document.body.removeChild(span);

    return fontSize; //+ 'px';
};


// const greenKey = Utils.createColoredKeyAsDataUrl(null, "#00AA33");

Utils.createColoredKeyAsDataUrl = (inCanvas, inFillcolor, inWidth = 144, inHeight = 144) => {
    let canvas = inCanvas;
    if(!inCanvas) {
        canvas = document.createElement('canvas');
        canvas.width = inWidth;
        canvas.height = inHeight;
    }
    const tempCtx = canvas.getContext('2d');
    tempCtx.clearRect(0, 0, canvas.width, canvas.height);
    tempCtx.fillStyle = inFillcolor;
    tempCtx.fillRect(0, 0, canvas.width, canvas.height);
    return canvas.toDataURL('image/png');
};

/** Quick utility to inject a style to the DOM
* e.g. injectStyle('.localbody { background-color: green;}')
*/
Utils.injectStyle = function (styles, styleId) {
   const node = document.createElement('style');
   const tempID = styleId || Utils.randomString(8);
   node.setAttribute('id', tempID);
   node.innerHTML = styles;
   document.body.appendChild(node);
   return node;
};

Utils.loadImageData = function(inUrl, callback) {
    let image = new Image();
    image.onload = function() {
        callback(image);
        // or to get raw image data
        // callback && callback(canvas.toDataURL('image/png').replace(/^data:image\/(png|jpg);base64,/, ''));
    };
    image.src = inUrl;
};

Utils.loadImagePromise = url =>
    new Promise(resolve => {
        const img = new Image();
        img.onload = () => resolve({url, status: 'ok'});
        img.onerror = () => resolve({url, status: 'error'});
        img.src = url;
    });

Utils.loadImages = arrayOfUrls => Promise.all(arrayOfUrls.map(Utils.loadImagePromise));

Utils.loadImageWithOptions = (url, w, h, inCanvas, clearCtx, inFillcolor) =>
    new Promise(resolve => {
        const img = new Image();
        img.onload = () => {
            const canvas = inCanvas && Utils.isCanvas(inCanvas) ? inCanvas : document.createElement('canvas');
            canvas.width = w || img.naturalWidth; // or 'width' if you want a special/scaled size
            canvas.height = h || img.naturalHeight; // or 'height' if you want a special/scaled size
            console.log('IMG', img, img.naturalWidth);
            const ctx = canvas.getContext('2d');
            if(clearCtx) {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
            }
            if(inFillcolor) {
                ctx.fillStyle = inFillcolor;
                ctx.fillRect(0, 0, canvas.width, canvas.height);
            }
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
            window.bbb = canvas.toDataURL('image/png');
            resolve({url, status: 'ok', image: canvas.toDataURL('image/png')}); // raw image with: canvas.toDataURL('image/png').replace(/^data:image\/(png|jpg);base64,/, '');
        };
        img.onerror = () => resolve({url, status: 'error'});
        img.src = url;
    });

Utils.loadImage = function (inUrl, callback, inCanvas, inFillcolor) {
    /** Convert to array, so we may load multiple images at once */
    const aUrl = !Array.isArray(inUrl) ? [inUrl] : inUrl;
    const canvas = inCanvas && inCanvas instanceof HTMLCanvasElement ? inCanvas : document.createElement('canvas');
    var imgCount = aUrl.length - 1;
    const imgCache = {};

    var ctx = canvas.getContext('2d');
    ctx.globalCompositeOperation = 'source-over';

    for (let url of aUrl) {
        let image = new Image();
        let cnt = imgCount;
        let w = 144, h = 144;

        image.onload = function () {
            imgCache[url] = this;
            // look at the size of the first image
            if (url === aUrl[0]) {
                canvas.width = this.naturalWidth; // or 'width' if you want a special/scaled size
                canvas.height = this.naturalHeight; // or 'height' if you want a special/scaled size
            }
            // if (Object.keys(imgCache).length == aUrl.length) {
            if (cnt < 1) {
                if (inFillcolor) {
                    ctx.fillStyle = inFillcolor;
                    ctx.fillRect(0, 0, canvas.width, canvas.height);
                }
                // draw in the proper sequence FIFO
                aUrl.forEach(e => {
                    if (!imgCache[e]) {
                        console.warn(imgCache[e], imgCache);
                    }

                    if (imgCache[e]) {
                        ctx.drawImage(imgCache[e], 0, 0);
                        ctx.save();
                    }
                });

                callback(canvas.toDataURL('image/png'), canvas.width, canvas.height, this);
                // or to get raw image data
                // callback && callback(canvas.toDataURL('image/png').replace(/^data:image\/(png|jpg);base64,/, ''));
            }
        };

        imgCount--;
        image.src = url;
    }
};

Utils.crop = function(canvas, offsetX, offsetY, width, height, callback, inCanvas) {
    var buffer = inCanvas && inCanvas instanceof HTMLCanvasElement ? inCanvas : document.createElement('canvas');
    var ctx = buffer.getContext('2d');
    buffer.width = width;
    buffer.height = height;

    // drawImage(source, source_X, source_Y, source_Width, source_Height, dest_X, dest_Y, dest_Width, dest_Height)
    ctx.drawImage(canvas, offsetX, offsetY, width, height, 0, 0, buffer.width, buffer.height);

    if(callback) callback(buffer.toDataURL('image/png'));
};

Utils.getData = function (url) {
    // Return a new promise.
    return new Promise(function (resolve, reject) {
        // Do the usual XHR stuff
        var req = new XMLHttpRequest();
        // Make sure to call .open asynchronously
        req.open('GET', url, true);

        req.onload = function () {
            // This is called even on 404 etc
            // so check the status
            if (req.status === 200) {
                // Resolve the promise with the response text
                resolve(req.response);
            } else {
                // Otherwise reject with the status text
                // which will hopefully be a meaningful error
                reject(Error(req.statusText));
            }
        };

        // Handle network errors
        req.onerror = function () {
            reject(Error('Network Error'));
        };

        // Make the request
        req.send();
    });
};

Utils.negArray = function (arr) {
    /** http://h3manth.com/new/blog/2013/negative-array-index-in-javascript/ */
    return Proxy.create({
        set: function (proxy, index, value) {
            index = parseInt(index);
            return index < 0 ? (arr[arr.length + index] = value) : (arr[index] = value);
        },
        get: function (proxy, index) {
            index = parseInt(index);
            return index < 0 ? arr[arr.length + index] : arr[index];
        }
    });
};

Utils.onChange = function(object, changedCallback, callback) {
    /** https://github.com/sindresorhus/on-change */
    'use strict';
    const handler = {
        get (target, property, receiver) {
            try {
                return new Proxy(target[property], handler);
            } catch (err) {
                return Reflect.get(target, property, receiver);
            }
        },
        set (target, property, value, receiver) {
            try {
                if(callback && !callback(target, property, value)) {
                    throw new Error(`${value} is not a valid ${property}`);
                };

                const oldValue = Reflect.get(target, property, value, receiver);
                const success = Reflect.set(target, property, value);

                if(oldValue !== value && typeof changedCallback === 'function') {
                    changedCallback(target, property, value, oldValue);
                }
                return success;
            } catch(err) {
                console.warn(`proxy:property was not SAVED: ${err}`);
                return Reflect.get(target, property, receiver) || {};
            }
        },
        defineProperty (target, property, descriptor) {
            console.log('Utils.onChange:defineProperty:', target, property, descriptor);
            callback(target, property, descriptor);
            return Reflect.defineProperty(target, property, descriptor);
        },
        deleteProperty (target, property) {
            console.log('Utils.onChange:deleteProperty:', target, property);
            callback(target, property);
            return Reflect.deleteProperty(target, property);
        }
    };

    return new Proxy(object, handler);
};

Utils.observeArray = function (object, callback) {
    'use strict';
    const array = [];
    const handler = {
        get (target, property, receiver) {
            try {
                return new Proxy(target[property], handler);
            } catch (err) {
                return Reflect.get(target, property, receiver);
            }
        },
        set (target, property, value, receiver) {
            console.log('XXXUtils.observeArray:set1:', target, property, value, array);
            target[property] = value;
            console.log('XXXUtils.observeArray:set2:', target, property, value, array);
        },
        defineProperty (target, property, descriptor) {
            callback(target, property, descriptor);
            return Reflect.defineProperty(target, property, descriptor);
        },
        deleteProperty (target, property) {
            callback(target, property, descriptor);
            return Reflect.deleteProperty(target, property);
        }
    };

    return new Proxy(object, handler);
};

Utils.noop = function() {};

window['_'] = Utils;

/*
 * connectElgatoStreamDeckSocket
 * This is the first function StreamDeck Software calls, when
 * establishing the connection to the plugin or the Property Inspector
 * @param {string} inPort - The socket's port to communicate with StreamDeck software.
 * @param {string} inUUID - A unique identifier, which StreamDeck uses to communicate with the plugin
 * @param {string} inMessageType - Identifies, if the event is meant for the property inspector or the plugin.
 * @param {string} inApplicationInfo - Information about the host (StreamDeck) application
 * @param {string} inActionInfo - Context is an internal identifier used to communicate to the host application.
 */


// eslint-disable-next-line no-unused-vars
function connectElgatoStreamDeckSocket(inPort, inUUID, inMessageType, inApplicationInfo, inActionInfo) {
    StreamDeck.getInstance().connect(arguments);
    window.$SD.api = Object.assign({ send: SDApi.send }, SDApi.common, SDApi[inMessageType]);
}

/* legacy support */

function connectSocket(inPort, inUUID, inMessageType, inApplicationInfo, inActionInfo) {
    connectElgatoStreamDeckSocket(inPort, inUUID, inMessageType, inApplicationInfo, inActionInfo);
}

/**
 * StreamDeck object containing all required code to establish
 * communication with SD-Software and the Property Inspector
 */

const StreamDeck = (function () {
    // Hello it's me
    var instance;
    /*
      Populate and initialize internally used properties
    */

    function init () {
        // *** PRIVATE ***

        var inPort,
            inUUID,
            inMessageType,
            inApplicationInfo,
            inActionInfo,
            websocket = null,
            filterPIMessages = ['didReceiveSettings', 'didReceiveGlobalSettings', 'propertyInspectorDidAppear', 'propertyInspectorDidDisappear'];
        // filterPIMessages = ['didReceiveGlobalSettings', 'propertyInspectorDidAppear', 'propertyInspectorDidDisappear'];

        var events = ELGEvents.eventEmitter();

        function connect (args) {
            inPort = args[0];
            inUUID = args[1];
            inMessageType = args[2];
            inApplicationInfo = Utils.parseJson(args[3]);
            inActionInfo = args[4] !== 'undefined' ? Utils.parseJson(args[4]) : args[4];

            const lang = Utils.getProp(inApplicationInfo,'application.language', false);
            if(lang) {
                loadLocalization(lang, inMessageType === 'registerPropertyInspector' ? '../' : './', function() {
                    events.emit('localizationLoaded', {language: lang});
                });
            }

            /** restrict the API to what's possible
             * within Plugin or Property Inspector
             * <unused for now>
             */
            // $SD.api = SDApi[inMessageType];

            if (websocket) {
                websocket.close();
                websocket = null;
            }

            websocket = new WebSocket('ws://127.0.0.1:' + inPort);

            websocket.onopen = function () {
                var json = {
                    event: inMessageType,
                    uuid: inUUID
                };

                // console.log('***************', inMessageType + "  websocket:onopen", inUUID, json);

                websocket.sendJSON(json);
                $SD.uuid = inUUID;
                $SD.actionInfo = inActionInfo;
                $SD.applicationInfo = inApplicationInfo;
                $SD.messageType = inMessageType;
                $SD.connection = websocket;

                instance.emit('connected', {
                    connection: websocket,
                    port: inPort,
                    uuid: inUUID,
                    actionInfo: inActionInfo,
                    applicationInfo: inApplicationInfo,
                    messageType: inMessageType
                });
            };

            websocket.onerror = function (evt) {
                console.warn('WEBOCKET ERROR', evt, evt.data);
            };

            websocket.onclose = function (evt) {
                // Websocket is closed
                var reason = WEBSOCKETERROR(evt);
                console.warn('[STREAMDECK]***** WEBOCKET CLOSED **** reason:', reason);
            };

            websocket.onmessage = function (evt) {
                var jsonObj = Utils.parseJson(evt.data),
                    m;

                // console.log('[STREAMDECK] websocket.onmessage ... ', jsonObj.event, jsonObj);

                if (!jsonObj.hasOwnProperty('action')) {
                    m = jsonObj.event;
                    // console.log('%c%s', 'color: white; background: red; font-size: 12px;', '[common.js]onmessage:', m);
                } else {
                    const e = jsonObj['event'];
                    if(filterPIMessages.includes(e)) {
                        // console.log('%c%s', 'color: white; background: red; font-size: 13px;', 'EMIITING GLOBAL PIMESSAGE ', e, jsonObj);
                        events.emit(e, jsonObj);
                        // m = jsonObj['action'] + '.' + jsonObj['event'];
                    }
                    switch (inMessageType) {
                    case 'registerPlugin':
                        m = jsonObj['action'] + '.' + jsonObj['event'];
                        break;
                    case 'registerPropertyInspector':
                        m = 'sendToPropertyInspector';
                        break;
                    default:
                        console.log('%c%s', 'color: white; background: red; font-size: 12px;', '[STREAMDECK] websocket.onmessage +++++++++  PROBLEM ++++++++');
                        console.warn('UNREGISTERED MESSAGETYPE:', inMessageType);
                    }
                }

                if(m && m !== '') events.emit(m, jsonObj);
            };

            instance.connection = websocket;
        }

        return {
            // *** PUBLIC ***

            uuid: inUUID,
            on: events.on,
            emit: events.emit,
            connection: websocket,
            connect: connect,
            api: null,
        };
    }

    return {
        getInstance: function () {
            if (!instance) {
                instance = init();
            }
            return instance;
        }
    };
})();

// eslint-disable-next-line no-unused-vars
function initializeControlCenterClient () {
    const settings = Object.assign(REMOTESETTINGS || {}, { debug: false });
    var $CC = new ControlCenterClient(settings);
    window['$CC'] = $CC;
    return $CC;
}

/** ELGEvents
 * Publish/Subscribe pattern to quickly signal events to
 * the plugin, property inspector and data.
 */

const ELGEvents = {
    eventEmitter: function (name, fn) {
        const eventList = new Map();

        const on = (name, fn) => {
            if (!eventList.has(name)) eventList.set(name, ELGEvents.pubSub());

            return eventList.get(name).sub(fn);
        };

        const has = name => eventList.has(name);

        const emit = (name, data) => eventList.has(name) && eventList.get(name).pub(data);

        return Object.freeze({ on, has, emit, eventList });
    },

    pubSub: function pubSub () {
        const subscribers = new Set();

        const sub = fn => {
            subscribers.add(fn);
            return () => {
                subscribers.delete(fn);
            };
        };

        const pub = data => subscribers.forEach(fn => fn(data));
        return Object.freeze({ pub, sub });
    }
};

/** SDApi
 * This ist the main API to communicate between plugin, property inspector and
 * application host.
 * Internal functions:
 * - setContext: sets the context of the current plugin
 * - exec: prepare the correct JSON structure and send
 *
 * Methods exposed in the $SD.api alias
 * Messages send from the plugin
 * -----------------------------
 * - showAlert
 * - showOK
 * - setSettings
 * - setTitle
 * - setImage
 * - sendToPropertyInspector
 *
 * Messages send from Property Inspector
 * -------------------------------------
 * - sendToPlugin
 *
 * Messages received in the plugin
 * -------------------------------
 * willAppear
 * willDisappear
 * keyDown
 * keyUp
 */

const SDApi = {
    send: function (context, fn, payload, debug) {
        /** Combine the passed JSON with the name of the event and it's context
         * If the payload contains 'event' or 'context' keys, it will overwrite existing 'event' or 'context'.
         * This function is non-mutating and thereby creates a new object containing
         * all keys of the original JSON objects.
         */
        const pl = Object.assign({}, { event: fn, context: context }, payload);

        /** Check, if we have a connection, and if, send the JSON payload */
        if (debug) {
            console.log('-----SDApi.send-----');
            console.log('context', context);
            console.log(pl);
            console.log(payload.payload);
            console.log(JSON.stringify(payload.payload));
            console.log('-------');
        }
        $SD.connection && $SD.connection.sendJSON(pl);

        /**
         * DEBUG-Utility to quickly show the current payload in the Property Inspector.
         */

        if($SD.connection && ['sendToPropertyInspector', 'showOK', 'showAlert', 'setSettings'].indexOf(fn) === -1) {
            // console.log("send.sendToPropertyInspector", payload);
            // this.sendToPropertyInspector(context, typeof payload.payload==='object' ? JSON.stringify(payload.payload) : JSON.stringify({'payload':payload.payload}), pl['action']);
        }
    },

    registerPlugin: {

        /** Messages send from the plugin */
        showAlert: function (context) {
            SDApi.send(context, 'showAlert', {});
        },

        showOk: function (context) {
            SDApi.send(context, 'showOk', {});
        },


        setState: function (context, payload) {
            SDApi.send(context, 'setState', {
                payload: {
                    state: 1 - Number(payload === 0)
                }
            });
        },

        setTitle: function (context, title, target) {
            SDApi.send(context, 'setTitle', {
                payload: {
                    title: '' + title || '',
                    target: target || DestinationEnum.HARDWARE_AND_SOFTWARE
                }
            });
        },

        clearTitle: function(context, title, target) {
            SDApi.send(context, 'setTitle', {
                payload: {
                    target: target || DestinationEnum.HARDWARE_AND_SOFTWARE
                }
            });
        },

        setImage: function (context, img, target) {
            SDApi.send(context, 'setImage', {
                payload: {
                    image: img || '',
                    target: target || DestinationEnum.HARDWARE_AND_SOFTWARE
                }
            });
        },

        sendToPropertyInspector: function (context, payload, action) {
            SDApi.send(context, 'sendToPropertyInspector', {
                action: action,
                payload: payload
            });
        },

        showUrl2: function (context, urlToOpen) {
            SDApi.send(context, 'openUrl', {
                payload: {
                    url: urlToOpen
                }
            });
        }
    },

    /** Messages send from Property Inspector */

    registerPropertyInspector: {

        sendToPlugin: function (piUUID, action, payload) {
            SDApi.send(
                piUUID,
                'sendToPlugin',
                {
                    action: action,
                    payload: payload || {}
                },
                false
            );
        }
    },

    /** COMMON */

    common: {

        getSettings: function(context, payload) {
            const uuid = context ? context : $SD.uuid;
            SDApi.send(uuid, 'getSettings', {});
        },

        setSettings: function(context, payload) {
            if(!context) context = $SD.uuid;
            SDApi.send(context, 'setSettings', {
                payload: payload
            });
        },

        getGlobalSettings: function(context) {
            const uuid = context ? context : $SD.uuid;
            SDApi.send(uuid, 'getGlobalSettings', {});
        },

        setGlobalSettings: function(context, payload) {
            const uuid = context ? context : $SD.uuid;
            SDApi.send(uuid, 'setGlobalSettings', {
                payload: payload
            });
        },

        switchToProfile: function(inContext, inDeviceID, inProfileName = null) {
            if(inDeviceID && inDeviceID.length !== 0) {
                const context = inContext ? inContext : $SD.uuid;
                const device = inDeviceID;
                const event = 'switchToProfile';
                // if (inProfileName && inProfileName.length !== 0) {
                const payload = {
                    profile: inProfileName
                };
                const pl = Object.assign({}, {event, context, device}, {payload: payload});
                console.log("$SD.switchToProfile", inProfileName, pl);
                $SD.connection && $SD.connection.sendJSON(pl);
                // }
            }
        },

        logMessage: function() {
            /**
             * for logMessage we don't need a context, so we allow both
             * logMessage(unneededContext, 'message')
             * and
             * logMessage('message')
             */

            let payload = arguments.length > 1 ? arguments[1] : arguments[0];

            SDApi.send(null, 'logMessage', {
                payload: {
                    message: payload
                }
            });
        },

        openUrl: function (context, urlToOpen) {
            SDApi.send(context, 'openUrl', {
                payload: {
                    url: urlToOpen
                }
            });
        },

        test: function () {
            console.log(this);
            console.log(SDApi);
        },

        debugPrint: function (context, inString) {
            // console.log("------------ DEBUGPRINT");
            // console.log([].slice.apply(arguments).join());
            // console.log("------------ DEBUGPRINT");
            SDApi.send(context, 'debugPrint', {
                payload: [].slice.apply(arguments).join('.') || ''
            });
        },

        dbgSend: function (fn, context) {
            /** lookup if an appropriate function exists */
            if ($SD.connection && this[fn] && typeof this[fn] === 'function') {
                /** verify if type of payload is an object/json */
                const payload = this[fn]();
                if (typeof payload === 'object') {
                    Object.assign({ event: fn, context: context }, payload);
                    $SD.connection && $SD.connection.sendJSON(payload);
                }
            }
            console.log(this, fn, typeof this[fn], this[fn]());
        }

    }
};

/**
 * This is the instance of the StreamDeck object.
 * There's only one StreamDeck object, which carries
 * connection parameters and handles communication
 * to/from the software's PluginManager.
 */

window.$SD = StreamDeck.getInstance();
window.$SD.api = SDApi;

function WEBSOCKETERROR (evt) {
    // Websocket is closed
    var reason = '';
    if (evt.code === 1000) {
        reason = 'Normal Closure. The purpose for which the connection was established has been fulfilled.';
    } else if (evt.code === 1001) {
        reason = 'Going Away. An endpoint is "going away", such as a server going down or a browser having navigated away from a page.';
    } else if (evt.code === 1002) {
        reason = 'Protocol error. An endpoint is terminating the connection due to a protocol error';
    } else if (evt.code === 1003) {
        reason = 'Unsupported Data. An endpoint received a type of data it doesn\'t support.';
    } else if (evt.code === 1004) {
        reason = '--Reserved--. The specific meaning might be defined in the future.';
    } else if (evt.code === 1005) {
        reason = 'No Status. No status code was actually present.';
    } else if (evt.code === 1006) {
        reason = 'Abnormal Closure. The connection was closed abnormally, e.g., without sending or receiving a Close control frame';
    } else if (evt.code === 1007) {
        reason = 'Invalid frame payload data. The connection was closed, because the received data was not consistent with the type of the message (e.g., non-UTF-8 [http://tools.ietf.org/html/rfc3629]).';
    } else if (evt.code === 1008) {
        reason = 'Policy Violation. The connection was closed, because current message data "violates its policy". This reason is given either if there is no other suitable reason, or if there is a need to hide specific details about the policy.';
    } else if (evt.code === 1009) {
        reason = 'Message Too Big. Connection closed because the message is too big for it to process.';
    } else if(evt.code === 1010) {
        // Note that this status code is not used by the server, because it can fail the WebSocket handshake instead.
        reason =
            'Mandatory Ext. Connection is terminated the connection because the server didn\'t negotiate one or more extensions in the WebSocket handshake. <br /> Mandatory extensions were: ' +
            evt.reason;
    } else if (evt.code === 1011) {
        reason = 'Internal Server Error. Connection closed because it encountered an unexpected condition that prevented it from fulfilling the request.';
    } else if (evt.code === 1015) {
        reason = 'TLS Handshake. The connection was closed due to a failure to perform a TLS handshake (e.g., the server certificate can\'t be verified).';
    } else {
        reason = 'Unknown reason';
    }

    return reason;
}

const SOCKETERRORS = {
    '0': 'The connection has not yet been established',
    '1': 'The connection is established and communication is possible',
    '2': 'The connection is going through the closing handshake',
    '3': 'The connection has been closed or could not be opened'
};
