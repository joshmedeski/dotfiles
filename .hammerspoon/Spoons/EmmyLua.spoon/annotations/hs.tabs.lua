--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Place the windows of an application into tabs drawn on its titlebar
---@class hs.tabs
local M = {}
hs.tabs = M

-- Places all the windows of an app into one place and tab them
--
-- Parameters:
--  * app - An `hs.application` object or the app title
--
-- Returns:
--  * None
function M.enableForApp(app, ...) end

-- Focuses a specific tab of an app
--
-- Parameters:
--  * app - An `hs.application` object previously enabled for tabbing
--  * num - A tab number to switch to
--
-- Returns:
--  * None
--
-- Notes:
--  * If num is higher than the number of tabs, the last tab will be focussed
function M.focusTab(app, num, ...) end

-- Gets a list of the tabs of a window
--
-- Parameters:
--  * app - An `hs.application` object
--
-- Returns:
--  * An array of the tabbed windows of an app in the same order as they would be tabbed
--
-- Notes:
--  * This function can be used when writing tab switchers
function M.tabWindows(app, ...) end

