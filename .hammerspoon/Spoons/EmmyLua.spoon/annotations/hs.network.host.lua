--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This sub-module provides functions for acquiring host information, such as hostnames, addresses, and reachability.
---@class hs.network.host
local M = {}
hs.network.host = M

-- Get IP addresses for the hostname specified.
--
-- Parameters:
--  * name - the hostname to lookup IP addresses for
--  * fn   - an optional callback function which, when provided, will perform the address resolution in an asynchronous, non-blocking manner.
--
-- Returns:
--  * If this function is called without a callback function, returns a table containing the IP addresses for the specified name.  If a callback function is specified, then a host object is returned.
--
-- Notes:
--  * If no callback function is provided, the resolution occurs in a blocking manner which may be noticeable when network access is slow or erratic.
--  * If a callback function is provided, this function acts as a constructor, returning a host object and the callback function will be invoked when resolution is complete.  The callback function should take two parameters: the string "addresses", indicating that an address resolution occurred, and a table containing the IP addresses identified.
--  * Generates an error if network access is currently disabled or the hostname is invalid.
function M.addressesForHostname(name, fn, ...) end

-- Cancels an in-progress asynchronous host resolution.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the hostObject
--
-- Notes:
--  * This method has no effect if the resolution has already completed.
function M:cancel() end

-- Get hostnames for the IP address specified.
--
-- Parameters:
--  * address - a string or number representing an IPv4 or IPv6 network address to lookup hostnames for.  If the argument is a number, it is treated as the 32 bit numerical representation of an IPv4 address.
--  * fn      - an optional callback function which, when provided, will perform the hostname resolution in an asynchronous, non-blocking manner.
--
-- Returns:
--  * If this function is called without a callback function, returns a table containing the hostnames for the specified address.  If a callback function is specified, then a host object is returned.
--
-- Notes:
--  * If no callback function is provided, the resolution occurs in a blocking manner which may be noticeable when network access is slow or erratic.
--  * If a callback function is provided, this function acts as a constructor, returning a host object and the callback function will be invoked when resolution is complete.  The callback function should take two parameters: the string "names", indicating that hostname resolution occurred, and a table containing the hostnames identified.
--  * Generates an error if network access is currently disabled or the IP address is invalid.
function M.hostnamesForAddress(address, fn, ...) end

-- Returns whether or not resolution is still in progress for an asynchronous query.
--
-- Parameters:
--  * None
--
-- Returns:
--  * true, if resolution is still in progress, or false if resolution has already completed.
---@return boolean
function M:isRunning() end

-- Get the reachability status for the IP address specified.
--
-- Parameters:
--  * address - a string or number representing an IPv4 or IPv6 network address to check the reachability for.  If the argument is a number, it is treated as the 32 bit numerical representation of an IPv4 address.
--  * fn      - an optional callback function which, when provided, will determine the address reachability in an asynchronous, non-blocking manner.
--
-- Returns:
--  * If this function is called without a callback function, returns the numeric representation of the address reachability status.  If a callback function is specified, then a host object is returned.
--
-- Notes:
--  * If no callback function is provided, the resolution occurs in a blocking manner which may be noticeable when network access is slow or erratic.
--  * If a callback function is provided, this function acts as a constructor, returning a host object and the callback function will be invoked when resolution is complete.  The callback function should take two parameters: the string "reachability", indicating that reachability was determined, and the numeric representation of the address reachability status.
--  * Generates an error if network access is currently disabled or the IP address is invalid.
--  * The numeric representation is made up from a combination of the flags defined in `hs.network.reachability.flags`.
--  * Performs the same reachability test as `hs.network.reachability.forAddress`.
function M.reachabilityForAddress(address, fn, ...) end

-- Get the reachability status for the IP address specified.
--
-- Parameters:
--  * name - the hostname to check the reachability for.  If the argument is a number, it is treated as the 32 bit numerical representation of an IPv4 address.
--  * fn   - an optional callback function which, when provided, will determine the address reachability in an asynchronous, non-blocking manner.
--
-- Returns:
--  * If this function is called without a callback function, returns the numeric representation of the hostname reachability status.  If a callback function is specified, then a host object is returned.
--
-- Notes:
--  * If no callback function is provided, the resolution occurs in a blocking manner which may be noticeable when network access is slow or erratic.
--  * If a callback function is provided, this function acts as a constructor, returning a host object and the callback function will be invoked when resolution is complete.  The callback function should take two parameters: the string "reachability", indicating that reachability was determined, and the numeric representation of the hostname reachability status.
--  * Generates an error if network access is currently disabled or the IP address is invalid.
--  * The numeric representation is made up from a combination of the flags defined in `hs.network.reachability.flags`.
--  * Performs the same reachability test as `hs.network.reachability.forHostName`.
function M.reachabilityForHostname(name, fn, ...) end

