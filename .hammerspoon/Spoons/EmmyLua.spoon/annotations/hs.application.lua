--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Manipulate running applications
---@class hs.application
local M = {}
hs.application = M

-- Tries to activate the app (make its key window focused) and returns whether it succeeded; if allWindows is true, all windows of the application are brought forward as well.
--
-- Parameters:
--  * allWindows - If true, all windows of the application will be brought to the front. Otherwise, only the application's key window will. Defaults to false.
--
-- Returns:
--  * A boolean value indicating whether or not the application could be activated
---@return boolean
function M:activate(allWindows, ...) end

-- Returns all open windows owned by the given app.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table of zero or more hs.window objects owned by the application
--
-- Notes:
--  * This function can only return windows in the current Mission Control Space; if you need to address windows across
--    different Spaces you can use the `hs.window.filter` module
--    - if `Displays have separate Spaces` is *on* (in System Preferences>Mission Control) the current Space is defined
--      as the union of all currently visible Spaces
--    - minimized windows and hidden windows (i.e. belonging to hidden apps, e.g. via cmd-h) are always considered
--      to be in the current Space
---@return hs.window[]
function M:allWindows() end

-- Returns the running app for the given pid, if it exists.
--
-- Parameters:
--  * pid - a UNIX process id (i.e. a number)
--
-- Returns:
--  * An hs.application object if one can be found, otherwise nil
---@return hs.application
function M.applicationForPID(pid, ...) end

-- Returns any running apps that have the given bundleID.
--
-- Parameters:
--  * bundleID - An OSX application bundle identifier
--
-- Returns:
--  * A table of zero or more hs.application objects that match the given identifier
---@return hs.application[]
function M.applicationsForBundleID(bundleID, ...) end

-- Returns the bundle identifier of the app.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the bundle identifier of the application
---@return string
function M:bundleID() end

-- Returns the bundle ID of the default application for a given UTI
--
-- Parameters:
--  * uti - A string containing a UTI
--
-- Returns:
--  * A string containing a bundle ID, or nil if none could be found
function M.defaultAppForUTI(uti, ...) end

-- Get or set whether Spotlight should be used to find alternate names for applications.
--
-- Parameters:
--  * `state` - an optional boolean specifying whether or not Spotlight should be used to try and determine alternate application names for `hs.application.find` and similar functions.
--
-- Returns:
--  * the current, possibly changed, state
--
-- Notes:
--  * This setting is persistent across reloading and restarting Hammerspoon.
--  * If this was set to true and you set it to true again, it will purge the alternate name map and rebuild it from scratch.
--  * You can disable Spotlight alternate name mapping by setting this value to false or nil. If you set this to false, then the notifications indicating that more results might be possible if Spotlight is enabled will be suppressed.
---@return boolean
function M.enableSpotlightForNameSearches(state, ...) end

