/**
@file      utils.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Register the plugin or PI
function registerPluginOrPI(inEvent, inUUID) {
    if (websocket) {
        websocket.send(JSON.stringify({
            event: inEvent,
            uuid: inUUID,
        }));
	}
}

// Save settings
function saveSettings(inAction, inUUID, inSettings) {
    if (websocket) {
        websocket.send(JSON.stringify({
             action: inAction,
             event: 'setSettings',
             context: inUUID,
             payload: inSettings,
         }));
    }
}

// Save global settings
function saveGlobalSettings(inUUID) {
    if (websocket) {
        websocket.send(JSON.stringify({
             event: 'setGlobalSettings',
             context: inUUID,
             payload: globalSettings,
         }));
    }
}

// Request global settings for the plugin
function requestGlobalSettings(inUUID) {
    if (websocket) {
        websocket.send(JSON.stringify({
            event: 'getGlobalSettings',
            context: inUUID,
        }));
    }
}

// Log to the global log file
function logToFile(inMessage) {
    // Log to the developer console
    let timeString = new Date().toLocaleString();
    // Log to the Stream Deck log file
    if (websocket) {
        websocket.send(JSON.stringify({
            event: 'logMessage',
            payload: {
                message: inMessage,
            },
        }));
    }
}

const log = console.log.bind(
  console,
  '%c [HUE]',
  'color: #66c',
);

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

// const debug = true;
// Object.defineProperty(this, "log", {
//   get: function () {
//     return debug ? console.log.bind(window.console, test(), '[DEBUG]') : function(){};
//    }
// });


const debounce = (callback, time = 800) => {
  let timer;
  return (...args) => {
      clearTimeout(timer);
      timer = setTimeout(() => callback(...args), time);
  };
};

// Show alert icon on the key
function showAlert(inUUID) {
    if (websocket) {
        websocket.send(JSON.stringify({
            event: 'showAlert',
            context: inUUID,
        }));
    }
}

// Set the state of a key
function setState(inContext, inState) {
    if (websocket) {
        websocket.send(JSON.stringify({
            event: 'setState',
            context: inContext,
            payload: {
                state: inState,
            },
        }));
    }
}

// Set data to PI
function sendToPropertyInspector(inAction, inContext, inData) {
    if (websocket) {
        websocket.send(JSON.stringify({
            action: inAction,
            event: 'sendToPropertyInspector',
            context: inContext,
            payload: inData,
        }));
    }
}

// Set data to plugin
function sendToPlugin(inAction, inContext, inData) {
    if (websocket) {
        websocket.send(JSON.stringify({
            action: inAction,
            event: 'sendToPlugin',
            context: inContext,
            payload: inData,
        }));
    }
}

// Send feedback to the Stream Deck+ panel (SD+)
function setFeedback(inContext, inPayload) {
  if (websocket) {
      websocket.send(JSON.stringify({
           event: 'setFeedback',
           context: inContext,
           payload: inPayload,
       }));
  }
}

// Load the localizations
function getLocalization(inLanguage, inCallback) {
    let url = `../${inLanguage}.json`;
    let xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);

    xhr.onload = () => {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            try {
                let data = JSON.parse(xhr.responseText);
                let localization = data['Localization'];
                inCallback(true, localization);
            }
            catch(e) {
                inCallback(false, 'Localizations is not a valid json.');
            }
        }
        else {
            inCallback(false, 'Could not load the localizations.');
        }
    };

    xhr.onerror = () => {
        inCallback(false, 'An error occurred while loading the localizations.');
    };

    xhr.ontimeout = () => {
        inCallback(false, 'Localization timed out.');
    };

    xhr.send();
}

const Utils = {};
Utils.debounce = function(func, wait = 100) {
  let timeout;
  return function(...args) {
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

Utils.capitalize = function(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
};

Utils.minmax = function(v = 0, min = 0, max = 100) {
  return Math.min(max, Math.max(min, v));
};
