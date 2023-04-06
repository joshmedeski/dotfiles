--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This sub-module is used to access the individual results of a spotlightObject or a spotlightGroupObject.
--
-- Each Spotlight item contains attributes which you can access with the [hs.spotlight.item:valueForAttribute](#valueForAttribute) method. An array containing common attributes for the type of entity the item represents can be retrieved with the [hs.spotlight.item:attributes](#attributes) method, however this list of attributes is usually not a complete list of the attributes available for a given spotlightItemObject. Many of the known attribute names are included in the `hs.spotlight.commonAttributeKeys` constant array, but even this is not an exhaustive list -- an application may create and assign any key it wishes to an entity for inclusion in the Spotlight metadata database.
--
-- For convenience, metamethods have been added to the spotlightItemObjects as a shortcut to the [hs.spotlight.item:valueForAttribute](#valueForAttribute) method; e.g. you can access the value of a specific attribute by treating the attribute as a key name: `spotlightItemObject.kMDItemPath` will return the path to the entity the spotlightItemObject refers to.
---@class hs.spotlight.item
local M = {}
hs.spotlight.item = M

-- Returns a list of attributes associated with the spotlightItemObject
--
-- Parameters:
--  * None
--
-- Returns:
--  * an array table containing a list of attributes associated with the result item.
--
-- Notes:
--  * This list of attributes is usually not a complete list of the attributes available for a given spotlightItemObject. Many of the known attribute names are included in the `hs.spotlight.commonAttributeKeys` constant array, but even this is not an exhaustive list -- an application may create and assign any key it wishes to an entity for inclusion in the Spotlight metadata database.
--
-- * A common attribute, which is not usually included in the results of this method is the "kMDItemPath" attribute which specifies the local path to the file the entity represents. This is included here for reference, as it is a commonly desired value that is not obviously available for almost all Spotlight entries.
--  * It is believed that only those keys which are explicitly set when an item is added to the Spotlight database are included in the array returned by this method. Any attribute which is calculated or restricted in a sandboxed application appears to require an explicit request. This is, however, conjecture, and when in doubt you should explicitly check for the attributes you require with [hs.spotlight.item:valueForAttribute](#valueForAttribute) and not rely solely on the results from this method.
function M:attributes() end

-- Returns the value for the specified attribute of the spotlightItemObject
--
-- Parameters:
--  * `attribute` - a string specifying the attribute to get the value of for the spotlightItemObject
--
-- Returns:
--  * the attribute value as an appropriate data type or nil if the attribute does not exist or contains no value
--
-- Notes:
--  * See [hs.spotlight.item:attributes](#attributes) for information about possible attribute names.
--
--  * For convenience, metamethods have been added to the spotlightItemObject which allow you to use `spotlightItemObject.attribute` as a shortcut for `spotlightItemObject:valueForAttribute(attribute)`.
function M:valueForAttribute(attribute, ...) end

