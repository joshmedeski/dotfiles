--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Allows Hammerspoon to respond to URLs
-- Hammerspoon is configured to react to URLs that start with `hammerspoon://` when they are opened by OS X.
-- This extension allows you to register callbacks for these URL events and their parameters, offering a flexible way to receive events from other applications.
--
-- You can also choose to make Hammerspoon the default for `http://` and `https://` URLs, which lets you route the URLs in your Lua code
--
-- Given a URL such as `hammerspoon://someEventToHandle?someParam=things&otherParam=stuff`, in the literal, RFC1808 sense of the URL, `someEventToHandle` is the hostname (or net_loc) of the URL, but given that these are not network resources, we consider `someEventToHandle` to be the name of the event. No path should be specified in the URL - it should consist purely of a hostname and, optionally, query parameters.
--
-- See also `hs.ipc` for a command line IPC mechanism that is likely more appropriate for shell scripts or command line use. Unlike `hs.ipc`, `hs.urlevent` is not able to return any data to its caller.
--
-- NOTE: If Hammerspoon is not running when a `hammerspoon://` URL is opened, Hammerspoon will be launched, but it will not react to the URL event. Nor will it react to any events until this extension is loaded and event callbacks have been bound.
-- NOTE: Any event which is received, for which no callback has been bound, will be logged to the Hammerspoon Console
-- NOTE: When you trigger a URL from another application, it is usually best to have the URL open in the background, if that option is available. Otherwise, OS X will activate Hammerspoon (i.e. give it focus), which makes URL events difficult to use for things like window management.
---@class hs.urlevent
local M = {}
hs.urlevent = M

-- Registers a callback for a hammerspoon:// URL event
--
-- Parameters:
--  * eventName - A string containing the name of an event
--  * callback - A function that will be called when the specified event is received, or nil to remove an existing callback
--
-- Returns:
--  * None
--
-- Notes:
--  * The callback function should accept two parameters:
--   * eventName - A string containing the name of the event
--   * params - A table containing key/value string pairs containing any URL parameters that were specified in the URL
--   * senderPID - An integer containing the PID of the sending application, if available (otherwise -1)
--  * Given the URL `hammerspoon://doThingA?value=1` The event name is `doThingA` and the callback's `params` argument will be a table containing `{["value"] = "1"}`
function M.bind(eventName, callback, ...) end

-- Gets all of the application bundle identifiers of applications able to handle a URL scheme
--
-- Parameters:
--  * scheme - A string containing a URL scheme (e.g. 'http')
--
-- Returns:
--  * A table containing the bundle identifiers of all applications that can handle the scheme
function M.getAllHandlersForScheme(scheme, ...) end

-- Gets the application bundle identifier of the application currently registered to handle a URL scheme
--
-- Parameters:
--  * scheme - A string containing a URL scheme (e.g. 'http')
--
-- Returns:
--  * A string containing the bundle identifier of the current default application
---@return string
function M.getDefaultHandler(scheme, ...) end

-- A function that should handle http:// and https:// URL events
--
-- Notes:
--  * The function should handle four arguments:
--   * scheme - A string containing the URL scheme (i.e. "http")
--   * host - A string containing the host requested (e.g. "www.hammerspoon.org")
--   * params - A table containing the key/value pairs of all the URL parameters
--   * fullURL - A string containing the full, original URL
--   * senderPID - An integer containing the PID of the application that opened the URL, if available (otherwise -1)
M.httpCallback = nil

-- A function that should handle mailto: URL events
--
-- Notes:
--  * The function should handle four arguments:
--   * scheme - A string containing the URI scheme (i.e. "mailto")
--   * host - A string containing the host requested (typically nil)
--   * params - A table containing the key/value pairs of all the URL parameters, typically empty
--   * fullURL - A string containing the full, original URI
--   * senderPID - An integer containing the PID of the application that opened the URI, if available (otherwise -1)
M.mailtoCallback = nil

-- Opens a URL with the default application
--
-- Parameters:
--  * url - A string containing a URL, which must contain a scheme and '://'
--
-- Returns:
--  * A boolean, true if the URL was opened successfully, otherwise false
function M.openURL(url, ...) end

-- Opens a URL with a specified application
--
-- Parameters:
--  * url - A string containing a URL
--  * bundleID - A string containing an application bundle identifier (e.g. "com.apple.Safari")
--
-- Returns:
--  * True if the application was launched successfully, otherwise false
---@return boolean
function M.openURLWithBundle(url, bundleID, ...) end

-- Sets the default system handler for URLs of a given scheme
--
-- Parameters:
--  * scheme - A string containing the URL scheme to change. This must be 'http' or 'https' (although entering either will change the handler for both)
--  * bundleID - An optional string containing an application bundle identifier for the application to set as the default handler. Defaults to `org.hammerspoon.Hammerspoon`.
--
-- Returns:
--  * None
--
-- Notes:
--  * Changing the default handler for http/https URLs will display a system prompt asking the user to confirm the change
function M.setDefaultHandler(scheme, bundleID, ...) end

-- Stores a URL handler that will be restored when Hammerspoon or reloads its config
--
-- Parameters:
--  * scheme - A string containing the URL scheme to change. This must be 'http' (although both http:// and https:// URLs will be affected)
--  * bundleID - A string containing an application bundle identifier (e.g. 'com.apple.Safari') for the application to set as the default handler when Hammerspoon exits or reloads its config
--
-- Returns:
--  * None
--
-- Notes:
--  * You don't have to call this function if you want Hammerspoon to permanently be your default handler. Only use this if you want the handler to be automatically reverted to something else when Hammerspoon exits/reloads.
function M.setRestoreHandler(scheme, bundleID, ...) end

