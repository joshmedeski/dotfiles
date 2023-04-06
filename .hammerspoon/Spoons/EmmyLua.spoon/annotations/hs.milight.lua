--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Simple controls for the MiLight LED WiFi bridge (also known as LimitlessLED and EasyBulb)
---@class hs.milight
local M = {}
hs.milight = M

-- Deletes an `hs.milight` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:delete() end

-- Cycles through the disco modes
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the command was sent correctly, otherwise false
---@return boolean
function M:disco() end

-- Specifies the maximum brightness value that can be used. Defaults to 25
M.maxBrightness = nil

-- Specifies the minimum brightness value that can be used. Defaults to 0
M.minBrightness = nil

-- Creates a new bridge object, which will be connected to the supplied IP address and port
--
-- Parameters:
--  * ip - A string containing the IP address of the MiLight WiFi bridge device. For convenience this can be the broadcast address of your network (e.g. 192.168.0.255)
--  * port - An optional number containing the UDP port to talk to the bridge on. Defaults to 8899
--
-- Returns:
--  * An `hs.milight` object
--
-- Notes:
--  * You can not use 255.255.255.255 as the IP address, to do so requires elevated privileges for the Hammerspoon process
function M.new(ip, port, ...) end

-- Sends a command to the bridge
--
-- Parameters:
--  * cmd - A command from the `hs.milight.cmd` table
--  * value - An optional value, if appropriate for the command (defaults to 0x00)
--
-- Returns:
--  * True if the command was sent, otherwise false
--
-- Notes:
--  * This is a low level command, you typically should use a specific method for the operation you want to perform
---@return boolean
function M:send(cmd, value, ...) end

-- Sets brightness for the specified zone
--
-- Parameters:
--  * zone - A number specifying which zone to operate on. 0 for all zones, 1-4 for zones one through four
--  * value - A number containing the brightness level to set, between `hs.milight.minBrightness` and `hs.milight.maxBrightness`
--
-- Returns:
--  * A number containing the value that was sent to the WiFi bridge, or -1 if an error occurred
---@return number
function M:zoneBrightness(zone, value, ...) end

-- Sets RGB color for the specified zone
--
-- Parameters:
--  * zone - A number specifying which zone to operate on. 0 for all zones, 1-4 for zones one through four
--  * value - A number between 0 and 255 that represents a color
--
-- Returns:
--  * True if the command was sent correctly, otherwise false
--
-- Notes:
--  * The color value is not a normal RGB colour, but rather a lookup in an internal table in the light hardware. While any number between 0 and 255 is valid, there are some useful values worth knowing:
--   * 00 - Violet
--   * 16 - Royal Blue
--   * 32 - Baby Blue
--   * 48 - Aqua
--   * 64 - Mint Green
--   * 80 - Seafoam Green
--   * 96 - Green
--   * 112 - Lime Green
--   * 128 - Yellow
--   * 144 - Yellowy Orange
--   * 160 - Orange
--   * 176 - Red
--   * 194 - Pink
--   * 210 - Fuchsia
--   * 226 - Lilac
--   * 240 - Lavender
---@return boolean
function M:zoneColor(zone, value, ...) end

-- Turns off the specified zone
--
-- Parameters:
--  * zone - A number specifying which zone to operate on. 0 for all zones, 1-4 for zones one through four
--
-- Returns:
--  * True if the command was sent correctly, otherwise false
---@return boolean
function M:zoneOff(zone, ...) end

-- Turns on the specified zone
--
-- Parameters:
--  * zone - A number specifying which zone to operate on. 0 for all zones, 1-4 for zones one through four
--
-- Returns:
--  * True if the command was sent correctly, otherwise false
---@return boolean
function M:zoneOn(zone, ...) end

-- Sets the specified zone to white
--
-- Parameters:
--  * zone - A number specifying which zone to operate on. 0 for all zones, 1-4 for zones one through four
--
-- Returns:
--  * True if the command was sent correctly, otherwise false
---@return boolean
function M:zoneWhite(zone, ...) end

