--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for application launch/terminate events
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Markus Engelbrecht](https://github.com/mgee) and [Steven Degutis](https://github.com/sdegutis/).
---@class hs.application.watcher
local M = {}
hs.application.watcher = M

-- An application has been activated (i.e. given keyboard/mouse focus)
M.activated = nil

-- An application has been deactivated (i.e. lost keyboard/mouse focus)
M.deactivated = nil

-- An application has been hidden
M.hidden = nil

-- An application has been launched
M.launched = nil

-- An application is in the process of being launched
M.launching = nil

-- Creates an application event watcher
--
-- Parameters:
--  * fn - A function that will be called when application events happen. It should accept three parameters:
--   * A string containing the name of the application
--   * An event type (see the constants defined above)
--   * An `hs.application` object representing the application, or nil if the application couldn't be found
--
-- Returns:
--  * An `hs.application.watcher` object
--
-- Notes:
--  * If the function is called with an event type of `hs.application.watcher.terminated` then the application name parameter will be `nil` and the `hs.application` parameter, will only be useful for getting the UNIX process ID (i.e. the PID) of the application
---@return hs.application.watcher
function M.new(fn) end

-- Starts the application watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.application.watcher` object
function M:start() end

-- Stops the application watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.application.watcher` object
function M:stop() end

-- An application has been terminated
M.terminated = nil

-- An application has been unhidden
M.unhidden = nil

