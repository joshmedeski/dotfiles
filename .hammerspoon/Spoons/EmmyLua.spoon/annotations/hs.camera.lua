--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect the system's camera devices
---@class hs.camera
local M = {}
hs.camera = M

-- Get all the cameras known to the system
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing all of the known cameras
function M.allCameras() end

-- Get the raw connection ID of the camera
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the connection ID of the camera
---@return string
function M:connectionID() end

-- Get the usage status of the camera
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, True if the camera is in use, otherwise False
---@return boolean
function M:isInUse() end

-- Checks if the property watcher on a camera object is running
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, True if the property watcher is running, otherwise False
---@return boolean
function M:isPropertyWatcherRunning() end

-- Checks if the camera devices watcher is running
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, True if the watcher is running, otherwise False
---@return boolean
function M.isWatcherRunning() end

-- Get the name of the camera
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the camera
---@return string
function M:name() end

-- Sets or clears a callback for when the properties of an hs.camera object change
--
-- Parameters:
--  * fn - A function to be called when properties of the camera change, or nil to clear a previously set callback. The function should accept the following parameters:
--   * The hs.camera object that changed
--   * A string describing the property that changed. Possible values are:
--    * gone - The device's "in use" status changed (ie another app started using the camera, or stopped using it)
--   * A string containing the scope of the event, this will likely always be "glob"
--   * A number containing the element of the event, this will likely always be "0"
--
-- Returns:
--  * The `hs.camera` object
---@return hs.camera
function M:setPropertyWatcherCallback(fn) end

-- Sets/clears the callback function for the camera devices watcher
--
-- Parameters:
--  * fn - A callback function, or nil to remove a previously set callback. The callback should accept a two arguments (see Notes below)
--
-- Returns:
--  * None
--
-- Notes:
--  * The callback will be called when a camera is added or removed from the system
--  * To watch for changes within a single camera device, see `hs.camera:newWatcher()`
--  * The callback function arguments are:
--   * An hs.camera device object for the affected device
--   * A string, either "Added" or "Removed" depending on whether the device was added or removed from the system
--  * For "Removed" events, most methods on the hs.camera device object will not function correctly anymore and the device object passed to the callback is likely to be useless. It is recommended you re-check `hs.camera.allCameras()` and keep records of the cameras you care about
--  * Passing nil will cause the watcher to stop if it is running
function M.setWatcherCallback(fn) end

-- Starts the property watcher on a camera
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.camera` object
function M:startPropertyWatcher() end

-- Starts the camera devices watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.startWatcher() end

-- Stops the property watcher on a camera
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.camera` object
function M:stopPropertyWatcher() end

-- Stops the camera devices watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.stopWatcher() end

-- Get the UID of the camera
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the UID of the camera
--
-- Notes:
--  * The UID is not guaranteed to be stable across reboots
---@return string
function M:uid() end

