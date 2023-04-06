--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Interact with NSDistributedNotificationCenter
-- There are many notifications posted by parts of OS X, and third party apps, which may be interesting to react to using this module.
--
-- You can discover the notifications that are being posted on your system with some code like this:
-- ```
-- foo = hs.distributednotifications.new(function(name, object, userInfo) print(string.format("name: %s\nobject: %s\nuserInfo: %s\n", name, object, hs.inspect(userInfo))) end)
-- foo:start()
-- ```
--
-- Note that distributed notifications are expensive - they involve lots of IPC. Also note that they are not guaranteed to be delivered, particularly if the system is very busy.
---@class hs.distributednotifications
local M = {}
hs.distributednotifications = M

-- Creates a new NSDistributedNotificationCenter watcher
--
-- Parameters:
--  * callback - A function to be called when a matching notification arrives. The function should accept one argument:
--   * notificationName - A string containing the name of the notification
--  * name - An optional string containing the name of notifications to watch for. A value of `nil` will cause all notifications to be watched on macOS versions earlier than Catalina. Defaults to `nil`.
--  * object - An optional string containing the name of sending objects to watch for. A value of `nil` will cause all sending objects to be watched. Defaults to `nil`.
--
-- Returns:
--  * An `hs.distributednotifications` object
--
-- Notes:
--  * On Catalina and above, it is no longer possible to observe all notifications - the `name` parameter is effectively now required. See https://mjtsai.com/blog/2019/10/04/nsdistributednotificationcenter-no-longer-supports-nil-names
function M.new(callback, name, object, ...) end

-- Sends a distributed notification
--
-- Parameters:
--  * name - A string containing the name of the notification
--  * sender - An optional string containing the name of the sender of the notification (in the form `com.domain.application.foo`). Defaults to nil.
--  * userInfo - An optional table containing additional information to post with the notification. Defaults to nil.
--
-- Returns:
--  * None
function M.post(name, sender, userInfo, ...) end

-- Starts a NSDistributedNotificationCenter watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.distributednotifications` object
function M:start() end

-- Stops a NSDistributedNotificationCenter watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.distributednotifications` object
function M:stop() end

