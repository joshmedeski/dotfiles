/**
@file      brightnessRelPI.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

function BrightnessRelPI(inContext, inLanguage, inStreamDeckVersion, inPluginVersion) {
    // Init BrightnessPI
    let instance = this;

    // Inherit from PI
    PI.call(this, inContext, inLanguage, inStreamDeckVersion, inPluginVersion);

    // Before overwriting parent method, save a copy of it
    let piLocalize = this.localize;

    // Localize the UI
    this.localize = function() {
        // Call PIs localize method
        piLocalize.call(instance);

        // Localize the brightness label
        document.getElementById('brightness-rel-label').innerHTML = instance.localization['Steps'];
    };

    // Add steps slider
    document.getElementById('placeholder').innerHTML = `
      <div type="range" class="sdpi-item">
        <div class="sdpi-item-label" id="brightness-rel-label"></div>
        <div class="sdpi-item-value">
          <input class="floating-tooltip" data-suffix="%" type="range" id="brightness-rel-input" min="-50" max="50" value="${settings.brightnessRel}">
        </div>
      </div>
    `;

    // Initialize the tooltips
    initToolTips();

    // Add event listener
    document.getElementById('brightness-rel-input').addEventListener('change', brightnessRelChanged);

    // Brightness changed
    function brightnessRelChanged(inEvent) {
        // Save the new brightness settings
        settings.brightnessRel = inEvent.target.value;
        instance.saveSettings();

        // Inform the plugin that a new brightness is set
        instance.sendToPlugin({ 'piEvent': 'valueChanged' });
    }
}
