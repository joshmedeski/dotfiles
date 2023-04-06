--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Controls for VOX music player
---@class hs.vox
local M = {}
hs.vox = M

-- Add media URL to current list
--
-- Parameters:
--  * url {string}
--
-- Returns:
--  * None
function M.addurl(url, ...) end

-- Skips the playback position backwards by about 7 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.backward() end

-- Decreases the player volume
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.decreaseVolume() end

-- Skips the playback position backwards by about 14 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.fastBackward() end

-- Skips the playback position forwards by about 17 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.fastForward() end

-- Skips the playback position forwards by about 7 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.forward() end

-- Gets the artist of current Album
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the artist of current Album, or nil if an error occurred
function M.getAlbumArtist() end

-- Gets the name of the album of the current track
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the Album of the current track, or nil if an error occurred
function M.getCurrentAlbum() end

-- Gets the name of the artist of the current track
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the Artist of the current track, or nil if an error occurred
function M.getCurrentArtist() end

-- Gets the current playback state of vox
--
-- Parameters:
--  * None
--
-- Returns:
--  * 0 for paused
--  * 1 for playing
function M.getPlayerState() end

-- Gets the uniqueID of the current track
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the current track, or nil if an error occurred
function M.getUniqueID() end

-- Increases the player volume
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.increaseVolume() end

-- Returns whether VOX is currently open
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether the vox application is running
function M.isRunning() end

-- Skips to the next track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.next() end

-- Pauses the current vox track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.pause() end

-- Plays the current vox track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.play() end

-- Toggles play/pause of current vox track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.playpause() end

-- Play media from the given URL
--
-- Parameters:
--  * url {string}
--
-- Returns:
--  * None
function M.playurl(url, ...) end

-- Skips to previous track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.previous() end

-- Toggle shuffle state of current list
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.shuffle() end

-- Toggle playlist
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.togglePlaylist() end

-- Displays information for current track on screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.trackInfo() end

