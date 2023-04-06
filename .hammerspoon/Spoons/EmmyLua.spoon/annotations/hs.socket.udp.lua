--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Talk to custom protocols using asynchronous UDP sockets.
--
-- For TCP sockets see [`hs.socket`](./hs.socket.html).
--
-- You can do a lot of neat trivial and non-trivial things with these. A simple ping ponger:
-- ```lua
-- function ping(data, addr)
--   print(data)
--   addr = hs.socket.parseAddress(addr)
--   hs.timer.doAfter(1, function()
--     client:send("ping", addr.host, addr.port)
--   end)
-- end
--
-- function pong(data, addr)
--   print(data)
--   addr = hs.socket.parseAddress(addr)
--   hs.timer.doAfter(1, function()
--     server:send("pong", addr.host, addr.port)
--   end)
-- end
--
-- server = hs.socket.udp.server(9001, pong):receive()
-- client = hs.socket.udp.new(ping):send("ping", "localhost", 9001):receive()
-- ```
-- Resulting in the following endless exchange:
-- ```
-- 20:26:56    LuaSkin: (secondary thread): Data written to UDP socket
--             LuaSkin: (secondary thread): Data read from UDP socket
-- ping
-- 20:26:57    LuaSkin: (secondary thread): Data written to UDP socket
--             LuaSkin: (secondary thread): Data read from UDP socket
-- pong
-- 20:26:58    LuaSkin: (secondary thread): Data written to UDP socket
--             LuaSkin: (secondary thread): Data read from UDP socket
-- ping
-- 20:26:59    LuaSkin: (secondary thread): Data written to UDP socket
--             LuaSkin: (secondary thread): Data read from UDP socket
-- pong
-- ...
-- ```
--
-- You can do some silly things with a callback factory and enabling broadcasting:
-- ```lua
-- local function callbackMaker(name)
--   local fun = function(data, addr)
--     addr = hs.socket.parseAddress(addr)
--     print(name.." received data:\n"..data.."\nfrom host: "..addr.host.." port: "..addr.port)
--   end
--   return fun
-- end
--
-- local listeners = {}
-- local port = 9001
--
-- for i=1,3 do
--   table.insert(listeners, hs.socket.udp.new(callbackMaker("listener "..i)):reusePort():listen(port):receive())
-- end
--
-- broadcaster = hs.socket.udp.new():broadcast()
-- broadcaster:send("hello!", "255.255.255.255", port)
-- ```
-- Since neither IPv4 nor IPv6 have been disabled, the broadcast is received on both protocols ('dual-stack' IPv6 addresses shown):
-- ```
-- listener 2 received data:
-- hello!
-- from host: ::ffff:192.168.0.3 port: 53057
-- listener 1 received data:
-- hello!
-- from host: ::ffff:192.168.0.3 port: 53057
-- listener 3 received data:
-- hello!
-- from host: ::ffff:192.168.0.3 port: 53057
-- listener 1 received data:
-- hello!
-- from host: 192.168.0.3 port: 53057
-- listener 3 received data:
-- hello!
-- from host: 192.168.0.3 port: 53057
-- listener 2 received data:
-- hello!
-- from host: 192.168.0.3 port: 53057
-- ```
-- 
---@class hs.socket.udp
local M = {}
hs.socket.udp = M

-- Enables broadcasting on the underlying socket.
--
-- Parameters:
--  * `flag` - An optional boolean: `true` to enable broadcasting, `false` to disable it. Defaults to `true`.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * By default, the underlying socket in the OS will not allow you to send broadcast messages.
--  * In order to send broadcast messages, you need to enable this functionality in the socket.
--  * A broadcast is a UDP message to addresses like "192.168.255.255" or "255.255.255.255" that is delivered to every host on the network.
--  * The reason this is generally disabled by default (by the OS) is to prevent accidental broadcast messages from flooding the network.
-- 
function M:broadcast(flag, ...) end

-- Immediately closes the socket, freeing it for reuse. Any pending send operations are discarded.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object.
-- 
---@return hs.socket.udp
function M:close() end

