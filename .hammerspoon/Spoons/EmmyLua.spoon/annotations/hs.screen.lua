--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Manipulate screens (i.e. monitors)
--
-- The macOS coordinate system used by Hammerspoon assumes a grid that spans all the screens (positioned as per
-- System Preferences->Displays->Arrangement). The origin `0,0` is at the top left corner of the *primary screen*.
-- (Screens to the left of the primary screen, or above it, and windows on these screens, will have negative coordinates)
---@class hs.screen
local M = {}
hs.screen = M

-- Transforms from the absolute coordinate space used by OSX/Hammerspoon to the screen's local coordinate space, where `0,0` is at the screen's top left corner
--
-- Parameters:
--  * geom - an hs.geometry point or rect, or arguments to construct one
--
-- Returns:
--  * an hs.geometry point or rect, transformed to the screen's local coordinate space
---@return hs.geometry
function M:absoluteToLocal(geom, ...) end

-- Gets the current state of the screen-related accessibility settings
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the following keys, and corresponding boolean values for whether the user has enabled these options:
--    * ReduceMotion (only available on macOS 10.12 or later)
--    * ReduceTransparency
--    * IncreaseContrast
--    * InvertColors (only available on macOS 10.12 or later)
--    * DifferentiateWithoutColor
function M.accessibilitySettings() end

-- Returns all the screens
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing one or more `hs.screen` objects
function M.allScreens() end

-- Returns a table containing the screen modes supported by the screen. A screen mode is a combination of resolution, scaling factor and colour depth
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the supported screen modes. The keys of the table take the form of "1440x900@2x" (for a HiDPI mode) or "1680x1050@1x" (for a native DPI mode). The values are tables which contain the keys:
--   * w - A number containing the width of the screen mode in points
--   * h - A number containing the height of the screen mode in points
--   * scale - A number containing the scaling factor of the screen mode (typically `1` for a native mode, `2` for a HiDPI mode)
--   * freq - A number containing the vertical refresh rate in Hz
--   * depth - A number containing the bit depth of the display mode
--
-- Notes:
--  * Prior to 0.9.83, only 32-bit colour modes would be returned, but now all colour depths are returned. This has necessitated changing the naming of the modes in the returned table.
--  * "points" are not necessarily the same as pixels, because they take the scale factor into account (e.g. "1440x900@2x" is a 2880x1800 screen resolution, with a scaling factor of 2, i.e. with HiDPI pixel-doubled rendering enabled), however, they are far more useful to work with than native pixel modes, when a Retina screen is involved. For non-retina screens, points and pixels are equivalent.
function M:availableModes() end

-- Returns a table describing the current screen mode
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the current screen mode. The keys of the table are:
--   * w - A number containing the width of the screen mode in points
--   * h - A number containing the height of the screen mode in points
--   * scale - A number containing the scaling factor of the screen mode (typically `1` for a native mode, `2` for a HiDPI mode)
--   * freq - A number containing the vertical refresh rate in Hz
--   * depth - A number containing the bit depth
--   * desc - A string containing a representation of the mode as used in `hs.screen:availableModes()` - e.g. "1920x1080@2x 60Hz 4bpp"
function M:currentMode() end

-- Gets/Sets the desktop background image for a screen
--
-- Parameters:
--  * imageURL - An optional file:// URL to an image file to set as the background. If omitted, the current file URL is returned
--
-- Returns:
--  * the `hs.screen` object if a new URL was set, otherwise a string containing the current URL
--
-- Notes:
--  * If the user has set a folder of pictures to be alternated as the desktop background, the path to that folder will be returned.
function M:desktopImageURL(imageURL, ...) end

