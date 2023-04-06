--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Tap into input events (mouse, keyboard, trackpad) for observation and possibly overriding them
-- It also provides convenience wrappers for sending mouse and keyboard events. If you need to construct finely controlled mouse/keyboard events, see hs.eventtap.event
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.eventtap
local M = {}
hs.eventtap = M

-- Returns a table containing the current key modifiers being pressed or in effect *at this instant* for the keyboard most recently used.
--
-- Parameters:
--  * raw - an optional boolean value which, if true, includes the _raw key containing the numeric representation of all of the keyboard/modifier flags.
--
-- Returns:
--  * Returns a table containing boolean values indicating which keyboard modifiers were held down when the function was invoked; The possible keys are:
--     * cmd (or ⌘)
--     * alt (or ⌥)
--     * shift (or ⇧)
--     * ctrl (or ⌃)
--     * capslock
--     * fn
--   and optionally
--     * _raw - a numeric representation of the numeric representation of all of the keyboard/modifier flags.
--
-- Notes:
--  * This is an instantaneous poll of the current keyboard modifiers for the most recently used keyboard, not a callback.  This is useful primarily in conjunction with other modules, such as `hs.menubar`, when a callback is already in progress or waiting for an event callback is not practical or possible.
--  * the numeric value returned is useful if you need to detect device dependent flags or flags which we normally ignore because they are not present (or are accessible another way) on most keyboards.
function M.checkKeyboardModifiers(raw, ...) end

-- Returns a table containing the current mouse buttons being pressed *at this instant*.
--
-- Parameters:
--  * None
--
-- Returns:
--  * Returns an array containing indices starting from 1 up to the highest numbered button currently being pressed where the index is `true` if the button is currently pressed or `false` if it is not.
--  * Special hash tag synonyms for `left` (button 1), `right` (button 2), and `middle` (button 3) are also set to true if these buttons are currently being pressed.
--
-- Notes:
--  * This is an instantaneous poll of the current mouse buttons, not a callback.  This is useful primarily in conjunction with other modules, such as `hs.menubar`, when a callback is already in progress or waiting for an event callback is not practical or possible.
function M.checkMouseButtons() end

-- Returns the system-wide setting for the delay between two clicks, to register a double click event
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the maximum number of seconds between two mouse click events, for a double click event to be registered
---@return number
function M.doubleClickInterval() end

-- Determine whether or not an event tap object is enabled.
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the event tap is enabled or false if it is not.
---@return boolean
function M:isEnabled() end

-- Checks if macOS is preventing keyboard events from being sent to event taps
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if secure input is enabled, otherwise false
--
-- Notes:
--  * If secure input is enabled, Hammerspoon is not able to intercept keyboard events
--  * Secure input is enabled generally only in situations where an password field is focused in a web browser, system dialog or terminal
---@return boolean
function M.isSecureInputEnabled() end

-- Returns the system-wide setting for the delay before keyboard repeat events begin
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the number of seconds before repeat events begin, after a key is held down
---@return number
function M.keyRepeatDelay() end

-- Returns the system-wide setting for the interval between repeated keyboard events
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the number of seconds between keyboard events, if a key is held down
---@return number
function M.keyRepeatInterval() end

-- Generates and emits a single keystroke event pair for the supplied keyboard modifiers and character
--
-- Parameters:
--  * modifiers - A table containing the keyboard modifiers to apply ("fn", "ctrl", "alt", "cmd", "shift", or their Unicode equivalents)
--  * character - A string containing a character to be emitted
--  * delay - An optional delay (in microseconds) between key down and up event. Defaults to 200000 (i.e. 200ms)
--  * application - An optional hs.application object to send the keystroke to
--
-- Returns:
--  * None
--
-- Notes:
--  * This function is ideal for sending single keystrokes with a modifier applied (e.g. sending ⌘-v to paste, with `hs.eventtap.keyStroke({"cmd"}, "v")`). If you want to emit multiple keystrokes for typing strings of text, see `hs.eventtap.keyStrokes()`
--  * Note that invoking this function with a table (empty or otherwise) for the `modifiers` argument will force the release of any modifier keys which have been explicitly created by [hs.eventtap.event.newKeyEvent](#newKeyEvent) and posted that are still in the "down" state. An explicit `nil` for this argument will not (i.e. the keystroke will inherit any currently "down" modifiers)
function M.keyStroke(modifiers, character, delay, application, ...) end

-- Generates and emits keystroke events for the supplied text
--
-- Parameters:
--  * text - A string containing the text to be typed
--  * application - An optional hs.application object to send the keystrokes to
--
-- Returns:
--  * None
--
-- Notes:
--  * If you want to send a single keystroke with keyboard modifiers (e.g. sending ⌘-v to paste), see `hs.eventtap.keyStroke()`
function M.keyStrokes(text, application, ...) end

-- Generates a left mouse click event at the specified point
--
-- Parameters:
--  * point - A table with keys `{x, y}` indicating the location where the mouse event should occur
--  * delay - An optional delay (in microseconds) between mouse down and up event. Defaults to 200000 (i.e. 200ms)
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a wrapper around `hs.eventtap.event.newMouseEvent` that sends `leftmousedown` and `leftmouseup` events)
function M.leftClick(point, delay, ...) end

