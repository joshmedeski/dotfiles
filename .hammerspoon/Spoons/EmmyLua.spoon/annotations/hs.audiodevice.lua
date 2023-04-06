--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Manipulate the system's audio devices
--
-- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.audiodevice
local M = {}
hs.audiodevice = M

-- Returns a list of all connected devices
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table of zero or more audio devices connected to the system
function M.allDevices() end

-- Gets all of the input data sources of an audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list of hs.audiodevice.dataSource objects, or nil if an error occurred
function M:allInputDataSources() end

-- Returns a list of all connected input devices.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table of zero or more audio input devices connected to the system
function M.allInputDevices() end

-- Gets all of the output data sources of an audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A list of hs.audiodevice.dataSource objects, or nil if an error occurred
function M:allOutputDataSources() end

-- Returns a list of all connected output devices
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table of zero or more audio output devices connected to the system
function M.allOutputDevices() end

-- Get the current left/right balance of this audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number between 0.0 and 1.0, representing the balance (0.0 for full left, 1.0 for full right, 0.5 for center), or nil if the audio device does not support balance
--
-- Notes:
--  * The return value will be a floating point number
--  * This method will inspect the device to determine if it is an input or output device, and return the appropriate volume. For devices that are both input and output devices, see `:inputVolume()` and `:outputVolume()`
function M:balance() end

-- Fetch various metadata about the current default audio devices
--
-- Parameters:
--  * output - An optional boolean, true to fetch information about the default input device, false for output device. Defaults to false
--
-- Returns:
--  * A table with the following contents:
-- ```lua
--     {
--         name = defaultOutputDevice():name(),
--         uid = module.defaultOutputDevice():uid(),
--         muted = defaultOutputDevice():muted(),
--         volume = defaultOutputDevice():volume(),
--         device = defaultOutputDevice(),
--     }
-- ```
function M.current(input, ...) end

-- Gets the current input data source of an audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.audiodevice.dataSource object, or nil if an error occurred
--
-- Notes:
--  * Before calling this method, you should check the result of hs.audiodevice:supportsInputDataSources()
---@return hs.audiodevice.datasource
function M:currentInputDataSource() end

-- Gets the current output data source of an audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.audiodevice.dataSource object, or nil if an error occurred
--
-- Notes:
--  * Before calling this method, you should check the result of hs.audiodevice:supportsOutputDataSources()
---@return hs.audiodevice.datasource
function M:currentOutputDataSource() end

-- Get the currently selected sound effect device
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.audiodevice object, or nil if no suitable device could be found
function M.defaultEffectDevice() end

-- Get the currently selected audio input device
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.audiodevice object, or nil if no suitable device could be found
function M.defaultInputDevice() end

-- Get the currently selected audio output device
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.audiodevice object, or nil if no suitable device could be found
function M.defaultOutputDevice() end

-- Find an audio device by name
--
-- Parameters:
--  * name - A string containing the name of an audio device to search for
--
-- Returns:
--  * An `hs.audiodevice` object or nil if the device could not be found
function M.findDeviceByName(name, ...) end

-- Find an audio device by UID
--
-- Parameters:
--  * uid - A string containing the UID of an audio device to search for
--
-- Returns:
--  * An `hs.audiodevice` object or nil if the device could not be found
function M.findDeviceByUID(uid, ...) end

-- Find an audio input device by name
--
-- Parameters:
--  * name - A string containing the name of an audio input device to search for
--
-- Returns:
--  * An hs.audiodevice object or nil if the device could not be found
function M.findInputByName(name, ...) end

-- Find an audio input device by UID
--
-- Parameters:
--  * name - A string containing the UID of an audio input device to search for
--
-- Returns:
--  * An hs.audiodevice object or nil if the device could not be found
function M.findInputByUID(uid, ...) end

-- Find an audio output device by name
--
-- Parameters:
--  * name - A string containing the name of an audio output device to search for
--
-- Returns:
--  * An hs.audiodevice object or nil if the device could not be found
function M.findOutputByName(name, ...) end

