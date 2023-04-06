--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect USB devices
---@class hs.usb
local M = {}
hs.usb = M

-- Gets details about currently attached USB devices
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing information about currently attached USB devices, or nil if an error occurred. The table contains a sub-table for each USB device, the keys of which are:
--   * productName - A string containing the name of the device
--   * vendorName - A string containing the name of the device vendor
--   * vendorID - A number containing the Vendor ID of the device
--   * productID - A number containing the Product ID of the device
function M.attachedDevices() end

