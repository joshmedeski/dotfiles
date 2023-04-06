--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Adds a hotkey to reload the hammerspoon configuration, and a pathwatcher to automatically reload on changes.
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip)
---@class spoon.ReloadConfiguration
local M = {}
spoon.ReloadConfiguration = M

-- Binds hotkeys for ReloadConfiguration
--
-- Parameters:
--  * mapping - A table containing hotkey modifier/key details for the following items:
--   * reloadConfiguration - This will cause the configuration to be reloaded
function M:bindHotkeys(mapping, ...) end

-- Start ReloadConfiguration
--
-- Parameters:
--  * None
function M:start() end

-- List of directories to watch for changes, defaults to hs.configdir
M.watch_paths = nil

