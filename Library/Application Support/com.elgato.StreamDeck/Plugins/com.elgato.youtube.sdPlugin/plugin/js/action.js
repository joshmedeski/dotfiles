//==============================================================================
/**
@file       action.js
@brief      YouTube Plugin
@copyright  (c) 2021, Corsair Memory, Inc.
            This source code is licensed under the MIT-style license found in the LICENSE file.
**/
//==============================================================================

// Protype which represents an action
function Action(inContext, inSettings) {
	// Init Action
	var instance = this;

	// Private variable containing the context of the action
	var context = inContext;

	// Private variable containing the settings of the action
	var settings = inSettings;

	// Set the default values
	setDefaults();

	// Public function returning the context
	this.getContext = function () {
		return context;
	};

	// Public function returning the settings
	this.getSettings = function () {
		return settings;
	};

	// Public function for settings the settings
	this.setSettings = function (inSettings) {
		settings = inSettings;
	};

	// Public function called when new cache is available
	this.newCacheAvailable = function (inCallback) {
		// Set default settings
		setDefaults(inCallback);
	};

	// Public function called on key up event
	this.onKeyUp = function(inData, inCallback) {
		// Check if any account is configured
		if (!('accountId' in inData.settings)) {
			log('No account configured');
			showAlert(inData.context);
			return;
		}
	
		// Check if the configured account is in the cache
		if (!(inData.settings.accountId in cache.data)) {
			log('Account ' + inData.settings.accountId + ' not found in cache');
			showAlert(inData.context);
			return;
		}

		// Find the configured account
		var account = cache.data[inData.settings.accountId];

		this.getBroadcast(account, function (success, result) {
			if (!success) {
				log(result);
				showAlert(inData.context);
				return;
			}
			
			// Target data required for the request
			var target = { };

			// Define the target broadcast for the actions
			target.broadcast = result;

			// Define the target message for chat message action
			if (instance instanceof ChatMessageAction) {
				target.message = inData.settings.msg;
			}

			// Call the function which send the request
			inCallback(account, target, function (success, result) {
				if (!success) {
					log(result);
					showAlert(inData.context);
					return;
				}

				showOk(inData.context);
			});
		});
	}

	this.getBroadcast = function(account, callback) {
		var url = "https://www.googleapis.com/youtube/v3/liveBroadcasts"
				+ "?part=snippet,status"
				+ "&broadcastStatus=active"
				+ "&broadcastType=all";
		var xhr = new XMLHttpRequest();
		xhr.responseType = 'json';
		xhr.open("GET", url, true);
		xhr.setRequestHeader('Accept', 'application/json');
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.setRequestHeader('Authorization', 'Bearer ' + account.token);
		xhr.timeout = 2500;
		xhr.onload = function () {
			if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
				var result = xhr.response;
				if (result != undefined && result != null) {
					if ('items' in result) {
						if (result.items.length > 0) {
							var item = result.items[0];
							if (item.status && item.snippet && item.status.lifeCycleStatus == "live") {
								callback(true, {
									'id': item.id,
									'channelId': item.snippet.channelId,
									'liveChatId': item.snippet.liveChatId
								});
							}
							else {
								callback(false, "Could not find an appropriate broadcast. Please make sure that you are live streaming.");
							}
						}
						else {
							callback(false, "Could not find an appropriate broadcast. Please make sure that you are live streaming.");
						}
					}
					else {
						callback(false, "Account request failed.");
					}
				}
				else {
					callback(false, "Account response is undefined or null.");
				}
			}
			else {
				callback(false, 'Could not connect to the account.');
			}
		};
		xhr.onerror = function () {
			callback(false, 'Unable to connect to the account.');
		};
		xhr.ontimeout = function () {
			callback(false, 'Connection to the account timed out.');
		};
		xhr.send();
	}

	// Private function to set the defaults
	function setDefaults(inCallback) {
		// If at least one account is paired
		if (Object.keys(cache.data).length > 0) {
			// Find out type of action
			if (instance instanceof ChatMessageAction) {
				var action = "com.elgato.youtube.chatmessage";

				// If no message is set for this action
				if (!('msg' in settings)) {
					// Create the message attribute
					settings.msg = "";
			
					// Save the settings
					saveSettings(action, inContext, settings);
				}
			}
			else if (instance instanceof ViewersAction) {
				var action = "com.elgato.youtube.viewers";
			}	

			// If no account is set for this action
			if (!('accountId' in settings)) {
				// Sort the accounts alphabatically
				var accountIDsSorted = Object.keys(cache.data).sort(function(a, b) {
					return cache.data[a].name.localeCompare(cache.data[b].name);
				});

				// Set the account automatically to the first one
				settings.accountId = accountIDsSorted[0];

				// Save the settings
				saveSettings(action, inContext, settings);
			}
		}

		// If a callback function was given
		if (inCallback != undefined) {
			// Execute the callback function
			inCallback();
		}
	}
};
