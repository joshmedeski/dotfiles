--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

--- global variable containing loaded spoons
spoon = {}

-- Core Hammerspoon functionality
---@class hs
local M = {}
hs = M

-- Checks the Accessibility Permissions for Hammerspoon, and optionally allows you to prompt for permissions.
--
-- Parameters:
--  * shouldPrompt - an optional boolean value indicating if the dialog box asking if the System Preferences application should be opened should be presented when Accessibility is not currently enabled for Hammerspoon.  Defaults to false.
--
-- Returns:
--  * True or False indicating whether or not Accessibility is enabled for Hammerspoon.
--
-- Notes:
--  * Since this check is done automatically when Hammerspoon loads, it is probably of limited use except for skipping things that are known to fail when Accessibility is not enabled.  Evettaps which try to capture keyUp and keyDown events, for example, will fail until Accessibility is enabled and the Hammerspoon application is relaunched.
function M.accessibilityState(shouldPrompt, ...) end

-- An optional function that will be called when the Accessibility State is changed.
--
-- Notes:
--  * The function will not receive any arguments when called.  To check what the accessibility state has been changed to, you should call [hs.accessibilityState](#accessibilityState) from within your function.
M.accessibilityStateCallback = nil

-- Set or display whether or not external Hammerspoon AppleScript commands are allowed.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not external Hammerspoon's AppleScript commands are allowed.
--
-- Returns:
--  * A boolean, `true` if Hammerspoon's AppleScript commands are (or has just been) allowed, otherwise `false`.
--
-- Notes:
--  * AppleScript access is disallowed by default.
--  * However due to the way AppleScript support works, Hammerspoon will always allow AppleScript commands that are part of the "Standard Suite", such as `name`, `quit`, `version`, etc. However, Hammerspoon will only allow commands from the "Hammerspoon Suite" if `hs.allowAppleScript()` is set to `true`.
--  * For a full list of AppleScript Commands:
--      - Open `/Applications/Utilities/Script Editor.app`
--      - Click `File > Open Dictionary...`
--      - Select Hammerspoon from the list of Applications
--      - This will now open a Dictionary containing all of the available Hammerspoon AppleScript commands.
--  * Note that strings within the Lua code you pass from AppleScript can be delimited by `[[` and `]]` rather than normal quotes
--  * Example:
--    ```lua
--    tell application "Hammerspoon"
--      execute lua code "hs.alert([[Hello from AppleScript]])"
--    end tell```
---@return boolean
function M.allowAppleScript(state, ...) end

-- Set or display the "Launch on Login" status for Hammerspoon.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not Hammerspoon should be launched automatically when you log into your computer.
--
-- Returns:
--  * True if Hammerspoon is currently (or has just been) set to launch on login or False if Hammerspoon is not.
---@return boolean
function M.autoLaunch(state, ...) end

-- Gets and optionally sets the Hammerspoon option to automatically check for updates.
--
-- Parameters:
--  * setting - an optional boolean variable indicating if Hammerspoon should (true) or should not (false) check for updates.
--
-- Returns:
--  * The current (or newly set) value indicating whether or not automatic update checks should occur for Hammerspoon.
--
-- Notes:
--  * If you are running a non-release or locally compiled version of Hammerspoon then the results of this function are unspecified.
---@return boolean
function M.automaticallyCheckForUpdates(setting, ...) end

-- Checks the Camera Permissions for Hammerspoon, and optionally allows you to prompt for permissions.
--
-- Parameters:
--  * shouldPrompt - an optional boolean value indicating if we should request camera access. Defaults to false.
--
-- Returns:
--  * `true` or `false` indicating whether or not Camera access is enabled for Hammerspoon.
--
-- Notes:
--  * Will always return `true` on macOS 10.13 or earlier.
---@return boolean
function M.cameraState(shouldPrompt, ...) end

-- Returns a boolean indicating whether or not the Sparkle framework is available to check for Hammerspoon updates.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean indicating whether or not the Sparkle framework is available to check for Hammerspoon updates
--
-- Notes:
--  * The Sparkle framework is included in all regular releases of Hammerspoon but not included if you are running a non-release or locally compiled version of Hammerspoon, so this function can be used as a simple test to determine whether or not you are running a formal release Hammerspoon or not.
---@return boolean
function M.canCheckForUpdates() end

-- Check for an update now, and if one is available, prompt the user to continue the update process.
--
-- Parameters:
--  * silent - An optional boolean. If true, no UI will be displayed if an update is available. Defaults to false.
--
-- Returns:
--  * None
--
-- Notes:
--  * If you are running a non-release or locally compiled version of Hammerspoon then the results of this function are unspecified.
function M.checkForUpdates(silent, ...) end

-- Returns a copy of the incoming string that can be displayed in the Hammerspoon console.  Invalid UTF8 sequences are converted to the Unicode Replacement Character and NULL (0x00) is converted to the Unicode Empty Set character.
--
-- Parameters:
--  * inString - the string to be cleaned up
--
-- Returns:
--  * outString - the cleaned up version of the input string.
--
-- Notes:
--  * This function is applied automatically to all output which appears in the Hammerspoon console, but not to the output provided by the `hs` command line tool.
--  * This function does not modify the original string - to actually replace it, assign the result of this function to the original string.
--  * This function is a more specifically targeted version of the `hs.utf8.fixUTF8(...)` function.
function M.cleanUTF8forConsole(inString, ...) end

-- Closes the Hammerspoon Console window
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.closeConsole() end

-- Closes the Hammerspoon Preferences window
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.closePreferences() end

-- Gathers tab completion options for the Console window
--
-- Parameters:
--  * completionWord - A string from the Console window's input field that completions are needed for
--
-- Returns:
--  * A table of strings, each of which will be shown as a possible completion option to the user
--
-- Notes:
--  * Hammerspoon provides a default implementation of this function, which can complete against the global Lua namespace, the 'hs' (i.e. extension) namespace, and object metatables. You can assign a new function to the variable to replace it with your own variant.
function M.completionsForInputString(completionWord, ...) end

-- A string containing Hammerspoon's configuration directory. Typically `~/.hammerspoon/`
M.configdir = nil

-- Set or display whether or not the Hammerspoon console is always on top when visible.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not the Hammerspoon console is always on top when visible.
--
-- Returns:
--  * True if the console is currently set (or has just been) to be always on top when visible or False if it is not.
---@return boolean
function M.consoleOnTop(state, ...) end

-- Yield coroutine to allow the Hammerspoon application to process other scheduled events and schedule a resume in the event application queue.
--
-- Parameters:
--  * `delay` - an optional number, default `hs.math.minFloat`, specifying the number of seconds from when this function is executed that the `coroutine.resume` should be scheduled for.
--
-- Returns:
--  * None
--
-- Notes:
--  * this function will return an error if invoked outside of a coroutine.
--  * unlike `coroutine.yield`, this function does not allow the passing of (new) information to or from the coroutine while it is running; this function is to allow long running tasks to yield time to the Hammerspoon application so other timers and scheduled events can occur without requiring the programmer to add code for an explicit resume.
--
--  * this function is added to the lua `coroutine` library as `coroutine.applicationYield` as an alternative name.
function M.coroutineApplicationYield(delay, ...) end

-- Set or display whether or not the Hammerspoon dock icon is visible.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not the Hammerspoon dock icon should be visible.
--
-- Returns:
--  * True if the icon is currently set (or has just been) to be visible or False if it is not.
--
-- Notes:
--  * This function is a wrapper to functions found in the `hs.dockicon` module, but is provided here to provide an interface consistent with other selectable preference items.
---@return boolean
function M.dockIcon(state, ...) end

-- An optional function that will be called when the Hammerspoon Dock Icon is clicked while the app is running
--
-- Notes:
--  * If set, this callback will be called regardless of whether or not Hammerspoon shows its console window in response to a click (which can be enabled/disabled via `hs.openConsoleOnDockClick()`
M.dockIconClickCallback = nil

-- A string containing the full path to the `docs.json` file inside Hammerspoon's app bundle. This contains the full Hammerspoon API documentation and can be accessed in the Console using `help("someAPI")`. It can also be loaded and processed by the `hs.doc` extension
M.docstrings_json_file = nil

-- Runs a shell command, optionally loading the users shell environment first, and returns stdout as a string, followed by the same result codes as `os.execute` would return.
--
-- Parameters:
--  * command - a string containing the shell command to execute
--  * with_user_env - optional boolean argument which if provided and is true, executes the command in the users login shell as an "interactive" login shell causing the user's local profile (or other login scripts) to be loaded first.
--
-- Returns:
--  * output -- the stdout of the command as a string.  May contain an extra terminating new-line (\n).
--  * status -- `true` if the command terminated successfully or nil otherwise.
--  * type   -- a string value of "exit" or "signal" indicating whether the command terminated of its own accord or if it was terminated by a signal (killed, segfault, etc.)
--  * rc     -- if the command exited of its own accord, then this number will represent the exit code (usually 0 for success, not 0 for an error, though this is very command specific, so check man pages when there is a question).  If the command was killed by a signal, then this number corresponds to the signal type that caused the command to terminate.
--
-- Notes:
--  * Setting `with_user_env` to true does incur noticeable overhead, so it should only be used if necessary (to set the path or other environment variables).
--  * Because this function returns the stdout as it's first return value, it is not quite a drop-in replacement for `os.execute`.  In most cases, it is probable that `stdout` will be the empty string when `status` is nil, but this is not guaranteed, so this trade off of shifting os.execute's results was deemed acceptable.
--  * This particular function is most useful when you're more interested in the command's output then a simple check for completion and result codes.  If you only require the result codes or verification of command completion, then `os.execute` will be slightly more efficient.
--  * If you need to execute commands that have spaces in their paths, use a form like: `hs.execute [["/Some/Path To/An/Executable" "--first-arg" "second-arg"]]`
function M.execute(command, with_user_env, ...) end

-- An optional function that will be called when a files are dragged to the Hammerspoon Dock Icon or sent via the Services menu
--
-- Notes:
--  * The function should accept a single parameter, which will be a string containing the full path to the file that was dragged to the dock icon
--  * If multiple files are sent, this callback will be called once for each file
--  * This callback will be triggered when ANY file type is dragged onto the Hammerspoon Dock Icon, however certain filetypes are also processed separately by Hammerspoon. For example, `hs.urlevent` will be triggered when the following filetypes are dropped onto the Dock Icon: HTML Documents (.html, .htm, .shtml, .jhtml), Plain text documents (.txt, .text), Web site locations (.url), XHTML documents (.xhtml, .xht, .xhtm, .xht).
M.fileDroppedToDockIconCallback = nil

-- Makes Hammerspoon the foreground app.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.focus() end

-- Fetches the Lua metatable for objects produced by an extension
--
-- Parameters:
--  * name - A string containing the name of a module to fetch object metadata for (e.g. `"hs.screen"`)
--
-- Returns:
--  * The extension's object metatable, or nil if an error occurred
function M.getObjectMetatable(name, ...) end

-- Prints the documentation for some part of Hammerspoon's API and Lua 5.3.  This function is actually sourced from hs.doc.help.
--
-- Parameters:
--  * identifier - A string containing the signature of some part of Hammerspoon's API (e.g. `"hs.reload"`)
--
-- Returns:
--  * None
--
-- Notes:
--  * This function is mainly for runtime API help while using Hammerspoon's Console
--  * You can also access the results of this function by the following methods from the console:
--    * help("identifier") -- quotes are required, e.g. `help("hs.reload")`
--    * help.identifier.path -- no quotes are required, e.g. `help.hs.reload`
--  * Lua information can be accessed by using the `lua` prefix, rather than `hs`.
--    * the identifier `lua._man` provides the table of contents for the Lua 5.3 manual.  You can pull up a specific section of the lua manual by including the chapter (and subsection) like this: `lua._man._3_4_8`.
--    * the identifier `lua._C` will provide information specifically about the Lua C API for use when developing modules which require external libraries.
function M.help(identifier, ...) end

-- Display's Hammerspoon API documentation in a webview browser.
--
-- Parameters:
--  * identifier - An optional string containing the signature of some part of Hammerspoon's API (e.g. `"hs.reload"`).  If no string is provided, then the table of contents for the Hammerspoon documentation is displayed.
--
-- Returns:
--  * None
--
-- Notes:
--  * You can also access the results of this function by the following methods from the console:
--    * hs.hsdocs.identifier.path -- no quotes are required, e.g. `hs.hsdocs.hs.reload`
--  * See `hs.doc.hsdocs` for more information about the available settings for the documentation browser.
--  * This function provides documentation for Hammerspoon modules, functions, and methods similar to the Hammerspoon Dash docset, but does not require any additional software.
--  * This currently only provides documentation for the built in Hammerspoon modules, functions, and methods.  The Lua documentation and third-party modules are not presently supported, but may be added in a future release.
function M.hsdocs(identifier, ...) end

-- Loads a Spoon
--
-- Parameters:
--  * name - The name of a Spoon (without the trailing `.spoon`)
--  * global - An optional boolean. If true, this function will insert the spoon into Lua's global namespace as `spoon.NAME`. Defaults to true.
--
-- Returns:
--  * The object provided by the Spoon (which can be ignored if you chose to make the Spoon global)
--
-- Notes:
--  * Spoons are a way of distributing self-contained units of Lua functionality, for Hammerspoon. For more information, see https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md
--  * This function will load the Spoon and call its `:init()` method if it has one. If you do not wish this to happen, or wish to use a Spoon that somehow doesn't fit with the behaviours of this function, you can also simply `require('name')` to load the Spoon
--  * If the Spoon has a `:start()` method you are responsible for calling it before using the functionality of the Spoon.
--  * If the Spoon provides documentation, it will be loaded by made available in hs.docs
--  * To learn how to distribute your own code as a Spoon, see https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md
function M.loadSpoon(name, global, ...) end

-- Set or display whether or not the Hammerspoon menu icon is visible.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not the Hammerspoon menu icon should be visible.
--
-- Returns:
--  * True if the icon is currently set (or has just been) to be visible or False if it is not.
---@return boolean
function M.menuIcon(state, ...) end

-- Checks the Microphone Permissions for Hammerspoon, and optionally allows you to prompt for permissions.
--
-- Parameters:
--  * shouldPrompt - an optional boolean value indicating if we should request microphone access. Defaults to false.
--
-- Returns:
--  * `true` or `false` indicating whether or not Microphone access is enabled for Hammerspoon.
--
-- Notes:
--  * Will always return `true` on macOS 10.13 or earlier.
---@return boolean
function M.microphoneState(shouldPrompt, ...) end

-- Opens a file as if it were opened with /usr/bin/open
--
-- Parameters:
--  * filePath - A string containing the path to a file/bundle to open
--
-- Returns:
--  * A boolean, true if the file was opened successfully, otherwise false
function M.open(filePath, ...) end

-- Displays the OS X About panel for Hammerspoon; implicitly focuses Hammerspoon.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.openAbout() end

-- Opens the Hammerspoon Console window and optionally focuses it.
--
-- Parameters:
--  * bringToFront - if true (default), the console will be focused as well as opened.
--
-- Returns:
--  * None
function M.openConsole(bringToFront, ...) end

-- Set or display whether or not the Console window will open when the Hammerspoon dock icon is clicked
--
-- Parameters:
--  * state - An optional boolean, true if the console window should open, false if not
--
-- Returns:
--  * A boolean, true if the console window will open when the dock icon
--
-- Notes:
--  * This only refers to dock icon clicks while Hammerspoon is already running. The console window is not opened by launching the app
---@return boolean
function M.openConsoleOnDockClick(state, ...) end

-- Displays the Hammerspoon Preferences panel; implicitly focuses Hammerspoon.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.openPreferences() end

-- Set or display whether or not the Preferences panel should display in dark mode.
--
-- Parameters:
--  * state - an optional boolean which will set whether or not the Preferences panel should display in dark mode.
--
-- Returns:
--  * A boolean, true if dark mode is enabled otherwise false.
---@return boolean
function M.preferencesDarkMode(state, ...) end

-- Prints formatted strings to the Console
--
-- Parameters:
--  * format - A format string
--  * ... - Zero or more arguments to fill the placeholders in the format string
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a simple wrapper around the Lua code `print(string.format(...))`.
function M.printf(format, ...) end

-- A table containing read-only information about the Hammerspoon application instance currently running.
M.processInfo = nil

-- The original Lua print() function
--
-- Parameters:
--  * aString - A string to be printed
--
-- Returns:
--  * None
--
-- Notes:
--  * Hammerspoon overrides Lua's print() function, but this is a reference we retain to is, should you need it for any reason
function M.rawprint(aString, ...) end

-- Quits and relaunches Hammerspoon.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.relaunch() end

-- Reloads your init-file in a fresh Lua environment.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.reload() end

-- Checks the Screen Recording Permissions for Hammerspoon, and optionally allows you to prompt for permissions.
--
-- Parameters:
--  * shouldPrompt - an optional boolean value indicating if the dialog box asking if the System Preferences application should be opened should be presented when Screen Recording is not currently enabled for Hammerspoon.  Defaults to false.
--
-- Returns:
--  * True or False indicating whether or not Screen Recording is enabled for Hammerspoon.
--
-- Notes:
--  * If you trigger the prompt and the user denies it, you cannot bring up the prompt again - the user must manually enable it in System Preferences.
function M.screenRecordingState(shouldPrompt, ...) end

-- Shows an error to the user, using Hammerspoon's Console
--
-- Parameters:
--  * err - A string containing an error message
--
-- Returns:
--  * None
--
-- Notes:
--  * This function is called whenever an (uncaught) error occurs or is thrown (via `error()`)
--  * The default implementation shows a notification, opens the Console, and prints the error message and stacktrace
--  * You can override this function if you wish to route errors differently (e.g. for remote systems)
function M.showError(err, ...) end

-- An optional function that will be called when the Lua environment is being destroyed (either because Hammerspoon is exiting or reloading its config)
--
-- Notes:
--  * This function should not perform any asynchronous tasks
--  * You do not need to fastidiously destroy objects you have created, this callback exists purely for utility reasons (e.g. serialising state, destroying system resources that will not be released by normal Lua garbage collection processes, etc)
M.shutdownCallback = nil

-- An optional function that will be called when text is dragged to the Hammerspoon Dock Icon or sent via the Services menu
--
-- Notes:
--  * The function should accept a single parameter, which will be a string containing the text that was dragged to the dock icon
M.textDroppedToDockIconCallback = nil

-- Toggles the visibility of the console
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * If the console is not currently open, it will be opened. If it is open and not the focused window, it will be brought forward and focused.
--  * If the console is focused, it will be closed.
function M.toggleConsole() end

-- Gets the version & build number of an available update
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the display version of the latest release, or a boolean false if no update is available
--  * A string containing the build number of the latest release, or `nil` if no update is available
--
-- Notes:
--  * This is not a live check, it is a cached result of whatever the previous update check found. By default Hammerspoon checks for updates every few hours, but you can also add your own timer to check for updates more frequently with `hs.checkForUpdates()`
function M.updateAvailable() end

-- Get or set the "Upload Crash Data" preference for Hammerspoon
--
-- Parameters:
--  * state - An optional boolean, true to upload crash reports, false to not
--
-- Returns:
--  * True if Hammerspoon is currently (or has just been) set to upload crash data or False otherwise
--
-- Notes:
--  * If at all possible, please do allow Hammerspoon to upload crash reports to us, it helps a great deal in keeping Hammerspoon stable
--  * Our Privacy Policy can be found here: [https://www.hammerspoon.org/privacy.html](https://www.hammerspoon.org/privacy.html)
---@return boolean
function M.uploadCrashData(state, ...) end

