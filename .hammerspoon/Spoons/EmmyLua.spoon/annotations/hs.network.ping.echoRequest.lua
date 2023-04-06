--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Provides lower-level access to the ICMP Echo Request infrastructure used by the hs.network.ping module. In general, you should not need to use this module directly unless you have specific requirements not met by the hs.network.ping module and the `hs.network.ping` object methods.
--
-- This module is based heavily on Apple's SimplePing sample project which can be found at https://developer.apple.com/library/content/samplecode/SimplePing/Introduction/Intro.html.
--
-- When a callback function argument is specified as an ICMP table, the Lua table returned will contain the following key-value pairs:
--  * `checksum`       - The ICMP packet checksum used to ensure data integrity.
--  * `code`           - ICMP Control Message Code. This should always be 0 unless the callback has received a "receivedUnexpectedPacket" message.
--  * `identifier`     - The ICMP packet identifier.  This should match the results of [hs.network.ping.echoRequest:identifier](#identifier) unless the callback has received a "receivedUnexpectedPacket" message.
--  * `payload`        - A string containing the ICMP payload for this packet. The default payload has been constructed to cause the ICMP packet to be exactly 64 bytes to match the convention for ICMP Echo Requests.
--  * `sequenceNumber` - The ICMP Sequence Number for this packet.
--  * `type`           - ICMP Control Message Type. Unless the callback has received a "receivedUnexpectedPacket" message, this will be 0 (ICMPv4) or 129 (ICMPv6) for packets we receive and 8 (ICMPv4) or 128 (ICMPv6) for packets we send.
--  * `_raw`           - A string containing the ICMP packet as raw data.
--
-- In cases where the callback receives a "receivedUnexpectedPacket" message because the packet is corrupted or truncated, this table may only contain the `_raw` field.
---@class hs.network.ping.echoRequest
local M = {}
hs.network.ping.echoRequest = M

-- Get or set the address family the echoRequestObject should communicate with.
--
-- Parameters:
--  * `family` - an optional string, default "any", which specifies the address family used by this object.  Valid values are "any", "IPv4", and "IPv6".
--
-- Returns:
--  * if an argument is provided, returns the echoRequestObject, otherwise returns the current value.
--
-- Notes:
--  * Setting this value to "IPv6" or "IPv4" will cause the echoRequestObject to attempt to resolve the server's name into an IPv6 address or an IPv4 address and communicate via ICMPv6 or ICMP(v4) when the [hs.network.ping.echoRequest:start](#start) method is invoked.  A callback with the message "didFail" will occur if the server could not be resolved to an address in the specified family.
--  * If this value is set to "any", then the first address which is discovered for the server's name will determine whether ICMPv6 or ICMP(v4) is used, based upon the family of the address.
--
--  * Setting a value with this method will have no immediate effect on an echoRequestObject which has already been started with [hs.network.ping.echoRequest:start](#start). You must first stop and then restart the object for any change to have an effect.
function M:acceptAddressFamily(family, ...) end

-- Creates a new ICMP Echo Request object for the server specified.
--
-- Parameters:
--  * `server` - a string containing the hostname or ip address of the server to communicate with. Both IPv4 and IPv6 style addresses are supported.
--
-- Returns:
--  * an echoRequest object
--
-- Notes:
--  * This constructor returns a lower-level object than the `hs.network.ping.ping` constructor and is more difficult to use. It is recommended that you use this constructor only if `hs.network.ping.ping` is not sufficient for your needs.
--
--  * For convenience, you can call this constructor as `hs.network.ping.echoRequest(server)`
function M.echoRequest(server, ...) end

-- Returns a string representation for the server's IP address, or a boolean if address resolution has not completed yet.
--
-- Parameters:
--  * None
--
-- Returns:
--  * If the object has been started and address resolution has completed, then the string representation of the server's IP address is returned.
--  * If the object has been started, but resolution is still pending, returns a boolean value of false.
--  * If the object has not been started, returns nil.
function M:hostAddress() end

-- Returns the host address family currently in use by this echoRequestObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string indicating the IP address family currently used by this echoRequestObject.  It will be one of the following values:
--    * "IPv4"       - indicates that ICMP(v4) packets are being sent and listened for.
--    * "IPv6"       - indicates that ICMPv6 packets are being sent and listened for.
--    * "unresolved" - indicates that the echoRequestObject has not been started or that address resolution is still in progress.
---@return string
function M:hostAddressFamily() end

-- Returns the name of the target host as provided to the echoRequestObject's constructor
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string containing the hostname as specified when the object was created.
---@return string
function M:hostName() end

-- Returns the identifier number for the echoRequestObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an integer specifying the identifier which is embedded in the ICMP packets this object sends.
--
-- Notes:
--  * ICMP Echo Replies which include this identifier will generate a "receivedPacket" message to the object callback, while replies which include a different identifier will generate a "receivedUnexpectedPacket" message.
---@return number
function M:identifier() end

-- Returns a boolean indicating whether or not this echoRequestObject is currently listening for ICMP Echo Replies.
--
-- Parameters:
--  * None
--
-- Returns:
--  * true if the object is currently listening for ICMP Echo Replies, or false if it is not.
---@return boolean
function M:isRunning() end

-- The sequence number that will be used for the next ICMP packet sent by this object.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an integer specifying the sequence number that will be embedded in the next ICMP message sent by this object when [hs.network.ping.echoRequest:sendPayload](#sendPayload) is invoked.
--
-- Notes:
--  * ICMP Echo Replies which are expected by this object should always be less than this number, with the caveat that this number is a 16-bit integer which will wrap around to 0 after sending a packet with the sequence number 65535.
--  * Because of this wrap around effect, this module will generate a "receivedPacket" message to the object callback whenever the received packet has a sequence number that is within the last 120 sequence numbers we've sent and a "receivedUnexpectedPacket" otherwise.
--    * Per the comments in Apple's SimplePing.m file: Why 120?  Well, if we send one ping per second, 120 is 2 minutes, which is the standard "max time a packet can bounce around the Internet" value.
---@return number
function M:nextSequenceNumber() end

-- Get or set whether or not the callback should receive all unexpected packets or only those which carry our identifier.
--
-- Parameters:
--  * `state` - an optional boolean, default false, specifying whether or not all unexpected packets or only those which carry our identifier should generate a "receivedUnexpectedPacket" callback message.
--
-- Returns:
--  * if an argument is provided, returns the echoRequestObject; otherwise returns the current value
--
-- Notes:
--  * The nature of ICMP packet reception is such that all listeners receive all ICMP packets, even those which belong to another process or echoRequestObject.
--    * By default, a valid packet (i.e. with a valid checksum) which does not contain our identifier is ignored since it was not intended for our receiver.  Only corrupt or packets with our identifier but that were otherwise unexpected will generate a "receivedUnexpectedPacket" callback message.
--    * This method optionally allows the echoRequestObject to receive *all* incoming packets, even ones which are expected by another process or echoRequestObject.
--  * If you wish to examine ICMPv6 router advertisement and neighbor discovery packets, you should set this property to true. Note that this module does not provide the necessary tools to decode these packets at present, so you will have to decode them yourself if you wish to examine their contents.
function M:seeAllUnexpectedPackets(state, ...) end

-- Sends a single ICMP Echo Request packet.
--
-- Parameters:
--  * `payload` - an optional string containing the data to include in the ICMP Echo Request as the packet payload.
--
-- Returns:
--  * If the object has been started and address resolution has completed, then the ICMP Echo Packet is sent and this method returns the echoRequestObject
--  * If the object has been started, but resolution is still pending, the packet is not sent and this method returns a boolean value of false.
--  * If the object has not been started, the packet is not sent and this method returns nil.
--
-- Notes:
--  * By convention, unless you are trying to test for specific network fragmentation or congestion problems, ICMP Echo Requests are generally 64 bytes in length (this includes the 8 byte header, giving 56 bytes of payload data).  If you do not specify a payload, a default payload which will result in a packet size of 64 bytes is constructed.
function M:sendPayload(payload, ...) end

-- Set or remove the object callback function
--
-- Parameters:
--  * `fn` - a function to set as the callback function for this object, or nil if you wish to remove any existing callback function.
--
-- Returns:
--  * the echoRequestObject
--
-- Notes:
--  * The callback function should expect between 3 and 5 arguments and return none. The possible arguments which are sent will be one of the following:
--
--    * "didStart" - indicates that the object has resolved the address of the server and is ready to begin sending and receiving ICMP Echo packets.
--      * `object`  - the echoRequestObject itself
--      * `message` - the message to the callback, in this case "didStart"
--      * `address` - a string representation of the IPv4 or IPv6 address of the server specified to the constructor.
--
--    * "didFail" - indicates that the object has failed, either because the address could not be resolved or a network error has occurred.
--      * `object`  - the echoRequestObject itself
--      * `message` - the message to the callback, in this case "didFail"
--      * `error`   - a string describing the error that occurred.
--    * Notes:
--      * When this message is received, you do not need to call [hs.network.ping.echoRequest:stop](#stop) -- the object will already have been stopped.
--
--    * "sendPacket" - indicates that the object has sent an ICMP Echo Request packet.
--      * `object`  - the echoRequestObject itself
--      * `message` - the message to the callback, in this case "sendPacket"
--      * `icmp`    - an ICMP packet table representing the packet which has been sent as described in the header of this module's documentation.
--      * `seq`     - the sequence number for this packet. Sequence numbers always start at 0 and increase by 1 every time the [hs.network.ping.echoRequest:sendPayload](#sendPayload) method is called.
--
--    * "sendPacketFailed" - indicates that the object failed to send the ICMP Echo Request packet.
--      * `object`  - the echoRequestObject itself
--      * `message` - the message to the callback, in this case "sendPacketFailed"
--      * `icmp`    - an ICMP packet table representing the packet which was to be sent.
--      * `seq`     - the sequence number for this packet.
--      * `error`   - a string describing the error that occurred.
--    * Notes:
--      * Unlike "didFail", the echoRequestObject is not stopped when this message occurs; you can try to send another payload if you wish without restarting the object first.
--
--    * "receivedPacket" - indicates that an expected ICMP Echo Reply packet has been received by the object.
--      * `object`  - the echoRequestObject itself
--      * `message` - the message to the callback, in this case "receivedPacket"
--      * `icmp`    - an ICMP packet table representing the packet received.
--      * `seq`     - the sequence number for this packet.
--
--    * "receivedUnexpectedPacket" - indicates that an unexpected ICMP packet was received
--      * `object`  - the echoRequestObject itself
--      * `message` - the message to the callback, in this case "receivedUnexpectedPacket"
--      * `icmp`    - an ICMP packet table representing the packet received.
--    * Notes:
--      * This message can occur for a variety of reasons, the most common being:
--        * the ICMP packet is corrupt or truncated and cannot be parsed
--        * the ICMP Identifier does not match ours and the sequence number is not one we have sent
--        * the ICMP type does not match an ICMP Echo Reply
--        * When using IPv6, this is especially common because IPv6 uses ICMP for network management functions like Router Advertisement and Neighbor Discovery.
--      * In general, it is reasonably safe to ignore these messages, unless you are having problems receiving anything else, in which case it could indicate problems on your network that need addressing.
function M:setCallback(fn) end

-- Start the echoRequestObject by resolving the server's address and start listening for ICMP Echo Reply packets.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the echoRequestObject
function M:start() end

-- Stop listening for ICMP Echo Reply packets with this object.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the echoRequestObject
function M:stop() end

