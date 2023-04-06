--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Create and manage menubar icons
---@class hs.menubar
local M = {}
hs.menubar = M

-- Get or set the autosave name of the menubar. By defining an autosave name, macOS can restore the menubar position after reloads.
--
-- Parameters:
--  * name - An optional string if you want to set the autosave name
--
-- Returns:
--  * Either the menubar item, if its autosave name was changed, or the current value of the autosave name
function M:autosaveName(name, ...) end

-- Removes the menubar item from the menubar and destroys it
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M:delete() end

-- Returns the menubar item frame
--
-- Parameters:
--  * None
--
-- Returns:
--  * an hs.geometry rect describing the menubar item's frame or nil if the menubar item is not currently in the menubar.
--
-- Notes:
--  * This will return a frame even if no icon or title is set
---@return hs.geometry
function M:frame() end

-- Returns the current icon of the menubar item object.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the menubar item icon as an hs.image object, or nil, if there isn't one.
---@return hs.image
function M:icon() end

-- Get or set the position of a menubar image relative to its text title
--
-- Parameters:
--  * position - Either one of the values in `hs.menubar.imagePositions` which will be set, or nothing to return the current position
--
-- Returns:
--  * Either the menubar item, if its image position was changed, or the current value of the image position
function M:imagePosition(position, ...) end

-- Pre-defined list of image positions for a menubar item
--
-- The constants defined are as follows:
--  * none          - don't show the image
--  * imageOnly     - only show the image, not the title
--  * imageLeading  - show the image before the title
--  * imageTrailing - show the image after the title
--  * imageLeft     - show the image to the left of the title
--  * imageRight    - show the image to the right of the title
--  * imageBelow    - show the image below the title
--  * imageAbove    - show the image above the title
--  * imageOverlaps - show the image on top of the title
---@type table
M.imagePositions = {}

-- Returns a boolean indicating whether or not the specified menu is currently in the OS X menubar.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean indicating whether or not the specified menu is currently in the OS X menubar
---@return boolean
function M:isInMenuBar() end

-- Creates a new menu bar item object and optionally add it to the system menubar
--
-- Parameters:
--  * inMenuBar - an optional parameter which defaults to true.  If it is true, the menubaritem is added to the system menubar, otherwise the menubaritem is hidden.
--  * autosaveName - an optional parameter allowing you to define an autosave name, so that macOS can restore the menubar position between restarts.
--
-- Returns:
--  * menubar item object to use with other API methods, or nil if it could not be created
--
-- Notes:
--  * You should call hs.menubar:setTitle() or hs.menubar:setIcon() after creating the object, otherwise it will be invisible
--
--  * Calling this method with inMenuBar equal to false is equivalent to calling hs.menubar.new():removeFromMenuBar().
--  * A hidden menubaritem can be added to the system menubar by calling hs.menubar:returnToMenuBar() or used as a pop-up menu by calling hs.menubar:popupMenu().
function M.new(inMenuBar, autosaveName, ...) end

-- Display a menubaritem as a pop up menu at the specified screen point.
--
-- Parameters:
--  * point - the location of the upper left corner of the pop-up menu to be displayed.
--  * darkMode - (optional) `true` to force the menubar dark (defaults to your macOS General Appearance settings)
--
-- Returns:
--  * The menubaritem
--
-- Notes:
--  * Items which trigger hs.menubar:setClickCallback() will invoke the callback function, but we cannot control the positioning of any visual elements the function may create -- calling this method on such an object is the equivalent of invoking its callback function directly.
--  * This method is blocking. Hammerspoon will be unable to respond to any other activity while the pop-up menu is being displayed.
--  * `darkMode` uses an undocumented macOS API call, so may break in a future release.
function M:popupMenu(point, darkMode, ...) end

-- Removes a menu from the system menu bar.  The item can still be used as a pop-up menu, unless you also delete it.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the menubaritem
function M:removeFromMenuBar() end

-- Returns a previously removed menu back to the system menu bar.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the menubaritem
function M:returnToMenuBar() end

-- Registers a function to be called when the menubar item is clicked
--
-- Parameters:
--  * `fn` - An optional function to be called when the menubar item is clicked. If this argument is not provided, any existing function will be removed. The function can optionally accept a single argument, which will be a table containing boolean values indicating which keyboard modifiers were held down when the menubar item was clicked; The possible keys are:
--   * cmd
--   * alt
--   * shift
--   * ctrl
--   * fn
--
-- Returns:
--  * the menubaritem
--
-- Notes:
--  * If a menu has been attached to the menubar item, this callback will never be called
--  * Has no affect on the display of a pop-up menu, but changes will be be in effect if hs.menubar:returnToMenuBar() is called on the menubaritem.
function M:setClickCallback(fn) end

