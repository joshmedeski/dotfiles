--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Graphical, interactive tool for choosing/searching data
--
-- Notes:
--  * This module was influenced heavily by Choose, by Steven Degutis (https://github.com/sdegutis/choose)
---@class hs.chooser
local M = {}
hs.chooser = M

-- Get or attach/detach a toolbar to/from the chooser.
--
-- Parameters:
--  * `toolbar` - An `hs.webview.toolbar` object to be attached to the chooser. If `nil` is supplied, the current toolbar will be removed
--
-- Returns:
--  * if a toolbarObject or explicit nil is specified, returns the hs.chooser object; otherwise returns the current toolbarObject or nil, if no toolbar is attached to the chooser.
--
-- Notes:
--  * this method is a convenience wrapper for the `hs.webview.toolbar.attachToolbar` function.
--
--  * If the toolbarObject is currently attached to another window when this method is called, it will be detached from the original window and attached to the chooser.  If you wish to attach the same toolbar to multiple chooser objects, see `hs.webview.toolbar:copy`.
---@return hs.chooser
function M:attachedToolbar(toolbar, ...) end

-- Sets the background of the chooser between light and dark
--
-- Parameters:
--  * beDark - A optional boolean, true to be dark, false to be light. If this parameter is omitted, the current setting will be returned
--
-- Returns:
--  * The `hs.chooser` object or a boolean, true if the window is dark, false if it is light
--
-- Notes:
--  * The text colors will not automatically change when you toggle the darkness of the chooser window, you should also set appropriate colors with `hs.chooser:fgColor()` and `hs.chooser:subTextColor()`
---@return hs.chooser
function M:bgDark(beDark, ...) end

-- Cancels the chooser
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.chooser` object
---@return hs.chooser
function M:cancel() end

-- Sets the choices for a chooser
--
-- Parameters:
--  * choices - Either a function to call when the list of choices is needed, or nil to remove any existing choices/callback, or a table containing static choices.
--
-- Returns:
--  * The `hs.chooser` object
--
-- Notes:
--  * The table of choices (be it provided statically, or returned by the callback) must contain at least the following keys for each choice:
--   * text - A string or hs.styledtext object that will be shown as the main text of the choice
--  * Each choice may also optionally contain the following keys:
--   * subText - A string or hs.styledtext object that will be shown underneath the main text of the choice
--   * image - An `hs.image` image object that will be displayed next to the choice
--   * valid - A boolean that defaults to `true`, if set to `false` selecting the choice will invoke the `invalidCallback` method instead of dismissing the chooser
--  * Any other keys/values in each choice table will be retained by the chooser and returned to the completion callback when a choice is made. This is useful for storing UUIDs or other non-user-facing information, however, it is important to note that you should not store userdata objects in the table - it is run through internal conversion functions, so only basic Lua types should be stored.
--  * If a function is given, it will be called once, when the chooser window is displayed. The results are then cached until this method is called again, or `hs.chooser:refreshChoicesCallback()` is called.
--  * If you're using a hs.styledtext object for text or subText choices, make sure you specify a color, otherwise your text could appear transparent depending on the bgDark setting.
--
-- Example:
--  ```lua
-- local choices = {
--  {
--   ["text"] = "First Choice",
--   ["subText"] = "This is the subtext of the first choice",
--   ["uuid"] = "0001"
--  },
--  { ["text"] = "Second Option",
--    ["subText"] = "I wonder what I should type here?",
--    ["uuid"] = "Bbbb"
--  },
--  { ["text"] = hs.styledtext.new("Third Possibility", {font={size=18}, color=hs.drawing.color.definedCollections.hammerspoon.green}),
--    ["subText"] = "What a lot of choosing there is going on here!",
--    ["uuid"] = "III3"
--  },
-- }```
---@return hs.chooser
function M:choices(choices, ...) end

-- Deletes a chooser
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:delete() end

-- Gets/Sets whether the chooser should run the callback on a query when it does not match any on the list
--
-- Parameters:
--  * enableDefaultForQuery - An optional boolean, true to return query string, false to not. If this parameter is omitted, the current configuration value will be returned
--
-- Returns:
--  * the `hs.chooser` object if a value was set, or a boolean if no parameter was passed
--
-- Notes:
--  * This should be used before a chooser has been displayed
---@return hs.chooser
function M:enableDefaultForQuery() end

-- Sets the foreground color of the chooser
--
-- Parameters:
--  * color - An optional table containing a color specification (see `hs.drawing.color`), or nil to restore the default color. If this parameter is omitted, the existing color will be returned
--
-- Returns:
--  * The `hs.chooser` object or a color table
---@return hs.chooser
function M:fgColor(color, ...) end

-- A global callback function used for various hs.chooser events
--
-- Notes:
--  * This callback should accept two parameters:
--   * An `hs.chooser` object
--   * A string containing the name of the event to handle. Possible values are:
--    * `willOpen` - An hs.chooser is about to be shown on screen
--    * `didClose` - An hs.chooser has just been removed from the screen
--  * There is a default global callback that uses the `willOpen` event to remember which window has focus, and the `didClose` event to restore focus back to the original window. If you want to use this in addition to your own callback, you can call it as `hs.chooser._defaultGlobalCallback(event)`
M.globalCallback = nil

-- Hides the chooser
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.chooser` object
---@return hs.chooser
function M:hide() end

-- Sets/clears a callback for when the chooser window is hidden
--
-- Parameters:
--  * fn - An optional function that will be called when the chooser window is hidden. If this parameter is omitted, the existing callback will be removed.
--
-- Returns:
--  * The hs.chooser object
--
-- Notes:
--  * This callback is called *after* the chooser is hidden.
--  * This callback is called *after* hs.chooser.globalCallback.
---@return hs.chooser
function M:hideCallback(fn) end

-- Sets/clears a callback for invalid choices
--
-- Parameters:
--  * fn - An optional function that will be called whenever the user select an choice set as invalid. If this parameter is omitted, the existing callback will be removed.
--
-- Returns:
--  * The `hs.chooser` object
--
-- Notes:
--   * The callback may accept one argument, it will be a table containing whatever information you supplied for the item the user chose.
--   * To display a context menu, see `hs.menubar`, specifically the `:popupMenu()` method
---@return hs.chooser
function M:invalidCallback(fn) end

-- Checks if the chooser is currently displayed
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the chooser is displayed on screen, false if not
---@return boolean
function M:isVisible() end

-- Creates a new chooser object
--
-- Parameters:
--  * completionFn - A function that will be called when the chooser is dismissed. It should accept one parameter, which will be nil if the user dismissed the chooser window, otherwise it will be a table containing whatever information you supplied for the item the user chose.
--
-- Returns:
--  * An `hs.chooser` object
--
-- Notes:
--  * As of macOS Sierra and later, if you want a `hs.chooser` object to appear above full-screen windows you must hide the Hammerspoon Dock icon first using: `hs.dockicon.hide()`
---@return hs.chooser
function M.new(completionFn, ...) end

-- Sets/gets placeholder text that is shown in the query text field when no other text is present
--
-- Parameters:
--  * placeholderText - An optional string for placeholder text. If this parameter is omitted, the existing placeholder text will be returned.
--
-- Returns:
--  * The hs.chooser object, or the existing placeholder text
---@return hs.chooser
function M:placeholderText(placeholderText, ...) end

-- Sets/gets the search string
--
-- Parameters:
--  * queryString - An optional string to search for, or an explicit nil to clear the query. If omitted, the current contents of the search box are returned
--
-- Returns:
--  * The `hs.chooser` object or a string
--
-- Notes:
--  * You can provide an explicit nil or empty string to clear the current query string.
---@return hs.chooser
function M:query(queryString, ...) end

-- Sets/clears a callback for when the search query changes
--
-- Parameters:
--  * fn - An optional function that will be called whenever the search query changes. If this parameter is omitted, the existing callback will be removed.
--
-- Returns:
--  * The hs.chooser object
--
-- Notes:
--  * As the user is typing, the callback function will be called for every keypress. You may wish to do filtering on each call, or you may wish to use a delayed `hs.timer` object to only react when they have finished typing.
--  * The callback function should accept a single argument:
--   * A string containing the new search query
---@return hs.chooser
function M:queryChangedCallback(fn) end

-- Refreshes the choices data from a callback
--
-- Parameters:
--  * reload - An optional parameter that reloads the chooser results to take into account the current query string (defaults to `false`)
--
-- Returns:
--  * The `hs.chooser` object
--
-- Notes:
--  * This method will do nothing if you have not set a function with `hs.chooser:choices()`
---@return hs.chooser
function M:refreshChoicesCallback(reload, ...) end

-- Sets/clears a callback for right clicking on choices
--
-- Parameters:
--  * fn - An optional function that will be called whenever the user right clicks on a choice. If this parameter is omitted, the existing callback will be removed.
--
-- Returns:
--  * The `hs.chooser` object
--
-- Notes:
--   * The callback may accept one argument, the row the right click occurred in or 0 if there is currently no selectable row where the right click occurred. To determine the location of the mouse pointer at the right click, see `hs.mouse`.
--   * To display a context menu, see `hs.menubar`, specifically the `:popupMenu()` method
---@return hs.chooser
function M:rightClickCallback(fn) end

-- Gets/Sets the number of rows that will be shown
--
-- Parameters:
--  * numRows - An optional number of choices to show (i.e. the vertical height of the chooser window). If this parameter is omitted, the current value will be returned
--
-- Returns:
--  * The `hs.chooser` object or a number
---@return hs.chooser
function M:rows(numRows, ...) end

-- Gets/Sets whether the chooser should search in the sub-text of each item
--
-- Parameters:
--  * searchSubText - An optional boolean, true to search sub-text, false to not search sub-text. If this parameter is omitted, the current configuration value will be returned
--
-- Returns:
--  * The `hs.chooser` object if a value was set, or a boolean if no parameter was passed
--
-- Notes:
--  * This should be used before a chooser has been displayed
---@return hs.chooser
function M:searchSubText(searchSubText, ...) end

-- Closes the chooser by selecting the specified row, or the currently selected row if not given
--
-- Parameters:
--  * `row` - an optional integer specifying the row to select.
--
-- Returns:
--  * The `hs.chooser` object
---@return hs.chooser
function M:select(row, ...) end

-- Get or set the currently selected row
--
-- Parameters:
--  * `row` - an optional integer specifying the row to select.
--
-- Returns:
--  * If an argument is provided, returns the hs.chooser object; otherwise returns a number containing the row currently selected (i.e. the one highlighted in the UI)
---@return number
function M:selectedRow(row, ...) end

-- Returns the contents of the currently selected or specified row
--
-- Parameters:
--  * `row` - an optional integer specifying the specific row to return the contents of
--
-- Returns:
--  * a table containing whatever information was supplied for the row currently selected or an empty table if no row is selected or the specified row does not exist.
function M:selectedRowContents(row, ...) end

-- Displays the chooser
--
-- Parameters:
--  * An optional `hs.geometry` point object describing the absolute screen co-ordinates for the top left point of the chooser window. Defaults to centering the window on the primary screen
--
-- Returns:
--  * The hs.chooser object
---@return hs.chooser
function M:show(topLeftPoint, ...) end

-- Sets/clears a callback for when the chooser window is shown
--
-- Parameters:
--  * fn - An optional function that will be called when the chooser window is shown. If this parameter is omitted, the existing callback will be removed.
--
-- Returns:
--  * The hs.chooser object
--
-- Notes:
--  * This callback is called *after* the chooser is shown. To execute code just before it's shown (and/or after it's removed) see `hs.chooser.globalCallback`
---@return hs.chooser
function M:showCallback(fn) end

-- Sets the sub-text color of the chooser
--
-- Parameters:
--  * color - An optional table containing a color specification (see `hs.drawing.color`), or nil to restore the default color. If this parameter is omitted, the existing color will be returned
--
-- Returns:
--  * The `hs.chooser` object or a color table
---@return hs.chooser
function M:subTextColor(color, ...) end

-- Gets/Sets the width of the chooser
--
-- Parameters:
--  * percent - An optional number indicating the percentage of the width of the screen that the chooser should occupy. If this parameter is omitted, the current width will be returned
--
-- Returns:
--  * The `hs.chooser` object or a number
--
-- Notes:
--  * This should be used before a chooser has been displayed
---@return hs.chooser
function M:width(percent, ...) end

