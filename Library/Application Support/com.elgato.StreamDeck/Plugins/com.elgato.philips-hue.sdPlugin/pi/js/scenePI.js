/**
@file      scenePI.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

function ScenePI(inContext, inLanguage, inStreamDeckVersion, inPluginVersion) {
    // Init ScenePI
    let instance = this;

    // Inherit from PI
    PI.call(this, inContext, inLanguage, inStreamDeckVersion, inPluginVersion);

    // Hide lights from light select
    document.getElementById('lights').style.display = 'none';

    // Remove groups label from lights select
    let groups = document.getElementById('groups');
    let groupsChildren = document.getElementById('groups').children;
    let lightSelect = document.getElementById('light-select');

    lightSelect.removeChild(groups);
    lightSelect.appendChild(groupsChildren[0]);

    // Before overwriting parent method, save a copy of it
    let piLocalize = this.localize;

    // Localize the UI
    this.localize = () => {
        // Call PIs localize method
        piLocalize.call(instance);

        // Localize the scene select
        document.getElementById('lights-label').innerHTML = instance.localization['Group'];
        document.getElementById('scene-label').innerHTML = instance.localization['Scene'];
        document.getElementById('no-scenes').innerHTML = instance.localization['NoScenes'];
    };

    // Add scene select
    document.getElementById('placeholder').innerHTML = `
        <div class='sdpi-item'>
          <div class='sdpi-item-label' id='scene-label'></div>
          <select class='sdpi-item-value select' id='scene-select'>
            <option id='no-scenes' value='no-scene'></option>
          </select>
        </div>
    `;

    // Add event listener
    document.getElementById('scene-select').addEventListener('change', sceneChanged);

    // Scenes changed
    function sceneChanged(inEvent) {
        if (inEvent.target.value === 'no-scenes') {
            // do nothing
        }
        else {
            // Save the new scene settings
            settings.scene = inEvent.target.value;
            instance.saveSettings();

            // Inform the plugin that a new scene is set
            instance.sendToPlugin({
                piEvent: 'valueChanged',
            });
        }
    }

    // Show all scenes
    this.loadScenes = () => {
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

        // Check if any light is configured
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

        // Remove previously shown scenes
        let scenes = document.getElementsByClassName('scenes');
        while (scenes.length > 0) {
            scenes[0].parentNode.removeChild(scenes[0]);
        }

        // Check if the group has at least one scene
        if (Object.keys(groupCache.scenes).length > 0) {
            // Hide the 'No Scenes' option
            document.getElementById('no-scenes').style.display = 'none';

            // Sort the scenes alphabetically
            let sceneIDsSorted = Object.keys(groupCache.scenes).sort((a, b) => {
                return groupCache.scenes[a].name.localeCompare(groupCache.scenes[b].name);
            });

            // Add the scenes
            sceneIDsSorted.forEach((inSceneID) => {
                // Add the scene
                let scene = groupCache.scenes[inSceneID];
                let option = `<option value="${scene.id}" class="scenes">${scene.name}</option>`;
                document.getElementById('no-scenes').insertAdjacentHTML('beforebegin', option);
            });
        }
        else {
            // Show the 'No Scenes' option
            document.getElementById('no-scenes').style.display = 'block';
        }

        // Check if scene is already setup
        if (settings.scene !== undefined) {
            // Check if the configured scene is in this group
            if (!(settings.scene in groupCache.scenes)) {
                return;
            }

            // Select the currently configured scene
            document.getElementById('scene-select').value = settings.scene;
        }
    }
}
