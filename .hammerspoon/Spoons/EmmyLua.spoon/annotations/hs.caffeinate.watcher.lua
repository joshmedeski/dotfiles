--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for display and system sleep/wake/power events
-- and for fast user switching session events.
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.caffeinate.watcher
local M = {}
hs.caffeinate.watcher = M

-- Creates a watcher object for system and display sleep/wake/power events
--
-- Parameters:
--  * fn - A function that will be called when system/display events happen. It should accept one parameter:
--   * An event type (see the constants defined above)
--
-- Returns:
--  * An `hs.caffeinate.watcher` object
---@return hs.caffeinate.watcher
function M.new(fn) end

-- The screensaver started
M.screensaverDidStart = nil

-- The screensaver stopped
M.screensaverDidStop = nil

-- The screensaver is about to stop
M.screensaverWillStop = nil

-- The screen was locked
M.screensDidLock = nil

-- The displays have gone to sleep
M.screensDidSleep = nil

-- The screen was unlocked
M.screensDidUnlock = nil

-- The displays have woken from sleep
M.screensDidWake = nil

-- The session became active, due to fast user switching
M.sessionDidBecomeActive = nil

-- The session is no longer active, due to fast user switching
M.sessionDidResignActive = nil

-- Starts the sleep/wake watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.caffeinate.watcher` object
function M:start() end

-- Stops the sleep/wake watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.caffeinate.watcher` object
function M:stop() end

-- The system woke from sleep
M.systemDidWake = nil

-- The user requested a logout or shutdown
M.systemWillPowerOff = nil

-- The system is preparing to sleep
M.systemWillSleep = nil

