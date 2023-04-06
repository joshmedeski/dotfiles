--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Create and manipulate toolbars which can be attached to the Hammerspoon console or hs.webview objects.
--
-- Toolbars are attached to titled windows and provide buttons which can be used to perform various actions within the application. Hammerspoon can use this module to add toolbars to the console or `hs.webview` objects which have a title bar (see `hs.webview.windowMasks` and `hs.webview:windowStyle`). Toolbars are identified by a unique identifier which is used by OS X to identify information which can be auto saved in the application's user defaults to reflect changes the user has made to the toolbar button order or active button list (this requires setting [hs.webview.toolbar:autosaves](#autosaves) and [hs.webview.toolbar:canCustomize](#canCustomize) both to true).
--
-- Multiple copies of the same toolbar can be made with the [hs.webview.toolbar:copy](#copy) method so that multiple webview windows use the same toolbar, for example. If the user customizes a copied toolbar, changes to the active buttons or their order will be reflected in all copies of the toolbar.
--
-- Example:
-- ~~~lua
-- t = require("hs.webview.toolbar")
-- a = t.new("myConsole", {
--         { id = "select1", selectable = true, image = hs.image.imageFromName("NSStatusAvailable") },
--         { id = "NSToolbarSpaceItem" },
--         { id = "select2", selectable = true, image = hs.image.imageFromName("NSStatusUnavailable") },
--         { id = "notShown", default = false, image = hs.image.imageFromName("NSBonjour") },
--         { id = "NSToolbarFlexibleSpaceItem" },
--         { id = "navGroup", label = "Navigation", groupMembers = { "navLeft", "navRight" }},
--         { id = "navLeft", image = hs.image.imageFromName("NSGoLeftTemplate"), allowedAlone = false },
--         { id = "navRight", image = hs.image.imageFromName("NSGoRightTemplate"), allowedAlone = false },
--         { id = "NSToolbarFlexibleSpaceItem" },
--         { id = "cust", label = "customize", fn = function(t, w, i) t:customizePanel() end, image = hs.image.imageFromName("NSAdvanced") }
--     }):canCustomize(true)
--       :autosaves(true)
--       :selectedItem("select2")
--       :setCallback(function(...)
--                         print("a", inspect(table.pack(...)))
--                    end)
--
-- t.attachToolbar(a)
-- ~~~
--
-- Notes:
--  * This module is supported in OS X versions prior to 10.10 (for the Hammerspoon console only), even though its parent `hs.webview` is not. To load this module directly, use `require("hs.webview.toolbar")` instead of relying on module auto-loading.
--  * Toolbar items are rendered in the order they are supplied, although if the toolbar is marked as customizable, the user may have changed the order.
---@class hs.webview.toolbar
local M = {}
hs.webview.toolbar = M

-- Add one or more toolbar items to the toolbar
--
-- Parameters:
--  * `toolbarTable` - a table describing a single toolbar item, or an array of tables, each describing a separate toolbar item, to be added to the toolbar.
--
-- Returns:
--  * the toolbarObject
--
-- Notes:
-- * Each toolbar item is defined as a table of key-value pairs.  The following list describes the valid keys used when describing a toolbar item for this method, the constructor [hs.webview.toolbar.new](#new), and the [hs.webview.toolbar:modifyItem](#modifyItem) method.  Note that the `id` field is **required** for all three uses.
--   * `id`           - A unique string identifier required for each toolbar item and group.  This key cannot be changed after an item has been created.
--   * `allowedAlone` - a boolean value, default true, specifying whether or not the toolbar item can be added to the toolbar, programmatically or through the customization panel, (true) or whether it can only be added as a member of a group (false).
--   * `default`      - a boolean value, default matching the value of `allowedAlone` for this item, indicating whether or not this toolbar item or group should be displayed in the toolbar by default, unless overridden by user customization or a saved configuration (when such options are enabled).
--   * `enable`       - a boolean value, default true, indicating whether or not the toolbar item is active (and can be clicked on) or inactive and greyed out.  This field is ignored when applied to a toolbar group; apply it to the group members instead.
--   * `fn`           - a callback function, or false to remove, specific to the toolbar item. This property is ignored if assigned to the button group. This function will override the toolbar callback defined with [hs.webview.toolbar:setCallback](#setCallback) for this specific item. The function should expect three (four, if the item is a `searchfield`) arguments and return none.  See [hs.webview.toolbar:setCallback](#setCallback) for information about the callback's arguments.
--   * `groupMembers` - an array (table) of strings specifying the toolbar item ids that are members of this toolbar item group.  If set to false, this field is removed and the item is reset back to being a regular toolbar item.  Note that you cannot change a currently visible toolbar item to or from being a group; it must first be removed from active toolbar with [hs.webview.toolbar:removeItem](#removeItem).
--   * `image`        - an `hs.image` object, or false to remove, specifying the image to use as the toolbar item's icon when icon's are displayed in the toolbar or customization panel. This key is ignored for a toolbar item group, but not for it's individual members.
--   * `label`        - a string label, or false to remove, for the toolbar item or group when text is displayed in the toolbar or in the customization panel. For a toolbar item, the default is the `id` string; for a group, the default is `false`. If a group has a label assigned to it, the group label will be displayed for the group of items it contains. If a group does not have a label, the individual items which make up the group will each display their individual labels.
--   * `priority`     - an integer value used to determine toolbar item order and which items are displayed or put into the overflow menu when the number of items in the toolbar exceed the width of the window in which the toolbar is attached. Some example values are provided in the [hs.webview.toolbar.itemPriorities](#itemPriorities) table. If a toolbar item is in a group, it's priority is ignored and the item group is ordered by the item group's priority.
--   * `searchfield`  - a boolean (default false) specifying whether or not this toolbar item is a search field. If true, the following additional keys are allowed:
--     * `searchHistory`                - an array (table) of strings, specifying previous searches to automatically include in the search field menu, if `searchPredefinedMenuTitle` is not false
--     * `searchHistoryAutosaveName`    - a string specifying the key name to save search history with in the application defaults (accessible through `hs.settings`). If this value is set, search history will be maintained through restarts of Hammerspoon.
--     * `searchHistoryLimit`           - the maximum number of items to store in the search field history.
--     * `searchPredefinedMenuTitle`    - a string or boolean specifying how a predefined list of search field "response" should be included in the search field menu. If this item is `true`, this list of items specified for `searchPredefinedSearches` will be displayed in a submenu with the title "Predefined Searches". If this item is a string, the list of items will be displayed in a submenu with the title specified by this string value. If this item is `false`, then the search field menu will only contain the items specified in `searchPredefinedSearches` and no search history will be included in the menu.
--     * `searchPredefinedSearches`     - an array (table) of strings specifying the items to be listed in the predefined search submenu. If set to false, any existing menu will be removed and the search field menu will be reset to the default.
--     * `searchReleaseFocusOnCallback` - a boolean, default false, specifying whether or not focus leaves the search field text box when the callback is invoked. Setting this to true can be useful if you want subsequent keypresses to be caught by the webview after reacting to the value entered into the search field by the user.
--     * `searchText`                   - a string specifying the text to display in the search field.
--     * `searchWidth`                  - the width of the search field text entry box.
--   * `selectable`   - a boolean value, default false, indicating whether or not this toolbar item is selectable (i.e. highlights, like a selected tab) when clicked on. Only one selectable toolbar item can be highlighted at a time, and you can get or set/reset the selected item with [hs.webview.toolbar:selectedItem](#selectedItem).
--   * `tag`          - an integer value which can be used for own purposes; has no affect on the visual aspect of the item or its behavior.
--   * `tooltip`      - a string label, or false to remove, which is displayed as a tool tip when the user hovers the mouse over the button or button group. If a button is in a group, it's tooltip is ignored in favor of the group tooltip.
function M:addItems(toolbarTable, ...) end

-- Returns an array of all toolbar item identifiers defined for this toolbar.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table as an array of all toolbar item identifiers defined for this toolbar.  See also [hs.webview.toolbar:items](#items) and [hs.webview.toolbar:visibleItems](#visibleItems).
function M:allowedItems() end

-- Get or attach/detach a toolbar to the webview, chooser, or console.
--
-- Parameters:
--  * obj1 - An optional toolbarObject
--  * obj2 - An optional toolbarObject
--   * if no arguments are present, this function returns the current toolbarObject for the Hammerspoon console, or nil if one is not attached.
--   * if one argument is provided and it is a toolbarObject or nil, this function will attach or detach a toolbarObject to/from the Hammerspoon console.
--   * if one argument is provided and it is an hs.webview or hs.chooser object, this function will return the current toolbarObject for the object, or nil if one is not attached.
--   * if two arguments are provided and the first is an hs.webview or hs.chooser object and the second is a toolbarObject or nil, this function will attach or detach a toolbarObject to/from the object.
--
-- Returns:
--  * if the function is used to attach/detach a toolbar, then the first object provided (the target) will be returned ; if this function is used to get the current toolbar object for a webview, chooser, or console, then the toolbarObject or nil will be returned.
--
-- Notes:
--  * This function is not expected to be used directly (though it can be) -- it is added to the `hs.webview` and `hs.chooser` object metatables so that it may be invoked as `hs.webview:attachedToolbar([toolbarObject | nil])`/`hs.chooser:attachedToolbar([toolbarObject | nil])` and to the `hs.console` module so that it may be invoked as `hs.console.toolbar([toolbarObject | nil])`.
--
--  * If the toolbar is currently attached to another window when this function is called, it will be detached from the original window and attached to the new one specified by this function.
function M.attachToolbar(obj1, obj2, ...) end

-- Get or set whether or not the toolbar autosaves changes made to the toolbar.
--
-- Parameters:
--  * an optional boolean value indicating whether or not changes made to the visible toolbar items or their order is automatically saved.
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
--
-- Notes:
--  * If the toolbar is set to autosave, then a user-defaults entry is created in org.hammerspoon.Hammerspoon domain with the key "NSToolbar Configuration XXX" where XXX is the toolbar identifier specified when the toolbar was created.
--  * The information saved for the toolbar consists of the following:
--    * the default item identifiers that are displayed when the toolbar is first created or when the user drags the default set from the customization panel.
--    * the current display mode (icon, text, both)
--    * the current size mode (regular, small)
--    * whether or not the toolbar is currently visible
--    * the currently shown identifiers and their order
-- * Note that the labels, icons, callback functions, etc. are not saved -- these are determined at toolbar creation time, by the [hs.webview.toolbar:addItems](#addItems), or by the [hs.webview.toolbar:modifyItem](#modifyItem) method and can differ between invocations of toolbars with the same identifier and button identifiers.
function M:autosaves(bool, ...) end

-- Get or set whether or not the user is allowed to customize the toolbar with the Customization Panel.
--
-- Parameters:
--  * an optional boolean value indicating whether or not the user is allowed to customize the toolbar.
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
--
-- Notes:
--  * the customization panel can be pulled up by right-clicking on the toolbar or by invoking [hs.webview.toolbar:customizePanel](#customizePanel).
function M:canCustomize(bool, ...) end

-- Returns a copy of the toolbar object.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a copy of the toolbar which can be attached to another window (webview, chooser, or console).
function M:copy() end

-- Opens the toolbar customization panel.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the toolbar object
function M:customizePanel() end

-- Deletes the toolbar, removing it from its window if it is currently attached.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:delete() end

-- Deletes the toolbar item specified completely from the toolbar, removing it first, if the toolbar item is currently active.
--
-- Parameters:
--  * `identifier` - the toolbar item's identifier
--
-- Returns:
--  * the toolbar object
--
-- Notes:
--  * This method completely removes the toolbar item from the toolbar's definition dictionary, thus removing it from active use in the toolbar as well as removing it from the customization panel, if supported.  If you only want to remove a toolbar item from the active toolbar, consider [hs.webview.toolbar:removeItem](#removeItem).
function M:deleteItem(identifier, ...) end

-- Get or set the toolbar's display mode.
--
-- Parameters:
--  * mode - an optional string to set the size of the toolbar to "default", "label", "icon", or "both".
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
function M:displayMode(mode, ...) end

-- The identifier for this toolbar.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The identifier for this toolbar.
function M:identifier() end

-- Insert or move the toolbar item to the index position specified
--
-- Parameters:
--  * id    - the string identifier of the toolbar item
--  * index - the numerical position where the toolbar item should be inserted/moved to.
--
-- Returns:
--  * the toolbar object
--
-- Notes:
--  * the toolbar position must be between 1 and the number of currently active toolbar items.
function M:insertItem(id, index, ...) end

-- Get or set whether or not the toolbar appears in the containing window's titlebar, similar to Safari.
--
-- Parameters:
--  * `state` - an optional boolean specifying whether or not the toolbar should appear in the window's titlebar.
--
-- Returns:
--  * if a parameter is specified, returns the toolbar object, otherwise the current value.
--
-- Notes:
--  * When this value is true, the toolbar, when visible, will appear in the window's title bar similar to the toolbar as seen in applications like Safari.  In this state, the toolbar will set the display of the toolbar items to icons without labels, ignoring changes made with [hs.webview.toolbar:displayMode](#displayMode).
--
-- * This method is only valid when the toolbar is attached to a webview, chooser, or the console.
function M:inTitleBar(state, ...) end

-- Returns a boolean indicating whether or not the toolbar is currently attached to a window.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean indicating whether or not the toolbar is currently attached to a window.
---@return boolean
function M:isAttached() end

-- Indicates whether or not the customization panel is currently open for the toolbar.
--
-- Parameters:
--  * None
--
-- Returns:
--  * true or false indicating whether or not the customization panel is open for the toolbar
---@return boolean
function M:isCustomizing() end

-- Returns a table containing details about the specified toolbar item
--
-- Parameters:
--  * id - a string identifier specifying the toolbar item
--
-- Returns:
--  * a table containing the toolbar item definition
--
-- Notes:
--  * For a list of the most of the possible toolbar item attribute keys, see [hs.webview.toolbar:addItems](#addItems).
--  * The table will also include `privateCallback` which will be a boolean indicating whether or not this toolbar item has a private callback function assigned (true) or uses the toolbar's general callback function (false).
--  * The returned table may also contain the following keys, if the item is currently assigned to a toolbar:
--    * `toolbar`  - the toolbar object the item belongs to
--    * `subItems` - if the toolbar item is actually a group, this will contain a table with basic information about the members of the group.  If you wish to get the full details for each sub-member, you may iterate on the identifiers provided in `groupMembers`.
function M:itemDetails(id) end

-- A table containing some pre-defined toolbar item priority values for use when determining item order in the toolbar.
--
-- Defined keys are:
--  * standard - the default priority for an item which does not set or change its priority
--  * low      - a low priority value
--  * high     - a high priority value
--  * user     - the priority of an item which the user has added or moved with the customization panel
M.itemPriorities = nil

-- Returns an array of the toolbar item identifiers currently assigned to the toolbar.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table as an array of the currently active (assigned) toolbar item identifiers.  Toolbar items which are in the overflow menu *are* included in this array.  See also [hs.webview.toolbar:visibleItems](#visibleItems) and [hs.webview.toolbar:allowedItems](#allowedItems).
function M:items() end

-- Modify the toolbar item specified by the "id" key in the table argument.
--
-- Parameters:
--  * a table containing an "id" key and the attributes to change for the toolbar item.
--
-- Returns:
--  * the toolbarObject
--
-- Notes:
--  * You cannot change a toolbar item's `id`
--  * For a list of the possible toolbar item attribute keys, see [hs.webview.toolbar:addItems](#addItems).
function M:modifyItem(table, ...) end

-- Creates a new toolbar for a webview, chooser, or the console.
--
-- Parameters:
--  * toolbarName  - a string specifying the name for this toolbar
--  * toolbarTable - an optional table describing possible items for the toolbar
--
-- Returns:
--  * a toolbarObject
--
-- Notes:
--  * Toolbar names must be unique, but a toolbar may be copied with [hs.webview.toolbar:copy](#copy) if you wish to attach it to multiple windows (webview, chooser, or console).
--  * See [hs.webview.toolbar:addItems](#addItems) for a description of the format for `toolbarTable`
function M.new(toolbarName, toolbarTable, ...) end

-- Get or set whether or not the global callback function is invoked when a toolbar item is added or removed from the toolbar.
--
-- Parameters:
--  * an optional boolean value to enable or disable invoking the global callback for toolbar changes.
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
function M:notifyOnChange(bool, ...) end

-- Remove the toolbar item at the index position specified, or with the specified identifier, if currently present in the toolbar.
--
-- Parameters:
--  * `index` - the numerical position of the toolbar item to remove.
--  * `identifier` - the identifier of the toolbar item to remove, if currently active in the toolbar
--
-- Returns:
--  * the toolbar object
--
-- Notes:
--  * the toolbar position must be between 1 and the number of currently active toolbar items.
function M:removeItem(index_or_identifier, ...) end

-- Returns a table containing the settings which will be saved for the toolbar if [hs.webview.toolbar:autosaves](#autosaves) is true.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the toolbar settings
--
-- Notes:
--  * If the toolbar is set to autosave, then a user-defaults entry is created in org.hammerspoon.Hammerspoon domain with the key "NSToolbar Configuration XXX" where XXX is the toolbar identifier specified when the toolbar was created.
--  * This method is provided if you do not wish for changes to the toolbar to be autosaved for every change, but may wish to save it programmatically under specific conditions.
function M:savedSettings() end

-- Get or set the selected toolbar item
--
-- Parameters:
--  * item - an optional id for the toolbar item to show as selected, or an explicit nil if you wish for no toolbar item to be selected.
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
--
-- Notes:
--  * Only toolbar items which were defined as `selectable` when created with [hs.webview.toolbar.new](#new) can be selected with this method.
function M:selectedItem(item, ...) end

-- Programmatically focus the search field for keyboard input.
--
-- Parameters:
--  * identifier - an optional string specifying the id of the specific search field to focus.  If this parameter is not provided, this method attempts to focus the first active searchfield found in the toolbar
--
-- Returns:
--  * if the searchfield can be found and is currently in the toolbar, returns the toolbarObject; otherwise returns false.
--
-- Notes:
--  * if there is current text in the searchfield, it will be selected so that any subsequent typing by the user will replace the current value in the searchfield.
function M:selectSearchField(identifier, ...) end

-- Get or set whether or not the toolbar shows a separator between the toolbar and the main window contents.
--
-- Parameters:
--  * an optional boolean value to enable or disable the separator.
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
function M:separator(bool, ...) end

-- Sets or removes the global callback function for the toolbar.
--
-- Parameters:
--  * fn - a function to set as the global callback for the toolbar, or nil to remove the global callback. The function should expect three (four, if the item is a `searchfield` or `notifyOnChange` is true) arguments and return none: the toolbar object, "console" or the webview/chooser object the toolbar is attached to, and the toolbar item identifier that was clicked.
--
-- Returns:
--  * the toolbar object.
--
-- Notes:
--  * the global callback function is invoked for a toolbar button item that does not have a specific function assigned directly to it.
--  * if [hs.webview.toolbar:notifyOnChange](#notifyOnChange) is set to true, then this callback function will also be invoked when a toolbar item is added or removed from the toolbar either programmatically with [hs.webview.toolbar:insertItem](#insertItem) and [hs.webview.toolbar:removeItem](#removeItem) or under user control with [hs.webview.toolbar:customizePanel](#customizePanel) and the callback function will receive a string of "add" or "remove" as a fourth argument.
function M:setCallback(fn) end

-- Get or set the toolbar's size.
--
-- Parameters:
--  * size - an optional string to set the size of the toolbar to "default", "regular", or "small".
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
function M:sizeMode(size, ...) end

-- An array containing string identifiers for supported system defined toolbar items.
--
-- Currently supported identifiers include:
--  * NSToolbarSpaceItem         - represents a space approximately the size of a toolbar item
--  * NSToolbarFlexibleSpaceItem - represents a space that stretches to fill available space in the toolbar
M.systemToolbarItems = nil

-- Get or set the toolbar's style.
--
-- Parameters:
--  * style - an optional string to set the style of the toolbar to "automatic", "expanded", "preference", "unified", or "unifiedCompact".
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
--
-- Notes:
--  * This is only available for macOS 11.0+. Will return `nil` if getting on an earlier version of macOS.
--  * `automatic` - A style indicating that the system determines the toolbar’s appearance and location.
--  * `expanded` - A style indicating that the toolbar appears below the window title.
--  * `preference` - A style indicating that the toolbar appears below the window title with toolbar items centered in the toolbar.
--  * `unified` - A style indicating that the toolbar appears next to the window title.
--  * `unifiedCompact` - A style indicating that the toolbar appears next to the window title and with reduced margins to allow more focus on the window’s contents.
function M:toolbarStyle(style, ...) end

-- Checks to see is a toolbar name is already in use
--
-- Parameters:
--  * toolbarName  - a string specifying the name of a toolbar
--
-- Returns:
--  * `true` if the name is unique otherwise `false`
---@return boolean
function M.uniqueName(toolbarName, ...) end

-- Get or set whether or not the toolbar is currently visible in the window it is attached to.
--
-- Parameters:
--  * an optional boolean value to show or hide the toolbar.
--
-- Returns:
--  * if an argument is provided, returns the toolbar object; otherwise returns the current value
function M:visible(bool, ...) end

-- Returns an array of the currently visible toolbar item identifiers.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table as an array of the currently visible toolbar item identifiers.  Toolbar items which are in the overflow menu are *not* included in this array.  See also [hs.webview.toolbar:items](#items) and [hs.webview.toolbar:allowedItems](#allowedItems).
function M:visibleItems() end

