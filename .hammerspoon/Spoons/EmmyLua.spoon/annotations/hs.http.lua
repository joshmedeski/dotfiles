--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Perform HTTP requests
---@class hs.http
local M = {}
hs.http = M

-- Sends an HTTP GET request asynchronously
--
-- Parameters:
--  * url - A string containing the URL to retrieve
--  * headers - A table containing string keys and values representing the request headers, or nil to add no headers
--  * callback - A function to be called when the request succeeds or fails. The function will be passed three parameters:
--   * A number containing the HTTP response status
--   * A string containing the response body
--   * A table containing the response headers
--
-- Returns:
--  * None
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * If the request fails, the callback function's first parameter will be negative and the second parameter will contain an error message. The third parameter will be nil
function M.asyncGet(url, headers, callback, ...) end

-- Sends an HTTP POST request asynchronously
--
-- Parameters:
--  * url - A string containing the URL to submit to
--  * data - A string containing the request body, or nil to send no body
--  * headers - A table containing string keys and values representing the request headers, or nil to add no headers
--  * callback - A function to be called when the request succeeds or fails. The function will be passed three parameters:
--   * A number containing the HTTP response status
--   * A string containing the response body
--   * A table containing the response headers
--
-- Returns:
--  * None
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * If the request fails, the callback function's first parameter will be negative and the second parameter will contain an error message. The third parameter will be nil
function M.asyncPost(url, data, headers, callback, ...) end

-- Sends an HTTP PUT request asynchronously
--
-- Parameters:
--  * url - A string containing the URL to submit to
--  * data - A string containing the request body, or nil to send no body
--  * headers - A table containing string keys and values representing the request headers, or nil to add no headers
--  * callback - A function to be called when the request succeeds or fails. The function will be passed three parameters:
--   * A number containing the HTTP response status
--   * A string containing the response body
--   * A table containing the response headers
--
-- Returns:
--  * None
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * If the request fails, the callback function's first parameter will be negative and the second parameter will contain an error message. The third parameter will be nil
function M.asyncPut(url, data, headers, callback, ...) end

-- Convert all recognized HTML Entities in the `inString` to appropriate UTF8 byte sequences and returns the converted text.
--
-- Parameters:
--  * inString -- A string containing any number of HTML Entities (&whatever;) in the text.
--
-- Returns:
--  * outString -- the input string with all recognized HTML Entity sequences converted to UTF8 byte sequences.
--
-- Notes:
--  * Recognized HTML Entities are those registered in `hs.http.htmlEntities` or numeric entity sequences: &#n; where `n` can be any integer number.
--  * This function is especially useful as a post-filter to data retrieved by the `hs.http.get` and `hs.http.asyncGet` functions.
function M.convertHtmlEntities(inString, ...) end

-- Creates an HTTP request and executes it asynchronously
--
-- Parameters:
--  * url - A string containing the URL
--  * method - A string containing the HTTP method to use (e.g. "GET", "POST", etc)
--  * data - A string containing the request body, or nil to send no body
--  * headers - A table containing string keys and values representing request header keys and values, or nil to add no headers
--  * callback - A function to called when the response is received. The function should accept three arguments:
--   * code - A number containing the HTTP response code
--   * body - A string containing the body of the response
--   * headers - A table containing the HTTP headers of the response
--  * cachePolicy - An optional string containing the cache policy ("protocolCachePolicy", "ignoreLocalCache", "ignoreLocalAndRemoteCache", "returnCacheOrLoad", "returnCacheDontLoad" or "reloadRevalidatingCache"). Defaults to `protocolCachePolicy`.
--  * enableRedirect - An optional boolean to indicate whether to redirect the http request. Defaults to true.
--
-- Returns:
--  * None
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * If the Content-Type response header begins `text/` then the response body return value is a UTF8 string. Any other content type passes the response body, unaltered, as a stream of bytes.
--  * If enableRedirect is set to true, response body will be empty string. Http body will be dropped even though response has the body. This seems the limitation of 'connection:willSendRequest:redirectResponse' method.
function M.doAsyncRequest(url, method, data, headers, callback, cachePolicy_or_enableRedirect, ...) end

