--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- **WARNING**: EXPERIMENTAL MODULE. DO **NOT** USE IN PRODUCTION.
-- This module is *for testing purposes only*. It can undergo breaking API changes or *go away entirely* **at any point and without notice**.
-- (Should you encounter any issues, please feel free to report them on https://github.com/Hammerspoon/hammerspoon/issues
-- or #hammerspoon on irc.libera.chat)
--
-- Tile windows
--
-- The `tileWindows` function in this module is primarily meant for use by `hs.window.layout`; however you can call it manually
-- (e.g. for your custom layout engine).
---@class hs.window.tiling
local M = {}
hs.window.tiling = M

-- Tile (or fit) windows into a rect
--
-- Parameters:
--  * windows - a list of `hs.window` objects indicating the windows to tile or fit
--  * rect - an `hs.geometry` rect (or constructor argument), indicating the desired onscreen region that the windows will be tiled within
--  * desiredAspect - (optional) an `hs.geometry` size (or constructor argument) or a number, indicating the desired optimal aspect ratio (width/height) of the tiled windows; the tiling engine will decide how to subdivide the rect among windows by trying to maintain every window's aspect ratio as close as possible to this; if omitted, defaults to 1 (i.e. try to keep the windows as close to square as possible)
--  * processInOrder - (optional) if `true`, windows will be placed left-to-right and top-to-bottom following the list order in `windows`; if `false` or omitted, the tiling engine will try to maintain the spatial distribution of windows, i.e. (roughly speaking) pick the closest window for each destination "tile"; note that in some cases this isn't possible and the windows might get "reshuffled" around in unexpected ways
--  * preserveRelativeArea - (optional) if `true`, preserve the relative area among windows; that is, if window A is currently twice as large as window B, the same will be true after both windows have been processed and placed into the rect; if `false` or omitted, all windows will have the same area (= area of the rect / number of windows) after processing
--  * animationDuration - (optional) the number of seconds to animate the move/resize operations of the windows; if omitted, defaults to the value of `hs.window.animationDuration`
--
-- Returns:
--   * None
--
-- Notes:
--   * To ensure all windows are placed in a row (side by side), use a very small aspect ratio (for "tall and narrow" windows) like 0.01;
--     similarly, to have all windows in a column, use a very large aspect ratio (for "short and wide") like 100
--   * Hidden and minimized windows will be processed as well: the rect will have "gaps" where the invisible windows
--     would lie, that will get filled as the windows get unhidden/unminimized
function M.tileWindows(windows, rect, desiredAspect, processInOrder, preserveRelativeArea, animationDuration, ...) end

