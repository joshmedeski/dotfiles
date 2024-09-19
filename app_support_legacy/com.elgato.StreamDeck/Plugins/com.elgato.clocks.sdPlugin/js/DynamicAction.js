/** TODO
 * unify intervals to a common interval object
 * add base class for all dynamic CLOCK actions and unify common code
 * 
 */

const DEFAULTOPTIONS = {
    fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif",
    fontSize: 10,
    fontWeight: 'bold',
    fontColor: '#ffffff',
    // backgroundColor2: '#000000',
    backgroundColor: 'transparent'
};

// all icons 12px x 12px
const icons = {
    caution: `<path transform="translate(6,6)" fill="white" d="M5.42371606,0.447987925 C5.74241336,-0.147478391 6.2571441,-0.151177362 6.57782112,0.447987925 L11.8623542,10.3218128 C12.1810515,10.9172792 11.9266557,11.4 11.3022832,11.4 L0.699253938,11.4 C0.0712379682,11.4 -0.181494059,10.9209781 0.139182964,10.3218128 L5.42371606,0.447987925 Z M6,1.35350432 L1.1760843,10.4086957 L10.824594,10.4086957 L6,1.35350432 Z M6,3.5625 C6.3186258,3.5625 6.5769231,3.82424122 6.5769231,4.14711538 L6.5769231,7.01538462 C6.5769231,7.33825878 6.3186258,7.60000002 6,7.60000002 C5.68137418,7.60000002 5.42307692,7.33825878 5.42307692,7.01538462 L5.42307692,4.14711538 C5.42307692,3.82424122 5.68137418,3.5625 6,3.5625 Z M6,8.07499998 C6.38235096,8.07499998 6.69230772,8.38908948 6.69230772,8.77653846 L6.69230772,8.79846156 C6.69230772,9.18591054 6.38235096,9.49999998 6,9.49999998 C5.61764902,9.49999998 5.30769231,9.18591054 5.30769231,8.79846156 L5.30769231,8.77653846 C5.30769231,8.38908948 5.61764902,8.07499998 6,8.07499998 Z" id="caution"></path>`
};

