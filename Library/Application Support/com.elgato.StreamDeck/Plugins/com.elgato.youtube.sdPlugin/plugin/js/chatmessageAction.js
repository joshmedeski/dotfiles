//==============================================================================
/**
@file       chatmessageAction.js
@brief      YouTube Plugin
@copyright  (c) 2021, Corsair Memory, Inc.
            This source code is licensed under the MIT-style license found in the LICENSE file.
**/
//==============================================================================

// Prototype which represents a chat message action
function ChatMessageAction(inContext, inSettings) {
	// Init ChatMessageAction
	var instance = this;

	// Inherit from Action
	Action.call(this, inContext, inSettings);

	// Before overwriting parrent method, save a copy of it
	var actionOnKeyUp = this.onKeyUp;

	// Public function called on key up event
	this.onKeyUp = function(inData, inCallback) {
		// Call actions onKeyUp method
		actionOnKeyUp.call(this, inData, send);
		inCallback();
	};
	
	// Private function called for sending a message
	function send(account, target, callback) {
		var url = "https://www.googleapis.com/youtube/v3/liveChat/messages"
				+ "?part=snippet";
		var xhr = new XMLHttpRequest();
		xhr.responseType = 'json';
		xhr.open("POST", url, true);
		xhr.setRequestHeader('Accept', 'application/json');
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.setRequestHeader('Authorization', 'Bearer ' + account.token);
		xhr.timeout = 2500;
		xhr.onload = function () {
			if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
				var result = xhr.response;
				if (result != undefined && result != null) {
					callback(true, result);
				}
				else {
					callback(false, "Account response is undefined or null.");
				}
			}
			else {
				callback(false, 'Could not send the message. Please make sure that Live Chat is enabled.');
			}
		};
		xhr.onerror = function () {
			callback(false, 'Unable to connect to the account.');
		};
		xhr.ontimeout = function () {
			callback(false, 'Connection to the account timed out.');
		};
		var obj = {};
		obj.snippet = {};
		obj.snippet.live_chat_id = target.broadcast.liveChatId;
		obj.snippet.type = 'textMessageEvent';
		obj.snippet.text_message_details = {};
		obj.snippet.text_message_details.message_text = target.message;
		var data = JSON.stringify(obj);
		xhr.send(data);
	}
};
