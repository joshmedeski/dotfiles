--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Razer device support.
--
-- This extension currently only supports the Razer Tartarus V2.
-- It allows you to trigger callbacks when you press buttons and use the
-- scroll wheel, as well as allowing you to change the LED backlights
-- on the buttons and scroll wheel, and control the three status lights.
--
-- By default, the Razer Tartarus V2 triggers regular keyboard commands
-- (i.e. pressing the "01" key will type "1"). However, you can use the
-- `:defaultKeyboardLayout(false)` method to prevent this. This works by
-- remapping the default shortcut keys to "dummy" keys, so that they
-- don't trigger regular keypresses in macOS.
--
-- Like the [`hs.streamdeck`](http://www.hammerspoon.org/docs/hs.streamdeck.html) extension, this extension has been
-- designed to be modular, so it's possible for others to develop support
-- for other Razer devices later down the line, if there's interest.
--
-- This extension was thrown together by [Chris Hocking](https://github.com/latenitefilms) for [CommandPost](https://commandpost.io).
--
-- This extension is based off the [`hs.streamdeck`](http://www.hammerspoon.org/docs/hs.streamdeck.html) extension by [Chris Jones](https://github.com/cmsj).
--
-- Special thanks to the authors of these awesome documents & resources:
--
--  - [Information on USB Packets](https://www.beyondlogic.org/usbnutshell/usb6.shtml)
--  - [AppleUSBDefinitions.h](https://lab.qaq.wiki/Lakr233/IOKit-deploy/-/blob/master/IOKit/usb/AppleUSBDefinitions.h)
--  - [hidutil key remapping generator for macOS](https://hidutil-generator.netlify.app)
--  - [macOS function key remapping with hidutil](https://www.nanoant.com/mac/macos-function-key-remapping-with-hidutil)
--  - [HID Device Property Keys](https://developer.apple.com/documentation/iokit/iohidkeys_h_user-space/hid_device_property_keys)
---@class hs.razer
local M = {}
hs.razer = M

-- Changes the keyboard backlights to the breath mode.
--
-- Parameters:
--  * [color] - An optional `hs.drawing.color` value
--  * [secondaryColor] - An optional secondary `hs.drawing.color`
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--  * A plain text error message if not successful.
--
-- Notes:
--  * If neither `color` nor `secondaryColor` is provided, then random colors will be used.
function M:backlightsBreathing(color, secondaryColor, ...) end

-- Changes the keyboard backlights to custom colours.
--
-- Parameters:
--  * colors - A table of `hs.drawing.color` objects for each individual button on your device (i.e. if there's 20 buttons, you should have twenty colors in the table).
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--  * A plain text error message if not successful.
--
-- Notes:
--  * The order is top to bottom, left to right. You can use `nil` for any buttons you don't want to light up.
--  * Example usage: ```lua
--   hs.razer.new(0):backlightsCustom({hs.drawing.color.red, nil, hs.drawing.color.green, hs.drawing.color.blue})
--   ```
function M:backlightsCustom(colors, ...) end

-- Turns all the keyboard backlights off.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`.
--  * A plain text error message if not successful.
function M:backlightsOff() end

-- Changes the keyboard backlights to the reactive mode.
--
-- Parameters:
--  * speed - A number between 1 (fast) and 4 (slow)
--  * color - A `hs.drawing.color` object
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--  * A plain text error message if not successful.
function M:backlightsReactive(speed, color, ...) end

-- Changes the keyboard backlights to the spectrum mode.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--  * A plain text error message if not successful.
function M:backlightsSpectrum() end

-- Changes the keyboard backlights to the Starlight mode.
--
-- Parameters:
--  * speed - A number between 1 (fast) and 3 (slow)
--  * [color] - An optional `hs.drawing.color` value
--  * [secondaryColor] - An optional secondary `hs.drawing.color`
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--  * A plain text error message if not successful.
--
-- Notes:
--  * If neither `color` nor `secondaryColor` is provided, then random colors will be used.
function M:backlightsStarlight(speed, color, secondaryColor, ...) end

-- Changes the keyboard backlights to a single static color.
--
-- Parameters:
--  * color - A `hs.drawing.color` object.
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`.
--  * A plain text error message if not successful.
function M:backlightsStatic(color, ...) end

-- Changes the keyboard backlights to the wave mode.
--
-- Parameters:
--  * speed - A number between 1 (fast) and 255 (slow)
--  * direction - "left" or "right" as a string
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--  * A plain text error message if not successful.
function M:backlightsWave(speed, direction, ...) end

-- Gets or sets the blue status light.
--
-- Parameters:
--  * value - `true` for on, `false` for off`
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` for on, `false` for off`, or `nil` if something has gone wrong
--  * A plain text error message if not successful.
function M:blueStatusLight(value, ...) end

-- Gets or sets the brightness of a Razer keyboard.
--
-- Parameters:
--  * value - The brightness value - a number between 0 (off) and 100 (brightest).
--
-- Returns:
--  * The `hs.razer` object.
--  * The brightness as a number or `nil` if something goes wrong.
--  * A plain text error message if not successful.
function M:brightness(value, ...) end

-- Sets or removes a callback function for the `hs.razer` object.
--
-- Parameters:
--  * `callbackFn` - a function to set as the callback for this `hs.razer` object.  If the value provided is `nil`, any currently existing callback function is removed.
--
-- Returns:
--  * The `hs.razer` object
--
-- Notes:
--  * The callback function should expect 4 arguments and should not return anything:
--    * `razerObject` - The serial port object that triggered the callback.
--    * `buttonName` - The name of the button as a string.
--    * `buttonAction` - A string containing "pressed", "released", "up" or "down".
function M:callback(callbackFn, ...) end

-- Allows you to remap the default Keyboard Layout on a Razer device so that the buttons no longer trigger their factory default actions, or restore the default keyboard layout.
--
-- Parameters:
--  * enabled - If `true` the Razer default will use its default keyboard layout.
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` if successful otherwise `false`
--
-- Notes:
--  * This feature currently only works on the Razer Tartarus V2.
---@return boolean
function M:defaultKeyboardLayout(enabled, ...) end

-- Sets/clears a callback for reacting to device discovery events
--
-- Parameters:
--  * fn - A function that will be called when a Razer device is connected or disconnected. It should take the following arguments:
--   * A boolean, true if a device was connected, false if a device was disconnected
--   * An hs.razer object, being the device that was connected/disconnected
--
-- Returns:
--  * None
function M.discoveryCallback(fn) end

-- Gets an hs.razer object for the specified device
--
-- Parameters:
--  * num - A number that should be within the bounds of the number of connected devices
--
-- Returns:
--  * An hs.razer object or `nil` if something goes wrong
function M.getDevice(num, ...) end

-- Gets or sets the green status light.
--
-- Parameters:
--  * value - `true` for on, `false` for off`
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` for on, `false` for off`, or `nil` if something has gone wrong
--  * A plain text error message if not successful.
function M:greenStatusLight(value, ...) end

-- Initialises the Razer driver and sets a discovery callback.
--
-- Parameters:
--  * fn - A function that will be called when a Razer device is connected or disconnected. It should take the following arguments:
--   * A boolean, true if a device was connected, false if a device was disconnected
--   * An hs.razer object, being the device that was connected/disconnected
--
-- Returns:
--  * None
--
-- Notes:
--  * This function must be called before any other parts of this module are used
function M.init(fn) end

-- Returns the human readable device name of the Razer device.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The device name as a string.
---@return string
function M:name() end

-- Gets the number of Razer devices connected
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the number of Razer devices attached to the system
---@return number
function M.numDevices() end

-- Gets or sets the orange status light.
--
-- Parameters:
--  * value - `true` for on, `false` for off`
--
-- Returns:
--  * The `hs.razer` object.
--  * `true` for on, `false` for off`, or `nil` if something has gone wrong
--  * A plain text error message if not successful.
function M:orangeStatusLight(value, ...) end

-- Runs some basic unit tests when a Razer Tartarus V2 is connected.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * Because `hs.razer` relies on a physical device to
--    be connected for testing, this method exists so that
--    Hammerspoon developers can test the extension outside
--    of the usual GitHub tests. It can also be used for
--    user troubleshooting.
function M.unitTests() end

