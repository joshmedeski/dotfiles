--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Base64 encoding and decoding
--
-- Portions sourced from (https://gist.github.com/shpakovski/1902994).
---@class hs.base64
local M = {}
hs.base64 = M

-- Decodes a given base64 string
--
-- Parameters:
--  * str - A base64 encoded string
--
-- Returns:
--  * A string containing the decoded data
function M.decode(str, ...) end

-- Encodes a given string to base64
--
-- Parameters:
--  * val - A string to encode as base64
--  * width - Optional line width to split the string into (usually 64 or 76)
--
-- Returns:
--  * A string containing the base64 representation of the input string
function M.encode(val, width, ...) end

