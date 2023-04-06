--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module provides a basic ping function which can test host availability. Ping is a network diagnostic tool commonly found in most operating systems which can be used to test if a route to a specified host exists and if that host is responding to network traffic.
---@class hs.network.ping
local M = {}
hs.network.ping = M

-- Returns a string containing the resolved IPv4 or IPv6 address this pingObject is sending echo requests to.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the IPv4 or IPv6 address this pingObject is sending echo requests to or "<unresolved address>" if the address cannot be resolved.
---@return string
function M:address() end

-- Cancels an in progress ping process, terminating it immediately
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * the `didFinish` message will be sent to the callback function as its final message.
function M:cancel() end

-- Get or set the number of ICMP Echo Requests that will be sent by the ping process
--
-- Parameters:
--  * `count` - an optional integer specifying the total number of echo requests that the ping process should send. If specified, this number must be greater than the number of requests already sent.
--
-- Returns:
--  * if no argument is specified, returns the current number of echo requests the ping process will send; if an argument is specified and the ping process has not completed, returns the pingObject; if the ping process has already completed, then this method returns nil.
function M:count(count, ...) end

-- Returns whether or not the ping process is currently paused.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating if the ping process is paused (true) or not (false)
---@return boolean
function M:isPaused() end

-- Returns whether or not the ping process is currently active.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating if the ping process is active (true) or not (false)
--
-- Notes:
--  * This method will return false only if the ping process has finished sending all echo requests or if it has been cancelled with [hs.network.ping:cancel](#cancel).  To determine if the process is currently sending out echo requests, see [hs.network.ping:isPaused](#isPaused).
---@return boolean
function M:isRunning() end

-- Returns a table containing information about the ICMP Echo packets sent by this pingObject.
--
-- Parameters:
--  * `sequenceNumber` - an optional integer specifying the sequence number of the ICMP Echo packet to return information about.
--
-- Returns:
--  * If `sequenceNumber` is specified, returns a table with key-value pairs containing information about the specific ICMP Echo packet with that sequence number, or an empty table if no packet with that sequence number has been sent yet. If no sequence number is specified, returns an array table of all ICMP Echo packets this object has sent.
--
-- Notes:
--  * Sequence numbers start at 0 while Lua array tables are indexed starting at 1. If you do not specify a `sequenceNumber` to this method, index 1 of the array table returned will contain a table describing the ICMP Echo packet with sequence number 0, index 2 will describe the ICMP Echo packet with sequence number 1, etc.
--
--  * An ICMP Echo packet table will have the following key-value pairs:
--    * `sent`           - a number specifying the time at which the echo request for this packet was sent. This number is the number of seconds since January 1, 1970 at midnight, GMT, and is a floating point number, so you should use `math.floor` on this number before using it as an argument to Lua's `os.date` function.
--    * `recv`           - a number specifying the time at which the echo reply for this packet was received. This number is the number of seconds since January 1, 1970 at midnight, GMT, and is a floating point number, so you should use `math.floor` on this number before using it as an argument to Lua's `os.date` function.
--    * `icmp`           - a table provided by the `hs.network.ping.echoRequest` object which contains the details about the specific ICMP packet this entry corresponds to. It will contain the following keys:
--      * `checksum`       - The ICMP packet checksum used to ensure data integrity.
--      * `code`           - ICMP Control Message Code. Should always be 0.
--      * `identifier`     - The ICMP Identifier generated internally for matching request and reply packets.
--      * `payload`        - A string containing the ICMP payload for this packet. This has been constructed to cause the ICMP packet to be exactly 64 bytes to match the convention for ICMP Echo Requests.
--      * `sequenceNumber` - The ICMP Sequence Number for this packet.
--      * `type`           - ICMP Control Message Type. For ICMPv4, this will be 0 if a reply has been received or 8 no reply has been received yet. For ICMPv6, this will be 129 if a reply has been received or 128 if no reply has been received yet.
--      * `_raw`           - A string containing the ICMP packet as raw data.
function M:packets(sequenceNumber, ...) end

-- Pause an in progress ping process.
--
-- Parameters:
--  * None
--
-- Returns:
--  * if the ping process is currently active, returns the pingObject; if the process has already completed, returns nil.
function M:pause() end

-- Test server availability by pinging it with ICMP Echo Requests.
--
-- Parameters:
--  * `server`   - a string containing the hostname or ip address of the server to test. Both IPv4 and IPv6 addresses are supported.
--  * `count`    - an optional integer, default 5, specifying the number of ICMP Echo Requests to send to the server.
--  * `interval` - an optional number, default 1.0, in seconds specifying the delay between the sending of each echo request. To set this parameter, you must supply `count` as well.
--  * `timeout`  - an optional number, default 2.0, in seconds specifying how long before an echo reply is considered to have timed-out. To set this parameter, you must supply `count` and `interval` as well.
--  * `class`    - an optional string, default "any", specifying whether IPv4 or IPv6 should be used to send the ICMP packets. The string must be one of the following:
--    * `any`  - uses the IP version which corresponds to the first address the `server` resolves to
--    * `IPv4` - use IPv4; if `server` cannot resolve to an IPv4 address, or if IPv4 traffic is not supported on the network, the ping will fail with an error.
--    * `IPv6` - use IPv6; if `server` cannot resolve to an IPv6 address, or if IPv6 traffic is not supported on the network, the ping will fail with an error.
--  * `fn`       - the callback function which receives update messages for the ping process. See the Notes for details regarding the callback function.
--
-- Returns:
--  * a pingObject
--
-- Notes:
--  * For convenience, you can call this constructor as `hs.network.ping(server, ...)`
--  * the full ping process will take at most `count` * `interval` + `timeout` seconds from `didStart` to `didFinish`.
--
--  * the default callback function, if `fn` is not specified, prints the results of each echo reply as they are received to the Hammerspoon console and a summary once completed. The output should be familiar to anyone who has used `ping` from the command line.
--
--  * If you provide your own callback function, it should expect between 2 and 4 arguments and return none. The possible arguments which are sent will be one of the following:
--
--    * "didStart" - indicates that address resolution has completed and the ping will begin sending ICMP Echo Requests.
--      * `object`  - the ping object the callback is for
--      * `message` - the message to the callback, in this case "didStart"
--
--    * "didFail" - indicates that the ping process has failed, most likely due to a failure in address resolution or because the network connection has dropped.
--      * `object`  - the ping object the callback is for
--      * `message` - the message to the callback, in this case "didFail"
--      * `error`   - a string containing the error message that has occurred
--
--    * "sendPacketFailed" - indicates that a specific ICMP Echo Request has failed for some reason.
--      * `object`         - the ping object the callback is for
--      * `message`        - the message to the callback, in this case "sendPacketFailed"
--      * `sequenceNumber` - the sequence number of the ICMP packet which has failed to send
--      * `error`          - a string containing the error message that has occurred
--
--    * "receivedPacket" - indicates that an ICMP Echo Request has received the expected ICMP Echo Reply
--      * `object`         - the ping object the callback is for
--      * `message`        - the message to the callback, in this case "receivedPacket"
--      * `sequenceNumber` - the sequence number of the ICMP packet received
--
--    * "didFinish" - indicates that the ping has finished sending all ICMP Echo Requests or has been cancelled
--      * `object`  - the ping object the callback is for
--      * `message` - the message to the callback, in this case "didFinish"
function M.ping(server, count, interval, timeout, class, fn, ...) end

-- Resume an in progress ping process, if it has been paused.
--
-- Parameters:
--  * None
--
-- Returns:
--  * if the ping process is currently active, returns the pingObject; if the process has already completed, returns nil.
function M:resume() end

-- Returns the number of ICMP Echo Requests which have been sent.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The number of echo requests which have been sent so far.
---@return number
function M:sent() end

-- Returns the hostname or ip address string given to the [hs.network.ping.ping](#ping) constructor.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string matching the hostname or ip address given to the [hs.network.ping.ping](#ping) constructor for this object.
---@return string
function M:server() end

-- Set or remove the callback function for the pingObject.
--
-- Parameters:
--  * `fn` - the function to set as the callback, or nil if you wish use the default callback.
--
-- Returns:
--  * the pingObject
--
-- Notes:
--  * Because the ping process begins immediately upon creation with the [hs.network.ping.ping](#ping) constructor, it is preferable to assign the callback with the constructor itself.
--  * This method is provided as a means of changing the callback based on other events (a change in the current network or location, perhaps.)
--  * If you truly wish to create a pingObject with no callback, you will need to do something like `hs.network.ping.ping(...):setCallback(function() end)`.
function M:setCallback(fn) end

-- Returns a string containing summary information about the ping process.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a summary string for the current state of the ping process
--
-- Notes:
--  * The summary string will look similar to the following:
-- ~~~
-- --- hostname ping statistics
-- 5 packets transmitted, 5 packets received, 0.0 packet loss
-- round-trip min/avg/max = 2.282/4.133/4.926 ms
-- ~~~
--  * The number of packets received will match the number that has currently been sent, not necessarily the value returned by [hs.network.ping:count](#count).
---@return string
function M:summary() end

