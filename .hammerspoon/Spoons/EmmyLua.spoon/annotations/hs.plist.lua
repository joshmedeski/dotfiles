--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Read and write Property List files
---@class hs.plist
local M = {}
hs.plist = M

-- Loads a Property List file
--
-- Parameters:
--  * filepath - The path and filename of a plist file to read
--
-- Returns:
--  * The contents of the plist as a Lua table
function M.read(filepath, ...) end

-- Interprets a property list file within a string into a table.
--
-- Parameters:
--  * value  - The contents of the property list as a string
--  * binary - an optional boolean, specifying whether the value should be treated as raw binary (true) or as an UTF8 encoded string (false). If you do not provide this argument, the function will attempt to auto-detect the type.
--
-- Returns:
--  * The contents of the property list as a Lua table or `nil` if an error occurs
function M.readString(value, binary, ...) end

-- Writes a Property List file
--
-- Parameters:
--  * filepath - The path and filename of the plist file to write
--  * data - A Lua table containing the data to write into the plist
--  * binary - An optional boolean, if true, the plist will be written as a binary file. Defaults to false
--
-- Returns:
--  * A boolean, true if the plist was written successfully, otherwise false
--
-- Notes:
--  * Only simple types can be converted to plist items:
--   * Strings
--   * Numbers
--   * Booleans
--   * Tables
--  * You should be careful when reading a plist, modifying and writing it - Hammerspoon may not be able to preserve all of the datatypes via Lua
---@return boolean
function M.write(filepath, data, binary, ...) end

-- Interprets a property list file within a string into a table.
--
-- Parameters:
--  * data - A Lua table containing the data to write into a plist string
--  * binary - an optional boolean, default false, specifying that the resulting string should be encoded as a binary plist.
--
-- Returns:
--  * A string representing the data as a plist or nil if there was a problem with the date or serialization.
function M.writeString(data, binary, ...) end

