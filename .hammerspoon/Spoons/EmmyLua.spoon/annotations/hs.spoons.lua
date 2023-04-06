--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Utility and management functions for Spoons
-- Spoons are Lua plugins for Hammerspoon.
-- See https://www.hammerspoon.org/Spoons/ for more information
---@class hs.spoons
local M = {}
hs.spoons = M

-- Map a number of hotkeys according to a definition table
--
-- Parameters:
--  * def - table containing name-to-function definitions for the hotkeys supported by the Spoon. Each key is a hotkey name, and its value must be a function that will be called when the hotkey is invoked.
--  * map - table containing name-to-hotkey definitions and an optional message to be displayed via `hs.alert()` when the hotkey has been triggered, as supported by [bindHotkeys in the Spoon API](https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#hotkeys). Not all the entries in `def` must be bound, but if any keys in `map` don't have a definition, an error will be produced.
--
-- Returns:
--  * None
function M.bindHotkeysToSpec(def, map, ...) end

-- Check if a given Spoon is installed.
--
-- Parameters:
--  * name - Name of the Spoon to check.
--
-- Returns:
--  * If the Spoon is installed, it returns a table with the Spoon information as returned by `list()`. Returns `nil` if the Spoon is not installed.
function M.isInstalled(name, ...) end

-- Check if a given Spoon is loaded.
--
-- Parameters:
--  * name - Name of the Spoon to check.
--
-- Returns:
--  * `true` if the Spoon is loaded, `nil` otherwise.
function M.isLoaded(name, ...) end

-- Return a list of installed/loaded Spoons
--
-- Parameters:
--  * onlyLoaded - only return loaded Spoons (skips those that are installed but not loaded). Defaults to `false`
--
-- Returns:
--  * Table with a list of installed/loaded spoons (depending on the value of `onlyLoaded`). Each entry is a table with the following entries:
--    * `name` - Spoon name
--    * `loaded` - boolean indication of whether the Spoon is loaded (`true`) or only installed (`false`)
--    * `version` - Spoon version number. Available only for loaded Spoons.
function M.list() end

-- Create a skeleton for a new Spoon
--
-- Parameters:
--  * name: name of the new spoon, without the `.spoon` extension
--  * basedir: (optional) directory where to create the template. Defaults to `~/.hammerspoon/Spoons`
--  * metadata: (optional) table containing metadata values to be inserted in the template. Provided values are merged with the defaults. Defaults to:
--    ```
--    {
--      version = "0.1",
--      author = "Your Name <your@email.org>",
--      homepage = "https://github.com/Hammerspoon/Spoons",
--      license = "MIT - https://opensource.org/licenses/MIT",
--      download_url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/"..name..".spoon.zip"
--    }
--    ```
--  * template: (optional) absolute path of the template to use for the `init.lua` file of the new Spoon. Defaults to the `templates/init.tpl` file included with Hammerspoon.
--
-- Returns:
--  * The full directory path where the template was created, or `nil` if there was an error.
function M.newSpoon(name, basedir, metadata, template, ...) end

-- Return full path of an object within a spoon directory, given its partial path.
--
-- Parameters:
--  * partial - path of a file relative to the Spoon directory. For example `images/img1.png` will refer to a file within the `images` directory of the Spoon.
--
-- Returns:
--  * Absolute path of the file. Note: no existence or other checks are done on the path.
---@return string
function M.resourcePath(partial, ...) end

-- Return path of the current spoon.
--
-- Parameters:
--  * n - (optional) stack level for which to get the path. Defaults to 2, which will return the path of the spoon which called `scriptPath()`
--
-- Returns:
--  * String with the path from where the calling code was loaded.
---@return string
function M.scriptPath(n) end

-- Declaratively load and configure a Spoon
--
-- Parameters:
--  * name - the name of the Spoon to load (without the `.spoon` extension).
--  * arg - if provided, can be used to specify the configuration of the Spoon. The following keys are recognized (all are optional):
--    * config - a table containing variables to be stored in the Spoon object to configure it. For example, `config = { answer = 42 }` will result in `spoon.<LoadedSpoon>.answer` being set to 42.
--    * hotkeys - a table containing hotkey bindings. If provided, will be passed as-is to the Spoon's `bindHotkeys()` method. The special string `"default"` can be given to use the Spoons `defaultHotkeys` variable, if it exists.
--    * fn - a function which will be called with the freshly-loaded Spoon object as its first argument.
--    * loglevel - if the Spoon has a variable called `logger`, its `setLogLevel()` method will be called with this value.
--    * start - if `true`, call the Spoon's `start()` method after configuring everything else.
--  * noerror - if `true`, don't log an error if the Spoon is not installed, simply return `nil`.
--
-- Returns:
--  * `true` if the spoon was loaded, `nil` otherwise
function M.use(name, arg, noerror, ...) end

