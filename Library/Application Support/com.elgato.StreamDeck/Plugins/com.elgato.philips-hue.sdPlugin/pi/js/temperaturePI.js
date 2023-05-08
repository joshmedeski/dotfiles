/**
@file      temperaturePI.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

function TemperaturePI(inContext, inLanguage, inStreamDeckVersion, inPluginVersion, isEncoder) {
    // Init TemperaturePI
    let instance = this;

    // Inherit from PI
    PI.call(this, inContext, inLanguage, inStreamDeckVersion, inPluginVersion);

    // Before overwriting parent method, save a copy of it
    let piLocalize = this.localize;

    // Localize the UI
    this.localize = () => {
        // Call PIs localize method
        piLocalize.call(instance);

        // Localize the brightness label
        document.getElementById('temperature-label').innerHTML = instance.localization['Temperature'];
        if(isEncoder) {
          document.getElementById('scaleticks-label').innerHTML = instance.localization['Scale Ticks'] || 'Scale Ticks';
        }
    };

    // Add brightness slider
    document.getElementById('placeholder').innerHTML = `
      <div type="range" class="sdpi-item">
        <div class="sdpi-item-label" id="temperature-label"></div>
        <div class="sdpi-item-value">
            <input class="floating-tooltip" data-suffix="%" type="range" id="temperature-input" min="1" max="100" value="${settings.temperature}">
        </div>
      </div>
      ${this.getEncoderOptions(settings.scaleTicks, isEncoder)}
    `;

    // Initialize the tooltips
    initToolTips();

    // Add event listener
    document.getElementById('temperature-input').addEventListener('change', temperatureChanged);
    if(isEncoder) {
      document.getElementById('scaleticks-input').addEventListener('change', scaleticksChanged);
    }

    // Brightness changed
    function temperatureChanged(inEvent) {
        // Save the new brightness settings
        settings.temperature = inEvent.target.value;
        instance.saveSettings();

        // Inform the plugin that a new brightness is set
        instance.sendToPlugin({
            piEvent: 'valueChanged',
        });
    }

    function scaleticksChanged(inEvent) {
      settings.scaleTicks = inEvent.target.value;
      instance.saveSettings();
    }
}
