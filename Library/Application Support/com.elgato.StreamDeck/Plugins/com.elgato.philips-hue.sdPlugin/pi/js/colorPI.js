/**
@file      colorPI.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

function ColorPI(inContext, inLanguage, inStreamDeckVersion, inPluginVersion) {
    // Init ColorPI
    let instance = this;

    // Inherit from PI
    PI.call(this, inContext, inLanguage, inStreamDeckVersion, inPluginVersion);

    // Add event listener
    document.getElementById('light-select').addEventListener('change', lightChanged);

    // Color changed
    function colorChanged(inEvent) {
        // Get the selected color
        let color = inEvent.target.value;

        // If the color is hex
        if (color.charAt(0) === '#') {
            // Convert the color to HSV
            let hsv = Bridge.hex2hsv(color);

            // Check if the color is valid
            if (hsv.v !== 1) {
                // Remove brightness component
                hsv.v = 1;

                // Set the color to the corrected color
                color = Bridge.hsv2hex(hsv);
            }
        }

        // Save the new color
        settings.color = color;
        instance.saveSettings();

        // Inform the plugin that a new color is set
        instance.sendToPlugin({
            piEvent: 'valueChanged',
        });
    }

    // Light changed
    function lightChanged() {
        // Get the light value manually
        // Because it is not set if this function was triggered via a CustomEvent
        let lightID = document.getElementById('light-select').value;

        // Don't show any color picker if no light or group is set
        if (lightID === 'no-lights' || lightID === 'no-groups') {
            return;
        }

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

        // Check if the selected light or group is in the cache
        if (!(lightID in bridgeCache.lights || lightID in bridgeCache.groups)) {
            return;
        }

        // Get light or group cache
        let lightCache;

        if (lightID.indexOf('l') !== -1) {
            lightCache = bridgeCache.lights[lightID];
        }
        else {
            lightCache = bridgeCache.groups[lightID];
        }

        // Add full color picker or only temperature slider
        let colorPicker;

        if (lightCache.xy !== null) {
            colorPicker = `
              <div type="color" class="sdpi-item">
                <div class="sdpi-item-label" id="color-label">${instance.localization['Color']}</div>
                <input type="color" class="sdpi-item-value" id="color-input" value="${settings.color}">
              </div>
            `;
        }
        else {
            colorPicker = `
              <div type="range" class="sdpi-item">
                <div class="sdpi-item-label" id="temperature-label">${instance.localization['Temperature']}</div>
                <div class="sdpi-item-value">
                  <input class="temperature floating-tooltip" data-suffix="K" type="range" id="color-input" min="2000" max="6500" value="${settings.color}">
                </div>
              </div>
            `;
        }

        // Add color picker
        document.getElementById('placeholder').innerHTML = colorPicker;

        // Initialize the tooltips
        initToolTips();

        // Add event listener
        document.getElementById('color-input').addEventListener('change', colorChanged);
    }
}
