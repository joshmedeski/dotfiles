--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Move/resize windows within a grid
--
-- The grid partitions your screens for the purposes of window management. The default layout of the grid is 3 columns by 3 rows.
-- You can specify different grid layouts for different screens and/or screen resolutions.
--
-- Windows that are aligned with the grid have their location and size described as a `cell`. Each cell is an `hs.geometry` rect with these fields:
--  * x - The column of the left edge of the window
--  * y - The row of the top edge of the window
--  * w - The number of columns the window occupies
--  * h - The number of rows the window occupies
--
-- For a grid of 3x3:
--  * a cell `'0,0 1x1'` will be in the upper-left corner
--  * a cell `'2,0 1x1'` will be in the upper-right corner
--  * and so on...
--
-- Additionally, a modal keyboard driven interface for interactive resizing is provided via `hs.grid.show()`;
-- The grid will be overlaid on the focused or frontmost window's screen with keyboard hints.
-- To resize/move the window, you can select the corner cells of the desired position.
-- For a move-only, you can select a cell and confirm with 'return'. The selected cell will become the new upper-left of the window.
-- You can also use the arrow keys to move the window onto adjacent screens, and the tab/shift-tab keys to cycle to the next/previous window.
-- Once you selected a cell, you can use the arrow keys to navigate through the grid. In this case, the grid will highlight the selected cells.
-- After highlighting enough cells, press enter to move/resize the window to the highlighted area.
---@class hs.grid
local M = {}
hs.grid = M

-- Calls a user specified function to adjust a window's cell
--
-- Parameters:
--  * fn - a function that accepts a cell object as its only argument. The function should modify it as needed and return nothing
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.adjustWindow(fn, window, ...) end

-- Gets the cell describing a window
--
-- Parameters:
--  * an `hs.window` object to get the cell of
--
-- Returns:
--  * a cell object (i.e. an `hs.geometry` rect), or nil if an error occurred
function M.get(win, ...) end

-- Gets the `hs.geometry` rect for a cell on a particular screen
--
-- Parameters:
--  * cell - a cell object, i.e. an `hs.geometry` rect or argument to construct one
--  * screen - an `hs.screen` object or argument to `hs.screen.find()` where the cell is located
--
-- Returns:
--  * the `hs.geometry` rect for a cell on a particular screen or nil if the screen isn't found
function M.getCell(cell, screen, ...) end

-- Gets the defined grid size for a given screen or screen resolution
--
-- Parameters:
--  * screen - an `hs.screen` object, or a valid argument to `hs.screen.find()`, indicating the screen to get the grid of;
--    if omitted or nil, gets the default grid, which is used when no specific grid is found for any given screen/resolution
--
-- Returns:
--   * an `hs.geometry` size object indicating the number of columns and rows in the grid
--
-- Notes:
--   * if a grid was not set for the specified screen or geometry, the default grid will be returned
--
-- Usage:
-- local mygrid = hs.grid.getGrid('1920x1080') -- gets the defined grid for all screens with a 1920x1080 resolution
-- local defgrid=hs.grid.getGrid() defgrid.w=defgrid.w+2 -- increases the number of columns in the default grid by 2
function M.getGrid(screen, ...) end

-- Gets the defined grid frame for a given screen or screen resolution.
--
-- Parameters:
--  * screen - an `hs.screen` object, or a valid argument to `hs.screen.find()`, indicating the screen to get the grid frame of
--
-- Returns:
--   * an `hs.geometry` rect object indicating the frame used by the grid for the given screen; if no custom frame
--     was given via `hs.grid.setGrid()`, returns the screen's frame
---@return hs.geometry
function M.getGridFrame(screen, ...) end

-- Hides the grid, if visible, and exits the modal resizing mode.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * Call this function if you need to make sure the modal is exited without waiting for the user to press `esc`.
--  * If an exit callback was provided when invoking the modal interface, calling `.hide()` will call it
function M.hide() end

