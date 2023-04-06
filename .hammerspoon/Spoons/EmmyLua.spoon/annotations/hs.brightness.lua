--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect/manipulate display brightness
--
-- Home: https://github.com/asmagill/mjolnir_asm.sys
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.brightness
local M = {}
hs.brightness = M

-- Gets the current ambient brightness
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the current ambient brightness, measured in lux. If an error occurred, the number will be -1
--
-- Notes:
--  * Even though external Apple displays include an ambient light sensor, their data is typically not available, so this function will likely only be useful to MacBook users
--
--  * On Silicon based macs, this function uses a method similar to that used by `corebrightnessdiag` to retrieve the aggregate lux as reported to `sysdiagnose`.
--  * On Intel based macs, the raw sensor data is converted to lux via an algorithm used by Mozilla Firefox and is not guaranteed to give an accurate lux value.
---@return number
function M.ambient() end

-- Returns the current brightness of the display
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the brightness of the display, between 0 and 100
---@return number
function M.get() end

-- Sets the display brightness
--
-- Parameters:
--  * brightness - A number between 0 and 100
--
-- Returns:
--  * True if the brightness was set, false if not
---@return boolean
function M.set(brightness, ...) end

