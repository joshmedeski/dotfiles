/**
@file      action.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype which represents an action
function Action(inContext, inSettings, jsn) {
    // Init Action
    let instance = this;
    let debounceDelay = 50;

    // Private variable containing the context of the action
    let context = inContext;
    this.isEncoder = jsn?.payload?.controller == 'Encoder';
    this.isInMultiAction = jsn?.payload?.isInMultiAction;

    this.savedValue = -1;
    this.savedPower = null;
    // Private variable containing the settings of the action
    let settings = inSettings;
    
    let updateActionsEvent = new CustomEvent('updateActions', {detail: {sender: this}} );

    // Set the default values
    setDefaults();

    // Public function returning the context
    this.getContext = () => {
        return context;
    };

    // Public function returning the settings
    this.getSettings = () => {
        return settings;
    };

    // Public function for settings the settings
    this.setSettings = inSettings => {
        settings = inSettings;
    };

    // Public function called when new cache is available
    this.newCacheAvailable = inCallback => {
        // Set default settings
        setDefaults(inCallback);
    };

    this.updateAllActions = () => {
      document.dispatchEvent(updateActionsEvent);
    };

    this.updateActionIfCacheAvailable = (ctx) => {
        // update the action and its display
      const cacheSize = Object.keys(cache.data).length;
      if(cacheSize === 0) {
        // after a willAppear event, the cache is not yet available
        wait(1000).then(() => {
          this.updateAction();
        });
      } else {
        this.updateAction();
      }
    }

    this.setFeedback = (context, value, opacity) => {
      console.assert(websocket, 'no connection to websocket');
      if(websocket && this.isEncoder) {
        // send the values to the encoder  (SD+)
        setFeedback(context, {
          value: {
            value,
            opacity
          },
          indicator: {
            value,
            opacity
          }
        });
      }
    };

    this.updateDisplay = (lightOrGroup, property) => {
      if(this.isInMultiAction || !this.isEncoder) return;
      const powerHue = property == 'power' ? !lightOrGroup?.power : lightOrGroup?.power;
      let actionValue = lightOrGroup?.[this.property];
  
      // check if the values have changed
      if(actionValue === this.savedValue && powerHue === this.savedPower) {
        return;
      }
      // cache the values
      this.savedValue = actionValue;
      this.savedPower = powerHue;
  
      // values in hue are 0-254, convert to 0-100
      const value = parseInt(actionValue/2.54);
      // if the light is off, set the opacity to 0.5
      const opacity = powerHue ? 1 :0.5;
      this.setFeedback(inContext, value, opacity);
    };

    this.togglePower = (inContext) => {
      const target = this.getCurrentLightOrGroup();
      if(!target) return;
      const targetState = !target.objCache.power;
      target.obj.setPower(targetState, (success, error) => {
        if (success) {
            target.objCache.power = targetState;
            // cache.refresh();
            this.updateAllActions();
        }
        else {
            log(error);
            showAlert(inContext);
        }
      });
      return target;
    };

    this.getVerifiedSettings = function(inContext, requiredPropertySetting = null) {

      // Check if any bridge is configured
      if(!('bridge' in settings)) {
        log('No bridge configured');
        showAlert(inContext);
        return false;
      }
  
      // Check if the configured bridge is in the cache
      if(!(settings.bridge in cache.data)) {
        log(`Bridge ${settings.bridge} not found in cache`);
        showAlert(inContext);
        return false;
      }
  
      // Check if any light is configured
      if(!('light' in settings)) {
        log('No light or group configured');
        showAlert(inContext);
        return false;
      }

      if(requiredPropertySetting) {
        if(!(requiredPropertySetting in settings)) {
          log(`No ${requiredPropertySetting} configured`);
          showAlert(inContext);
          return;
        }
      }
   
      // Find the configured bridge
      let bridgeCache = cache.data[settings.bridge];
      if(bridgeCache === false) {
        console.warn('getVerifiedSettings: no bridge in cache');
        return false;
      };
  
      // Check if the configured light or group is in the cache
      if(!(settings.light in bridgeCache.lights || settings.light in bridgeCache.groups)) {
        log(`Light or group ${settings.light} not found in cache`, settings, bridgeCache);
        showAlert(inContext);
        return false;
      }
  
      return settings;
    };

    // Private function to set the defaults
    function setDefaults(inCallback) {
        // If at least one bridge is paired
        if (!(Object.keys(cache.data).length > 0)) {
            // If a callback function was given
            if (inCallback !== undefined) {
                // Execute the callback function
                inCallback();
            }
            return;
        }

        // Find out type of action
        let action;
        if (instance instanceof PowerAction) {
            action = 'com.elgato.philips-hue.power';
        }
        else if (instance instanceof ColorAction) {
            action = 'com.elgato.philips-hue.color';
        }
        else if (instance instanceof CycleAction) {
            action = 'com.elgato.philips-hue.cycle';
        }
        else if (instance instanceof BrightnessAction) {
            action = 'com.elgato.philips-hue.brightness';
        }
		else if (instance instanceof BrightnessRelAction) {
            action = 'com.elgato.philips-hue.brightness-rel';
        }
        else if (instance instanceof SceneAction) {
            action = 'com.elgato.philips-hue.scene';
        }

        // If no bridge is set for this action
        if (!('bridge' in settings)) {
            // Sort the bridges alphabetically
            let bridgeIDsSorted = Object.keys(cache.data).sort((a, b) => {
                return cache.data[a].name.localeCompare(cache.data[b].name);
            });

            // Set the bridge automatically to the first one
            settings.bridge = bridgeIDsSorted[0];

            // Save the settings
            saveSettings(action, inContext, settings);
        }

        // Find the configured bridge
        let bridgeCache = cache.data[settings.bridge];

        // If no light is set for this action
        if (!('light' in settings)) {
            // First try to set a group, because scenes only support groups
            // If the bridge has at least one group
            if (Object.keys(bridgeCache.groups).length > 0) {
                // Sort the groups automatically
                let groupIDsSorted = Object.keys(bridgeCache.groups).sort((a, b) => {
                    return bridgeCache.groups[a].name.localeCompare(bridgeCache.groups[b].name);
                });

                // Set the light automatically to the first group
                settings.light = groupIDsSorted[0];

                // Save the settings
                saveSettings(action, inContext, settings);
            }
            else if (Object.keys(bridgeCache.lights).length > 0) {
                // Sort the lights automatically
                let lightIDsSorted = Object.keys(bridgeCache.lights).sort((a, b) => {
                    return bridgeCache.lights[a].name.localeCompare(bridgeCache.lights[b].name);
                });

                // Set the light automatically to the first light
                settings.light = lightIDsSorted[0];

                // Save the settings
                saveSettings(action, inContext, settings);
            }
        }

        // If a callback function was given
        if (inCallback !== undefined) {
            // Execute the callback function
            inCallback();
        }
    }
}