-- Finds screens
--
-- Parameters:
--  * hint - search criterion for the desired screen(s); it can be:
--   * a number as per `hs.screen:id()`
--   * a string containing the UUID of the desired screen
--   * a string pattern that matches (via `string.match`) the screen name as per `hs.screen:name()` (for convenience, the matching will be done on lowercased strings)
--   * an hs.geometry *point* object, or constructor argument, with the *x and y position* of the screen in the current layout as per `hs.screen:position()`
--   * an hs.geometry *size* object, or constructor argument, with the *resolution* of the screen as per `hs.screen:fullFrame()`
--   * an hs.geometry *rect* object, or constructor argument, with an arbitrary rect in absolute coordinates; the screen
--      containing the largest part of the rect will be returned
--
-- Returns:
--  * one or more hs.screen objects that match the supplied search criterion, or `nil` if none found
--
-- Notes:
--  * for convenience you call this as `hs.screen(hint)`
--
-- Example:
-- ```lua
-- hs.screen(724562417) --> Color LCD - by id
-- hs.screen'Dell'      --> DELL U2414M - by name
-- hs.screen'Built%-in' --> Built-in Retina Display, note the % to escape the hyphen repetition character
-- hs.screen'0,0'       --> PHL BDM4065 - by position, same as hs.screen.primaryScreen()
-- hs.screen{x=-1,y=0}  --> DELL U2414M - by position, screen to the immediate left of the primary screen
-- hs.screen'3840x2160' --> PHL BDM4065 - by screen resolution
-- hs.screen'-500,240 700x1300' --> DELL U2414M, by arbitrary rect
-- ```
---@return hs.screen
function M.find(hint, ...) end

-- Returns the screen frame, without the dock or menu.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an hs.geometry rect describing this screen's "usable" frame (i.e. without the dock and menu bar) in absolute coordinates
---@return hs.geometry
function M:frame() end

-- Returns the absolute rect of a given unit rect within this screen
--
-- Parameters:
--  * unitrect - an hs.geometry unit rect, or arguments to construct one
--
-- Returns:
--  * an hs.geometry rect describing the given unit rect in absolute coordinates
--
-- Notes:
--  * this method is just a convenience wrapper for `hs.geometry.fromUnitRect(unitrect,this_screen:frame())`
---@return hs.geometry
function M:fromUnitRect(unitrect, ...) end

-- Returns the screen frame, including the dock and menu.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an hs.geometry rect describing this screen's frame in absolute coordinates
---@return hs.geometry
function M:fullFrame() end

-- Gets the screen's brightness
--
-- Parameters:
--  * None
--
-- Returns:
--  * A floating point number between 0 and 1, containing the current brightness level, or nil if the display does not support brightness queries
function M:getBrightness() end

-- Gets the screen's ForceToGray setting
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the ForceToGray mode is set, otherwise false
---@return boolean
function M.getForceToGray() end

-- Gets the current whitepoint and blackpoint of the screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the white point and black point of the screen, or nil if an error occurred. The keys `whitepoint` and `blackpoint` each have values of a table containing the following keys, with corresponding values between 0.0 and 1.0:
--   * red
--   * green
--   * blue
function M:getGamma() end

-- Gets a table of information about an `hs.screen` object
--
-- Parameters:
--  * None
--
-- Returns:
--  *  A table containing various information, or nil if an error occurred.
function M:getInfo() end

-- Gets the screen's InvertedPolarity setting
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the InvertedPolarity mode is set, otherwise false
---@return boolean
function M.getInvertedPolarity() end

-- Gets the UUID of an `hs.screen` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the UUID, or nil if an error occurred.
---@return string
function M:getUUID() end

-- Returns a screen's unique ID
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the ID of the screen
---@return number
function M:id() end

-- Transforms from the screen's local coordinate space, where `0,0` is at the screen's top left corner, to the absolute coordinate space used by OSX/Hammerspoon
--
-- Parameters:
--  * geom - an hs.geometry point or rect, or arguments to construct one
--
-- Returns:
--  * an hs.geometry point or rect, transformed to the absolute coordinate space
---@return hs.geometry
function M:localToAbsolute(geom, ...) end

-- Returns the 'main' screen, i.e. the one containing the currently focused window
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.screen` object
---@return hs.screen
function M.mainScreen() end

-- Make this screen mirror another
--
-- Parameters:
--  * aScreen - an hs.screen object you wish to mirror
--  * permanent - an optional bool, true if this should be configured permanently, false if it should apply just for this login session. Defaults to false.
--
-- Returns:
--  * true if the operation succeeded, otherwise false
---@return boolean
function M:mirrorOf(aScreen, permanent, ...) end

-- Stops this screen mirroring another
--
-- Parameters:
--  * permanent - an optional bool, true if this should be configured permanently, false if it should apply just for this login session. Defaults to false.
--
-- Returns:
--  * true if the operation succeeded, otherwise false
---@return boolean
function M:mirrorStop(permanent, ...) end

-- Returns the preferred name for the screen set by the manufacturer
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the screen, or nil if an error occurred
function M:name() end

-- Gets the screen 'after' this one (in arbitrary order); this method wraps around to the first screen.
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.screen` object
---@return hs.screen
function M:next() end

