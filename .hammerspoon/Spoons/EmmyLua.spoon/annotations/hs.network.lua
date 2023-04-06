--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module provides functions for inquiring about and monitoring changes to the network.
---@class hs.network
local M = {}
hs.network = M

-- Returns a list of the IPv4 and IPv6 addresses for the specified interfaces, or all interfaces if no arguments are given.
--
-- Parameters:
--  * interface_list - The interface names to return the IP addresses for. It should be specified as one of the following:
--    * one or more interface names, separated by a comma
--    * if the first argument is a table, it is assumes to be a table containing a list of interfaces and this list is used instead, ignoring any additional arguments that may be provided
--    * if no arguments are specified, then the results of [hs.network.interfaces](#interfaces) is used.
--
-- Returns:
--  * A table containing a list of the IP addresses for the interfaces as determined by the arguments provided.
--
-- Notes:
--  * The order of the IP addresses returned is undefined.
--  * If no arguments are provided, then this function returns the same results as `hs.host.addresses`, but does not block.
function M.addresses(interface_list, ...) end

-- Returns details about the specified interface or the primary interface if no interface is specified.
--
-- Parameters:
--  * interface - an optional string specifying the interface to retrieve details about.  Defaults to the primary interface if not specified.
--  * favorIPv6 - an optional boolean specifying whether or not to prefer the primary IPv6 or the primary IPv4 interface if `interface` is not specified.  Defaults to false.
--
-- Returns:
--  * A table containing key-value pairs describing interface details.  Returns an empty table if no primary interface can be determined. Logs an error and returns nil if there was a problem retrieving this information.
--
-- Notes:
--  * When determining the primary interface, the `favorIPv6` flag only determines interface search order.  If you specify true for this flag, but no primary IPv6 interface exists (i.e. your DHCP server only provides an IPv4 address an IPv6 is limited to local only traffic), then the primary IPv4 interface will be used instead.
function M.interfaceDetails(interface_or_favorIPv6, ...) end

-- Returns the user defined name for the specified interface or the primary interface if no interface is specified.
--
-- Parameters:
--  * interface - an optional string specifying the interface to retrieve the name for.  Defaults to the primary interface if not specified.
--  * favorIPv6 - an optional boolean specifying whether or not to prefer the primary IPv6 or the primary IPv4 interface if `interface` is not specified.  Defaults to false.
--
-- Returns:
--  * A string containing the user defined name for the interface, if one exists, or false if the interface does not have a user defined name. Logs an error and returns nil if there was a problem retrieving this information.
--
-- Notes:
--  * Only interfaces which show up in the System Preferences Network panel will have a user defined name.
--
--  * When determining the primary interface, the `favorIPv6` flag only determines interface search order.  If you specify true for this flag, but no primary IPv6 interface exists (i.e. your DHCP server only provides an IPv4 address an IPv6 is limited to local only traffic), then the primary IPv4 interface will be used instead.
---@return string
function M.interfaceName(interface_or_favorIPv6, ...) end

-- Returns a list of interfaces currently active for the system.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing a list of the interfaces active for the system.  Logs an error and returns nil if there was a problem retrieving this information.
--
-- Notes:
--  * The names of the interfaces returned by this function correspond to the interface's BSD name, not the user defined name that shows up in the System Preferences's Network panel.
--  * This function returns *all* interfaces, even ones used by the system that are not directly manageable by the user.
function M.interfaces() end

-- Returns the names of the primary IPv4 and IPv6 interfaces.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The name of the primary IPv4 interface or false if there isn't one, and the name of the IPv6 interface or false if there isn't one. Logs an error and returns a single nil if there was a problem retrieving this information.
--
-- Notes:
--  * The IPv4 and IPv6 interface names are often, but not always, the same.
function M.primaryInterfaces() end

