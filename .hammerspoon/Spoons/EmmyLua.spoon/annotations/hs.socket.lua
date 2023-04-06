--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Talk to custom protocols using asynchronous TCP sockets.
--
-- For UDP sockets see [`hs.socket.udp`](./hs.socket.udp.html).
--
-- `hs.socket` is implemented with [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket). CocoaAsyncSocket's [tagging features](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Intro_GCDAsyncSocket#reading--writing) provide a handy way to implement custom protocols.
--
-- For example, you can easily implement a basic HTTP client as follows (though using [`hs.http`](./hs.http.html) is recommended for the real world):
--
-- ```lua
-- local TAG_HTTP_HEADER, TAG_HTTP_CONTENT = 1, 2
-- local body = ""
-- local function httpCallback(data, tag)
--   if tag == TAG_HTTP_HEADER then
--     print(tag, "TAG_HTTP_HEADER"); print(data)
--     local contentLength = data:match("\r\nContent%-Length: (%d+)\r\n")
--     client:read(tonumber(contentLength), TAG_HTTP_CONTENT)
--   elseif tag == TAG_HTTP_CONTENT then
--     print(tag, "TAG_HTTP_CONTENT"); print(data)
--     body = data
--   end
-- end
--
-- client = hs.socket.new(httpCallback):connect("google.com", 80)
-- client:write("GET /index.html HTTP/1.0\r\nHost: google.com\r\n\r\n")
-- client:read("\r\n\r\n", TAG_HTTP_HEADER)
-- ```
--
-- Resulting in the following console output (adjust log verbosity with `hs.socket.setLogLevel()`) :
--
-- ```
--             LuaSkin: (secondary thread): TCP socket connected
--             LuaSkin: (secondary thread): Data written to TCP socket
--             LuaSkin: (secondary thread): Data read from TCP socket
-- 1 TAG_HTTP_HEADER
-- HTTP/1.0 301 Moved Permanently
-- Location: http://www.google.com/index.html
-- Content-Type: text/html; charset=UTF-8
-- Date: Thu, 03 Mar 2016 08:38:02 GMT
-- Expires: Sat, 02 Apr 2016 08:38:02 GMT
-- Cache-Control: public, max-age=2592000
-- Server: gws
-- Content-Length: 229
-- X-XSS-Protection: 1; mode=block
-- X-Frame-Options: SAMEORIGIN
--
--             LuaSkin: (secondary thread): Data read from TCP socket
-- 2 TAG_HTTP_CONTENT
-- &lt;HTML&gt;&lt;HEAD&gt;&lt;meta http-equiv=&quot;content-type&quot; content=&quot;text/html;charset=utf-8&quot;&gt;
-- &lt;TITLE&gt;301 Moved&lt;/TITLE&gt;&lt;/HEAD&gt;&lt;BODY&gt;
-- &lt;H1&gt;301 Moved&lt;/H1&gt;
-- The document has moved
-- &lt;A HREF=&quot;http://www.google.com/index.html&quot;&gt;here&lt;/A&gt;.
-- &lt;/BODY&gt;&lt;/HTML&gt;
--             LuaSkin: (secondary thread): TCP socket disconnected Socket closed by remote peer
-- ```
--
-- 
---@class hs.socket
local M = {}
hs.socket = M

