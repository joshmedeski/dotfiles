--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This submodule allows you to create observers for accessibility elements and be notified when they trigger notifications. Not all notifications are supported by all elements and not all elements support notifications, so some trial and error will be necessary, but for compliant applications, this can allow your code to be notified when an application's user interface changes in some way.
---@class hs.axuielement.observer
local M = {}
hs.axuielement.observer = M

-- Registers the specified notification for the specified accessibility element with the observer.
--
-- Parameters:
--  * `element`      - the `hs.axuielement` representing an accessibility element of the application the observer was created for.
--  * `notification` - a string specifying the notification.
--
-- Returns:
--  * the observerObject; generates an error if watcher cannot be registered
--
-- Notes:
--  * multiple notifications for the same accessibility element can be registered by invoking this method multiple times with the same element but different notification strings.
--  * if the specified element and notification string are already registered, this method does nothing.
--  * the notification string is application dependent and can be any string that the application developers choose; some common ones are found in `hs.axuielement.observer.notifications`, but the list is not exhaustive nor is an application or element required to provide them.
function M:addWatcher(element, notification, ...) end

-- Get or set the callback for the observer.
--
-- Parameters:
--  * `fn` - a function, or an explicit nil to remove, specifying the callback function the observer will invoke when the assigned elements generate notifications.
--
-- Returns:
--  * If an argument is provided, the observerObject; otherwise the current value.
--
-- Notes:
--  * the callback should expect 4 arguments and return none. The arguments passed to the callback will be as follows:
--    * the observerObject itself
--    * the `hs.axuielement` object for the accessibility element which generated the notification
--    * a string specifying the specific notification which was received
--    * a table containing key-value pairs with more information about the notification, if the element and notification type provide it. Commonly this will be an empty table indicating that no additional detail was provided.
function M:callback(fn) end

-- Returns true or false indicating whether the observer is currently watching for notifications and generating callbacks.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean value indicating whether or not the observer is currently active.
---@return boolean
function M:isRunning() end

-- Creates a new observer object for the application with the specified process ID.
--
-- Parameters:
--  * `pid` - the process ID of the application.
--
-- Returns:
--  * a new observerObject; generates an error if the pid does not exist or if the object cannot be created.
--
-- Notes:
--  * If you already have the `hs.application` object for an application, you can get its process ID with `hs.application:pid()`
--  * If you already have an `hs.axuielement` from the application you wish to observe (it doesn't have to be the application axuielement object, just one belonging to the application), you can get the process ID with `hs.axuielement:pid()`.
function M.new(pid, ...) end

-- A table of common accessibility object notification names, provided for reference.
--
-- Notes:
--  * Notifications are application dependent and can be any string that the application developers choose; this list provides the suggested notification names found within the macOS Framework headers, but the list is not exhaustive nor is an application or element required to provide them.
---@type table
M.notifications = {}

-- Unregisters the specified notification for the specified accessibility element from the observer.
--
-- Parameters:
--  * `element`      - the `hs.axuielement` representing an accessibility element of the application the observer was created for.
--  * `notification` - a string specifying the notification.
--
-- Returns:
--  * the observerObject; generates an error if watcher cannot be unregistered
--
-- Notes:
--  * if the specified element and notification string are not currently registered with the observer, this method does nothing.
function M:removeWatcher(element, notification, ...) end

-- Start observing the application and trigger callbacks for the elements and notifications assigned.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the observerObject
--
-- Notes:
--  * This method does nothing if the observer is already running
function M:start() end

-- Stop observing the application; no further callbacks will be generated.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the observerObject
--
-- Notes:
--  * This method does nothing if the observer is not currently running
function M:stop() end

-- Returns a table of the notifications currently registered with the observer.
--
-- Parameters:
--  * `element` - an optional `hs.axuielement` to return a list of registered notifications for.
--
-- Returns:
--  * a table containing the currently registered notifications
--
-- Notes:
--  * If an element is specified, then the table returned will contain a list of strings specifying the specific notifications that the observer is watching that element for.
--  * If no argument is specified, then the table will contain key-value pairs in which each key will be an `hs.axuielement` that is being observed and the corresponding value will be a table containing a list of strings specifying the specific notifications that the observer is watching for from that element.
function M:watching(element, ...) end

