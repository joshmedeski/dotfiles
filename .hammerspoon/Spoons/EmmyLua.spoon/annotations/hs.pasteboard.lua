--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect/manipulate pasteboards (more commonly called clipboards). Both the system default pasteboard and custom named pasteboards can be interacted with.
--
-- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.pasteboard
local M = {}
hs.pasteboard = M

-- An array whose elements are a table containing the content types for each element on the clipboard.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--
-- Returns:
--  * an array with each index representing an object on the pasteboard.  If the pasteboard contains only one element, this is equivalent to `{ hs.pasteboard.contentTypes(name) }`.
function M.allContentTypes(name, ...) end

-- Invokes callback when the specified pasteboard has changed or the timeout is reached.
--
-- Parameters:
--  * `name`     - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * `timeout`  - an optional number, default 2.0, specifying the time in seconds that this function should wait for a change to the specified pasteboard before timing out.
--  * `callback` - a required callback function that will be invoked when either the specified pasteboard contents have changed or the timeout has been reached. The function should expect one boolean argument, true if the pasteboard contents have changed or false if timeout has been reached.
--
-- Returns:
--  * None
--
-- Notes:
--  * This function can be used to capture the results of a copy operation issued programmatically with `hs.application:selectMenuItem` or `hs.eventtap.keyStroke` without resorting to creating your own timers:
--  ~~~
--      hs.eventtap.keyStroke({"cmd"}, "c", 0) -- or whatever method you want to trigger the copy
--      hs.pasteboard.callbackWhenChanged(5, function(state)
--          if state then
--              local contents = hs.pasteboard.getContents()
--              -- do what you want with contents
--          else
--              error("copy timeout") -- or whatever fallback you want when it times out
--          end
--      end)
--  ~~~
function M.callbackWhenChanged(name, timeout, callback, ...) end

-- Gets the number of times the pasteboard owner has changed
--
-- Parameters:
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard
--
-- Returns:
--  * A number containing a count of the times the pasteboard owner has changed
--
-- Notes:
--  * This is useful for seeing if the pasteboard has been updated by another process
---@return number
function M.changeCount(name, ...) end

-- Clear the contents of the pasteboard
--
-- Parameters:
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard
--
-- Returns:
--  * None
function M.clearContents(name, ...) end

-- Return the UTI strings of the data types for the first pasteboard item on the specified pasteboard.
--
-- Parameters:
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard
--
-- Returns:
--  * a table containing the UTI strings of the data types for the first pasteboard item.
function M.contentTypes(name, ...) end

-- Deletes a custom pasteboard
--
-- Parameters:
--  * name - A string containing the name of the pasteboard
--
-- Returns:
--  * None
--
-- Notes:
--  * You can not delete the system pasteboard, this function should only be called on custom pasteboards you have created
function M.deletePasteboard(name, ...) end

-- Gets the contents of the pasteboard
--
-- Parameters:
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard
--
-- Returns:
--  * A string containing the contents of the pasteboard, or nil if an error occurred
function M.getContents(name, ...) end

-- Return the pasteboard type identifier strings for the specified pasteboard.
--
-- Parameters:
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard
--
-- Returns:
--  * a table containing the pasteboard type identifier strings
function M.pasteboardTypes(name, ...) end

-- Returns all values in the first item on the pasteboard in a table that maps a UTI value to the raw data of the item
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--
-- Returns:
--   a mapping from a UTI value to the raw data
function M.readAllData(name, ...) end

-- Returns the first item on the pasteboard with the specified UTI. The data on the pasteboard must be encoded as a keyed archive object conforming to NSKeyedArchiver.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * uti  - a string specifying the UTI of the pasteboard item to retrieve.
--
-- Returns:
--  * a lua item representing the archived data if it can be decoded. Generates an error if the data is in the wrong format.
--
-- Notes:
--  * NSKeyedArchiver specifies an architecture-independent format that is often used in OS X applications to store and transmit objects between applications and when storing data to a file. It works by recording information about the object types and key-value pairs which make up the objects being stored.
--  * Only objects which have conversion functions built into Hammerspoon can be converted. A string representation describing unrecognized types wil be returned. If you find a common data type that you believe may be of interest to Hammerspoon users, feel free to contribute a conversion function or make a request in the Hammerspoon Google group or GitHub site.
--  * Some applications may define their own classes which can be archived.  Hammerspoon will be unable to recognize these types if the application does not make the object type available in one of its frameworks.  You *may* be able to load the necessary framework with `package.loadlib("/Applications/appname.app/Contents/Frameworks/frameworkname.framework/frameworkname", "*")` before retrieving the data, but a full representation of the data in Hammerspoon is probably not possible without support from the Application's developers.
function M.readArchiverDataForUTI(name, uti, ...) end

-- Returns one or more `hs.drawing.color` tables from the clipboard, or nil if no compatible objects are present.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * all  - an optional boolean indicating whether or not all (true) of the colors on the clipboard should be returned, or just the first (false).  Defaults to false.
--
-- Returns:
--  * By default the first color on the clipboard, or a table of all colors on the clipboard if the `all` parameter is provided and set to true.  Returns nil if no colors are present.
function M.readColor(name, all, ...) end

