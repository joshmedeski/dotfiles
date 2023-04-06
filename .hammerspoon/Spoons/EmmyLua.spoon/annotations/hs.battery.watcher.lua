--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for battery/power state changes
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.battery.watcher
local M = {}
hs.battery.watcher = M

-- Creates a battery watcher
--
-- Parameters:
--  * A function that will be called when the battery state changes. The function should accept no arguments.
--
-- Returns:
--  * An `hs.battery.watcher` object
--
-- Notes:
--  * Because the callback function accepts no arguments, tracking of state of changing battery attributes is the responsibility of the user (see https://github.com/Hammerspoon/hammerspoon/issues/166 for discussion)
---@return hs.battery.watcher
function M.new(fn) end

-- Starts the battery watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.battery.watcher` object
---@return hs.battery.watcher
function M:start() end

-- Stops the battery watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.battery.watcher` object
---@return hs.battery.watcher
function M:stop() end

