--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- A collection of useful dialog boxes, alerts and panels for user interaction.
---@class hs.dialog
local M = {}
hs.dialog = M

-- Displays a simple non-blocking dialog box using `NSAlert` and a hidden `hs.webview` that's automatically destroyed when the alert is closed.
--
-- Parameters:
--  * x - A number containing the horizontal co-ordinate of the top-left point of the dialog box. Defaults to 1.
--  * y - A number containing the vertical co-ordinate of the top-left point of the dialog box. Defaults to 1.
--  * callbackFn - The callback function that's called when a button is pressed.
--  * message - The message text to display.
--  * [informativeText] - Optional informative text to display.
--  * [buttonOne] - An optional value for the first button as a string. Defaults to "OK".
--  * [buttonTwo] - An optional value for the second button as a string. If `nil` is used, no second button will be displayed.
--  * [style] - An optional style of the dialog box as a string. Defaults to "warning".
--
-- Returns:
--  * nil
--
-- Notes:
--  * The optional values must be entered in order (i.e. you can't supply `style` without also supplying `buttonOne` and `buttonTwo`).
--  * [style] can be "warning", "informational" or "critical". If something other than these string values is given, it will use "informational".
--  * Example:
--      ```lua
--      testCallbackFn = function(result) print("Callback Result: " .. result) end
--      hs.dialog.alert(100, 100, testCallbackFn, "Message", "Informative Text", "Button One", "Button Two", "NSCriticalAlertStyle")
--      hs.dialog.alert(200, 200, testCallbackFn, "Message", "Informative Text", "Single Button")```
---@return string
function M.alert(x, y, callbackFn, message, informativeText, buttonOne, buttonTwo, style, ...) end

-- Displays a simple dialog box using `NSAlert` that will halt Lua code processing until the alert is closed.
--
-- Parameters:
--  * message - The message text to display.
--  * informativeText - The informative text to display.
--  * [buttonOne] - An optional value for the first button as a string. Defaults to "OK".
--  * [buttonTwo] - An optional value for the second button as a string. If `nil` is used, no second button will be displayed.
--  * [style] - An optional style of the dialog box as a string. Defaults to "informational".
--
-- Returns:
--  * The value of the button as a string.
--
-- Notes:
--  * The optional values must be entered in order (i.e. you can't supply `style` without also supplying `buttonOne` and `buttonTwo`).
--  * [style] can be "warning", "informational" or "critical". If something other than these string values is given, it will use "informational".
--  * Example:
--      `hs.dialog.blockAlert("Message", "Informative Text", "Button One", "Button Two", "NSCriticalAlertStyle")`
---@return string
function M.blockAlert(message, informativeText, buttonOne, buttonTwo, style, ...) end

-- Displays a file and/or folder selection dialog box using NSOpenPanel.
--
-- Parameters:
--  * [message] - The optional message text to display.
--  * [defaultPath] - The optional path you want to dialog to open to.
--  * [canChooseFiles] - Whether or not the user can select files. Defaults to `true`.
--  * [canChooseDirectories] - Whether or not the user can select folders. Default to `false`.
--  * [allowsMultipleSelection] - Allow multiple selections of files and/or folders. Defaults to `false`.
--  * [allowedFileTypes] - An optional table of allowed file types. Defaults to `true`.
--  * [resolvesAliases] - An optional boolean that indicates whether the panel resolves aliases.
--
-- Returns:
--  * The selected files in a table or `nil` if cancel was pressed.
--
-- Notes:
--  * The optional values must be entered in order (i.e. you can't supply `allowsMultipleSelection` without also supplying `canChooseFiles` and `canChooseDirectories`).
--  * Example:
--      `hs.inspect(hs.dialog.chooseFileOrFolder("Please select a file:", "~/Desktop", true, false, true, {"jpeg", "pdf"}, true))`
---@return string
function M.chooseFileOrFolder(message, defaultPath, canChooseFiles, canChooseDirectories, allowsMultipleSelection, allowedFileTypes, resolvesAliases, ...) end

-- Displays a simple text input dialog box.
--
-- Parameters:
--  * message - The message text to display
--  * informativeText - The informative text to display
--  * [defaultText] - The informative text to display
--  * [buttonOne] - An optional value for the first button as a string
--  * [buttonTwo] - An optional value for the second button as a string
--  * [secureField] - An optional boolean. If true, PasswordField instead of TextField. Defaults to false.
--
-- Returns:
--  * The value of the button as a string
--  * The value of the text input as a string
--
-- Notes:
--  * `buttonOne` defaults to "OK" if no value is supplied.
--  * `buttonOne` will also be triggered by pressing `ENTER`, whereas `buttonTwo` will be triggered by pressing `ESC`.
--  * Examples:
--      `hs.dialog.textPrompt("Main message.", "Please enter something:")`
--      `hs.dialog.textPrompt("Main message.", "Please enter something:", "Default Value", "OK")`
--      `hs.dialog.textPrompt("Main message.", "Please enter something:", "Default Value", "OK", "Cancel")`
--      `hs.dialog.textPrompt("Main message.", "Please enter something:", "", "OK", "Cancel", true)`
function M.textPrompt(message, informativeText, defaultText, buttonOne, buttonTwo, secureField, ...) end

-- Displays a simple dialog box using `NSAlert` in a `hs.webview`.
--
-- Parameters:
--  * webview - The `hs.webview` to display the alert on.
--  * callbackFn - The callback function that's called when a button is pressed.
--  * message - The message text to display.
--  * [informativeText] - Optional informative text to display.
--  * [buttonOne] - An optional value for the first button as a string. Defaults to "OK".
--  * [buttonTwo] - An optional value for the second button as a string. If `nil` is used, no second button will be displayed.
--  * [style] - An optional style of the dialog box as a string. Defaults to "warning".
--
-- Returns:
--  * nil
--
-- Notes:
--  * This alert is will prevent the user from interacting with the `hs.webview` until a button is pressed on the alert.
--  * The optional values must be entered in order (i.e. you can't supply `style` without also supplying `buttonOne` and `buttonTwo`).
--  * [style] can be "warning", "informational" or "critical". If something other than these string values is given, it will use "informational".
--  * Example:
--      ```lua
--      testCallbackFn = function(result) print("Callback Result: " .. result) end
--      testWebviewA = hs.webview.newBrowser(hs.geometry.rect(250, 250, 250, 250)):show()
--      testWebviewB = hs.webview.newBrowser(hs.geometry.rect(450, 450, 450, 450)):show()
--      hs.dialog.webviewAlert(testWebviewA, testCallbackFn, "Message", "Informative Text", "Button One", "Button Two", "warning")
--      hs.dialog.webviewAlert(testWebviewB, testCallbackFn, "Message", "Informative Text", "Single Button")```
---@return string
function M.webviewAlert(webview, callbackFn, message, informativeText, buttonOne, buttonTwo, style, ...) end