-- Returns the first item on the pasteboard with the specified UTI as raw data
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * uti  - a string specifying the UTI of the pasteboard item to retrieve.
--
-- Returns:
--  * a lua string containing the raw data of the specified pasteboard item
--
-- Notes:
--  * The UTI's of the items on the pasteboard can be determined with the [hs.pasteboard.allContentTypes](#allContentTypes) and [hs.pasteboard.contentTypes](#contentTypes) functions.
---@return string
function M.readDataForUTI(name, uti, ...) end

-- Returns one or more `hs.image` objects from the clipboard, or nil if no compatible objects are present.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * all  - an optional boolean indicating whether or not all (true) of the urls on the clipboard should be returned, or just the first (false).  Defaults to false.
--
-- Returns:
--  * By default the first image on the clipboard, or a table of all images on the clipboard if the `all` parameter is provided and set to true.  Returns nil if no images are present.
---@return hs.image
function M.readImage(name, all, ...) end

-- Returns the first item on the pasteboard with the specified UTI as a property list item
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * uti  - a string specifying the UTI of the pasteboard item to retrieve.
--
-- Returns:
--  * a lua item representing the property list value of the pasteboard item specified
--
-- Notes:
--  * The UTI's of the items on the pasteboard can be determined with the [hs.pasteboard.allContentTypes](#allContentTypes) and [hs.pasteboard.contentTypes](#contentTypes) functions.
--  * Property lists consist only of certain types of data: tables, strings, numbers, dates, binary data, and Boolean values.
function M.readPListForUTI(name, uti, ...) end

-- Returns one or more `hs.sound` objects from the clipboard, or nil if no compatible objects are present.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * all  - an optional boolean indicating whether or not all (true) of the urls on the clipboard should be returned, or just the first (false).  Defaults to false.
--
-- Returns:
--  * By default the first sound on the clipboard, or a table of all sounds on the clipboard if the `all` parameter is provided and set to true.  Returns nil if no sounds are present.
---@return hs.sound
function M.readSound(name, all, ...) end

