--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This sub-module is used to access results to a spotlightObject query which have been grouped by one or more attribute values.
--
-- A spotlightGroupObject is a special object created when you specify one or more grouping attributes with [hs.spotlight:groupingAttributes](#groupingAttributes). Spotlight items which match the Spotlight query and share a common value for the specified attribute will be grouped in objects you can retrieve with the [hs.spotlight:groupedResults](#groupedResults) method. This method returns an array of spotlightGroupObjects.
--
-- For each spotlightGroupObject you can identify the attribute and value the grouping represents with the [hs.spotlight.group:attribute](#attribute) and [hs.spotlight.group:value](#value) methods.  An array of the results which belong to the group can be retrieved with the [hs.spotlight.group:resultAtIndex](#resultAtIndex) method.  For convenience, metamethods have been added to the spotlightGroupObject which make accessing individual results easier:  an individual spotlightItemObject may be accessed from a spotlightGroupObject by treating the spotlightGroupObject like an array; e.g. `spotlightGroupObject[n]` will access the n'th spotlightItemObject in the grouped results.
---@class hs.spotlight.group
local M = {}
hs.spotlight.group = M

-- Returns the name of the attribute the spotlightGroupObject results are grouped by.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the attribute name as a string
---@return string
function M:attribute() end

-- Returns the number of query results contained in the spotlightGroupObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an integer specifying the number of results that match the attribute and value represented by this spotlightGroup object.
--
-- Notes:
--  * For convenience, metamethods have been added to the spotlightGroupObject which allow you to use `#spotlightGroupObject` as a shortcut for `spotlightGroupObject:count()`.
---@return number
function M:count() end

-- Returns the spotlightItemObject at the specified index of the spotlightGroupObject
--
-- Parameters:
--  * `index` - an integer specifying the index of the result to return.
--
-- Returns:
--  * the spotlightItemObject at the specified index or an error if the index is out of bounds.
--
-- Notes:
--  * For convenience, metamethods have been added to the spotlightGroupObject which allow you to use `spotlightGroupObject[index]` as a shortcut for `spotlightGroupObject:resultAtIndex(index)`.
function M:resultAtIndex(index, ...) end

-- Returns the subgroups of the spotlightGroupObject
--
-- Parameters:
--  * None
--
-- Returns:
--  * an array table containing the subgroups of the spotlightGroupObject or nil if no subgroups exist
--
-- Notes:
--  * Subgroups are created when you supply more than one grouping attribute to `hs.spotlight:groupingAttributes`.
function M:subgroups() end

-- Returns the value for the attribute the spotlightGroupObject results are grouped by.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the attribute value as an appropriate data type
function M:value() end

