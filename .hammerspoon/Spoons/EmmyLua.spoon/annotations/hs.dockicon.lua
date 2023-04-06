--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Control Hammerspoon's dock icon
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.dockicon
local M = {}
hs.dockicon = M

-- Bounce Hammerspoon's dock icon
--
-- Parameters:
--  * indefinitely - A boolean value, true if the dock icon should bounce until the dock icon is clicked, false if the dock icon should only bounce briefly
--
-- Returns:
--  * None
function M.bounce(indefinitely, ...) end

-- Hide Hammerspoon's dock icon
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.hide() end

-- Set Hammerspoon's dock icon badge
--
-- Parameters:
--  * badge - A string containing the label to place inside the dock icon badge. If the string is empty, the badge will be cleared
--
-- Returns:
--  * None
function M.setBadge(badge, ...) end

-- Make Hammerspoon's dock icon visible
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.show() end

-- Get or set a canvas object to be displayed as the Hammerspoon dock icon
--
-- Parameters:
--  * `canvas` - an optional `hs.canvas` object specifying the canvas to be displayed as the dock icon for Hammerspoon. If an explicit `nil` is specified, the dock icon will revert to the Hammerspoon application icon.
--
-- Returns:
--  * If the dock icon is assigned a canvas object, that canvas object will be returned, otherwise returns nil.
--
-- Notes:
--  * If you update the canvas object by changing any of its components, it will not be reflected in the dock icon until you invoke [hs.dockicon.tileUpdate](#tileUpdate).
function M.tileCanvas(canvas, ...) end

-- Returns a table containing the size of the tile representing the dock icon.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the size of the tile representing the dock icon for Hammerspoon. This table will contain `h` and `w` keys specifying the tile height and width as numbers.
--
-- Notes:
--  * the size returned specifies the display size of the dock icon tile. If your canvas item is larger than this, then only the top left portion corresponding to the size returned will be displayed.
function M.tileSize() end

-- Force an update of the dock icon.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * Changes made to a canvas object are not reflected automatically like they are when a canvas is being displayed on the screen; you must invoke this method after making changes to the canvas for the updates to be reflected in the dock icon.
function M.tileUpdate() end

-- Determine whether Hammerspoon's dock icon is visible
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the dock icon is visible, false if not
---@return boolean
function M.visible() end

