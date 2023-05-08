/**
@file      powerAction.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype which represents a power action
function PowerAction(inContext, inSettings) {
    // Init PowerAction
    let instance = this;

    // Inherit from Action
    Action.call(this, inContext, inSettings);

    // Update the state
    updateState();

    this.updateAction = function() {
      updateState();
    };

    // Public function called on key up event
    this.onKeyUp = (inContext, inSettings, inCoordinates, inUserDesiredState, inState) => {
        const settings = this.getVerifiedSettings(inContext);
        if(false === settings) return;
  
        let bridgeCache = cache.data[settings.bridge];
        // Create a bridge instance
        let bridge = new Bridge(bridgeCache.ip, bridgeCache.id, bridgeCache.username);

        // Create a light or group object
        let objCache, obj;
        if (settings.light.indexOf('l-') !== -1) {
            objCache = bridgeCache.lights[settings.light];
            obj = new Light(bridge, objCache.id);
        }
        else {
            objCache = bridgeCache.groups[settings.light];
            obj = new Group(bridge, objCache.id);
        }

        // Check for multi action
        let targetState;
        if (inUserDesiredState !== undefined) {
            targetState = !inUserDesiredState;
        }
        else {
            targetState = !objCache.power;
        }

        // Set light or group state
        obj.setPower(targetState, (success, error) => {
            if (success) {
                setActionState(inContext, targetState ? 0 : 1);
                objCache.power = targetState;
                cache.refresh();
            }
            else {
                log(error);
                setActionState(inContext, inState);
                showAlert(inContext);
            }
        });
    };

    // Before overwriting parent method, save a copy of it
    let actionNewCacheAvailable = this.newCacheAvailable;

    // Public function called when new cache is available
    this.newCacheAvailable = inCallback => {
        // Call actions newCacheAvailable method
        actionNewCacheAvailable.call(instance, () => {
            // Update the state
            updateState();

            // Call the callback function
            inCallback();
        });
    };

    function updateState() {
        // Get the settings and the context
        let settings = instance.getSettings();
        let context = instance.getContext();

        // Check if any bridge is configured
        if (!('bridge' in settings)) {
            return;
        }

        // Check if the configured bridge is in the cache
        if (!(settings.bridge in cache.data)) {
            return;
        }

        // Find the configured bridge
        let bridgeCache = cache.data[settings.bridge];

        // Check if a light was set for this action
        if (!('light' in settings)) {
            return;
        }

        // Check if the configured light or group is in the cache
        if (!(settings.light in bridgeCache.lights || settings.light in bridgeCache.groups)) {
            return;
        }

        // Find out if it is a light or a group
        let objCache;
        if (settings.light.indexOf('l-') !== -1) {
            objCache = bridgeCache.lights[settings.light];
        }
        else {
            objCache = bridgeCache.groups[settings.light];
        }

        // Set the target state
        let targetState = objCache.power;

        // Set the new action state
        setActionState(context, targetState ? 0 : 1);
    }

    // Private function to set the state
    function setActionState(inContext, inState) {
        setState(inContext, inState);
    }
}
