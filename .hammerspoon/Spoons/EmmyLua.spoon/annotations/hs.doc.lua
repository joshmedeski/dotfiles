--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Create documentation objects for interactive help within Hammerspoon
--
-- The documentation object created is a table with tostring metamethods allowing access to a specific functions documentation by appending the path to the method or function to the object created.
--
-- From the Hammerspoon console:
--
--       doc = require("hs.doc")
--       doc.hs.application
--
-- Results in:
--
--       Manipulate running applications
--
--       [submodules]
--       hs.application.watcher
--
--       [subitems]
--       hs.application:activate([allWindows]) -> bool
--       hs.application:allWindows() -> window[]
--           ...
--       hs.application:visibleWindows() -> win[]
--
-- By default, the internal core documentation and portions of the Lua 5.3 manual, located at http://www.lua.org/manual/5.3/manual.html, are already registered for inclusion within this documentation object, but you can register additional documentation from 3rd party modules with `hs.registerJSONFile(...)`.
---@class hs.doc
local M = {}
hs.doc = M

-- Prints the documentation for some part of Hammerspoon's API and Lua 5.3.  This function has also been aliased as `hs.help` and `help` as a shorthand for use within the Hammerspoon console.
--
-- Parameters:
--  * identifier - A string containing the signature of some part of Hammerspoon's API (e.g. `"hs.reload"`)
--
-- Returns:
--  * None
--
-- Notes:
--  * This function is mainly for runtime API help while using Hammerspoon's Console
--
--  * Documentation files registered with [hs.doc.registerJSONFile](#registerJSONFile) or [hs.doc.preloadSpoonDocs](#preloadSpoonDocs) that have not yet been actually loaded will be loaded when this command is invoked in any of the forms described below.
--
--  * You can also access the results of this function by the following methods from the console:
--    * help("prefix.path") -- quotes are required, e.g. `help("hs.reload")`
--    * help.prefix.path -- no quotes are required, e.g. `help.hs.reload`
--      * `prefix` can be one of the following:
--        * `hs`    - provides documentation for Hammerspoon's builtin commands and modules
--        * `spoon` - provides documentation for the Spoons installed on your system
--        * `lua`   - provides documentation for the version of lua Hammerspoon is using, currently 5.3
--          * `lua._man` - provides the table of contents for the Lua 5.3 manual.  You can pull up a specific section of the lua manual by including the chapter (and subsection) like this: `lua._man._3_4_8`.
--          * `lua._C`   - provides documentation specifically about the Lua C API for use when developing modules which require external libraries.
--      * `path` is one or more components, separated by a period specifying the module, submodule, function, or method you wish to view documentation for.
function M.help(identifier, ...) end

-- Locates the JSON file corresponding to the specified third-party module or Spoon by searching package.path and package.cpath.
--
-- Parameters:
--  * module - the name of the module to locate a JSON file for
--
-- Returns:
--  * the path to the JSON file, or `false, error` if unable to locate a corresponding JSON file.
--
-- Notes:
--  * The JSON should be named 'docs.json' and located in the same directory as the `lua` or `so` file which is used when the module is loaded via `require`.
--
--  * The documentation for core modules is stored in the JSON file specified by the `hs.docstrings_json_file` variable; this function is intended for use in locating the documentation file for third party modules and Spoons.
function M.locateJSONFile(module, ...) end

-- Locates all installed Spoon documentation files and marks them for loading the next time the [hs.doc.help](#help) function is invoked.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.preloadSpoonDocs() end

-- Returns the list of registered JSON files.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the list of registered JSON files
--
-- Notes:
--  * The table returned by this function has a metatable including a __tostring method which allows you to see the list of registered files by simply typing `hs.doc.registeredFiles()` in the Hammerspoon Console.
--
--  * By default, the internal core documentation and portions of the Lua 5.3 manual, located at http://www.lua.org/manual/5.3/manual.html, are already registered for inclusion within this documentation object.
--
--  * You can unregister these defaults if you wish to start with a clean slate with the following commands:
--    * `hs.doc.unregisterJSONFile(hs.docstrings_json_file)` -- to unregister the Hammerspoon API docs
--    * `hs.doc.unregisterJSONFile((hs.docstrings_json_file:gsub("/docs.json$","/lua.json")))` -- to unregister the Lua 5.3 Documentation.
function M.registeredFiles() end

-- Register a JSON file for inclusion when Hammerspoon generates internal documentation.
--
-- Parameters:
--  * jsonfile - A string containing the location of a JSON file
--  * isSpoon  - an optional boolean, default false, specifying that the documentation should be added to the `spoons` sub heading in the documentation hierarchy.
--
-- Returns:
--  * status - Boolean flag indicating if the file was registered or not.  If the file was not registered, then a message indicating the error is also returned.
--
-- Notes:
--  * this function just registers the documentation file; it won't actually be loaded and parsed until [hs.doc.help](#help) is invoked.
function M.registerJSONFile(jsonfile, isSpoon, ...) end

-- Remove a JSON file from the list of registered files.
--
-- Parameters:
--  * jsonfile - A string containing the location of a JSON file
--
-- Returns:
--  * status - Boolean flag indicating if the file was unregistered or not.  If the file was not unregistered, then a message indicating the error is also returned.
--
-- Notes:
--  * This function requires the rebuilding of the entire documentation tree for all remaining registered files, so the next time help is queried with [hs.doc.help](#help), there may be a slight one-time delay.
function M.unregisterJSONFile(jsonfile, ...) end

