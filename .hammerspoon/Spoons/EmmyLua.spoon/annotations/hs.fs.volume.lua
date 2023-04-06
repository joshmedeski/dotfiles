--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Interact with OS X filesystem volumes
--
-- This is distinct from hs.fs in that hs.fs deals with UNIX filesystem operations, while hs.fs.volume interacts with the higher level OS X concept of volumes
---@class hs.fs.volume
local M = {}
hs.fs.volume = M

-- Returns a table of information about disk volumes attached to the system
--
-- Parameters:
--  * showHidden - An optional boolean, true to show hidden volumes, false to not show hidden volumes. Defaults to false.
--
-- Returns:
--  * A table of information, where the keys are the paths of disk volumes
--
-- Notes:
--  * This is an alias for `hs.host.volumeInformation()`
--  * The possible keys in the table are:
--   * NSURLVolumeTotalCapacityKey - Size of the volume in bytes
--   * NSURLVolumeAvailableCapacityKey - Available space on the volume in bytes
--   * NSURLVolumeIsAutomountedKey - Boolean indicating if the volume was automounted
--   * NSURLVolumeIsBrowsableKey - Boolean indicating if the volume can be browsed
--   * NSURLVolumeIsEjectableKey - Boolean indicating if the volume should be ejected before its media is removed
--   * NSURLVolumeIsInternalKey - Boolean indicating if the volume is an internal drive or an external drive
--   * NSURLVolumeIsLocalKey - Boolean indicating if the volume is a local or remote drive
--   * NSURLVolumeIsReadOnlyKey - Boolean indicating if the volume is read only
--   * NSURLVolumeIsRemovableKey - Boolean indicating if the volume's media can be physically ejected from the drive (e.g. a DVD)
--   * NSURLVolumeMaximumFileSizeKey - Maximum file size the volume can support, in bytes
--   * NSURLVolumeUUIDStringKey - The UUID of volume's filesystem
--   * NSURLVolumeURLForRemountingKey - For remote volumes, the network URL of the volume
--   * NSURLVolumeLocalizedNameKey - Localized version of the volume's name
--   * NSURLVolumeNameKey - The volume's name
--   * NSURLVolumeLocalizedFormatDescriptionKey - Localized description of the volume
-- * Not all keys will be present for all volumes
-- * The meanings of NSURLVolumeIsEjectableKey and NSURLVolumeIsRemovableKey are not generally useful for determining if a drive is removable in the modern sense (e.g. a USB drive) as much of this terminology dates back to when USB didn't exist and removable drives were things like Floppy/DVD drives. If you're trying to determine if a drive is not fixed into the computer, you may need to use a combination of these keys, but which exact combination you should use, is not consistent across macOS versions.
function M.allVolumes(showHidden, ...) end

-- A volume was mounted
M.didMount = nil

-- A volume changed either its name or mountpoint (or more likely, both)
M.didRename = nil

-- A volume was unmounted
M.didUnmount = nil

-- Unmounts and ejects a volume
--
-- Parameters:
--  * path - An absolute path to the volume you wish to eject
--
-- Returns:
--  * A boolean, true if the volume was ejected, otherwise false
--  * A string, empty if the volume was ejected, otherwise it will contain the error message
function M.eject(path, ...) end

-- Creates a watcher object for volume events
--
-- Parameters:
--  * fn - A function that will be called when volume events happen. It should accept two parameters:
--   * An event type (see the constants defined above)
--   * A table that will contain relevant information
--
-- Returns:
--  * An `hs.fs.volume` object
function M.new(fn) end

-- Starts the volume watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.fs.volume` object
function M:start() end

-- Stops the volume watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * An `hs.fs.volume` object
function M:stop() end

-- A volume is about to be unmounted
M.willUnmount = nil

