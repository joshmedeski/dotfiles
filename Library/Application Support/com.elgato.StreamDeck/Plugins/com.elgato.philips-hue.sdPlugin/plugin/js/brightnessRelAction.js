/**
@file      brightnessRelAction.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype which represents a brightness action
function BrightnessRelAction(inContext, inSettings) {
    // Init BrightnessRelAction
    let instance = this;

    // Inherit from Action
    Action.call(this, inContext, inSettings);

    // Set the default values
    setDefaults();

    // Public function called on key up event
    this.onKeyUp = (inContext, inSettings, inCoordinates, inUserDesiredState, inState) => {
        // If onKeyUp was triggered manually, load settings
        if (inSettings === undefined) {
            inSettings = instance.getSettings();
        }

        // Set icon according to relative value
        setState(inContext, inSettings.brightnessRel >= 0 ? 0 : 1);

        // Check if any bridge is configured
        if (!('bridge' in inSettings)) {
            log('No bridge configured');
            showAlert(inContext);
            return;
        }

        // Check if the configured bridge is in the cache
        if (!(inSettings.bridge in cache.data)) {
            log(`Bridge ${inSettings.bridge} not found in cache`);
            showAlert(inContext);
            return;
        }

        // Find the configured bridge
        let bridgeCache = cache.data[inSettings.bridge];

        // Check if any light is configured
        if (!('light' in inSettings)) {
            log('No light or group configured');
            showAlert(inContext);
            return;
        }

        // Check if the configured light or group is in the cache
        if (!(inSettings.light in bridgeCache.lights || inSettings.light in bridgeCache.groups)) {
            log(`Light or group ${inSettings.light} not found in cache`);
            showAlert(inContext);
            return;
        }

        // Check if any brightness is configured
        if (!('brightnessRel' in inSettings)) {
            log('No relative brightness configured');
            showAlert(inContext);
            return;
        }

        // Create a bridge instance
        let bridge = new Bridge(bridgeCache.ip, bridgeCache.id, bridgeCache.username);

        // Create a light or group object
        let objCache, obj;
        if (inSettings.light.indexOf('l') !== -1) {
            objCache = bridgeCache.lights[inSettings.light];
            obj = new Light(bridge, objCache.id);
        }
        else {
            objCache = bridgeCache.groups[inSettings.light];
            obj = new Group(bridge, objCache.id);
        }

        // Convert brightness
        let brightness;
        if (objCache.power) {
            let brightnessRel = (objCache.brightness / 2.54) + parseInt(inSettings.brightnessRel);
            brightness = Math.round(brightnessRel * 2.54);
        }
        else {
            brightness = parseInt(inSettings.brightnessRel);
        }

        if (brightness > 254) {
            brightness = 254;
        }
        else if (brightness < 0) {
            brightness = 0;
        }

        // Turn lights off if brightness is 0
        if (brightness <= 0) {
            obj.setPower(false, (inSuccess, inError) => {
                if (inSuccess) {
                    objCache.power = false;
                }
                else {
                    log(inError);
                    showAlert(inContext);
                }
            });
        }
        else {
            // Set light or group state
            obj.setBrightness(brightness, (inSuccess, inError) => {
                if (inSuccess) {
                    objCache.brightness = brightness;
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

        // If brightness is already set for this action
        if ('brightnessRel' in settings) {
            return;
        }

        // Set the relative brightness to 0
        settings.brightnessRel = 0;

        // Save the settings
        saveSettings('com.elgato.philips-hue.brightness-rel', context, settings);
    }
}