-- Sets the image of a menubar item object. The image will be displayed in the system menubar
--
-- Parameters:
--  * imageData - This can one of the following:
--   * An `hs.image` object
--   * A string containing a path to an image file
--   * A string beginning with `ASCII:` which signifies that the rest of the string is interpreted as a special form of ASCII diagram, which will be rendered to an image and used as the icon. See the notes below for information about the special format of ASCII diagram.
--   * nil, indicating that the current image is to be removed
--  * template - An optional boolean value which defaults to true. If it's true, the provided image will be treated as a "template" image, which allows it to automatically support OS X 10.10's Dark Mode. If it's false, the image will be used as is, supporting colour.
--
-- Returns:
--  * the menubaritem if the image was loaded and set, `nil` if it could not be found or loaded
--
-- Notes:
--  * ** API Change **
--    * This method used to return true on success -- this has been changed to return the menubaritem on success to facilitate method chaining.  Since Lua treats any value which is not nil or false as "true", this should only affect code where the return value was actually being compared to true, e.g. `if result == true then...` rather than the (unaffected) `if result then...`.
--
--  * If you set a title as well as an icon, they will both be displayed next to each other
--  * Has no affect on the display of a pop-up menu, but changes will be be in effect if hs.menubar:returnToMenuBar() is called on the menubaritem.
--
--  * Icons should be small, transparent images that roughly match the size of normal menubar icons, otherwise they will look very strange. Note that if you're using an `hs.image` image object as the icon, you can force it to be resized with `hs.image:setSize({w=16,h=16})`
--  * Retina scaling is supported if the image is either scalable (e.g. a PDF produced by Adobe Illustrator) or contain multiple sizes (e.g. a TIFF with small and large images). Images will not automatically do the right thing if you have a @2x version present
--  * Icons are by default specified as "templates", which allows them to automatically support OS X 10.10's Dark Mode, but this also means they cannot be complicated, colour images.
--  * For examples of images that work well, see Hammerspoon.app/Contents/Resources/statusicon.tiff (for a retina-capable multi-image TIFF icon) or [https://github.com/jigish/slate/blob/master/Slate/status.pdf](https://github.com/jigish/slate/blob/master/Slate/status.pdf) (for a scalable vector PDF icon)
--  * For guidelines on the sizing of images, see [http://alastairs-place.net/blog/2013/07/23/nsstatusitem-what-size-should-your-icon-be/](http://alastairs-place.net/blog/2013/07/23/nsstatusitem-what-size-should-your-icon-be/)
function M:setIcon(imageData, template, ...) end

-- Attaches a dropdown menu to the menubar item
--
-- Parameters:
--  * `menuTable`:
--   * If this argument is `nil`: Removes any previously registered menu
--   * If this argument is a table: Sets the menu for this menubar item to the supplied table. The format of the table is documented below
--   * If this argument is a function: The function will be called each time the user clicks on the menubar item and the function should return a table that specifies the menu to be displayed. The table should be of the same format as described below. The function can optionally accept a single argument, which will be a table containing boolean values indicating which keyboard modifiers were held down when the menubar item was clicked; The possible keys are:
--    * cmd
--    * alt
--    * shift
--    * ctrl
--    * fn
--   * Table Format:
-- ```lua
--    {
--        { title = "my menu item", fn = function() print("you clicked my menu item!") end },
--        { title = "-" },
--        { title = "other item", fn = some_function },
--        { title = "disabled item", disabled = true },
--        { title = "checked item", checked = true },
--    }```
--   * The available keys for each menu item are (note that `title` is the only required key -- all other keys are optional):
--    * `title`           - A string or `hs.styledtext` object to be displayed in the menu. If this is the special string `"-"` the item will be rendered as a menu separator.  This key can be set to the empty string (""), but it must be present.
--    * `fn`              - A function to be executed when the menu item is clicked. The function will be called with two arguments. The first argument will be a table containing boolean values indicating which keyboard modifiers were held down when the menubar item was clicked (see `menuTable` parameter for possible keys) and the second is the table representing the item.
--    * `checked`         - A boolean to indicate if the menu item should have a checkmark (by default) next to it or not. Defaults to false.
--    * `state`           - a text value of "on", "off", or "mixed" indicating the menu item state.  "on" and "off" are equivalent to `checked` being true or false respectively, and "mixed" will have a dash (by default) beside it.
--    * `disabled`        - A boolean to indicate if the menu item should be unselectable or not. Defaults to false (i.e. menu items are selectable by default)
--    * `menu`            - a table, in the same format as above, which will be presented as a sub-menu for this menu item.
--     * A menu item that is disabled and has a sub-menu will show the arrow at the right indicating that it has a sub-menu, but the items within the sub-menu will not be available, even if the sub-menu items are not disabled themselves.
--     * A menu item with a sub-menu is also a clickable target, so it can also have an `fn` key.
--    * `image`           - An image to display in the menu to the right of any state image or checkmark and to the left of the menu item title.  This image is not constrained by the size set with [hs.menubar:stateImageSize](#stateImageSize), so you should adjust it with `hs.image:setSize` if your image is extremely large or small.
--    * `tooltip`         - A tool tip to display if you hover the cursor over a menu item for a few seconds.
--    * `shortcut`        - A string containing a single character, which will be used as the keyboard shortcut for the menu item. Note that if you use a capital letter, the Shift key will be required to activate the shortcut.
--    * `indent`          - An integer from 0 to 15 indicating how far to the right a menu item should be indented.  Defaults to 0.
--    * `onStateImage`    - An image to display when `checked` is true or `state` is set to "on".  This image size is constrained to the size set by [hs.menubar:stateImageSize](#stateImageSize).  If this key is not set, a checkmark will be displayed for checked or "on" menu items.
--    * `offStateImage`   - An image to display when `checked` is false or `state` is set to "off".  This image size is constrained to the size set by [hs.menubar:stateImageSize](#stateImageSize).  If this key is not set, no special marking appears next to the menu item.
--    * `mixedStateImage` - An image to display when `state` is set to "mixed".  This image size is constrained to the size set by [hs.menubar:stateImageSize](#stateImageSize).  If this key is not set, a dash will be displayed for menu items with a state of "mixed".
--
-- Returns:
--  * the menubaritem
--
-- Notes:
--  * If you are using the callback function, you should take care not to take too long to generate the menu, as you will block the process and the OS may decide to remove the menubar item
function M:setMenu(menuTable, ...) end

-- Sets the title of a menubar item object. The title will be displayed in the system menubar
--
-- Parameters:
--  * `title` - A string or `hs.styledtext` object to use as the title, or nil to remove the title
--
-- Returns:
--  * the menubar item
--
-- Notes:
--  * If you set an icon as well as a title, they will both be displayed next to each other
--  * Has no affect on the display of a pop-up menu, but changes will be be in effect if hs.menubar:returnToMenuBar() is called on the menubaritem.
function M:setTitle(title, ...) end

-- Sets the tooltip text on a menubar item
--
-- Parameters:
--  * `tooltip` - A string to use as the tooltip
--
-- Returns:
--  * the menubaritem
--
-- Notes:
--  * Has no affect on the display of a pop-up menu, but changes will be be in effect if hs.menubar:returnToMenuBar() is called on the menubaritem.
function M:setTooltip(tooltip, ...) end

-- Get or set the size for state images when the menu is displayed.
--
-- Parameters:
--  * size - an optional table specifying the size for state images displayed when using the `checked` or `state` key in a menu table definition.  Defaults to a size determined by the system menu font point size.  If you specify an explicit nil, the size is reset to this default.
--
-- Returns:
--  * if a parameter is provided, returns the menubar item; otherwise returns the current value.
--
-- Notes:
--  * An image is used rather than a checkmark or dash only when you set them with the `onStateImage`, `offStateImage`, or `mixedStateImage` keys.  If you are not using these keys, then this method will have no visible effect on the menu's rendering.  See  [hs.menubar:setMenu](#setMenu) for more information.
--  * If you are setting the menu contents with a static table, you should invoke this method before invoking [hs.menubar:setMenu](#setMenu), as changes will only go into effect when the table is next converted to a menu structure.
---@return hs.image
function M:stateImageSize(size, ...) end

-- Returns the current title of the menubar item object.
--
-- Parameters:
--  * styled - an optional boolean, defaulting to false, indicating that a styledtextObject representing the text of the menu title should be returned
--
-- Returns:
--  * the menubar item title, or an empty string, if there isn't one.  If `styled` is not set or is false, then a string is returned; otherwise a styledtextObject will be returned.
function M:title(styled, ...) end

