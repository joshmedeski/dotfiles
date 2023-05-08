/**
@file      propertyAction.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype which represents a brightness action
function PropertyAction(inContext, inSettings, jsn) {

  let instance = this;
  this.keyIsDown = false;
  this.actionTriggered = false;
  const setStateFunction = `set${Utils.capitalize(this.property)}`;

  // Inherit from Action
  Action.call(this, inContext, inSettings, jsn);

  // Set the default values
  setDefaults();

  this.updateAction = function() {
    const target = this.getCurrentLightOrGroup();
    if(target === false) return;
    this.updateDisplay(target.objCache, this.property);
  };

  if(this.isEncoder) {
    let timer = setInterval(() => {
      this.updateAction();
    }, 5000);
  }

  this.getCurrentLightOrGroup = function() {
    let settings = this.getVerifiedSettings(inContext);
    if(settings === false) return false; // break if settings are not valid
    let bridgeCache = cache.data[settings.bridge]; // we have a valid bridge (was checked in getVerifiedSettings)
    let objCache = {};
    let obj = {};
    let bridge = new Bridge(bridgeCache.ip, bridgeCache.id, bridgeCache.username);
    if(settings.light.indexOf('l') !== -1) {
      objCache = bridgeCache.lights[settings.light];
      if(objCache) {
        obj = new Light(bridge, objCache.id);
      }
    }
    else {
      objCache = bridgeCache.groups[settings.light];
      if(objCache) {
        obj = new Group(bridge, objCache.id);
      }
    }
    return {obj, objCache};
  };

  this.setValue = function(inValue, jsn) {
    const target = this.getCurrentLightOrGroup();
    if(target) {
      if(target.objCache.power === false) return;
      let value = inValue ? inValue : target.objCache[this.property];

      if(jsn?.payload?.ticks) {
        let settings = this.getSettings();
        const scaleTicks = settings?.scaleTicks || 1;
        const multiplier = scaleTicks * jsn.payload.ticks;
        value = Utils.minmax(parseInt(value + multiplier * 2.55), 0,255);
        // value = parseInt(value + jsn.payload.ticks * 2.55);
      }

      // just update the panel optimistically
      // note: this didn't work well for me, so I'm not using it
      // this.setFeedback(inContext, parseInt(value / 2.54), 1);

      target.obj[setStateFunction](value, (inSuccess, inError) => {
        if(inSuccess) {
          target.objCache[this.property] = value;
          this.updateDisplay(target.objCache, this.property);
          this.updateAllActions();
        } else {
          log(inError);
          showAlert(inContext);
        }
      });
    }

  };

  this.onDialPress = function(jsn) {
    if(this.getVerifiedSettings(inContext) === false) return;
    if(jsn?.payload?.pressed === true) {  // dial pressed == down
      // temporarily set a flag to mark that the key is down
      this.keyIsDown = true;
      this.actionTriggered = false;
      setTimeout(function() {
        if(instance.keyIsDown) {
          // console.log("***** long keypress detected:", instance.keyIsDown,inContext);
          const target = instance.togglePower(inContext);
          instance.updateDisplay(target.objCache, 'power');
          instance.actionTriggered = true;
        }
        instance.keyIsDown = false;
      }, 500);
    } else { // dial released == up
      this.keyIsDown = false;
      if(!this.actionTriggered) {
        const target = this.getCurrentLightOrGroup();
        // check if light is off, and if it is, turn it on
        if(target.objCache.power === false) {
          this.togglePower(inContext);
          this.updateDisplay(target.objCache, 'power');
        } else {
          // otherwise, just change the property to the configured value
          this.onKeyUp(inContext);
        }
      }
    }
  };

  this.onDialRotate = function(jsn) {
    this.setValue(null, jsn);
  };

  this.onTouchTap = function(jsn) {
    this.togglePower(inContext);
  };

  // Public function called on key up event
  this.onKeyUp = (inContext) => {
    const settings = this.getVerifiedSettings(inContext);
    if(settings === false) return;
    // Convert value
    let value = Math.round(settings[this.property] * 2.54);
    this.setValue(value);
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

    // If property is already set for this action
    if(this.property in settings) {
      return;
    }

    // Set the property to 100
    settings[this.property] = 100;

    // Save the settings
    saveSettings(`com.elgato.philips-hue.${this.property}`, context, settings);
  }

  // update the action and its display
  this.updateActionIfCacheAvailable(inContext);

}
