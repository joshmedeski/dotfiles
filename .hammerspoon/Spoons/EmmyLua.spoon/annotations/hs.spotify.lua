--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Controls for Spotify music player
---@class hs.spotify
local M = {}
hs.spotify = M

-- Displays information for current track on screen
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.displayCurrentTrack() end

-- Skips the playback position forwards by 5 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.ff() end

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

-- Gets the name of the current track
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the current track, or nil if an error occurred
function M.getCurrentTrack() end

-- Gets the id of the current track
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the id of the current track, or nil if an error occurred
function M.getCurrentTrackId() end

-- Gets the duration (in seconds) of the current song
--
-- Parameters:
--  * None
--
-- Returns:
--  * The number of seconds long the current song is, 0 if no song is playing
function M.getDuration() end

-- Gets the current playback state of Spotify
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing one of the following constants:
--    - `hs.spotify.state_stopped`
--    - `hs.spotify.state_paused`
--    - `hs.spotify.state_playing`
function M.getPlaybackState() end

-- Gets the playback position (in seconds) in the current song
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number indicating the current position in the song
function M.getPosition() end

-- Gets the Spotify volume setting
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the volume Spotify is set to between 1 and 100
function M.getVolume() end

-- Returns whether Spotify is currently playing
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether Spotify is currently playing a track, or nil if an error occurred (unknown player state). Also returns false if the application is not running
function M.isPlaying() end

-- Returns whether Spotify is currently open. Most other functions in hs.spotify will automatically start the application, so this function can be used to guard against that.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether the Spotify application is running.
function M.isRunning() end

-- Skips to the next Spotify track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.next() end

-- Pauses the current Spotify track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.pause() end

-- Plays the current Spotify track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.play() end

-- Toggles play/pause of current Spotify track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.playpause() end

-- Plays the Spotify track with the given id
--
-- Parameters:
--  * id - The Spotify id of the track to be played
--
-- Returns:
--  * None
function M.playTrack(id) end

-- Skips to previous Spotify track
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.previous() end

-- Skips the playback position backwards by 5 seconds
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.rw() end

-- Sets the playback position in the current song
--
-- Parameters:
--  * pos - A number containing the position (in seconds) to jump to in the current song
--
-- Returns:
--  * None
function M.setPosition(pos, ...) end

-- Sets the Spotify volume setting
--
-- Parameters:
--  * vol - A number between 1 and 100
--
-- Returns:
--  * None
function M.setVolume(vol, ...) end

-- Returned by `hs.spotify.getPlaybackState()` to indicates Spotify is paused
M.state_paused = nil

-- Returned by `hs.spotify.getPlaybackState()` to indicates Spotify is playing
M.state_playing = nil

-- Returned by `hs.spotify.getPlaybackState()` to indicates Spotify is stopped
M.state_stopped = nil

-- Reduces the volume by 5
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.volumeDown() end

-- Increases the volume by 5
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.volumeUp() end

