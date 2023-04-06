--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect/manipulate windows
--
-- Notes:
--  * See `hs.screen` and `hs.geometry` for more information on how Hammerspoon uses window/screen frames and coordinates
---@class hs.window
local M = {}
hs.window = M

-- Returns all windows
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list of `hs.window` objects representing all open windows
--
-- Notes:
--  * `visibleWindows()`, `orderedWindows()`, `get()`, `find()`, and several more functions and methods in this and other
--     modules make use of this function, so it is important to understand its limitations
--  * This function queries all applications for their windows every time it is invoked; if you need to call it a lot and
--    performance is not acceptable consider using the `hs.window.filter` module
--  * This function can only return windows in the current Mission Control Space; if you need to address windows across
--    different Spaces you can use the `hs.window.filter` module
--    - if `Displays have separate Spaces` is *on* (in System Preferences>Mission Control) the current Space is defined
--      as the union of all currently visible Spaces
--    - minimized windows and hidden windows (i.e. belonging to hidden apps, e.g. via cmd-h) are always considered
--      to be in the current Space
--  * This function filters out the desktop "window"; use `hs.window.desktop()` to address it. (Note however that
--    `hs.application.get'Finder':allWindows()` *will* include the desktop in the returned list)
--  * Beside the limitations discussed above, this function will return *all* windows as reported by OSX, including some
--    "windows" that one wouldn't expect: for example, every Google Chrome (actual) window has a companion window for its
--    status bar; therefore you might get unexpected results  - in the Chrome example, calling `hs.window.focusWindowSouth()`
--    from a Chrome window would end up "focusing" its status bar, and therefore the proper window itself, seemingly resulting
--    in a no-op. In order to avoid such surprises you can use the `hs.window.filter` module, and more specifically
--    the default windowfilter (`hs.window.filter.default`) which filters out known cases of not-actual-windows
--  * Some windows will not be reported by OSX - e.g. things that are on different Spaces, or things that are Full Screen
---@return hs.window[]
function M.allWindows() end

-- The default duration for animations, in seconds. Initial value is 0.2; set to 0 to disable animations.
--
-- Usage:
-- ```
-- hs.window.animationDuration = 0 -- disable animations
-- hs.window.animationDuration = 3 -- if you have time on your hands
-- ```
function M.animationDuration (number, ...) end

-- Gets the `hs.application` object the window belongs to
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.application` object representing the application that owns the window, or nil if an error occurred
function M:application() end

-- Makes the window the main window of its application
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
--
-- Notes:
--  * Make a window become the main window does not transfer focus to the application. See `hs.window.focus()`
---@return hs.window
function M:becomeMain() end

-- Centers the window on a screen
--
-- Parameters:
--  * screen - (optional) An `hs.screen` object or argument for `hs.screen.find`; if nil, use the screen the window is currently on
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:centerOnScreen(screen, ensureInScreenBounds, duration, ...) end

-- Closes the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the operation succeeded, false if not
---@return boolean
function M:close() end

-- Returns the desktop "window"
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.window` object representing the desktop, or nil if Finder is not running
--
-- Notes:
--  * The desktop belongs to Finder.app: when Finder is the active application, you can focus the desktop by cycling
--    through windows via cmd-`
--  * The desktop window has no id, a role of `AXScrollArea` and no subrole
--  * The desktop is filtered out from `hs.window.allWindows()` (and downstream uses)
---@return hs.window
function M.desktop() end

-- Finds windows
--
-- Parameters:
--  * hint - search criterion for the desired window(s); it can be:
--    - an id number as per `hs.window:id()`
--    - a string pattern that matches (via `string.find`) the window title as per `hs.window:title()` (for convenience, the matching will be done on lowercased strings)
--
-- Returns:
--  * one or more hs.window objects that match the supplied search criterion, or `nil` if none found
--
-- Notes:
--  * for convenience you can call this as `hs.window(hint)`
--  * see also `hs.window.get`
--  * for more sophisticated use cases and/or for better performance if you call this a lot, consider using `hs.window.filter`
--
-- Usage:
-- ```
-- -- by id
-- hs.window(8812):title() --> Hammerspoon Console
-- -- by title
-- hs.window'bash':application():name() --> Terminal
-- ```
---@return hs.window
function M.find(hint, ...) end

-- Focuses the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:focus() end

-- Returns the window that has keyboard/mouse focus
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.window` object representing the currently focused window
---@return hs.window
function M.focusedWindow() end