-- Generates a middle mouse click event at the specified point
--
-- Parameters:
--  * point  - A table with keys `{x, y}` indicating the location where the mouse event should occur
--  * delay  - An optional delay (in microseconds) between mouse down and up event. Defaults to 200000 (i.e. 200ms)
--
-- Returns:
--  * None
--
-- Notes:
--  * This function is just a wrapper which calls `hs.eventtap.otherClick(point, delay, 2)` and is included solely for backwards compatibility.
function M.middleClick(point, delay, ...) end

-- Create a new event tap object
--
-- Parameters:
--  * types - A table that should contain values from `hs.eventtap.event.types`
--  * fn - A function that will be called when the specified event types occur. The function should take a single parameter, which will be an event object. It can optionally return two values. Firstly, a boolean, true if the event should be deleted, false if it should propagate to any other applications watching for that event. Secondly, a table of events to post.
--
-- Returns:
--  * An event tap object
--
-- Notes:
--  * If you specify the argument `types` as the special table {"all"[, events to ignore]}, then *all* events (except those you optionally list *after* the "all" string) will trigger a callback, even events which are not defined in the [Quartz Event Reference](https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html).
---@return hs.eventtap
function M.new(types, fn, ...) end

-- Generates an "other" mouse click event at the specified point
--
-- Parameters:
--  * point  - A table with keys `{x, y}` indicating the location where the mouse event should occur
--  * delay  - An optional delay (in microseconds) between mouse down and up event. Defaults to 200000 (i.e. 200ms)
--  * button - An optional integer, default 2, between 2 and 31 specifying the button number to be pressed.  If this parameter is specified then `delay` must also be specified, though you may specify it as `nil` to use the default.
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a wrapper around `hs.eventtap.event.newMouseEvent` that sends `otherMouseDown` and `otherMouseUp` events)
--  * macOS recognizes up to 32 distinct mouse buttons, though few mouse devices have more than 3.  The left mouse button corresponds to button number 0 and the right mouse button corresponds to 1;  distinct events are used for these mouse buttons, so you should use `hs.eventtap.leftClick` and `hs.eventtap.rightClick` respectively.  All other mouse buttons are coalesced into the `otherMouse` events and are distinguished by specifying the specific button with the `mouseEventButtonNumber` property, which this function does for you.
--  * The specific purpose of mouse buttons greater than 2 varies by hardware and application (typically they are not present on a mouse and have no effect in an application)
function M.otherClick(point, delay, button, ...) end

-- Generates a right mouse click event at the specified point
--
-- Parameters:
--  * point - A table with keys `{x, y}` indicating the location where the mouse event should occur
--  * delay - An optional delay (in microseconds) between mouse down and up event. Defaults to 200000 (i.e. 200ms)
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a wrapper around `hs.eventtap.event.newMouseEvent` that sends `rightmousedown` and `rightmouseup` events)
function M.rightClick(point, delay, ...) end

-- Generates and emits a scroll wheel event
--
-- Parameters:
--  * offsets - A table containing the {horizontal, vertical} amount to scroll. Positive values scroll up or left, negative values scroll down or right.
--  * mods - A table containing zero or more of the following:
--   * cmd
--   * alt
--   * shift
--   * ctrl
--   * fn
--  * unit - An optional string containing the name of the unit for scrolling. Either "line" (the default) or "pixel"
--
-- Returns:
--  * None
---@return hs.eventtap
function M.scrollWheel(offsets, modifiers, unit, ...) end

-- Starts an event tap
--
-- Parameters:
--  * None
--
-- Returns:
--  * The event tap object
function M:start() end

-- Stops an event tap
--
-- Parameters:
--  * None
--
-- Returns:
--  * The event tap object
function M:stop() end

