//==============================================================================
/**
@file       main.js
@brief      YouTube Plugin
@copyright  (c) 2021, Corsair Memory, Inc.
            This source code is licensed under the MIT-style license found in the LICENSE file.
**/
//==============================================================================

// Global web socket
var websocket = null;

// Global plugin settings
var globalSettings = {};

// Global settings
var settings = {};

// Global cache
var cache = {};
  
// Setup the websocket and handle communication
function connectElgatoStreamDeckSocket(inPort, inUUID, inRegisterEvent, inInfo, inActionInfo) {
    // Parse parameter from string to object
    var actionInfo = JSON.parse(inActionInfo);
    var info = JSON.parse(inInfo);

    // Save global settings
    settings = actionInfo['payload']['settings'];

    // Retrieve language
    var language = info['application']['language'];

    // Retrieve action identifier
    var action = actionInfo['action'];

    // Open the web socket to Stream Deck
    // Use 127.0.0.1 because Windows needs 300ms to resolve localhost
	websocket = new WebSocket("ws://127.0.0.1:" + inPort);

    // WebSocket is connected, send message
	websocket.onopen = function () {
		// Register property inspector to Stream Deck
		registerPluginOrPI(inRegisterEvent, inUUID);

        // Request the global settings of the plugin
        requestGlobalSettings(inUUID);
	};

    // Create actions
    if (action == "com.elgato.youtube.chatmessage") {
        var pi = new ChatMessagePI(inUUID, language);
    }
    else if (action == "com.elgato.youtube.viewers") {
        var pi = new ViewersPI(inUUID, language);
    }
     
    websocket.onmessage = function (evt) {
        // Received message from Stream Deck
        var jsonObj = JSON.parse(evt.data);
        var event = jsonObj['event'];
        var jsonPayload = jsonObj['payload'];

        if(event == "didReceiveGlobalSettings") {
            // Set global plugin settings
            globalSettings = jsonPayload['settings'];
        }
        else if(event == "didReceiveSettings") {
            // Save global settings after default was set
            settings = jsonPayload['settings'];
        }
        else if(event == "sendToPropertyInspector") {
            // Save global cache
            cache = jsonPayload;

            // Load accounts
            pi.loadAccounts();
        }
    };
}