class DynamicAction {
    __version = "0.1.0";
    language = Utils.detectLanguage();
    defaults = {...DEFAULTOPTIONS};
    index;
    layout;
    #data;
    data;
    state = {
        lastTicks: 0,
        lastPressed: 0
    };
    #cache = {};
    #scale = 1;
    #events = null;
    #controller = 'Keypad';
    changeInProgress = false;
    // dateUtilities = ELGDATEUTILS || {};
    // dateUtilities = new DateUtils();
    constructor (options = {}, debug = false) {

        // constants
        const CONSTANTS = {
            contextWidth: 100,
            contextHeight: 50,
            longPressDelay: 500

        };
        // const w = 100; // fixed hw width
        this.previews = {
            'Keypad': {
                id: 'keypad',
            },
            'Encoder': {
                id: 'encoder',
            },
        };
        this.#events = new ELGEventEmitter(this.name || this.id);
        this.__events = this.#events;
        this.utils = Utils;
        this.id = options?.id || this.utils.rs();
        this.context = options?.context;
        this.index = options?.index || 0;
        this.name = options?.name;
        this.columns = options?.columns || 1;
        this.render = null;
        this.options = options;
        this.hasInterval = options?.interval ?? 0;
        this.updateTimer = null;
        this.#scale = options?.scale || 2;
        this.initialized = false;
        this.debounceDelay = 500;

        const dbgColor = this.utils.getRandomLightColor();
        this.dbg = this.utils.initDbg({debug, color: dbgColor, prefix: `[DynamicAction ${this.context}]`});
        // this is used to allow debugging from the template (but use the same text-color as the class)
        this.$dbg = this.utils.initDbg({debug, color: dbgColor, prefix: `[${options.id} ${this.context}]`});
        this.size = {
            rows: 1,
            columns: 1
        };
        this.lastUpdateCache = '';
        this.dialStack = options?.dialStack;
        this.on = this.#events.on;
        this.emit = this.#events.emit.bind(this);

        this.contextWidth = CONSTANTS.contextWidth;
        this.contextHeight = CONSTANTS.contextHeight;
        // width is the panel's width including columns (1-4)
        this.width = this.contextWidth * this.columns;
        this.height = CONSTANTS.contextHeight;

        this.position = {x: this.index * this.contextWidth * 2, y: 0};

        this.hasOwnUpdateFunction = false;
        this.interpolate = false;

        this.update = this.utils.debounce((bRedraw = false) => {
            this.updateLayout(bRedraw);
        }, this.debounceDelay);

        this.longPressDetector = this.utils.debounce((cb) => {
            if(this.state.lastPressed && Date.now() - this.state.lastPressed > CONSTANTS.longPressDelay) {
                if(typeof cb === 'function') cb();
            }
        }, CONSTANTS.longPressDelay);

        // if a layout already contains events, bind them to this class and data
        if(options.on) {
            Object.keys(options.on).forEach((eventName) => {
                this.on(eventName, options.on[eventName].bind(this));
            });
        }

        Object.keys(options).forEach((key) => {
            if(key.charAt(0) === '$') {
                this[key] = options[key];
            }
        });

        const self = this;

        this.methods = {};
        if(options.methods) {
            Object.keys(options.methods).forEach((key) => {
                // if(key.charAt(0) === '$') {
                this[key] = options.methods[key];
                this.methods[key] = this[key].bind(this);
                // }
            });
        }
        if(!options?.data?.$message) options.data.$message = '';
        this.#data = {...this.defaults, ...options.data};

        this.setRenderFunction(options?.render);

        this.updateLock = false;

        if(this.#data?.hasOwnProperty('options')) {
            this.dbg('%c%s', 'color: white; background: red; font-size: 15px;', 'DialStack:constructor::this.#data has options', this.#data);
        }

        this.controllers = options.controllers || ['Keypad', 'Encoder'];

        this.data = new ESDProxy(this.#data, {
            set(target, path, value, receiver) {
                // CAUTION: `this` is somehow lost here :(
                const k = path[0]; // const k = path[path.length - 1];
                if(k.charAt(0) === '$') {
                    //  dbg("private variable - returning", k);
                    return false;
                }
                self.emit('changed', path.join('.'), value);

                if(!self.updateLock) self.updateLayout(true);
            },
            deleteProperty(target, path) {
                console.log('[ESDProxy:delete]', path.join('.'));
            }
        });

        this.setLayout(options?.layout);

        this.controller = options?.payload?.controller || 'Keypad';
        return this;
    }

    get cache() {
        return this.#cache;
    }

    get controller() {
        return this.#controller;
    }

    get scale() {
        return this.#scale;
    }

    set scale(value) {
        this.#scale = value;
    }

    get isEncoder() {
        return ['Encoder'].includes(this.controller);
    }

    get privateData() {
        return this.#data;
    }

    setUpdateLock(bool = true) {
        this.updateLock = bool === true || false;
        if(bool !== true) {
            this.dbg('setUpdateLock:unlocking', this.updateLock);
            this.lastUpdateCache = '';
            this.updateLayout(true);
        }
    }
    set controller(value) {
        // console.trace('%c%s', 'color: white; background: red; font-size: 15px;', 'DialStack:set controller', value);
        this.#controller = value;
        if(value === 'Keypad') {
            this.width = 72;
            this.height = 72;
        } else {
            this.width = this.contextWidth * this.columns;
            this.height = this.contextHeight;
        }
        if(this.data) {
            this.initialized = false;
            this.setLayout(this.options?.layout, true);
        }
    }
    onStopTimer() {
        if(this.updateTimer) {
            clearInterval(this.updateTimer);
        }
        this.updateTimer = null;
    }

    handleInterval() {
        this.dbg('handleInterval', this.hasInterval, this.updateTimer);
        if(this.hasInterval > 0) {
            this.onStopTimer();
            this.updateTimer = setInterval(() => {
                if(!this.updateLock) this.update(true);
            }, this.hasInterval);
        }
    }

    destroy() {
        this.onDestroy();
    }

