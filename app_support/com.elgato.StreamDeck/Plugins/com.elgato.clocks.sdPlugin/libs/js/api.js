/// <reference path="events.js"/>

class ELGSDPlugin {
    #data = {};
    #language = 'en';
    #localization;
    test = new Set();
    on = EventEmitter.on;
    emit = EventEmitter.emit;

    localizationLoaded = false;
    constructor () {
        // super();
        if(ELGSDPlugin.__instance) {
            return ELGSDPlugin.__instance;
        }

        ELGSDPlugin.__instance = this;
        const pathArr = location.pathname.split("/");
        const idx = pathArr.findIndex(f => f.endsWith('sdPlugin'));
        this.#data.__filename = pathArr[pathArr.length - 1];
        this.#data.__dirname = pathArr[pathArr.length - 2];
        this.#data.__folderpath = `${pathArr.slice(0, idx + 1).join("/")}/`;
        this.#data.__folderroot = `${pathArr.slice(0, idx).join("/")}/`;
        this.#data.__parentdir = `${pathArr.slice(0, idx-1).join("/")}/`;
    }

    set language(value) {
        this.#language = value;
        this.loadLocalization(this.#data.__folderpath).then(l => {
            this.emit('languageChanged', value);
        });
    }

    get language() {
        return this.#language;
    }

    set localization(value) {
        this.#localization = value;
        this.localizeUI();
        this.emit('localizationChanged', value);
    }

    get localization() {
        return this.#localization;
    }

    get __filename() {
        return this.#data.__filename;
    }

    get __dirname() {
        return this.#data.__dirname;
    }

    get __folderpath() {
        return this.#data.__folderpath;
    }
    get __folderroot() {
        return this.#data.__folderroot;
    }
    get data() {
        return this.#data;
    }

    /**
    * Finds the original key of the string value
    * Note: This is used by the localization UI to find the original key (not used here)
    * @param {string} str
    * @returns {string}
    */

    localizedString(str) {
        return Object.keys(this.localization).find(e => e == str);
    }

    /**
   * Returns the localized string or the original string if not found
   * @param {string} str
   * @returns {string}
   */

    localize(s) {
        if(typeof s === 'undefined') return '';
        let str = String(s);
        try {
            str = this.localization[str] || str;
        } catch(b) {}
        return str;
    };

    /**
    * Searches the document tree to find elements with data-localize attributes
    * and replaces their values with the localized string
    * @returns {<void>}
    */

    localizeUI = () => {
        const el = document.querySelector('.sdpi-wrapper');
        if(!el) return console.warn("No element found to localize");
        const selectorsList = '[data-localize]';
        // see if we have any data-localize attributes
        // that means we can skip the rest of the DOM
        el.querySelectorAll(selectorsList).forEach(e => {
            const s = e.innerText.trim();
            e.innerHTML = e.innerHTML.replace(s, this.localize(s));
            if(e.placeholder && e.placeholder.length) {
                e.placeholder = this.localize(e.placeholder);
            }
            if(e.title && e.title.length) {
                e.title = this.localize(e.title);
            }
        });
    };
    /**
     * Fetches the specified language json file
     * @param {string} pathPrefix
     * @returns {Promise<void>}
     */
async loadLocalization(pathPrefix) {
    if(!pathPrefix) {
        pathPrefix = this.#data.__folderpath;
    }
    // here we save the promise to the JSON-reader result,
    // which we can later re-use to see, if the strings are already loaded 
    this.localizationLoaded = this.readJson(`${pathPrefix}${this.language}.json`);
    const manifest = await this.localizationLoaded;
    this.localization = manifest['Localization'] ?? null;
    window.$localizedStrings = this.localization;
    this.emit('localizationLoaded', this.localization);

    return this.localization;
}

    /**
     *
     * @param {string} path
     * @returns {Promise<any>} json
     */
    async readJson(path) {
        if(!path) {
            console.error('A path is required to readJson.');
        }

        return new Promise((resolve, reject) => {
            const req = new XMLHttpRequest();
            req.onerror = reject;
            req.overrideMimeType('application/json');
            req.open('GET', path, true);
            req.onreadystatechange = (response) => {
                if(req.readyState === 4) {
                    const jsonString = response?.target?.response;
                    if(jsonString) {
                        resolve(JSON.parse(response?.target?.response));
                    } else {
                        reject();
                    }
                }
            };

            req.send();
        });
    }
}

class ELGSDApi extends ELGSDPlugin {
    port;
    uuid;
    messageType;
    actionInfo;
    websocket;
    appInfo;
    #data = {};
    
