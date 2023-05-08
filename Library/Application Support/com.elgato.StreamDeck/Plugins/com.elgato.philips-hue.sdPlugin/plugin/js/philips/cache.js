/**
@file      cache.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Prototype for a data cache
function Cache() {
    // Init Cache
    let instance = this;

    // Refresh time of the cache  in seconds
    let autoRefreshTime = 60;

    // Private timer instance
    let timer = null;

    // Private bridge discovery
    let discovery = null;

    // Public variable containing the cached data
    this.data = {};

    // Private function to discover all bridges on the network
    function buildDiscovery(inCallback) {
        // Check if discovery ran already
        if (discovery != null) {
            inCallback(true);
            return;
        }

        // Init discovery variable to indicate that it ran already
        discovery = {};

        // Run discovery
        Bridge.discover((inSuccess, inBridges) => {
            // If the discovery was not successful
            if (!inSuccess) {
                log(inBridges);
                inCallback(false);
                return;
            }

            // For all discovered bridges
            inBridges.forEach(inBridge => {
                // Add new bridge to discovery object
                discovery[inBridge.getID()] = {
                    ip: inBridge.getIP()
                };
            });

            inCallback(true);
        });
    }

    // Gather all required information by a Bridge via ID
    function refreshBridge(pairedBridgeID, pairedBridge) {
        // Older Bridges in Settings may have the ID stored inside the object
        if (!pairedBridge.id) {
            pairedBridge.id = pairedBridgeID;
        }

        // Older Bridges in Settings may have no IP stored
        if (!pairedBridge.ip) {
            // Trying to receive the IP trough auto-discovery
            if (discovery[pairedBridge.id]) {
                pairedBridge.ip = discovery[pairedBridge.id].ip;
            }

            // If no IP can be found for this Bridge we need to stop here
            else {
                log(`No IP found for paired Bridge ID: ${pairedBridge.id}`);
                return;
            }
        }

        // Create a bridge instance
        let bridge = new Bridge(pairedBridge.ip, pairedBridge.id, pairedBridge.username);

        // Create bridge cache
        let bridgeCache = { 'lights': {}, 'groups': {} };
        bridgeCache.id = bridge.getID();
        bridgeCache.ip = bridge.getIP();
        bridgeCache.username = bridge.getUsername();

        // Load the bridge name
        bridge.getName((inSuccess, inName) => {
            // If getName was not successful
            if (!inSuccess) {
                log(inName);
                return;
            }

            // Save the name
            bridgeCache.name = inName;

            // Add bridge to the cache
            // instance.data[bridge.getID()] = bridgeCache;

            // Request all lights of the bridge
            bridge.getLights((inSuccess, inLights) => {
                // If getLights was not successful
                if (!inSuccess) {
                    log(inLights);
                    return;
                }

                // Create cache for each light
                inLights.forEach(inLight => {
                    // Add light to cache
                    bridgeCache.lights['l-' + inLight.getID()] = {
                        id: inLight.getID(),
                        name: inLight.getName(),
                        type: inLight.getType(),
                        power: inLight.getPower(),
                        brightness: inLight.getBrightness(),
                        xy: inLight.getXY(),
                        temperature: inLight.getTemperature(),
                    };
                });

                // Request all groups of the bridge
                bridge.getGroups((inSuccess, inGroups) => {
                    // If getGroups was not successful
                    if (!inSuccess) {
                        log(inGroups);
                        return;
                    }

                    // Create cache for each group
                    inGroups.forEach(inGroup => {
                        // Add group to cache
                        bridgeCache.groups['g-' + inGroup.getID()] = {
                            id: inGroup.getID(),
                            name: inGroup.getName(),
                            type: inGroup.getType(),
                            power: inGroup.getPower(),
                            brightness: inGroup.getBrightness(),
                            xy: inGroup.getXY(),
                            temperature: inGroup.getTemperature(),
                            scenes: {},
                        };

                        // If this is the last group
                        if (Object.keys(bridgeCache.groups).length === inGroups.length) {
                            // Request all scenes of the bridge
                            bridge.getScenes((inSuccess, inScenes) => {
                                // If getScenes was not successful
                                if (!inSuccess) {
                                    log(inScenes);
                                    return;
                                }

                                // Create cache for each scene
                                inScenes.forEach(inScene => {
                                    // Check if this is a group scene
                                    if (inScene.getType() !== 'GroupScene') {
                                        return;
                                    }

                                    // If scenes group is in cache
                                    if ('g-' + inScene.getGroup() in bridgeCache.groups) {
                                        // Add scene to cache
                                        bridgeCache.groups['g-' + inScene.getGroup()].scenes[inScene.getID()] = {
                                            id: inScene.getID(),
                                            name: inScene.getName(),
                                            type: inScene.getType(),
                                            group: inScene.getGroup(),
                                        };
                                    }
                                });
                                // console.log(bridgeCache);
                                instance.data[bridge.getID()] = bridgeCache;
                                // Inform keys that updated cache is available
                                let event = new CustomEvent('newCacheAvailable');
                                document.dispatchEvent(event);
                            });
                        }
                    });
                });
            });
        });
    }

    // Public function to start polling
    this.startPolling = () => {
        // Log to the global log file
        log('Start polling to create cache');

        // Start a timer
        instance.refresh();
        timer = setInterval(instance.refresh, autoRefreshTime * 1000);
    }

    // Public function to stop polling
    this.stopPolling = () => {
        // Log to the global log file
        log('Stop polling to create cache');

        // Invalidate the timer
        clearInterval(timer);
        timer = null;
    }

    this.refresh = Utils.debounce(function () {
        // Build discovery if necessary
        buildDiscovery(() => {
            if (globalSettings.bridges) {
                Object.keys(globalSettings.bridges).forEach(bridgeID => refreshBridge(bridgeID, globalSettings.bridges[bridgeID]));
            }
        })
    }, 200); // avoid multiple calls in a short time

    // Private function to build a cache
    this.refresh2 = () => {
        // Build discovery if necessary
        buildDiscovery(() => {
            if (globalSettings.bridges) {
                Object.keys(globalSettings.bridges).forEach(bridgeID => refreshBridge(bridgeID, globalSettings.bridges[bridgeID]));
            }
        })
    };
}
