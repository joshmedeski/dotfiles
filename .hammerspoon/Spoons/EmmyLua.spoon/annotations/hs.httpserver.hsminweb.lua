--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Minimalist Web Server for Hammerspoon
--
-- This module aims to be a minimal, but (mostly) standards-compliant web server for use within Hammerspoon.  Expanding upon the Hammerspoon module, `hs.httpserver`, this module adds support for serving static pages stored at a specified document root as well as serving dynamic content from Lua Template Files interpreted within the Hammerspoon environment and external executables which support the CGI/1.1 framework.
--
-- This module aims to provide a fully functional, and somewhat extendable, web server foundation, but will never replace a true dedicated web server application.  Some limitations include:
--  * It is single threaded within the Hammerspoon environment and can only serve one resource at a time
--  * As with all Hammerspoon modules, while dynamic content is being generated, Hammerspoon cannot respond to other callback functions -- a complex or time consuming script may block other Hammerspoon activity in a noticeable manner.
--  * All document requests and responses are handled in memory only -- because of this, maximum resource size is limited to what you are willing to allow Hammerspoon to consume and memory limitations of your computer.
--
-- While some of these limitations may be mitigated to an extent in the future with additional modules and additions to `hs.httpserver`, Hammerspoon's web serving capabilities will never replace a dedicated web server when volume or speed is required.
--
-- An example web site is provided in the `hsdocs` folder of the `hs.doc` module.  This web site can serve documentation for Hammerspoon dynamically generated from the json file included with the Hammerspoon application for internal documentation.  It serves as a basic example of what is possible with this module.
--
-- You can start this web server by typing the following into your Hammerspoon console:
-- `require("hs.doc.hsdocs").start()` and then visiting `http://localhost:12345/` with your web browser.
---@class hs.httpserver.hsminweb
local M = {}
hs.httpserver.hsminweb = M

