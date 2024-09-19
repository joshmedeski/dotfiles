class ESDProxy {

    #handler;
    #cache;
    constructor (target, handler) {
        this.#cache = new WeakMap();
        this.#handler = handler;
        this.dbg = console.log.bind(
            console,
            `%c [ELGSDProxy]`,
            'color: #75A',
        );
        return this.proxify(target, []);
    }

    compareArray(arr, arr2) {
        return (
            Array.isArray(arr) && Array.isArray(arr2) && arr.length === arr2.length &&
            arr.every((value, index) => value === arr2[index])
        );
    };
    compareObject(obj, obj2) {
        return (
            typeof obj === 'object' && typeof obj2 === 'object' &&
            Object.keys(obj).length === Object.keys(obj2).length &&
            Object.keys(obj).every((key) => {
                return obj[key] === obj2[key];
            })
        );
    };
    compare(obj, obj2) {
        // if(!obj || !obj2) {
        //     return false;
        // }
        if(obj === undefined || typeof obj2 === undefined) {
            return false;
        }
        if(obj instanceof Date || obj2 instanceof Date) {
            return obj.getTime() === obj2.getTime();
        }
        if(Array.isArray(obj)) {
            return this.compareArray(obj, obj2);
        }
        if(typeof obj === 'object') {
            return this.compareObject(obj, obj2);
        }
        return obj === obj2;
    };


    createProxyHandler(path) {

        // wrapping a Proxy steals 'this' so we need to bind it
        let self = this;
        return {
            set(target, key, value, receiver) {
                let equal = false;
                if(value !== null && typeof value === 'object' && !(value instanceof Date)) {
                    value = self.proxify(value, [...path, key]);
                }
                equal = self.compare(target[key], value);
              
                if(!equal || !(key in target)) {
                    target[key] = value;

                    // self.dbg('createProxyHandler:set', path, key, value);

                    if(self.#handler.set) {
                        self.#handler.set(target, [...path, key], value, receiver);
                    }
                }
                return true;
            },

            // get: function(target, key) {
            //     return key in target ?
            //         target[key].bind(target) : undefined
            // },
            // get: (target, key, receiver) => {
            //     if((key in target)) {
            //         if(typeof target[key] == 'function') {
            //             if(target instanceof Date) {
            //                 console.log("PROXY", typeof target[key],  target instanceof Date, key, target[key], target);
            //                 if(target instanceof Date) {
            //                     // console.log("PROXY", receiver.getMonth());
            //                 }
            //             }
            //             return target[key].bind(this);
            //         }
            //         return target[key];
            //     }
            //     const value = Reflect.get(target, key, receiver);
            //     return value;
            // },

            deleteProperty(target, key) {
                if(Reflect.has(target, key)) {
                    self.unproxify(target, key);
                    let deleted = Reflect.deleteProperty(target, key);
                    if(deleted && self.#handler.deleteProperty) {
                        self.#handler.deleteProperty(target, [...path, key]);
                    }
                    return deleted;
                }
                return false;
            }
        };
    }

    unproxify(obj, key) {
        if(this.#cache.has(obj[key])) {
            // console.log('unproxify',key);
            obj[key] = this.#cache.get(obj[key]);
            this.#cache.delete(obj[key]);
        }
        Object.keys(obj[key]).forEach(k => {
            if(typeof obj[key][k] === 'object') {
                this.unproxify(obj[key], k);
            }
        });
    }

    proxify(obj, path) {
        Object.keys(obj).forEach(key => {
            if(obj && obj[key] instanceof Date) {
                console.log("PROXY is a date: can not proxy dates", obj[key], obj[key].getMonth());
                // obj[key] = new Date(obj[key]);
            } else if(typeof obj[key] === 'object' && obj[key] !== null) {
                obj[key] = this.proxify(obj[key], [...path, key]);
            }
        });
        let p = new Proxy(obj, this.createProxyHandler(path));
        this.#cache.set(p, obj);
        return p;
    }
}

// TEST ESDProxy

/*

let obj = {
    foo: 'baz',
}


let esdproxy;
esdproxy = new ESDProxy(obj, {
    set(target, path, value, receiver) {
        const k = path[path.length-1];
        if(k.charAt(0) === '$') {
            // this.dbg("private variable - returning");
            // return false;
        }
        console.log('ESDProxy:set', k,{target, path, value, receiver});
        console.log('ESDProxy:set', path.join('.'), '=', JSON.stringify(value));
    },

    deleteProperty(target, path) {
        console.log('ESDProxy:delete', path.join('.'));
    }
});

console.log("ESDProxy", esdproxy)

window.esdproxy = esdproxy;

esdproxy.foo = 'bar';
esdproxy.deep = {}
esdproxy.deep.blue = 'sea';
delete esdproxy.foo;
delete esdproxy.deep; // 

esdproxy.dip={welt: "Hallo", zwo: 2, data: {otto: 'waalkes', oma: 'opa', $dollar: 'DOLLAR'}}

*/
