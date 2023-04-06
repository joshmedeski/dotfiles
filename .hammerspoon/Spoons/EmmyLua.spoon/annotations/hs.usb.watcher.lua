--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch for USB device connection/disconnection events
---@class hs.usb.watcher
local M = {}
hs.usb.watcher = M

-- Creates a new watcher for USB device events
--
-- Parameters:
--  * fn - A function that will be called when a USB device is inserted or removed. The function should accept a single parameter, which is a table containing the following keys:
--   * eventType - A string containing either "added" or "removed" depending on whether the USB device was connected or disconnected
--   * productName - A string containing the name of the device
--   * vendorName - A string containing the name of the device vendor
--   * vendorID - A number containing the Vendor ID of the device
--   * productID - A number containing the Product ID of the device
--
-- Returns:
--  * A `hs.usb.watcher` object
---@return hs.usb.watcher
function M.new(fn) end

-- Starts the USB watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.usb.watcher` object
---@return hs.usb.watcher
function M:start() end

-- Stops the USB watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.usb.watcher` object
---@return hs.usb.watcher
function M:stop() end

