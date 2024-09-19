/// <reference path="DynamicAction.js" />

const defaultEvents = {
    initialized: function(jsn) {
        // console.log("Inititalized", this.id, {...this.data});
    },
    clicked: function() {
        console.log("clicked", this.id, {...this.data}, this.dialStack);
        //  
        if(this.state.lastTicks === 0 && this.data.hasOwnProperty('mode')) {
            this.data.mode = 1 - this.data.mode;
        }
        this.data.fontColor = '#FFFFFF';
    },
    pressed: function() {
        this.data.fontColor = '#00AAFF';
    },
    released: function() {
        this.data.fontColor = '#FFFFFF';
    },
    rotated: function(jsn) {
        console.log('rotated', jsn);
        const arr = jsn?.payload?.pressed ? ['value2', 'value1'] : ['value1', 'value2'];
        const mode = this.data.mode || 0;
        const minmax = (v = 0, min = 0, max = 100) => Math.min(max, Math.max(min, v));
        const newValue = typeof jsn === 'number' ? this.data[arr[mode]] + jsn : this.data[arr[mode]] + jsn?.payload?.ticks || 1;
        this.data[arr[mode]] = minmax(newValue, 0, this.data.maxValue || 100);
        return this.data[arr[mode]];

    },
    updated: function(data) {
        // console.log('updated', this.id, this.context, data);
        // $SD.api.setImage(this.context, data.b64);
    }
};

// private eval function for the context of the template
const STREAMDECK = {};
class ELGSDTemplateLoader {

    templateId;
    templateUrl = '__internal__';
    templateData;
    #promise;
    dynamicActionPath = './action/templates/';
    // dynamicActionPath = './js/';
    // dbg(message, ...args) {
    //     console.log('%c[ELGSDTemplateLoader]', 'color: #66c', message, ...args);
    // }

    // dbg = console.log.bind(
    //     console,
    //     `%c [ELGSDTemplateLoader]`,
    //     'color: #39e',
    // )

    dbg = () => {};