-- Return a given screen's position relative to the primary screen - see 'hs.screen.screenPositions()'
--
-- Parameters:
--  * None
--
-- Returns:
--  * two integers indicating the screen position in the current screen arrangement, in the x and y axis respectively.
function M:position() end

-- Gets the screen 'before' this one (in arbitrary order); this method wraps around to the last screen.
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.screen` object
---@return hs.screen
function M:previous() end

-- Gets the primary screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.screen` object
---@return hs.screen
function M.primaryScreen() end

-- Restore the gamma settings to defaults
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This returns all displays to the gamma tables specified by the user's selected ColorSync display profiles
function M.restoreGamma() end

-- Gets/Sets the rotation of a screen
--
-- Parameters:
--  * degrees - An optional number indicating how many degrees clockwise, to rotate. If no number is provided, the current rotation will be returned. This number must be one of:
--   * 0
--   * 90
--   * 180
--   * 270
--
-- Returns:
--  * If the rotation is being set, a boolean, true if the operation succeeded, otherwise false. If the rotation is being queried, a number will be returned
function M:rotate(degrees, ...) end

-- Returns a list of all connected and enabled screens, along with their "position" relative to the primary screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table where each *key* is an `hs.screen` object, and the corresponding value is a table {x=X,y=Y}, where X and Y attempt to indicate each screen's position relative to the primary screen (which is at {x=0,y=0}); so e.g. a value of {x=-1,y=0} indicates a screen immediately to the left of the primary screen, and a value of {x=0,y=2} indicates a screen positioned below the primary screen, with another screen inbetween.
--
-- Notes:
--  * grid-like arrangements of same-sized screens should behave consistently; but there's no guarantee of a consistent result for more "exotic" screen arrangements
function M.screenPositions() end

-- Sets the screen's brightness
--
-- Parameters:
--  * brightness - A floating point number between 0 and 1
--
-- Returns:
--  * The `hs.screen` object
function M:setBrightness(brightness, ...) end

-- Sets the screen's ForceToGray mode
--
-- Parameters:
--  * ForceToGray - A boolean if ForceToGray mode should be enabled
--
-- Returns:
--  * None
function M.setForceToGray(ForceToGray, ...) end

-- Sets the current white point and black point of the screen
--
-- Parameters:
--  * whitepoint - A table containing color component values between 0.0 and 1.0 for each of the keys:
--   * red
--   * green
--   * blue
--  * blackpoint - A table containing color component values between 0.0 and 1.0 for each of the keys:
--   * red
--   * green
--   * blue
--
-- Returns:
--  * A boolean, true if the gamma settings were applied, false if an error occurred
--
-- Notes:
--  * If the whitepoint and blackpoint specified, are very similar, it will be impossible to read the screen. You should exercise caution, and may wish to bind a hotkey to `hs.screen.restoreGamma()` when experimenting
---@return boolean
function M:setGamma(whitepoint, blackpoint, ...) end

-- Sets the screen's InvertedPolarity mode
--
-- Parameters:
--  * InvertedPolarity - A boolean if InvertedPolarity mode should be enabled
--
-- Returns:
--  * None
function M.setInvertedPolarity(InvertedPolarity, ...) end

-- Sets the screen to a new mode
--
-- Parameters:
--  * width - A number containing the width in points of the new mode
--  * height - A number containing the height in points of the new mode
--  * scale - A number containing the scaling factor of the new mode (typically 1 for native pixel resolutions, 2 for HiDPI/Retina resolutions)
--  * frequency - A number containing the vertical refresh rate, in Hertz of the new mode
--  * depth - A number containing the bit depth of the new mode
--
-- Returns:
--  * A boolean, true if the requested mode was set, otherwise false
--
-- Notes:
--  * The available widths/heights/scales can be seen in the output of `hs.screen:availableModes()`, however, it should be noted that the CoreGraphics subsystem seems to list more modes for a given screen than it is actually prepared to set, so you may find that seemingly valid modes still return false. It is not currently understood why this is so!
---@return boolean
function M:setMode(width, height, scale, frequency, depth, ...) end

