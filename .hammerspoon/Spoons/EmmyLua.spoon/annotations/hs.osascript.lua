--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Execute Open Scripting Architecture (OSA) code - AppleScript and JavaScript
-- 
---@class hs.osascript
local M = {}
hs.osascript = M

-- Runs osascript code
--
-- Parameters:
--  * source - Some osascript code to execute
--  * language - A string containing the OSA language, either 'AppleScript' or 'JavaScript'. Defaults to AppleScript if invalid language
--
-- Returns:
--  * A boolean value indicating whether the code succeeded or not
--  * An object containing the parsed output that can be any type, or nil if unsuccessful
--  * A string containing the raw output of the code and/or its errors
function M._osascript(source, language, ...) end

-- Runs AppleScript code
--
-- Parameters:
--  * source - A string containing some AppleScript code to execute
--
-- Returns:
--  * A boolean value indicating whether the code succeeded or not
--  * An object containing the parsed output that can be any type, or nil if unsuccessful
--  * If the code succeeded, the raw output of the code string. If the code failed, a table containing an error dictionary
--
-- Notes:
--  * Use hs.osascript._osascript(source, "AppleScript") if you always want the result as a string, even when a failure occurs
function M.applescript(source, ...) end

-- Runs AppleScript code from a source file.
--
-- Parameters:
--  * fileName - A string containing the file name of an AppleScript file to execute.
--
-- Returns:
--  * A boolean value indicating whether the code succeeded or not
--  * An object containing the parsed output that can be any type, or nil if unsuccessful
--  * If the code succeeded, the raw output of the code string. If the code failed, a table containing an error dictionary
--
-- Notes:
--  * This function uses hs.osascript.applescript for execution.
--  * Use hs.osascript._osascript(source, "AppleScript") if you always want the result as a string, even when a failure occurs. However, this function can only take a string, and not a file name.
function M.applescriptFromFile(fileName, ...) end

-- Runs JavaScript code
--
-- Parameters:
--  * source - A string containing some JavaScript code to execute
--
-- Returns:
--  * A boolean value indicating whether the code succeeded or not
--  * An object containing the parsed output that can be any type, or nil if unsuccessful
--  * If the code succeeded, the raw output of the code string. If the code failed, a table containing an error dictionary
--
-- Notes:
--  * Use hs.osascript._osascript(source, "JavaScript") if you always want the result as a string, even when a failure occurs
function M.javascript(source, ...) end

-- Runs JavaScript code from a source file.
--
-- Parameters:
--  * fileName - A string containing the file name of an JavaScript file to execute.
--
-- Returns:
--  * A boolean value indicating whether the code succeeded or not
--  * An object containing the parsed output that can be any type, or nil if unsuccessful
--  * If the code succeeded, the raw output of the code string. If the code failed, a table containing an error dictionary
--
-- Notes:
--  * This function uses hs.osascript.javascript for execution.
--  * Use hs.osascript._osascript(source, "JavaScript") if you always want the result as a string, even when a failure occurs. However, this function can only take a string, and not a file name.
function M.javascriptFromFile(fileName, ...) end

