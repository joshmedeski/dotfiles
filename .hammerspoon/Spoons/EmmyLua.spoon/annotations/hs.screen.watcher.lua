--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for screen layout changes
-- This could be the addition or removal of a monitor, a screen resolution change, movement of a monitor in the Display preferences pane, etc.
--
-- Note that screen events which happen while your Mac is suspended, may not trigger the watcher in various circumstances (e.g. if you have FileVault enabled and the machine resumes out of hibernation - the screen events will be happening before the drive is unlocked and will not be reported to Hammerspoon)
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.screen.watcher
local M = {}
hs.screen.watcher = M

-- Creates a new screen-watcher.
--
-- Parameters:
--  * The function to be called when a change in the screen layout occurs.  This function should take no arguments.
--
-- Returns:
--  * An `hs.screen.watcher` object
--
-- Notes:
--  * A screen layout change usually involves a change that is made from the Displays Preferences Panel or when a monitor is attached or removed. It can also be caused by a change in the Dock size or presence.
---@return hs.screen.watcher
function M.new(fn) end

-- Creates a new screen-watcher that is also called when the active screen changes.
--
-- Parameters:
--  * The function to be called when a change in the screen layout or active screen occurs.  This function can optionally take one argument, a boolean which will indicate if the change was due to a screen layout change (nil) or because the active screen changed (true).
--
-- Returns:
--  * An `hs.screen.watcher` object
--
-- Notes:
--  * A screen layout change usually involves a change that is made from the Displays Preferences Panel or when a monitor is attached or removed. It can also be caused by a change in the Dock size or presence.
--    * `nil` was chosen instead of `false` for the argument type when this type of change occurs to more closely match the previous behavior of having no argument passed to the callback function.
--  * An active screen change indicates that the focused or main screen has changed when the user has "Displays have separate spaces" checked in the Mission Control Preferences Panel (the focused display is the display which has the active window and active menubar).
--    * Detecting a change in the active display relies on watching for the `NSWorkspaceActiveDisplayDidChangeNotification` message which is not documented by Apple.  While this message has been around at least since OS X 10.9, because it is undocumented, we cannot be positive that Apple won't remove it in a future OS X update.  Because this watcher works by listening for posted messages, should Apple remove this notification, your callback function will no longer receive messages about this change -- it won't crash or change behavior in any other way.  This documentation will be updated if this status changes.
--  * Plugging in or unplugging a monitor can cause both a screen layout callback and an active screen change callback.
---@return hs.screen.watcher
function M.newWithActiveScreen(fn) end

-- Starts the screen watcher, making it so fn is called each time the screen arrangement changes
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.screen.watcher` object
---@return hs.screen.watcher
function M:start() end

-- Stops the screen watcher's fn from getting called until started again
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.screen.watcher` object
---@return hs.screen.watcher
function M:stop() end

