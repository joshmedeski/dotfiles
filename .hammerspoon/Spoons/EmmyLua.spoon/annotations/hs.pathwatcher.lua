--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Watch paths recursively for changes
--
-- This simple example watches your Hammerspoon directory for changes, and when it sees a change, reloads your configs:
--
--     local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.pathwatcher
local M = {}
hs.pathwatcher = M

-- Creates a new path watcher object
--
-- Parameters:
--  * path - A string containing the path to be watched
--  * fn - A function to be called when changes are detected. It should accept two arguments:
--    * `paths`: a table containing a list of file paths that have changed
--    * `flagTables`: a table containing a list of tables denoting how each corresponding file in `paths` has changed, each containing boolean values indicating which types of events occurred; The possible keys are:
--      * mustScanSubDirs
--      * userDropped
--      * kernelDropped
--      * eventIdsWrapped
--      * historyDone
--      * rootChanged
--      * mount
--      * unmount
--      * itemCreated
--      * itemRemoved
--      * itemInodeMetaMod
--      * itemRenamed
--      * itemModified
--      * itemFinderInfoMod
--      * itemChangeOwner
--      * itemXattrMod
--      * itemIsFile
--      * itemIsDir
--      * itemIsSymlink
--      * ownEvent (OS X 10.9+)
--      * itemIsHardlink (OS X 10.10+)
--      * itemIsLastHardlink (OS X 10.10+)
--
-- Returns:
--  * An `hs.pathwatcher` object
--
-- Notes:
--  * For more information about the event flags, see [the official documentation](https://developer.apple.com/reference/coreservices/1455361-fseventstreameventflags/)
---@return hs.pathwatcher
function M.new(path, fn, ...) end

-- Starts a path watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.pathwatcher` object
function M:start() end

-- Stops a path watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:stop() end

