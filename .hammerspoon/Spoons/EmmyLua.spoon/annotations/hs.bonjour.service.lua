--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Represents the service records that are discovered or published by the hs.bonjour module.
--
-- This module allows you to explore the details of discovered services including ip addresses and text records, and to publish your own multicast DNS advertisements for services on your computer. This can be useful to advertise network services provided by other Hammerspoon modules or other applications on your computer which do not publish their own advertisements already.
--
-- This module will *not* allow you to publish proxy records for other hosts on your local network.
-- Additional submodules which may address this limitation as well as provide additional functions available with Apple's dns-sd library are being considered but there is no estimated timeframe at present.
---@class hs.bonjour.service
local M = {}
hs.bonjour.service = M

-- Returns a table listing the addresses for the service represented by the serviceObject
--
-- Parameters:
--  * None
--
-- Returns:
--  * an array table of strings representing the IPv4 and IPv6 address of the machine which provides the services represented by the serviceObject
--
-- Notes:
--  * for remote serviceObjects, the table will be empty if this method is invoked before [hs.bonjour.service:resolve](#resolve).
--  * for local (published) serviceObjects, this table will always be empty.
function M:addresses() end

-- Returns the domain the service represented by the serviceObject belongs to.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string containing the domain the service represented by the serviceObject belongs to.
--
-- Notes:
--  * for remote serviceObjects, this domain will be the domain the service was discovered in.
--  * for local (published) serviceObjects, this domain will be the domain the service is published in; if you did not specify a domain with [hs.bonjour.service.new](#new) then this will be an empty string until [hs.bonjour.service:publish](#publish) is invoked.
---@return string
function M:domain() end

-- Returns the hostname of the machine the service represented by the serviceObject belongs to.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string containing the hostname of the machine the service represented by the serviceObject belongs to.
--
-- Notes:
--  * for remote serviceObjects, this will be nil if this method is invoked before [hs.bonjour.service:resolve](#resolve).
--  * for local (published) serviceObjects, this method will always return nil.
---@return string
function M:hostname() end

-- Get or set whether the service represented by the service object should be published or resolved over peer-to-peer Bluetooth and Wi-Fi, if available.
--
-- Parameters:
--  * `value` - an optional boolean, default false, specifying whether advertising and resolving should occur over peer-to-peer Bluetooth and Wi-Fi, if available.
--
-- Returns:
--  * if `value` is provided, returns the serviceObject; otherwise returns the current value.
--
-- Notes:
--  * if you are changing the value of this property, you must call this method before invoking [hs.bonjour.service:publish](#publish] or [hs.bonjour.service:resolve](#resolve), or after stopping publishing or resolving with [hs.bonjour.service:stop](#stop).
--
--  * for remote serviceObjects, this flag determines if resolution and text record monitoring should occur over peer-to-peer network interfaces.
--  * for local (published) serviceObjects, this flag determines if advertising should occur over peer-to-peer network interfaces.
function M:includesPeerToPeer(value, ...) end

-- Monitor the service for changes to its associated text records.
--
-- Parameters:
--  * `callback` - an optional callback function which should expect 3 arguments:
--    * the serviceObject userdata
--    * the string "txtRecord"
--    * a table containing key-value pairs specifying the new text records for the service
--
-- Returns:
--  * the serviceObject
--
-- Notes:
--  * When monitoring is active, [hs.bonjour.service:txtRecord](#txtRecord) will return the most recent text records observed. If this is the only method by which you check the text records, but you wish to ensure you have the most recent values, you should invoke this method without specifying a callback.
--
--  * When [hs.bonjour.service:resolve](#resolve) is invoked, the text records at the time of resolution are captured for retrieval with [hs.bonjour.service:txtRecord](#txtRecord). Subsequent changes to the text records will not be reflected by [hs.bonjour.service:txtRecord](#txtRecord) unless this method has been invoked (with or without a callback function) and is currently active.
--
--  * You *can* monitor for text changes on local serviceObjects that were created by [hs.bonjour.service.new](#new) and that you are publishing. This can be used to invoke a callback when one portion of your code makes changes to the text records you are publishing and you need another portion of your code to be aware of this change.
function M:monitor(callback, ...) end

-- Returns the name of the service represented by the serviceObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string containing the name of the service represented by the serviceObject.
---@return string
function M:name() end

-- Returns a new serviceObject for advertising a service provided by your computer.
--
-- Parameters:
--  * `name`    - The name of the service being advertised. This does not have to be the hostname of the machine. However, if you specify an empty string, the computers hostname will be used.
--  * `service` - a string specifying the service being advertised. This string should be specified in the format of '_service._protocol.' where _protocol is one of '_tcp' or '_udp'. Examples of common service types can be found in `hs.bonjour.serviceTypes`.
--  * `port`    - an integer specifying the tcp or udp port the service is provided at
--  * `domain`  - an optional string specifying the domain you wish to advertise this service in.
--
-- Returns:
--  * the newly created service object, or nil if there was an error
--
-- Notes:
--  * If the name specified is not unique on the network for the service type specified, then a number will be appended to the end of the name. This behavior cannot be overridden and can only be detected by checking [hs.bonjour.service:name](#name) after [hs.bonjour.service:publish](#publish) is invoked to see if the name has been changed from what you originally assigned.
--
--  * The service will not be advertised until [hs.bonjour.service:publish](#publish) is invoked on the serviceObject returned.
--
--  * If you do not specify the `domain` parameter, your default domain, usually "local" will be used.
function M.new(name, service, port, domain, ...) end

-- Returns the port the service represented by the serviceObject is available on.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a number specifying the port the service represented by the serviceObject is available on.
--
-- Notes:
--  * for remote serviceObjects, this will be -1 if this method is invoked before [hs.bonjour.service:resolve](#resolve).
--  * for local (published) serviceObjects, this method will always return the number specified when the serviceObject was created with the [hs.bonjour.service.new](#new) constructor.
---@return number
function M:port() end

-- Begin advertising the specified local service.
--
-- Parameters:
--  * `allowRename` - an optional boolean, default true, specifying whether to automatically rename the service if the name and type combination is already being published in the service's domain. If renaming is allowed and a conflict occurs, the service name will have `-#` appended to it where `#` is an increasing integer starting at 2.
--  * `callback`    - an optional callback function which should expect 2 or 3 arguments and return none. The arguments to the callback function will be one of the following sets:
--    * on successful publishing:
--      * the serviceObject userdata
--      * the string "published"
--    * if an error occurs during publishing:
--      * the serviceObject userdata
--      * the string "error"
--      * a string specifying the specific error that occurred
--
-- Returns:
--  * the serviceObject
--
-- Notes:
--  * this method should only be called on serviceObjects which were created with [hs.bonjour.service.new](#new).
function M:publish(allowRename, callback, ...) end

-- Returns a new serviceObject for a remote machine (i.e. not the users computer) on your network offering the specified service.
--
-- Parameters:
--  * `name`    - a string specifying the name of the advertised service on the network to locate. Often, but not always, this will be the hostname of the machine providing the desired service.
--  * `service` - a string specifying the service type. This string should be specified in the format of '_service._protocol.' where _protocol is one of '_tcp' or '_udp'. Examples of common service types can be found in `hs.bonjour.serviceTypes`.
--  * `domain`  - an optional string specifying the domain the service belongs to.
--
-- Returns:
--  * the newly created service object, or nil if there was an error
--
-- Notes:
--  * In general you should not need to use this constructor, as they will be created automatically for you in the callbacks to `hs.bonjour:findServices`.
--  * This method can be used, however, when you already know that a specific service should exist on the network and you wish to resolve its current IP addresses or text records.
--
--  * Resolution of the service ip address, hostname, port, and current text records will not occur until [hs.bonjour.service:publish](#publish) is invoked on the serviceObject returned.
--
--  * The macOS API specifies that an empty domain string (i.e. specifying the `domain` parameter as "" or leaving it off completely) should result in using the default domain for the computer; in my experience this results in an error when attempting to resolve the serviceObject's ip addresses if I don't specify "local" explicitly. In general this shouldn't be an issue if you limit your use of remote serviceObjects to those returned by `hs.bonjour:findServices` as the domain of discovery will be included in the object for you automatically. If you do try to create these objects independently yourself, be aware that attempting to use the "default domain" rather than specifying it explicitly will probably not work as expected.
function M.remote(name, service, domain, ...) end

-- Resolve the address and details for a discovered service.
--
-- Parameters:
--  * `timeout`  - an optional number, default 0.0, specifying the maximum number of seconds to attempt to resolve the details for this service. Specifying 0.0 means that the resolution should not timeout and that resolution should continue indefinitely.
--  * `callback` - an optional callback function which should expect 2 or 3 arguments and return none.
--    * on successful resolution:
--      * the serviceObject userdata
--      * the string "resolved"
--    * if an error occurs during resolution:
--      * the serviceObject userdata
--      * the string "error"
--      * a string specifying the specific error that occurred
--    * if `timeout` is specified and is any number other than 0.0, the following will be sent to the callback when the timeout has been reached:
--      * the serviceObject userdata
--      * the string "stop"
--
-- Returns:
--  * the serviceObject
--
-- Notes:
--  * this method should only be called on serviceObjects which were returned by an `hs.bonjour` browserObject or created with [hs.bonjour.service.remote](#remote).
--
--  * For a remote service, this method must be called in order to retrieve the [addresses](#addresses), the [port](#port), the [hostname](#hostname), and any the associated [text records](#txtRecord) for the service.
--  * To reduce the usage of system resources, you should generally specify a timeout value or make sure to invoke [hs.bonjour.service:stop](#stop) after you have verified that you have received the details you require.
function M:resolve(timeout, callback, ...) end

-- A list of common service types which can used for discovery through this module.
--
-- Notes:
--  * This list was generated from the output of `avahi-browse -b` and `avahi-browse -bk` from the avahi-daemon/stable,now 0.7-4+b1 armhf package under Raspbian GNU/Linux 10.
--  * This list is by no means complete and is provided solely for the purposes of providing examples. Additional service types can be discovered quite easily using Google or other search engines.
--  * You can view the contents of this table in the Hammerspoon Console by entering `require("hs.bonjour").serviceTypes` into the input field.
MTypes = nil

-- Stop advertising or resolving the service specified by the serviceObject
--
-- Parameters:
--  * None
--
-- Returns:
--  * the serviceObject
--
-- Notes:
--  * this method will stop the advertising of a service which has been published with [hs.bonjour.service:publish](#publish) or is being resolved with [hs.bonjour.service:resolve](#resolve).
--
--  * To reduce the usage of system resources, you should make sure to use this method when resolving a remote service if you did not specify a timeout for [hs.bonjour.service:resolve](#resolve) or specified a timeout of 0.0 once you have verified that you have the details you need.
function M:stop() end

-- Stop monitoring a service for changes to its text records.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the serviceObject
--
-- Notes:
--  * This method will stop updating [hs.bonjour.service:txtRecord](#txtRecord) and invoking the callback, if any, assigned with [hs.bonjour.service:monitor](#monitor).
function M:stopMonitoring() end

-- Get or set the text records associated with the serviceObject.
--
-- Parameters:
--  * `records` - an optional table specifying the text record for the advertised service as a series of key-value entries. All keys and values must be specified as strings.
--
-- Returns:
--  * if an argument is provided to this method, returns the serviceObject or false if there was a problem setting the text record for this service. If no argument is provided, returns the current table of text records.
--
-- Notes:
--  * for remote serviceObjects, this method will return nil if invoked before [hs.bonjour.service:resolve](#resolve)
--  * setting the text record for a service replaces the existing records for the serviceObject. If the serviceObject is remote, this change is only visible on the local machine. For a service you are advertising, this change will be advertised to other machines.
--
--  * Text records are usually used to provide additional information concerning the service and their purpose and meanings are service dependant; for example, when advertising an `_http._tcp.` service, you can specify a specific path on the server by specifying a table of text records containing the "path" key.
function M:txtRecord(records, ...) end

-- Returns the type of service represented by the serviceObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string containing the type of service represented by the serviceObject.
---@return string
function M:type() end