    onDestroy() {
        this.dbg('onDestroy', this.id, this.initialized);
        this.updateLock = true;
        this.onStopTimer();
        this.updateLock = false;
    }

    onInit() {
        this.dbg('onInit', this.id, this.initialized);
        this.updateLock = true;
        this.emit('initialized', this);
        this.handleInterval();
        this.updateLock = false;
    }

    getProp(path, defaultValue = null) {
        return this.utils.getProp(this.data, path, defaultValue);
    }
    changeProp(prop, value) {
        if(typeof prop === 'object') {
            return Object.entries(Utils.flatten(prop)).forEach(e => {
                this.changeProp(e[0], e[1]);
            });
        }
        if(prop === undefined || value === undefined || typeof prop !== 'string') return;
        const found = Utils.getProp(this.data, prop, null);
        if(found !== null) {
            if(found !== value) {
                if(Array.isArray(value)) {
                    Utils.setProp(this.data, prop, Array.from(value));
                } else if(typeof value === 'object') {
                    Utils.setProp(this.data, prop, {...found, ...value});
                } else {
                    Utils.setProp(this.data, prop, value);
                }
                this.dbg('setting property', prop, 'from', found, 'to', value, ' == ', typeof value);
                this.lastUpdateCache = '';
                return true;
            }
            // } else {
            //     console.info('%c[DynamicAction.js changeProp]', 'color: #9F9', 'property not found:', prop);
        };
        return false; //nothing changed or property not found
    }

    changeProps(props) {
        if(!props) return;
        this.dbg('changeProps', this.id, props);
        this.setUpdateLock(true);
        Object.keys(props).forEach(k => {
            this.changeProp(k, props[k]);
        });
        this.setUpdateLock(false);
        this.updateLayout(true);
    }

    onKeyDown(jsn) {
        this.dbg('onKeyDown', this.id, jsn);
        this.state.lastPressed = Date.now();
        this.emit('pressed', jsn);
        this.longPressDetector(() => {
            this.dbg("+++++++++++ LONG PRESS DETECTED +++++++++++++");
            this.emit('longDown', jsn);
        });
    }

    onKeyUp(jsn) {
        this.dbg('onKeyUp', this.id, jsn);
        if(Date.now() > (this.state.lastPressed + 450)) {
            jsn.payload.long = true;
            this.emit('longPressed', jsn);
        }
        this.emit('released', jsn);
        this.emit('clicked', jsn);
    }

    onDialPress(jsn) {
        this.dbg('onDialPress', this.id, jsn);
        this.emit('dialPress', jsn);
        if(jsn.payload.pressed === true) {
            this.onKeyDown(jsn);
        } else {
            this.onKeyUp(jsn);
        }
    }

    onDialRotate(jsn) {
        this.dbg('onDialRotate', this.id, jsn.payload);
        this.emit('dialRotate', jsn);
        this.emit('rotated', jsn);
    }

    onTouchTap(jsn) {
        this.dbg('onTouchTap', this.id, jsn);
        this.emit('touchTap', jsn);
    }

    setRenderFunction(fn) {
        if(typeof fn === 'function') {
            this.render = fn;
            const fnAsString = fn.toString();
            this.layoutString = fnAsString.substring(fnAsString.indexOf("{"), fnAsString.lastIndexOf("}") + 1); // extract function's body
            this.hasOwnUpdateFunction = this.layoutString.includes('updateStreamDeck');
        }
    }

