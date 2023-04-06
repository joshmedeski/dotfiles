--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This submodule allows hs.axuielement to support using AXTextMarker and AXTextMarkerRange objects as parameters for parameterized Accessibility attributes with applications that support them.
--
-- Most Accessibility object values correspond to the common data types found in most programming languages -- strings, numbers, tables (arrays and dictionaries), etc. AXTextMarker and AXTextMarkerRange types are application specific and do not have a direct mapping to a simple data type. The description I've found most apt comes from comments within the Chromium source for the Mac version of their browser:
--
-- > // A serialization of a position as POD. Not for sharing on disk or sharing
-- > // across thread or process boundaries, just for passing a position to an
-- > // API that works with positions as opaque objects.
--
-- This submodule allows Lua to represent these as userdata which can be passed in to parameterized attributes for the application from which they were retrieved. Examples are expected to be added to the Hammerspoon wiki soon.
--
-- As this submodule utilizes private and undocumented functions in the HIServices framework, if you receive an error using any of these functions or methods indicating an undefined CF function (the function or method will return nil and a string of the format "CF function AX... undefined"), please make sure to include the output of the following in any issue you submit to the Hammerspoon github page (enter these into the Hammerspoon console):
--
--     hs.inspect(hs.axuielement.axtextmarker._functionCheck())
--     hs.inspect(hs.processInfo)
--     hs.host.operatingSystemVersionString()
---@class hs.axuielement.axtextmarker
local M = {}
hs.axuielement.axtextmarker = M

-- Returns a table of the AXTextMarker and AXTextMarkerRange functions that have been discovered and are used within this module.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table with key-value pairs where the keys correspond to the undocumented Core Foundation functions required by this module to support AXTextMarker and AXTextMarkerRange and the value will be a boolean indicating whether the function exists in the currently loaded frameworks.
--
-- Notes:
--  * the functions are defined within the HIServices framework which is part of the ApplicationServices framework, so it is expected that the necessary functions will always be available; however, if you ever receive an error message from a function or method within this submodule of the form "CF function AX... undefined", please see the submodule heading documentation for a description of the information, including that which this function provides, that should be included in any error report you submit.
--  * This is for debugging purposes and is not expected to be used often.
function M._functionCheck() end

-- Returns a string containing the opaque binary data contained within the axTextMarkerObject
--
-- Parameters:
--  * None
--
-- Returns:
--  *  a string containing the opaque binary data contained within the axTextMarkerObject
--
-- Notes:
--  * the string will likely contain invalid UTF8 code sequences or unprintable ascii values; to see the data in decimal or hexadecimal form you can use:
--     string.byte(hs.axuielement.axtextmarker:bytes(), 1, hs.axuielement.axtextmarker:length())
--     -- or
--     hs.utf8.hexDump(hs.axuielement.axtextmarker:bytes())
--  * As the data is application specific, it is unlikely that you will use this method often; it is included primarily for testing and debugging purposes.
function M:bytes() end

-- Returns the ending marker for an axTextMarkerRangeObject
--
-- Parameters:
--  * None
--
-- Returns:
--  *  the ending marker for an axTextMarkerRangeObject
function M:endMarker() end

-- Returns an integer specifying the number of bytes in the data portion of the axTextMarkerObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  *  an integer specifying the number of bytes in the data portion of the axTextMarkerObject
--
-- Notes:
--  * As the data is application specific, it is unlikely that you will use this method often; it is included primarily for testing and debugging purposes.
function M:length() end

-- Creates a new AXTextMarker object from the string of binary data provided
--
-- Parameters:
--  * `string` - a string containing 1 or more bytes of data for the AXTextMarker object
--
-- Returns:
--  * a new axTextMarkerObject or nil and a string description if there was an error
--
-- Notes:
--  * This function is included primarily for testing and debugging purposes -- in general you will probably never use this constructor; AXTextMarker objects appear to be mostly application dependant and have no meaning external to the application from which it was created.
function M.newMarker(string, ...) end

-- Creates a new AXTextMarkerRange object from the start and end markers provided
--
-- Parameters:
--  * `startMarker` - an axTextMarkerObject representing the start of the range to be created
--  * `endMarker`   - an axTextMarkerObject representing the end of the range to be created
--
-- Returns:
--  * a new axTextMarkerRangeObject or nil and a string description if there was an error
--
-- Notes:
--  * this constructor can be used to create a range from axTextMarkerObjects obtained from an application to specify a new range for a parameterized attribute. As a simple example (it is hoped that more will be added to the Hammerspoon wiki shortly):
--     ```lua
--     s = hs.axuielement.applicationElement(hs.application("Safari"))
--     -- for a window displaying the DuckDuckGo main search page, this gets the
--     -- primary display area. Other pages may vary and you should build your
--     -- object as necessary for your target.
--     c = s("AXMainWindow")("AXSections")[1].SectionObject[1][1]
--     start = c("AXStartTextMarker") -- get the text marker for the start of this element
--     ending = c("AXNextLineEndTextMarkerForTextMarker", start) -- get the next end of line marker
--     print(c("AXStringForTextMarkerRange", hs.axuielement.axtextmarker.newRange(start, ending)))
--     -- outputs "Privacy, simplified." to the Hammerspoon console```
--  * The specific attributes and parameterized attributes supported by a given application differ and can be discovered with the `hs.axuielement:getAttributeNames` and `hs.axuielement:getParameterizedAttributeNames` methods.
function M.newRange(startMarker, endMarker, ...) end

-- Returns the starting marker for an axTextMarkerRangeObject
--
-- Parameters:
--  * None
--
-- Returns:
--  *  the starting marker for an axTextMarkerRangeObject
function M:startMarker() end

