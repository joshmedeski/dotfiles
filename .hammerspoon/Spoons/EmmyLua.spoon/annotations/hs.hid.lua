--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- HID interface for Hammerspoon, controls and queries caps lock state
--
-- Portions sourced from (https://discussions.apple.com/thread/7094207).
---@class hs.hid
local M = {}
hs.hid = M

-- Checks the state of the caps lock via HID
--
-- Parameters:
--  * None
--
-- Returns:
--  * true if on, false if off
---@return boolean
function M.capslock.get() end

-- Assigns capslock to the desired state
--
-- Parameters:
--  * state - A boolean indicating desired state
--
-- Returns:
--  * true if on, false if off
---@return boolean
function M.capslock.set(state, ...) end

-- Toggles the state of caps lock via HID
--
-- Parameters:
--  * None
--
-- Returns:
--  * true if on, false if off
---@return boolean
function M.capslock.toggle() end