-- Creates an HTTP request and executes it synchronously
--
-- Parameters:
--  * url - A string containing the URL
--  * method - A string containing the HTTP method to use (e.g. "GET", "POST", etc)
--  * data - An optional string containing the data to POST to the URL, or nil to send no data
--  * headers - An optional table of string keys and values used as headers for the request, or nil to add no headers
--  * cachePolicy - An optional string containing the cache policy ("protocolCachePolicy", "ignoreLocalCache", "ignoreLocalAndRemoteCache", "returnCacheOrLoad", "returnCacheDontLoad" or "reloadRevalidatingCache"). Defaults to `protocolCachePolicy`.
--
-- Returns:
--  * A number containing the HTTP response status code
--  * A string containing the response body
--  * A table containing the response headers
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--
--  * This function is synchronous and will therefore block all Lua execution until it completes. You are encouraged to use the asynchronous functions.
--  * If you attempt to connect to a local Hammerspoon server created with `hs.httpserver`, then Hammerspoon will block until the connection times out (60 seconds), return a failed result due to the timeout, and then the `hs.httpserver` callback function will be invoked (so any side effects of the function will occur, but it's results will be lost).  Use [hs.http.doAsyncRequest](#doAsyncRequest) to avoid this.
--  * If the Content-Type response header begins `text/` then the response body return value is a UTF8 string. Any other content type passes the response body, unaltered, as a stream of bytes.
function M.doRequest(url, method, data, headers, cachePolicy, ...) end

-- Returns a copy of the provided string in which characters that are not valid within an HTTP query key or value are escaped with their %## equivalent.
--
-- Parameters:
--  * originalString - the string to make safe as a key or value for a query
--
-- Returns:
--  * the converted string
--
-- Notes:
--  * The intent of this function is to provide a valid key or a valid value for a query string, not to validate the entire query string.  For this reason, ?, =, +, and & are included in the converted characters.
---@return string
function M.encodeForQuery(string, ...) end

-- Sends an HTTP GET request to a URL
--
-- Parameters:
--  * url - A string containing the URL to retrieve
--  * headers - A table containing string keys and values representing the request headers, or nil to add no headers
--
-- Returns:
--  * A number containing the HTTP response status
--  * A string containing the response body
--  * A table containing the response headers
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * This function is synchronous and will therefore block all other Lua execution while the request is in progress, you are encouraged to use the asynchronous functions
--  * If you attempt to connect to a local Hammerspoon server created with `hs.httpserver`, then Hammerspoon will block until the connection times out (60 seconds), return a failed result due to the timeout, and then the `hs.httpserver` callback function will be invoked (so any side effects of the function will occur, but it's results will be lost).  Use [hs.http.asyncGet](#asyncGet) to avoid this.
function M.get(url, headers, ...) end

-- A collection of common HTML Entities (&whatever;) and their UTF8 equivalents.  To retrieve the UTF8 sequence for a given entity, reference the table as `hs.http.htmlEntities["&key;"]` where `key` is the text of the entity's name or a numeric reference like `#number`.
--
-- Notes:
--  * This list is likely not complete.  It is based on the list of common entities described at http://www.freeformatter.com/html-entities.html.
--  * Additional entities can be temporarily added via the `hs.http.registerEntity(...)` function.  If you feel you have a more official list of entities which contains items which are currently not included by default, please open up an issue at https://github.com/Hammerspoon/hammerspoon and your link will be considered.
--  * To see a list of the currently defined entities, a __tostring meta-method is included so that referencing the table directly as a string will return the current definitions.
--    * For reference, this meta-method is essentially the following:
--
--      for i,v in hs.fnutils.sortByKeys(hs.http.htmlEntities) do print(string.format("%-10s %-10s %s\n", i, "&#"..tostring(hs.utf8.codepoint(v))..";", v)) end
--
--    * Note that this list will not include the numeric conversion of entities (e.g. &#65;), as this is handled by an __index metamethod to allow for all possible numeric values.
---@type table
M.htmlEntities = {}

-- Sends an HTTP POST request to a URL
--
-- Parameters:
--  * url - A string containing the URL to submit to
--  * data - A string containing the request body, or nil to send no body
--  * headers - A table containing string keys and values representing the request headers, or nil to add no headers
--
-- Returns:
--  * A number containing the HTTP response status
--  * A string containing the response body
--  * A table containing the response headers
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * This function is synchronous and will therefore block all other Lua execution while the request is in progress, you are encouraged to use the asynchronous functions
--  * If you attempt to connect to a local Hammerspoon server created with `hs.httpserver`, then Hammerspoon will block until the connection times out (60 seconds), return a failed result due to the timeout, and then the `hs.httpserver` callback function will be invoked (so any side effects of the function will occur, but it's results will be lost).  Use [hs.http.asyncPost](#asyncPost) to avoid this.
function M.post(url, data, headers, ...) end

-- Sends an HTTP PUT request to a URL
--
-- Parameters:
--  * url - A string containing the URL to submit to
--  * data - A string containing the request body, or nil to send no body
--  * headers - A table containing string keys and values representing the request headers, or nil to add no headers
--
-- Returns:
--  * A number containing the HTTP response status
--  * A string containing the response body
--  * A table containing the response headers
--
-- Notes:
--  * If authentication is required in order to download the request, the required credentials must be specified as part of the URL (e.g. "http://user:password@host.com/"). If authentication fails, or credentials are missing, the connection will attempt to continue without credentials.
--  * This function is synchronous and will therefore block all other Lua execution while the request is in progress, you are encouraged to use the asynchronous functions
--  * If you attempt to connect to a local Hammerspoon server created with `hs.httpserver`, then Hammerspoon will block until the connection times out (60 seconds), return a failed result due to the timeout, and then the `hs.httpserver` callback function will be invoked (so any side effects of the function will occur, but it's results will be lost).  Use [hs.http.asyncPost](#asyncPost) to avoid this.
function M.put(url, data, headers, ...) end

-- Registers an HTML Entity with the specified Unicode codepoint which can later referenced in your code as `hs.http.htmlEntity[entity]` for convenience and readability.
--
-- Parameters:
--  * entity -- The full text of the HTML Entity as it appears in HTML encoded documents.  A proper entity starts with & and ends with ; and entity labels which do not meet this will have them added -- future dereferences to get the corresponding UTF8 *must* include this initiator and terminator or they will not be recognized.
--  * codepoint -- a Unicode codepoint in numeric or `U+xxxx` format to register with as the given entity.
--
-- Returns:
--  * Returns the UTF8 byte sequence for the entity registered.
--
-- Notes:
--  * If an entity label was previously registered, this will overwrite the previous value with a new one.
--  * The return value is merely syntactic sugar and you do not need to save it locally; it can be safely ignored -- future access to the pre-converted entity should be retrieved as `hs.http.htmlEntities[entity]` in your code.  It looks good when invoked from the console, though ☺.
---@return string
function M.registerEntity(entity, codepoint, ...) end

-- Returns a table of keys containing the individual components of the provided url.
--
-- Parameters:
--  * url - the url to parse into it's individual components
--
-- Returns:
--  * a table containing any of the following keys which apply to the specified url:
--    * absoluteString           - The URL string for the URL as an absolute URL.
--    * absoluteURL              - An absolute URL that refers to the same resource as the provided URL.
--    * baseURL                  - the base URL, if the URL is relative
--    * fileSystemRepresentation - the URL’s unescaped path specified as a file system path
--    * fragment                 - the fragment, if specified in the URL
--    * host                     - the host for the URL
--    * isFileURL                - a boolean value indicating whether or not the URL represents a local file
--    * lastPathComponent        - the last path component specified in the URL
--    * parameterString          - the parameter string, if specified in the URL
--    * password                 - the password, if specified in the URL
--    * path                     - the unescaped path specified in the URL
--    * pathComponents           - an array containing the path components of the URL
--    * pathExtension            - the file extension, if specified in the URL
--    * port                     - the port, if specified in the URL
--    * query                    - the query, if specified in the URL
--    * queryItems               - if the URL contains a query string, then this field contains an array of the unescaped key-value pairs for each item. Each key-value pair is represented as a table in the array to preserve order.  See notes for more information.
--    * relativePath             - the relative path of the URL without resolving against its base URL. If the path has a trailing slash it is stripped. If the URL is already an absolute URL, this contains the same value as path.
--    * relativeString           - a string representation of the relative portion of the URL. If the URL is already an absolute URL this contains the same value as absoluteString.
--    * resourceSpecifier        - the resource specified in the URL
--    * scheme                   - the scheme of the URL
--    * standardizedURL          - the URL with any instances of ".." or "." removed from its path
--    * user                     - the username, if specified in the URL
--
-- Notes:
--  * This function assumes that the URL conforms to RFC 1808.  If the URL is malformed or does not conform to RFC1808, then many of these fields may be missing.
--
--  * A contrived example for the url `http://user:password@host.site.com:80/path/to%20a/../file.txt;parameter?query1=1&query2=a%28#fragment`:
--
--     > hs.inspect(hs.http.urlParts("http://user:password@host.site.com:80/path/to%20a/../file.txt;parameter?query1=1&query2=a%28#fragment"))
--      {
--        absoluteString = "http://user:password@host.site.com:80/path/to%20a/../file.txt;parameter?query1=1&query2=a%28#fragment",
--        absoluteURL = "http://user:password@host.site.com:80/path/to%20a/../file.txt;parameter?query1=1&query2=a%28#fragment",
--        fileSystemRepresentation = "/path/to a/../file.txt",
--        fragment = "fragment",
--        host = "host.site.com",
--        isFileURL = false,
--        lastPathComponent = "file.txt",
--        parameterString = "parameter",
--        password = "password",
--        path = "/path/to a/../file.txt",
--        pathComponents = { "/", "path", "to a", "..", "file.txt" },
--        pathExtension = "txt",
--        port = 80,
--        query = "query1=1&query2=a%28",
--        queryItems = { {
--            query1 = "1"
--          }, {
--            query2 = "a("
--          } },
--        relativePath = "/path/to a/../file.txt",
--        relativeString = "http://user:password@host.site.com:80/path/to%20a/../file.txt;parameter?query1=1&query2=a%28#fragment",
--        resourceSpecifier = "//user:password@host.site.com:80/path/to%20a/../file.txt;parameter?query1=1&query2=a%28#fragment",
--        scheme = "http",
--        standardizedURL = "http://user:password@host.site.com:80/path/file.txt;parameter?query1=1&query2=a%28#fragment",
--        user = "user"
--      }
--
--  * Because it is valid for a query key-value pair to be missing either the key or the value or both, the following conventions are used:
--    * a missing key (e.g. '=value') will be represented as { "" = value }
--    * a missing value (e.g. 'key=') will be represented as { key = "" }
--    * a missing value with no = (e.g. 'key') will be represented as { key }
--    * a missing key and value (e.g. '=') will be represented as { "" = "" }
--    * an empty query item (e.g. a query ending in '&' or a query containing && between two other query items) will be represented as { "" }
--
--  * At present Hammerspoon does not provide a way to represent a URL as a true Objective-C object within the OS X API.  This affects the following keys:
--    * relative URLs are not possible to express properly so baseURL will always be nil and relativePath and relativeString will always match path and absoluteString.
--    * These limitations may change in a future update if the need for a more fully compliant URL treatment is determined to be necessary.
function M.urlParts(url, ...) end

