--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Window layout manager
--
-- This extension allows you to trigger window placement/sizing to a number of windows at once
---@class hs.layout
local M = {}
hs.layout = M

-- Applies a layout to applications/windows
--
-- Parameters:
--  * table - A table describing your desired layout. Each element in the table should be another table describing a set of windows to match, and their desired size/position. The fields in each of these tables are:
--   * A string containing an application name, or an `hs.application` object, or nil
--   * A string containing a window title, or an `hs.window` object, or a function, or nil
--   * A string containing a screen name, or an `hs.screen` object, or a function that accepts no parameters and returns an `hs.screen` object, or nil to select the first available screen
--   * A Unit rect, or a function which is called for each window and returns a unit rect (see `hs.window.moveToUnit()`). The function should accept one parameter, which is the window object.
--   * A Frame rect, or a function which is called for each window and returns a frame rect (see `hs.screen:frame()`). The function should accept one parameter, which is the window object.
--   * A Full-frame rect, of a function which is called for each window and returns a full-frame rect (see `hs.screen:fullFrame()`). The function should accept one parameter, which is the window object.
--  * windowTitleComparator - (optional) Function to use for window title comparison. It is called with two string arguments (below) and its return value is evaluated as a boolean. If no comparator is provided, the '==' operator is used
--   * windowTitle: The `:title()` of the window object being examined
--   * layoutWindowTitle: The window title string (second field) specified in each element of the layout table
--   * Optionally a final element, the key "options" and a table value that can contain the following keys:
--     * `absolute_x`: A boolean indicating that the x value in a frame rect above, is an absolute co-ordinate (ie useful for negative absolute co-ordinates)
--     * `absolute_y`: A boolean indicating that the y value in a frame rect above, is an absolute co-ordinate (ie useful for negative absolute co-ordinates)
--
-- Returns:
--  * None
--
-- Notes:
--  * If the application name argument is nil, window titles will be matched regardless of which app they belong to
--  * If the window title argument is nil, all windows of the specified application will be matched
--  * If the window title argument is a function, the function will be called with the application name argument (which may be nil), and should return a table of `hs.window` objects (even if there is only one window it must be in a table)
--  * You can specify both application name and window title if you want to match only one window of a particular application
--  * If you specify neither application name or window title, no windows will be matched :)
--  * Monitor name is a string, as found in `hs.screen:name()` or `hs.screen:getUUID()`. You can also pass an `hs.screen` object, or a function that returns an `hs.screen` object. If you pass nil, the first screen will be selected
--  * The final three arguments use `hs.geometry.rect()` objects to describe the desired position and size of matched windows:
--    * Unit rect will be passed to `hs.window.moveToUnit()`
--    * Frame rect will be passed to `hs.window.setFrame()` (including menubar and dock)
--    * Full-frame rect will be passed to `hs.window.setFrame()` (ignoring menubar and dock)
--  * If either the x or y components of frame/full-frame rect are negative, they will be applied as offsets against the opposite edge of the screen (e.g. If x is -100 then the left edge of the window will be 100 pixels from the right edge of the screen)
--  * Only one of the rect arguments will apply to any matched windows. If you specify more than one, the first will win
--  * An example usage:
--
--     ```lua
--       layout1 = {
--         {"Mail", nil, "Color LCD", hs.layout.maximized, nil, nil},
--         {"Safari", nil, "Thunderbolt Display", hs.layout.maximized, nil, nil},
--         {"iTunes", "iTunes", "Color LCD", hs.layout.maximized, nil, nil},
--         {"iTunes", "MiniPlayer", "Color LCD", nil, nil, hs.geometry.rect(0, -48, 400, 48)},
--       }```
--  * An example of a function that works well as a `windowTitleComparator` is the Lua built-in `string.match`, which uses Lua Patterns to match strings
function M.apply(table, windowTitleComparator, ...) end

-- A unit rect which will make a window occupy the left 25% of a screen
M.left25 = nil

-- A unit rect which will make a window occupy the left 30% of a screen
M.left30 = nil

-- A unit rect which will make a window occupy the left 50% of a screen
M.left50 = nil

-- A unit rect which will make a window occupy the left 70% of a screen
M.left70 = nil

-- A unit rect which will make a window occupy the left 75% of a screen
M.left75 = nil

-- A unit rect which will make a window occupy all of a screen
M.maximized = nil

-- A unit rect which will make a window occupy the right 25% of a screen
M.right25 = nil

-- A unit rect which will make a window occupy the right 30% of a screen
M.right30 = nil

-- A unit rect which will make a window occupy the right 50% of a screen
M.right50 = nil

-- A unit rect which will make a window occupy the right 70% of a screen
M.right70 = nil

-- A unit rect which will make a window occupy the right 75% of a screen
M.right75 = nil

