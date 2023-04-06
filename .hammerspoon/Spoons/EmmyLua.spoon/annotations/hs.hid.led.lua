--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- HID LED interface for Hammerspoon, controls the state of keyboard LEDs
---@class hs.hid.led
local M = {}
hs.hid.led = M

-- Assigns HID LED to the desired state
--
-- Parameters:
--  * name  - LED name: "caps", "scroll" or "num"
--  * state - A boolean indicating desired state
--
-- Returns:
--  * true if success, false if error
--
-- Notes:
--  * This function controls the LED state only, to modify capslock state, use hs.hid.capslock.set
---@return boolean
function M.set(name, state, ...) end