-- Focuses the tab in the window's tab group at index, or the last tab if index is out of bounds
--
-- Parameters:
--  * index - A number, a 1-based index of a tab to focus
--
-- Returns:
--  * true if the tab was successfully pressed, or false if there was a problem
--
-- Notes:
--  * This method works with document tab groups and some app tabs, like Chrome and Safari.
---@return boolean
function M:focusTab(index, ...) end

-- Focuses the nearest possible window to the east (i.e. right)
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows
--    to the east are candidates.
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    eastward axis
--
-- Returns:
--  * `true` if a window was found and focused, `false` otherwise; `nil` if the search couldn't take place
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows
--    every time this method is called; this can be slow, and some undesired "windows" could be included
--    (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in
--    `hs.window.filter` instead
---@return boolean
function M:focusWindowEast(candidateWindows, frontmost, strict, ...) end

-- Focuses the nearest possible window to the north (i.e. up)
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows
--    to the east are candidates.
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    eastward axis
--
-- Returns:
--  * `true` if a window was found and focused, `false` otherwise; `nil` if the search couldn't take place
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows
--    every time this method is called; this can be slow, and some undesired "windows" could be included
--    (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in
--    `hs.window.filter` instead
---@return boolean
function M:focusWindowNorth(candidateWindows, frontmost, strict, ...) end

-- Focuses the nearest possible window to the south (i.e. down)
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows
--    to the east are candidates.
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    eastward axis
--
-- Returns:
--  * `true` if a window was found and focused, `false` otherwise; `nil` if the search couldn't take place
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows
--    every time this method is called; this can be slow, and some undesired "windows" could be included
--    (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in
--    `hs.window.filter` instead
---@return boolean
function M:focusWindowSouth(candidateWindows, frontmost, strict, ...) end

-- Focuses the nearest possible window to the west (i.e. left)
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows
--    to the east are candidates.
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    eastward axis
--
-- Returns:
--  * `true` if a window was found and focused, `false` otherwise; `nil` if the search couldn't take place
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows
--    every time this method is called; this can be slow, and some undesired "windows" could be included
--    (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in
--    `hs.window.filter` instead
---@return boolean
function M:focusWindowWest(candidateWindows, frontmost, strict, ...) end

-- Gets the frame of the window in absolute coordinates
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.geometry rect containing the co-ordinates of the top left corner of the window and its width and height
---@return hs.geometry
function M:frame() end

-- Returns the focused window or, if no window has focus, the frontmost one
--
-- Parameters:
--  * None
--
-- Returns:
-- * An `hs.window` object representing the frontmost window, or `nil` if there are no visible windows
---@return hs.window
function M.frontmostWindow() end

-- Gets a specific window
--
-- Parameters:
--  * hint - search criterion for the desired window; it can be:
--    - an id number as per `hs.window:id()`
--    - a window title string as per `hs.window:title()`
--
-- Returns:
--  * the first hs.window object that matches the supplied search criterion, or `nil` if not found
--
-- Notes:
--  * see also `hs.window.find` and `hs.application:getWindow()`
---@return hs.window
function M.get(hint, ...) end

-- Gets the unique identifier of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the unique identifier of the window, or nil if an error occurred
function M:id() end

-- Gets all invisible windows
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list containing `hs.window` objects representing all windows that are not visible as per `hs.window:isVisible()`
---@return hs.window[]
function M.invisibleWindows() end

-- Gets the fullscreen state of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the window is fullscreen, false if not. Nil if an error occurred
function M:isFullScreen() end

-- Determines if a window is maximizable
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the window is maximizable, False if it isn't, or nil if an error occurred
function M:isMaximizable() end

-- Gets the minimized state of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the window is minimized, otherwise false
---@return boolean
function M:isMinimized() end

-- Determines if the window is a standard window
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the window is standard, otherwise false
--
-- Notes:
--  * "Standard window" means that this is not an unusual popup window, a modal dialog, a floating window, etc.
---@return boolean
function M:isStandard() end

-- Determines if a window is visible (i.e. not hidden and not minimized)
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if the window is visible, otherwise `false`
--
-- Notes:
--  * This does not mean the user can see the window - it may be obscured by other windows, or it may be off the edge of the screen
---@return boolean
function M:isVisible() end

-- Gets a table containing all the window data retrieved from `CGWindowListCreate`.
--
-- Parameters:
--  * allWindows - Get all the windows, even those "below" the Dock window.
--
-- Returns:
--  * `true` is succesful otherwise `false` if an error occurred.
--
-- Notes:
--  * This allows you to get window information without Accessibility Permissions.
function M.list(allWindows, ...) end

-- Maximizes the window
--
-- Parameters:
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
--
-- Notes:
--  * The window will be resized as large as possible, without obscuring the dock/menu
---@return hs.window
function M:maximize(duration, ...) end

-- Minimizes the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
--
-- Notes:
--  * This method will always animate per your system settings and is not affected by `hs.window.animationDuration`
---@return hs.window
function M:minimize() end

-- Gets all minimized windows
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list containing `hs.window` objects representing all windows that are minimized as per `hs.window:isMinimized()`
---@return hs.window[]
function M.minimizedWindows() end

-- Moves the window
--
-- Parameters:
--  * rect - It can be:
--    - an `hs.geometry` point, or argument to construct one; will move the screen by this delta, keeping its size constant; `screen` is ignored
--    - an `hs.geometry` rect, or argument to construct one; will set the window frame to this rect, in absolute coordinates; `screen` is ignored
--    - an `hs.geometry` unit rect, or argument to construct one; will set the window frame to this rect relative to the desired screen;
--      if `screen` is nil, use the screen the window is currently on
--  * screen - (optional) An `hs.screen` object or argument for `hs.screen.find`; only valid if `rect` is a unit rect
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:move(rect, screen, ensureInScreenBounds, duration, ...) end

-- Moves the window one screen east (i.e. right)
--
-- Parameters:
--  * noResize - (optional) if `true`, maintain the window's absolute size
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:moveOneScreenEast(noResize, ensureInScreenBounds, duration, ...) end

-- Moves the window one screen north (i.e. up)
--
--
-- Parameters:
--  * noResize - (optional) if `true`, maintain the window's absolute size
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:moveOneScreenNorth(noResize, ensureInScreenBounds, duration, ...) end

-- Moves the window one screen south (i.e. down)
--
--
-- Parameters:
--  * noResize - (optional) if `true`, maintain the window's absolute size
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:moveOneScreenSouth(noResize, ensureInScreenBounds, duration, ...) end

-- Moves the window one screen west (i.e. left)
--
-- Parameters:
--  * noResize - (optional) if `true`, maintain the window's absolute size
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:moveOneScreenWest(noResize, ensureInScreenBounds, duration, ...) end

-- Moves the window to a given screen, retaining its relative position and size
--
-- Parameters:
--  * screen - An `hs.screen` object, or an argument for `hs.screen.find()`, representing the screen to move the window to
--  * noResize - (optional) if `true`, maintain the window's absolute size
--  * ensureInScreenBounds - (optional) if `true`, use `setFrameInScreenBounds()` to ensure the resulting window frame is fully contained within
--    the window's screen
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:moveToScreen(screen, noResize, ensureInScreenBounds, duration, ...) end

-- Moves and resizes the window to occupy a given fraction of the screen
--
-- Parameters:
--  * unitrect - An `hs.geometry` unit rect, or constructor argument to create one
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
--
-- Notes:
--  * An example, which would make a window fill the top-left quarter of the screen: `win:moveToUnit'[0.0,0.0,0.5,0.5]'`
---@return hs.window
function M:moveToUnit(unitrect, duration, ...) end

-- Returns all visible windows, ordered from front to back
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list of `hs.window` objects representing all visible windows, ordered from front to back
---@return hs.window[]
function M.orderedWindows() end

-- Gets every window except this one
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing `hs.window` objects representing all visible windows other than this one
---@return hs.window[]
function M:otherWindowsAllScreens() end

-- Gets other windows on the same screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table of `hs.window` objects representing the visible windows other than this one that are on the same screen
---@return hs.window[]
function M:otherWindowsSameScreen() end

-- Brings a window to the front of the screen without focussing it
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:raise() end

-- Gets the role of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the role of the window
---@return string
function M:role() end

-- Gets the screen which the window is on
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.screen` object representing the screen which contains the window.
--
-- Notes:
--  * While windows can be dragged to span multiple screens, part of the window will disappear when the mouse is released. The screen returned by this method will be the part of the window that remains visible.
---@return hs.screen
function M:screen() end

-- Sends the window to the back
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
--
-- Notes:
--  * Due to the way this method works and OSX limitations, calling this method when you have a lot of randomly overlapping (as opposed to neatly tiled) windows might be visually jarring, and take a fair amount of time to complete. So if you don't use orderly layouts, or if you have a lot of windows in general, you're probably better off using `hs.application:hide()` (or simply `cmd-h`)
--  * This method works by focusing all overlapping windows behind this one, front to back. If called on the focused window, this method will switch focus to the topmost window under this one; otherwise, the currently focused window will regain focus after this window has been sent to the back.
---@return hs.window
function M:sendToBack() end

-- Sets the frame of the window in absolute coordinates
--
-- Parameters:
--  * rect - An hs.geometry rect, or constructor argument, describing the frame to be applied to the window
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:setFrame(rect, duration, ...) end

-- Using `hs.window:setFrame()` in some cases does not work as expected: namely, the bottom (or Dock) edge, and edges between screens, might
-- exhibit some "stickiness"; consequently, trying to make a window abutting one of those edges just *slightly* smaller could
-- result in no change at all (you can verify this by trying to resize such a window with the mouse: at first it won't budge,
-- and, as you drag further away, suddenly snap to the new size); and similarly in some cases windows along screen edges
-- might erroneously end up partially on the adjacent screen after a move/resize.  Additionally some windows (no matter
-- their placement on screen) only allow being resized at "discrete" steps of several screen points; the typical example
-- is Terminal windows, which only resize to whole rows and columns. Both these OSX issues can cause incorrect behavior
-- when using `:setFrame()` directly or in downstream uses, such as `hs.window:move()` and the `hs.grid` and `hs.window.layout` modules.
--
-- Setting this variable to `true` will make `:setFrame()` perform additional checks and workarounds for these potential
-- issues. However, as a side effect the window might appear to jump around briefly before setting toward its destination
-- frame, and, in some cases, the move/resize animation (if requested) might be skipped entirely - these tradeoffs are
-- necessary to ensure the desired result.
--
-- The default value is `false`, in order to avoid the possibly annoying or distracting window wiggling; set to `true` if you see
-- incorrect results in `:setFrame()` or downstream modules and don't mind the wiggling.
M.setFrameCorrectness = nil

-- Sets the frame of the window in absolute coordinates, possibly adjusted to ensure it is fully inside the screen
--
-- Parameters:
--  * rect - An hs.geometry rect, or constructor argument, describing the frame to be applied to the window; if omitted,
--    the current window frame will be used
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:setFrameInScreenBounds(rect, duration, ...) end

-- Sets the frame of the window in absolute coordinates, using the additional workarounds described in `hs.window.setFrameCorrectness`
--
-- Parameters:
--  * rect - An hs.geometry rect, or constructor argument, describing the frame to be applied to the window
--  * duration - (optional) The number of seconds to animate the transition. Defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:setFrameWithWorkarounds(rect, duration, ...) end

-- Sets the fullscreen state of the window
--
-- Parameters:
--  * fullscreen - A boolean, true if the window should be set fullscreen, false if not
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:setFullScreen(fullscreen, ...) end

-- Enables/Disables window shadows
--
-- Parameters:
--  * shadows - A boolean, true to show window shadows, false to hide window shadows
--
-- Returns:
--  * None
--
-- Notes:
--  * This function uses a private, undocumented OS X API call, so it is not guaranteed to work in any future OS X release
function M.setShadows(shadows, ...) end

-- Resizes the window
--
-- Parameters:
--  * size - A size-table containing the width and height the window should be resized to
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:setSize(size, ...) end

-- Moves the window to a given point
--
-- Parameters:
--  * point - A point-table containing the absolute co-ordinates the window should be moved to
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:setTopLeft(point, ...) end

-- Gets the size of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * A size-table containing the width and height of the window
---@return hs.geometry
function M:size() end

-- Returns a snapshot of the window as an `hs.image` object
--
-- Parameters:
--  * keepTransparency - optional boolean value indicating if the windows alpha value (transparency) should be maintained in the resulting image or if it should be fully opaque (default).
--
-- Returns:
--  * `hs.image` object of the window snapshot or nil if unable to create a snapshot
--
-- Notes:
--  * See also function `hs.window.snapshotForID()`
---@return hs.image-
function M:snapshot(keepTransparency, ...) end

-- Returns a snapshot of the window specified by the ID as an `hs.image` object
--
-- Parameters:
--  * ID - Window ID of the window to take a snapshot of.
--  * keepTransparency - optional boolean value indicating if the windows alpha value (transparency) should be maintained in the resulting image or if it should be fully opaque (default).
--
-- Returns:
--  * `hs.image` object of the window snapshot or nil if unable to create a snapshot
--
-- Notes:
--  * See also method `hs.window:snapshot()`
--  * Because the window ID cannot always be dynamically determined, this function will allow you to provide the ID of a window that was cached earlier.
---@return hs.image-
function M.snapshotForID(ID, keepTransparency, ...) end

-- Gets the subrole of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the subrole of the window
--
-- Notes:
--  * This typically helps to determine if a window is a special kind of window - such as a modal window, or a floating window
---@return string
function M:subrole() end

-- Gets the number of tabs in the window has
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the number of tabs, or nil if an error occurred
--
-- Notes:
--  * Intended for use with the focusTab method, if this returns a number, then focusTab can switch between that many tabs.
function M:tabCount() end

-- Sets the timeout value used in the accessibility API.
--
-- Parameters:
--  * value - The number of seconds for the new timeout value.
--
-- Returns:
--  * `true` is succesful otherwise `false` if an error occurred.
---@return boolean
function M.timeout(value, ...) end

-- Gets the title of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the title of the window
---@return string
function M:title() end

-- Toggles the fullscreen state of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
--
-- Notes:
--  * Not all windows support being full-screened
---@return hs.window
function M:toggleFullScreen() end

-- Toggles the zoom state of the window (this is effectively equivalent to clicking the green maximize/fullscreen button at the top left of a window)
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:toggleZoom() end

-- Gets the absolute co-ordinates of the top left of the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * A point-table containing the absolute co-ordinates of the top left corner of the window
---@return hs.geometry
function M:topLeft() end

-- Un-minimizes the window
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.window` object
---@return hs.window
function M:unminimize() end

-- Gets all visible windows
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list containing `hs.window` objects representing all windows that are visible as per `hs.window:isVisible()`
---@return hs.window[]
function M.visibleWindows() end

-- Gets all windows to the east of this window
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows to the east are candidates.
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the eastward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned east (i.e. right) of the window, in ascending order of distance
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows every time this method is called; this can be slow, and some undesired "windows" could be included (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in `hs.window.filter` instead
---@return hs.window[]
function M:windowsToEast(candidateWindows, frontmost, strict, ...) end

-- Gets all windows to the north of this window
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows to the north are candidates.
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the northward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned north (i.e. up) of the window, in ascending order of distance
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows every time this method is called; this can be slow, and some undesired "windows" could be included (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in `hs.window.filter` instead
---@return hs.window[]
function M:windowsToNorth(candidateWindows, frontmost, strict, ...) end

-- Gets all windows to the south of this window
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows to the south are candidates.
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the southward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned south (i.e. down) of the window, in ascending order of distance
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows every time this method is called; this can be slow, and some undesired "windows" could be included (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in `hs.window.filter` instead
---@return hs.window[]
function M:windowsToSouth(candidateWindows, frontmost, strict, ...) end

-- Gets all windows to the west of this window
--
-- Parameters:
--  * candidateWindows - (optional) a list of candidate windows to consider; if nil, all visible windows to the west are candidates.
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the westward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned west (i.e. left) of the window, in ascending order of distance
--
-- Notes:
--  * If you don't pass `candidateWindows`, Hammerspoon will query for the list of all visible windows every time this method is called; this can be slow, and some undesired "windows" could be included (see the notes for `hs.window.allWindows()`); consider using the equivalent methods in `hs.window.filter` instead
---@return hs.window[]
function M:windowsToWest(candidateWindows, frontmost, strict, ...) end

-- Gets a rect-table for the location of the zoom button (the green button typically found at the top left of a window)
--
-- Parameters:
--  * None
--
-- Returns:
--  * A rect-table containing the bounding frame of the zoom button, or nil if an error occurred
--
-- Notes:
--  * The co-ordinates in the rect-table (i.e. the `x` and `y` values) are in absolute co-ordinates, not relative to the window the button is part of, or the screen the window is on
--  * Although not perfect as such, this method can provide a useful way to find a region of the titlebar suitable for simulating mouse click events on, with `hs.eventtap`
function M:zoomButtonRect() end