-- Sets the origin of a screen in the global display coordinate space. The origin of the main or primary display is (0,0). The new origin is placed as close as possible to the requested location, without overlapping or leaving a gap between displays. If you use this function to change the origin of a mirrored display, the display may be removed from the mirroring set.
--
-- Parameters:
--  * x - The desired x-coordinate for the upper-left corner of the display.
--  * y - The desired y-coordinate for the upper-left corner of the display.
--
-- Returns:
--  * true if the operation succeeded, otherwise false
---@return boolean
function M:setOrigin(x, y, ...) end

-- Sets the screen to be the primary display (i.e. contain the menubar and dock)
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the operation succeeded, otherwise false
---@return boolean
function M:setPrimary() end

-- Saves an image of the screen to a JPG file
--
-- Parameters:
--  * filePath - A string containing a file path to save the screenshot as
--  * screenRect - An optional `hs.geometry` rect (or arguments for its constructor) containing a portion of the screen to capture. Defaults to the whole screen
--
-- Returns:
--  * None
function M:shotAsJPG(filePath, screenRect, ...) end

-- Saves an image of the screen to a PNG file
--
-- Parameters:
--  * filePath - A string containing a file path to save the screenshot as
--  * screenRect - An optional `hs.geometry` rect (or arguments for its constructor) containing a portion of the screen to capture. Defaults to the whole screen
--
-- Returns:
--  * None
function M:shotAsPNG(filePath, screenRect, ...) end

-- Captures an image of the screen
--
-- Parameters:
--  * rect - An optional `rect-table` containing a portion of the screen to capture. Defaults to the whole screen
--
-- Returns:
--  * An `hs.image` object, or nil if an error occurred
function M:snapshot(rect, ...) end

-- If set to `true`, the methods `hs.screen:toEast()`, `:toNorth()` etc. will disregard screens that lie perpendicularly to the desired axis
M.strictScreenInDirection = nil

-- Gets the first screen to the east of this one, ordered by proximity to its center or a specified point.
--
-- Parameters:
--  * from - An `hs.geometry.rect` or `hs.geometry.point` object; if omitted, the geometric center of this screen will be used
--  * strict - If `true`, disregard screens that lie completely above or below this one (alternatively, set `hs.screen.strictScreenInDirection`)
--
-- Returns:
--   * An `hs.screen` object, or `nil` if not found
---@return hs.screen
function M:toEast(from, strict, ...) end

-- Gets the first screen to the north of this one, ordered by proximity to its center or a specified point.
--
-- Parameters:
--  * from - An `hs.geometry.rect` or `hs.geometry.point` object; if omitted, the geometric center of this screen will be used
--  * strict - If `true`, disregard screens that lie completely to the left or to the right of this one (alternatively, set `hs.screen.strictScreenInDirection`)
--
-- Returns:
--   * An `hs.screen` object, or `nil` if not found
---@return hs.screen
function M:toNorth(from, strict, ...) end

-- Gets the first screen to the south of this one, ordered by proximity to its center or a specified point.
--
-- Parameters:
--  * from - An `hs.geometry.rect` or `hs.geometry.point` object; if omitted, the geometric center of this screen will be used
--  * strict - If `true`, disregard screens that lie completely to the left or to the right of this one (alternatively, set `hs.screen.strictScreenInDirection`)
--
-- Returns:
--   * An `hs.screen` object, or `nil` if not found
---@return hs.screen
function M:toSouth(from, strict, ...) end

-- Returns the unit rect of a given rect, relative to this screen
--
-- Parameters:
--  * rect - an hs.geometry rect, or arguments to construct one
--
-- Returns:
--  * an hs.geometry unit rect describing the given rect relative to this screen's frame
--
-- Notes:
--  * this method is just a convenience wrapper for `hs.geometry.toUnitRect(rect,this_screen:frame())`
function M:toUnitRect(rect, ...) end

-- Gets the first screen to the west of this one, ordered by proximity to its center or a specified point.
--
-- Parameters:
--  * from - An `hs.geometry.rect` or `hs.geometry.point` object; if omitted, the geometric center of this screen will be used
--  * strict - If `true`, disregard screens that lie completely above or below this one (alternatively, set `hs.screen.strictScreenInDirection`)
--
-- Returns:
--   * An `hs.screen` object, or `nil` if not found
---@return hs.screen
function M:toWest(from, strict, ...) end

