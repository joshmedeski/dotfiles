//==============================================================================
/**
@file       chatmessagePI.js
@brief      YouTube Plugin
@copyright  (c) 2021, Corsair Memory, Inc.
            This source code is licensed under the MIT-style license found in the LICENSE file.
**/
//==============================================================================

function ChatMessagePI(inContext, inLanguage) {
    // Inherit from PI
    PI.call(this, inContext, inLanguage);

    // Save a copy of a method
    var piSaveSettings = this.saveSettings;

    // Add message text area
    var messageArea = "<div type='textarea' class='sdpi-item' id='message_only'> \
            <div class='sdpi-item-label' id='message-label'></div> \
            <span class='sdpi-item-value textarea'> \
                <textarea type='textarea' maxlength='200' id='txa'></textarea> \
                <label id='length-label'>0/200</label> \
            </span> \
        </div>";
    document.getElementById('placeholder').innerHTML = messageArea;

    var txa = document.getElementById('txa');
    var label = document.getElementById('length-label');
    const max = txa.getAttribute('maxlength');
    updateMessage(settings.msg);

    // Add event listener
    txa.addEventListener("input", messageChanged);

    // Before overwriting parrent method, save a copy of it
    var piLocalize = this.localize;

    // Localize the UI
    this.localize = function (tr) {
        // Call PIs localize method
        piLocalize.call(this, tr);

        document.getElementById('message-label').innerHTML = tr("Message");
        document.getElementById('txa').placeholder = tr("MessagePlaceholder");
    };

    // Message text area changed
    function messageChanged(event) {
        var value = (event ? event.target.value : undefined);
        // Update data
        updateMessage(value);
        // Update settings
        settings.msg = value;
        piSaveSettings();
    }

    // Private function called to update message data
    function updateMessage(value) {
        value = value || "";
        // Update text area content
        txa.value = value;
        // Update character counter
        label.innerText = max ? `${value.length}/${max}` : `${value.length}`;
    }
}
