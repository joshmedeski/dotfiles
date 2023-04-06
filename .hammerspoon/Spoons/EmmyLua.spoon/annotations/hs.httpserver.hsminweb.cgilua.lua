--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Provides support functions in the `cgilua` module for Hammerspoon Minimal Web Server Lua templates.
--
-- This file contains functions which attempt to mimic as closely as possible the functions available to lua template files in the CGILua module provided by the Kepler Project at http://keplerproject.github.io/cgilua/index.html
--
-- The goal of this file is to provide most of the same functionality that CGILua does for template files. Any differences in the results or errors are most likely due to this code and you should direct all error reports or code change suggestions to the Hammerspoon GitHub repository.
--
-- **Do not include this file directly in your Lua templates.**  This library is provided automatically in the `cgilua` table (module) in Lua template web server files.  This submodule will only work from within that environment and should not be used in any other code.
---@class hs.httpserver.hsminweb.cgilua
local M = {}
hs.httpserver.hsminweb.cgilua = M

-- Sets the HTTP response type for the content being generated to maintype/subtype.
--
-- Parameters:
--  * maintype - the primary content type (e.g. "text")
--  * subtype  - the sub-type for the content (e.g. "plain")
--
-- Returns:
--  * None
--
-- Notes:
--  * This sets the `Content-Type` header field for the HTTP response being generated.  This will override any previous setting, including the default of "text/html".
function M.contentheader(maintype, subtype, ...) end

-- Executes a lua file (given by filepath) if it exists.
--
-- Parameters:
--  * filepath - the file to interpret as Lua code
--
-- Returns:
--  * the values returned by the execution, or nil followed by an error message if the file does not exists.
--
-- Notes:
--  * This function only interprets the file if it exists; if the file does not exist, it returns an error to the calling code (not the web client)
--  * During the processing of a web request, the local directory is temporarily changed to match the local directory of the path of the file being served, as determined by the URL of the request.  This is usually different than the Hammerspoon default directory which corresponds to the directory which contains the `init.lua` file for Hammerspoon.
function M.doif(filename, ...) end

-- Executes a lua file (given by filepath).
--
-- Parameters:
--  * filepath - the file to interpret as Lua code
--
-- Returns:
--  * the values returned by the execution, or nil followed by an error message if the file does not exists.
--
-- Notes:
--  * If the file does not exist, an Internal Server error is returned to the client and an error is logged to the Hammerspoon console.
--  * During the processing of a web request, the local directory is temporarily changed to match the local directory of the path of the file being served, as determined by the URL of the request.  This is usually different than the Hammerspoon default directory which corresponds to the directory which contains the `init.lua` file for Hammerspoon.
function M.doscript(filename, ...) end

-- Sends the message to the `hs.httpserver.hsminweb` log, tagged as an error.
--
-- Parameters:
--  * msg - the message to send to the module's error log
--
-- Returns:
--  * None
--
-- Notes:
--  * Available within a lua template file as `cgilua.errorlog`
--  * By default, messages logged with this method will appear in the Hammerspoon console and are available in the `hs.logger` history.
function M.errorlog(msg, ...) end

