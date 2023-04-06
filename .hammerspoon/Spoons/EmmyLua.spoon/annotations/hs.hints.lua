--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Switch focus with a transient per-application keyboard shortcut
---@class hs.hints
local M = {}
hs.hints = M

-- A fully specified family-face name, preferably the PostScript name, such as Helvetica-BoldOblique or Times-Roman. (The Font Book app displays PostScript names of fonts in the Font Info panel.)
-- The default value is the system font
M.fontName = nil

-- The size of font that should be used. A value of 0.0 will use the default size.
M.fontSize = nil

-- This controls the set of characters that will be used for window hints. They must be characters found in hs.keycodes.map
-- The default is the letters A-Z. Note that if `hs.hints.style` is set to "vimperator", this variable will be ignored.
M.hintChars = nil

-- Opacity of the application icon. Default is 0.95.
M.iconAlpha = nil

-- If there are less than or equal to this many windows on screen their titles will be shown in the hints.
-- The default is 4. Setting to 0 will disable this feature.
M.showTitleThresh = nil

-- If this is set to "vimperator", every window hint starts with the first character
-- of the parent application's title
M.style = nil

-- If the title is longer than maxSize, the string is truncated, -1 to disable, valid value is >= 6
M.titleMaxSize = nil

-- Displays a keyboard hint for switching focus to each window
--
-- Parameters:
--  * windows - An optional table containing some `hs.window` objects. If this value is nil, all windows will be hinted
--  * callback - An optional function that will be called when a window has been selected by the user. The function will be called with a single argument containing the `hs.window` object of the window chosen by the user
--  * allowNonStandard - An optional boolean.  If true, all windows will be included, not just standard windows
--
-- Returns:
--  * None
--
-- Notes:
--  * If there are more windows open than there are characters available in hs.hints.hintChars, multiple characters will be used
--  * If hints.style is set to "vimperator", every window hint is prefixed with the first character of the parent application's name
--  * To display hints only for the currently focused application, try something like:
--   * `hs.hints.windowHints(hs.window.focusedWindow():application():allWindows())`
function M.windowHints(windows, callback, allowNonStandard, ...) end

