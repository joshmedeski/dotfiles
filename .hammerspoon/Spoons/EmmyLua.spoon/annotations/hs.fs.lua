--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Access/inspect the filesystem
--
-- This module is partial superset of LuaFileSystem 1.8.0 (http://keplerproject.github.io/luafilesystem/). It has been modified to remove functions which do not apply to macOS filesystems and additional functions providing macOS specific filesystem information have been added.
---@class hs.fs
local M = {}
hs.fs = M

-- Gets the attributes of a file
--
-- Parameters:
--  * filepath - A string containing the path of a file to inspect
--  * aName - An optional attribute name. If this value is specified, only the attribute requested, is returned
--
-- Returns:
--  * A table with the file attributes corresponding to filepath (or nil followed by an error message in case of error). If the second optional argument is given, then a string is returned with the value of the named attribute. attribute mode is a string, all the others are numbers, and the time related attributes use the same time reference of os.time:
--   * dev - A number containing the device the file resides on
--   * ino - A number containing the inode of the file
--   * mode - A string containing the type of the file (possible values are: file, directory, link, socket, named pipe, char device, block device or other)
--   * nlink - A number containing a count of hard links to the file
--   * uid - A number containing the user-id of owner
--   * gid - A number containing the group-id of owner
--   * rdev - A number containing the type of device, for files that are char/block devices
--   * access - A number containing the time of last access modification (as seconds since the UNIX epoch)
--   * change - A number containing the time of last file status change (as seconds since the UNIX epoch)
--   * modification - A number containing the time of the last file contents change (as seconds since the UNIX epoch)
--   * permissions - A 9 character string specifying the user access permissions for the file. The first three characters represent Read/Write/Execute permissions for the file owner. The first character will be "r" if the user has read permissions, "-" if they do not; the second will be "w" if they have write permissions, "-" if they do not; the third will be "x" if they have execute permissions, "-" if they do not. The second group of three characters follow the same convention, but refer to whether or not the file's group have Read/Write/Execute permissions, and the final three characters follow the same convention, but apply to other system users not covered by the Owner or Group fields.
--   * creation - A number containing the time the file was created (as seconds since the UNIX epoch)
--   * size - A number containing the file size, in bytes
--   * blocks - A number containing the number of blocks allocated for file
--   * blksize - A number containing the optimal file system I/O blocksize
--
-- Notes:
--  * This function uses `stat()` internally thus if the given filepath is a symbolic link, it is followed (if it points to another link the chain is followed recursively) and the information is about the file it refers to. To obtain information about the link itself, see function `hs.fs.symlinkAttributes()`
function M.attributes(filepath, aName, ...) end

-- Changes the current working directory to the given path.
--
-- Parameters:
--  * path - A string containing the path to change working directory to
--
-- Returns:
--  * If successful, returns true, otherwise returns nil and an error string
function M.chdir(path, ...) end

-- Gets the current working directory
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the current working directory, or if an error occurred, nil and an error string
function M.currentDir() end

-- Creates an iterator for walking a filesystem path
--
-- Parameters:
--  * path - A string containing a directory to iterate
--
-- Returns:
--  * An iterator function
--  * A data object to pass to the iterator function or an error message as a string
--  * `nil` as the initial argument for the iterator (unused and unnecessary in this case, but conforms to Lua spec for iterators). Ignore this value if you are not using this function with `for` (see Notes).
--  * A second data object used by `for` to close the directory object immediately when the loop terminates. Ignore this value if you are not using this function with `for` (see Notes).
--
-- Notes:
--  * Unlike most functions in this module, `hs.fs.dir` will throw a Lua error if the supplied path cannot be iterated.
--
--  * The simplest way to use this function is with a `for` loop. When used in this manner, the `for` loop itself will take care of closing the directory stream for us, even if we break out of the loop early.
--    ```
--       for file in hs.fs.dir("/Users/Guest/Documents") do
--           print(file)
--       end
--    ```
--
--  * It is also possible to use the dir_obj directly if you wish:
--    ```
--       local iterFn, dirObj = hs.fs.dir("/Users/Guest/Documents")
--       local file = dirObj:next() -- get the first file in the directory
--       while (file) do
--           print(file)
--           file = dirObj:next() -- get the next file in the directory
--       end
--       dirObj:close() -- necessary to make sure that the directory stream is closed
--    ```
function M.dir(path, ...) end

-- Returns the display name of the file or directory at a specified path.
--
-- Parameters:
--  * filepath - The path to the file or directory
--
-- Returns:
--  * a string containing the display name of the file or directory at a specified path; returns nil if no file with the specified path exists.
---@return string
function M.displayName(filepath, ...) end

-- Returns the Uniform Type Identifier for the file location specified.
--
-- Parameters:
--  * path - the path to the file to return the UTI for.
--
-- Returns:
--  * a string containing the Uniform Type Identifier for the file location specified or nil if an error occurred
function M.fileUTI(path, ...) end

-- Returns the fileUTI's equivalent form in an alternate type specification format.
--
-- Parameters:
--  * a string containing a file UTI, such as one returned by `hs.fs.fileUTI`.
--  * a string specifying the alternate format for the UTI.  This string may be one of the following:
--     * `extension`  - as a file extension, commonly used for platform independent file sharing when file metadata can't be guaranteed to be cross-platform compatible.  Generally considered unreliable when other file type identification methods are available.
--    * `mime`       - as a mime-type, commonly used by Internet applications like web browsers and email applications.
--    * `pasteboard` - as an NSPasteboard type (see `hs.pasteboard`).
--    * `ostype`     - four character file type, most common pre OS X, but still used in some legacy APIs.
--
-- Returns:
--  * the file UTI in the alternate format or nil if the UTI does not have an alternate of the specified type.
---@return string
function M.fileUTIalternate(fileUTI, type, ...) end

-- Get the Finder comments for the file or directory at the specified path
--
-- Parameters:
--  * path - the path to the file or directory you wish to get the comments of
--
-- Returns:
--  * a string containing the Finder comments for the file or directory specified.  If no comments have been set for the file, returns an empty string.  If an error occurs, most commonly an invalid path, this function will throw a Lua error.
--
-- Notes:
--  * This function uses `hs.osascript` to access the file comments through AppleScript
---@return string
function M.getFinderComments(path, ...) end

-- Creates a link
--
-- Parameters:
--  * old - A string containing a path to a filesystem object to link from
--  * new - A string containing a path to create the link at
--  * symlink - An optional boolean, true to create a symlink, false to create a hard link. Defaults to false
--
-- Returns:
--  * True if the link was created, otherwise nil and an error string
function M.link(old, new, symlink, ...) end

-- Locks a file, or part of it
--
-- Parameters:
--  * filehandle - An open file
--  * mode - A string containing either "r" for a shared read lock, or "w" for an exclusive write lock
--  * start - An optional number containing an offset into the file to start the lock at. Defaults to 0
--  * length - An optional number containing the length of the file to lock. Defaults to the full size of the file
--
-- Returns:
--  * True if the lock was obtained successfully, otherwise nil and an error string
function M.lock(filehandle, mode, start, length, ...) end

-- Locks a directory
--
-- Parameters:
--  * path - A string containing the path to a directory
--  * seconds_stale - An optional number containing an age (in seconds) beyond which to consider an existing lock as stale. Defaults to INT_MAX (which is, broadly speaking, equivalent to "never")
--
-- Returns:
--  * If successful, a lock object, otherwise nil and an error string
--
-- Notes:
--  * This is not a low level OS feature, the lock is actually a file created in the path, called `lockfile.lfs`, so the directory must be writable for this function to succeed
--  * The returned lock object can be freed with ```lock:free()```
--  * If the lock already exists and is not stale, the error string returned will be "File exists"
function M.lockDir(path, seconds_stale, ...) end

-- Creates a new directory
--
-- Parameters:
--  * dirname - A string containing the path of a directory to create
--
-- Returns:
--  * True if the directory was created, otherwise nil and an error string
function M.mkdir(dirname, ...) end

-- Gets the file path from a binary encoded bookmark.
--
-- Parameters:
--  * data - The binary encoded Bookmark.
--
-- Returns:
--  * A string containing the path to the Bookmark URL or `nil` if an error occurs.
--  * An error message if an error occurs.
--
-- Notes:
--  * A bookmark provides a persistent reference to a file-system resource.
--    When you resolve a bookmark, you obtain a URL to the resource’s current location.
--    A bookmark’s association with a file-system resource (typically a file or folder)
--    usually continues to work if the user moves or renames the resource, or if the
--    user relaunches your app or restarts the system.
--  * No volumes are mounted during the resolution of the bookmark data.
function M.pathFromBookmark(data, ...) end

-- Gets the absolute path of a given path
--
-- Parameters:
--  * filepath - Any kind of file or directory path, be it relative or not
--
-- Returns:
--  * A string containing the absolute path of `filepath` (i.e. one that doesn't include `.`, `..` or symlinks)
--  * Note that symlinks will be resolved to their target file
---@return string
function M.pathToAbsolute(filepath, ...) end

-- Returns the path as binary encoded bookmark data.
--
-- Parameters:
--  * path - The path to encode
--
-- Returns:
--  * Bookmark data in a binary encoded string or `nil` if path is invalid.
function M.pathToBookmark(path, ...) end

-- Removes an existing directory
--
-- Parameters:
--  * dirname - A string containing the path to a directory to remove
--
-- Returns:
--  * True if the directory was removed, otherwise nil and an error string
function M.rmdir(dirname, ...) end

-- Set the Finder comments for the file or directory at the specified path to the comment specified
--
-- Parameters:
--  * path    - the path to the file or directory you wish to set the comments of
--  * comment - a string specifying the comment to set.  If this parameter is missing or is an explicit nil, the existing comment is cleared.
--
-- Returns:
--  * true on success; on error, most commonly an invalid path, this function will throw a Lua error.
--
-- Notes:
--  * This function uses `hs.osascript` to access the file comments through AppleScript
---@return boolean
function M.setFinderComments(path, comment, ...) end

-- Gets the attributes of a symbolic link
--
-- Parameters:
--  * filepath - A string containing the path of a link to inspect
--  * aName - An optional attribute name. If this value is specified, only the attribute requested, is returned
--
-- Returns:
--  * A table or string if the values could be found, otherwise nil and an error string.
--
-- Notes:
--  * The return values for this function are identical to those provided by `hs.fs.attributes()` with the following addition: the attribute name "target" is added and specifies a string containing the absolute path that the symlink points to.
function M.symlinkAttributes (filepath, aname, ...) end

-- Adds one or more tags to the Finder tags of a file
--
-- Parameters:
--  * filepath - A string containing the path of a file
--  * tags - A table containing one or more strings, each containing a tag name
--
-- Returns:
--  * true if the tags were updated; throws a lua error if an error occurs updating the tags
function M.tagsAdd(filepath, tags, ...) end

-- Gets the Finder tags of a file
--
-- Parameters:
--  * filepath - A string containing the path of a file
--
-- Returns:
--  * A table containing the list of the file's tags, or nil if the file has no tags assigned; throws a lua error if an error accessing the file occurs
function M.tagsGet(filepath, ...) end

-- Removes Finder tags from a file
--
-- Parameters:
--  * filepath - A string containing the path of a file
--  * tags - A table containing one or more strings, each containing a tag name
--
-- Returns:
--  * true if the tags were updated; throws a lua error if an error occurs updating the tags
function M.tagsRemove(filepath, tags, ...) end

-- Sets the Finder tags of a file, removing any that are already set
--
-- Parameters:
--  * filepath - A string containing the path of a file
--  * tags - A table containing zero or more strings, each containing a tag name
--
-- Returns:
--  * true if the tags were set; throws a lua error if an error occurs setting the new tags
function M.tagsSet(filepath, tags, ...) end

-- Returns the path of the temporary directory for the current user.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The path to the system designated temporary directory for the current user.
---@return string
function M.temporaryDirectory() end

-- Updates the access and modification times of a file
--
-- Parameters:
--  * filepath - A string containing the path of a file to touch
--  * atime - An optional number containing the new access time of the file to set (as seconds since the Epoch). Defaults to now
--  * mtime - An optional number containing the new modification time of the file to set (as seconds since the Epoch). Defaults to the value of atime
--
-- Returns:
--  * True if the operation was successful, otherwise nil and an error string
function M.touch(filepath, atime, mtime, ...) end

-- Unlocks a file or a part of it.
--
-- Parameters:
--  * filehandle - An open file
--  * start - An optional number containing an offset from the start of the file, to unlock. Defaults to 0
--  * length - An optional number containing the length of file to unlock. Defaults to the full size of the file
--
-- Returns:
--  * True if the unlock succeeded, otherwise nil and an error string
function M.unlock(filehandle, start, length, ...) end

-- Returns the encoded URL from a path.
--
-- Parameters:
--  * path - The path
--
-- Returns:
--  * A string or `nil` if path is invalid.
function M.urlFromPath(path, ...) end

