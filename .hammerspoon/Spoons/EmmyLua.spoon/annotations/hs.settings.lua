--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Serialize simple Lua variables across Hammerspoon launches
-- Settings must have a string key and must be made up of serializable Lua objects (string, number, boolean, nil, tables of such, etc.)
--
-- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
-- 
---@class hs.settings
local M = {}
hs.settings = M

-- A string representing the ID of the bundle Hammerspoon's settings are stored in . You can use this with the command line tool `defaults` or other tools which allow access to the `User Defaults` of applications, to access these outside of Hammerspoon
M.bundleID = nil

-- Deletes a setting
--
-- Parameters:
--  * key - A string containing the name of a setting
--
-- Returns:
--  * A boolean, true if the setting was deleted, otherwise false
---@return boolean
function M.clear(key, ...) end

-- A string representing the expected format of date and time when presenting the date and time as a string to `hs.setDate()`.  e.g. `os.date(hs.settings.dateFormat)`
M.dateFormat = nil

-- Loads a setting
--
-- Parameters:
--  * key - A string containing the name of the setting
--
-- Returns:
--  * The value of the setting
--
-- Notes:
--  * This function can load all of the datatypes supported by `hs.settings.set()`, `hs.settings.setData()` and `hs.settings.setDate()`
function M.get(key, ...) end

-- Gets all of the previously stored setting names
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing all of the settings keys in Hammerspoon's settings
--
-- Notes:
--  * Use `ipairs(hs.settings.getKeys())` to iterate over all available settings
--  * Use `hs.settings.getKeys()["someKey"]` to test for the existence of a particular key
function M.getKeys() end

-- Saves a setting with common datatypes
--
-- Parameters:
--  * key - A string containing the name of the setting
--  * val - An optional value for the setting. Valid datatypes are:
--    * string
--    * number
--    * boolean
--    * nil
--    * table (which may contain any of the same valid datatypes)
--
-- Returns:
--  * None
--
-- Notes:
--  * If no val parameter is provided, it is assumed to be nil
--  * This function cannot set dates or raw data types, see `hs.settings.setDate()` and `hs.settings.setData()`
--  * Assigning a nil value is equivalent to clearing the value with `hs.settings.clear`
function M.set(key, val, ...) end

-- Saves a setting with raw binary data
--
-- Parameters:
--  * key - A string containing the name of the setting
--  * val - Some raw binary data
--
-- Returns:
--  * None
function M.setData(key, val, ...) end

-- Saves a setting with a date
--
-- Parameters:
--  * key - A string containing the name of the setting
--  * val - A number representing seconds since `1970-01-01 00:00:00 +0000` (e.g. `os.time()`), or a string containing a date in RFC3339 format (`YYYY-MM-DD[T]HH:MM:SS[Z]`)
--
-- Returns:
--  * None
--
-- Notes:
--  * See `hs.settings.dateFormat` for a convenient representation of the RFC3339 format, to use with other time/date related functions
function M.setDate(key, val, ...) end

-- Get or set a watcher to invoke a callback when the specified settings key changes
--
-- Parameters:
--  * identifier - a required string used as an identifier for this callback
--  * key        - the settings key to watch for changes to
--  * fn         - the callback function to be invoked when the specified key changes.  If this is an explicit nil, removes the existing callback.
--
-- Returns:
--  * if a callback is set or removed, returns the identifier; otherwise returns the current callback function or nil if no callback function is currently defined.
--
-- Notes:
--  * the identifier is required so that multiple callbacks for the same key can be registered by separate modules; it's value doesn't affect what is being watched but does need to be unique between multiple watchers of the same key.
--  * Does not work with keys that include a period (.) in the key name because KVO uses dot notation to specify a sequence of properties.  If you know of a way to escape periods so that they are watchable as NSUSerDefault key names, please file an issue and share!
function M.watchKey(identifier, key, fn, ...) end