    /**
     * Connect to Stream Deck
     * @param {string} port
     * @param {string} uuid
     * @param {string} messageType
     * @param {string} appInfoString
     * @param {string} actionString
     */
    connect(port, uuid, messageType, appInfoString, actionString) {
        this.port = port;
        this.uuid = uuid;
        this.messageType = messageType;
        this.actionInfo = actionString ? JSON.parse(actionString) : null;
        this.appInfo = JSON.parse(appInfoString);
        this.language = this.appInfo?.application?.language ?? null;

        if(this.websocket) {
            this.websocket.close();
            this.websocket = null;
        }

        this.websocket = new WebSocket('ws://127.0.0.1:' + this.port);

        this.websocket.onopen = () => {
            const json = {
                event: this.messageType,
                uuid: this.uuid,
            };

            this.websocket.send(JSON.stringify(json));

            this.emit(Events.connected, {
                connection: this.websocket,
                port: this.port,
                uuid: this.uuid,
                actionInfo: this.actionInfo,
                appInfo: this.appInfo,
                messageType: this.messageType,
            });
        };

        this.websocket.onerror = (evt) => {
            const error = `WEBSOCKET ERROR: ${evt}, ${evt.data}, ${SocketErrors[evt?.code]}`;
            console.warn(error);
            this.logMessage(error);
        };

        this.websocket.onclose = (evt) => {
            console.warn('WEBSOCKET CLOSED:', SocketErrors[evt?.code]);
        };

        this.websocket.onmessage = (evt) => {
            const data = evt?.data ? JSON.parse(evt.data) : null;

            const {action, event} = data;
            const message = action ? `${action}.${event}` : event;
            if(message && message !== '') this.emit(message, data);
        };
    }

    /**
     * Write to log file
     * @param {string} message
     */
    logMessage(message) {
        if(!message) {
            console.error('A message is required for logMessage.');
        }

        try {
            if(this.websocket) {
                const json = {
                    event: Events.logMessage,
                    payload: {
                        message: message,
                    },
                };
                this.websocket.send(JSON.stringify(json));
            } else {
                console.error('Websocket not defined');
            }
        } catch(e) {
            console.error('Websocket not defined');
        }
    }

    /**
     * Send JSON payload to StreamDeck
     * @param {string} context
     * @param {string} event
     * @param {object} [payload]
     */
    send(context, event, payload = {}) {
        this.websocket && this.websocket.send(JSON.stringify({context, event, ...payload}));
    }

    /**
     * Save the plugin's persistent data
     * @param {object} payload
     */
    setGlobalSettings(payload) {
        this.send(this.uuid, Events.setGlobalSettings, {
            payload: payload,
        });
    }

    /**
     * Request the plugin's persistent data. StreamDeck does not return the data, but trigger the plugin/property inspectors didReceiveGlobalSettings event
     */
    getGlobalSettings() {
        this.send(this.uuid, Events.getGlobalSettings);
    }

    /**
     * Opens a URL in the default web browser
     * @param {string} url
     */
    openUrl(url) {
        if(!url) {
            console.error('A url is required for openUrl.');
        }

        this.send(this.uuid, Events.openUrl, {
            payload: {
                url,
            },
        });
    }

    /**
     * Registers a callback function for when Stream Deck is connected
     * @param {function} fn
     * @returns ELGSDStreamDeck
     */
    onConnected(fn) {
        if(!fn) {
            console.error('A callback function for the connected event is required for onConnected.');
        }

        this.on(Events.connected, (jsn) => fn(jsn));
        return this;
    }

    /**
     * Registers a callback function for the didReceiveGlobalSettings event, which fires when calling getGlobalSettings
     * @param {function} fn
     */
    onDidReceiveGlobalSettings(fn) {
        if(!fn) {
            console.error(
                'A callback function for the didReceiveGlobalSettings event is required for onDidReceiveGlobalSettings.'
            );
        }

        this.on(Events.didReceiveGlobalSettings, (jsn) => fn(jsn));
        return this;
    }

    /**
     * Registers a callback function for the didReceiveSettings event, which fires when calling getSettings
     * @param {string} action
     * @param {function} fn
     */
    onDidReceiveSettings(action, fn) {
        if(!fn) {
            console.error(
                'A callback function for the didReceiveSettings event is required for onDidReceiveSettings.'
            );
        }

        this.on(`${action}.${Events.didReceiveSettings}`, (jsn) => fn(jsn));
        return this;
    }
}
