--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Some functions for manipulating the Hammerspoon console.
--
-- These functions allow altering the behavior and display of the Hammerspoon console.  They should be considered experimental, but have worked well for me.
---@class hs.console
local M = {}
hs.console = M

-- Get or set the alpha level of the console window.
--
-- Parameters:
--  * `alpha` - an optional number between 0.0 and 1.0 specifying the new alpha level for the Hammerspoon console.
--
-- Returns:
--  * the current, possibly new, value.
function M.alpha(alpha, ...) end

-- Because use of this function can easily lead to a crash, useful methods from `hs.drawing` have been added to the `hs.console` module itself.  If you believe that a useful method has been overlooked, please submit an issue.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a placeholder object
---@return hs.drawing
function M.asHSDrawing() end

-- Returns an hs.window object for the console so that you can use hs.window methods on it.
--
-- This function is identical to [hs.console.hswindow](#hswindow).  It is included for reasons of backwards compatibility, but use of the new name is recommended for clarity.
---@return hs.window
function M.asHSWindow() end

-- Get or set the window behavior settings for the console.
--
-- Parameters:
--  * `behavior` - an optional number representing the desired window behaviors for the Hammerspoon console.
--
-- Returns:
--  * the current, possibly new, value.
--
-- Notes:
--  * Window behaviors determine how the webview object is handled by Spaces and Exposé. See `hs.drawing.windowBehaviors` for more information.
function M.behavior(behavior, ...) end

-- Get or set the window behavior settings for the console using labels defined in `hs.drawing.windowBehaviors`.
--
-- Parameters:
--  * behaviorTable - an optional table of strings and/or numbers specifying the desired window behavior for the Hammerspoon console.
--
-- Returns:
--  * the current (possibly new) value.
--
-- Notes:
--  * Window behaviors determine how the console is handled by Spaces and Exposé. See `hs.drawing.windowBehaviors` for more information.
function M.behaviorAsLabels(behaviorTable, ...) end

-- Clear the Hammerspoon console output window.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is equivalent to `hs.console.setConsole()`
function M.clearConsole() end

-- Get or set the color that commands displayed in the Hammerspoon console are displayed with.
--
-- Parameters:
--  * color - an optional table containing color keys as described in `hs.drawing.color`
--
-- Returns:
--  * the current color setting as a table
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
--  * Note this only affects future output -- anything already in the console will remain its current color.
function M.consoleCommandColor(color, ...) end

-- Get or set the font used in the Hammerspoon console.
--
-- Parameters:
--  * font - an optional string or table describing the font to use in the console. If a string is specified, then the default system font size will be used.  If a table is specified, it should contain a `name` key-value pair and a `size` key-value pair describing the font to be used.
--
-- Returns:
--  * the current font setting as a table containing a `name` key and a `size` key.
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
--  * Note this only affects future output -- anything already in the console will remain its current font.
function M.consoleFont(font, ...) end

-- Get or set the color that regular output displayed in the Hammerspoon console is displayed with.
--
-- Parameters:
--  * color - an optional table containing color keys as described in `hs.drawing.color`
--
-- Returns:
--  * the current color setting as a table
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
--  * Note this only affects future output -- anything already in the console will remain its current color.
function M.consolePrintColor(color, ...) end

-- Get or set the color that function results displayed in the Hammerspoon console are displayed with.
--
-- Parameters:
--  * color - an optional table containing color keys as described in `hs.drawing.color`
--
-- Returns:
--  * the current color setting as a table
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
--  * Note this only affects future output -- anything already in the console will remain its current color.
function M.consoleResultColor(color, ...) end

-- Set or display whether or not the Console window should display in dark mode.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not the Console window should display in dark mode.
--
-- Returns:
--  * A boolean, true if dark mode is enabled otherwise false.
--
-- Notes:
--  * Enabling Dark Mode for the Console only affects the window background, and doesn't automatically change the Console's Background Color, so you will need to add something similar to:
--    ```lua
--    if hs.console.darkMode() then
--        hs.console.outputBackgroundColor{ white = 0 }
--        hs.console.consoleCommandColor{ white = 1 }
--        hs.console.alpha(.8)
--    end
-- .   ```
---@return boolean
function M.darkMode(state, ...) end

-- Default toolbar for the Console window
--
-- Notes:
--  * This is an `hs.toolbar` object that is shown by default in the Hammerspoon Console
--  * You can remove this toolbar by adding `hs.console.toolbar(nil)` to your config, or you can replace it with your own `hs.webview.toolbar` object
M.defaultToolbar = nil

-- Get the text of the Hammerspoon console output window.
--
-- Parameters:
--  * styled - an optional boolean indicating whether the console text is returned as a string or a styledText object.  Defaults to false.
--
-- Returns:
--  * The text currently in the Hammerspoon console output window as either a string or an `hs.styledtext` object.
--
-- Notes:
--  * If the text of the console is retrieved as a string, no color or style information in the console output is retrieved - only the raw text.
function M.getConsole(styled, ...) end

-- Get the Hammerspoon console command history as an array.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an array containing the history of commands entered into the Hammerspoon console.
function M.getHistory() end

-- Get an hs.window object which represents the Hammerspoon console window
--
-- Parameters:
--  * None
--
-- Returns:
--  * an hs.window object
---@return hs.window
function M.hswindow() end

-- Get or set the color for the background of the Hammerspoon Console's input field.
--
-- Parameters:
--  * color - an optional table containing color keys as described in `hs.drawing.color`
--
-- Returns:
--  * the current color setting as a table
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
function M.inputBackgroundColor(color, ...) end

-- Get or set the console window level
--
-- Parameters:
--  * `theLevel` - an optional parameter specifying the desired level as an integer, which can be obtained from `hs.drawing.windowLevels`.
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * see the notes for `hs.drawing.windowLevels`
function M.level(theLevel, ...) end

-- Get or set the max length of the Hammerspoon console's scrollback history.
--
-- Parameters:
--  * length - an optional number containing the maximum size in bytes of the Hammerspoon console history.
--
-- Returns:
--  * the current maximum size of the console history
--
-- Notes:
--  * A length value of zero will allow the history to grow infinitely
--  * The default console history is 100,000 characters
---@return number
function M.maxOutputHistory(length, ...) end

-- Get or set the color for the background of the Hammerspoon Console's output view.
--
-- Parameters:
--  * color - an optional table containing color keys as described in `hs.drawing.color`
--
-- Returns:
--  * the current color setting as a table
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
function M.outputBackgroundColor(color, ...) end

-- A print function which recognizes `hs.styledtext` objects and renders them as such in the Hammerspoon console.
--
-- Parameters:
--  * Any number of arguments can be specified, just like the builtin Lua `print` command.  If an argument matches the userdata type of `hs.styledtext`, the text is rendered as defined by its style attributes in the Hammerspoon console; otherwise it is rendered as it would be via the traditional `print` command within Hammerspoon.
--
-- Returns:
--  * None
--
-- Notes:
--  * This has been made as close to the Lua `print` command as possible.  You can replace the existing print command with this by adding the following to your `init.lua` file:
--
-- ~~~
--    print = function(...)
--        hs.rawprint(...)
--        hs.console.printStyledtext(...)
--    end
-- ~~~
function M.printStyledtext(...) end

-- Clear the Hammerspoon console output window.
--
-- Parameters:
--  * styledText - an optional `hs.styledtext` object containing the text you wish to replace the Hammerspoon console output with.  If you do not provide an argument, the console is cleared of all content.
--
-- Returns:
--  * None
--
-- Notes:
--  * You can specify the console content as a string or as an `hs.styledtext` object in either userdata or table format.
function M.setConsole(styledText, ...) end

-- Set the Hammerspoon console command history to the items specified in the given array.
--
-- Parameters:
--  * array - the list of commands to set the Hammerspoon console history to.
--
-- Returns:
--  * None
--
-- Notes:
--  * You can clear the console history by using an empty array (e.g. `hs.console.setHistory({})`
function M.setHistory(array, ...) end

-- Determine whether or not objects copied from the console window insert or delete space around selected words to preserve proper spacing and punctuation.
--
-- Parameters:
--  * flag - an optional boolean value indicating whether or not "smart" space behavior is enabled when copying from the Hammerspoon console.
--
-- Returns:
--  * the current value
--
-- Notes:
--  * this only applies to future copy operations from the Hammerspoon console -- anything already in the clipboard is not affected.
---@return boolean
function M.smartInsertDeleteEnabled(flag, ...) end

-- Get or set whether or not the "Hammerspoon Console" text appears in the Hammerspoon console titlebar.
--
-- Parameters:
--  * state - an optional string containing the text "visible" or "hidden", specifying whether or not the console window's title text appears.
--
-- Returns:
--  * a string of "visible" or "hidden" specifying the current (possibly changed) state of the window title's visibility.
--
-- Notes:
--  * When a toolbar is attached to the Hammerspoon console (see the `hs.webview.toolbar` module documentation), this function can be used to specify whether the Toolbar appears underneath the console window's title ("visible") or in the window's title bar itself, as seen in applications like Safari ("hidden"). When the title is hidden, the toolbar will only display the toolbar items as icons without labels, and ignores changes made with `hs.webview.toolbar:displayMode`.
--
--  * If a toolbar is attached to the console, you can achieve the same effect as this function with `hs.console.toolbar():inTitleBar(boolean)`
function M.titleVisibility(state, ...) end

-- Get or attach/detach a toolbar to/from the Hammerspoon console.
--
-- Parameters:
--  * `toolbar` - if an `hs.webview.toolbar` object is specified, it will be attached to the Hammerspoon console.  If an explicit nil is specified, the current toolbar will be removed from the console.
--
-- Returns:
--  * if a toolbarObject or explicit nil is specified, returns the toolbarObject; otherwise returns the current toolbarObject or nil, if no toolbar is attached to the console.
--
-- Notes:
--  * this method is a convenience wrapper for the `hs.webview.toolbar.attachToolbar` function.
--
--  * If the toolbar is currently attached to another window when this function is called, it will be detached from the original window and attached to the console.
function M.toolbar(toolbar, ...) end

-- Get or set the color for the background of the Hammerspoon Console's window.
--
-- Parameters:
--  * color - an optional table containing color keys as described in `hs.drawing.color`
--
-- Returns:
--  * the current color setting as a table
--
-- Notes:
--  * See the `hs.drawing.color` entry in the Dash documentation, or type `help.hs.drawing.color` in the Hammerspoon console to get more information on how to specify a color.
function M.windowBackgroundColor(color, ...) end

