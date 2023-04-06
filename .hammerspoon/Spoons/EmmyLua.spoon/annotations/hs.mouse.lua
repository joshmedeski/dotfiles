--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect/manipulate the position of the mouse pointer
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
--
-- This module uses ManyMouse by Ryan C. Gordon.
--
-- MANYMOUSE LICENSE:
--
-- Copyright (c) 2005-2012 Ryan C. Gordon and others.
--
-- This software is provided 'as-is', without any express or implied warranty.
-- In no event will the authors be held liable for any damages arising from
-- the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
-- claim that you wrote the original software. If you use this software in a
-- product, an acknowledgment in the product documentation would be
-- appreciated but is not required.
--
-- 2. Altered source versions must be plainly marked as such, and must not be
-- misrepresented as being the original software.
--
-- 3. This notice may not be removed or altered from any source distribution.
--
--     Ryan C. Gordon <icculus@icculus.org>
---@class hs.mouse
local M = {}
hs.mouse = M

-- Get or set the absolute co-ordinates of the mouse pointer
--
-- Parameters:
--  * An optional point table containing the absolute x and y co-ordinates to move the mouse pointer to
--
-- Returns:
--  * A point table containing the absolute x and y co-ordinates of the mouse pointer
--
-- Notes:
--  * If no parameters are supplied, the current position will be returned. If a point table parameter is supplied, the mouse pointer position will be set and the new co-ordinates returned
---@return hs.geometry
function M.absolutePosition(point, ...) end

-- Gets the total number of mice connected to your system.
--
-- Parameters:
--  * includeInternal - A boolean which sets whether or not you want to include internal Trackpad's in the count. Defaults to false.
--
-- Returns:
--  * The number of mice connected to your system
--
-- Notes:
--  * This function leverages code from [ManyMouse](http://icculus.org/manymouse/).
--  * This function considers any mouse labelled as "Apple Internal Keyboard / Trackpad" to be an internal mouse.
---@return number
function M.count(includeInternal, ...) end

-- Gets the identifier of the current mouse cursor type.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string.
--
-- Notes:
--  * Possible values include: arrowCursor, contextualMenuCursor, closedHandCursor, crosshairCursor, disappearingItemCursor, dragCopyCursor, dragLinkCursor, IBeamCursor, operationNotAllowedCursor, pointingHandCursor, resizeDownCursor, resizeLeftCursor, resizeLeftRightCursor, resizeRightCursor, resizeUpCursor, resizeUpDownCursor, IBeamCursorForVerticalLayout or unknown if the cursor type cannot be determined.
--  * This function can also return daVinciResolveHorizontalArrows, when hovering over mouse-draggable text-boxes in DaVinci Resolve. This is determined using the "hotspot" value of the cursor.
---@return string
function M.currentCursorType() end

-- Returns a table containing the current mouse buttons being pressed *at this instant*.
--
-- Parameters:
--  * None
--
-- Returns:
--  * Returns an array containing indices starting from 1 up to the highest numbered button currently being pressed where the index is `true` if the button is currently pressed or `false` if it is not.
--  * Special hash tag synonyms for `left` (button 1), `right` (button 2), and `middle` (button 3) are also set to true if these buttons are currently being pressed.
--
-- Notes:
--  * This function is a wrapper to `hs.eventtap.checkMouseButtons`
--  * This is an instantaneous poll of the current mouse buttons, not a callback.
function M.getButtons() end

-- Gets the screen the mouse pointer is on
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.screen` object that the mouse pointer is on, or nil if an error occurred
function M.getCurrentScreen() end

-- Gets the co-ordinates of the mouse pointer, relative to the screen it is on
--
-- Parameters:
--  * None
--
-- Returns:
--  * A point-table containing the relative x and y co-ordinates of the mouse pointer, or nil if an error occurred
--
-- Notes:
--  * The co-ordinates returned by this function are relative to the top left pixel of the screen the mouse is on (see `hs.mouse.getAbsolutePosition` if you need the location in the full desktop space)
function M.getRelativePosition() end

-- Gets the names of any mice connected to the system.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing strings of all the mice connected to the system.
--
-- Notes:
--  * This function leverages code from [ManyMouse](http://icculus.org/manymouse/).
function M.names() end

-- Gets the system-wide direction of scrolling
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string, either "natural" or "normal"
---@return string
function M.scrollDirection() end

-- Sets the co-ordinates of the mouse pointer, relative to a screen
--
-- Parameters:
--  * point - A point-table containing the relative x and y co-ordinates to move the mouse pointer to
--  * screen - An optional `hs.screen` object. Defaults to the screen the mouse pointer is currently on
--
-- Returns:
--  * None
function M.setRelativePosition(point, screen, ...) end

-- Gets/Sets the current system mouse tracking speed setting
--
-- Parameters:
--  * speed - An optional number containing the new tracking speed to set. If this is omitted, the current setting is returned
--
-- Returns:
--  * A number indicating the current tracking speed setting for mice
--
-- Notes:
--  * This is represented in the System Preferences as the "Tracking speed" setting for mice
--  * Note that not all values will work, they should map to the steps defined in the System Preferences app, which are:
--    * 0.0, 0.125, 0.5, 0.6875, 0.875, 1.0, 1.5, 2.0, 2.5, 3.0
--  * Note that changes to this value will not be noticed immediately by macOS
---@return number
function M.trackingSpeed(speed, ...) end

