/**
@file      sceneAction.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype which represents a scene action
function SceneAction(inContext, inSettings) {
    // Init SceneAction
    let instance = this;

    // Inherit from Action
    Action.call(this, inContext, inSettings);

    // Set the default values
    setDefaults();

    // Public function called on key up event
    this.onKeyUp = (inContext, inSettings, inCoordinates, inUserDesiredState, inState) => {
       
        const settings = this.getVerifiedSettings(inContext, 'scene');
        if(false === settings) return;
        let bridgeCache = cache.data[settings.bridge];

        // Find the configured group
        let groupCache = bridgeCache.groups[inSettings.light];

        // Check if any scene is configured
        if (!('scene' in inSettings)) {
            log('No scene configured');
            showAlert(inContext);
            return;
        }

        // Check if the configured scene is in the group cache
        if (!(settings.scene in groupCache.scenes)) {
            log(`Scene ${settings.scene} not found in cache`);
            showAlert(inContext);
            return;
        }

        // Find the configured scene
        let sceneCache = groupCache.scenes[inSettings.scene];

        // Create a bridge instance
        let bridge = new Bridge(bridgeCache.ip, bridgeCache.id, bridgeCache.username);

        // Create a scene instance
        let scene = new Scene(bridge, sceneCache.id);

        // Set scene
        scene.on((inSuccess, inError) => {
            // Check if setting the scene was successful
            if (!(inSuccess)) {
                log(inError);
                showAlert(inContext);
            }
        });
    };

    // Before overwriting parent method, save a copy of it
    let actionNewCacheAvailable = this.newCacheAvailable;

    // Public function called when new cache is available
    this.newCacheAvailable = (inCallback) => {
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

        // Check if the light was set to a group
        if (!(settings.light.indexOf('g-') !== -1)) {
            return;
        }

        // Check if the configured group is in the cache
        if (!(settings.light in bridgeCache.groups)) {
            return;
        }

        // Find the configured group
        let groupCache = bridgeCache.groups[settings.light];

        // Check if a scene was configured for this action
        if ('scene' in settings) {
            // Check if the scene is part of the set group
            if (settings.scene in groupCache.scenes) {
                return;
            }
        }

        // Check if the group has at least one scene
        if (!(Object.keys(groupCache.scenes).length > 0)) {
            return;
        }

        // Sort the scenes alphabetically
        let sceneIDsSorted = Object.keys(groupCache.scenes).sort((a, b) => {
            return groupCache.scenes[a].name.localeCompare(groupCache.scenes[b].name);
        });

        // Set the action automatically to the first one
        settings.scene = sceneIDsSorted[0];

        // Save the settings
        saveSettings('com.elgato.philips-hue.scene', context, settings);
    }
}
