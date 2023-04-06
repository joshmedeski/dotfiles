--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Find and publish network services advertised by multicast DNS (Bonjour) with Hammerspoon.
--
-- This module will allow you to discover services advertised on your network through multicast DNS and publish services offered by your computer.
---@class hs.bonjour
local M = {}
hs.bonjour = M

-- Return a list of zero-conf and bonjour domains visible to the users computer.
--
-- Parameters:
--  * `callback` - a function which will be invoked as visible domains are discovered. The function should accept the following parameters and return none:
--    * `browserObject`    - the userdata object for the browserObject which initiated the search
--    * `type`             - a string which will be 'domain' or 'error'
--      * if `type` == 'domain', the remaining arguments will be:
--        * `added`        - a boolean value indicating whether this callback invocation represents a newly discovered or added domain (true) or that the domain has been removed from the network (false)
--        * `domain`       - a string specifying the name of the domain discovered or removed
--        * `moreExpected` - a boolean value indicating whether or not the browser expects to discover additional domains or not.
--      * if `type` == 'error', the remaining arguments will be:
--        * `errorString`  - a string specifying the error which has occurred
--
-- Returns:
--  * the browserObject
--
-- Notes:
--  * This method returns domains which are visible to your machine; however, your machine may or may not be able to access or publish records within the returned domains. See  [hs.bonjour:findRegistrationDomains](#findRegistrationDomains)
--
--  * For most non-corporate network users, it is likely that the callback will only be invoked once for the `local` domain. This is normal. Corporate networks or networks including Linux machines using additional domains defined with Avahi may see additional domains as well, though most Avahi installations now use only 'local' by default unless specifically configured to do otherwise.
--
--  * When `moreExpected` becomes false, it is the macOS's best guess as to whether additional records are available.
--    * Generally macOS is fairly accurate in this regard concerning domain searches, so to reduce the impact on system resources, it is recommended that you use [hs.bonjour:stop](#stop) when this parameter is false
function M:findBrowsableDomains(callback, ...) end

-- Return a list of zero-conf and bonjour domains this computer can register services in.
--
-- Parameters:
--  * `callback` - a function which will be invoked as domains are discovered. The function should accept the following parameters and return none:
--    * `browserObject`    - the userdata object for the browserObject which initiated the search
--    * `type`             - a string which will be 'domain' or 'error'
--      * if `type` == 'domain', the remaining arguments will be:
--        * `added`        - a boolean value indicating whether this callback invocation represents a newly discovered or added domain (true) or that the domain has been removed from the network (false)
--        * `domain`       - a string specifying the name of the domain discovered or removed
--        * `moreExpected` - a boolean value indicating whether or not the browser expects to discover additional domains or not.
--      * if `type` == 'error', the remaining arguments will be:
--        * `errorString`  - a string specifying the error which has occurred
--
-- Returns:
--  * the browserObject
--
-- Notes:
--  * This is the preferred method for accessing domains as it guarantees that the host machine can connect to services in the returned domains. Access to domains outside this list may be more limited. See also [hs.bonjour:findBrowsableDomains](#findBrowsableDomains)
--
--  * For most non-corporate network users, it is likely that the callback will only be invoked once for the `local` domain. This is normal. Corporate networks or networks including Linux machines using additional domains defined with Avahi may see additional domains as well, though most Avahi installations now use only 'local' by default unless specifically configured to do otherwise.
--
--  * When `moreExpected` becomes false, it is the macOS's best guess as to whether additional records are available.
--    * Generally macOS is fairly accurate in this regard concerning domain searches, so to reduce the impact on system resources, it is recommended that you use [hs.bonjour:stop](#stop) when this parameter is false
function M:findRegistrationDomains(callback, ...) end

-- Find advertised services of the type specified.
--
-- Parameters:
--  * `type`     - a string specifying the type of service to discover on your network. This string should be specified in the format of '_service._protocol.' where _protocol is one of '_tcp' or '_udp'. Examples of common service types can be found in [hs.bonjour.serviceTypes](#serviceTypes).
--  * `domain`   - an optional string specifying the domain to look for advertised services in. The domain should end with a period. If you omit this parameter, the default registration domain will be used, usually "local."
--  * `callback` - a callback function which will be invoked as service advertisements meeting the specified criteria are discovered. The callback function should expect 2-5 arguments as follows:
--    * if a service is discovered or advertising for the service is terminated, the arguments will be:
--      * the browserObject
--      * the string "domain"
--      * a boolean indicating whether the service is being advertised (true) or should be removed because advertisements for the service are being terminated (false)
--      * the serviceObject for the specific advertisement (see `hs.bonjour.service`)
--      * a boolean indicating if more advertisements are expected (true) or if the macOS believes that there are no more advertisements to be discovered (false).
--    * if an error occurs, the callback arguments will be:
--      * the browserObject
--      * the string "error"
--      * a string specifying the specific error that occurred
--
-- Returns:
--  * the browserObject
--
-- Notes:
--  * macOS will indicate when it believes there are no more advertisements of the type specified by `type` in `domain` by marking the last argument to your callback function as false. This is a best guess and may not always be accurate if your network is slow or some servers on your network are particularly slow to respond.
--  * In addition, if you leave the browser running this method, you will get future updates when services are removed because of server shutdowns or added because of new servers being booted up.
--  * Leaving the browser running does consume some system resources though, so you will have to determine, based upon your specific requirements, if this is a concern for your specific task or not. To terminate the browser when you have retrieved all of the information you require, you can use the [hs.bonjour:stop](#stop) method.
--
--  * The special type "_services._dns-sd._udp." can be used to discover the types of services being advertised on your network. The `hs.bonjour.service` objects returned to the callback function cannot actually be resolved, but you can use the `hs.bonjour.service:name` method to create a list of services that are currently present and being advertised.
--    * this special type is used by the shortcut function [hs.bonjour.networkServices](#networkServices) for this specific purpose.
--
--  * The special domain "dns-sd.org." can be specified to find services advertised through Wide-Area Service Discovery as described at http://www.dns-sd.org. This can be used to discover a limited number of globally available sites on the internet, especially with a service type of `_http._tcp.`.
--    * In theory, with additional software, you may be able to publish services on your machine for Wide-Area Service discovery using this domain with `hs.bonjour.service.new` but the local dns server requirements and security implications of doing so are beyond the scope of this documentation. You should refer to http://www.dns-sd.org and your local DNS Server administrator or provider for more details.
function M:findServices(type, domain, callback, ...) end

-- Get or set whether to also browse over peer-to-peer Bluetooth and Wi-Fi, if available.
--
-- Parameters:
--  * `value` - an optional boolean, default false, value specifying whether to also browse over peer-to-peer Bluetooth and Wi-Fi, if available.
--
-- Returns:
--  * if `value` is provided, returns the browserObject; otherwise returns the current value for this property
--
-- Notes:
--  * This property must be set before initiating a search to have an effect.
function M:includesPeerToPeer(value, ...) end

-- Polls a host for the service types it is advertising via multicast DNS.
--
-- Parameters:
--  * `target`   - a string specifying the target host to query for advertised service types
--  * `callback` - a callback function which will be invoked when the service type query has completed. The callback should expect one argument which will either be an array of strings specifying the service types the target is advertising or a string specifying the error that occurred.
--
-- Returns:
--  * None
--
-- Notes:
--  * this function may not work for all clients implementing multicast DNS; it has been successfully tested with macOS and Linux targets running the Avahi Daemon service, but has generally returned an error when used with minimalist implementations found in common IOT devices and embedded electronics.
function M.machineServices(target, callback, ...) end

-- Returns a list of service types being advertised on your local network.
--
-- Parameters:
--  * `callback` - a callback function which will be invoked when the services query has completed. The callback should expect one argument: an array of strings specifying the service types discovered on the local network.
--  * `timeout`  - an optional number, default 5, specifying the maximum number of seconds after the most recently received service type Hammerspoon should wait trying to identify advertised service types before finishing its query and invoking the callback.
--
-- Returns:
--  * None
--
-- Notes:
--  * This function is a convenience wrapper to [hs.bonjour:findServices](#findServices) which collects the results from multiple callbacks made to `findServices` and returns them all at once to the callback function provided as an argument to this function.
--
--  * Because this function collects the results of multiple callbacks before invoking its own callback, the `timeout` value specified indicates the maximum number of seconds to wait after the latest value received by `findServices` unless the macOS specifies that it believes there are no more service types to identify.
--    * This is a best guess made by the macOS which may not always be accurate if your local network is particularly slow or if there are machines on your network which are slow to respond.
--    * See [hs.bonjour:findServices](#findServices) for more details if you need to create your own query which can persist for longer periods of time or require termination logic that ignores the macOS's best guess.
function M.networkServices(callback, timeout, ...) end

-- Creates a new network service browser that finds published services on a network using multicast DNS.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a new browserObject or nil if an error occurs
function M.new() end

-- Stops a currently running search or resolution for the browser object
--
-- Parameters:
--  * None
--
-- Returns:
--  * the browserObject
--
-- Notes:
--  * This method should be invoked when you have identified the services or hosts you require to reduce the consumption of system resources.
--  * Invoking this method on an already idle browser will do nothing
--
--  * In general, when your callback function for [hs.bonjour:findBrowsableDomains](#findBrowsableDomains), [hs.bonjour:findRegistrationDomains](#findRegistrationDomains), or [hs.bonjour:findServices](#findServices) receives false for the `moreExpected` parameter, you should invoke this method on the browserObject unless there are specific reasons not to. Possible reasons you might want to extend the life of the browserObject are documented within each method.
function M:stop() end

