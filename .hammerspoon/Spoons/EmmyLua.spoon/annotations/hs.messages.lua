--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Send messages via iMessage and SMS Relay (note, SMS Relay requires OS X 10.10 and an established SMS Relay pairing between your Mac and an iPhone running iOS8)
--
-- Note: This extension works by controlling the OS X "Messages" app via AppleScript, so you will need that app to be signed into an iMessage account
---@class hs.messages
local M = {}
hs.messages = M

-- Sends an iMessage
--
-- Parameters:
--  * targetAddress - A string containing a phone number or email address registered with iMessage, to send the iMessage to
--  * message - A string containing the message to send
--
-- Returns:
--  * None
function M.iMessage(targetAddress, message, ...) end

-- Sends an SMS using SMS Relay
--
-- Parameters:
--  * targetNumber - A string containing a phone number to send an SMS to
--  * message - A string containing the message to send
--
-- Returns:
--  * None
function M.SMS(targetNumber, message, ...) end

