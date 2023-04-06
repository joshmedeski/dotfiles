--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Inspect/manipulate the data sources of an audio device
--
-- Note: These objects are obtained from the methods on an `hs.audiodevice` object
---@class hs.audiodevice.datasource
local M = {}
hs.audiodevice.datasource = M

-- Gets the name of an audio device datasource
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the datasource
---@return string
function M:name() end

-- Sets the audio device datasource as the default
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.audiodevice.datasource` object
---@return hs.audiodevice.datasource
function M:setDefault() end