-- Accessed as `self._accessLog`.  If query logging is enabled for the web server, an Apache style common log entry will be appended to this string for each request.  See [hs.httpserver.hsminweb:queryLogging](#queryLogging).
M._accessLog = nil

-- Accessed as `self._errorHandlers[errorCode]`.  A table whose keyed entries specify the function to generate the error response page for an HTTP error.
--
-- HTTP uses a three digit numeric code for error conditions.  Some servers have introduced subcodes, which are appended as a decimal added to the error condition.
--
-- You can assign your own handler to customize the response for a specific error code by specifying a function for the desired error condition as the value keyed to the error code as a string key in this table.  The function should expect three arguments:
--  * method  - the method for the HTTP request
--  * path    - the full path, including any GET query items
--  * headers - a table containing key-value pairs for the HTTP request headers
--
-- If you override the default handler, "default", the function should expect four arguments instead:  the error code as a string, followed by the same three arguments defined above.
--
-- In either case, the function should return three values:
--  * body    - the content to be returned, usually HTML for a basic error description page
--  * code    - a 3 digit integer specifying the HTTP Response status (see https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
--  * headers - a table containing any headers which should be included in the HTTP response.
M._errorHandlers = nil

-- Accessed as `self._serverAdmin`.  A string containing the administrator for the web server.  Defaults to the currently logged in user's short form username and the computer's localized name as returned by `hs.host.localizedName()` (e.g. "user@computer").
--
-- This value is often used in error messages or on error pages indicating a point of contact for administrative help.  It can be accessed from within an error helper functions as `headers._.serverAdmin`.
M._serverAdmin = nil

-- Accessed as `self._supportMethods[method]`.  A table whose keyed entries specify whether or not a specified HTTP method is supported by this server.
--
-- The default methods supported internally are:
--  * HEAD - an HTTP method which verifies whether or not a resource is available and it's last modified date
--  * GET  - an HTTP method requesting content; the default method used by web browsers for bookmarks or URLs typed in by the user
--  * POST - an HTTP method requesting content that includes content in the request body, most often used by forms to include user input or file data which may affect the content being returned.
--
-- If you assign `true` to another method key, then it will be supported if the target URL refers to a CGI script or Lua Template file, and their support has been enabled for the server.
--
-- If you assign `false` to a method key, then *any* request utilizing that method will return a status of 405 (Method Not Supported).  E.g. `self._supportMethods["POST"] = false` will prevent the POST method from being supported.
--
-- Common HTTP request methods can be found at https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods and https://en.wikipedia.org/wiki/WebDAV.  Currently, only HEAD, GET, and POST have built in support for static pages; even if you set other methods to `true`, they will return a status code of 405 (Method Not Supported) if the request does not invoke a CGI file or Lua Template file for dynamic content.
--
-- A companion module supporting the methods required for WebDAV is being considered.
M._supportMethods = nil

-- Get or set the access-list table for the hsminweb web server
--
-- Parameters:
--  * table - an optional table or `nil` containing the access list for the web server, default `nil`.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * The access-list feature works by comparing the request headers against a list of tests which either accept or reject the request.  If no access list is set (i.e. it is assigned a value of `nil`), then all requests are served.  If a table is passed into this method, then any request which is not explicitly accepted by one of the tests provided is rejected (i.e. there is an implicit "reject" at the end of the list).
--  * The access-list table is a list of tests which are evaluated in order.  The first test which matches a given request determines whether or not the request is accepted or rejected.
--  * Each entry in the access-list table is also a table with the following format:
--    * { 'header', 'value', isPattern, isAccepted }
--      * header     - a string value matching the name of a header.  While the header name must match exactly, the comparison is case-insensitive (i.e. "X-Remote-addr" and "x-remote-addr" will both match the actual header name used, which is "X-Remote-Addr").
--      * value      - a string value specifying the value to compare the header key's value to.
--      * isPattern  - a boolean indicating whether or not the header key's value should be compared to `value` as a pattern match (true) -- see Lua documentation 6.4.1, `help.lua._man._6_4_1` in the console, or as an exact match (false)
--      * isAccepted - a boolean indicating whether or not a match should be accepted (true) or rejected (false)
--    * A special entry of the form { '\*', '\*', '\*', true } accepts all further requests and can be used as the final entry if you wish for the access list to function as a list of requests to reject, but to accept any requests which do not match a previous test.
--    * A special entry of the form { '\*', '\*', '\*', false } rejects all further requests and can be used as the final entry if you wish for the access list to function as a list of requests to accept, but to reject any requests which do not match a previous test.  This is the implicit "default" final test if a table is assigned with the access-list method and does not actually need to be specified, but is included for completeness.
--    * Note that any entry after an entry in which the first two parameters are equal to '\*' will never actually be used.
--
--  * The tests are performed in order; if you wich to allow one IP address in a range, but reject all others, you should list the accepted IP addresses first. For example:
--     ~~~
--     {
--        { 'X-Remote-Addr', '192.168.1.100',  false, true },  -- accept requests from 192.168.1.100
--        { 'X-Remote-Addr', '^192%.168%.1%.', true,  false }, -- reject all others from the 192.168.1 subnet
--        { '*',             '*',              '*',   true }   -- accept all other requests
--     }
--     ~~~
--
--  * Most of the headers available are provided by the requesting web browser, so the exact headers available will vary.  You can find some information about common HTTP request headers at: https://en.wikipedia.org/wiki/List_of_HTTP_header_fields.
--
--  * The following headers are inserted automatically by `hs.httpserver` and are probably the most useful for use in an access list:
--    * X-Remote-Addr - the remote IPv4 or IPv6 address of the machine making the request,
--    * X-Remote-Port - the TCP port of the remote machine where the request originated.
--    * X-Server-Addr - the server IPv4 or IPv6 address that the web server received the request from.  For machines with multiple interfaces, this will allow you to determine which interface the request was received on.
--    * X-Server-Port - the TCP port of the web server that received the request.
function M:accessList(table, ...) end

-- Get or set the whether or not a directory index is returned when the requested URL specifies a directory and no file matching an entry in the directory indexes table is found.
--
-- Parameters:
--  * flag - an optional boolean, defaults to false, indicating whether or not a directory index can be returned when a default file cannot be located.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * if this value is false, then an attempt to retrieve a URL specifying a directory that does not contain a default file as identified by one of the entries in the [hs.httpserver.hsminweb:directoryIndex](#directoryIndex) list will result in a "403.2" error.
function M:allowDirectory(flag, ...) end

-- Get or set the whether or not the web server should advertise itself via Bonjour when it is running.
--
-- Parameters:
--  * flag - an optional boolean, defaults to true, indicating whether or not the server should advertise itself via Bonjour when it is running.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * this flag can only be changed when the server is not running (i.e. the [hs.httpserver.hsminweb:start](#start) method has not yet been called, or the [hs.httpserver.hsminweb:stop](#stop) method is called first.)
function M:bonjour(flag, ...) end

-- Get or set the whether or not CGI file execution is enabled.
--
-- Parameters:
--  * flag - an optional boolean, defaults to false, indicating whether or not CGI script execution is enabled for the web server.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
function M:cgiEnabled(flag, ...) end

-- Get or set the file extensions which identify files which should be executed as CGI scripts to provide the results to an HTTP request.
--
-- Parameters:
--  * table - an optional table or `nil`, defaults to `{ "cgi", "pl" }`, specifying a list of file extensions which indicate that a file should be executed as CGI scripts to provide the content for an HTTP request.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * this list is ignored if [hs.httpserver.hsminweb:cgiEnabled](#cgiEnabled) is not also set to true.
function M:cgiExtensions(table, ...) end

-- A format string, usable with `os.date`, which will display a date in the format expected for HTTP communications as described in RFC 822, updated by RFC 1123.
M.dateFormatString = nil

-- Get or set the file names to look for when the requested URL specifies a directory.
--
-- Parameters:
--  * table - an optional table or `nil`, defaults to `{ "index.html", "index.htm" }`, specifying a list of file names to look for when the requested URL specifies a directory.  If a file with one of the names is found in the directory, this file is served instead of the directory.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * Files listed in this table are checked in order, so the first matched is served.  If no file match occurs, then the server will return a generated list of the files in the directory, or a "403.2" error, depending upon the value controlled by [hs.httpserver.hsminweb:allowDirectory](#allowDirectory).
function M:directoryIndex(table, ...) end

-- Get or set the whether or not DNS lookups are performed.
--
-- Parameters:
--  * flag - an optional boolean, defaults to false, indicating whether or not DNS lookups are performed.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * DNS lookups can be time consuming or even block Hammerspoon for a short time, so they are disabled by default.
--  * Currently DNS lookups are (optionally) performed for CGI scripts, but may be added for other purposes in the future (logging, etc.).
function M:dnsLookup(flag, ...) end

-- Get or set the document root for the web server.
--
-- Parameters:
--  * path - an optional string, default `os.getenv("HOME") .. "/Sites"`, specifying where documents for the web server should be served from.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
function M:documentRoot(path, ...) end

-- Returns the current or specified time in the format expected for HTTP communications as described in RFC 822, updated by RFC 1123.
--
-- Parameters:
--  * date - an optional integer specifying the date as the number of seconds since 00:00:00 UTC on 1 January 1970.  Defaults to the current time as returned by `os.time()`
--
-- Returns:
--  * the time indicated as a string in the format expected for HTTP communications as described in RFC 822, updated by RFC 1123.
---@return string
function M.formattedDate(date, ...) end

-- Get or set the network interface that the hsminweb web server will listen on
--
-- Parameters:
--  * interface - an optional string, or nil, specifying the network interface the web server will listen on.  An explicit nil specifies that the web server should listen on all active interfaces for the machine.  Defaults to nil.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * See `hs.httpserver.setInterface` for a description of valid values that can be specified as the `interface` argument to this method.
--  * the interface can only be specified before the hsminweb web server has been started.  If you wish to change the listening interface for a running web server, you must stop it with [hs.httpserver.hsminweb:stop](#stop) before invoking this method and then restart it with [hs.httpserver.hsminweb:start](#start).
function M:interface(interface, ...) end

-- The `hs.logger` instance for the `hs.httpserver.hsminweb` module. See the documentation for `hs.logger` for more information.
M.log = nil

-- Get or set the extension of files which contain Lua code which should be executed within Hammerspoon to provide the results to an HTTP request.
--
-- Parameters:
--  * string - an optional string or `nil`, defaults to `nil`, specifying the file extension which indicates that a file should be executed as Lua code within the Hammerspoon environment to provide the content for an HTTP request.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * This extension is checked after the extensions given to [hs.httpserver.hsminweb:cgiExtensions](#cgiExtensions); this means that if the same extension set by this method is also in the CGI extensions list, then the file will be interpreted as a CGI script and ignore this setting.
function M:luaTemplateExtension(string, ...) end

-- Get or set the maximum body size for an HTTP request
--
-- Parameters:
--  * size - An optional integer value specifying the maximum body size allowed for an incoming HTTP request in bytes.  Defaults to 10485760 (10 MB).
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * Because the Hammerspoon http server processes incoming requests completely in memory, this method puts a limit on the maximum size for a POST or PUT request.
--  * If the request body exceeds this size, `hs.httpserver` will respond with a status code of 405 for the method before this module ever receives the request.
function M:maxBodySize(size, ...) end

-- Get or set the name the web server uses in Bonjour advertisement when the web server is running.
--
-- Parameters:
--  * name - an optional string specifying the name the server advertises itself as when Bonjour is enabled and the web server is running.  Defaults to `nil`, which causes the server to be advertised with the computer's name as defined in the Sharing preferences panel for the computer.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
function M:name(name, ...) end

-- Create a new hsminweb table object representing a Hammerspoon Web Server.
--
-- Parameters:
--  * documentRoot - an optional string specifying the document root for the new web server.  Defaults to the Hammerspoon users `Sites` sub-directory (i.e. `os.getenv("HOME").."/Sites"`).
--
-- Returns:
--  * a table representing the hsminweb object.
--
-- Notes:
--  * a web server's document root is the directory which contains the documents or files to be served by the web server.
--  * while an hs.minweb object is actually represented by a Lua table, it has been assigned a meta-table which allows methods to be called directly on it like a user-data object.  For most purposes, you should think of this table as the module's userdata.
---@return hs.httpserver.hsminweb
function M.new(documentRoot, ...) end

-- Set a password for the hsminweb web server, or return a boolean indicating whether or not a password is currently set for the web server.
--
-- Parameters:
--  * password - An optional string that contains the server password, or an explicit `nil` to remove an existing password.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or a boolean indicating whether or not a password has been set if no parameter is specified.
--
-- Notes:
--  * the password, if set, is server wide and causes the server to use the Basic authentication scheme with an empty string for the username.
--  * this module is an extension to the Hammerspoon core module `hs.httpserver`, so it has the same limitations regarding server passwords. See the documentation for `hs.httpserver.setPassword` (`help.hs.httpserver.setPassword` in the Hammerspoon console).
function M:password(password, ...) end

-- Get or set the name the port the web server listens on
--
-- Parameters:
--  * port - an optional integer specifying the TCP port the server listens for requests on when it is running.  Defaults to `nil`, which causes the server to randomly choose a port when it is started.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * due to security restrictions enforced by OS X, the port must be a number greater than 1023
function M:port(port, ...) end

-- Get or set the whether or not requests to this web server are logged.
--
-- Parameters:
--  * flag - an optional boolean, defaults to false, indicating whether or not query requests are logged.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * If logging is enabled, an Apache common style log entry is appended to [self._accesslog](#_accessLog) for each request made to the web server.
--  * Error messages during content generation are always logged to the Hammerspoon console via the `hs.logger` instance saved to [hs.httpserver.hsminweb.log](#log).
function M:queryLogging(flag, ...) end

-- Get or set the timeout for a CGI script
--
-- Parameters:
--  * integer - an optional integer, defaults to 30, specifying the length of time in seconds a CGI script should be allowed to run before being forcibly terminated if it has not yet completed its task.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * With the current functionality available in `hs.httpserver`, any script which is expected to return content for an HTTP request must run in a blocking manner -- this means that no other Hammerspoon activity can be occurring while the script is executing.  This parameter lets you set the maximum amount of time such a script can hold things up before being terminated.
--  * An alternative implementation of at least some of the methods available in `hs.httpserver` is being considered which may make it possible to use `hs.task` for these scripts, which would alleviate this blocking behavior.  However, even if this is addressed, a timeout for scripts is still desirable so that a client making a request doesn't sit around waiting forever if a script is malformed.
function M:scriptTimeout(integer, ...) end

-- Get or set the whether or not the web server utilizes SSL for HTTP request and response communications.
--
-- Parameters:
--  * flag - an optional boolean, defaults to false, indicating whether or not the server utilizes SSL for HTTP request and response traffic.
--
-- Returns:
--  * the hsminwebTable object if a parameter is provided, or the current value if no parameter is specified.
--
-- Notes:
--  * this flag can only be changed when the server is not running (i.e. the [hs.httpserver.hsminweb:start](#start) method has not yet been called, or the [hs.httpserver.hsminweb:stop](#stop) method is called first.)
--  * this module is an extension to the Hammerspoon core module `hs.httpserver`, so it has the same considerations regarding SSL. See the documentation for `hs.httpserver.new` (`help.hs.httpserver.new` in the Hammerspoon console).
function M:ssl(flag, ...) end

-- Start serving pages for the hsminweb web server.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the hsminWebTable object
---@return hs.httpserver.hsminweb
function M:start() end

-- HTTP Response Status Codes
--
-- This table contains a list of common HTTP status codes identified from various sources (see Notes below). Because some web servers append a subcode after the official HTTP status codes, the keys in this table are the string representation of the numeric code so a distinction can be made between numerically "identical" keys (for example, "404.1" and "404.10").  You can reference this table with a numeric key, however, and it will be converted to its string representation internally.
--
-- Notes:
--  * The keys and labels in this table have been combined from a variety of sources including, but not limited to:
--    * "Official" list at https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
--    * KeplerProject's wsapi at https://github.com/keplerproject/wsapi
--    * IIS additions from https://support.microsoft.com/en-us/kb/943891
--  * This table has metatable additions which allow you to review its contents from the Hammerspoon console by typing `hs.httpserver.hsminweb.statusCodes`
M.statusCodes = nil

-- Stop serving pages for the hsminweb web server.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the hsminWebTable object
--
-- Notes:
--  * this method is called automatically during garbage collection.
---@return hs.httpserver.hsminweb
function M:stop() end

-- Parse the specified URL into its constituent parts.
--
-- Parameters:
--  * url - the url to parse
--
-- Returns:
--  * a table containing the constituent parts of the provided url.  The table will contain one or more of the following key-value pairs:
--    * fragment           - the anchor name a URL refers to within an HTML document.  Appears after '#' at the end of a URL.  Note that not all web clients include this in an HTTP request since its normal purpose is to indicate where to scroll to within a page after the content has been retrieved.
--    * host               - the host name portion of the URL, if any
--    * lastPathComponent  - the last component of the path portion of the URL
--    * password           - the password specified in the URL.  Note that this is not the password that would be entered when using Basic or Digest authentication; rather it is a password included in the URL itself -- for security reasons, use of this field has been deprecated in most situations and modern browsers will often prompt for confirmation before allowing URL's which contain a password to be transmitted.
--    * path               - the full path specified in the URL
--    * pathComponents     - an array containing the path components as individual strings.  Components which specify a sub-directory of the path will end with a "/" character.
--    * pathExtension      - if the final component of the path refers to a file, the file's extension, if any.
--    * port               - the port specified in the URL, if any
--    * query              - the portion of the URL after a '?' character, if any; used to contain query information often from a form submitting it's input with the GET method.
--    * resourceSpecifier  - the portion of the URL after the scheme
--    * scheme             - the URL scheme; for web traffic, this will be "http" or "https"
--    * standardizedURL    - the URL with any path components of ".." or "." normalized.  The use of ".." that would cause the URL to refer to something preceding its root is simply removed.
--    * URL                - the URL as it was provided to this function (no changes)
--    * user               - the user name specified in the URL.  Note that this is not the user name that would be entered when using Basic or Digest authentication; rather it is a user name included in the URL itself -- for security reasons, use of this field has been deprecated in most situations and modern browsers will often prompt for confirmation before allowing URL's which contain a user name to be transmitted.
--
-- Notes:
--  * This function differs from the similar function `hs.http.urlParts` in a few ways:
--    * To simplify the logic used by this module to determine if a request for a directory is properly terminated with a "/", the path components returned by this function do not remove this character from the component, if present.
--    * Some extraneous or duplicate keys have been removed.
--    * This function is patterned after RFC 3986 while `hs.http.urlParts` uses OS X API functions which are patterned after RFC 1808. RFC 3986 obsoletes 1808.  The primary distinction that affects this module is in regards to `parameters` for path components in the URI -- RFC 3986 disallows them in schema based URI's (like the URL's that are used for web based traffic).
function M.urlParts(url, ...) end

