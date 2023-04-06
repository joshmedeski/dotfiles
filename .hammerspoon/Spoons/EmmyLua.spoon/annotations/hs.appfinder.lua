--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Easily find `hs.application` and `hs.window` objects
--
-- This module is *deprecated*; you can use `hs.window.find()`, `hs.window.get()`, `hs.application.find()`,
-- `hs.application.get()`, `hs.application:findWindow()` and `hs.application:getWindow()` instead.
---@class hs.appfinder
local M = {}
hs.appfinder = M

-- Finds an application by its name (e.g. "Safari")
--
-- Parameters:
--  * name - A string containing the name of the application to search for
--
-- Returns:
--  * An hs.application object if one can be found, otherwise nil
function M.appFromName(name, ...) end

-- Finds an application by its window title (e.g. "Activity Monitor (All Processes)")
--
-- Parameters:
--  * title - A string containing a window title of the application to search for
--
-- Returns:
--  * An hs.application object if one can be found, otherwise nil
function M.appFromWindowTitle(title, ...) end

-- Finds an application by Lua pattern in its window title (e.g."Inbox %(%d+ messages.*)")
--
-- Parameters:
--  * pattern - a Lua pattern describing a window title of the application to search for
--
-- Returns:
--  * An hs.application object if one can be found, otherwise nil
--
-- Notes:
--  * For more about Lua patterns, see http://lua-users.org/wiki/PatternsTutorial and http://www.lua.org/manual/5.2/manual.html#6.4.1
function M.appFromWindowTitlePattern(pattern, ...) end

-- Finds a window by its title (e.g. "Activity Monitor (All Processes)")
--
-- Parameters:
--  * title - A string containing the title of the window to search for
--
-- Returns:
--  * An hs.window object if one can be found, otherwise nil
function M.windowFromWindowTitle(title, ...) end

-- Finds a window by Lua pattern in its title (e.g."Inbox %(%d+ messages.*)")
--
-- Parameters:
--  * pattern - a Lua pattern describing a window title of the window to search for
--
-- Returns:
--  * An hs.window object if one can be found, otherwise nil
--
-- Notes:
--  * For more about Lua patterns, see http://lua-users.org/wiki/PatternsTutorial and http://www.lua.org/manual/5.2/manual.html#6.4.1
function M.windowFromWindowTitlePattern(pattern, ...) end

