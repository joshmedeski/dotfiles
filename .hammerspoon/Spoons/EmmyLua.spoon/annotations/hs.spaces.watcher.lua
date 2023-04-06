--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watches for the current Space being changed
-- NOTE: This extension determines the number of a Space, using OS X APIs that have been deprecated since 10.8 and will likely be removed in a future release. You should not depend on Space numbers being around forever!
---@class hs.spaces.watcher
local M = {}
hs.spaces.watcher = M

-- Creates a new watcher for Space change events
--
-- Parameters:
--  * handler - A function to be called when the active Space changes. It should accept one argument, which will be the number of the new Space (or -1 if the number cannot be determined)
--
-- Returns:
--  * An `hs.spaces.watcher` object
---@return hs.spaces.watcher
function M.new(handler, ...) end

-- Starts the Spaces watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The watcher object
function M:start() end

-- Stops the Spaces watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The watcher object
function M:stop() end

