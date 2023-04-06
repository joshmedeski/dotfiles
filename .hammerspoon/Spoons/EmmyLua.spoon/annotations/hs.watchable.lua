--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- A minimalistic Key-Value-Observer framework for Lua.
--
-- This module allows you to generate a table with a defined label or path that can be used to share data with other modules or code.  Other modules can register as watchers to a specific key-value pair within the watchable object table and will be automatically notified when the key-value pair changes.
--
-- The goal is to provide a mechanism for sharing state information between separate and (mostly) unrelated code easily and in an independent fashion.
---@class hs.watchable
local M = {}
hs.watchable = M

-- Change or remove the callback function for the watchableObject.
--
-- Parameters:
--  * `fn` - a function, or an explicit nil to remove, specifying the new callback function to receive notifications for this watchableObject
--
-- Returns:
--  * the watchableObject
--
-- Notes:
--  * see [hs.watchable.watch](#watch) for a description of the arguments the callback function should expect.
function M:callback(fn) end

-- Externally change the value of the key-value pair being watched by the watchableObject
--
-- Parameters:
--  * `key`   - if the watchableObject was defined with a key of "*", this argument is required and specifies the specific key of the watched table to change the value of.  If a specific key was specified when the watchableObject was defined, this argument must not be provided.
--  * `value` - the new value for the key.
--
-- Returns:
--  * the watchableObject
--
-- Notes:
--  * if external changes are not allowed for the specified path, this method generates an error
function M:change(key, value, ...) end

-- Creates a table that can be watched by other modules for key changes
--
-- Parameters:
--  * `path`            - the global name for this internal table that external code can refer to the table as.
--  * `externalChanges` - an optional boolean, default false, specifying whether external code can make changes to keys within this table (bi-directional communication).
--
-- Returns:
--  * a table with metamethods which will notify external code which is registered to watch this table for key-value changes.
--
-- Notes:
--  * This constructor is used by code which wishes to share state information which other code may register to watch.
--
--  * You may specify any string name as a path, but it must be unique -- an error will occur if the path name has already been registered.
--  * All key-value pairs stored within this table are potentially watchable by external code -- if you wish to keep some data private, do not store it in this table.
--  * `externalChanges` will apply to *all* keys within this table -- if you wish to only allow some keys to be externally modifiable, you will need to register separate paths.
--  * If external changes are enabled, you will need to register your own watcher with [hs.watchable.watch](#watch) if action is required when external changes occur.
function M.new(path, externalChanges, ...) end

-- Temporarily stop notifications about the key-value pair(s) watched by this watchableObject.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the watchableObject
function M:pause() end

-- Removes the watchableObject so that key-value pairs watched by this object no longer generate notifications.
--
-- Parameters:
--  * None
--
-- Returns:
--  * nil
function M:release() end

-- Resume notifications about the key-value pair(s) watched by this watchableObject which were previously paused.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the watchableObject
function M:resume() end

-- Get the current value for the key-value pair being watched by the watchableObject
--
-- Parameters:
--  * `key` - if the watchableObject was defined with a key of "*", this argument is required and specifies the specific key of the watched table to retrieve the value for.  If a specific key was specified when the watchableObject was defined, this argument is ignored.
--
-- Returns:
--  * The current value for the key-value pair being watched by the watchableObject. May be nil.
function M:value(key, ...) end

-- Creates a watcher that will be invoked when the specified key in the specified path is modified.
--
-- Parameters:
--  * `path`     - a string specifying the path to watch.  If `key` is not provided, then this should be a string of the form "path.key" where the key will be identified as the string after the last "."
--  * `key`      - if provided, a string specifying the specific key within the path to watch.
--  * `callback` - an optional function which will be invoked when changes occur to the key specified within the path.  The function should expect the following arguments:
--    * `watcher` - the watcher object itself
--    * `path`    - the path being watched
--    * `key`     - the specific key within the path which invoked this callback
--    * `old`     - the old value for this key, may be nil
--    * `new`     - the new value for this key, may be nil
--
-- Returns:
--  * a watchableObject
--
-- Notes:
--  * This constructor is used by code which wishes to watch state information which is being shared by other code.
--
--  * The callback function is invoked after the new value has already been set -- the callback is a "didChange" notification, not a "willChange" notification.
--
--  * If the key (specified as a separate argument or as the final component of path) is "*", then all key-value pair changes that occur for the table specified by the path will invoke a callback.  This is a shortcut for watching an entire table, rather than just a specific key-value pair of the table.
--  * It is possible to register a watcher for a path that has not been registered with [hs.watchable.new](#new) yet. Retrieving the current value with [hs.watchable:value](#value) in such a case will return nil.
function M.watch(path, key, callback, ...) end

