--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Window-based cmd-tab replacement
--
-- Usage:
-- ```
-- -- set up your windowfilter
-- switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
-- switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)
--
-- -- bind to hotkeys; WARNING: at least one modifier key is required!
-- hs.hotkey.bind('alt','tab','Next window',function()switcher:next()end)
-- hs.hotkey.bind('alt-shift','tab','Prev window',function()switcher:previous()end)
--
-- -- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
-- hs.hotkey.bind('alt','tab','Next window',hs.window.switcher.nextWindow)
-- -- you can also bind to `repeatFn` for faster traversing
-- hs.hotkey.bind('alt-shift','tab','Prev window',hs.window.switcher.previousWindow,nil,hs.window.switcher.previousWindow)
-- ```
---@class hs.window.switcher
local M = {}
hs.window.switcher = M

-- Creates a new switcher instance; it can use a windowfilter to determine which windows to show
--
-- Parameters:
--  * windowfilter - (optional) if omitted or nil, use the default windowfilter; otherwise it must be a windowfilter
--    instance or constructor table
--  * uiPrefs - (optional) a table to override UI preferences for this instance; its keys and values
--    must follow the conventions described in `hs.window.switcher.ui`; this parameter allows you to have multiple
--    switcher instances with different behaviour (for example, with and without thumbnails and/or titles)
--    using different hotkeys
--  * logname - (optional) name of the `hs.logger` instance for the new switcher; if omitted, the class logger will be used
--  * loglevel - (optional) log level for the `hs.logger` instance for the new switcher
--
-- Returns:
--  * the new instance
---@return hs.window.switcher
function M.new(windowfilter, uiPrefs, logname, loglevel, ...) end

-- Shows the switcher instance (if not yet visible) and selects the next window
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * the switcher will be dismissed (and the selected window focused) when all modifier keys are released
function M:next() end

-- Shows the switcher (if not yet visible) and selects the next window
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * the switcher will be dismissed (and the selected window focused) when all modifier keys are released
function M.nextWindow() end

-- Shows the switcher instance (if not yet visible) and selects the previous window
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * the switcher will be dismissed (and the selected window focused) when all modifier keys are released
function M:previous() end

-- Shows the switcher (if not yet visible) and selects the previous window
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * the switcher will be dismissed (and the selected window focused) when all modifier keys are released
function M.previousWindow() end

-- Allows customization of the switcher behaviour and user interface
--
-- This table contains variables that you can change to customize the behaviour of the switcher and the look of the UI.
-- To have multiple switcher instances with different behaviour/looks, use the `uiPrefs` parameter for the constructor;
-- the passed keys and values will override those in this table for that particular instance.
--
-- The default values are shown in the right hand side of the assignments below.
--
-- To represent color values, you can use:
--  * a table {red=redN, green=greenN, blue=blueN, alpha=alphaN}
--  * a table {redN,greenN,blueN[,alphaN]} - if omitted alphaN defaults to 1.0
-- where redN, greenN etc. are the desired value for the color component between 0.0 and 1.0
--
--  * `hs.window.switcher.ui.textColor = {0.9,0.9,0.9}`
--  * `hs.window.switcher.ui.fontName = 'Lucida Grande'`
--  * `hs.window.switcher.ui.textSize = 16` - in screen points
--  * `hs.window.switcher.ui.highlightColor = {0.8,0.5,0,0.8}` - highlight color for the selected window
--  * `hs.window.switcher.ui.backgroundColor = {0.3,0.3,0.3,1}`
--  * `hs.window.switcher.ui.onlyActiveApplication = false` -- only show windows of the active application
--  * `hs.window.switcher.ui.showTitles = true` - show window titles
--  * `hs.window.switcher.ui.titleBackgroundColor = {0,0,0}`
--  * `hs.window.switcher.ui.showThumbnails = true` - show window thumbnails
--  * `hs.window.switcher.ui.thumbnailSize = 128` - size of window thumbnails in screen points
--  * `hs.window.switcher.ui.showSelectedThumbnail = true` - show a larger thumbnail for the currently selected window
--  * `hs.window.switcher.ui.selectedThumbnailSize = 384`
--  * `hs.window.switcher.ui.showSelectedTitle = true` - show larger title for the currently selected window
M.ui = nil

