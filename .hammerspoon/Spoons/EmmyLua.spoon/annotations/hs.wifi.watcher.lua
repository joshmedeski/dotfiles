--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for changes to the associated wifi network
---@class hs.wifi.watcher
local M = {}
hs.wifi.watcher = M

-- A table containing the possible event types that this watcher can monitor for.
--
-- Notes:
--  * The following events are available for monitoring:
--   * "SSIDChange"                   - monitor when the associated network for the Wi-Fi interface changes
--   * "BSSIDChange"                  - monitor when the base station the Wi-Fi interface is connected to changes
--   * "countryCodeChange"            - monitor when the adopted country code of the Wi-Fi interface changes
--   * "linkChange"                   - monitor when the link state for the Wi-Fi interface changes
--   * "linkQualityChange"            - monitor when the RSSI or transmit rate for the Wi-Fi interface changes
--   * "modeChange"                   - monitor when the operating mode of the Wi-Fi interface changes
--   * "powerChange"                  - monitor when the power state of the Wi-Fi interface changes
--   * "scanCacheUpdated"             - monitor when the scan cache of the Wi-Fi interface is updated with new information
---@type table
M.eventTypes = {}

-- Creates a new watcher for WiFi network events
--
-- Parameters:
--  * fn - A function that will be called when a WiFi event that is being monitored occurs. The function should expect 2 or 4 arguments as described in the notes below.
--
-- Returns:
--  * A `hs.wifi.watcher` object
--
-- Notes:
--  * For backwards compatibility, only "SSIDChange" is watched for by default, so existing code can continue to ignore the callback function arguments unless you add or change events with the [hs.wifi.watcher:watchingFor](#watchingFor).
--  * The callback function should expect between 3 and 5 arguments, depending upon the events being watched.  The possible arguments are as follows:
--    * `watcher`, "SSIDChange", `interface` - occurs when the associated network for the Wi-Fi interface changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "SSIDChange"
--      * `interface` - the name of the interface for which the event occurred
--    * Use `hs.wifi.currentNetwork([interface])` to identify the new network, which may be nil when you leave a network.
--    * `watcher`, "BSSIDChange", `interface` - occurs when the base station the Wi-Fi interface is connected to changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "BSSIDChange"
--      * `interface` - the name of the interface for which the event occurred
--    * `watcher`, "countryCodeChange", `interface` - occurs when the adopted country code of the Wi-Fi interface changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "countryCodeChange"
--      * `interface` - the name of the interface for which the event occurred
--    * `watcher`, "linkChange", `interface` - occurs when the link state for the Wi-Fi interface changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "linkChange"
--      * `interface` - the name of the interface for which the event occurred
--    * `watcher`, "linkQualityChange", `interface` - occurs when the RSSI or transmit rate for the Wi-Fi interface changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "linkQualityChange"
--      * `interface` - the name of the interface for which the event occurred
--      * `rssi`      - the RSSI value for the currently associated network on the Wi-Fi interface
--      * `rate`      - the transmit rate for the currently associated network on the Wi-Fi interface
--    * `watcher`, "modeChange", `interface` - occurs when the operating mode of the Wi-Fi interface changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "modeChange"
--      * `interface` - the name of the interface for which the event occurred
--    * `watcher`, "powerChange", `interface` - occurs when the power state of the Wi-Fi interface changes
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "powerChange"
--      * `interface` - the name of the interface for which the event occurred
--    * `watcher`, "scanCacheUpdated", `interface` - occurs when the scan cache of the Wi-Fi interface is updated with new information
--      * `watcher`   - the watcher object itself
--      * `message`   - the message specifying the event, in this case "scanCacheUpdated"
--      * `interface` - the name of the interface for which the event occurred
---@return hs.wifi.watcher
function M.new(fn) end

-- Starts the SSID watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.wifi.watcher` object
---@return hs.wifi.watcher
function M:start() end

-- Stops the SSID watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.wifi.watcher` object
---@return hs.wifi.watcher
function M:stop() end

-- Get or set the specific types of wifi events to generate a callback for with this watcher.
--
-- Parameters:
--  * `messages` - an optional table of or list of strings specifying the types of events this watcher should invoke a callback for.  You can specify multiple types of events to watch for. Defaults to `{ "SSIDChange" }`.
--
-- Returns:
--  * if a value is provided, returns the watcher object; otherwise returns the current values as a table of strings.
--
-- Notes:
--  * the possible values for this method are described in [hs.wifi.watcher.eventTypes](#eventTypes).
--  * the special string "all" specifies that all event types should be watched for.
function M:watchingFor(messages, ...) end

