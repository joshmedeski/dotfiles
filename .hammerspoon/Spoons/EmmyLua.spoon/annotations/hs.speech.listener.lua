--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module provides access to the Speech Recognizer component of OS X.
--
-- The speech recognizer functions and methods provide a way to add commands which may be issued to Hammerspoon through spoken words and phrases to trigger a callback.
---@class hs.speech.listener
local M = {}
hs.speech.listener = M

-- Get or set whether or not the speech recognizer should block other recognizers when it is active.
--
-- Parameters:
--  * flag - an optional boolean indicating whether or not the speech recognizer should block other speech recognizers when it is active. Defaults to false.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the recognizer object.
function M:blocksOtherRecognizers(flag, ...) end

-- Get or set the commands this speech recognizer will listen for.
--
-- Parameters:
--  * commandsArray - an optional array of strings which specify the commands the recognizer will listen for.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the recognizer object.
--
-- Notes:
--  * The list of commands will appear in the Dictation Commands window, if it is visible, under the title of this speech recognizer.  The text of each command is a possible value which may be sent as the second argument to a callback function for this speech recognizer, if one is defined.
--  * Setting this to an empty list does not disable the speech recognizer, but it does make it of limited use, other than to provide a title in the Dictation Commands window.  To disable the recognizer, use the `hs.speech.listener:stop` or `hs.speech.listener:delete` methods.
function M:commands(commandsArray, ...) end

-- Disables the speech recognizer and removes it from the possible available speech recognizers.
--
-- Parameters:
--  * None.
--
-- Returns:
--  * None
--
-- Notes:
--  * this disables the speech recognizer and removes it from the list in the Dictation Commands window.  The object is effectively destroyed, so you will need to create a new one with `hs.speech.listener.new` if you want to bring it back.
--  * if this was the only speech recognizer currently available, the Dictation Commands window and feedback display will be removed from the users display.
--  * this method is automatically called during a reload or restart of Hammerspoon.
function M:delete() end

-- Get or set whether or not the speech recognizer is active only when the Hammerspoon application is active.
--
-- Parameters:
--  * flag - an optional boolean indicating whether or not the speech recognizer should respond to commands only when Hammerspoon is the active application or not. Defaults to true.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the recognizer object.
function M:foregroundOnly(flag, ...) end

-- Returns a boolean value indicating whether or not the recognizer is currently enabled (started).
--
-- Parameters:
--  * None
--
-- Returns:
--  * true if the listener is listening (has been started) or false if it is not.
---@return boolean
function M:isListening() end

-- Creates a new speech recognizer object for use by Hammerspoon.
--
-- Parameters:
--  * title - an optional parameter specifying the title under which commands assigned to this speech recognizer will be listed in the Dictation Commands display when it is visible.  Defaults to "Hammerspoon".
--
-- Returns:
--  * a speech recognizer object or nil, if the system was unable to create a new recognizer.
--
-- Notes:
--  * You can change the title later with the `hs.speech.listener:title` method.
function M.new(title, ...) end

-- Sets or removes a callback function for the speech recognizer.
--
-- Parameters:
--  * fn - a function to set as the callback for this speech synthesizer.  If the value provided is nil, any currently existing callback function is removed.  The callback function should accept two arguments and return none.  The arguments will be the speech recognizer object itself and the string of the command which was spoken.
--
-- Returns:
--  * the recognizer object
--
-- Notes:
--  * Possible string values for the command spoken are set with the `hs.speech.listener:commands` method.
--  * Removing the callback does not disable the speech recognizer, but it does make it of limited use, other than to provide a list in the Dictation Commands window.  To disable the recognizer, use the `hs.speech.listener:stop` or `hs.speech.listener:delete` methods.
function M:setCallback(fn) end

-- Make the speech recognizer active.
--
-- Parameters:
--  * None.
--
-- Returns:
--  * returns the recognizer object.
function M:start() end

-- Disables the speech recognizer.
--
-- Parameters:
--  * None.
--
-- Returns:
--  * returns the recognizer object.
--
-- Notes:
--  * this only disables the speech recognizer.  To completely remove it from the list in the Dictation Commands window, use `hs.speech.listener:delete`.
function M:stop() end

-- Get or set the title for a speech recognizer.
--
-- Parameters:
--  * title - an optional parameter specifying the title under which commands assigned to this speech recognizer will be listed in the Dictation Commands display when it is visible.  If you provide an explicit `nil`, it will reset to the default of "Hammerspoon".
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the recognizer object.
function M:title(title, ...) end

