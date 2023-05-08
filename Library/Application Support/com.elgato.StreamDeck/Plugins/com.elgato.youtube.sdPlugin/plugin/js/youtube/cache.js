//==============================================================================
/**
@file       cache.js
@brief      YouTube Plugin
@copyright  (c) 2021, Corsair Memory, Inc.
            This source code is licensed under the MIT-style license found in the LICENSE file.
**/
//==============================================================================

// Prototype for a data cache
function Cache() {
		// Init Cache
		var instance = this;

		// Public variable containing the cached data
		this.data = {};

		// Private function to build a cache
		this.update = function () {
				var newData = {};

				// If some accounts are paired
				if (globalSettings.accounts != undefined) {
				
						globalSettings.accounts.forEach(function (inAccount) {
								// Create account
								var newAccount = { };
								newAccount.id = inAccount.uniqueIdentifier;
								newAccount.name = inAccount.displayName;
								newAccount.token = inAccount.token;

								// Store new account
								newData[newAccount.id] = newAccount;
						});
				}

				// Remove old accounts
				Object.keys(instance.data).forEach(function (accountID) {
						// If cached account doesn't exist anymore
						if (!(accountID in newData)) {
								// Remove account from the cache
								delete instance.data[accountID];
						}
				});

				// Add new or Update existing accounts
				Object.keys(newData).forEach(function (newAccountID) {
						var newAccount = newData[newAccountID];

						// If new account not cached yet
						if (!(newAccountID in instance.data)) {
								// Add new account in the cache
								instance.data[newAccountID] = newAccount;
						}

						// If received & cached tokens don't match
						if (newAccount.token != instance.data[newAccountID].token) {
								// Update existing account in the cache
								instance.data[newAccountID] = newAccount;
						}
				});

				// Inform keys that updated cache is available
				var event = new CustomEvent('newCacheAvailable');
				document.dispatchEvent(event);
		};
};
