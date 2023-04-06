--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Create/manage modal keyboard shortcut environments
--
-- Usage:
-- ```lua
-- k = hs.hotkey.modal.new('cmd-shift', 'd')
-- function k:entered() hs.alert'Entered mode' end
-- function k:exited()  hs.alert'Exited mode'  end
-- k:bind('', 'escape', function() k:exit() end)
-- k:bind('', 'J', 'Pressed J',function() print'let the record show that J was pressed' end)```
---@class hs.hotkey.modal
local M = {}
hs.hotkey.modal = M

-- Creates a hotkey that is enabled/disabled as the modal is entered/exited
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--  * message - A string containing a message to be displayed via `hs.alert()` when the hotkey has been triggered, or nil for no alert
--  * pressedfn - A function that will be called when the hotkey has been pressed, or nil
--  * releasedfn - A function that will be called when the hotkey has been released, or nil
--  * repeatfn - A function that will be called when a pressed hotkey is repeating, or nil
--
-- Returns:
--  * The `hs.hotkey.modal` object for method chaining
---@return hs.hotkey.modal
function M:bind(mods, key, message, pressedfn, releasedfn, repeatfn, ...) end

-- Deletes a modal hotkey object without calling :exited()
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:delete() end

-- Enters a modal state
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.hotkey.modal` object for method chaining
--
-- Notes:
--  * This method will enable all of the hotkeys defined in the modal state via `hs.hotkey.modal:bind()`,
--    and disable the hotkey that entered the modal state (if one was defined)
--  * If the modal state was created with a keyboard combination, this method will be called automatically
---@return hs.hotkey.modal
function M:enter() end

-- Optional callback for when a modal is entered
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a preexisting function that you should override if you need to use it; the default implementation does nothing.
function M:entered() end

-- Exits a modal state
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.hotkey.modal` object for method chaining
--
-- Notes:
--  * This method will disable all of the hotkeys defined in the modal state, and enable the hotkey for entering the modal state (if one was defined)
---@return hs.hotkey.modal
function M:exit() end

-- Optional callback for when a modal is exited
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a preexisting function that you should override if you need to use it; the default implementation does nothing.
function M:exited() end

-- Creates a new modal state, optionally with a global keyboard combination to trigger it
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--  * message - A string containing a message to be displayed via `hs.alert()` when the hotkey has been triggered, or nil for no alert
--
-- Returns:
--  * A new `hs.hotkey.modal` object
--
-- Notes:
--  * If `key` is nil, no global hotkey will be registered (all other parameters will be ignored)
---@return hs.hotkey.modal
function M.new(mods, key, message, ...) end