-- Finds running applications
--
-- Parameters:
--  * hint - search criterion for the desired application(s); it can be:
--    - a pid number as per `hs.application:pid()`
--    - a bundle ID string as per `hs.application:bundleID()`
--    - a string pattern that matches (via `string.find`) the application name as per `hs.application:name()` (for convenience, the matching will be done on lowercased strings)
--    - a string pattern that matches (via `string.find`) the application's window title per `hs.window:title()` (for convenience, the matching will be done on lowercased strings)
--  * exact - a boolean, true to check application names for exact matches, false to use Lua's string:find() method. Defaults to false
--  * stringLiteral - a boolean, true to interpret the hint string literally, false to interpret it as a Lua Pattern. Defaults to false.
--
-- Returns:
--  * one or more hs.application objects for running applications that match the supplied search criterion, or `nil` if none found
--
-- Notes:
--  * If multiple results are found, this function will return multiple values. See [https://www.lua.org/pil/5.1.html](https://www.lua.org/pil/5.1.html) for more information on how to work with this
--  * for convenience you can call this as `hs.application(hint)`
--  * use this function when you don't know the exact name of an application you're interested in, i.e.
--    from the console: `hs.application'term' --> hs.application: iTerm2 (0x61000025fb88)  hs.application: Terminal (0x618000447588)`.
--    But be careful when using it in your `init.lua`: `terminal=hs.application'term'` will assign either "Terminal" or "iTerm2" arbitrarily (or even,
--    if neither are running, any other app with a window that happens to have "term" in its title); to make sure you get the right app in your scripts,
--    use `hs.application.get` with the exact name: `terminal=hs.application.get'Terminal' --> "Terminal" app, or nil if it's not running`
--
-- Usage:
-- -- by pid
-- hs.application(42):name() --> Finder
-- -- by bundle id
-- hs.application'com.apple.Safari':name() --> Safari
-- -- by name
-- hs.application'chrome':name() --> Google Chrome
-- -- by window title
-- hs.application'bash':name() --> Terminal
---@return hs.application
function M.find(hint, exact, stringLiteral, ...) end

-- Searches the application for a menu item
--
-- Parameters:
--  * menuItem - This can either be a string containing the text of a menu item (e.g. `"Messages"`) or a table representing the hierarchical path of a menu item (e.g. `{"File", "Share", "Messages"}`). In the string case, all of the application's menus will be searched until a match is found (with no specified behaviour if multiple menu items exist with the same name). In the table case, the whole menu structure will not be searched, because a precise path has been specified.
--  * isRegex - An optional boolean, defaulting to false, which is only used if `menuItem` is a string. If set to true, `menuItem` will be treated as a regular expression rather than a strict string to match against
--
-- Returns:
--  * Returns nil if the menu item cannot be found. If it does exist, returns a table with two keys:
--   * enabled - whether the menu item can be selected/ticked. This will always be false if the application is not currently focussed
--   * ticked - whether the menu item is ticked or not (obviously this value is meaningless for menu items that can't be ticked)
--
-- Notes:
--  * This can only search for menu items that don't have children - i.e. you can't search for the name of a submenu
function M:findMenuItem(menuItem, isRegex, ...) end

-- Finds windows from this application
--
-- Parameters:
--  * titlePattern - a string pattern that matches (via `string.find`) the window title(s) as per `hs.window:title()` (for convenience, the matching will be done on lowercased strings)
--
-- Returns:
--  * one or more hs.window objects belonging to this application that match the supplied search criterion, or `nil` if none found
---@return hs.window
function M:findWindow(titlePattern, ...) end

-- Returns the currently focused window of the application, or nil
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.window object representing the window of the application that currently has focus, or nil if there are none
---@return hs.window
function M:focusedWindow() end

-- Returns the application object for the frontmost (active) application.  This is the application which currently receives input events.
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.application object
---@return hs.application
function M.frontmostApplication() end

-- Gets a running application
--
-- Parameters:
--  * hint - search criterion for the desired application; it can be:
--    - a pid number as per `hs.application:pid()`
--    - a bundle ID string as per `hs.application:bundleID()`
--    - an application name string as per `hs.application:name()`
--
-- Returns:
--  * an hs.application object for a running application that matches the supplied search criterion, or `nil` if not found
--
-- Notes:
--  * see also `hs.application.find`
---@return hs.application
function M.get(hint, ...) end

-- Gets the menu structure of the application
--
-- Parameters:
--  * fn - an optional callback function.  If provided, the function will receive a single argument and return none.
--
-- Returns:
--  * If no argument is provided, returns a table containing the menu structure of the application, or nil if an error occurred. If a callback function is provided, the callback function will receive this table (or nil) and this method will return the application object this method was invoked on.
--
-- Notes:
--  * In some applications, this can take a little while to complete, because quite a large number of round trips are required to the source application, to get the information. When this method is invoked without a callback function, Hammerspoon will block while creating the menu structure table.  When invoked with a callback function, the menu structure is built in a background thread.
--
--  * The table is nested with the same structure as the menus of the application. Each item has several keys containing information about the menu item. Not all keys will appear for all items. The possible keys are:
--   * AXTitle - A string containing the text of the menu item (entries which have no title are menu separators)
--   * AXEnabled - A boolean, 1 if the menu item is clickable, 0 if not
--   * AXRole - A string containing the role of the menu item - this will be either AXMenuBarItem for a top level menu, or AXMenuItem for an item in a menu
--   * AXMenuItemMarkChar - A string containing the "mark" character for a menu item. This is for toggleable menu items and will usually be an empty string or a Unicode tick character (✓)
--   * AXMenuItemCmdModifiers - A table containing string representations of the keyboard modifiers for the menu item's keyboard shortcut, or nil if no modifiers are present
--   * AXMenuItemCmdChar - A string containing the key for the menu item's keyboard shortcut, or an empty string if no shortcut is present
--   * AXMenuItemCmdGlyph - An integer, corresponding to one of the defined glyphs in `hs.application.menuGlyphs` if the keyboard shortcut is a special character usually represented by a pictorial representation (think arrow keys, return, etc), or an empty string if no glyph is used in presenting the keyboard shortcut.
--  * Using `hs.inspect()` on these tables, while useful for exploration, can be extremely slow, taking several minutes to correctly render very complex menus
function M:getMenuItems(fn) end

-- Gets a specific window from this application
--
-- Parameters:
--  * title - the desired window's title string as per `hs.window:title()`
--
-- Returns:
--  * the desired hs.window object belonging to this application, or `nil` if not found
---@return hs.window
function M:getWindow(title, ...) end

-- Hides the app (and all its windows).
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating whether the application was successfully hidden
---@return boolean
function M:hide() end

-- Gets the metadata of an application from its bundle identifier
--
-- Parameters:
--  * bundleID - A string containing an application bundle identifier (e.g. "com.apple.Safari")
--
-- Returns:
--  * A table containing information about the application, or nil if the bundle identifier could not be located
function M.infoForBundleID(bundleID, ...) end

-- Gets the metadata of an application from its path on disk
--
-- Parameters:
--  * bundlePath - A string containing the path to an application bundle (e.g. "/Applications/Safari.app")
--
-- Returns:
--  * A table containing information about the application, or nil if the bundle could not be located
function M.infoForBundlePath(bundlePath, ...) end

-- Returns whether the app is the frontmost (i.e. is the currently active application)
--
-- Parameters:
--  * None
--
-- Returns:
--  * True if the application is the frontmost application, otherwise false
---@return boolean
function M:isFrontmost() end

-- Returns whether the app is currently hidden.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating whether the application is hidden or not
---@return boolean
function M:isHidden() end

-- Checks if the application is still running
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean, true if the application is running, false if not
--
-- Notes:
--  * If an application is terminated and re-launched, this method will still return false, as `hs.application` objects are tied to a specific instance of an application (i.e. its PID)
---@return boolean
function M:isRunning() end

-- Tries to terminate the app gracefully.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:kill() end

-- Tries to terminate the app forcefully.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:kill9() end

-- Identify the application's GUI state
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number that is either 1 if the app is in the dock, 0 if it is not, or -1 if the application is prohibited from having GUI elements
---@return number
function M:kind() end

-- Launches the app with the given name, or activates it if it's already running
--
-- Parameters:
--  * name - A string containing the name of the application to either launch or focus. This can also be the full path to an application (including the `.app` suffix) if you need to uniquely distinguish between applications in different locations that share the same name
--
-- Returns:
--  * True if the application was either launched or focused, otherwise false (e.g. if the application doesn't exist)
--
-- Notes:
--  * The name parameter should match the name of the application on disk, e.g. "IntelliJ IDEA", rather than "IntelliJ"
---@return boolean
function M.launchOrFocus(name, ...) end

-- Launches the app with the given bundle ID, or activates it if it's already running
--
-- Parameters:
--  * bundleID - A string containing the bundle ID of the application to either launch or focus.
--
-- Returns:
--  * True if the application was either launched or focused, otherwise false (e.g. if the application doesn't exist)
--
-- Notes:
--  * Bundle identifiers typically take the form of `com.company.ApplicationName`
---@return boolean
function M.launchOrFocusByBundleID(bundleID, ...) end

-- Gets a list of all the localizations contained in the bundle.
--
-- Parameters:
--  * bundleID - A string containing an application bundle identifier (e.g. "com.apple.Safari")
--
-- Returns:
--  * A table containing language IDs for all the localizations contained in the bundle.
function M.localizationsForBundleID(bundleID, ...) end

-- Gets a list of all the localizations contained in the bundle.
--
-- Parameters:
--  * bundlePath - A string containing the path to an application bundle (e.g. "/Applications/Safari.app")
--
-- Returns:
--  * A table containing language IDs for all the localizations contained in the bundle.
function M.localizationsForBundlePath(bundlePath, ...) end

-- Returns the main window of the given app, or nil.
--
-- Parameters:
--  * None
--
-- Returns:
--  * An hs.window object representing the main window of the application, or nil if it has no windows
---@return hs.window
function M:mainWindow() end

-- A table containing UTF8 representations of the defined key glyphs used in Menus for keyboard shortcuts which are presented pictorially rather than as text (arrow keys, return key, etc.)
--
-- These glyphs are indexed numerically where the numeric index matches a possible value for the AXMenuItemCmdGlyph key of an entry returned by `hs.application.getMenus`.  If the AXMenuItemCmdGlyph field is non-numeric, then no glyph is used in the presentation of the keyboard shortcut for a menu item.
--
-- The following glyphs are defined:
--  * "⇥",  -- kMenuTabRightGlyph, 0x02, Tab to the right key (for left-to-right script systems)
--  * "⇤",  -- kMenuTabLeftGlyph, 0x03, Tab to the left key (for right-to-left script systems)
--  * "⌤",   -- kMenuEnterGlyph, 0x04, Enter key
--  * "⇧",  -- kMenuShiftGlyph, 0x05, Shift key
--  * "⌃",   -- kMenuControlGlyph, 0x06, Control key
--  * "⌥",  -- kMenuOptionGlyph, 0x07, Option key
--  * "␣",    -- kMenuSpaceGlyph, 0x09, Space (always glyph 3) key
--  * "⌦",  -- kMenuDeleteRightGlyph, 0x0A, Delete to the right key (for right-to-left script systems)
--  * "↩",  -- kMenuReturnGlyph, 0x0B, Return key (for left-to-right script systems)
--  * "↪",  -- kMenuReturnR2LGlyph, 0x0C, Return key (for right-to-left script systems)
--  * "",   -- kMenuPencilGlyph, 0x0F, Pencil key
--  * "↓",   -- kMenuDownwardArrowDashedGlyph, 0x10, Downward dashed arrow key
--  * "⌘",  -- kMenuCommandGlyph, 0x11, Command key
--  * "✓",   -- kMenuCheckmarkGlyph, 0x12, Checkmark key
--  * "⃟",   -- kMenuDiamondGlyph, 0x13, Diamond key
--  * "",   -- kMenuAppleLogoFilledGlyph, 0x14, Apple logo key (filled)
--  * "⌫",  -- kMenuDeleteLeftGlyph, 0x17, Delete to the left key (for left-to-right script systems)
--  * "←",  -- kMenuLeftArrowDashedGlyph, 0x18, Leftward dashed arrow key
--  * "↑",   -- kMenuUpArrowDashedGlyph, 0x19, Upward dashed arrow key
--  * "→",   -- kMenuRightArrowDashedGlyph, 0x1A, Rightward dashed arrow key
--  * "⎋",  -- kMenuEscapeGlyph, 0x1B, Escape key
--  * "⌧",  -- kMenuClearGlyph, 0x1C, Clear key
--  * "『",  -- kMenuLeftDoubleQuotesJapaneseGlyph, 0x1D, Unassigned (left double quotes in Japanese)
--  * "』",  -- kMenuRightDoubleQuotesJapaneseGlyph, 0x1E, Unassigned (right double quotes in Japanese)
--  * "␢",   -- kMenuBlankGlyph, 0x61, Blank key
--  * "⇞",   -- kMenuPageUpGlyph, 0x62, Page up key
--  * "⇪",  -- kMenuCapsLockGlyph, 0x63, Caps lock key
--  * "←",  -- kMenuLeftArrowGlyph, 0x64, Left arrow key
--  * "→",   -- kMenuRightArrowGlyph, 0x65, Right arrow key
--  * "↖",  -- kMenuNorthwestArrowGlyph, 0x66, Northwest arrow key
--  * "﹖",  -- kMenuHelpGlyph, 0x67, Help key
--  * "↑",   -- kMenuUpArrowGlyph, 0x68, Up arrow key
--  * "↘",  -- kMenuSoutheastArrowGlyph, 0x69, Southeast arrow key
--  * "↓",   -- kMenuDownArrowGlyph, 0x6A, Down arrow key
--  * "⇟",   -- kMenuPageDownGlyph, 0x6B, Page down key
--  * "",  -- kMenuContextualMenuGlyph, 0x6D, Contextual menu key
--  * "⌽",  -- kMenuPowerGlyph, 0x6E, Power key
--  * "F1",  -- kMenuF1Glyph, 0x6F, F1 key
--  * "F2",  -- kMenuF2Glyph, 0x70, F2 key
--  * "F3",  -- kMenuF3Glyph, 0x71, F3 key
--  * "F4",  -- kMenuF4Glyph, 0x72, F4 key
--  * "F5",  -- kMenuF5Glyph, 0x73, F5 key
--  * "F6",  -- kMenuF6Glyph, 0x74, F6 key
--  * "F7",  -- kMenuF7Glyph, 0x75, F7 key
--  * "F8",  -- kMenuF8Glyph, 0x76, F8 key
--  * "F9",  -- kMenuF9Glyph, 0x77, F9 key
--  * "F10", -- kMenuF10Glyph, 0x78, F10 key
--  * "F11", -- kMenuF11Glyph, 0x79, F11 key
--  * "F12", -- kMenuF12Glyph, 0x7A, F12 key
--  * "F13", -- kMenuF13Glyph, 0x87, F13 key
--  * "F14", -- kMenuF14Glyph, 0x88, F14 key
--  * "F15", -- kMenuF15Glyph, 0x89, F15 key
--  * "⎈",  -- kMenuControlISOGlyph, 0x8A, Control key (ISO standard)
--  * "⏏",   -- kMenuEjectGlyph, 0x8C, Eject key (available on Mac OS X 10.2 and later)
--  * "英数", -- kMenuEisuGlyph, 0x8D, Japanese eisu key (available in Mac OS X 10.4 and later)
--  * "かな", -- kMenuKanaGlyph, 0x8E, Japanese kana key (available in Mac OS X 10.4 and later)
--  * "F16", -- kMenuF16Glyph, 0x8F, F16 key (available in SnowLeopard and later)
--  * "F17", -- kMenuF16Glyph, 0x90, F17 key (available in SnowLeopard and later)
--  * "F18", -- kMenuF16Glyph, 0x91, F18 key (available in SnowLeopard and later)
--  * "F19", -- kMenuF16Glyph, 0x92, F19 key (available in SnowLeopard and later)
--
-- Notes:
--  * a `__tostring` metamethod is provided for this table so you can view its current contents by typing `hs.application.menuGlyphs` into the Hammerspoon console.
--  * This table is provided as a variable so that you can change any representation if you feel you know of a better or more appropriate one for you usage at runtime.
--
--  * The glyphs provided are defined in the Carbon framework headers in the Menus.h file, located (as of 10.11) at /System/Library/Frameworks/Carbon.framework/Frameworks/HIToolbox.framework/Headers/Menus.h.
--  * The following constants are defined in Menus.h, but do not seem to correspond to a visible UTF8 character or well defined representation that I could discover.  If you believe that you know of a (preferably sanctioned by Apple) proper visual representation, please submit an issue detailing it at the Hammerspoon repository on GitHub.
--    * kMenuNullGlyph, 0x00, Null (always glyph 1)
--    * kMenuNonmarkingReturnGlyph, 0x0D, Nonmarking return key
--    * kMenuParagraphKoreanGlyph, 0x15, Unassigned (paragraph in Korean)
--    * kMenuTrademarkJapaneseGlyph, 0x1F, Unassigned (trademark in Japanese)
--    * kMenuAppleLogoOutlineGlyph, 0x6C, Apple logo key (outline)
M.menuGlyphs = nil

-- Alias for [`hs.application:title()`](#title)
function M:name() end

-- Gets the name of an application from its bundle identifier
--
-- Parameters:
--  * bundleID - A string containing an application bundle identifier (e.g. "com.apple.Safari")
--
-- Returns:
--  * A string containing the application name, or nil if the bundle identifier could not be located
function M.nameForBundleID(bundleID, ...) end

-- Launches an application, or activates it if it's already running
--
-- Parameters:
--  * app - a string describing the application to open; it can be:
--    - the application's name as per `hs.application:name()`
--    - the full path to an application on disk (including the `.app` suffix)
--    - the application's bundle ID as per `hs.application:bundleID()`
--  * wait - (optional) the maximum number of seconds to wait for the app to be launched, if not already running; if omitted, defaults to 0;
--   if the app takes longer than this to launch, this function will return `nil`, but the app will still launch
--  * waitForFirstWindow - (optional) if `true`, additionally wait until the app has spawned its first window (which usually takes a bit longer)
--
-- Returns:
--  * the `hs.application` object for the launched or activated application; `nil` if not found
--
-- Notes:
--  * the `wait` parameter will *block all Hammerspoon activity* in order to return the application object "synchronously"; only use it if you
--    a) have no time-critical event processing happening elsewhere in your `init.lua` and b) need to act on the application object, or on
--    its window(s), right away
--  * when launching a "windowless" app (background daemon, menulet, etc.) make sure to omit `waitForFirstWindow`
---@return hs.application
function M.open(app, wait, waitForFirstWindow, ...) end

-- Returns the filesystem path of the app.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the filesystem path of the application or nil if the path could not be determined (e.g. if the application has terminated).
---@return string
function M:path() end

-- Gets the filesystem path of an application from its bundle identifier
--
-- Parameters:
--  * bundleID - A string containing an application bundle identifier (e.g. "com.apple.Safari")
--
-- Returns:
--  * A string containing the app bundle's filesystem path, or nil if the bundle identifier could not be located
function M.pathForBundleID(bundleID, ...) end

-- Returns the app's process identifier.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The UNIX process identifier of the application (i.e. a number)
---@return number
function M:pid() end

-- Gets an ordered list of preferred localizations contained in a bundle
--
-- Parameters:
--  * bundleID - A string containing an application bundle identifier (e.g. "com.apple.Safari")
--
-- Returns:
--  * A table containing language IDs for localizations in the bundle. The strings are ordered according to the user's language preferences and available localizations.
function M.preferredLocalizationsForBundleID(bundleID, ...) end

-- Gets an ordered list of preferred localizations contained in a bundle
--
-- Parameters:
--  * bundlePath - A string containing the path to an application bundle (e.g. "/Applications/Safari.app")
--
-- Returns:
--  * A table containing language IDs for localizations in the bundle. The strings are ordered according to the user's language preferences and available localizations.
function M.preferredLocalizationsForBundlePath(bundlePath, ...) end

-- Returns all running apps.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing zero or more hs.application objects currently running on the system
---@return hs.application[]
function M.runningApplications() end

-- Selects a menu item (i.e. simulates clicking on the menu item)
--
-- Parameters:
--  * menuitem - The menu item to select, specified as either a string or a table. See the `menuitem` parameter of `hs.application:findMenuItem()` for more information.
--  * isRegex - An optional boolean, defaulting to false, which is only used if `menuItem` is a string. If set to true, `menuItem` will be treated as a regular expression rather than a strict string to match against
--
-- Returns:
--  * True if the menu item was found and selected, or nil if it wasn't (e.g. because the menu item couldn't be found)
--
-- Notes:
--  * Depending on the type of menu item involved, this will either activate or tick/untick the menu item
function M:selectMenuItem(menuitem, isRegex, ...) end

-- Sets the app to the frontmost (i.e. currently active) application
--
-- Parameters:
--  * allWindows - An optional boolean, true to bring all windows of the application to the front. Defaults to false
--
-- Returns:
--  * A boolean, true if the operation was successful, otherwise false
---@return boolean
function M:setFrontmost(allWindows, ...) end

-- Returns the localized name of the app (in UTF8).
--
-- Parameters:
--  * None
--
-- Returns:
--  * A string containing the name of the application
---@return string
function M:title() end

-- Unhides the app (and all its windows) if it's hidden.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating whether the application was successfully unhidden
---@return boolean
function M:unhide() end

-- Returns only the app's windows that are visible.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A table containing zero or more hs.window objects
function M:visibleWindows() end

