--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Manage the internal documentation web server.
--
-- This module provides functions for managing the Hammerspoon built-in documentation web server.  Currently, this is the same documentation available in the Dash docset for Hammerspoon, but does not require third party software for viewing.
--
-- Future enhancements to this module under consideration include:
--  * Support for third-party modules to add to the documentation set at run-time
--  * Markdown/HTML based tutorials and How-To examples
--  * Documentation for the LuaSkin Objective-C Framework
--  * Lua Reference documentation
--
-- The intent of this sub-module is to provide as close a rendering of the same documentation available at the Hammerspoon GitHub site and Dash documentation as possible in a manner suitable for run-time modification so module developers can test out documentation additions without requiring a complete recompilation of the Hammerspoon source.  As always, the most current and official documentation can be found at https://www.hammerspoon.org and in the official Hammerspoon Dash docset.
---@class hs.doc.hsdocs
local M = {}
hs.doc.hsdocs = M

-- Get or set whether or not the Hammerspoon browser renders output in Dark mode.
--
-- Parameters:
--  * value - an optional boolean, number, or nil specifying whether or not the documentation browser renders in Dark mode.
--    * if value is `true`, then the HTML output will always be inverted
--    * if value is `false`, then the HTML output will never be inverted
--    * if value is `nil`, then the output will be inverted only when the OS X theme is set to Dark mode
--    * if the value is a number between 0 and 100, the number specifies the inversion ratio, where 0 means no inversion, 100 means full inversion, and 50 is completely unreadable because the foreground and background are equally adjusted.
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * Inversion is applied through the use of CSS filtering, so while numeric values other than 0 (false) and 100 (true) are allowed, the result is generally not what is desired.
--
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.invertDocs" and will persist through a reload or restart of Hammerspoon.
function M.browserDarkMode(value, ...) end

-- Get or set the currently saved initial frame location for the documentation browser.
--
-- Parameters:
--  * frameTable - a frame table containing x, y, h, and w values specifying the browser's initial position when Hammerspoon starts.
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * If [hs.doc.hsdocs.trackBrowserFrame](#trackBrowserFrame) is false or nil (the default), then you can use this function to specify the initial position of the documentation browser.
--  * If [hs.doc.hsdocs.trackBrowserFrame](#trackBrowserFrame) is true, then this any value set with this function will be overwritten whenever the browser window is moved or resized.
--
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.browserFrame" and will persist through a reload or restart of Hammerspoon.
function M.browserFrame(frameTable, ...) end

-- Get or set whether or not [hs.doc.hsdocs.help](#help) uses an external browser.
--
-- Parameters:
--  * value - an optional boolean or string, default false, specifying whether or not documentation requests will be displayed in an external browser or the internal one handled by `hs.webview`.
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * If this value is set to true, help requests invoked by [hs.doc.hsdocs.help](#help) will be invoked by your system's default handler for the `http` scheme.
--  * If this value is set to a string, the string specifies the bundle ID of an application which will be used to handle the url request for the documentation.  The string should match one of the items returned by `hs.urlevent.getAllHandlersForScheme("http")`.
--
--  * This behavior is triggered automatically, regardless of this setting, if you are running with a version of OS X prior to 10.10, since `hs.webview` requires OS X 10.10 or later.
--
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.forceExternalBrowser" and will persist through a reload or restart of Hammerspoon.
function M.forceExternalBrowser(value, ...) end

-- Display the documentation for the specified Hammerspoon function, or the Table of Contents for the Hammerspoon documentation in a built-in mini browser.
--
-- Parameters:
--  * an optional string specifying a Hammerspoon module, function, or method to display documentation for. If you leave out this parameter, the table of contents for the Hammerspoon built-in documentation is displayed instead.
--
-- Returns:
--  * None
function M.help(identifier, ...) end

-- Get or set the network interface that the Hammerspoon documentation web server will be served on
--
-- Parameters:
--  * interface - an optional string, or nil, specifying the network interface the Hammerspoon documentation web server will be served on.  An explicit nil specifies that the web server should listen on all active interfaces for the machine.  Defaults to "localhost".
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * See `hs.httpserver.setInterface` for a description of valid values that can be specified as the `interface` argument to this function.
--  * A change to the interface can only occur when the documentation server is not running. If the server is currently active when you call this function with an argument, the server will be temporarily stopped and then restarted after the interface has been changed.
--
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.interface" and will persist through a reload or restart of Hammerspoon.
function M.interface(interface, ...) end

-- Get or set whether or not a module's entity list is displayed as a column on the left of the rendered page.
--
-- Parameters:
--  * value - an optional boolean specifying whether or not a module's entity list is displayed inline in the documentation (false) or in a sidebar on the left (true).
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * This is experimental and is disabled by default. It was inspired by a Userscript written by krasnovpro.  The original can be found at https://openuserjs.org/scripts/krasnovpro/hammerspoon.org_Documentation/source.
--
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.entitiesInSidebar" and will persist through a reload or restart of Hammerspoon.
function M.moduleEntitiesInSidebar(value, ...) end

-- Get or set the Hammerspoon documentation server HTTP port.
--
-- Parameters:
--  * value - an optional number specifying the port for the Hammerspoon documentation web server
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * The default port number is 12345.
--
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.serverPort" and will persist through a reload or restart of Hammerspoon.
function M.port(value, ...) end

-- Start the Hammerspoon internal documentation web server.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the table representing the `hs.doc.hsdocs` module
--
-- Notes:
--  * This function is automatically called, if necessary, when [hs.doc.hsdocs.help](#help) is invoked.
--  * The documentation web server can be viewed from a web browser by visiting "http://localhost:port" where `port` is the port the server is running on, 12345 by default -- see [hs.doc.hsdocs.port](#port).
function M.start() end

-- Stop the Hammerspoon internal documentation web server.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the table representing the `hs.doc.hsdocs` module
function M.stop() end

-- Get or set whether or not changes in the documentation browsers location and size persist through launches of Hammerspoon.
--
-- Parameters:
--  * value - an optional boolean specifying whether or not the browsers location should be saved across launches of Hammerspoon.
--
-- Returns:
--  * the current, possibly new, value
--
-- Notes:
--  * Changes made with this function are saved with `hs.settings` with the label "_documentationServer.trackBrowserFrameChanges" and will persist through a reload or restart of Hammerspoon.
function M.trackBrowserFrame(value, ...) end