-- Sets the HTTP response header `key` to `value`
--
-- Parameters:
--  * key - the HTTP response header to set a value to.  This should be a string.
--  * value - the value for the header.  This should be a string or a value representable as a string.
--
-- Returns:
--  * None
--
-- Notes:
--  * You should not use this function to set the value for the "Content-Type" key; instead use [cgilua.contentheader](#contentheader) or [cgilua.htmlheader](#htmlheader).
function M.header(key, value, ...) end

-- Sets the HTTP response type to "text/html"
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This sets the `Content-Type` header field for the HTTP response being generated to "text/html".  This is the default value, so generally you should not need to call this function unless you have previously changed it with the [cgilua.contentheader](#contentheader) function.
function M.htmlheader() end

-- Returns an absolute URL for the given URI by prepending the path with the scheme, hostname, and port of this web server.
--
-- Parameters:
--  * URI - A path to a resource served by this web server.  A "/" will be prepended to the path if it is not present.
--
-- Returns:
--  * An absolute URL for the given path of the form "scheme://hostname:port/path" where `scheme` will be either "http" or "https", and the hostname and port will match that of this web server.
--
-- Notes:
--  * If you wish to append query items to the path or expand a relative path into it's full path, see [cgilua.mkurlpath](#mkurlpath).
---@return string
function M.mkabsoluteurl(uri, ...) end

-- Creates a full document URI from a partial URI, including query arguments if present.
--
-- Parameters:
--  * uri  - the full or partial URI (path and file component of a URL) of the document
--  * args - an optional table which should have key-value pairs that will be encoded to form a valid query at the end of the URI (see [cgilua.urlcode.encodetable](#encodetable).
--
-- Returns:
--  * A full URI including any query arguments, if present.
--
-- Notes:
--  * This function is intended to be used in conjunction with [cgilua.mkabsoluteurl](#mkabsoluteurl) to generate a full URL.  If the `uri` provided does not begin with a "/", then the current directory path is prepended to the uri and any query arguments are appended.
--  * e.g. `cgilua.mkabsoluteurl(cgiurl.mkurlpath("file.lp", { key = value, ... }))` will return a full URL specifying the file `file.lp` in the current directory with the specified key-value pairs as query arguments.
---@return string
function M.mkurlpath(uri, args, ...) end

-- Appends the given arguments to the response body.
--
-- Parameters:
--  * ... - a list of comma separated arguments to add to the response body
--
-- Returns:
--  * None
--
-- Notes:
--  * Available within a lua template file as `cgilua.print`
--  * This function works like the lua builtin `print` command in that it converts all its arguments to strings, separates them with tabs (`\t`), and ends the line with a newline (`\n`) before appending them to the current response body.
function M.print(...) end

-- Appends the given arguments to the response body.
--
-- Parameters:
--  * ... - a list of comma separated arguments to add to the response body
--
-- Returns:
--  * None
--
-- Notes:
--  * Available within a lua template file as `cgilua.put`
--  * This function works by flattening tables and converting all values except for `nil` and `false` to their string representation and then appending them in order to the response body. Unlike `cgilua.print`, it does not separate values with a tab character or terminate the line with a newline character.
function M.put(...) end

-- Sends the headers to force a redirection to the given URL adding the parameters in table args to the new URL.
--
-- Parameters:
--  * url  - the URL the client should be redirected to
--  * args - an optional table which should have key-value pairs that will be encoded to form a valid query at the end of the URL (see [cgilua.urlcode.encodetable](#encodetable).
--
-- Returns:
--  * None
--
-- Notes:
--  * This function should generally be followed by a `return` in your lua template page as no additional processing or output should occur when a request is to be redirected.
function M.redirect(url, args, ...) end

-- The file name of the running script. Obtained from cgilua.script_path.
--
-- Notes:
--  * CGILua supports being invoked through a URL that amounts to set of chained paths and script names; this is not necessary for this module, so these variables may differ somewhat from a true CGILua installation; the intent of the variable has been maintained as closely as I can determine at present.  If this changes, so will this documentation.
M.script_file = nil

-- The system path of the running script. Equivalent to the CGI environment variable SCRIPT_FILENAME.
--
-- Notes:
--  * CGILua supports being invoked through a URL that amounts to set of chained paths and script names; this is not necessary for this module, so these variables may differ somewhat from a true CGILua installation; the intent of the variable has been maintained as closely as I can determine at present.  If this changes, so will this documentation.
M.script_path = nil

-- The directory of the running script. Obtained from cgilua.script_path.
--
-- Notes:
--  * CGILua supports being invoked through a URL that amounts to set of chained paths and script names; this is not necessary for this module, so these variables may differ somewhat from a true CGILua installation; the intent of the variable has been maintained as closely as I can determine at present.  If this changes, so will this documentation.
M.script_pdir = nil

-- If PATH_INFO represents a directory (i.e. ends with "/"), then this is equal to `cgilua.script_vpath`.  Otherwise, this contains the directory portion of `cgilua.script_vpath`.
--
-- Notes:
--  * CGILua supports being invoked through a URL that amounts to set of chained paths and script names; this is not necessary for this module, so these variables may differ somewhat from a true CGILua installation; the intent of the variable has been maintained as closely as I can determine at present.  If this changes, so will this documentation.
M.script_vdir = nil

-- Equivalent to the CGI environment variable PATH_INFO or "/", if no PATH_INFO is set.
--
-- Notes:
--  * CGILua supports being invoked through a URL that amounts to set of chained paths and script names; this is not necessary for this module, so these variables may differ somewhat from a true CGILua installation; the intent of the variable has been maintained as closely as I can determine at present.  If this changes, so will this documentation.
M.script_vpath = nil

-- Returns a string with the value of the CGI environment variable corresponding to varname.
--
-- Parameters:
--  * varname - the name of the CGI variable to get the value of.
--
-- Returns:
--  * the value of the CGI variable as a string, or nil if no such variable exists.
--
-- Notes:
--  * CGI Variables include server defined values commonly shared with CGI scripts and the HTTP request headers from the web request.  The server variables include the following (note that depending upon the request and type of resource the URL refers to, not all values may exist for every request):
--    * "AUTH_TYPE"         - If the server supports user authentication, and the script is protected, this is the protocol-specific authentication method used to validate the user.
--    * "CONTENT_LENGTH"    - The length of the content itself as given by the client.
--    * "CONTENT_TYPE"      - For queries which have attached information, such as HTTP POST and PUT, this is the content type of the data.
--    * "DOCUMENT_ROOT"     - the real directory on the server that corresponds to a DOCUMENT_URI of "/".  This is the first directory which contains files or sub-directories which are served by the web server.
--    * "DOCUMENT_URI"      - the path portion of the HTTP URL requested
--    * "GATEWAY_INTERFACE" - The revision of the CGI specification to which this server complies. Format: CGI/revision
--    * "PATH_INFO"         - The extra path information, as given by the client. In other words, scripts can be accessed by their virtual pathname, followed by extra information at the end of this path. The extra information is sent as PATH_INFO. This information should be decoded by the server if it comes from a URL before it is passed to the CGI script.
--    * "PATH_TRANSLATED"   - The server provides a translated version of PATH_INFO, which takes the path and does any virtual-to-physical mapping to it.
--    * "QUERY_STRING"      - The information which follows the "?" in the URL which referenced this script. This is the query information. It should not be decoded in any fashion. This variable should always be set when there is query information, regardless of command line decoding.
--    * "REMOTE_ADDR"       - The IP address of the remote host making the request.
--    * "REMOTE_HOST"       - The hostname making the request. If the server does not have this information, it should set REMOTE_ADDR and leave this unset.
--    * "REMOTE_IDENT"      - If the HTTP server supports RFC 931 identification, then this variable will be set to the remote user name retrieved from the server. Usage of this variable should be limited to logging only.
--    * "REMOTE_USER"       - If the server supports user authentication, and the script is protected, this is the username they have authenticated as.
--    * "REQUEST_METHOD"    - The method with which the request was made. For HTTP, this is "GET", "HEAD", "POST", etc.
--    * "REQUEST_TIME"      - the time the server received the request represented as the number of seconds since 00:00:00 UTC on 1 January 1970.  Usable with `os.date` to provide the date and time in whatever format you require.
--    * "REQUEST_URI"       - the DOCUMENT_URI with any query string present in the request appended.  Usually this corresponds to the URL without the scheme or host information.
--    * "SCRIPT_FILENAME"   - the actual path to the script being executed.
--    * "SCRIPT_NAME"       - A virtual path to the script being executed, used for self-referencing URLs.
--    * "SERVER_NAME"       - The server's hostname, DNS alias, or IP address as it would appear in self-referencing URLs.
--    * "SERVER_PORT"       - The port number to which the request was sent.
--    * "SERVER_PROTOCOL"   - The name and revision of the information protocol this request came in with. Format: protocol/revision
--    * "SERVER_SOFTWARE"   - The name and version of the web server software answering the request (and running the gateway). Format: name/version
--
-- * The HTTP Request header names are prefixed with "HTTP_", converted to all uppercase, and have all hyphens converted into underscores.  Common headers (converted to their CGI format) might include, but are not limited to:
--    * HTTP_ACCEPT, HTTP_ACCEPT_ENCODING, HTTP_ACCEPT_LANGUAGE, HTTP_CACHE_CONTROL, HTTP_CONNECTION, HTTP_DNT, HTTP_HOST, HTTP_USER_AGENT
--  * This server also defines the following (which are replicated in the CGI variables above, so those should be used for portability):
--    * HTTP_X_REMOTE_ADDR, HTTP_X_REMOTE_PORT, HTTP_X_SERVER_ADDR, HTTP_X_SERVER_PORT
--  * A list of common request headers and their definitions can be found at https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
---@return string
function M.servervariable(varname, ...) end

-- Returns two strings with the "first directory" and the "remaining path" of the given path string splitted on the first separator ("/" or "\").
--
-- Parameters:
--  * path - the path to split
--
-- Returns:
--  * the first directory component, the remainder of the path
function M.splitfirst(path, ...) end

-- Returns two strings with the "directory path" and "file" parts of the given path string splitted on the last separator ("/" or "\").
--
-- Parameters:
--  * path - the path to split
--
-- Returns:
--  * the directory path, the file
--
-- Notes:
--  * This function used to be called cgilua.splitpath and still can be accessed by this name for compatibility reasons. cgilua.splitpath may be deprecated in future versions.
function M.splitonlast(path, ...) end

-- The directory used by `cgilua.tmpfile`
--
-- This variable contains the location where temporary files should be created.  Defaults to the user's temporary directory as returned by `hs.fs.temporaryDirectory`.
M.tmp_path = nil

-- Returns the file handle to a temporary file for writing, or nil and an error message if the file could not be created for any reason.
--
-- Parameters:
--  * dir          - the system directory where the temporary file should be created.  Defaults to `cgilua.tmp_path`.
--  * namefunction - an optional function used to generate unique file names for use as temporary files.  Defaults to `cgilua.tmpname`.
--
-- Returns:
--  * the created file's handle and the filename or nil and an error message if the file could not be created.
--
-- Notes:
--  * The file is automatically deleted when the HTTP request has been completed, so if you need for the data to persist, make sure to `io.flush` or `io.close` the file handle yourself and copy the file to a more permanent location.
function M.tmpfile(dir, namefunction, ...) end

-- Returns a temporary file name used by `cgilua.tmpfile`.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a temporary filename, without the path.
--
-- Notes:
--  * This function uses `hs.host.globallyUniqueString` to generate a unique file name.
---@return string
function M.tmpname() end

-- The name of the script as requested in the URL. Equivalent to the CGI environment variable SCRIPT_NAME.
--
-- Notes:
--  * CGILua supports being invoked through a URL that amounts to set of chained paths and script names; this is not necessary for this module, so these variables may differ somewhat from a true CGILua installation; the intent of the variable has been maintained as closely as I can determine at present.  If this changes, so will this documentation.
M.urlpath = nil