-- Returns one or more strings from the clipboard, or nil if no compatible objects are present.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * all  - an optional boolean indicating whether or not all (true) of the urls on the clipboard should be returned, or just the first (false).  Defaults to false.
--
-- Returns:
--  * By default the first string on the clipboard, or a table of all strings on the clipboard if the `all` parameter is provided and set to true.  Returns nil if no strings are present.
--
-- Notes:
--  * almost all string and styledText objects are internally convertible and will be available with this method as well as [hs.pasteboard.readStyledText](#readStyledText). If the item is actually an `hs.styledtext` object, the string will be just the text of the object.
function M.readString(name, all, ...) end

-- Returns one or more `hs.styledtext` objects from the clipboard, or nil if no compatible objects are present.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * all  - an optional boolean indicating whether or not all (true) of the urls on the clipboard should be returned, or just the first (false).  Defaults to false.
--
-- Returns:
--  * By default the first styledtext object on the clipboard, or a table of all styledtext objects on the clipboard if the `all` parameter is provided and set to true.  Returns nil if no styledtext objects are present.
--
-- Notes:
--  * almost all string and styledText objects are internally convertible and will be available with this method as well as [hs.pasteboard.readString](#readString). If the item on the clipboard is actually just a string, the `hs.styledtext` object representation will have no attributes set
---@return hs.styledtext
function M.readStyledText(name, all, ...) end

-- Returns one or more strings representing file or resource urls from the clipboard, or nil if no compatible objects are present.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * all  - an optional boolean indicating whether or not all (true) of the urls on the clipboard should be returned, or just the first (false).  Defaults to false.
--
-- Returns:
--  * By default the first url on the clipboard, or a table of all urls on the clipboard if the `all` parameter is provided and set to true.  Returns nil if no urls are present.
function M.readURL(name, all, ...) end

-- Sets the contents of the pasteboard
--
-- Parameters:
--  * contents - A string to be placed in the pasteboard
--  * name - An optional string containing the name of the pasteboard. Defaults to the system pasteboard
--
-- Returns:
--  * True if the operation succeeded, otherwise false
---@return boolean
function M.setContents(contents, name, ...) end

-- Returns a table indicating what content types are available on the pasteboard.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--
-- Returns:
--  * a table which may contain any of the following keys set to the value true:
--    * string     - at least one element which can be represented as a string is on the pasteboard
--    * styledText - at least one element which can be represented as an `hs.styledtext` object is on the pasteboard
--    * sound      - at least one element which can be represented as an `hs.sound` object is on the pasteboard
--    * image      - at least one element which can be represented as an `hs.image` object is on the pasteboard
--    * URL        - at least one element on the pasteboard represents a URL, either to a local file or a remote resource
--    * color      - at least one element on the pasteboard represents a color, representable as a table as described in `hs.drawing.color`
--
-- Notes:
--  * almost all string and styledText objects are internally convertible and will return true for both keys
--    * if the item on the clipboard is actually just a string, the `hs.styledtext` object representation will have no attributes set
--    * if the item is actually an `hs.styledtext` object, the string representation will be the text without any attributes.
function M.typesAvailable(name, ...) end

-- Returns the name of a new pasteboard with a name that is guaranteed to be unique with respect to other pasteboards on the computer.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a unique pasteboard name
--
-- Notes:
--  * to properly manage system resources, you should release the created pasteboard with [hs.pasteboard.deletePasteboard](#deletePasteboard) when you are certain that it is no longer necessary.
---@return string
function M.uniquePasteboard() end

-- Stores in the pasteboard a given table of UTI to data mapping all at once
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * a mapping from a UTI value to the raw data
--
-- Returns:
--   * True if the operation succeeded, otherwise false (which most likely means ownership of the pasteboard has changed)
---@return boolean
function M.writeAllData(name, table, ...) end

-- Sets the pasteboard to the contents of the data and assigns its type to the specified UTI. The data will be encoded as an archive conforming to NSKeyedArchiver.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * uti  - a string specifying the UTI of the pasteboard item to set.
--  * data - any type representable in Lua which will be converted into the appropriate NSObject types and archived with NSKeyedArchiver.  All Lua basic types are supported as well as those NSObject types handled by Hammerspoon modules (NSColor, NSStyledText, NSImage, etc.)
--  * add  - an optional boolean value specifying if data with other UTI values should retain.  This value must be strictly either true or false if given, to avoid ambiguity with preceding parameters.
--
-- Returns:
--  * True if the operation succeeded, otherwise false (which most likely means ownership of the pasteboard has changed)
--
-- Notes:
--  * NSKeyedArchiver specifies an architecture-independent format that is often used in OS X applications to store and transmit objects between applications and when storing data to a file. It works by recording information about the object types and key-value pairs which make up the objects being stored.
--  * Only objects which have conversion functions built into Hammerspoon can be converted.
--  * A full list of NSObjects supported directly by Hammerspoon is planned in a future Wiki article.
---@return boolean
function M.writeArchiverDataForUTI(name, uti, data, add, ...) end

-- Sets the pasteboard to the contents of the data and assigns its type to the specified UTI.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * uti  - a string specifying the UTI of the pasteboard item to set.
--  * data - a string specifying the raw data to assign to the pasteboard.
--  * add  - an optional boolean value specifying if data with other UTI values should retain.  This value must be strictly either true or false if given, to avoid ambiguity with preceding parameters.
--
-- Returns:
--  * True if the operation succeeded, otherwise false (which most likely means ownership of the pasteboard has changed)
--
-- Notes:
--  * The UTI's of the items on the pasteboard can be determined with the [hs.pasteboard.allContentTypes](#allContentTypes) and [hs.pasteboard.contentTypes](#contentTypes) functions.
---@return boolean
function M.writeDataForUTI(name, uti, data, add, ...) end

-- Sets the pasteboard contents to the object or objects specified.
--
-- Parameters:
--  * object - an object or table of objects to set the pasteboard to.  The following objects are recognized:
--    * a lua string, which can be received by most applications that can accept text from the clipboard
--    * `hs.styledtext` object, which can be received by most applications that can accept a raw NSAttributedString (often converted internally to RTF, RTFD, HTML, etc.)
--    * `hs.sound` object, which can be received by most applications that can accept a raw NSSound object
--    * `hs.image` object, which can be received by most applications that can accept a raw NSImage object
--    * a table with the `url` key and value representing a file or resource url, which can be received by most applications that can accept an NSURL object to represent a file or a remote resource
--    * a table with keys as described in `hs.drawing.color` to represent a color, which can be received by most applications that can accept a raw NSColor object
--    * an array of one or more of the above objects, allowing you to place more than one object onto the clipboard.
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--
-- Returns:
--  * true or false indicating whether or not the clipboard contents were updated.
--
-- Notes:
--  * Most applications can only receive the first item on the clipboard.  Multiple items on a clipboard are most often used for intra-application communication where the sender and receiver are specifically written with multiple objects in mind.
---@return boolean
function M.writeObjects(object, name, ...) end

-- Sets the pasteboard to the contents of the data and assigns its type to the specified UTI.
--
-- Parameters:
--  * name - an optional string indicating the pasteboard name.  If nil or not present, defaults to the system pasteboard.
--  * uti  - a string specifying the UTI of the pasteboard item to set.
--  * data - a lua type which can be represented as a property list value.
--  * add  - an optional boolean value specifying if data with other UTI values should retain.  This value must be strictly either true or false if given, to avoid ambiguity with preceding parameters.
--
-- Returns:
--  * True if the operation succeeded, otherwise false (which most likely means ownership of the pasteboard has changed)
--
-- Notes:
--  * The UTI's of the items on the pasteboard can be determined with the [hs.pasteboard.allContentTypes](#allContentTypes) and [hs.pasteboard.contentTypes](#contentTypes) functions.
--  * Property lists consist only of certain types of data: tables, strings, numbers, dates, binary data, and Boolean values.
---@return boolean
function M.writePListForUTI(name, uti, data, add, ...) end

