/**
@file      pi.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

function PI(inContext, inLanguage, inStreamDeckVersion, inPluginVersion) {
    // Init PI
    let instance = this;

    const values = [1,2,3,4,5,10];
    this.getEncoderOptions = (settingsValue, forEncoder) => {
      const selectedIndex = values.indexOf(Number(settingsValue));
      return forEncoder === true ? `<div type="select" class="sdpi-item">
    <div class="sdpi-item-label" id="scaleticks-label"></div>
    <select id="scaleticks-input" class="sdpi-item-value select" selectedIndex="${selectedIndex}">
      ${values.map((value, index) => `<option value="${value}" ${index === selectedIndex ? 'selected' : ''}>${value}x</option>`).join('')}
  </select>
    </select>
  </div>`: ''
    };

    // Public localizations for the UI
    this.localization = {};

    // Add event listener
    document.getElementById('bridge-select').addEventListener('change', bridgeChanged);
    document.getElementById('light-select').addEventListener('change', lightsChanged);
    document.addEventListener('saveBridge', setupCallback);

    // Load the localizations
    getLocalization(inLanguage, (inStatus, inLocalization) => {
        if (inStatus) {
            // Save public localization
            instance.localization = inLocalization['PI'];

            // Localize the PI
            instance.localize();
        }
        else {
            log(inLocalization);
        }
    });

    // Localize the UI
    this.localize = () => {
        // Check if localizations were loaded
        if (instance.localization == null) {
            return;
        }

        // Localize the bridge select
        document.getElementById('bridge-label').innerHTML = instance.localization['Bridge'];
        document.getElementById('no-bridges').innerHTML = instance.localization['NoBridges'];
        document.getElementById('add-bridge').innerHTML = instance.localization['AddBridge'];

        // Localize the light and group select
        document.getElementById('lights-label').innerHTML = instance.localization['Lights'];
        document.getElementById('lights').label = instance.localization['LightsTitle'];
        document.getElementById('no-lights').innerHTML = instance.localization['NoLights'];
        document.getElementById('no-groups').innerHTML = instance.localization['NoGroups'];

        // Groups label is removed for scenes PI
        if (document.getElementById('groups') != null) {
            document.getElementById('groups').label = instance.localization['GroupsTitle'];
        }
    };

    // Show all paired bridges
    this.loadBridges = () => {
        // Remove previously shown bridges
        let bridges = document.getElementsByClassName('bridges');
        while (bridges.length > 0) {
            bridges[0].parentNode.removeChild(bridges[0]);
        }

        // Check if any bridge is paired
        if (Object.keys(cache).length > 0) {
            // Hide the 'No Bridges' option
            document.getElementById('no-bridges').style.display = 'none';

            // Sort the bridges alphabetically
            let bridgeIDsSorted = Object.keys(cache).sort((a, b) => {
                return cache[a].name.localeCompare(cache[b].name);
            });

            // Add the bridges
            bridgeIDsSorted.forEach(inBridgeID => {
                // Add the group
                let option = `
                  <option value='${inBridgeID}' class='bridges'>${cache[inBridgeID].name}</option>
                `;
                document.getElementById('no-bridges').insertAdjacentHTML('beforebegin', option);
            });

            // Check if the bridge is already configured
            if (settings.bridge !== undefined) {
                // Select the currently configured bridge
                document.getElementById('bridge-select').value = settings.bridge;
            }

            // Load the lights
            loadLights();
        }
        else {
            // Show the 'No Bridges' option
            document.getElementById('no-bridges').style.display = 'block';
        }

        // Show PI
        document.getElementById('pi').style.display = 'block';
    }

    // Show all lights
    function loadLights() {
        // Check if any bridge is configured
        if (!('bridge' in settings)) {
            return;
        }

        // Check if the configured bridge is in the cache
        if (!(settings.bridge in cache)) {
            return;
        }

        // Find the configured bridge
        let bridgeCache = cache[settings.bridge];

        // Remove previously shown lights
        let lights = document.getElementsByClassName('lights');
        while (lights.length > 0) {
            lights[0].parentNode.removeChild(lights[0]);
        }

        // Check if the bridge has at least one light
        if (Object.keys(bridgeCache.lights).length > 0) {
            // Hide the 'No Light' option
            document.getElementById('no-lights').style.display = 'none';

            // Sort the lights alphabetically
            let lightIDsSorted = Object.keys(bridgeCache.lights).sort((a, b) => {
                return bridgeCache.lights[a].name.localeCompare(bridgeCache.lights[b].name);
            });

            // Add the lights
            lightIDsSorted.forEach(inLightID => {
                let light = bridgeCache.lights[inLightID];

                // Check if this is a color action and the lights supports colors
                if (!(instance instanceof ColorPI && light.temperature == null && light.xy == null)) {
                    // Add the light
                    let option = `
                      <option value='l-${light.id}' class='lights'>${light.name}</option>
                    `;
                    document.getElementById('no-lights').insertAdjacentHTML('beforebegin', option);
                }
            });
        }
        else {
            // Show the 'No Light' option
            document.getElementById('no-lights').style.display = 'block';
        }

        // Remove previously shown groups
        let groups = document.getElementsByClassName('groups');
        while (groups.length > 0) {
            groups[0].parentNode.removeChild(groups[0]);
        }

        // Check if the bridge has at least one group
        if (Object.keys(bridgeCache.groups).length > 0) {
            // Hide the 'No Group' option
            document.getElementById('no-groups').style.display = 'none';

            // Sort the groups alphabetically
            let groupIDsSorted = Object.keys(bridgeCache.groups).sort((a, b) => {
                return bridgeCache.groups[a].name.localeCompare(bridgeCache.groups[b].name);
            });

            // Add the groups
            groupIDsSorted.forEach(inGroupID => {
                let group = bridgeCache.groups[inGroupID];

                // Check if this is a color action and the lights supports colors
                if (!(instance instanceof ColorPI && group.temperature == null && group.xy == null)) {
                    // Add the group
                    let option = `
                      <option value='g-${group.id}' class='groups'>${group.name}</option>
                    `;
                    document.getElementById('no-groups').insertAdjacentHTML('beforebegin', option);
                }
            });
        }
        else {
            // Show the 'No Group' option
            document.getElementById('no-groups').style.display = 'block';
        }

        // Check if a light is already setup
        if (settings.light !== undefined) {
            // Check if the configured light or group is part of the bridge cache
            if (!(settings.light in bridgeCache.lights || settings.light in bridgeCache.groups)) {
                return;
            }

            // Select the currently configured light or group
            document.getElementById('light-select').value = settings.light;

            // Dispatch light change event manually
            // So that the colorPI can set the correct color picker at initialization
            document.getElementById('light-select').dispatchEvent(new CustomEvent('change', {'detail': {'manual': true}} ));
        }

        // If this is a scene PI
        if (instance instanceof ScenePI) {
            //Load the scenes
            instance.loadScenes();
        }
    }

    // Function called on successful bridge pairing
    function setupCallback(inEvent) {
        // Set bridge to the newly added bridge
        settings.bridge = inEvent.detail.id;
        instance.saveSettings();

        // Check if global settings need to be initialized
        if (globalSettings.bridges === undefined) {
            globalSettings.bridges = {};
        }

        // Add new bridge to the global settings
        globalSettings.bridges[inEvent.detail.id] = {
            ip: inEvent.detail.ip,
            id: inEvent.detail.id,
            username: inEvent.detail.username,
        };
        saveGlobalSettings(inContext);
    }

    // Bridge select changed
    function bridgeChanged(inEvent) {
        if (inEvent.target.value === 'add') {
            // Open setup window
            window.open(`../setup/index.html?language=${inLanguage}&streamDeckVersion=${inStreamDeckVersion}&pluginVersion=${inPluginVersion}`);

            // Select the first in case user cancels the setup
            document.getElementById('bridge-select').selectedIndex = 0;
        }
        else if (inEvent.target.value === 'no-bridges') {
            // If no bridge was selected, do nothing
        }
        else {
            settings.bridge = inEvent.target.value;
            instance.saveSettings();
            instance.loadBridges();
        }
    }

    // Light select changed
    function lightsChanged(inEvent) {
        if (inEvent.target.value === 'no-lights' || inEvent.target.value === 'no-groups') {
            // If no light or group was selected, do nothing
        }
        else if (inEvent.detail !== undefined) {
            // If the light was changed via code
            if (inEvent.detail.manual === true) {
                // do nothing
            }
        }
        else {
            settings.light = inEvent.target.value;
            instance.saveSettings();

            // If this is a scene PI
            if (instance instanceof ScenePI) {
                //Load the scenes
                instance.loadScenes();
            }
        }
    }

    // Private function to return the action identifier
    function getAction() {
        let action

        // Find out type of action
        if (instance instanceof PowerPI) {
            action = 'com.elgato.philips-hue.power';
        }
        else if (instance instanceof ColorPI) {
            action = 'com.elgato.philips-hue.color';
        }
        else if (instance instanceof CyclePI) {
            action = 'com.elgato.philips-hue.cycle';
        }
        else if (instance instanceof BrightnessPI) {
            action = 'com.elgato.philips-hue.brightness';
        }
        else if (instance instanceof TemperaturePI) {
          action = 'com.elgato.philips-hue.temperature';
      }
        else if (instance instanceof BrightnessRelPI) {
            action = 'com.elgato.philips-hue.brightness-rel';
        }
        else if (instance instanceof ScenePI) {
            action = 'com.elgato.philips-hue.scene';
        }

        return action;
    }

    // Public function to save the settings
    this.saveSettings = () => {
        saveSettings(getAction(), inContext, settings);
    }

    // Public function to send data to the plugin
    this.sendToPlugin = inData => {
        sendToPlugin(getAction(), inContext, inData);
    }
}
