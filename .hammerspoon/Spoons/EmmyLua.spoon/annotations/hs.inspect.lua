--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Produce human-readable representations of Lua variables (particularly tables)
--
-- This extension is based on inspect.lua by Enrique García Cota
-- https://github.com/kikito/inspect.lua
---@class hs.inspect
local M = {}
hs.inspect = M

-- Gets a human readable version of the supplied Lua variable
--
-- Parameters:
--  * variable - A lua variable of some kind
--  * options - An optional table which can be used to influence the inspector. Valid keys are as follows:
--   * depth - A number representing the maximum depth to recurse into `variable`. Below that depth, data will be displayed as `{...}`
--   * newline - A string to use for line breaks. Defaults to `\n`
--   * indent - A string to use for indentation. Defaults to `  ` (two spaces)
--   * process - A function that will be called for each item. It should accept two arguments, `item` (the current item being processed) and `path` (the item's position in the variable being inspected. The function should either return a processed form of the variable, the original variable itself if it requires no processing, or `nil` to remove the item from the inspected output.
--   * metatables - If `true`, include (and traverse) metatables
--
-- Returns:
--  * A string containing the human readable version of `variable`
--
-- Notes:
--  * For convenience, you can call this function as `hs.inspect(variable)`
--  * To view the output in Hammerspoon's Console, use `print(hs.inspect(variable))`
--  * For more information on the options, and some examples, see [the upstream docs](https://github.com/kikito/inspect.lua)
---@return string
function M.inspect(variable, options, ...) end