-- Find an audio output device by UID
--
-- Parameters:
--  * name - A string containing the UID of an audio output device to search for
--
-- Returns:
--  * An hs.audiodevice object or nil if the device could not be found
function M.findOutputByUID(uid, ...) end

-- Get the Input mutedness state of the audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device's Input is muted. False if it's not muted, nil if it does not support muting
function M:inputMuted() end

-- Get the current input volume of this audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number between 0 and 100, representing the input volume percentage, or nil if the audio device does not support input volume levels
--
-- Notes:
--  * The return value will be a floating point number
function M:inputVolume() end

-- Check if the audio device is in use
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device is in use, False if not. nil if an error occurred.
function M:inUse() end

-- Determines if an audio device is an input device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the device is an input device, false if not
---@return boolean
function M:isInputDevice() end

-- Determines if an audio device is an output device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the device is an output device, false if not
---@return boolean
function M:isOutputDevice() end

-- Determines whether an audio jack (e.g. headphones) is connected to an audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if a jack is connected, false if not, or nil if the device does not support jack sense
function M:jackConnected() end

-- Get the mutedness state of the audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device is muted, False if it is not muted, nil if it does not support muting
--
-- Notes:
--  * If a device is capable of both input and output, this method will prefer the output. See `:inputMuted()` and `:outputMuted()` for specific variants.
function M:muted() end

-- Get the name of the audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the audio device, or nil if it has no name
function M:name() end

-- Get the Output mutedness state of the audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device's Output is muted. False if it's not muted, nil if it does not support muting
function M:outputMuted() end

-- Get the current output volume of this audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number between 0 and 100, representing the output volume percentage, or nil if the audio device does not support output volume levels
--
-- Notes:
--  * The return value will be a floating point number
function M:outputVolume() end

-- Set the balance of this audio device
--
-- Parameters:
--  * level - A number between 0.0 and 1.0, representing the balance (0.0 for full left, 1.0 for full right, 0.5 for center)
--
-- Returns:
--  * True if the balance was set, false if the audio device does not support setting a balance.
--
-- Notes:
--  * This method will inspect the device to determine if it is an input or output device, and set the appropriate volume. For devices that are both input and output devices, see `:setInputVolume()` and `:setOutputVolume()`
---@return boolean
function M:setBalance(level, ...) end

-- Selects this device as the audio output device for system sound effects
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device was successfully selected, otherwise false.
---@return boolean
function M:setDefaultEffectDevice() end

-- Selects this device as the system's audio input device
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device was successfully selected, otherwise false.
---@return boolean
function M:setDefaultInputDevice() end

-- Selects this device as the system's audio output device
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the audio device was successfully selected, otherwise false.
---@return boolean
function M:setDefaultOutputDevice() end

-- Set the mutedness state of the Input of the audio device
--
-- Parameters:
--  * state - A boolean value. True to mute the device, False to unmute it
--
-- Returns:
--  * True if the device's Input mutedness state was set, or False if it does not support muting
---@return boolean
function M:setInputMuted(state, ...) end

-- Set the input volume of this audio device
--
-- Parameters:
--  * level - A number between 0 and 100, representing the input volume as a percentage
--
-- Returns:
--  * True if the volume was set, false if the audio device does not support setting an input volume level
--
-- Notes:
--  * The volume level is a floating point number. Depending on your audio hardware, it may not be possible to increase volume in single digit increments
---@return boolean
function M:setInputVolume(level, ...) end

-- Set the mutedness state of the audio device
--
-- Parameters:
--  * state - A boolean value. True to mute the device, False to unmute it
--
-- Returns:
--  * True if the device's mutedness state was set, or False if it does not support muting
--
-- Notes:
--  * If a device is capable of both input and output, this method will prefer the output. See `:setInputMuted()` and `:setOutputMuted()` for specific variants.
---@return boolean
function M:setMuted(state, ...) end

-- Set the mutedness state of the Output of the audio device
--
-- Parameters:
--  * state - A boolean value. True to mute the device, False to unmute it
--
-- Returns:
--  * True if the device's Output mutedness state was set, or False if it does not support muting
---@return boolean
function M:setOutputMuted(state, ...) end

