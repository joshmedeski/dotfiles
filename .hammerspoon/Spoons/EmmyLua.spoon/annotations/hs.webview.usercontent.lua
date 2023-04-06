--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module provides support for injecting custom JavaScript user content into your webviews and for JavaScript to post messages back to Hammerspoon.
---@class hs.webview.usercontent
local M = {}
hs.webview.usercontent = M

-- Add a script to be injected into webviews which use this user content controller.
--
-- Parameters:
--  * scriptTable - a table containing the following keys which define the script and how it is to be injected:
--    * source        - the javascript which is injected (required)
--    * mainFrame     - a boolean value which indicates whether this script is only injected for the main webview frame (true) or for all frames within the webview (false).  Defaults to true.
--    * injectionTime - a string which indicates whether the script is injected at "documentStart" or "documentEnd". Defaults to "documentStart".
--
-- Returns:
--  * the usercontentControllerObject or nil if the script table was malformed in some way.
function M:injectScript(scriptTable, ...) end

-- Create a new user content controller for a webview and create the message port with the specified name for JavaScript message support.
--
-- Parameters:
--  * name - the name of the message port which JavaScript in the webview can use to post messages to Hammerspoon.
--
-- Returns:
--  * the usercontentControllerObject
--
-- Notes:
--  * This object should be provided as the final argument to the `hs.webview.new` constructor in order to tie the webview to this content controller.  All new windows which are created from this parent webview will also use this controller.
--  * See `hs.webview.usercontent:setCallback` for more information about the message port.
function M.new(name, ...) end

-- Removes all user scripts currently defined for this user content controller.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the usercontentControllerObject
-- Notes:
--  * The WKUserContentController class only allows for removing all scripts.  If you need finer control, make a copy of the current scripts with `hs.webview.usercontent.userScripts()` first so you can recreate the scripts you want to keep.
function M:removeAllScripts() end

-- Set or remove the callback function to handle message posted to this user content's message port.
--
-- Parameters:
--  * fn - The function which should receive messages posted to this user content's message port.  Specify an explicit nil to disable the callback.  The function should take one argument which will be the message posted and any returned value will be ignored.
--
-- Returns:
--  * the usercontentControllerObject
--
-- Notes:
--  * Within your (injected or served) JavaScript, you can post messages via the message port created with the constructor like this:
--
--      try {
--          webkit.messageHandlers.*name*>.postMessage(*message-object*);
--      } catch(err) {
--          console.log('The controller does not exist yet');
--      }
--
--  * Where *name* matches the name specified in the constructor and *message-object* is the object to post to the function.  This object can be a number, string, date, array, dictionary(table), or nil.
function M:setCallback(fn) end

-- Get a table containing all of the currently defined injection scripts for this user content controller
--
-- Parameters:
--  * None
--
-- Returns:
--  * An array of injected user scripts.  Each entry in the array will be a table containing the following keys:
--    * source        - the javascript which is injected
--    * mainFrame     - a boolean value which indicates whether this script is only injected for the main webview frame (true) or for all frames within the webview (false)
--    * injectionTime - a string which indicates whether the script is injected at "documentStart" or "documentEnd".
--
-- Notes:
--  * Because the WKUserContentController class only allows for removing all scripts, you can use this method to generate a list of all scripts, modify it, and then use it in a loop to reapply the scripts if you need to remove just a few scripts.
function M:userScripts() end

