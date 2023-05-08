/**
@file      meethue.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

const MDEBOUNCEDELAYMS = 80;

// Prototype which represents a Philips Hue bridge
function Bridge(ip = null, id = null, username = null) {
    // Init Bridge
    let instance = this;

    // Public function to pair with a bridge
    this.pair = (callback) => {
        if (ip) {
            let url = `http://${ip}/api`;
            let xhr = new XMLHttpRequest();
            xhr.responseType = 'json';
            xhr.open('POST', url, true);
            xhr.timeout = 2500;
            
            xhr.onload = () => {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                    if (xhr.response !== undefined && xhr.response != null) {
                        let result = xhr.response[0];

                        if ('success' in result) {
                            username = result['success']['username'];
                            callback(true, result);
                        }
                        else {
                            let message = result['error']['description'];
                            callback(false, message);
                        }
                    }
                    else {
                        callback(false, 'Bridge response is undefined or null.');
                    }
                }
                else {
                    callback(false, 'Could not connect to the bridge.');
                }
            };

            xhr.onerror = () => {
                callback(false, 'Unable to connect to the bridge.');
            };

            xhr.ontimeout = () => {
                callback(false, 'Connection to the bridge timed out.');
            };

            let obj = {};
            obj.devicetype = 'stream_deck';
            let data = JSON.stringify(obj);
            xhr.send(data);
        }
        else {
            callback(false, 'No IP address given.');
        }
    };

    // Public function to retrieve the username
    this.getUsername = () => {
        return username;
    };

    // Public function to retrieve the IP address
    this.getIP = () => {
        return ip;
    };

    // Public function to retrieve the ID
    this.getID = () => {
        return id;
    };

    // Public function to retrieve the name
    this.getName = callback => {
        let url = `http://${ip}/api/${username}/config`;
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open('GET', url, true);
        xhr.timeout = 5000;

        xhr.onload = () => {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                let result = xhr.response;

                if (result !== undefined && result != null) {
                    if ('name' in result) {
                        let name = result['name'];
                        callback(true, name);
                    }
                    else {
                        let message = result[0]['error']['description'];
                        callback(false, message);
                    }
                }
                else {
                    callback(false, 'Bridge response is undefined or null.');
                }
            }
            else {
                callback(false, 'Could not connect to the bridge.');
            }
        };

        xhr.onerror = () => {
            callback(false, 'Unable to connect to the bridge.');
        };

        xhr.ontimeout = () => {
            callback(false, 'Connection to the bridge timed out.');
        };

        xhr.send();
    };

    // Private function to retrieve objects
    function getMeetHues(type, callback) {
        let url;

        if (type === 'light') {
            url = `http://${ip}/api/${username}/lights`;
        }
        else if (type === 'group') {
            url = `http://${ip}/api/${username}/groups`;
        }
        else if (type === 'scene') {
            url = `http://${ip}/api/${username}/scenes`;
        }
        else {
            callback(false, 'Type does not exist.');
            return;
        }

        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open('GET', url, true);
        xhr.timeout = 5000;
    
        xhr.onload = () => {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                let result = xhr.response;

                if (result !== undefined && result != null) {
                    if (!Array.isArray(result)) {
                        let objects = [];

                        Object.keys(result).forEach(key => {
                            let value = result[key];

                            if (type === 'light') {
                                objects.push(new Light(instance, key, value.name, value.type, value.state.on, value.state.bri, value.state.xy, value.state.ct));
                            }
                            else if (type === 'group') {
                                objects.push(new Group(instance, key, value.name, value.type, value.state.all_on, value.action.bri, value.action.xy, value.action.ct));
                            }
                            else if (type === 'scene') {
                                objects.push(new Scene(instance, key, value.name, value.type, value.group));
                            }
                        });

                        callback(true, objects);
                    }
                    else {
                        let message = result[0]['error']['description'];
                        callback(false, message);
                    }
                }
                else {
                    callback(false, 'Bridge response is undefined or null.');
                }
            }
            else {
                callback(false, 'Unable to get objects of type ' + type + '.');
            }
        };

        xhr.onerror = () => {
            callback(false, 'Unable to connect to the bridge.');
        };

        xhr.ontimeout = () => {
            callback(false, 'Connection to the bridge timed out.');
        };

        xhr.send();
    }

    // Public function to retrieve the lights
    this.getLights = callback => {
        getMeetHues('light', callback);
    };

    // Public function to retrieve the groups
    this.getGroups = callback => {
        getMeetHues('group', callback);
    };

    // Public function to retrieve the scenes
    this.getScenes = callback => {
        getMeetHues('scene', callback);
    };
}

// Static function to discover bridges
Bridge.discover = callback => {
    let url = 'https://discovery.meethue.com';
    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json';
    xhr.open('GET', url, true);
    xhr.timeout = 10000;

    xhr.onload = () => {
        if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
            if (xhr.response !== undefined && xhr.response != null) {
                let bridges = [];

                xhr.response.forEach(bridge => {
                    bridges.push(new Bridge(bridge.internalipaddress, bridge.id));
                });

                callback(true, bridges);
            }
            else {
                callback(false, 'Meethue server response is undefined or null.');
            }
        }
        else {
            callback(false, 'Unable to discover bridges.');
        }
    };

    xhr.onerror = () => {
        callback(false, 'Unable to connect to the internet.');
    };

    xhr.ontimeout = () => {
        callback(false, 'Connection to the internet timed out.');
    };

    xhr.send();
};

// Check if a Bridge is available under a certain IP address
// If a username is set it will check that too
Bridge.check = (ip, username, callback) => {
    let url = username ? `http://${ip}/api/${username}config` : `http://${ip}/api/config`;
    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json';
    xhr.open('GET', url, true);
    xhr.timeout = 10000;

    xhr.onload = () => {
        if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200 &&
            xhr.response !== undefined && xhr.response != null &&
            xhr.response.hasOwnProperty('bridgeid') &&
            (!username || xhr.response.hasOwnProperty('ipaddress'))
        ) {
            // at this point the bridge has been found and added to list
            callback(true, {
                ip: ip,
                id: xhr.response.bridgeid.toLowerCase(),
            });
        }

        callback(false);
    };

    xhr.onerror = xhr.ontimeout = () => {
        callback(false);
    };

    xhr.send();
};

// Static function to convert hex to rgb
Bridge.hex2rgb = inHex => {
    // Remove hash if it exists
    if (inHex.charAt(0) === '#') {
        inHex = inHex.substr(1);
    }

    // Split hex into RGB components
    let rgbArray = inHex.match(/.{1,2}/g);

    // Convert RGB component into decimals
    let red = parseInt(rgbArray[0], 16);
    let green = parseInt(rgbArray[1], 16);
    let blue = parseInt(rgbArray[2], 16);

    return {
        r: red,
        g: green,
        b: blue,
    };
}

// Static function to convert rgb to hex
Bridge.rgb2hex = inRGB => {
    return '#' + ((1 << 24) + (inRGB.r << 16) + (inRGB.g << 8) + inRGB.b).toString(16).slice(1);
}

// Static function to convert rgb to hsv
Bridge.rgb2hsv = inRGB => {
    // Calculate the brightness and saturation value
    let max = Math.max(inRGB.r, inRGB.g, inRGB.b);
    let min = Math.min(inRGB.r, inRGB.g, inRGB.b);
    let d = max - min;
    let s = (max === 0 ? 0 : d / max);
    let v = max / 255;

    // Calculate the hue value
    let h;

    switch (max) {
        case min:
            h = 0;
            break;
        case inRGB.r:
            h = (inRGB.g - inRGB.b) + d * (inRGB.g < inRGB.b ? 6: 0);
            h /= 6 * d;
            break;
        case inRGB.g:
            h = (inRGB.b - inRGB.r) + d * 2;
            h /= 6 * d;
            break;
        case inRGB.b:
            h = (inRGB.r - inRGB.g) + d * 4;
            h /= 6 * d;
            break;
    }

    return {h, s, v};
}

// Static function to convert hsv to rgb
Bridge.hsv2rgb = inHSV => {
    let r = null;
    let g = null;
    let b = null;

    let i = Math.floor(inHSV.h * 6);
    let f = inHSV.h * 6 - i;
    let p = inHSV.v * (1 - inHSV.s);
    let q = inHSV.v * (1 - f * inHSV.s);
    let t = inHSV.v * (1 - (1 - f) * inHSV.s);

    // Calculate red, green and blue
    switch (i % 6) {
        case 0:
            r = inHSV.v;
            g = t;
            b = p;
            break;
        case 1:
            r = q;
            g = inHSV.v;
            b = p;
            break;
        case 2:
            r = p;
            g = inHSV.v;
            b = t;
            break;
        case 3:
            r = p;
            g = q;
            b = inHSV.v;
            break;
        case 4:
            r = t;
            g = p;
            b = inHSV.v;
            break;
        case 5:
            r = inHSV.v;
            g = p;
            b = q;
            break;
    }

    // Convert rgb values to int
    let red = Math.round(r * 255);
    let green = Math.round(g * 255);
    let blue = Math.round(b * 255);

    return {
        r: red,
        g: green,
        b: blue,
    };
}

// Static function to convert hex to hsv
Bridge.hex2hsv = inHex => {
    // Convert hex to rgb
    let rgb = Bridge.hex2rgb(inHex);

    // Convert rgb to hsv
    return Bridge.rgb2hsv(rgb);
}

// Static function to convert hsv to hex
Bridge.hsv2hex = inHSV => {
    // Convert hsv to rgb
    let rgb = Bridge.hsv2rgb(inHSV);

    // Convert rgb to hex
    return Bridge.rgb2hex(rgb);
}

// Static function to convert hex to xy
Bridge.hex2xy = inHex => {
    // Convert hex to rgb
    let rgb = Bridge.hex2rgb(inHex);

    // Concert RGB components to floats
    let red = rgb.r / 255;
    let green = rgb.g / 255;
    let blue = rgb.b / 255;

    // Convert RGB to XY
    let r = red > 0.04045 ? Math.pow(((red + 0.055) / 1.055), 2.4000000953674316) : red / 12.92;
    let g = green > 0.04045 ? Math.pow(((green + 0.055) / 1.055), 2.4000000953674316) : green / 12.92;
    let b = blue > 0.04045 ? Math.pow(((blue + 0.055) / 1.055), 2.4000000953674316) : blue / 12.92;
    let x = r * 0.664511 + g * 0.154324 + b * 0.162028;
    let y = r * 0.283881 + g * 0.668433 + b * 0.047685;
    let z = r * 8.8E-5 + g * 0.07231 + b * 0.986039;

    // Convert XYZ zo XY
    let xy = [x / (x + y + z), y / (x + y + z)];

    if (isNaN(xy[0])) {
      xy[0] = 0.0;
    }

    if (isNaN(xy[1])) {
      xy[1] = 0.0;
    }

    return xy;
};

// Prototype which represents a Philips Hue object
function MeetHue(bridge = null, id = null, name = null, type = null) {
    // Init MeetHue
    let instance = this;

    // Override in child prototype
    let url = null;

    // Public function to retrieve the type
    this.getType = () => {
        return type;
    };

    // Public function to retrieve the name
    this.getName = () => {
        return name;
    };

    // Public function to retrieve the ID
    this.getID = () => {
        return id;
    };

    // Public function to retrieve the URL
    this.getURL = () => {
        return url;
    };

    // Public function to set the URL
    this.setURL = inURL => {
        url = inURL;
    }

    // Public function to set light state
    this.setState = (state, callback) => {
        // Check if the URL was set
        if (instance.getURL() == null) {
            callback(false, 'URL is not set.');
            return;
        }

        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open('PUT', instance.getURL(), true);
        xhr.timeout = 2500;

        xhr.onload = () => {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                if (xhr.response !== undefined && xhr.response != null) {
                    let result = xhr.response[0];

                    if ('success' in result) {
                        callback(true, result);
                    }
                    else {
                        let message = result['error']['description'];
                        callback(false, message);
                    }
                }
                else {
                    callback(false, 'Bridge response is undefined or null.');
                }
            }
            else {
                callback(false, 'Could not set state.');
            }
        };

        xhr.onerror = () => {
            callback(false, 'Unable to connect to the bridge.');
        };

        xhr.ontimeout = () => {
            callback(false, 'Connection to the bridge timed out.');
        };

        let data = JSON.stringify(state);
        xhr.send(data);
    };
}

// Prototype which represents a scene
function Scene(bridge = null, id = null, name = null, type = null, group = null) {
    // Init Scene
    let instance = this;

    // Inherit from MeetHue
    MeetHue.call(this, bridge, id, name, type);

    // Set the URL
    this.setURL(`http://${bridge.getIP()}/api/${bridge.getUsername()}/groups/0/action`);

    // Public function to retrieve the group
    this.getGroup = () => {
        return group;
    };

    // Public function to set the scene
    this.on = callback => {
        // Define state object
        let state = {};
        state.scene = id;

        // Send new state
        instance.setState(state, callback);
    };
}

// Prototype which represents an illumination
function Illumination(bridge = null, id = null, name = null, type = null, power = null, brightness = null, xy = null, temperature = null) {
    // Init Illumination
    let instance = this;

    // Inherit from MeetHue
    MeetHue.call(this, bridge, id, name, type);

    // Public function to retrieve the power state
    this.getPower = () => {
        return power;
    };

    // Public function to retrieve the brightness
    this.getBrightness = () => {
        return brightness;
    };

    // Public function to retrieve xy
    this.getXY = () => {
        return xy;
    };

    // Public function to retrieve the temperature
    this.getTemperature = () => {
        return temperature;
    };

    // Public function to set the power status of the light
    this.setPower = (power, callback) => {
        // Define state object
        let state = {};
        state.on = power;

        // Send new state
        instance.setState(state, callback);
    };

    // Public function to set the brightness
    this.setBrightness = Utils.debounce((brightness, callback) => {
      // Define state object
      let state = {};
      state.bri = brightness;

      // To modify the brightness, the light needs to be on
      state.on = true;
      // Send new state
      instance.setState(state, callback);
  }, MDEBOUNCEDELAYMS);

    // Public function set the xy value
    this.setXY = (xy, callback) => {
        // Define state object
        let state = {};
        state.xy = xy;

        // To modify the color, the light needs to be on
        state.on = true;

        // Send new state
        instance.setState(state, callback);
    };

    // Public function set the temperature value
    this.setTemperature = Utils.debounce((temperature, callback) => {
        // Define state object
        let state = {};
        state.ct = temperature;

        // To modify the temperature, the light needs to be on
        state.on = true;

        // Send new state
        instance.setState(state, callback);
    }, MDEBOUNCEDELAYMS);
}

// Prototype which represents a light
function Light(bridge = null, id = null, name = null, type = null, power = null, brightness = null, xy = null, temperature = null) {
    // Inherit from Illumination
    Illumination.call(this, bridge, id, name, type, power, brightness, xy, temperature);

    // Set the URL
    this.setURL(`http://${bridge.getIP()}/api/${bridge.getUsername()}/lights/${id}/state`);
}

// Prototype which represents a group
function Group(bridge = null, id = null, name = null, type = null, power = null, brightness = null, xy = null, temperature = null) {
    // Inherit from Illumination
    Illumination.call(this, bridge, id, name, type, power, brightness, xy, temperature);

    // Set the URL
    this.setURL(`http://${bridge.getIP()}/api/${bridge.getUsername()}/groups/${id}/action`);
}
