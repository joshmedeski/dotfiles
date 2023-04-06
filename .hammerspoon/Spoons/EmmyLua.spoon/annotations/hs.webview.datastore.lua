--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Provides methods to list and purge the various types of data used by websites visited with `hs.webview`.
--
-- This module is only available under OS X 10.11 and later.
--
-- This module allows you to list and selectively purge the types of data stored locally for the websites visited with the `hs.webview` module.  It also adds support for non-persistent datastores to `hs.webview` (private browsing) and allows a non-persistent datastore to be shared among multiple instances of `hs.webview` objects.
--
-- The datastore for a webview contains various types of data including cookies, disk and memory caches, and persistent data such as WebSQL, IndexedDB databases, and local storage.  You can use methods in this module to selectively or completely purge the common datastore (used by all Hammerspoon `hs.webview` instances that do not use a non-persistent datastore).
---@class hs.webview.datastore
local M = {}
hs.webview.datastore = M

-- Returns an object representing the default datastore for Hammerspoon `hs.webview` instances.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a datastoreObject
--
-- Notes:
--  * this is the datastore used unless otherwise specified when creating an `hs.webview` instance.
function M.default() end

-- Generates a list of the datastore records of the specified type, and invokes the callback function with the list.
--
-- Parameters:
--  * `dataTypes` - an optional string or table specifying the data types to fetch from the datastore.  If this parameter is not specified, it defaults to the list returned by [hs.webview.datastore.websiteDataTypes](#websiteDataTypes).
--  * `callback`  - a function which accepts as it's argument an array-table containing tables with the following key-value pairs:
--    * `displayName` - a string containing the site's display name.  Typically, the display name is the domain name with suffix taken from the resource’s security origin (website name).
--    * `dataTypes`   - a table containing strings representing the types of data stored for the website specified by `displayName`.
--
-- Returns:
--  * the datastore object
--
-- Notes:
--  * only those sites with one or more of the specified data types are returned
--  * for the sites returned, only those data types that were present in the query will be included in the list, even if the site has data of another type in the datastore.
function M:fetchRecords(dataTypes, callback, ...) end

-- Returns an object representing the datastore for the specified `hs.webview` instance.
--
-- Parameters:
--  * `webview` - an `hs.webview` instance (webviewObject)
--
-- Returns:
--  * a datastoreObject
--
-- Notes:
--  * When running on a system with OS X 10.11 or later, this method will also be added to the metatable for `hs.webview` objects so that you can retrieve a webview's datastore with `hs.webview:datastore()`.
--
--  * This method can be used to identify the datastore in use for a webview if you wish to create a new instance using the same datastore.
function M.fromWebview(webview, ...) end

-- Returns an object representing a newly created non-persistent (private) datastore for use with a Hammerspoon `hs.webview` instance.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a datastoreObject
--
-- Notes:
--  * The datastore represented by this object will be initially empty.  You can use this function to create a non-persistent datastore that you wish to share among multiple `hs.webview` instances.  Once a datastore is created, you assign it to a `hs.webview` instance by including the `datastore` key in the `hs.webview.new` constructor's preferences table and setting it equal to this key.  All webview instances created with this datastore object will share web caches, cookies, etc. but will still be isolated from the default datastore and it will be purged from memory when the webviews are deleted, or Hammerspoon is restarted.
--
--  * Using the `datastore` key in the webview's constructor differs from the `private` key -- use of the `private` key will override the `datastore` key and will create a separate non-persistent datastore for the webview instance.  See `hs.webview.new` for more information.
function M.newPrivate() end

-- Returns whether or not the datastore is persistent.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean value indicating whether or not the datastore is persistent (true) or private (false)
--
-- Notes:
--  * Note that this value is the inverse of `hs.webview:privateBrowsing()`, since private browsing uses a non-persistent datastore.
---@return boolean
function M:persistent() end

-- Removes the specified types of data from the datastore if the data was added or changed since the given date.
--
-- Parameters:
--  * `date`         - an integer representing seconds since `1970-01-01 00:00:00 +0000` (e.g. `os.time()`), or a string containing a date in RFC3339 format (`YYYY-MM-DD[T]HH:MM:SS[Z]`).
--  * `dataTypes`    - a string or array of strings specifying the types of data to remove from the datastore for the specified sites.
--  * `callback`     - an optional function, which should expect no arguments, that will be called when the specified items have been removed from the datastore.
--
-- Returns:
--  * the datastore object
--
-- Notes:
--  * Yes, you read the description correctly -- removes data *newer* then the date specified.  I've not yet found a way to remove data *older* then the date specified (to expire old data, for example) but updates or suggestions are welcome in the Hammerspoon Google group or GitHub web site.
--
--  * to specify that all data types that qualify should be removed, specify the function  [hs.webview.datastore.websiteDataTypes()](#websiteDataTypes). as the second argument.
--
--  * For example, to purge the Hammerspoon default datastore of all data, you can do the following:
-- ~~~
-- hs.webview.datastore.default():removeRecordsAfter(0, hs.webview.datastore.websiteDataTypes())
-- ~~~
function M:removeRecordsAfter(date, dataTypes, callback, ...) end

-- Remove data from the datastore of the specified type(s) for the specified site(s).
--
-- Parameters:
--  * `displayNames` - a string or array of strings specifying the display names (sites) to remove records for.
--  * `dataTypes`    - a string or array of strings specifying the types of data to remove from the datastore for the specified sites.
--  * `callback`     - an optional function, which should expect no arguments, that will be called when the specified items have been removed from the datastore.
--
-- Returns:
--  * the datastore object
--
-- Notes:
--  * to specify that all data types that qualify should be removed, specify the function  [hs.webview.datastore.websiteDataTypes()](#websiteDataTypes). as the second argument.
function M:removeRecordsFor(displayNames, dataTypes, callback, ...) end

-- Returns a list of the currently available data types within a datastore.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a list of strings where each string is a specific data type stored in a datastore.
--
-- Notes:
--  * As of the writing of this module, the following data types are defined and returned by this function:
--    * `WKWebsiteDataTypeDiskCache`                  - On-disk caches.
--    * `WKWebsiteDataTypeOfflineWebApplicationCache` - HTML offline web application caches.
--    * `WKWebsiteDataTypeMemoryCache`                - In-memory caches.
--    * `WKWebsiteDataTypeLocalStorage`               - HTML local storage.
--    * `WKWebsiteDataTypeCookies`                    - Cookies.
--    * `WKWebsiteDataTypeSessionStorage`             - HTML session storage.
--    * `WKWebsiteDataTypeIndexedDBDatabases`         - WebSQL databases.
--    * `WKWebsiteDataTypeWebSQLDatabases`            - IndexedDB databases.
function M.websiteDataTypes() end

