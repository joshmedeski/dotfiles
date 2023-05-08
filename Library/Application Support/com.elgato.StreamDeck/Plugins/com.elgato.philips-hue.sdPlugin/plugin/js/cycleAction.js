/**
@file      cycleAction.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype which represents a color action
function CycleAction(inContext, inSettings) {
  // Init CycleAction
  let instance = this;

  // Index of current active Color
  let currentColor = -1;

  // Inherit from Action
  Action.call(this, inContext, inSettings);

  // Set the default values
  setDefaults();

  // Public function called on key up event
  this.onKeyUp = (inContext) => {
    const settings = this.getVerifiedSettings(inContext, 'colors');
    if(false === settings) return;

    let bridgeCache = cache.data[settings.bridge];

    // Create a bridge instance
    let bridge = new Bridge(bridgeCache.ip, bridgeCache.id, bridgeCache.username);

    // Create a light or group object
    let objCache, obj;
    if(settings.light.indexOf('l') !== -1) {
      objCache = bridgeCache.lights[settings.light];
      obj = new Light(bridge, objCache.id);
    }
    else {
      objCache = bridgeCache.groups[settings.light];
      obj = new Group(bridge, objCache.id);
    }

    // Reset current Color index
    if(currentColor + 1 >= settings.colors.length) {
      currentColor = -1;
    }

    let colorIndex = currentColor + 1;

    // Check if this is a color or temperature light
    if(settings.colors[colorIndex].indexOf('#') !== -1) {
      // Convert light color to hardware independent XY color
      let xy = Bridge.hex2xy(settings.colors[colorIndex]);

      // Set light or group state
      obj.setXY(xy, (inSuccess, inError) => {
        if(inSuccess) {
          objCache.xy = xy;
          ++currentColor;
        }
        else {
          log(inError);
          showAlert(inContext);
        }
      });
    }
    else {
      // Note: Some lights do not support the full range
      let min = 153.0;
      let max = 500.0;

      let minK = 2000.0;
      let maxK = 6500.0;

      // Convert light color
      let percentage = (settings.colors[colorIndex] - minK) / (maxK - minK);
      let invertedPercentage = -1 * (percentage - 1.0);
      let temperature = Math.round(invertedPercentage * (max - min) + min);

      // Set light or group state
      obj.setTemperature(temperature, (inSuccess, inError) => {
        if(inSuccess) {
          objCache.ct = temperature;
          ++currentColor;
        }
        else {
          log(inError);
          showAlert(inContext);
        }
      });
    }
  };

  // Before overwriting parent method, save a copy of it
  let actionNewCacheAvailable = this.newCacheAvailable;

  // Public function called when new cache is available
  this.newCacheAvailable = inCallback => {
    // Call actions newCacheAvailable method
    actionNewCacheAvailable.call(instance, () => {
      // Set defaults
      setDefaults();

      // Call the callback function
      inCallback();
    });
  };

  // Private function to set the defaults
  function setDefaults() {
    // Get the settings and the context
    let settings = instance.getSettings();
    let context = instance.getContext();

    // Check if any bridge is configured
    if(!('bridge' in settings)) {
      return;
    }

    // Check if the configured bridge is in the cache
    if(!(settings.bridge in cache.data)) {
      return;
    }

    // Find the configured bridge
    let bridgeCache = cache.data[settings.bridge];

    // Check if a light was set for this action
    if(!('light' in settings)) {
      return;
    }

    // Check if the configured light or group is in the cache
    if(!(settings.light in bridgeCache.lights || settings.light in bridgeCache.groups)) {
      return;
    }

    // Get a light or group cache
    let lightCache;
    if(settings.light.indexOf('l-') !== -1) {
      lightCache = bridgeCache.lights[settings.light];
    }
    else {
      lightCache = bridgeCache.groups[settings.light];
    }

    // Check if any color is configured
    if('colors' in settings) {
      // Check if the set color is supported by the light
      if(settings.colors[0].charAt(0) === '#' && lightCache.xy != null) {
        return;
      }
      else if(settings.colors[0].charAt(0) !== '#' && lightCache.xy == null) {
        return;
      }
    }

    // Check if the light supports all colors
    if(lightCache.xy != null) {
      // Set white as the default color
      settings.colors = ['#ff0000', '#00ff00', '#0000ff'];
    }
    else {
      // Set white as the default temperature
      settings.colors = ['2230', '4250', '6410'];
    }

    // Save the settings
    saveSettings('com.elgato.philips-hue.cycle', context, settings);
  }
}
