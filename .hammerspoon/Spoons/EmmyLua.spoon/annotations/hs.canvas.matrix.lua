--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- A sub module to `hs.canvas` which provides support for basic matrix manipulations which can be used as the values for `transformation` attributes in the `hs.canvas` module.
--
-- For mathematical reasons that are beyond the scope of this document, a 3x3 matrix can be used to represent a series of manipulations to be applied to the coordinates of a 2 dimensional drawing object.  These manipulations can include one or more of a combination of translations, rotations, shearing and scaling. Within the 3x3 matrix, only 6 numbers are actually required, and this module represents them as the following keys in a Lua table: `m11`, `m12`, `m21`, `m22`, `tX`, and `tY`. For those of a mathematical bent, the 3x3 matrix used within this module can be visualized as follows:
--
--     [  m11,  m12,  0  ]
--     [  m21,  m22,  0  ]
--     [  tX,   tY,   1  ]
--
-- This module allows you to generate the table which can represent one or more of the recognized transformations without having to understand the math behind the manipulations or specify the matrix values directly.
--
-- Many of the methods defined in this module can be used both as constructors and as methods chained to a previous method or constructor. Chaining the methods in this manner allows you to combine multiple transformations into one combined table which can then be assigned to an element in your canvas.
-- .
--
-- For more information on the mathematics behind these, you can check the web.  One site I used for reference (but there are many more which go into much more detail) can be found at http://www.cs.trinity.edu/~jhowland/cs2322/2d/2d/.
---@class hs.canvas.matrix
local M = {}
hs.canvas.matrix = M

-- Appends the specified matrix transformations to the matrix and returns the new matrix.  This method cannot be used as a constructor.
--
-- Parameters:
--  * `matrix` - the table to append to the current matrix.
--
-- Returns:
--  * the new matrix
--
-- Notes:
--  * Mathematically this method multiples the original matrix by the new one and returns the result of the multiplication.
--  * You can use this method to "stack" additional transformations on top of existing transformations, without having to know what the existing transformations in effect for the canvas element are.
function M:append(matrix, ...) end

-- Specifies the identity matrix.  Resets all existing transformations when applied as a method to an existing matrixObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the identity matrix.
--
-- Notes:
--  * The identity matrix can be thought of as "apply no transformations at all" or "render as specified".
--  * Mathematically this is represented as:
-- ~~~
-- [ 1,  0,  0 ]
-- [ 0,  1,  0 ]
-- [ 0,  0,  1 ]
-- ~~~
function M.identity() end

-- Generates the mathematical inverse of the matrix.  This method cannot be used as a constructor.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the inverted matrix.
--
-- Notes:
--  * Inverting a matrix which represents a series of transformations has the effect of reversing or undoing the original transformations.
--  * This is useful when used with [hs.canvas.matrix.append](#append) to undo a previously applied transformation without actually replacing all of the transformations which may have been applied to a canvas element.
function M:invert() end

-- Prepends the specified matrix transformations to the matrix and returns the new matrix.  This method cannot be used as a constructor.
--
-- Parameters:
--  * `matrix` - the table to append to the current matrix.
--
-- Returns:
--  * the new matrix
--
-- Notes:
--  * Mathematically this method multiples the new matrix by the original one and returns the result of the multiplication.
--  * You can use this method to apply a transformation *before* the currently applied transformations, without having to know what the existing transformations in effect for the canvas element are.
function M:prepend(matrix, ...) end

-- Applies a rotation of the specified number of degrees to the transformation matrix.  This method can be used as a constructor or a method.
--
-- Parameters:
--  * `angle` - the number of degrees to rotate in a clockwise direction.
--
-- Returns:
--  * the new matrix
--
-- Notes:
--  * The rotation of an element this matrix is applied to will be rotated about the origin (zero point).  To rotate an object about another point (its center for example), prepend a translation to the point to rotate about, and append a translation reversing the initial translation.
--    * e.g. `hs.canvas.matrix.translate(x, y):rotate(angle):translate(-x, -y)`
function M:rotate(angle, ...) end

-- Applies a scaling transformation to the matrix.  This method can be used as a constructor or a method.
--
-- Parameters:
--  * `xFactor` - the scaling factor to apply to the object in the horizontal orientation.
--  * `yFactor` - an optional argument specifying a different scaling factor in the vertical orientation.  If this argument is not provided, the `xFactor` argument will be used for both orientations.
--
-- Returns:
--  * the new matrix
function M:scale(xFactor, yFactor, ...) end

-- Applies a shearing transformation to the matrix.  This method can be used as a constructor or a method.
--
-- Parameters:
--  * `xFactor` - the shearing factor to apply to the object in the horizontal orientation.
--  * `yFactor` - an optional argument specifying a different shearing factor in the vertical orientation.  If this argument is not provided, the `xFactor` argument will be used for both orientations.
--
-- Returns:
--  * the new matrix
function M:shear(xFactor, yFactor, ...) end

-- Applies a translation transformation to the matrix.  This method can be used as a constructor or a method.
--
-- Parameters:
--  * `x` - the distance to translate the object in the horizontal direction.
--  * `y` - the distance to translate the object in the vertical direction.
--
-- Returns:
--  * the new matrix
function M:translate(x, y, ...) end

