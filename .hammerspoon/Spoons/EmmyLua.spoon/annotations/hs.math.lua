--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Various helpful mathematical functions
--
-- This module includes, and is a superset of the built-in Lua `math` library so it is safe to do something like the following in your own code and still have access to both libraries:
--
--     local math = require("hs.math")
--     local n = math.sin(math.minFloat) -- works even though they're both from different libraries
--
-- The documentation for the math library can be found at http://www.lua.org/manual/5.3/ or from the Hammerspoon console via the help command: `help.lua.math`. This includes the following functions and variables:
--
--   * hs.math.abs        - help available via `help.lua.math.abs`
--   * hs.math.acos       - help available via `help.lua.math.acos`
--   * hs.math.asin       - help available via `help.lua.math.asin`
--   * hs.math.atan       - help available via `help.lua.math.atan`
--   * hs.math.ceil       - help available via `help.lua.math.ceil`
--   * hs.math.cos        - help available via `help.lua.math.cos`
--   * hs.math.deg        - help available via `help.lua.math.deg`
--   * hs.math.exp        - help available via `help.lua.math.exp`
--   * hs.math.floor      - help available via `help.lua.math.floor`
--   * hs.math.fmod       - help available via `help.lua.math.fmod`
--   * hs.math.huge       - help available via `help.lua.math.huge`
--   * hs.math.log        - help available via `help.lua.math.log`
--   * hs.math.max        - help available via `help.lua.math.max`
--   * hs.math.maxinteger - help available via `help.lua.math.maxinteger`
--   * hs.math.min        - help available via `help.lua.math.min`
--   * hs.math.mininteger - help available via `help.lua.math.mininteger`
--   * hs.math.modf       - help available via `help.lua.math.modf`
--   * hs.math.pi         - help available via `help.lua.math.pi`
--   * hs.math.rad        - help available via `help.lua.math.rad`
--   * hs.math.random     - help available via `help.lua.math.random`
--   * hs.math.randomseed - help available via `help.lua.math.randomseed`
--   * hs.math.sin        - help available via `help.lua.math.sin`
--   * hs.math.sqrt       - help available via `help.lua.math.sqrt`
--   * hs.math.tan        - help available via `help.lua.math.tan`
--   * hs.math.tointeger  - help available via `help.lua.math.tointeger`
--   * hs.math.type       - help available via `help.lua.math.type`
--   * hs.math.ult        - help available via `help.lua.math.ult`
--
-- Additional functions and values that are specific to Hammerspoon which provide expanded math support are documented here.
---@class hs.math
local M = {}
hs.math = M

-- Returns whether or not the value is a finite number
--
-- Parameters:
--  * `value` - the value to be tested
--
-- Returns:
--  * true if the value is a finite number, or false otherwise
--
-- Notes:
--  * This function returns true if the value is a number and both [hs.math.isNaN](#isNaN) and [hs.math.isInfinite](#isInfinite) return false.
---@return boolean
function M.isFinite(value, ...) end

-- Returns whether or not the value is the mathematical equivalent of either positive or negative "Infinity"
--
-- Parameters:
--  * `value` - the value to be tested
--
-- Returns:
--  * 1 if the value is equivalent to positive infinity, -1 if the value is equivalent to negative infinity, or false otherwise.
--
-- Notes:
--  * This function specifically checks if the `value` is equivalent to positive or negative infinity --- it does not do type checking. If `value` is not a numeric value (e.g. a string), it *cannot* be equivalent to positive or negative infinity and will return false.
--  * Because lua treats any value other than `nil` and `false` as `true`, the return value of this function can be safely used in conditionals when you don't care about the sign of the infinite value.
function M.isInfinite(value, ...) end

-- Returns whether or not the value is the mathematical equivalent of "Not-A-Number"
--
-- Parameters:
--  * `value` - the value to be tested
--
-- Returns:
--  * true if `value` is equal to the mathematical "value" of NaN, or false otherwise
--
-- Notes:
--  * Mathematical `NaN` represents an impossible value, usually the result of a calculation, yet is still considered within the domain of mathematics. The most common case is the result of `n / 0` as division by 0 is considered undefined or "impossible".
--  * This function specifically checks if the `value` is `NaN` --- it does not do type checking. If `value` is not a numeric value (e.g. a string), it *cannot* be equivalent to `NaN` and this function will return false.
---@return boolean
function M.isNaN(value, ...) end

-- Smallest positive floating point number representable in Hammerspoon
--
-- Notes:
--  * Because specifying a delay of 0 to `hs.timer.doAfter` results in the event not triggering, use this value to indicate that the action should occur as soon as possible after the current code block has completed execution.
M.minFloat = nil

-- Returns a random floating point number between 0 and 1
--
-- Parameters:
--  * None
--
-- Returns:
--  * A random number between 0 and 1
---@return number
function M.randomFloat() end

-- Returns a random integer between the start and end parameters
--
-- Parameters:
--  * start - A number to start the range, must be greater than or equal to zero
--  * end - A number to end the range, must be greater than zero and greater than `start`
--
-- Returns:
--  * A randomly chosen integer between `start` and `end`
---@return number
function M.randomFromRange(start, _end, ...) end

