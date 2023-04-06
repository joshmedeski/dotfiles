--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Simple HTTP server
--
-- Notes:
--  * Running an HTTP server is potentially dangerous, you should seriously consider the security implications of exposing your Hammerspoon instance to a network - especially to the Internet
--  * As a user of Hammerspoon, you are assumed to be highly capable, and aware of the security issues
---@class hs.httpserver
local M = {}
hs.httpserver = M

-- Gets the network interface the server is configured to listen on
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the network interface name, or nil if the server will listen on all interfaces
function M:getInterface() end

-- Gets the Bonjour name the server is configured to advertise itself as
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the Bonjour name of this server
--
-- Notes:
--  * This is not the hostname of the server, just its name in Bonjour service lists (e.g. Safari's Bonjour bookmarks menu)
---@return string
function M:getName() end

-- Gets the TCP port the server is configured to listen on
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the TCP port
---@return number
function M:getPort() end

-- Get or set the maximum allowed body size for an incoming HTTP request.
--
-- Parameters:
--  * size - An optional integer value specifying the maximum body size allowed for an incoming HTTP request in bytes.  Defaults to 10485760 (10 MB).
--
-- Returns:
--  * If a new size is specified, returns the `hs.httpserver` object; otherwise the current value.
--
-- Notes:
--  * Because the Hammerspoon http server processes incoming requests completely in memory, this method puts a limit on the maximum size for a POST or PUT request.
function M:maxBodySize(size, ...) end

-- Creates a new HTTP or HTTPS server
--
-- Parameters:
--  * ssl     - An optional boolean. If true, the server will start using HTTPS. Defaults to false.
--  * bonjour - An optional boolean. If true, the server will advertise itself with Bonjour.  Defaults to true. Note that in order to change this, you must supply a true or false value for the `ssl` argument.
--
-- Returns:
--  * An `hs.httpserver` object
--
-- Notes:
--  * By default, the server will start on a random TCP port and advertise itself with Bonjour. You can check the port with `hs.httpserver:getPort()`
--  * By default, the server will listen on all network interfaces. You can override this with `hs.httpserver:setInterface()` before starting the server
--  * Currently, in HTTPS mode, the server will use a self-signed certificate, which most browsers will warn about. If you want/need to be able to use `hs.httpserver` with a certificate signed by a trusted Certificate Authority, please file an bug on Hammerspoon requesting support for this.
function M.new(ssl, bonjour, ...) end

-- Sends a message to the websocket client
--
-- Parameters:
--  * message - A string containing the message to send
--
-- Returns:
--  * The `hs.httpserver` object
function M:send(message, ...) end

-- Sets the request handling callback for an HTTP server object
--
-- Parameters:
--  * callback - An optional function that will be called to process each incoming HTTP request, or nil to remove an existing callback. See the notes section below for more information about this callback
--
-- Returns:
--  * The `hs.httpserver` object
--
-- Notes:
--  * The callback will be passed four arguments:
--   * A string containing the type of request (i.e. `GET`/`POST`/`DELETE`/etc)
--   * A string containing the path element of the request (e.g. `/index.html`)
--   * A table containing the request headers
--   * A string containing the raw contents of the request body, or the empty string if no body is included in the request.
--  * The callback *must* return three values:
--   * A string containing the body of the response
--   * An integer containing the response code (e.g. 200 for a successful request)
--   * A table containing additional HTTP headers to set (or an empty table, `{}`, if no extra headers are required)
--
-- Notes:
--  * A POST request, often used by HTML forms, will store the contents of the form in the body of the request.
function M:setCallback(callback, ...) end

-- Sets the network interface the server is configured to listen on
--
-- Parameters:
--  * interface - A string containing an interface name
--
-- Returns:
--  * The `hs.httpserver` object
--
-- Notes:
--  * As well as real interface names (e.g. `en0`) the following values are valid:
--   * An IP address of one of your interfaces
--   * localhost
--   * loopback
--   * nil (which means all interfaces, and is the default)
function M:setInterface(interface, ...) end

-- Sets the Bonjour name the server should advertise itself as
--
-- Parameters:
--  * name - A string containing the Bonjour name for the server
--
-- Returns:
--  * The `hs.httpserver` object
--
-- Notes:
--  * This is not the hostname of the server, just its name in Bonjour service lists (e.g. Safari's Bonjour bookmarks menu)
function M:setName(name, ...) end

-- Sets a password for an HTTP server object
--
-- Parameters:
--  * password - An optional string that contains the server password, or nil to remove an existing password
--
-- Returns:
--  * The `hs.httpserver` object
--
-- Notes:
--  * It is not currently possible to set multiple passwords for different users, or passwords only on specific paths
function M:setPassword(password, ...) end

-- Sets the TCP port the server is configured to listen on
--
-- Parameters:
--  * port - An integer containing a TCP port to listen on
--
-- Returns:
--  * The `hs.httpserver` object
function M:setPort(port, ...) end

-- Starts an HTTP server object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.httpserver` object
function M:start() end

-- Stops an HTTP server object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.httpserver` object
function M:stop() end

-- Enables a websocket endpoint on the HTTP server
--
-- Parameters:
--  * path - A string containing the websocket path such as '/ws'
--  * callback - A function returning a string for each received websocket message
--
-- Returns:
--  * The `hs.httpserver` object
--
-- Notes:
--  * The callback is passed one string parameter containing the received message
--  * The callback must return a string containing the response message
--  * Given a path '/mysock' and a port of 8000, the websocket URL is as follows:
--   * ws://localhost:8000/mysock
--   * wss://localhost:8000/mysock (if SSL enabled)
function M:websocket(path, callback, ...) end

