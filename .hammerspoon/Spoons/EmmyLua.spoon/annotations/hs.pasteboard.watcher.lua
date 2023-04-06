--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for Pasteboard Changes.
-- macOS doesn't offer any API for getting Pasteboard notifications, so this extension uses polling to check for Pasteboard changes at a chosen interval (defaults to 0.25).
---@class hs.pasteboard.watcher
local M = {}
hs.pasteboard.watcher = M

-- Gets or sets the polling interval (i.e. the frequency the pasteboard watcher checks the pasteboard).
--
-- Parameters:
--  * value - an optional number to set the polling interval to.
--
-- Returns:
--  * The polling interval as a number.
--
-- Notes:
--  * This only affects new watchers, not existing/running ones.
--  * The default value is 0.25.
---@return number
function M.interval(value, ...) end

-- Creates and starts a new `hs.pasteboard.watcher` object for watching for Pasteboard changes.
--
-- Parameters:
--  * callbackFn - A function that will be called when the Pasteboard contents has changed. It should accept one parameter:
--   * A string containing the pasteboard contents or `nil` if the contents is not a valid string.
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard.
--
-- Returns:
--  * An `hs.pasteboard.watcher` object
--
-- Notes:
--  * Internally this extension uses a single `NSTimer` to check for changes to the pasteboard count every half a second.
--  * Example usage:
--  ```lua
--  generalPBWatcher = hs.pasteboard.watcher.new(function(v) print(string.format("General Pasteboard Contents: %s", v)) end)
--  specialPBWatcher = hs.pasteboard.watcher.new(function(v) print(string.format("Special Pasteboard Contents: %s", v)) end, "special")
--  hs.pasteboard.writeObjects("This is on the general pasteboard.")
--  hs.pasteboard.writeObjects("This is on the special pasteboard.", "special")```
function M.new(callbackFn, name, ...) end

-- Returns a boolean indicating whether or not the Pasteboard Watcher is currently running.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether or not the timer is currently running.
---@return boolean
function M:running() end

-- Starts an `hs.pasteboard.watcher` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.pasteboard.watcher` object
function M:start() end

-- Stops an `hs.pasteboard.watcher` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.pasteboard.watcher` object
function M:stop() end

