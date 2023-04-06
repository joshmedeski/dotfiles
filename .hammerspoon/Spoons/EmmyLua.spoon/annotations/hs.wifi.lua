--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect WiFi networks
---@class hs.wifi
local M = {}
hs.wifi = M

-- Connect the interface to a wireless network
--
-- Parameters:
--  * network - A string containing the SSID of the network to associate to
--  * passphrase - A string containing the passphrase of the network
--  * interface - An optional string containing the name of an interface (see [hs.wifi.interfaces](#interfaces)). If not present, the default system WLAN device will be used
--
-- Returns:
--  * A boolean, true if the network was joined successfully, false if an error occurred
--
-- Notes:
--  * Enterprise WiFi networks are not currently supported. Please file an issue on GitHub if you need support for enterprise networks
--  * This function blocks Hammerspoon until the operation is completed
--  * If multiple access points are available with the same SSID, one will be chosen at random to connect to
---@return boolean
function M.associate(network, passphrase, interface, ...) end

-- Gets a list of available WiFi networks
--
-- Parameters:
--  * interface - an optional interface name as listed in the results of [hs.wifi.interfaces](#interfaces).  If not present, the interface defaults to the systems default WLAN device.
--
-- Returns:
--  * A table containing the names of all visible WiFi networks
--
-- Notes:
--  * WARNING: This function will block all Lua execution until the scan has completed. It's probably not very sensible to use this function very much, if at all.
function M.availableNetworks(interface, ...) end

-- Perform a scan for available wifi networks in the background (non-blocking)
--
-- Parameters:
--  * fn        - the function to callback when the scan is completed.
--  * interface - an optional interface name as listed in the results of [hs.wifi.interfaces](#interfaces).  If not present, the interface defaults to the systems default WLAN device.
--
-- Returns:
--  * returns a scan object
--
-- Notes:
--  * If you pass in nil as the callback function, the scan occurs but no callback function is called.  This can be useful to update the `cachedScanResults` entry returned by [hs.wifi.interfaceDetails](#interfaceDetails).
--  * The callback function should expect one argument which will be a table if the scan was successful or a string containing an error message if it was not.  The table will be an array of available networks.  Each entry in the array will be a table containing the following keys:
--   * beaconInterval         - The beacon interval (ms) for the network.
--   * bssid                  - The basic service set identifier (BSSID) for the network.
--   * countryCode            - The country code (ISO/IEC 3166-1:1997) for the network.
--   * ibss                   - Whether or not the network is an IBSS (ad-hoc) network.
--   * informationElementData - Information element data included in beacon or probe response frames as an array of integers.
--   * noise                  - The aggregate noise measurement (dBm) for the network.
--   * PHYModes               - A table containing the PHY Modes supported by the network.
--   * rssi                   - The aggregate received signal strength indication (RSSI) measurement (dBm) for the network.
--   * security               - A table containing the security types supported by the network.
--   * ssid                   - The service set identifier (SSID) for the network, encoded as a string.
--   * ssidData               - The service set identifier (SSID) for the network, returned as data (1-32 octets).
--   * wlanChannel            - A table containing details about the channel the network is on. The table will contain the following keys:
--    * band   - The channel band.
--    * number - The channel number.
--    * width  - The channel width.
--
-- Notes:
--  * The contents of the `informationElementData` field is returned as an array of integers, each array item representing a byte in the block of data for the element.
--    * You can convert this data into a Lua string by passing the array as an argument to `string.char(table.unpack(results.informationElementData))`, but note that this field contains arbitrary binary data and should **not** be treated or considered as a *displayable* string. It requires additional parsing, depending upon the specific information you need from the probe or beacon response.
--    * For debugging purposes, if you wish to view the contents of this field as a string, make sure to wrap `string.char(table.unpack(results.informationElementData))` with `hs.utf8.asciiOnly` or `hs.utf8.hexDump`, rather than just print the result directly.
--    * As an example using [hs.wifi.interfaceDetails](#interfaceDetails) whose `cachedScanResults` key is an array of entries identical to the argument passed to this constructor's callback function:
--    ~~~
--    function dumpIED(interface)
--        local interface = interface or "en0"
--        local cleanupFunction = hs.utf8.hexDump -- or hs.utf8.asciiOnly if you prefer
--        local cachedScanResults = hs.wifi.interfaceDetails(interface).cachedScanResults
--        if not cachedScanResults then
--            hs.wifi.availableNetworks() -- blocking, so only do if necessary
--            cachedScanResults = hs.wifi.interfaceDetails(interface).cachedScanResults
--        end
--        for i, v in ipairs(cachedScanResults) do
--            print(v.ssid .. " on channel " .. v.wlanChannel.number .. " beacon data:")
--            print(cleanupFunction(string.char(table.unpack(v.informationElementData))))
--        end
--    end
--    ~~~
--    * These precautions are in response to Hammerspoon GitHub Issue #859.  As binary data, even when cleaned up with the Console's UTF8 wrapper code, some valid UTF8 sequences have been found to cause crashes in the OSX CoreText API during rendering.  While some specific sequences have made the rounds on the Internet, the specific code analysis at http://www.theregister.co.uk/2015/05/27/text_message_unicode_ios_osx_vulnerability/ suggests a possible cause of the problem which may be triggered by other currently unknown sequences as well.  As the sequences aren't at present predictable, we can't add to the UTF8 wrapper already in place for the Hammerspoon console.
function M.backgroundScan(fn, interface, ...) end

-- Gets the name of the current WiFi network
--
-- Parameters:
--  * interface - an optional interface name as listed in the results of [hs.wifi.interfaces](#interfaces).  If not present, the interface defaults to the systems default WLAN device.
--
-- Returns:
--  * A string containing the SSID of the WiFi network currently joined, or nil if no there is no WiFi connection
function M.currentNetwork(interface, ...) end

-- Disconnect the interface from its current network.
--
-- Parameters:
--  * interface - an optional interface name as listed in the results of [hs.wifi.interfaces](#interfaces).  If not present, the interface defaults to the systems default WLAN device.
--
-- Returns:
--  * None
function M.disassociate(interface, ...) end

-- Returns a table containing details about the wireless interface.
--
-- Parameters:
--  * interface - an optional interface name as listed in the results of [hs.wifi.interfaces](#interfaces).  If not present, the interface defaults to the systems default WLAN device.
--
-- Returns:
--  * A table containing details about the interface.  The table will contain the following keys:
--    * active            - The interface has its corresponding network service enabled.
--    * activePHYMode     - The current active PHY mode for the interface.
--    * bssid             - The current basic service set identifier (BSSID) for the interface. Note that for this key to be available, hs.location needs to have been started
--    * cachedScanResults - A table containing the networks currently in the scan cache for the WLAN interface.  See [hs.wifi.backgroundScan](#backgroundScan) for details on the table format.
--    * configuration     - A table containing the current configuration for the given WLAN interface.  This table will contain the following keys:
--      * networkProfiles                    - A table containing an array of known networks for the interface.  Entries in the array will each contain the following keys:
--        * ssid     - The service set identifier (SSID) for the network profile.
--        * ssidData - The service set identifier (SSID) for the network, returned as data (1-32 octets).
--        * security - The security mode for the network profile.
--      * rememberJoinedNetworks             - A boolean flag indicating whether or not the AirPort client will remember all joined networks.
--      * requireAdministratorForAssociation - A boolean flag indicating whether or not changing the wireless network requires an Administrator password.
--      * requireAdministratorForIBSSMode    - A boolean flag indicating whether or not creating an IBSS (Ad Hoc) network requires an Administrator password.
--      * requireAdministratorForPower       - A boolean flag indicating whether or not changing the wireless power state requires an Administrator password.
--    * countryCode       - The current country code (ISO/IEC 3166-1:1997) for the interface.
--    * hardwareAddress   - The hardware media access control (MAC) address for the interface.
--    * interface         - The BSD name of the interface.
--    * interfaceMode     - The current mode for the interface.
--    * noise             - The current aggregate noise measurement (dBm) for the interface.
--    * power             - Whether or not the interface is currently powered on.
--    * rssi              - The current aggregate received signal strength indication (RSSI) measurement (dBm) for the interface.
--    * security          - The current security mode for the interface.
--    * ssid              - The current service set identifier (SSID) for the interface.
--    * ssidData          - The service set identifier (SSID) for the interface, returned as data (1-32 octets).
--    * supportedChannels - An array of channels supported by the interface for the active country code.  The array will contain entries with the following keys:
--      * band   - The channel band.
--      * number - The channel number.
--      * width  - The channel width.
--    * transmitPower     - The current transmit power (mW) for the interface. Returns 0 in the case of an error.
--    * transmitRate      - The current transmit rate (Mbps) for the interface.
--    * wlanChannel       - A table containing details about the channel the interface is on. The table will contain the following keys:
--      * band   - The channel band.
--      * number - The channel number.
--      * width  - The channel width.
function M.interfaceDetails(interface, ...) end

-- Returns a list of interface names for WLAN devices attached to the system
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the names of all WLAN interfaces for this system.
--
-- Notes:
--  * For most systems, this will be one interface, but the result is still returned as an array.
function M.interfaces() end

-- Returns whether or not a scan object has completed its scan for wireless networks.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean value indicating whether or not the scan has been completed.
--
-- Notes:
--  * This will be set whether or not an actual callback function was invoked.  This method can be checked to see if the cached data for the `cachedScanResults` entry returned by [hs.wifi.interfaceDetails](#interfaceDetails) has been updated.
---@return boolean
function M:isDone() end

-- Turns a wifi interface on or off
--
-- Parameters:
--  * state - a boolean value indicating if the Wifi device should be powered on (true) or off (false).
--  * interface - an optional interface name as listed in the results of [hs.wifi.interfaces](#interfaces).  If not present, the interface defaults to the systems default WLAN device.
--
-- Returns:
--  * True if the power change was successful, or false and an error string if an error occurred attempting to set the power state.  Returns nil if there is a problem attaching to the interface.
---@return boolean
function M.setPower(state, interface, ...) end

