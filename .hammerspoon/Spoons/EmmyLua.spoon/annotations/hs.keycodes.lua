--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Convert between key-strings and key-codes. Also provides functionality for querying and changing keyboard layouts.
---@class hs.keycodes
local M = {}
hs.keycodes = M

-- Gets the name of the current keyboard layout
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the current keyboard layout
---@return string
function M.currentLayout() end

-- Gets the icon of the current keyboard layout
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.image object containing the icon, if available
---@return hs.image
function M.currentLayoutIcon() end

-- Get current input method
--
-- Parameters:
--  * None
--
-- Returns:
--  * Name of current input method, or nil
---@return string
function M.currentMethod() end

-- Get or set the source id for the keyboard input source
--
-- Parameters:
--  * sourceID - an optional string specifying the input source to set for keyboard input
--
-- Returns:
--  * If no parameter is provided, returns a string containing the source id for the current keyboard layout or input method; if a parameter is provided, returns true or false specifying whether or not the input source was able to be changed.
function M.currentSourceID(sourceID, ...) end

-- Gets an hs.image object for a given keyboard layout or input method
--
-- Parameters:
--  * sourceName - A string containing the name of an input method or keyboard layout
--
-- Returns:
--  * An hs.image object, or nil if no image could be found
--
-- Notes:
--  * Not all layouts/methods have icons, so you should assume this will return nil at some point
---@return hs.image
function M.iconForLayoutOrMethod(sourceName, ...) end

-- Sets the function to be called when your input source (i.e. qwerty, dvorak, colemac) changes.
--
-- Parameters:
--  * fn - A function that will be called when the input source changes. No arguments are supplied to the function.
--
-- Returns:
--  * None
--
-- Notes:
--  * This may be helpful for rebinding your hotkeys to appropriate keys in the new layout
--  * Setting this will un-set functions previously registered by this function.
function M.inputSourceChanged(fn) end

-- Gets all of the enabled keyboard layouts that the keyboard input source can be switched to
--
-- Parameters:
--  * sourceID - an optional boolean, default false, indicating whether the keyboard layout names should be returned (false) or their source IDs (true).
--
-- Returns:
--  * A table containing a list of keyboard layouts enabled in System Preferences
--
-- Notes:
--  * Only those layouts which can be explicitly switched to will be included in the table.  Keyboard layouts which are part of input methods are not included.  See `hs.keycodes.methods`.
function M.layouts(sourceID, ...) end

-- A mapping from string representation of a key to its keycode, and vice versa.
--
-- Notes:
--  * For example: keycodes[1] == "s", and keycodes["s"] == 1, and so on.
--  * This is primarily used by the hs.eventtap and hs.hotkey extensions.
--  * Valid strings are any single-character string, or any of the following strings:
--   * f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15,
--   * f16, f17, f18, f19, f20, pad., pad*, pad+, pad/, pad-, pad=,
--   * pad0, pad1, pad2, pad3, pad4, pad5, pad6, pad7, pad8, pad9,
--   * padclear, padenter, return, tab, space, delete, escape, help,
--   * home, pageup, forwarddelete, end, pagedown, left, right, down, up,
--   * shift, rightshift, cmd, rightcmd, alt, rightalt, ctrl, rightctrl,
--   * capslock, fn
M.map = nil

-- Gets all of the enabled input methods that the keyboard input source can be switched to
--
-- Parameters:
--  * sourceID - an optional boolean, default false, indicating whether the keyboard input method names should be returned (false) or their source IDs (true).
--
-- Returns:
--  * A table containing a list of input methods enabled in System Preferences
--
-- Notes:
--  * Keyboard layouts which are not part of an input method are not included in this table.  See `hs.keycodes.layouts`.
function M.methods(sourceID, ...) end

-- Changes the system keyboard layout
--
-- Parameters:
--  * layoutName - A string containing the name of an enabled keyboard layout
--
-- Returns:
--  * A boolean, true if the layout was successfully changed, otherwise false
---@return boolean
function M.setLayout(layoutName, ...) end

-- Changes the system input method
--
-- Parameters:
--  * methodName - A string containing the name of an enabled input method
--
-- Returns:
--  * A boolean, true if the method was successfully changed, otherwise false
---@return boolean
function M.setMethod(methodName, ...) end

