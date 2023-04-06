--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Communicate with external devices through a serial port (most commonly RS-232).
--
-- Powered by ORSSerialPort. Thrown together by @latenitefilms.
--
-- Copyright (c) 2011-2012 Andrew R. Madsen (andrew@openreelsoftware.com)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
---@class hs.serial
local M = {}
hs.serial = M

-- Returns a table of currently connected serial ports details, organised by port name.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the IOKit details of any connected serial ports, organised by port name.
function M.availablePortDetails() end

-- Returns a table of currently connected serial ports names.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the names of any connected serial port names as strings.
function M.availablePortNames() end

-- Returns a table of currently connected serial ports paths.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the names of any connected serial port paths as strings.
function M.availablePortPaths() end

-- Gets or sets the baud rate for the serial port.
--
-- Parameters:
--  * value - An optional number to set the baud rate.
--  * [allowNonStandardBaudRates] - An optional boolean to enable non-standard baud rates. Defaults to `false`.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns the baud rate as a number
--
-- Notes:
--  * This function supports the following standard baud rates as numbers: 300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400.
--  * If no baud rate is supplied, it defaults to 115200.
function M:baudRate(value, allowNonStandardBaudRates, ...) end

-- Sets or removes a callback function for the `hs.serial` object.
--
-- Parameters:
--  * `callbackFn` - a function to set as the callback for this `hs.serial` object.  If the value provided is `nil`, any currently existing callback function is removed.
--
-- Returns:
--  * The `hs.serial` object
--
-- Notes:
--  * The callback function should expect 4 arguments and should not return anything:
--    * `serialPortObject` - The serial port object that triggered the callback.
--    * `callbackType` - A string containing "opened", "closed", "received", "removed" or "error".
--    * `message` - If the `callbackType` is "received", then this will be the data received as a string. If the `callbackType` is "error", this will be the error message as a string.
--    * `hexadecimalString` - If the `callbackType` is "received", then this will be the data received as a hexadecimal string.
function M:callback(callbackFn, ...) end

-- Closes the serial port.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.serial` object.
function M:close() end

-- Gets or sets the number of data bits for the serial port.
--
-- Parameters:
--  * value - An optional number to set the number of data bits. It can be 5 to 8.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns the data bits as a number.
--  * The default value is 8.
function M:dataBits(value, ...) end

-- A callback that's triggered when a serial port is added or removed from the system.
--
-- Parameters:
--  * callbackFn - the callback function to trigger, or nil to remove the current callback
--
-- Returns:
--  * None
--
-- Notes:
--  * The callback function should expect 1 argument and should not return anything:
--    * `devices` - A table containing the names of any serial ports connected as strings.
function M.deviceCallback(callbackFn, ...) end

-- Gets or sets the state of the serial port's DTR (Data Terminal Ready) pin.
--
-- Parameters:
--  * value - An optional boolean.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns a boolean.
--
-- Notes:
--  * The default value is `false`.
--  * Setting this to `true` is most likely required for Arduino devices prior to opening the serial port.
function M:dtr(value, ...) end

-- Gets whether or not a serial port is open.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if open, otherwise `false`.
---@return boolean
function M:isOpen() end

-- Returns the name of a `hs.serial` object.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The name as a string.
---@return string
function M:name() end

-- Creates a new `hs.serial` object using the port name.
--
-- Parameters:
--  * portName - A string containing the port name.
--
-- Returns:
--  * An `hs.serial` object or `nil` if an error occurred.
--
-- Notes:
--  * A valid port name can be found by checking `hs.serial.availablePortNames()`.
function M.newFromName(portName, ...) end

-- Creates a new `hs.serial` object using a path.
--
-- Parameters:
--  * path - A string containing the path (i.e. "/dev/cu.usbserial").
--
-- Returns:
--  * An `hs.serial` object or `nil` if an error occurred.
--
-- Notes:
--  * A valid port name can be found by checking `hs.serial.availablePortPaths()`.
function M.newFromPath(path, ...) end

-- Opens the serial port.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.serial` object or `nil` if the port could not be opened.
function M:open() end

-- Gets or sets the parity for the serial port.
--
-- Parameters:
--  * value - An optional string to set the parity. It can be "none", "odd" or "even".
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns a string value of "none", "odd" or "even".
function M:parity(value, ...) end

-- Returns the path of a `hs.serial` object.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The path as a string.
---@return string
function M:path() end

-- Gets or sets the state of the serial port's RTS (Request to Send) pin.
--
-- Parameters:
--  * value - An optional boolean.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns a boolean.
--
-- Notes:
--  * The default value is `false`.
--  * Setting this to `true` is most likely required for Arduino devices prior to opening the serial port.
function M:rts(value, ...) end

-- Sends data via a serial port.
--
-- Parameters:
--  * value - A string of data to send.
--
-- Returns:
--  * None
function M:sendData(value, ...) end

-- Gets or sets whether the port should echo received data.
--
-- Parameters:
--  * value - An optional boolean.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns a boolean.
--
-- Notes:
--  * The default value is `false`.
function M:shouldEchoReceivedData(value, ...) end

-- Gets or sets the number of stop bits for the serial port.
--
-- Parameters:
--  * value - An optional number to set the number of stop bits. It can be 1 or 2.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns the number of stop bits as a number.
--
-- Notes:
--  * The default value is 1.
function M:stopBits(value, ...) end

-- Gets or sets whether the port should use DTR/DSR Flow Control.
--
-- Parameters:
--  * value - An optional boolean.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns a boolean.
--
-- Notes:
--  * The default value is `false`.
function M:usesDTRDSRFlowControl(value, ...) end

-- Gets or sets whether the port should use RTS/CTS Flow Control.
--
-- Parameters:
--  * value - An optional boolean.
--
-- Returns:
--  * If a value is specified, then this method returns the serial port object. Otherwise this method returns a boolean.
--
-- Notes:
--  * The default value is `false`.
function M:usesRTSCTSFlowControl(value, ...) end

