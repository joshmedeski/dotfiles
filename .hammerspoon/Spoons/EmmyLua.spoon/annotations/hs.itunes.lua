--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Controls for iTunes music player
---@class hs.itunes
local M = {}
hs.itunes = M

-- Displays information for current track on screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.displayCurrentTrack() end

-- Skips the current playback forwards by 5 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.ff() end

-- Gets the name of the current Album
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the Album of the current track, or nil if an error occurred
function M.getCurrentAlbum() end

-- Gets the name of the current Artist
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the Artist of the current track, or nil if an error occurred
function M.getCurrentArtist() end

-- Gets the name of the current track
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the current track, or nil if an error occurred
function M.getCurrentTrack() end

-- Gets the duration (in seconds) of the current song
--
-- Parameters:
--  * None
--
-- Returns:
--  * The number of seconds long the current song is, 0 if no song is playing
function M.getDuration() end

-- Gets the current playback state of iTunes
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing one of the following constants:
--    - `hs.itunes.state_stopped`
--    - `hs.itunes.state_paused`
--    - `hs.itunes.state_playing`
function M.getPlaybackState() end

-- Gets the playback position (in seconds) of the current song
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number indicating the current position in the song
function M.getPosition() end

-- Gets the current iTunes volume setting
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number, between 1 and 100, containing the current iTunes playback volume
function M.getVolume() end

-- Returns whether iTunes is currently playing
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether iTunes is currently playing a track, or nil if an error occurred (unknown player state). Also returns false if the application is not running
function M.isPlaying() end

-- Returns whether iTunes is currently open. Most other functions in hs.itunes will automatically start the application, so this function can be used to guard against that.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether the iTunes application is running.
function M.isRunning() end

-- Skips to the next itunes track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.next() end

-- Pauses the current iTunes track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.pause() end

-- Plays the current iTunes track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.play() end

-- Toggles play/pause of current iTunes track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.playpause() end

-- Skips to previous itunes track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.previous() end

-- Skips the current playback backwards by 5 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.rw() end

-- Sets the playback position of the current song
--
-- Parameters:
--  * pos - A number indicating the playback position (in seconds) to skip to
--
-- Returns:
--  * None
function M.setPosition(pos, ...) end

-- Sets the iTunes playback volume
--
-- Parameters:
--  * vol - A number, between 1 and 100
--
-- Returns:
--  * None
function M.setVolume(vol, ...) end

-- Returned by `hs.itunes.getPlaybackState()` to indicates iTunes is paused
M.state_paused = nil

-- Returned by `hs.itunes.getPlaybackState()` to indicates iTunes is playing
M.state_playing = nil

-- Returned by `hs.itunes.getPlaybackState()` to indicates iTunes is stopped
M.state_stopped = nil

-- Decreases the iTunes playback volume by 5
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.volumeDown() end

-- Increases the iTunes playback volume by 5
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.volumeUp() end