    constructor (options) {
        this.dbg.error = (message, ...args) => {
            console.error(`%c[LGSDTemplateLoader Error]`, 'color: #fff;background: #c33;', message, ...args);
        };
        const template = options.template;
        const preset = options.preset || {};
        // const hasPreset = font?.hasOwnProperty('preset') ?? false;

        if(options.hasOwnProperty('dynamicActionPath')) {
            this.dynamicActionPath = options.dynamicActionPath;
        };
        this.dbg('constructor', template, preset, this.dynamicActionPath);
        if(typeof template === 'object') {
            this.loadTemplate(template, this.templateUrl);
            if(preset) this.loadPreset(preset.preset);
        } else {
            this.getTemplateData(template);
            this.#promise = this.readTemplate(this.templateUrl).then(data => {
                this.loadTemplate(data, this.templateUrl);
                if(preset) this.loadPreset(preset.preset);
                return this.templateData;
            }).catch((error) => {
                console.error('ERROR', error);
            });
        }
        this.createPreviewForLayout();
    }

    get privateData() {
        const obj = {};
        const data = this.templateData.data;
        Object.keys(data).filter(e => !e.startsWith('$') && !e.startsWith('__') && !data.hasOwnProperty(`__${e}`)).map(e => {
            obj[e] = data[e];
        });
        return obj;
    }

    loaded() {
        return this.#promise || new Promise((resolve, reject) => {
            if(this.templateData) {
                resolve(this.templateData);
            } else {
                reject('No template data');
            }
        });
    }
    getTemplateData(template) {
        if(template instanceof File) {
            this.templateId = template.name;
            this.templateUrl = `${template.lastModified}-${template.size}-${template.name}`;
        } else {
            this.templateId = template;
            this.templateUrl = template.split('.').pop() === 'js' ? `${this.dynamicActionPath}${template}` : `${this.dynamicActionPath}${template}.js`;
        }
    }

    createPreviewForLayout() {
        if(typeof DynamicAction !== 'undefined' && this.templateData) {
            const dynamicAction = new DynamicAction(this.templateData);
            dynamicAction.updateLayout(false);
            if(dynamicAction.b64) {
                this.templateData.preview = dynamicAction.b64;  //dynamicAction.toDataURL(dynamicAction.b64);
            } else if(dynamicAction.svg) {
                this.templateData.preview = dynamicAction.toDataURL(dynamicAction.svg);
            }
            dynamicAction.destroy();
        }
    };
    loadPreset(presetData) {
        this.dbg('loadPreset', this.templateData, presetData);
        if(!presetData) return;
        const privateData = Object.keys(this.templateData.data).filter(e => !e.startsWith('$') && !e.startsWith('__') && !this.templateData.data.hasOwnProperty(`__${e}`));
        privateData.forEach(d => {
            if(presetData.hasOwnProperty(d)) {
                this.templateData.data[d] = {...presetData[d]};
            }
        });
    };

    // loadTemplateToWorker(){
    //     const workerCode = document.getElementById('workerCode').textContent;
    //     if(templateData.startsWith('STREAMDECK.template')) {
    //         const wBlob = new Blob([templateData], { type: 'application/javascript' });
    //         const worker = new Worker(URL.createObjectURL(wBlob));
    //         return worker;
    //     }
    // }

    prepareTemplate(templateId, sdData) {
        this.dbg("prepareTemplate", templateId, sdData, typeof templateId, templateId.hasOwnProperty('id'), templateId.id);
        if(typeof templateId === 'object') {
            if(!templateId.hasOwnProperty('id') || templateId.id == '__none__') {
                console.error('prepareTemplate: id is required');
                templateId.id = Utils.randomString();
            }
            return templateId;
        }
        return {id: templateId, sdData};
    };

    loadTemplate(data, moduleUrl, storeAction = 'addLayout') {
        let fn = null;
        try {
            if(typeof data === 'object') {
                // fn = STREAMDECK.template(data);
                fn = this.prepareTemplate(data);
                this.dbg("template is an object", fn);
            } else if(data.startsWith('STREAMDECK.template')) {
                const obj = eval(data);
                fn = obj.sdData;
            } else {
                fn = Function('defaultEvents', data)(defaultEvents);
                const __data = {defaultEvents};
                const keys = Object.keys(__data);
                const values = Object.values(__data);
                const result = true ? `return \`${data}\`;` : `${data}`;
                fn = Function(...keys, result)(...values);
                this.dbg("created function", fn.id, fn);
            }
            fn.url = moduleUrl;
            fn.__originalData = data;
        } catch(err) {
            console.error('Template data contains errors', err, data);
        }
        // if(fn) createPreviewForLayout(fn);
        // store.dispatch('addLayout', fn);
        // if(storeAction && storeAction.length) store.dispatch(storeAction, fn);
        // else {
        //     console.warn("No store action provided", storeAction);
        // }
        this.templateId = fn?.id;
        this.templateData = fn;
        return fn;
    };

    readTemplate(template = null, type = 'text') {
        return new Promise(function(resolve, reject) {
            if(template instanceof File) {
                resolve(template.text());
            } else {
                const req = new XMLHttpRequest();
                req.withCredentials = true; // should be default anyway
                req.responseType = type;
                // req.overrideMimeType("application/javascript");

                req.onload = () => {
                    resolve(req.response);
                };

                ['abort', 'error'].forEach((evt) => {
                    req.addEventListener(evt, (error) => {
                        reject(error);
                    });
                });
                req.open('GET', template);
                req.send();
            }
        });
    };
}

STREAMDECK.template = (templateId, sdData) => {
    // console.log("****** STREAMDECK.template", templateId, sdData, typeof templateId, templateId.hasOwnProperty('id'), templateId.id);
    if(typeof templateId === 'object') {
        if(!templateId.hasOwnProperty('id') || templateId.id == '__none__') {
            console.error('STREAMDECK.template: id is required');
            templateId.id = Utils.randomString();
        }
        return templateId;
    }
    return {id: templateId, sdData};
};
