--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Utility object to represent points, sizes and rects in a bidimensional plane
--
-- An hs.geometry object can be:
--  * a *point*, or vector2, with `x` and `y` fields for its coordinates
--  * a *size* with `w` and `h` fields for width and height respectively
--  * a *rect*, which has both a point component for one of its corners, and a size component - so it has all 4 fields
--  * a *unit rect*, which is a rect with all fields between 0 and 1; it represents a "relative" rect within another (absolute) rect
--    (e.g. a unit rect `x=0,y=0 , w=0.5,h=0.5` is the quarter portion closest to the origin); please note that hs.geometry
--    makes no distinction internally between regular rects and unit rects; you can convert to and from as needed via the appropriate methods
--
-- You can create these objects in many different ways, via `my_obj=hs.geometry.new(...)` or simply `my_obj=hs.geometry(...)`
-- by passing any of the following:
--  * 4 parameters `X,Y,W,H` for the respective fields - W and H, or X and Y, can be `nil`:
--    * `hs.geometry(X,Y)` creates a point
--    * `hs.geometry(nil,nil,W,H)` creates a size
--    * `hs.geometry(X,Y,W,H)` creates a rect given its width and height from a corner
--  * a table `{X,Y}` creates a point
--  * a table `{X,Y,W,H}` creates a rect
--  * a table `{x=X,y=Y,w=W,h=H}` creates a rect, or if you omit X and Y, or W and H, creates a size or a point respectively
--  * a table `{x1=X1,y1=Y1,x2=X2,y2=Y2}` creates a rect, where X1,Y1 and X2,Y2 are the coordinates of opposite corners
--  * a string:
--    * `"X Y"` or `"X,Y"` creates a point
--    * `"WxH"` or `"W*H"` creates a size
--    * `"X Y/WxH"` or `"X,Y W*H"` (or variations thereof) creates a rect given its width and height from a corner
--    * `"X1,Y1>X2,Y2"` or `"X1 Y1 X2 Y2"` (or variations thereof) creates a rect given two opposite corners
--    * `"[X,Y WxH]"` or `"[X1,Y1 X2,Y2]"` or variations (note the square brackets) creates a unit rect where x=X/100, y=Y/100, w=W/100, h=H/100
--  * a point and a size `"X Y","WxH"` or `{x=X,y=Y},{w=W,h=H}` create a rect
--
-- You can use any of these anywhere an hs.geometry object is expected in Hammerspoon; the constructor will be called for you.
---@class hs.geometry
local M = {}
hs.geometry = M

-- Returns the angle between the positive x axis and this vector2
--
-- Parameters:
--  * None
--
-- Returns:
--  * a number representing the angle in radians
---@return number
function M:angle() end

-- Returns the angle between the positive x axis and the vector connecting this point or rect's center to another point or rect's center
--
-- Parameters:
--  * point - an hs.geometry object, or a table or string or parameter list to construct one; if a rect, uses the rect's center
--
-- Returns:
--  * a number representing the angle in radians
---@return number
function M:angleTo(point, ...) end

-- A number representing the area of this rect or size; changing it will scale the rect/size - see `hs.geometry:scale()`
M.area = nil

-- A number representing the aspect ratio of this rect or size; changing it will reshape the rect/size, keeping its area and center constant
M.aspect = nil

-- Alias for `x2y2`
M.bottomright = nil

-- A point representing the geometric center of this rect or the midpoint of this vector2; changing it will move the rect/vector accordingly
M.center = nil

-- Creates a copy of an hs.geometry object
--
-- Parameters:
--  * geom - an hs.geometry object to copy
--
-- Returns:
--  * a newly created copy of the hs.geometry object
---@return hs.geometry
function M.copy(geom, ...) end

-- Finds the distance between this point or rect's center and another point or rect's center
--
-- Parameters:
--  * point - an hs.geometry object, or a table or string or parameter list to construct one; if a rect, uses the rect's center
--
-- Returns:
--  * a number indicating the distance
---@return number
function M:distance(point, ...) end

-- Checks if two geometry objects are equal
--
-- Parameters:
--  * other - another hs.geometry object, or a table or string or parameter list to construct one
--
-- Returns:
--  * `true` if this hs.geometry object perfectly overlaps other, `false` otherwise
---@return boolean
function M:equals(other, ...) end

-- Ensure this rect is fully inside `bounds`, by scaling it down if it's larger (preserving its aspect ratio) and moving it if necessary
--
-- Parameters:
--  * bounds - an hs.geometry rect object, or a table or string or parameter list to construct one, indicating the rect that
--    must fully contain this rect
--
-- Returns:
--  * this hs.geometry object for method chaining
---@return hs.geometry
function M:fit(bounds, ...) end

-- Truncates all coordinates in this object to integers
--
-- Parameters:
--  * None
--
-- Returns:
--  * this hs.geometry point for method chaining
---@return hs.geometry
function M:floor() end

-- Converts a unit rect within a given frame into a rect
--
-- Parameters:
--  * frame - an hs.geometry rect (with `w` and `h` >0)
--
-- Returns:
--  * An hs.geometry rect object
---@return hs.geometry
function M:fromUnitRect(frame, ...) end

-- The height of this rect or size; changing it will keep the rect's x,y corner constant
M.h = nil

-- Checks if this hs.geometry object lies fully inside a given rect
--
-- Parameters:
--  * rect - an hs.geometry rect, or a table or string or parameter list to construct one
--
-- Returns:
--  * `true` if this point/rect lies fully inside the given rect, `false` otherwise
---@return boolean
function M:inside(rect, ...) end

