--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Create and manage global keyboard shortcuts
---@class hs.hotkey
local M = {}
hs.hotkey = M

-- Duration of the alert shown when a hotkey created with a `message` parameter is triggered, in seconds. Default is 1.
--
-- Usage:
-- hs.hotkey.alertDuration = 2.5 -- alert stays on screen a bit longer
-- hs.hotkey.alertDuration = 0 -- hotkey alerts are disabled
M.alertDuration = nil

-- Determines whether the hotkey combination can be assigned a callback through Hammerspoon.
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--
-- Returns:
--  * a boolean value, true if the hotkey combination can be given an assignment by Hammerspoon or false if it cannot.
--
-- Notes:
--  * The most common reason a hotkey combination cannot be given an assignment by Hammerspoon is because it is in use by the Mac operating system -- see the Shortcuts tab of Keyboard in the System Preferences application or [hs.hotkey.systemAssigned](#systemAssigned).
---@return boolean
function M.assignable(mods, key, ...) end

-- Creates a new hotkey and enables it immediately
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--  * message - (optional) A string containing a message to be displayed via `hs.alert()` when the hotkey has been
--    triggered; if omitted, no alert will be shown
--  * pressedfn - A function that will be called when the hotkey has been pressed, or nil
--  * releasedfn - A function that will be called when the hotkey has been released, or nil
--  * repeatfn - A function that will be called when a pressed hotkey is repeating, or nil
--
-- Returns:
--  * A new `hs.hotkey` object or nil if the hotkey could not be enabled
--
-- Notes:
--  * This function is just a wrapper that performs `hs.hotkey.new(...):enable()`
--  * You can create multiple `hs.hotkey` objects for the same keyboard combination, but only one can be active
--    at any given time - see `hs.hotkey:enable()`
--  * If `message` is the empty string `""`, the alert will just show the triggered keyboard combination
--  * If you don't want any alert, you must *actually* omit the `message` parameter; a `nil` in 3rd position
--    will be interpreted as a missing `pressedfn`
--  * You must pass at least one of `pressedfn`, `releasedfn` or `repeatfn`; to delete a hotkey, use `hs.hotkey:delete()`
---@return hs.hotkey
function M.bind(mods, key, message, pressedfn, releasedfn, repeatfn, ...) end

-- Creates a hotkey and enables it immediately
--
-- Parameters:
--  * keyspec - A table containing two items:
--   * first, a table containing keyboard modifiers, as specified in `hs.hotkey.bind()`
--   * second, a string containing the name of a keyboard key, as specified in `hs.hotkey.bind()`
--  * ... - All remaining arguments are as specified in `hs.hotkey.bind()`
--
-- Returns:
--  * A new `hs.hotkey` object for method chaining
--
-- Notes:
--  * This function is just a wrapper that performs `hs.hotkey.bind(keyspec[1], keyspec[2], ...)`
---@return hs.hotkey
function M.bindSpec(keyspec, ...) end

-- Disables and deletes a hotkey object
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:delete() end

-- Deletes all previously set callbacks for a given keyboard combination
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--
-- Returns:
--  * None
function M.deleteAll(mods, key, ...) end

-- Disables a hotkey object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.hotkey` object for method chaining
---@return hs.hotkey
function M:disable() end

-- Disables all previously set callbacks for a given keyboard combination
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--
-- Returns:
--  * None
function M.disableAll(mods, key, ...) end

-- Enables a hotkey object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.hotkey` object for method chaining or nil if the hotkey could not be enabled for some reason.
--
-- Notes:
--  * When you enable a hotkey that uses the same keyboard combination as another previously-enabled hotkey, the old
--    one will stop working as it's being "shadowed" by the new one. As soon as the new hotkey is disabled or deleted
--    the old one will trigger again.
---@return hs.hotkey
function M:enable() end

-- Returns a list of all currently active hotkeys
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the hotkeys that are active, i.e. enabled and not "shadowed", in the current context
--    (usually, the global hotkey context, but it could be a modal hotkey context). Every element in the list
--    is a table with two fields:
--    * idx - a string describing the keyboard combination for the hotkey
--    * msg - the hotkey message, if provided when the hotkey was created (prefixed with the keyboard combination)
function M.getHotkeys() end

-- Creates a new hotkey
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--  * message - (optional) A string containing a message to be displayed via `hs.alert()` when the hotkey has been
--    triggered; if omitted, no alert will be shown
--  * pressedfn - A function that will be called when the hotkey has been pressed, or nil
--  * releasedfn - A function that will be called when the hotkey has been released, or nil
--  * repeatfn - A function that will be called when a pressed hotkey is repeating, or nil
--
-- Returns:
--  * A new `hs.hotkey` object or nil if the hotkey could not be enabled
--
-- Notes:
--  * You can create multiple `hs.hotkey` objects for the same keyboard combination, but only one can be active
--    at any given time - see `hs.hotkey:enable()`
--  * If `message` is the empty string `""`, the alert will just show the triggered keyboard combination
--  * If you don't want any alert, you must *actually* omit the `message` parameter; a `nil` in 3rd position
--    will be interpreted as a missing `pressedfn`
--  * You must pass at least one of `pressedfn`, `releasedfn` or `repeatfn`; to delete a hotkey, use `hs.hotkey:delete()`
---@return hs.hotkey
function M.new(mods, key, message, pressedfn, releasedfn, repeatfn, ...) end

-- Creates (and enables) a hotkey that shows all currently active hotkeys (i.e. enabled and not "shadowed" in the current context) while pressed
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--
-- Returns:
--  * The new `hs.hotkey` object
---@return hs.hotkey
function M.showHotkeys(mods, key, ...) end

-- Examine whether a potential hotkey is in use by the macOS system such as the Screen Capture, Universal Access, and Keyboard Navigation keys.
--
-- Parameters:
--  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
--    which should be zero or more of the following:
--    * "cmd", "command" or "⌘"
--    * "ctrl", "control" or "⌃"
--    * "alt", "option" or "⌥"
--    * "shift" or "⇧"
--  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
--
-- Returns:
--  * if the hotkey combination is in use by a system function, returns a table containing the following keys:
--    * keycode - the numeric keycode for the hotkey
--    * mods    - a numeric representation of the modifier flags for the hotkey
--    * enabled - a boolean indicating whether or not the key is currently enabled
--  * if the hotkey combination is not in use by the operating system, returns the boolean value `false`
--
-- Notes:
--  * this is provided for informational purposes and does not provide a reliable test as to whether or not Hammerspoon can use the combination to create a custom hotkey -- some combinations which return a table can be over-ridden by Hammerspoon while others cannot.  See also [hs.hotkey.assignable](#assignable).
function M.systemAssigned(mods, key, ...) end