    isAFunction(newLayout) {
        const detectFunctionRegExp = new RegExp(/^(?:[\s]+)?(?:const|let|var|)?(?:[a-z0-9.]+(?:\.prototype)?)?(?:\s)?(?:[a-z0-9-_]+\s?=)?\s?(?:[a-z0-9]+\s+\:\s+)?(?:function\s?)?(?:[a-z0-9_-]+)?\s?\(.*\)\s?(?:.+)?([=>]:)?\{(?:(?:[^}{]+|\{(?:[^}{]+|\{[^}{]*\})*\})*\}(?:\s?\(.*\)\s?\)\s?)?)?(?:\;)?/);
        let isAFunction = typeof newLayout === 'function' || newLayout.startsWith('()') || newLayout.startsWith('function');
        if(!isAFunction) {
            isAFunction = detectFunctionRegExp.test(newLayout);
        }
        return isAFunction;
    }

    setLayout(layout, immediateUpdate = false) {
        if(!layout) return;

        this.layout = layout;

        const isAFunction = this.isAFunction(layout);
        if(isAFunction || typeof this.layout === 'function') {
            const s = this.layout.toString();
            this.layoutString = s.substring(s.indexOf("`") + 1, s.lastIndexOf("`"));
        } else {
            this.layoutString = this.layout;
        }
        if(this.layoutString.match(new RegExp(/(\$\{[\s]*.*?[\s]*\})/, "g"))) {
            this.interpolate = true;
        } else {
            this.interpolate = false;
        }

        if(immediateUpdate) {
            this.updateLayout(true);
        }
        this.emit('layoutUpdated', this.data);
    }

    processTemplate() {
        // convert handlebars to template-variables:
        // const s = this.layoutString.replace(/\{{(.*?)}}/g, (a, k) => `\${${k.trim()}}`);
        const s = this.layoutString.replace(/\{{(.*?)}}/g, (a, k) => this.#data[k.trim()]);
        if(this.render || this.interpolate) {
            const keys = Object.keys(this.#data).filter(k => !k.includes('.')); // remove dot-separated keys
            const values = Object.values(this.#data);
            keys.push('updateStreamDeck');
            values.push(this.updateStreamDeck.bind(this));
            const result = this.interpolate ? `return \`${s}\`;` : `${s}`;
            // console.log('processTemplate creating Func:', this);
            // generate and return the function's output
            try {
                return new Function(...keys, result).bind(this)(...values);
            } catch(e) {
               console.error('processTemplate error:', this.#data?.clock_style?.id,e);
               return '';
           }
        }
        return s;
    };

    // We need this otherwise the panel will not be updated when the data-object changes, 
    // because Javascript does not detect changes in the data object, if the size stays the same.
    set(prop, index, value) {
        if(Array.isArray(this.data[prop])) {
            const tmpArr = [...this.data[prop]];
            tmpArr[index] = value;
            this.data[prop] = tmpArr;
            return tmpArr;
        };
    }

    updatePreviews(width, height, inController) {
        const font = `font-family="${this.data.fontFamily}" font-size="${this.data.fontSize}" font-weight="${this.data.fontWeight}"`;
        let svg = `<?xml version="1.0" encoding="utf-8"?>
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"  width="${width * this.scale}" height="${height * this.scale}" viewBox="0 0 ${width} ${height}" ${font} fill="${this.data.fontColor}"  stroke="none" stroke-width="0">
        <rect id="background" x="0" y="0" width="${width}" height="${height}" fill="${this.data.backgroundColor}" />
           ${this.processTemplate()}
           ${this.data.$message.length < 1 ? '' : `<rect fill="#330000" width="${width}" height="${height}" />${icons.caution}<textArea font-size="9" fill="#ffffff" text-anchor="start" x="24" y="4" width="${width - 36}" height="${height - 8}">${this.data.$message}</textArea>`}
        </svg>`.replace(/\>\s+\</g, '><'); // just remove all whitespace to save some bytes;
        if(!inController) {
            inController = this.#controller;
        }
        const ctrl = (inController != 'Keypad') ? 'Encoder' : 'Keypad';
        this.previews[ctrl].svg = svg;
        this.previews[ctrl].b64 = `data:image/svg+xml;base64,${this.utoa(svg)}`;
        // this.previews[ctrl].b64 = this.containsUnicode(svg) ? `data:image/svg+xml;base64,${this.utoa(svg)}` : `data:image/svg+xml;base64,${btoa(svg)}`;
        // this.previews[ctrl].encodedPreview = `data:image/svg+xml;base64,${btoa(unescape(encodeURIComponent(svg)))}`;
    }

    updateLayout(bRedraw, {width, height} = {}, inController) {
        if(this.initialized === false) {
            this.onInit();
            this.initialized = true;
        }

        let ctrl = inController ?? (this.#controller != 'Keypad') ? 'Encoder' : 'Keypad';
        const svg = this.previews[this.#controller].svg;
        const cachedWidth = this.width;
        const cachedHeight = this.height;
        const drawScaled = !!(width && height);
        if(drawScaled) {
            this.width = width;
            this.height = height;
        }
        if(!this.changeInProgress) {
            this.updateLock = true;
            this.emit('willUpdate', {...this.data, controller: ctrl});
            this.updateLock = false;
        }

        if(this.render && this.hasOwnUpdateFunction) {
            return this.processTemplate();
        };

        this.position = {x: this.index * this.contextWidth * 2, y: 0};

        this.updatePreviews(this.width, this.height, inController);

        if(drawScaled) {
            this.width = cachedWidth;
            this.height = cachedHeight;
        } else {
            if(bRedraw) this.updateStreamDeck();
            this.emit('updated', {b64: this.previews[ctrl].b64, svg: this.previews[ctrl].svg, position: this.position, data: this.data});
        }
        return {b64: this.previews[ctrl].b64, svg: this.previews[ctrl].svg, position: this.position, data: this.data};
    }

    updateStreamDeck(base64String) {

        this.position = {x: this.index * this.contextWidth * 2, y: 0};
        const svg = this.previews[this.#controller].svg;
        if(this.lastUpdateCache == svg) { // don't bother with updating Stream Deck if the svg hasn't changed
            //    this.dbg("updateStreamDeck::skipped", svg.length, this.lastUpdateCache.length);
            return;
        }

        // const img = this.previews[this.#controller].b64;
        if(this.sd) {
            // this.dbg('updateStreamDeck', this.id, this.context, this.controller);
            this.lastUpdateCache = svg;
            if(this.#controller == 'Encoder') {
                const dataJSN = {
                    payload: {
                        "full-canvas": {
                            value: `data:image/svg+xml,${svg};`
                        },
                        title: ''
                    }
                };
                this.sd.send(this.context, 'setFeedback', dataJSN);
            } else {
                this.sd.setImage(this.context, `data:image/svg+xml,${svg};`);
            }
        };
        this.emit('updatedStreamDeck', this);
    }

    showMessage(msg = '', delay = 2500) {
        if(this.data.$message === msg) return;
        this.data.$message = msg;
        this.updateLayout(true);
        this.updateLock = false;
        if(!this.__timer) this.__timer = setTimeout(() => {
            this.hideMessage();
        }, delay);
    }
    hideMessage() {
        if(this.__timer) clearTimeout(this.__timer);
        this.__timer = null;
        this.data.$message = '';
        this.updateLayout(true);
        this.updateLock = false;
    }

    /** EXPORT */
    encodedPreview() {
        this.previews[this.#controller].encodedPreview = `data:image/svg+xml;base64,${btoa(unescape(encodeURIComponent(svg)))}`;
        return this.previews[this.#controller].encodedPreview;
    }

    toSVG() {
        return this.updateLayout(false).svg;
    }

    toBase64() {
        return this.updateLayout(false).b64;
    }

    toDataURL(svg) {
        return this.containsUnicode(svg) ? `data:image/svg+xml;base64,${this.utoa(svg)}` : `data:image/svg+xml;base64,${btoa(svg)}`;
    }

    getData() {
        return this.utils.diff(this.defaults, this.data);
    }

    stringToSVG(svgString) {
        const doc = new DOMParser().parseFromString(
            svgString,
            "image/svg+xml"
        );
        return doc.querySelector('svg') || {};
    }

    export() {
        const svg = this.toSVG();
        return {
            id: this.id,
            data: this.data,
            position: this.position,
            svgString: svg,
            svg: this.stringToSVG(svg),
            width: this.width,
            height: this.height,
            contextWidth: this.contextWidth,
            contextHeight: this.contextHeight,
            index: this.index,
            layoutString: this.layoutString
        };
    };

    /** HELPERS */

    containsUnicode(s) {
        return /[^\u0000-\u00ff]/.test(s);
    };
    utoa(data) {
        return btoa(unescape(encodeURIComponent(data)));
    };
}