-- Set the output volume of this audio device
--
-- Parameters:
--  * level - A number between 0 and 100, representing the output volume as a percentage
--
-- Returns:
--  * True if the volume was set, false if the audio device does not support setting an output volume level
--
-- Notes:
--  * The volume level is a floating point number. Depending on your audio hardware, it may not be possible to increase volume in single digit increments
---@return boolean
function M:setOutputVolume(level, ...) end

-- Set the volume of this audio device
--
-- Parameters:
--  * level - A number between 0 and 100, representing the volume as a percentage
--
-- Returns:
--  * True if the volume was set, false if the audio device does not support setting a volume level.
--
-- Notes:
--  * The volume level is a floating point number. Depending on your audio hardware, it may not be possible to increase volume in single digit increments.
--  * This method will inspect the device to determine if it is an input or output device, and set the appropriate volume. For devices that are both input and output devices, see `:setInputVolume()` and `:setOutputVolume()`
---@return boolean
function M:setVolume(level, ...) end

-- Determines whether an audio device supports input data sources
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the device supports input data sources, false if not
---@return boolean
function M:supportsInputDataSources() end

-- Determines whether an audio device supports output data sources
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the device supports output data sources, false if not
---@return boolean
function M:supportsOutputDataSources() end

-- Gets the hardware transport type of an audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the transport type, or nil if an error occurred
---@return string
function M:transportType() end

-- Get the unique identifier of the audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the UID of the audio device, or nil if it has no UID.
function M:uid() end

-- Get the current volume of this audio device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number between 0 and 100, representing the volume percentage, or nil if the audio device does not support volume levels
--
-- Notes:
--  * The return value will be a floating point number
--  * This method will inspect the device to determine if it is an input or output device, and return the appropriate volume. For devices that are both input and output devices, see `:inputVolume()` and `:outputVolume()`
function M:volume() end

-- Sets or removes a callback function for an audio device watcher
--
-- Parameters:
--  * fn - A callback function that will be called when properties of this audio device change, or nil to remove an existing callback. The function should accept four arguments:
--   * A string containing the UID of the audio device (see `hs.audiodevice.findDeviceByUID()`)
--   * A string containing the name of the event. Possible values are:
--    * vmvc - Volume changed
--    * mute - Mute state changed
--    * jack - Jack sense state changed (usually this means headphones were plugged/unplugged)
--    * span - Stereo pan changed
--    * diff - Device configuration changed (if you are caching audio device properties, this event indicates you should flush your cache)
--    * gone - The device's "in use" status changed (ie another app started using the device, or stopped using it)
--   * A string containing the scope of the event. Possible values are:
--    * glob - This is a global event pertaining to the whole device
--    * inpt - This is an event pertaining only to the input functions of the device
--    * outp - This is an event pertaining only to the output functions of the device
--   * A number containing the element of the event. Typical values are:
--    * 0 - Typically this means the Master channel
--    * 1 - Typically this means the Left channel
--    * 2 - Typically this means the Right channel
--
-- Returns:
--  * The `hs.audiodevice` object
--
-- Notes:
--  * You will receive many events to your callback, so filtering on the name/scope/element arguments is vital. For example, on a stereo device, it is not uncommon to receive a `volm` event for each audio channel when the volume changes, or multiple `mute` events for channels. Dragging a volume slider in the system Sound preferences will produce a large number of `volm` events. Plugging/unplugging headphones may trigger `volm` events in addition to `jack` ones, etc.
--  * If you need to use the `hs.audiodevice` object in your callback, use `hs.audiodevice.findDeviceByUID()` to obtain it fro the first callback argument
---@return hs.audiodevice
function M:watcherCallback(fn) end

-- Gets the status of the `hs.audiodevice` object watcher
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the watcher is running, false if not
---@return boolean
function M:watcherIsRunning() end

-- Starts the watcher on an `hs.audiodevice` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.audiodevice` object, or nil if an error occurred
function M:watcherStart() end

-- Stops the watcher on an `hs.audiodevice` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.audiodevice` object
---@return hs.audiodevice
function M:watcherStop() end