-- Connects an unconnected socket.
--
-- Parameters:
--  * `host` - A string containing the hostname or IP address.
--  * `port` - A port number [1-65535].
--  * `path` - A string containing the path to the Unix domain socket.
--  * `fn` - An optional single-use callback function to execute after establishing the connection. The callback receives no parameters.
--
-- Returns:
--  * The [`hs.socket`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * Either a host/port pair OR a Unix domain socket path must be supplied. If no port is passed, the first parameter is assumed to be a path to the socket file.
-- 
function M:connect(host, port_or_path, fn, ...) end

-- Returns the connection status of the socket.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if the socket is connected, otherwise `false`.
--
-- Notes:
--  * If the socket is bound for listening, this method returns `true` if there is at least one connection.
-- 
---@return boolean
function M:connected() end

-- Returns the number of connections to the socket.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The number of connections to the socket.
--
-- Notes:
--  * This method returns at most 1 for default (non-listening) sockets.
-- 
---@return number
function M:connections() end

-- Disconnects the socket, freeing it for reuse.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The [`hs.socket`](#new) object.
--
-- Notes:
--  * If called on a listening socket with multiple connections, each client is disconnected.
-- 
---@return hs.socket
function M:disconnect() end

-- Returns information about the socket.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing the following keys:
--    * connectedAddress - `string` (`sockaddr` struct)
--    * connectedHost - `string`
--    * connectedPort - `number`
--    * connectedURL - `string`
--    * connections - `number`
--    * isConnected - `boolean`
--    * isDisconnected - `boolean`
--    * isIPv4 - `boolean`
--    * isIPv4Enabled - `boolean`
--    * isIPv4PreferredOverIPv6 - `boolean`
--    * isIPv6 - `boolean`
--    * isIPv6Enabled - `boolean`
--    * isSecure - `boolean`
--    * localAddress - `string` (`sockaddr` struct)
--    * localHost - `string`
--    * localPort - `number`
--    * timeout - `number`
--    * unixSocketPath - `string`
--    * userData - `string`
-- 
function M:info() end

-- Binds an unconnected socket to either a port or path (Unix domain socket) for listening.
--
-- Parameters:
--  * `port` - A port number [0-65535]. Ports [1-1023] are privileged. Port 0 allows the OS to select any available port.
--  * `path` - A string containing the path to the Unix domain socket.
--
-- Returns:
--  * The [`hs.socket`](#new) object, or `nil` if an error occurred.
-- 
function M:listen(port_or_path, ...) end

-- Creates an unconnected asynchronous TCP socket object.
--
-- Parameters:
--  * `fn` - An optional [callback function](#setCallback) for reading data from the socket, settable here for convenience.
--
-- Returns:
--  * An [`hs.socket`](#new) object.
-- 
---@return hs.socket
function M.new(fn) end

-- Parses a binary socket address structure into a readable table.
--
-- Parameters:
--  * `sockaddr` - A binary socket address structure, usually obtained from the [`info`](#info) method or in [`hs.socket.udp`](./hs.socket.udp.html)'s [read callback](./hs.socket.udp.html#setCallback).
--
-- Returns:
--  * A table describing the address with the following keys or `nil`:
--   * host - A string containing the host IP.
--   * port - A number containing the port.
--   * addressFamily - A number containing the address family.
--
-- Notes:
--  * Some address family definitions from `<sys/socket.h>`:
--
-- address family | number | description
-- :--- | :--- | :
-- AF_UNSPEC | 0 | unspecified
-- AF_UNIX | 1 | local to host (pipes)
-- AF_LOCAL | AF_UNIX | backward compatibility
-- AF_INET | 2 | internetwork: UDP, TCP, etc.
-- AF_NS | 6 | XEROX NS protocols
-- AF_CCITT | 10 | CCITT protocols, X.25 etc
-- AF_APPLETALK | 16 | Apple Talk
-- AF_ROUTE | 17 | Internal Routing Protocol
-- AF_LINK | 18 | Link layer interface
-- AF_INET6 | 30 | IPv6
-- 
function M.parseAddress(sockaddr, ...) end

-- Read data from the socket.
--
-- Parameters:
--  * `delimiter` - Either a number of bytes to read, or a string delimiter such as "\\n" or "\\r\\n". Data is read up to and including the delimiter.
--  * `tag` - An optional integer to assist with labeling reads. It is passed to the callback to assist with implementing [state machines](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Intro_GCDAsyncSocket#reading--writing) for processing complex protocols.
--
-- Returns:
--  * The [`hs.socket`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * Results are passed to the socket's [callback function](#setCallback), which must be set to use this method.
--  * If called on a listening socket with multiple connections, data is read from each of them.
-- 
function M:read(delimiter, tag, ...) end

-- Alias for [`hs.socket:read`](#read)
-- 
---@return hs.socket
function M:receive(delimiter, tag, ...) end

-- Alias for [`hs.socket:write`](#write)
-- 
---@return hs.socket
function M:send(message, tag, ...) end

-- Creates a TCP socket, and binds it to either a port or path (Unix domain socket) for listening.
--
-- Parameters:
--  * `port` - A port number [0-65535]. Ports [1-1023] are privileged. Port 0 allows the OS to select any available port.
--  * `path` - A string containing the path to the Unix domain socket.
--  * `fn` - An optional [callback function](#setCallback) for reading data from the socket, settable here for convenience.
--
-- Returns:
--  * An [`hs.socket`](#new) object.
-- 
---@return hs.socket
function M.server(port_or_path, fn, ...) end

-- Sets the read callback for the socket.
--
-- Parameters:
--  * `fn` - An optional callback function to process data read from the socket. `nil` or no argument clears the callback. The callback receives 2 parameters:
--    * `data` - The data read from the socket as a string.
--    * `tag` - The integer tag associated with the read call, which defaults to `-1`.
--
-- Returns:
--  * The [`hs.socket`](#new) object.
--
-- Notes:
--  * A callback must be set in order to read data from the socket.
-- 
---@return hs.socket
function M:setCallback(fn) end

-- Sets the timeout for the socket operations.
--
-- Parameters:
--  * `timeout` - A number containing the timeout duration, in seconds.
--
-- Returns:
--  * The [`hs.socket`](#new) object.
--
-- Notes:
--  *  If the timeout value is negative, the operations will not use a timeout, which is the default.
-- 
---@return hs.socket
function M:setTimeout(timeout, ...) end

-- Secures the socket with TLS.
--
-- Parameters:
--  * `verify` - An optional boolean that, if `false`, allows TLS handshaking with servers with self-signed certificates and does not evaluate the chain of trust. Defaults to `true` and omitted if `peerName` is supplied
--  * `peerName` - An optional string containing the fully qualified domain name of the peer to validate against — for example, `store.apple.com`. It should match the name in the X.509 certificate given by the remote party. See the important security note below.
--
-- Returns:
--  * The [`hs.socket`](#new) object.
--
-- Notes:
--  * The socket will disconnect immediately if TLS negotiation fails.
--  * **IMPORTANT SECURITY NOTE**: The default settings will check to make sure the remote party's certificate is signed by a trusted 3rd party certificate agency (e.g. verisign) and that the certificate is not expired.  However it will not verify the name on the certificate unless you give it a name to verify against via `peerName`.  The security implications of this are important to understand.  Imagine you are attempting to create a secure connection to MySecureServer.com, but your socket gets directed to MaliciousServer.com because of a hacked DNS server.  If you simply use the default settings, and MaliciousServer.com has a valid certificate, the default settings will not detect any problems since the certificate is valid.  To properly secure your connection in this particular scenario you should set `peerName` to "MySecureServer.com".
-- 
---@return hs.socket
function M:startTLS(verify, peerName, ...) end

-- Timeout for the socket operations, in seconds.
--
-- Notes:
--  * New [`hs.socket`](#new) objects will be created with this timeout value, but can individually change it with the [`hs.socket:setTimeout`](#setTimeout) method.
--
--  * If the timeout value is negative, the operations will not use a timeout. The default value is `-1`.
-- 
M.timeout = nil

-- Write data to the socket.
--
-- Parameters:
--  * `message` - A string containing data to be sent on the socket.
--  * `tag` - An optional integer to assist with labeling writes.
--  * `fn` - An optional single-use callback function to execute after writing data to the socket. The callback receives the tag parameter provided here.
--
-- Returns:
--  * The [`hs.socket`](#new) object.
--
-- Notes:
--  * If called on a listening socket with multiple connections, data is broadcast to all connected sockets.
-- 
---@return hs.socket
function M:write(message, tag, fn, ...) end