-- Returns the closed status of the socket.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if the socket is closed, otherwise `false`.
--
-- Notes:
--  * UDP sockets are typically meant to be connectionless.
--  * Sending a packet anywhere, regardless of whether or not the destination receives it, opens the socket until it is explicitly closed.
--  * An active listening socket will not be closed, but will not be 'connected' unless the [`hs.socket.udp:connect`](#connect) method has been called.
-- 
---@return boolean
function M:closed() end

-- Connects an unconnected socket.
--
-- Parameters:
--  * `host` - A string containing the hostname or IP address.
--  * `port` - A port number [1-65535].
--  * `fn` - An optional single-use callback function to execute after establishing the connection. The callback receives no parameters.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
--
-- Notes:
-- * By design, UDP is a connectionless protocol, and connecting is not needed.
-- * Choosing to connect to a specific host/port has the following effect:
--   * You will only be able to send data to the connected host/port;
--   * You will only be able to receive data from the connected host/port;
--   * You will receive ICMP messages that come from the connected host/port, such as "connection refused".
-- * The actual process of connecting a UDP socket does not result in any communication on the socket, it simply changes the internal state of the socket.
-- * You cannot bind a socket for listening after it has been connected.
-- * You can only connect a socket once.
-- 
function M:connect(host, port, fn, ...) end

-- Returns the connection status of the socket.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if connected, otherwise `false`.
--
-- Notes:
--  * UDP sockets are typically meant to be connectionless.
--  * This method will only return `true` if the [`hs.socket.udp:connect`](#connect) method has been explicitly called.
-- 
---@return boolean
function M:connected() end

-- Enables or disables IPv4 or IPv6 on the underlying socket. By default, both are enabled.
--
-- Parameters:
--  * `version` - A number containing the IP version (4 or 6) to enable or disable.
--  * `flag` - A boolean: `true` to enable the chosen IP version, `false` to disable it. Defaults to `true`.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * Must be called before binding the socket. If you want to create an IPv6-only server, do something like:
--    * `hs.socket.udp.new(callback):enableIPv(4, false):listen(port):receive()`
--  * The convenience constructor [`hs.socket.server`](#server) will automatically bind the socket and requires closing and relistening to use this method.
-- 
function M:enableIPv(version, flag, ...) end

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
--    * isClosed - `boolean`
--    * isConnected - `boolean`
--    * isIPv4 - `boolean`
--    * isIPv4Enabled - `boolean`
--    * isIPv4Preferred - `boolean`
--    * isIPv6 - `boolean`
--    * isIPv6Enabled - `boolean`
--    * isIPv6Preferred - `boolean`
--    * isIPVersionNeutral - `boolean`
--    * localAddress - `string` (`sockaddr` struct)
--    * localAddress_IPv4 - `string` (`sockaddr` struct)
--    * localAddress_IPv6 - `string` (`sockaddr` struct)
--    * localHost - `string`
--    * localHost_IPv4 - `string`
--    * localHost_IPv6 - `string`
--    * localPort - `number`
--    * localPort_IPv4 - `number`
--    * localPort_IPv6 - `number`
--    * maxReceiveIPv4BufferSize - `number`
--    * maxReceiveIPv6BufferSize - `number`
--    * timeout - `number`
--    * userData - `string`
-- 
function M:info() end

-- Binds an unconnected socket to a port for listening.
--
-- Parameters:
--  * `port` - A port number [0-65535]. Ports [1-1023] are privileged. Port 0 allows the OS to select any available port.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
-- 
function M:listen(port, ...) end

-- Creates an unconnected asynchronous UDP socket object.
--
-- Parameters:
--  * `fn` - An optional [callback function](#setCallback) for reading data from the socket, settable here for convenience.
--
-- Returns:
--  * An [`hs.socket.udp`](#new) object.
-- 
---@return hs.socket.udp
function M.new(fn) end

-- Alias for [`hs.socket.parseAddress`](./hs.socket.html#parseAddress)
-- 
function M.parseAddress(sockaddr, ...) end

-- Suspends reading of packets from the socket.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object
--
-- Notes:
--  * Call one of the receive methods to resume.
-- 
---@return hs.socket.udp
function M:pause() end

-- Sets the preferred IP version: IPv4, IPv6, or neutral (first to resolve).
--
-- Parameters:
--  * `version` - An optional number containing the IP version to prefer. Anything but 4 or 6 else sets the default neutral behavior.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object.
--
-- Notes:
--  * If a DNS lookup returns only IPv4 results, the socket will automatically use IPv4.
--  * If a DNS lookup returns only IPv6 results, the socket will automatically use IPv6.
--  * If a DNS lookup returns both IPv4 and IPv6 results, then the protocol used depends on the configured preference.
-- 
---@return hs.socket.udp
function M:preferIPv(version, ...) end

-- Alias for [`hs.socket.udp:receive`](#receive)
-- 
---@return hs.socket.udp
function M:read(delimiter, tag, ...) end

-- Alias for [`hs.socket.udp:receiveOne`](#receiveOne)
-- 
---@return hs.socket.udp
function M:readOne(delimiter, tag, ...) end

-- Reads packets from the socket as they arrive.
--
-- Parameters:
--  * `fn` - Optionally supply the [read callback](#setCallback) here.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * Results are passed to the [callback function](#setCallback), which must be set to use this method.
--  * There are two modes of operation for receiving packets: one-at-a-time & continuous.
--  * In one-at-a-time mode, you call receiveOne every time you are ready process an incoming UDP packet.
--  * Receiving packets one-at-a-time may be better suited for implementing certain state machine code where your state machine may not always be ready to process incoming packets.
--  * In continuous mode, the callback is invoked immediately every time incoming udp packets are received.
--  * Receiving packets continuously is better suited to real-time streaming applications.
--  * You may switch back and forth between one-at-a-time mode and continuous mode.
--  * If the socket is currently in one-at-a-time mode, calling this method will switch it to continuous mode.
-- 
function M:receive(fn) end

-- Reads a single packet from the socket.
--
-- Parameters:
--  * `fn` - Optionally supply the [read callback](#setCallback) here.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * Results are passed to the [callback function](#setCallback), which must be set to use this method.
--  * There are two modes of operation for receiving packets: one-at-a-time & continuous.
--  * In one-at-a-time mode, you call receiveOne every time you are ready process an incoming UDP packet.
--  * Receiving packets one-at-a-time may be better suited for implementing certain state machine code where your state machine may not always be ready to process incoming packets.
--  * In continuous mode, the callback is invoked immediately every time incoming udp packets are received.
--  * Receiving packets continuously is better suited to real-time streaming applications.
--  * You may switch back and forth between one-at-a-time mode and continuous mode.
--  * If the socket is currently in continuous mode, calling this method will switch it to one-at-a-time mode
-- 
function M:receiveOne(fn) end

-- Enables port reuse on the socket.
--
-- Parameters:
--  * `flag` - An optional boolean: `true` to enable port reuse, `false` to disable it. Defaults to `true`.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object, or `nil` if an error occurred.
--
-- Notes:
--  * By default, only one socket can be bound to a given IP address & port at a time.
--  * To enable multiple processes to simultaneously bind to the same address & port, you need to enable this functionality in the socket.
--  * All processes that wish to use the address & port simultaneously must all enable reuse port on the socket bound to that port.
--  * Must be called before binding the socket.
-- 
function M:reusePort(flag, ...) end

-- Sends a packet to the destination address.
--
-- Parameters:
--  * `message` - A string containing data to be sent on the socket.
--  * `host` - A string containing the hostname or IP address.
--  * `port` - A port number [1-65535].
--  * `tag` - An optional integer to assist with labeling writes.
--  * `fn` - An optional single-use callback function to execute after sending the packet. The callback receives the tag parameter provided here.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object.
--
-- Notes:
--  * For non-connected sockets, the remote destination is specified for each packet.
--  * If the socket has been explicitly connected with [`connect`](#connect), only the message parameter and an optional tag and/or write callback can be supplied.
--  * Recall that connecting is optional for a UDP socket.
--  * For connected sockets, data can only be sent to the connected address.
-- 
---@return hs.socket.udp
function M:send(message, host, port, tag, fn, ...) end

-- Creates a UDP socket, and binds it to a port for listening.
--
-- Parameters:
--  * `port` - A port number [0-65535]. Ports [1-1023] are privileged. Port 0 allows the OS to select any available port.
--  * `fn` - An optional [callback function](#setCallback) for reading data from the socket, settable here for convenience.
--
-- Returns:
--  * An [`hs.socket.udp`](#new) object.
-- 
---@return hs.socket.udp
function M.server(port, fn, ...) end

-- Sets the maximum size of the buffer that will be allocated for receive operations.
--
-- Parameters:
--  * `size` - An number containing the receive buffer size in bytes.
--  * `version` - An optional number containing the IP version for which to set the buffer size. Anything but 4 or 6 else sets the same size for both.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object.
--
-- Notes:
--  * The default maximum size is 9216 bytes.
--  * The theoretical maximum size of any IPv4 UDP packet is `UINT16_MAX = 65535`.
--  * The theoretical maximum size of any IPv6 UDP packet is `UINT32_MAX = 4294967295`.
--  * Since the OS notifies us of the size of each received UDP packet, the actual allocated buffer size for each packet is exact.
--  * In practice the size of UDP packets is generally much smaller than the max. Most protocols will send and receive packets of only a few bytes, or will set a limit on the size of packets to prevent fragmentation in the IP layer.
--  * If you set the buffer size too small, the sockets API in the OS will silently discard any extra data.
-- 
---@return hs.socket.udp
function M:setBufferSize(size, version, ...) end

-- Sets the read callback for the socket.
--
-- Parameters:
--  * `fn` - An optional callback function to process data read from the socket. `nil` or no argument clears the callback. The callback receives 2 parameters:
--    * `data` - The data read from the socket as a string.
--    * `sockaddr` - The sending address as a binary socket address structure. See [`parseAddress`](#parseAddress).
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object.
--
-- Notes:
--  * A callback must be set in order to read data from the socket.
-- 
---@return hs.socket.udp
function M:setCallback(fn) end

-- Sets the timeout for the socket operations.
--
-- Parameters:
--  * `timeout` - A number containing the timeout duration, in seconds.
--
-- Returns:
--  * The [`hs.socket.udp`](#new) object.
--
-- Notes:
--  *  If the timeout value is negative, the operations will not use a timeout, which is the default.
-- 
---@return hs.socket.udp
function M:setTimeout(timeout, ...) end

-- Timeout for the socket operations, in seconds.
--
-- Notes:
--  * New [`hs.socket.udp`](#new) objects will be created with this timeout value, but can individually change it with the [`hs.socket.udp:setTimeout`](#setTimeout) method.
--
--  * If the timeout value is negative, the operations will not use a timeout. The default value is `-1`.
-- 
M.timeout = nil

-- Alias for [`hs.socket.udp:send`](#send)
-- 
---@return hs.socket.udp
function M:write(message, tag, ...) end

