/**
@file      cyclePI.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

function CyclePI(inContext, inLanguage, inStreamDeckVersion, inPluginVersion) {
    // Init CyclePI
    let instance = this;

    // Maximum amount of Colors
    let maxColors = 10;

    // Current amount of Colors
    let curColors = settings?.colors?.length || 0;

    // Default color for new pickers
    let defaultColor = "#ffffff";

    // Default temperature for new pickers
    let defaultTemperature = 2000;

    // Inherit from PI
    PI.call(this, inContext, inLanguage, inStreamDeckVersion, inPluginVersion);

    // Add event listener
    document.getElementById('light-select').addEventListener('change', lightChanged);

    // Color changed
    function colorChanged(inEvent) {
        // Get the selected index and color
        let index = inEvent.target.dataset.id;
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
        settings.colors[index] = color;
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

        // Get html of color picker or temperature slider
        let getColorPicker = i => {
            let colorIndex = i - 1;

            if (lightCache.xy != null) {
                if (i === 0) {
                    return `
                      <div type="color" class="sdpi-item" id="color-input-container">
                        <div class="sdpi-item-label" class="color-label">${instance.localization['Colors']}</div>
                        <div class="sdpi-item-value"></div>
                      </div>
                    `;
                }
                else {
                    return `
                      <span id="color-input-container-${colorIndex}"><input type="color" class="sdpi-item-value" id="color-input-${colorIndex}" name="color-input" data-id="${colorIndex}" value="${(settings.colors[colorIndex] || defaultColor)}"></span>
                    `;
                }
            }
            else if (i > 0) {
                return `
                  <div type="range" class="sdpi-item" id="color-input-container-${colorIndex}">
                    <div class="sdpi-item-label" id="temperature-label">${instance.localization['Temperature']} ${i}</div>
                    <div class="sdpi-item-value">
                      <input class="temperature floating-tooltip" data-suffix="K" type="range" id="color-input-${colorIndex}" name="color-input" data-id="${colorIndex}" min="2000" max="6500" value="${(settings.colors[colorIndex] || defaultTemperature)}">
                    </div>
                  </div>
                `;
            }

            return '';
        };

        let placeholder = document.getElementById('placeholder');

        // Add a new color picker to document
        let addColorPicker = i => {
            let picker = document.createElement('div');
            picker.innerHTML = getColorPicker(i);

            if (lightCache.xy != null) {
                document.querySelector('#color-input-container .sdpi-item-value').append(picker.firstChild);
            }
            else {
                placeholder.insertBefore(picker.firstChild, document.getElementById('cycle-buttons'));
            }

            document.getElementById('color-input-' + (i - 1)).addEventListener('change', colorChanged);
        };

        // Add first color pickers container and buttons
        placeholder.innerHTML = getColorPicker(0) + `
          <div id="cycle-buttons" class="sdpi-item">
            <div class="sdpi-item-label empty"></div>
            <div class="sdpi-item-value">
              <button id="add-color">+</button>
              <button id="remove-color">-</button>
            </div>
          </div>
        `;

        // Initial create color pickers from settings
        for (let n = 1; n <= settings.colors.length; n++) {
            addColorPicker(n);
        }

        // Get buttons for later usage
        let addButton = document.getElementById('add-color');
        let removeButton = document.getElementById('remove-color');
        let checkButtonStates = () => {
            // Hide add button when reached max color pickers
            addButton.style.display = curColors >= maxColors ? 'none' : 'inline-block';

            // Hide remove button when only two color pickers left
            removeButton.style.display = curColors <= 2 ? 'none' : 'inline-block';
        };

        // Event listener for add color
        addButton.addEventListener('click', () => {
            addColorPicker((++curColors));

            // Add new picker value to settings
            let colorIndex = curColors - 1;

            if (!settings.colors[colorIndex]) {
                if (lightCache.xy != null) {
                    settings.colors[colorIndex] = defaultColor;
                }
                else {
                    settings.colors[colorIndex] = defaultTemperature;
                }

                instance.saveSettings();
            }

            checkButtonStates();
        });

        // Event listener for remove last color
        removeButton.addEventListener('click', () => {
            document.getElementById('color-input-container-' + (--curColors)).remove();

            // Remove color from settings
            settings.colors = settings.colors.splice(0, settings.colors.length - 1);
            instance.saveSettings();

            checkButtonStates();
        });

        // Initial button states
        checkButtonStates();

        // Initialize the tooltips
        initToolTips();
    }
}
