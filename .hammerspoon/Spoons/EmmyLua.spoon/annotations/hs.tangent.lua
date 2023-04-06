--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Tangent Control Surface Extension
--
-- **API Version:** TUBE Version 3.2 - TIPC Rev 4 (22nd February 2017)
--
-- This plugin allows Hammerspoon to communicate with Tangent's range of panels, such as their Element, Virtual Element Apps, Wave, Ripple and any future panels.
--
-- The Tangent Unified Bridge Engine (TUBE) is made up of two software elements, the Mapper and the Hub. The Hub communicates with your application via the
-- TUBE Inter Process Communications (TIPC). TIPC is a standardised protocol to allow any application that supports it to communicate with any current and
-- future panels produced by Tangent via the TUBE Hub.
--
-- You can download the Tangent Developer Support Pack & Tangent Hub Installer for Mac [here](http://www.tangentwave.co.uk/developer-support/).
--
-- This extension was thrown together by [Chris Hocking](https://github.com/latenitefilms), then dramatically improved by [David Peterson](https://github.com/randomeizer) for [CommandPost](http://commandpost.io).
---@class hs.tangent
local M = {}
hs.tangent = M

-- Definitions for reserved action IDs.
--
-- Notes:
--  * `alt`                     - toggles the 'ALT' function.
--  * `nextKnobBank`            - switches to the next knob bank.
--  * `prevKnobBank`            - switches to the previous knob bank.
--  * `nextButtonBank`          - switches to the next button bank.
--  * `prevBasketBank`          - switches to the previous button bank.
--  * `nextTrackerballBank`     - switches to the next trackerball bank.
--  * `prevTrackerballBank`     - switches to the previous trackerball bank.
--  * `nextMode`                - switches to the next mode.
--  * `prevMode`                - switches to the previous mode.
--  * `goToMode`                - switches to the specified mode, requiring a Argument with the mode ID.
--  * `toggleJogShuttle`        - toggles jog/shuttle mode.
--  * `toggleMouseEmulation`    - toggles mouse emulation.
--  * `fakeKeypress`            - generates a keypress, requiring an Argument with the key code.
--  * `showHUD`                 - shows the HUD on screen.
--  * `goToKnobBank`            - goes to the specific knob bank, requiring an Argument with the bank number.
--  * `goToButtonBank`          - goes to the specific button bank, requiring an Argument with the bank number.
--  * `goToTrackerballBank`     - goes to the specific trackerball bank, requiring an Argument with the bank number.
M.reserved.action = nil

-- Automatically send the "Application Definition" response. Defaults to `true`.
---@type boolean
M.automaticallySendApplicationDefinition = nil

-- Sets a callback when new messages are received.
--
-- Parameters:
--  * callbackFn - a function to set as the callback for `hs.tangent`. If the value provided is `nil`, any currently existing callback function is removed.
--
-- Returns:
--  * `true` if successful otherwise `false`
--
-- Notes:
--  * Full documentation for the Tangent API can be downloaded [here](http://www.tangentwave.co.uk/download/developer-support-pack/).
--  * The callback function should expect 1 argument and should not return anything.
--  * The 1 argument will be a table, which can contain one or many commands. Each command is it's own table with the following contents:
--    * id - the message ID of the incoming message
--    * metadata - A table of data for the Tangent command (see below).
--  * The metadata table will return the following, depending on the `id` for the callback:
--    * `connected` - Connection to Tangent Hub successfully established.
--    * `disconnected` - The connection to Tangent Hub was dropped.
--    * `initiateComms` - Initiates communication between the Hub and the application.
--      * `protocolRev` - The revision number of the protocol.
--      * `numPanels` - The number of panels connected.
--      * `panels`
--        * `panelID` - The ID of the panel.
--        * `panelType` - The type of panel connected.
--      * `data` - The raw data from the Tangent Hub
--    * `parameterChange` - Requests that the application increment a parameter.
--      * `paramID` - The ID value of the parameter.
--      * `increment` - The incremental value which should be applied to the parameter.
--    * `parameterReset` - Requests that the application changes a parameter to its reset value.
--      * `paramID` - The ID value of the parameter.
--    * `parameterValueRequest` - Requests that the application sends a `ParameterValue (0x82)` command to the Hub.
--      * `paramID` - The ID value of the parameter.
--    * `menuChange` - Requests the application change a menu index by +1 or -1.
--      * `menuID` - The ID value of the menu.
--      * `increment` - The incremental amount by which the menu index should be changed which will always be an integer value of +1 or -1.
--    * `menuReset` - Requests that the application changes a menu to its reset value.
--      * `menuID` - The ID value of the menu.
--    * `menuStringRequest` - Requests that the application sends a `MenuString (0x83)` command to the Hub.
--      * `menuID` - The ID value of the menu.
--    * `actionOn` - Requests that the application performs the specified action.
--      * `actionID` - The ID value of the action.
--    * `modeChange` - Requests that the application changes to the specified mode.
--      * `modeID` - The ID value of the mode.
--    * `transport` - Requests the application to move the currently active transport.
--      * `jogValue` - The number of jog steps to move the transport.
--      * `shuttleValue` - An incremental value to add to the shuttle speed.
--    * `actionOff` - Requests that the application cancels the specified action.
--      * `actionID` - The ID value of the action.
--    * `unmanagedPanelCapabilities` - Only used when working in Unmanaged panel mode. Sent in response to a `UnmanagedPanelCapabilitiesRequest (0xA0)` command.
--      * `panelID` - The ID of the panel as reported in the `InitiateComms` command.
--      * `numButtons` - The number of buttons on the panel.
--      * `numEncoders` - The number of encoders on the panel.
--      * `numDisplays` - The number of displays on the panel.
--      * `numDisplayLines` - The number of lines for each display on the panel.
--      * `numDisplayChars` - The number of characters on each line of each display on the panel.
--    * `unmanagedButtonDown` - Only used when working in Unmanaged panel mode. Issued when a button has been pressed.
--      * `panelID` - The ID of the panel as reported in the `InitiateComms` command.
--      * `buttonID` - The hardware ID of the button
--    * `unmanagedButtonUp` - Only used when working in Unmanaged panel mode. Issued when a button has been released.
--      * `panelID` - The ID of the panel as reported in the `InitiateComms` command.
--      * `buttonID` - The hardware ID of the button.
--    * `unmanagedEncoderChange` - Only used when working in Unmanaged panel mode. Issued when an encoder has been moved.
--      * `panelID` - The ID of the panel as reported in the `InitiateComms` command.
--      * `paramID` - The hardware ID of the encoder.
--      * `increment` - The incremental value.
--    * `unmanagedDisplayRefresh` - Only used when working in Unmanaged panel mode. Issued when a panel has been connected or the focus of the panel has been returned to your application.
--      * `panelID` - The ID of the panel as reported in the `InitiateComms` command.
--    * `panelConnectionState`
--      * `panelID` - The ID of the panel as reported in the `InitiateComms` command.
--      * `state` - The connected state of the panel, `true` if connected, `false` if disconnected.
---@return boolean
function M.callback() end

-- Connects to the Tangent Hub.
--
-- Parameters:
--  * applicationName - Your application name as a string
--  * systemPath - A string containing the absolute path of the directory that contains the Controls and Default Map XML files.
--  * [userPath] - An optional string containing the absolute path of the directory that contains the User’s Default Map XML files.
--
-- Returns:
--  * success - `true` on success, otherwise `nil`
--  * errorMessage - The error messages as a string or `nil` if `success` is `true`.
function M.connect(applicationName, systemPath, userPath, ...) end

-- Checks to see whether or not you're successfully connected to the Tangent Hub.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if connected, otherwise `false`
---@return boolean
function M.connected() end

-- Disconnects from the Tangent Hub.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.disconnect() end

-- Definitions for IPC Commands from the HUB to Hammerspoon.
--
-- Notes:
--  * `connected`                       - a connection is established with the Hub.
--  * `disconnected`                    - the connection is dropped with the Hub.
--  * `initiateComms`                   - sent when the Hub wants to initiate communications.
--  * `parameterChange`                 - a parameter was incremented.
--  * `parameterReset`                  - a parameter was reset.
--  * `parameterValueRequest`           - the Hub wants the current value of the parameter.
--  * `menuChange`                      - The menu was changed, `+1` or `-1`.
--  * `menuReset`                       - The menu was reset.
--  * `menuStringRequest`               - The application should send a `menuString` with the current value.
--  * `actionOn`                        - An action button was pressed.
--  * `actionOff`                       - An action button was released.
--  * `modeChange`                      - The current mode was changed.
--  * `transport`                       - The transport.
--  * `unmanagedPanelCapabilities`      - Send by the Hub to advertise an unmanaged panel.
--  * `unmanagedButtonDown`             - A button on an unmanaged panel was pressed.
--  * `unmanagedButtonUp`               - A button on an unmanaged panel was released.
--  * `unmanagedEncoderChange`          - An encoder (dial/wheel) on an unmanaged panel changed.
--  * `unmanagedDisplayRefresh`         - Triggered when an unmanaged panel's display needs to update.
--  * `panelConnectionState`            - A panel's connection state changed.
M.fromHub = nil

-- IP Address that the Tangent Hub is located at. Defaults to 127.0.0.1.
---@type number
M.ipAddress = nil

-- Checks to see whether or not the Tangent Hub software is installed.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if Tangent Hub is installed otherwise `false`.
---@return boolean
function M.isTangentHubInstalled() end

-- Tangent Panel Types.
M.panelType = nil

-- A table of reserved parameter IDs.
--
-- Notes:
--  * `transportRing`           - transport ring.
--  * `fakeKeypress`            - sends a fake keypress.
M.reserved.parameter = nil

-- The port that Tangent Hub monitors. Defaults to 64246.
---@type number
M.port = nil

-- Sends a "bytestring" message to the Tangent Hub.
--
-- Parameters:
--  * byteString   - The string of bytes to send to tangent.
--
-- Returns:
--  * success - `true` if connected, otherwise `false`
--  * errorMessage - An error message if an error occurs, as a string
--
-- Notes:
--  * This should be a full encoded string for the command you want to send, withouth the leading 'size' section, which the function will calculate automatically.
--  * In general, you should use the more specific functions that package the command for you, such as `sendParameterValue(...)`. This function can be used to send a message that this API doesn't yet support.
--  * Full documentation for the Tangent API can be downloaded [here](http://www.tangentwave.co.uk/download/developer-support-pack/).
function M.send(byteString, ...) end

-- Tells the Hub that a large number of software-controls have changed.
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * The Hub responds by requesting all the current values of software-controls it is currently controlling.
function M.sendAllChange() end

-- Sends the application details to the Tangent Hub.
--
-- Parameters:
--  * appName       - The human-readable name of the application.
--  * systemPath    - A string containing the absolute path of the directory that contains the Controls and Default Map XML files (Path String)
--  * userPath      - A string containing the absolute path of the directory that contains the User’s Default Map XML files (Path String)
--
-- Returns:
--  * `true` if successful, `false` and an error message if there was a problem.
--
-- Notes:
--  * If no details are provided the ones stored in the module are used.
function M.sendApplicationDefinition(appName, systemPath, userPath, ...) end

-- Updates the Hub with a number of character strings that will be displayed on connected panels if there is space.
--
-- Parameters:
--  * messages      - A list of messages to send.
--  * doubleHeight  - An optional list of `boolean`s indicating if the corresponding message is double-height.
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * Strings may either be 32 character, single height or 16 character double-height. They will be displayed in the order received; the first string displayed at the top of the display.
--  * If a string is not defined as double-height then it will occupy the next line.
--  * If a string is defined as double-height then it will occupy the next 2 lines.
--  * The maximum number of lines which will be used by the application must be indicated in the Controls XML file.
--  * Text which exceeds 32 (single-height) or 16 (double-height) characters will be truncated.
--  * If all text is single-height, the `doubleHeight` table can be omitted.
--
-- Examples:
--
-- ```lua
-- hs.tangent.sendDisplayText(
--     { "Single Height", "Double Height" }, {false, true}
-- )```
function M.sendDisplayText(messages, doubleHeight, ...) end

-- Highlights the control on any panel where this feature is available.
--
-- Parameters:
--  * targetID      - The id of any application defined Parameter, Menu, Action or Mode (Unsigned Int)
--  * active        - If `true`, the control is highlighted, otherwise it is not.
--
-- Returns:
--  * `true` if sent successfully, `false` and an error message if no.
--
-- Notes:
--  * When applied to Modes, buttons which are mapped to the reserved "Go To Mode" action for this particular mode will highlight.
function M.sendHighlightControl(targetID, active, ...) end

-- Sets the Indicator of the control on any panel where this feature is available.
--
-- Parameters:
--  * targetID      - The id of any application defined Parameter, Menu, Action or Mode
--  * active        - If `true`, the control is indicated, otherwise it is not.
--
-- Returns:
--  * `true` if sent successfully, `false` and an error message if no.
--
-- Notes:
--  * This indicator is driven by the `atDefault` argument for Parameters and Menus. This command therefore only applies to controls mapped to Actions and Modes.
--  * When applied to Modes, buttons which are mapped to the reserved "Go To Mode" action for this particular mode will have their indicator set.
function M.sendIndicateControl(targetID, indicated, ...) end

-- Updates the Hub with a menu value.
--
-- Parameters:
--  * menuID - The ID value of the menu (Unsigned Int)
--  * value - The current ‘value’ of the parameter represented as a string
--  * atDefault - if `true` the value represents the default. Otherwise `false`.
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * The Hub then updates the displays of any panels which are currently showing the menu.
--  * If a value of `nil` is sent then the Hub will not attempt to display a value for the menu. However the `atDefault` flag will still be recognised.
function M.sendMenuString(menuID, value, atDefault, ...) end

-- Updates the Hub with a mode value.
--
-- Parameters:
--  * modeID - The ID value of the mode (Unsigned Int)
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * The Hub then changes mode and requests all the current values of software-controls it is controlling.
function M.sendModeValue(modeID, ...) end

-- Requests the Hub to respond with a sequence of PanelConnectionState (0x35) commands to report the connected/disconnected status of each configured panel
--
-- Parameters:
--  * None
--
-- Returns:
--  * `true` if sent successfully, `false` and an error message if not.
--
-- Notes:
--  * A single request may result in multiple state responses.
function M.sendPanelConnectionStatesRequest() end

-- Updates the Hub with a parameter value.
--
-- Parameters:
--  * paramID - The ID value of the parameter (Unsigned Int)
--  * value - The current value of the parameter (Float)
--  * atDefault - if `true` the value represents the default. Defaults to `false`.
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * The Hub then updates the displays of any panels which are currently showing the parameter value.
function M.sendParameterValue(paramID, value, atDefault, ...) end

-- Renames a control dynamically.
--
-- Parameters:
--  * targetID  - The id of any application defined Parameter, Menu, Action or Mode (Unsigned Int)
--  * newName   - The new name to apply.
--
-- Returns:
--  * `true` if successful, `false` and an error message if not.
--
-- Notes:
--  * The string supplied will replace the normal text which has been derived from the Controls XML file.
--  * To remove any existing replacement name set `newName` to `""`, this will remove any renaming and return the system to the normal display text
--  * When applied to Modes, the string displayed on buttons which mapped to the reserved "Go To Mode" action for this particular mode will also change.
function M.sendRenameControl(targetID, newName, ...) end

-- Updates the Hub with text that will be displayed on a specific panel at the given line and starting position where supported by the panel capabilities.
--
-- Parameters:
--  * panelID       - The ID of the panel as reported in the InitiateComms command (Unsigned Int)
--  * displayID     - The ID of the display to be written to (Unsigned Int)
--  * lineNum       - The line number of the display to be written to with `1` as the top line (Unsigned Int)
--  * pos           - The position on the line to start writing from with `1` as the first column (Unsigned Int)
--  * message       - A line of text (Character String)
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * Only used when working in Unmanaged panel mode.
--  * If the most significant bit of any individual text character in `message` is set it will be displayed as inversed with dark text on a light background.
function M.sendUnmanagedDisplayWrite(panelID, displayID, lineNum, pos, message, ...) end

-- Requests the Hub to respond with an UnmanagedPanelCapabilities (0x30) command.
--
-- Parameters:
--  * panelID - The ID of the panel as reported in the InitiateComms command (Unsigned Int)
--
-- Returns:
--  * `true` if successful, or `false` and an error message if not.
--
-- Notes:
--  * Only used when working in Unmanaged panel mode
function M.sendUnmanagedPanelCapabilitiesRequest(panelID, ...) end

-- Sets the Log Level.
--
-- Parameters:
--  * loglevel - can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose'; or a corresponding number between 0 and 5
--
-- Returns:
--  * None
function M.setLogLevel(loglevel, ...) end

-- Definitions for IPC Commands from Hammerspoon to the HUB.
M.toHub = nil

