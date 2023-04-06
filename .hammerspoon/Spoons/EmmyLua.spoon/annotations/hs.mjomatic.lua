--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- tmuxomatic-like window management
---@class hs.mjomatic
local M = {}
hs.mjomatic = M

-- Applies a configuration to the currently open windows
--
-- Parameters:
--  * cfg - A table containing a series of strings, representing the desired window layout
--
-- Returns:
--  * None
--
-- Notes:
--  * An example use:
--
-- ~~~lua
-- mjomatic.go({
-- "CCCCCCCCCCCCCiiiiiiiiiii      # <-- The windowgram, it defines the shapes and positions of windows",
-- "CCCCCCCCCCCCCiiiiiiiiiii",
-- "SSSSSSSSSSSSSiiiiiiiiiii",
-- "SSSSSSSSSSSSSYYYYYYYYYYY",
-- "SSSSSSSSSSSSSYYYYYYYYYYY",
-- "",
-- "C Google Chrome            # <-- window C has application():title() 'Google Chrome'",
-- "i iTerm",
-- "Y YoruFukurou",
-- "S Sublime Text 2"})
-- ~~~
function M.go(cfg, ...) end

