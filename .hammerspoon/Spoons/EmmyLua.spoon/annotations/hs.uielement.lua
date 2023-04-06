--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- A generalized framework for working with OSX UI elements
---@class hs.uielement
local M = {}
hs.uielement = M

-- Gets the currently focused UI element
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.uielement` object or nil if no object could be found
function M.focusedElement() end

-- Returns whether the UI element represents an application.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the UI element is an application
---@return boolean
function M:isApplication() end

-- Returns whether the UI element represents a window.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the UI element is a window, otherwise false
---@return boolean
function M:isWindow() end

-- Creates a new watcher
--
-- Parameters:
--  * A function to be called when a watched event occurs.  The function will be passed the following arguments:
--    * element: The element the event occurred on. Note this is not always the element being watched.
--    * event: The name of the event that occurred.
--    * watcher: The watcher object being created.
--    * userData: The userData you included, if any.
--  * an optional userData object which will be included as the final argument to the callback function when it is called.
--
-- Returns:
--  * An `hs.uielement.watcher` object, or `nil` if an error occurred
function M:newWatcher(handler, userData, ...) end

-- Returns the role of the element.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the role of the UI element
---@return string
function M:role() end

-- Returns the selected text in the element
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the selected text, or nil if none could be found
--
-- Notes:
--  * Many applications (e.g. Safari, Mail, Firefox) do not implement the necessary accessibility features for this to work in their web views
function M:selectedText() end