-- A bidimensional array (table of tables of strings) holding the keyboard hints (as per `hs.keycodes.map`) to be used for the interactive resizing interface.
-- Change this if you don't use a QWERTY layout; you need to provide 5 valid rows of hints (even if you're not going to use all 5 rows)
--
-- Default `HINTS` is an array to 5 rows and 10 columns.
--
-- Notes:
--  * `hs.inspect(hs.grid.HINTS)` from the console will show you how the table is built
--  * `hs.grid.show()`
--     When displaying interactive grid, if gird dimensions (`hs.grid.setGrid()`) are greater than `HINTS` dimensions,
--     then Hammerspoon merges few cells such that interactive grid dimensions do not exceed `HINTS` dimensions.
--     This is done to make sure interactive grid cells do not run out of hints. The interactive grid ends up with
--     cells of varying height and width.
--     The actual grid is not affected. If you use API methods like `hs.grid.pushWindowDown()`, you will not face this
--     issue at all.
--     If you have a grid of higher dimensions and require an interactive gird that accurately models underlying grid
--     then set `HINTS` variable to a table that has same dimensions as your grid.
--     Following is an example of grid that has 16 columns
--
-- ```
-- hs.grid.setGrid('16x4')
-- hs.grid.HINTS={
--     {'f1', 'f2' , 'f3' , 'f4' , 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12', 'f13', 'f14', 'f15', 'f16'},
--     {'1' , 'f11', 'f15', 'f19', 'f3', '=' , ']' , '2' , '3' , '4'  , '5'  , '6'  , '7'  , '8'  , '9'  , '0'  },
--     {'Q' , 'f12', 'f16', 'f20', 'f4', '-' , '[' , 'W' , 'E' , 'R'  , 'T'  , 'Y'  , 'U'  , 'I'  , 'O'  , 'P'  },
--     {'A' , 'f13', 'f17', 'f1' , 'f5', 'f7', '\\', 'S' , 'D' , 'F'  , 'G'  , 'H'  , 'J'  , 'K'  , 'L'  , ','  },
--     {'X' , 'f14', 'f18', 'f2' , 'f6', 'f8', ';' , '/' , '.' , 'Z'  , 'X'  , 'C'  , 'V'  , 'B'  , 'N'  , 'M'  }
-- }
-- ```
-- 
M.HINTS = nil

-- Moves and resizes a window to fill the entire grid
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.maximizeWindow(window, ...) end

-- Moves a window one grid cell down the screen, or onto the adjacent screen's grid when necessary
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.pushWindowDown(window, ...) end

-- Moves a window one grid cell to the left, or onto the adjacent screen's grid when necessary
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.pushWindowLeft(window, ...) end

-- Moves a window one cell to the right, or onto the adjacent screen's grid when necessary
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.pushWindowRight(window, ...) end

-- Moves a window one grid cell up the screen, or onto the adjacent screen's grid when necessary
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.pushWindowUp(window, ...) end

-- Resizes a window so its bottom edge moves one grid cell higher
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.resizeWindowShorter(window, ...) end

-- Resizes a window so its bottom edge moves one grid cell lower
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
--
-- Notes:
--  * if the window hits the bottom edge of the screen and is asked to become taller, its top edge will shift further up
---@return hs.grid
function M.resizeWindowTaller(window, ...) end

-- Resizes a window to be one cell thinner
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.resizeWindowThinner(window, ...) end

-- Resizes a window to be one cell wider
--
-- Parameters:
--  * window - an `hs.window` object to act on; if omitted, the focused or frontmost window will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
--
-- Notes:
--  * if the window hits the right edge of the screen and is asked to become wider, its left edge will shift further left
---@return hs.grid
function M.resizeWindowWider(window, ...) end

-- Sets the cell for a window on a particular screen
--
-- Parameters:
--  * win - an `hs.window` object representing the window to operate on
--  * cell - a cell object, i.e. an `hs.geometry` rect or argument to construct one, to apply to the window
--  * screen - (optional) an `hs.screen` object or argument to `hs.screen.find()` representing the screen to place the window on; if omitted
--    the window's current screen will be used
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.set(win, cell, screen, ...) end

-- Sets the grid size for a given screen or screen resolution
--
-- Parameters:
--  * grid - an `hs.geometry` size, or argument to construct one, indicating the number of columns and rows for the grid
--  * screen - an `hs.screen` object, or a valid argument to `hs.screen.find()`, indicating the screen(s) to apply the grid to;
--    if omitted or nil, sets the default grid, which is used when no specific grid is found for any given screen/resolution
--  * frame - an `hs.geometry` rect object indicating the frame that the grid will occupy for the given screen;
--    if omitted or nil, the screen's `:frame()` will be used; use this argument if you want e.g. to leave
--    a strip of the desktop unoccluded when using GeekTool or similar. The `screen` argument *must* be non-nil when setting a
--    custom grid frame.
--
-- Returns:
--  * the `hs.grid` module for method chaining
--
-- Examples:
--  * hs.grid.setGrid('5x3','Color LCD') -- sets the grid to 5x3 for any screen named "Color LCD"
--  * hs.grid.setGrid('8x5','1920x1080') -- sets the grid to 8x5 for all screens with a 1920x1080 resolution
--  * hs.grid.setGrid'4x4' -- sets the default grid to 4x4
---@return hs.grid
function M.setGrid(grid, screen, frame, ...) end

