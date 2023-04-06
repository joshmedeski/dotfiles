--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- JSON encoding and decoding
--
-- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
-- 
---@class hs.json
local M = {}
hs.json = M

-- Decodes JSON into a table
--
-- Parameters:
--  * jsonString - A string containing some JSON data
--
-- Returns:
--  * A table representing the supplied JSON data
--
-- Notes:
--  * This is useful for retrieving some of the more complex lua table structures as a persistent setting (see `hs.settings`)
function M.decode(jsonString, ...) end

-- Encodes a table as JSON
--
-- Parameters:
--  * val - A table containing data to be encoded as JSON
--  * prettyprint - An optional boolean, true to format the JSON for human readability, false to format the JSON for size efficiency. Defaults to false
--
-- Returns:
--  * A string containing a JSON representation of the supplied table
--
-- Notes:
--  * This is useful for storing some of the more complex lua table structures as a persistent setting (see `hs.settings`)
---@return string
function M.encode(val, prettyprint, ...) end

-- Decodes JSON file into a table.
--
-- Parameters:
--  * path - The path and filename of the JSON file to read.
--
-- Returns:
--  * A table representing the supplied JSON data, or `nil` if an error occurs.
function M.read(path, ...) end

-- Encodes a table as JSON to a file
--
-- Parameters:
--  * data - A table containing data to be encoded as JSON
--  * path - The path and filename of the JSON file to write to
--  * prettyprint - An optional boolean, `true` to format the JSON for human readability, `false` to format the JSON for size efficiency. Defaults to `false`
--  * replace - An optional boolean, `true` to replace an existing file at the same path if one exists. Defaults to `false`
--
-- Returns:
--  * `true` if successful otherwise `false` if an error has occurred
---@return boolean
function M.write(data, path, prettyprint, replace, ...) end

