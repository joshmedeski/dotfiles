--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- List and run shortcuts from the Shortcuts app
--
-- Separate from this extension, Hammerspoon provides an action for use in the Shortcuts app.
-- The action is called "Execute Lua" and if it is passed a text block of valid Lua, it will execute that Lua within Hammerspoon.
-- You can use this action to call functions defined in your `init.lua` or to just execute chunks of Lua.
--
-- Your functions/chunks can return text, which will be returned by the action in Shortcuts.
---@class hs.shortcuts
local M = {}
hs.shortcuts = M

-- Returns a list of available shortcuts
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table of shortcuts, each being a table with the following keys:
--   * name - The name of the shortcut
--   * id - A unique ID for the shortcut
--   * acceptsInput - A boolean indicating if the shortcut requires input
--   * actionCount - A number relating to how many actions are in the shortcut
function M.list() end

-- Execute a Shortcuts shortcut by name
--
-- Parameters:
--  * name - A string containing the name of the Shortcut to execute
--
-- Returns:
--  * None
function M.run(name, ...) end