-- Returns the intersection rect between this rect and another rect
--
-- Parameters:
--  * rect - an hs.geometry rect, or a table or string or parameter list to construct one
--
-- Returns:
--  * a new hs.geometry rect
--
-- Notes:
--  * If the two rects don't intersect, the result rect will be a "projection" of the second rect onto this rect's
--    closest edge or corner along the x or y axis; the `w` and/or `h` fields in the result rect will be 0.
---@return hs.geometry
function M:intersect(rect, ...) end

-- A number representing the length of the diagonal of this rect, or the length of this vector2; changing it will scale the rect/vector - see `hs.geometry:scale()`
M.length = nil

-- Moves this point/rect
--
-- Parameters:
--  * point - an hs.geometry object, or a table or string or parameter list to construct one, indicating the x and y displacement to apply
--
-- Returns:
--  * this hs.geometry object for method chaining
---@return hs.geometry
function M:move(point, ...) end

-- Creates a new hs.geometry object
--
-- Parameters:
--  * ... - see the module description at the top
--
-- Returns:
--  * a newly created hs.geometry object
---@return hs.geometry
function M.new(...) end

-- Normalizes this vector2
--
-- Parameters:
--  * None
--
-- Returns:
--  * this hs.geometry point for method chaining
---@return hs.geometry
function M:normalize() end

-- Convenience function for creating a point object
--
-- Parameters:
--  * x - A number containing the horizontal co-ordinate of the point
--  * y - A number containing the vertical co-ordinate of the point
--
-- Returns:
--  * An hs.geometry point object
function M.point(x, y, ...) end

-- Convenience function for creating a rect-table
--
-- Parameters:
--  * x - A number containing the horizontal co-ordinate of the top-left point of the rect
--  * y - A number containing the vertical co-ordinate of the top-left point of the rect
--  * w - A number containing the width of the rect
--  * h - A number containing the height of the rect
--
-- Returns:
--  * An hs.geometry rect object
---@return hs.geometry
function M.rect(x, y, w, h, ...) end

-- Rotates a point around another point N times
--
-- Parameters:
--  * aroundpoint - an hs.geometry point to rotate this point around
--  * ntimes - the number of times to rotate, defaults to 1
--
-- Returns:
--  * A new hs.geometry point containing the location of the rotated point
function M:rotateCCW(aroundpoint, ntimes, ...) end

-- Scales this vector2/size, or this rect *keeping its center constant*
--
-- Parameters:
--  * size - an hs.geometry object, or a table or string or parameter list to construct one, indicating the factors for scaling this rect's width and height;
--    if a number, the rect will be scaled by the same factor in both axes
--
-- Returns:
--  * this hs.geometry object for method chaining
---@return hs.geometry
function M:scale(size, ...) end

-- Convenience function for creating a size object
--
-- Parameters:
--  * w - A number containing a width
--  * h - A number containing a height
--
-- Returns:
--  * An hs.geometry size object
function M.size(w, h, ...) end

-- The `"X,Y/WxH"` string for this hs.geometry object (*reduced precision*); useful e.g. for logging
M.string = nil

-- The `{x=X,y=Y,w=W,h=H}` table for this hs.geometry object; useful e.g. for serialization/deserialization
M.table = nil

-- Alias for `xy`
M.topleft = nil

-- Converts a rect into its unit rect within a given frame
--
-- Parameters:
--  * frame - an hs.geometry rect (with `w` and `h` >0)
--
-- Returns:
--  * An hs.geometry unit rect object
--
-- Notes:
--  * The resulting unit rect is always clipped within `frame`'s bounds (via `hs.geometry:intersect()`); if `frame`
--    does not encompass this rect *no error will be thrown*, but the resulting unit rect won't be a direct match with this rect
--    (i.e. calling `:fromUnitRect(frame)` on it will return a different rect)
function M:toUnitRect(frame, ...) end

-- Returns the type of an hs.geometry object
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string describing the type of this hs.geometry object, i.e. 'point', 'size', 'rect' or 'unitrect'; `nil` if not a valid object
---@return string
function M:type() end

-- Returns the smallest rect that encloses both this rect and another rect
--
-- Parameters:
--  * rect - an hs.geometry rect, or a table or string or parameter list to construct one
--
-- Returns:
--  * a new hs.geometry rect
---@return hs.geometry
function M:union(rect, ...) end

-- Returns the vector2 from this point or rect's center to another point or rect's center
--
-- Parameters:
--  * point - an hs.geometry object, or a table or string or parameter list to construct one; if a rect, uses the rect's center
--
-- Returns:
--  * an hs.geometry point
---@return hs.geometry
function M:vector(point, ...) end

-- The width of this rect or size; changing it will keep the rect's x,y corner constant
M.w = nil

-- The size component for this hs.geometry object; setting this to a new size will keep the rect's x,y corner constant
M.wh = nil

-- The x coordinate for this point or rect's corner; changing it will move the rect but keep the same width and height
M.x = nil

-- Alias for `x`
M.x1 = nil

-- The x coordinate for the second corner of this rect; changing it will affect the rect's width
M.x2 = nil

-- The point denoting the other corner of this hs.geometry object; setting this to a new point will change the rect's width and height
M.x2y2 = nil

-- The point component for this hs.geometry object; setting this to a new point will move the rect but keep the same width and height
M.xy = nil

-- The y coordinate for this point or rect's corner; changing it will move the rect but keep the same width and height
M.y = nil

-- Alias for `y`
M.y1 = nil

-- The y coordinate for the second corner of this rect; changing it will affect the rect's height
M.y2 = nil