-- Sets the margins between windows
--
-- Parameters:
--  * margins - an `hs.geometry` point or size, or argument to construct one, indicating the desired margins between windows in screen points
--
-- Returns:
--   * the `hs.grid` module for method chaining
---@return hs.grid
function M.setMargins(margins, ...) end

-- Shows the grid and starts the modal interactive resizing process for the focused or frontmost window.
--
-- Parameters:
--  * exitedCallback - (optional) a function that will be called after the user dismisses the modal interface
--  * multipleWindows - (optional) if `true`, the resizing grid won't automatically go away after selecting the desired cells for the frontmost window; instead, it'll switch to the next window
--
-- Returns:
--  * None
--
-- Notes:
--  * In most cases this function should be invoked via `hs.hotkey.bind` with some keyboard shortcut.
--  * In the modal interface, press the arrow keys to jump to adjacent screens; spacebar to maximize/unmaximize; esc to quit without any effect
--  * Pressing `tab` or `shift-tab` in the modal interface will cycle to the next or previous window; if `multipleWindows`
--    is false or omitted, the first press will just enable the multiple windows behaviour
--  * The keyboard hints assume a QWERTY layout; if you use a different layout, change `hs.grid.HINTS` accordingly
--  * If grid dimensions are greater than 10x10 then you may have to change `hs.grid.HINTS` depending on your
--    requirements. See note in `HINTS`.
function M.show(exitedCallback, multipleWindows, ...) end

-- Snaps a window into alignment with the nearest grid lines
--
-- Parameters:
--  * win - an `hs.window` object to snap
--
-- Returns:
--  * the `hs.grid` module for method chaining
---@return hs.grid
function M.snap(win, ...) end

-- Toggles the grid and modal resizing mode - see `hs.grid.show()` and `hs.grid.hide()`
--
-- Parameters:
--  * exitedCallback - (optional) a function that will be called after the user dismisses the modal interface
--  * multipleWindows - (optional) if `true`, the resizing grid won't automatically go away after selecting the desired cells for the frontmost window; instead, it'll switch to the next window
--
-- Returns:
--  * None
function M.toggleShow(exitedCallback, multipleWindows, ...) end

-- Allows customization of the modal resizing grid user interface
--
-- This table contains variables that you can change to customize the look of the modal resizing grid.
-- The default values are shown in the right hand side of the assignments below.
--
-- To represent color values, you can use:
--  * a table {red=redN, green=greenN, blue=blueN, alpha=alphaN}
--  * a table {redN,greenN,blueN[,alphaN]} - if omitted alphaN defaults to 1.0
-- where redN, greenN etc. are the desired value for the color component between 0.0 and 1.0
--
-- The following variables must be color values:
--  * `hs.grid.ui.textColor = {1,1,1}`
--  * `hs.grid.ui.cellColor = {0,0,0,0.25}`
--  * `hs.grid.ui.cellStrokeColor = {0,0,0}`
--  * `hs.grid.ui.selectedColor = {0.2,0.7,0,0.4}` -- for the first selected cell during a modal resize
--  * `hs.grid.ui.highlightColor = {0.8,0.8,0,0.5}` -- to highlight the frontmost window behind the grid
--  * `hs.grid.ui.highlightStrokeColor = {0.8,0.8,0,1}`
--  * `hs.grid.ui.cyclingHighlightColor = {0,0.8,0.8,0.5}` -- to highlight the window to be resized, when cycling among windows
--  * `hs.grid.ui.cyclingHighlightStrokeColor = {0,0.8,0.8,1}`
--
-- The following variables must be numbers (in screen points):
--  * `hs.grid.ui.textSize = 200`
--  * `hs.grid.ui.cellStrokeWidth = 5`
--  * `hs.grid.ui.highlightStrokeWidth = 30`
--
-- The following variables must be strings:
--  * `hs.grid.ui.fontName = 'Lucida Grande'`
--
-- The following variables must be booleans:
--  * `hs.grid.ui.showExtraKeys = true` -- show non-grid keybindings in the center of the grid
M.ui = nil

