--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Configure/control an Elgato Stream Deck.
--
-- Please note that in order for this module to work, the official Elgato Stream Deck app should not be running.
--
-- This extension supports the following devices:
--  * Stream Deck (Original)
--  * Stream Deck (Original V2)
--  * Stream Deck Plus
--  * Stream Deck Mini
--  * Stream Deck Mini (V2)
--  * Stream Deck XL
--  * Stream Deck XL (Mk2)
--  * Stream Deck Pedal
--
-- This module would not have been possible without standing on the shoulders of others:
--  * https://github.com/OpenStreamDeck/StreamDeckSharp
--  * https://github.com/Lange/node-elgato-stream-deck
--  * Hopper
---@class hs.streamdeck
local M = {}
hs.streamdeck = M

-- Sets/clears the button callback function for a Stream Deck device
--
-- Parameters:
--  * fn - A function to be called when a button is pressed/released on the stream deck. It should receive three arguments:
--   * The hs.streamdeck userdata object
--   * A number containing the button that was pressed/released
--   * A boolean indicating whether the button was pressed (true) or released (false)
--
-- Returns:
--  * The hs.streamdeck device
function M:buttonCallback(fn) end

-- Gets the layout of buttons a Stream Deck device has
--
-- Parameters:
--  * None
--
-- Returns:
--  * The number of columns
--  * The number of rows
function M:buttonLayout() end

-- Sets/clears a callback for reacting to device discovery events
--
-- Parameters:
--  * fn - A function that will be called when a Stream Deck is connected or disconnected. It should take the following arguments:
--   * A boolean, true if a device was connected, false if a device was disconnected
--   * An hs.streamdeck object, being the device that was connected/disconnected
--
-- Returns:
--  * None
function M.discoveryCallback(fn) end

-- Sets/clears the knob/encoder callback function for a Stream Deck Plus.
--
-- Parameters:
--  * fn - A function to be called when an encoder button is pressed/released/rotated on a Stream Deck Plus. It should receive five arguments:
--   * The hs.streamdeck userdata object
--   * A number containing the button that was pressed/released/rotated
--   * A boolean indicating whether the button was pressed (true) or released (false)
--   * A boolean indicating that the button was turned left
--   * A boolean indicating that the button was turned right
--
-- Returns:
--  * The hs.streamdeck device
function M:encoderCallback(fn) end

-- Gets the firmware version of a Stream Deck device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the firmware version of the deck
function M:firmwareVersion() end

-- Gets an hs.streamdeck object for the specified device
--
-- Parameters:
--  * num - A number that should be within the bounds of the number of connected devices
--
-- Returns:
--  * An hs.streamdeck object
function M.getDevice(num, ...) end

-- Gets the width and height of the buttons in pixels
--
-- Parameters:
--  * None
--
-- Returns:
--  * An table with keys `w` and `h` containing the width and height, respectively, of images expected by the Stream Deck
function M:imageSize() end

-- Initialises the Stream Deck driver and sets a discovery callback
--
-- Parameters:
--  * fn - A function that will be called when a Stream Deck is connected or disconnected. It should take the following arguments:
--   * A boolean, true if a device was connected, false if a device was disconnected
--   * An hs.streamdeck object, being the device that was connected/disconnected
--
-- Returns:
--  * None
--
-- Notes:
--  * This function must be called before any other parts of this module are used
function M.init(fn) end

-- Gets the number of Stream Deck devices connected
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the number of Stream Deck devices attached to the system
function M.numDevices() end

-- Resets a Stream Deck device
--
-- Parameters:
--  * None
--
-- Returns:
--  * The hs.streamdeck object
function M:reset() end

-- Sets/clears the screen callback function for a Stream Deck Plus's touch screen (above the encoder knobs).
--
-- Parameters:
--  * fn - A function to be called when a screen is pressed/released/swiped on a Stream Deck Plus. It should receive six arguments:
--   * The hs.streamdeck userdata object
--   * A string either containing "shortPress", "longPress" or "swipe"
--   * The X position of where the screen was first touched
--   * The Y position of where the screen was first touched
--   * The X position of where the screen was last touched (if swiping)
--   * The Y position of where the screen was last touched (if swiping)
--
-- Returns:
--  * The hs.streamdeck device
function M:screenCallback(fn) end

-- Gets the serial number of a Stream Deck device
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the serial number of the deck
function M:serialNumber() end

-- Sets the brightness of a Stream Deck device
--
-- Parameters:
--  * brightness - A whole number between 0 and 100 indicating the percentage brightness level to set
--
-- Returns:
--  * The hs.streamdeck device
function M:setBrightness(brightness, ...) end

-- Sets a button on the Stream Deck device to the specified color
--
-- Parameters:
--  * button - A number (from 1 to 15) describing which button to set the color on
--  * color - An hs.drawing.color object
--
-- Returns:
--  * The hs.streamdeck object
function M:setButtonColor(button, color, ...) end

-- Sets the image of a button on the Stream Deck device
--
-- Parameters:
--  * button - A number (from 1 to 15) describing which button to set the image for
--  * image - An hs.image object
--
-- Returns:
--  * The hs.streamdeck object
function M:setButtonImage(button, image, ...) end

-- Sets the image of the screen on the Stream Deck device
--
-- Parameters:
--  * encoder - A number (from 1 to 4) describing which encoder to set the image for
--  * image - An hs.image object
--
-- Returns:
--  * The hs.streamdeck object
function M:setScreenImage(encoder, image, ...) end

