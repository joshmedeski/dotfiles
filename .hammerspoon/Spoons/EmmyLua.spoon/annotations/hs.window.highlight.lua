--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Highlight the focused window
--
-- This module can be useful to spatially keep track of windows if you have large and/or multiple screens, and are
-- therefore likely to have several windows visible at any given time.
-- It highlights the currently focused window by covering other windows and the desktop with either a subtle
-- ("overlay" mode) or opaque ("isolate" mode) overlay; additionally it can highlight windows as they're shown
-- or hidden via a brief flash, to help determine their location intuitively (to avoid having to studiously scan
-- all your screens when, for example, you know you triggered a dialog but it didn't show up where you expected it).
--
-- By default, overlay mode is disabled - you can enable it with `hs.window.highlight.ui.overlay=true` - and so are
-- the window shown/hidden flashes - enable those with `hs.window.highlight.ui.flashDuration=0.3` (or whatever duration
-- you prefer). Isolate mode is always available and can be toggled manually via `hs.window.highlight.toggleIsolate()`
-- or automatically by passing an appropriate windowfilter (or a list of apps) to `hs.window.highlight.start()`.
---@class hs.window.highlight
local M = {}
hs.window.highlight = M

-- Starts the module
--
-- Parameters:
--  * windowfilterIsolate - (optional) an `hs.window.filter` instance that automatically enable "isolate" mode
--    whenever one of the allowed windows is focused; alternatively, you can just provide a list of application
--    names and a windowfilter will be created for you that enables isolate mode whenever one of these apps is focused;
--    if omitted or nil, isolate mode won't be toggled automatically, but you can still toggle it manually via
--    `hs.window.highlight.toggleIsolate()`
--  * windowfilterOverlay - (optional) an `hs.window.filter` instance that determines which windows to consider
--    for "overlay" mode when focused; if omitted or nil, the default windowfilter will be used
--
-- Returns:
--  * None
--
-- Notes:
--  * overlay mode is disabled by default - see `hs.window.highlight.ui.overlayColor`
function M.start(windowfilterIsolate, windowfilterOverlay, ...) end

-- Stops the module and disables focused window highlighting (both "overlay" and "isolate" mode)
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.stop() end

-- Sets or clears the user override for "isolate" mode.
--
-- Parameters:
--  * v - (optional) a boolean; if true, enable isolate mode; if false, disable isolate mode,
--    even when `windowfilterIsolate` passed to `.start()` would otherwise enable it; if omitted or nil,
--    toggle the override, i.e. clear it if it's currently enforced, or set it to the opposite of the current
--    isolate mode status otherwise.
--
-- Returns:
--  * None
--
-- Notes:
--  * This function should be bound to a hotkey, e.g.: `hs.hotkey.bind('ctrl-cmd','\','Isolate',hs.window.highlight.toggleIsolate)`
function M.toggleIsolate(v) end

-- Allows customization of the highlight overlays and behaviour.
--
-- The default values are shown in the right hand side of the assignments below.
--
-- To represent color values, you can use:
--  * a table {red=redN, green=greenN, blue=blueN, alpha=alphaN}
--  * a table {redN,greenN,blueN[,alphaN]} - if omitted alphaN defaults to 1.0
-- where redN, greenN etc. are the desired value for the color component between 0.0 and 1.0
--
-- Color inversion is governed by the module `hs.redshift`. See the relevant documentation for more information.
--
--  * `hs.window.highlight.ui.overlay = false` - draw overlay over the area of the screen(s) that isn't occupied by the focused window
--  * `hs.window.highlight.ui.overlayColor = {0.2,0.05,0,0.25}` - overlay color
--  * `hs.window.highlight.ui.overlayColorInverted = {0.8,0.9,1,0.3}` - overlay color when colors are inverted
--  * `hs.window.highlight.ui.isolateColor = {0,0,0,0.95}` - overlay color for isolate mode
--  * `hs.window.highlight.ui.isolateColorInverted = {1,1,1,0.95}` - overlay color for isolate mode when colors are inverted
--  * `hs.window.highlight.ui.frameWidth = 10` - draw a frame around the focused window in overlay mode; 0 to disable
--  * `hs.window.highlight.ui.frameColor = {0,0.6,1,0.5}` - frame color
--  * `hs.window.highlight.ui.frameColorInvert = {1,0.4,0,0.5}`
--  * `hs.window.highlight.ui.flashDuration = 0` - duration in seconds of a brief flash over windows as they're shown/hidden;
--    disabled if 0; if desired, 0.3 is a good value
--  * `hs.window.highlight.ui.windowShownFlashColor = {0,1,0,0.8}` - flash color when a window is shown (created or unhidden)
--  * `hs.window.highlight.ui.windowHiddenFlashColor = {1,0,0,0.8}` - flash color when a window is hidden (destroyed or hidden)
--  * `hs.window.highlight.ui.windowShownFlashColorInvert = {1,0,1,0.8}`
--  * `hs.window.highlight.ui.windowHiddenFlashColorInvert = {0,1,1,0.8}`
M.ui = nil

