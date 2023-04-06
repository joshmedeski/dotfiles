--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Simple logger for debugging purposes
--
-- Note: "methods" in this module are actually "static" functions - see `hs.logger.new()`
---@class hs.logger
local M = {}
hs.logger = M

-- Logs debug info to the console
--
-- Parameters:
--  * ... - one or more message strings
--
-- Returns:
--  * None
function M.d(...) end

-- Default log level for new logger instances.
--
-- The starting value is 'warning'; set this (to e.g. 'info') at the top of your `init.lua` to affect
-- all logger instances created without specifying a `loglevel` parameter
M.defaultLogLevel = nil

-- Logs formatted debug info to the console
--
-- Parameters:
--  * fmt - formatting string as per string.format
--  * ... - arguments to fmt
--
-- Returns:
--  * None
function M.df(fmt, ...) end

-- Logs an error to the console
--
-- Parameters:
--  * ... - one or more message strings
--
-- Returns:
--  * None
function M.e(...) end

-- Logs a formatted error to the console
--
-- Parameters:
--  * fmt - formatting string as per string.format
--  * ... - arguments to fmt
--
-- Returns:
--  * None
function M.ef(fmt, ...) end

-- Logs formatted info to the console
--
-- Parameters:
--  * fmt - formatting string as per string.format
--  * ... - arguments to fmt
--
-- Returns:
--  * None
function M.f(fmt, ...) end

-- Gets the log level of the logger instance
--
-- Parameters:
--  * None
--
-- Returns:
--  * The log level of this logger as a number between 0 and 5
---@return number
function M.getLogLevel() end

-- Returns the global log history
--
-- Parameters:
--  * None
--
-- Returns:
--  * a list of (at most `hs.logger.historySize()`) log entries produced by all the logger instances, in chronological order;
--    each entry is a table with the following fields:
--    * time - timestamp in seconds since the epoch
--    * level - a number between 1 (error) and 5 (verbose)
--    * id - a string containing the id of the logger instance that produced this entry
--    * message - a string containing the logged message
function M.history() end

-- Sets or gets the global log history size
--
-- Parameters:
--  * size - (optional) the desired number of log entries to keep in the history;
--    if omitted, will return the current size; the starting value is 0 (disabled)
--
-- Returns:
--  * the current or new history size
--
-- Notes:
--  * if you change history size (other than from 0) after creating any logger instances, things will likely break
---@return number
function M.historySize(size, ...) end

-- Logs info to the console
--
-- Parameters:
--  * ... - one or more message strings
--
-- Returns:
--  * None
function M.i(...) end

-- The log level of the logger instance, as a number between 0 and 5
M.level = nil

-- Creates a new logger instance
--
-- Parameters:
--  * id - a string identifier for the instance (usually the module name)
--  * loglevel - (optional) can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number
--    between 0 and 5; uses `hs.logger.defaultLogLevel` if omitted
--
-- Returns:
--  * the new logger instance
--
-- Notes:
--  * the logger instance created by this method is not a regular object, but a plain table with "static" functions;
--    therefore, do not use the colon syntax for so-called "methods" in this module (as in `mylogger.setLogLevel(3)`);
--    you must instead use the regular dot syntax: `mylogger.setLogLevel(3)`
--
-- Example:
-- ```lua
-- local log = hs.logger.new('mymodule','debug')
-- log.i('Initializing') -- will print "[mymodule] Initializing" to the console```
---@return hs.logger
function M.new(id, loglevel, ...) end

-- Prints the global log history to the console
--
-- Parameters:
--  * entries - (optional) the maximum number of entries to print; if omitted, all entries in the history will be printed
--  * level - (optional) the desired log level (see `hs.logger.setLogLevel()`); if omitted, defaults to `verbose`
--  * filter - (optional) a string to filter the entries (by logger id or message) via `string.find` plain matching
--  * caseSensitive - (optional) if true, filtering is case sensitive
--
-- Returns:
--  * None
function M.printHistory(entries, level, filter, caseSensitive, ...) end

-- Sets the log level for all logger instances (including objects' loggers)
--
-- Parameters:
--  * lvl
--
-- Returns:
--  * None
function M.setGlobalLogLevel(lvl, ...) end

-- Sets the log level of the logger instance
--
-- Parameters:
--  * loglevel - can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose'; or a corresponding number between 0 and 5
--
-- Returns:
--  * None
function M.setLogLevel(loglevel, ...) end

-- Sets the log level for all currently loaded modules
--
-- Parameters:
--  * lvl
--
-- Returns:
--  * None
--
-- Notes:
--  * This function only affects *module*-level loggers, object instances with their own loggers (e.g. windowfilters) won't be affected;
--    you can use `hs.logger.setGlobalLogLevel()` for those
function M.setModulesLogLevel(lvl, ...) end

-- Logs verbose info to the console
--
-- Parameters:
--  * ... - one or more message strings
--
-- Returns:
--  * None
function M.v(...) end

-- Logs formatted verbose info to the console
--
-- Parameters:
--  * fmt - formatting string as per string.format
--  * ... - arguments to fmt
--
-- Returns:
--  * None
function M.vf(fmt, ...) end

-- Logs a warning to the console
--
-- Parameters:
--  * ... - one or more message strings
--
-- Returns:
--  * None
function M.w(...) end

-- Logs a formatted warning to the console
--
-- Parameters:
--  * fmt - formatting string as per string.format
--  * ... - arguments to fmt
--
-- Returns:
--  * None
function M.wf(fmt, ...) end

