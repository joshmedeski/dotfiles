--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Filter windows by application, title, location on screen and more, and easily subscribe to events on these windows
--
-- Warning: this module is still somewhat experimental.
-- Should you encounter any issues, please feel free to report them on https://github.com/Hammerspoon/hammerspoon/issues
-- or #hammerspoon on irc.libera.chat.
--
-- Windowfilters monitor all windows as they're created, closed, moved etc., and select some (or none) among these windows
-- according to specific filtering rules. These filtering rules are app-specific, i.e. they start off by selecting all windows
-- belonging to a certain application (but you can also define *default* and *override* filters - see `:setAppFilter()`,
-- `:setDefaultFilter()`, `:setOverrideFilter()`) and they can allow or reject windows based on:
--   * visibility, focused and/or fullscreen status
--   * title length or patterns in the title
--   * position on screen (inside or outside a certain region or screen)
--   * accessibility role (standard window, dialog, etc.)
--   * whether they're in the current Mission Control Space or not
--
-- The filtering happens automatically in the background; windowfilters then:
--   * generate a dynamic list of the windows that currently satisfy the filtering rules (see `:getWindows()`)
--   * sanitize and expose all pertinent events on these windows (see `:subscribe()` and the module constants with all the events)
--
-- A *default windowfilter* (not to be confused with the default filter *within* a windowfilter) is provided as convenience;
-- it excludes some known apps and windows that are transient in nature, therefore unlikely to be "interesting" for e.g. window management.
-- `hs.window.filter.new()` (with no arguments) returns a copy of the default windowfilter that you can further tailor
-- to your needs - see `hs.window.filter.default` and `hs.window.filter.new()` for more information.
--
-- Usage examples:
-- ```
-- local wf=hs.window.filter
--
-- -- alter the default windowfilter
-- wf.default:setAppFilter('My IDE',{allowTitles=1}) -- ignore no-title windows (e.g. transient autocomplete suggestions) in My IDE
--
-- -- set the exact scope of what you're interested in - see hs.window.filter:setAppFilter()
-- wf_terminal = wf.new{'Terminal','iTerm2'} -- all visible terminal windows
-- wf_timewaster = wf.new(false):setAppFilter('Safari',{allowTitles='reddit'}) -- any Safari windows with "reddit" anywhere in the title
-- wf_leftscreen = wf.new{override={visible=true,fullscreen=false,allowScreens='-1,0',currentSpace=true}}
-- -- all visible and non-fullscreen windows that are on the screen to the left of the primary screen in the current Space
-- wf_editors_righthalf = wf.new{'TextEdit','Sublime Text','BBEdit'}:setRegions(hs.screen.primaryScreen():fromUnitRect'0.5,0/1,1')
-- -- text editor windows that are on the right half of the primary screen
-- wf_bigwindows = wf.new(function(w)return w:frame().area>3000000 end) -- only very large windows
-- wf_notif = wf.new{['Notification Center']={allowRoles='AXNotificationCenterAlert'}} -- notification center alerts
--
-- -- subscribe to events
-- wf_terminal:subscribe(wf.windowFocused,some_fn) -- run a function whenever a terminal window is focused
-- wf_timewaster:subscribe(wf.hasWindow,startAnnoyingMe):subscribe(wf.hasNoWindows,stopAnnoyingMe) -- fight procrastination :)
-- ```
---@class hs.window.filter
local M = {}
hs.window.filter = M

-- Sets the windowfilter to allow all visible windows belonging to a specific app
--
-- Parameters:
--  * appname - app name as per `hs.application:name()`
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * this is just a convenience wrapper for `windowfilter:setAppFilter(appname,{visible=true})`
---@return hs.window.filter
function M:allowApp(appname, ...) end

-- A table for window roles (as per `hs.window:subrole()`) that are allowed by default.
--
-- Set the desired window roles as *keys* in this table, like this: `hs.window.filter.allowedWindowRoles = {AXStandardWindow=true,AXDialog=true}`
--
-- Notes:
--  * You can have fine grained control of allowed window roles via the `setAppFilter`, `setDefaultFilter`, `setOverrideFilter` methods.
--  * If you know what you're doing you can override the allowed window roles globally by changing this variable, but this is discouraged.
M.allowedWindowRoles = nil

-- Returns a copy of an hs.window.filter object that you can further restrict or expand
--
-- Parameters:
--  * windowfilter - an `hs.window.filter` object to copy
--  * logname - (optional) name of the `hs.logger` instance for the new windowfilter; if omitted, the class logger will be used
--  * loglevel - (optional) log level for the `hs.logger` instance for the new windowfilter
--
-- Returns:
--  * An `hs.window.filter` object
---@return hs.window.filter
function M.copy(windowfilter, logname, loglevel, ...) end

-- The default windowfilter; it filters apps whose windows are transient in nature so that you're unlikely (and often
-- unable) to do anything with them, such as launchers, menulets, preference pane apps, screensavers, etc. It also
-- filters nonstandard and invisible windows.
--
-- Notes:
--  * While you can customize the default windowfilter, it's usually advisable to make your customizations on a local copy via `mywf=hs.window.filter.new()`;
--    the default windowfilter can potentially be used in several Hammerspoon modules and changing it might have unintended consequences.
--    Common customizations:
--    * to exclude fullscreen windows: `nofs_wf=hs.window.filter.new():setOverrideFilter{fullscreen=false}`
--    * to include invisible windows: `inv_wf=windowfilter.new():setDefaultFilter{}`
--  * If you still want to alter the default windowfilter:
--    * you should probably apply your customizations at the top of your `init.lua`, or at any rate before instantiating any other windowfilter; this
--      way copies created via `hs.window.filter.new(nil,...)` will inherit your modifications
--    * to list the known exclusions: `hs.inspect(hs.window.filter.default:getFilters())` from the console
--    * to add an exclusion: `hs.window.filter.default:rejectApp'Cool New Launcher'`
--    * to add an app-specific rule: `hs.window.filter.default:setAppFilter('My IDE',1)`; ignore tooltips/code completion (empty title) in My IDE
--    * to remove an exclusion (e.g. if you want to have access to Spotlight windows): `hs.window.filter.default:allowApp'Spotlight'`;
--      for specialized uses you can make a specific windowfilter with `myfilter=hs.window.filter.new'Spotlight'`
M.default = nil

-- A copy of the default windowfilter (see `hs.window.filter.default`) that only allows windows in the current
-- Mission Control Space
--
-- Notes:
--  * This windowfilter will inherit customizations to the default windowfilter if they're performed *before* referencing this
M.defaultCurrentSpace = nil

-- Convenience function to focus the nearest window to the east
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.filter.defaultCurrentSpace:focusWindowEast(nil,nil,true)`
function M.focusEast() end

-- Convenience function to focus the nearest window to the north
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.filter.defaultCurrentSpace:focusWindowNorth(nil,nil,true)`
function M.focusNorth() end

-- Convenience function to focus the nearest window to the south
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.filter.defaultCurrentSpace:focusWindowSouth(nil,nil,true)`
function M.focusSouth() end

-- Convenience function to focus the nearest window to the west
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.filter.defaultCurrentSpace:focusWindowWest(nil,nil,true)`
function M.focusWest() end

-- Focuses the nearest window to the east of a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window in this windowfilter
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    eastward axis
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.focusWindowEast(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call
function M:focusWindowEast(window, frontmost, strict, ...) end

-- Focuses the nearest window to the south of a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window in this windowfilter
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    southward axis
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.focusWindowNorth(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call
function M:focusWindowNorth(window, frontmost, strict, ...) end

-- Focuses the nearest window to the north of a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window in this windowfilter
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    northward axis
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.focusWindowSouth(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call
function M:focusWindowSouth(window, frontmost, strict, ...) end

-- Focuses the nearest window to the west of a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true focuses the nearest window that isn't occluded by any other window in this windowfilter
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the westward axis
--
-- Returns:
--  * None
--
-- Notes:
--  * This is a convenience wrapper that performs `hs.window.focusWindowWest(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call
function M:focusWindowWest(window, frontmost, strict, ...) end

-- Tells all windowfilters whether to refresh all windows when the user switches to a different Mission Control Space.
--
-- Due to OS X limitations Hammerspoon cannot directly query for windows in Spaces other than the current one;
-- therefore when a windowfilter is initially instantiated, it doesn't know about many of these windows.
--
-- If this variable is set to `true`, windowfilters will re-query applications for all their windows whenever a Space change
-- by the user is detected, therefore any existing windows in that Space that were not yet being tracked will become known at that point;
-- if `false` (the default) this won't happen, but the windowfilters will *eventually* learn about these windows
-- anyway, as soon as they're interacted with.
--
-- If you need your windowfilters to become aware of windows across all Spaces as soon as possible, you can set this to `true`,
-- but you'll incur a modest performance penalty on every Space change. If possible, use the `hs.window.filter.switchedToSpace()`
-- callback instead.
--
-- Notes:
--  * If you defined one or more Spaces-aware windowfilters (i.e. when the `currentSpace` field of a filter is present), windows need refreshing at every space change anyway, so this variable is ignored
M.forceRefreshOnSpaceChange = nil

-- Return a table with all the filtering rules defined for this windowfilter
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the filtering rules of this windowfilter; you can pass this table (optionally
--  after performing valid manipulations) to `hs.window.filter:setFilters()` and `hs.window.filter.new()`
function M:getFilters() end

-- Gets the current windows allowed by this windowfilter
--
-- Parameters:
--  * sortOrder - (optional) one of the `hs.window.filter.sortBy...` constants to determine the sort order
--    of the returned list; if omitted, uses the windowfilter's sort order as per `hs.window.filter:setSortOrder()`
--   (defaults to `sortByFocusedLast`)
--
-- Returns:
--  * a list of `hs.window` objects
---@return hs.window[]
function M:getWindows(sortOrder, ...) end

-- Pseudo-event for `hs.window.filter:subscribe()`: the windowfilter now rejects all windows
--
-- Notes:
--  * callbacks for this event will receive (as the first argument) the last window that was allowed (and is now rejected)
--  * this pseudo-event won't trigger again until after the windowfilter allows at least one window
--  * this pseudo-event will be emitted *after* the *actual* event(s) (e.g. `windowDestroyed`) that caused the window to be rejected
M.hasNoWindows = nil

-- Pseudo-event for `hs.window.filter:subscribe()`: the windowfilter now allows one window
--
-- Notes:
--  * callbacks for this event will receive (as the first argument) the window that is now allowed
--  * this pseudo-event won't trigger again until after the windowfilter reverts to rejecting all windows
--  * this pseudo-event will be emitted *after* the *actual* event(s) (e.g. `windowCreated`) that caused a window to be allowed
M.hasWindow = nil

-- A table of application names (as per `hs.application:name()`) that are always ignored by this module.
-- These are apps with no windows or any visible GUI, such as system services, background daemons and "helper" apps.
--
-- You can add an app to this table with `hs.window.filter.ignoreAlways['Background App Title'] = true`
--
-- Notes:
--  * As the name implies, even the empty, "allow all" windowfilter will ignore these apps.
--  * You don't *need* to keep this table up to date, since non GUI apps will simply never show up anywhere; this table is just used as a "root" filter to gain a (very small) performance improvement.
M.ignoreAlways = nil

-- Checks if an app is allowed by the windowfilter
--
-- Parameters:
--  * appname - app name as per `hs.application:name()`
--
-- Returns:
--  * `false` if the app is rejected by the windowfilter; `true` otherwise
---@return boolean
function M:isAppAllowed(appname, ...) end

-- Checks whether an app is a known non-GUI app, as per `hs.window.filter.ignoreAlways`
--
-- Parameters:
--  * appname - name of the app to check as per `hs.application:name()`
--
-- Returns:
--  * `false` if the app is a known non-GUI (or not accessible) app; `true` otherwise
---@return boolean
function M.isGuiApp(appname, ...) end

-- Checks if a window is allowed by the windowfilter
--
-- Parameters:
--  * window - an `hs.window` object to check
--
-- Returns:
--  * `true` if the window is allowed by the windowfilter, `false` otherwise; `nil` if an invalid object was passed
---@return boolean
function M:isWindowAllowed(window, ...) end

-- Creates a new hs.window.filter instance
--
-- Parameters:
--  * fn
--    * if `nil`, returns a copy of the default windowfilter, including any customizations you might have applied to it
--      so far; you can then further restrict or expand it
--    * if `true`, returns an empty windowfilter that allows every window
--    * if `false`, returns a windowfilter with a default rule to reject every window
--    * if a string or table of strings, returns a windowfilter that only allows visible windows of the specified apps
--      as per `hs.application:name()`
--    * if a table, you can fully define a windowfilter without having to call any methods after construction; the
--      table must be structured as per `hs.window.filter:setFilters()`; if not specified in the table, the
--      default filter in the new windowfilter will reject all windows
--    * otherwise it must be a function that accepts an `hs.window` object and returns `true` if the window is allowed
--      or `false` otherwise; this way you can define a fully custom windowfilter
--  * logname - (optional) name of the `hs.logger` instance for the new windowfilter; if omitted, the class logger will be used
--  * loglevel - (optional) log level for the `hs.logger` instance for the new windowfilter
--
-- Returns:
--  * a new windowfilter instance
---@return hs.window.filter
function M.new(fn, logname, loglevel, ...) end

-- Stops the windowfilter event subscriptions; no more event callbacks will be triggered, but the subscriptions remain intact for a subsequent call to `hs.window.filter:resume()`
--
-- Parameters:
--  * None
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
---@return hs.window.filter
function M:pause() end

-- Sets the windowfilter to outright reject any windows belonging to a specific app
--
-- Parameters:
--  * appname - app name as per `hs.application:name()`
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * this is just a convenience wrapper for `windowfilter:setAppFilter(appname,false)`
---@return hs.window.filter
function M:rejectApp(appname, ...) end

-- Resumes the windowfilter event subscriptions
--
-- Parameters:
--  * None
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
---@return hs.window.filter
function M:resume() end

-- Sets the detailed filtering rules for the windows of a specific app
--
-- Parameters:
--  * appname - app name as per `hs.application:name()`
--  * filter - if `false`, reject the app; if `true`, `nil`, or omitted, allow all visible windows (in any Space) for the app; otherwise it must be a table describing the filtering rules for the app, via the following fields:
--    * visible - if `true`, only allow visible windows (in any Space); if `false`, reject visible windows; if omitted, this rule is ignored
--    * currentSpace - if `true`, only allow windows in the current Mission Control Space (minimized and hidden windows are included, as they're considered to belong to all Spaces); if `false`, reject windows in the current Space (including all minimized and hidden windows); if omitted, this rule is ignored
--    * fullscreen - if `true`, only allow fullscreen windows; if `false`, reject fullscreen windows; if omitted, this rule is ignored
--    * hasTitlebar - if `true`, only allow windows with titlebar; if `false`, reject window with titlebar; if omitted, this rule is ignored
--    * focused - if `true`, only allow a window while focused; if `false`, reject the focused window; if omitted, this rule is ignored
--    * activeApplication - only allow any of this app's windows while it is (if `true`) or it's not (if `false`) the active application; if omitted, this rule is ignored
--    * allowTitles
--      * if a number, only allow windows whose title is at least as many characters long; e.g. pass `1` to filter windows with an empty title
--      * if a string or table of strings, only allow windows whose title matches (one of) the pattern(s) as per `string.match`
--      * if omitted, this rule is ignored
--    * rejectTitles - if a string or table of strings, reject windows whose titles matches (one of) the pattern(s) as per `string.match`; if omitted, this rule is ignored
--    * allowRegions - an `hs.geometry` rect or constructor argument, or a list of them, designating (a) screen "region(s)" in absolute coordinates: only allow windows that "cover" at least 50% of (one of) the region(s), and/or windows that have at least 50% of their surface inside (one of) the region(s); if omitted, this rule is ignored
--    * rejectRegions - an `hs.geometry` rect or constructor argument, or a list of them, designating (a) screen "region(s)" in absolute coordinates: reject windows that "cover" at least 50% of (one of) the region(s), and/or windows that have at least 50% of their surface inside (one of) the region(s); if omitted, this rule is ignored
--    * allowScreens - a valid argument for `hs.screen.find()`, or a list of them, indicating one (or more) screen(s): only allow windows that (mostly) lie on (one of) the screen(s); if omitted, this rule is ignored
--    * rejectScreens - a valid argument for `hs.screen.find()`, or a list of them, indicating one (or more) screen(s): reject windows that (mostly) lie on (one of) the screen(s); if omitted, this rule is ignored
--    * allowRoles
--      * if a string or table of strings, only allow these window roles as per `hs.window:subrole()`
--      * if the special string `'*'`, this rule is ignored (i.e. all window roles, including empty ones, are allowed)
--      * if omitted, use the default allowed roles (defined in `hs.window.filter.allowedWindowRoles`)
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * Passing `focused=true` in `filter` will (naturally) result in the windowfilter ever allowing 1 window at most
--  * If you want to allow *all* windows for an app, including invisible ones, pass an empty table for `filter`
--  * Spaces-aware windowfilters might experience a (sometimes significant) delay after every Space switch, since (due to OS X limitations) they must re-query for the list of all windows in the current Space every time.
--  * If System Preferences>Mission Control>Displays have separate Spaces is *on*, the *current Space* is defined as the union of all the Spaces that are currently visible
--  * This table explains the effects of different combinations of `visible` and `currentSpace`, showing which windows will be allowed:
-- ```
--              |visible=         nil                      |             true             |     false    |
-- |currentSpace|------------------------------------------|------------------------------|--------------|
-- |     nil    |all                                       |visible in ANY space          |min and hidden|
-- |    true    |visible in CURRENT space+min and hidden   |visible in CURRENT space      |min and hidden|
-- |    false   |visible in OTHER space only+min and hidden|visible in OTHER space only   |none          |
-- ```
---@return hs.window.filter
function M:setAppFilter(appname, filter, ...) end

-- Sets whether the windowfilter should only allow (or reject) windows in the current Mission Control Space
--
-- Parameters:
--  * val - boolean; if `true`, only allow windows in the current Mission Control Space, plus minimized and hidden windows;
--    if `false`, reject them; if `nil`, ignore Mission Control Spaces
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * This is just a convenience wrapper for setting the `currentSpace` field in the `override` filter (other
--    fields will be left untouched); per-app filters will maintain their `currentSpace` field, if present, as is
--  * Spaces-aware windowfilters might experience a (sometimes significant) delay after every Space switch, since
--    (due to OS X limitations) they must re-query for the list of all windows in the current Space every time.
---@return hs.window.filter
function M:setCurrentSpace(val, ...) end

-- Set the default filtering rules to be used for apps without app-specific rules
--
-- Parameters:
--  * filter - see `hs.window.filter:setAppFilter`
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
---@return hs.window.filter
function M:setDefaultFilter(filter, ...) end

-- Sets multiple filtering rules
--
-- Parameters:
--  * filters - table, every element will set an application filter; these elements must:
--    - have a *key* of type string, denoting an application name as per `hs.application:name()`
--    - if the *value* is a boolean, the app will be allowed or rejected accordingly - see `hs.window.filter:allowApp()`
--      and `hs.window.filter:rejectApp()`
--    - if the *value* is a table, it must contain the accept/reject rules for the app *as key/value pairs*; valid keys
--      and values are described in `hs.window.filter:setAppFilter()`
--    - the key can be one of the special strings `"default"` and `"override"`, which will set the default and override
--      filter respectively
--    - the key can be the special string `"sortOrder"`; the value must be one of the `sortBy...` constants as per
--      `hs.window.filter:setSortOrder()`
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * every filter definition in `filters` will overwrite the preexisting one for the relevant application, if present;
--    this also applies to the special default and override filters, if included
---@return hs.window.filter
function M:setFilters(filters, ...) end

-- Set overriding filtering rules that will be applied for all apps before any app-specific rules
--
-- Parameters:
--  * filter - see `hs.window.filter:setAppFilter`
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
---@return hs.window.filter
function M:setOverrideFilter(filter, ...) end

-- Sets the allowed screen regions for this windowfilter
--
-- Parameters:
--  * regions - an `hs.geometry` rect or constructor argument, or a list of them, indicating the allowed region(s) for this windowfilter
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * This is just a convenience wrapper for setting the `allowRegions` field in the `override` filter (other fields will be left untouched); per-app filters will maintain their `allowRegions` and `rejectRegions` fields, if present
---@return hs.window.filter
function M:setRegions(regions, ...) end

-- Sets the allowed screens for this windowfilter
--
-- Parameters:
--  * regions - a valid argument for `hs.screen.find()`, or a list of them, indicating the allowed screen(s) for this windowfilter
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * This is just a convenience wrapper for setting the `allowScreens` field in the `override` filter (other
--    fields will be left untouched); per-app filters will maintain their `allowScreens` and `rejectScreens` fields, if present
---@return hs.window.filter
function M:setScreens(screens, ...) end

-- Sets the sort order for this windowfilter's `:getWindows()` method
--
-- Parameters:
--  * sortOrder - one of the `hs.window.filter.sortBy...` constants
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--   * The default sort order for all windowfilters (that is, until changed by this method) is `hs.window.filter.sortByFocusedLast`
---@return hs.window.filter
function M:setSortOrder(sortOrder, ...) end

-- Sort order for `hs.window.filter:getWindows()`: windows are sorted in order of creation, oldest first (see also `hs.window.filter:setSortOrder()`)
M.sortByCreated = nil

-- Sort order for `hs.window.filter:getWindows()`: windows are sorted in order of creation, newest first (see also `hs.window.filter:setSortOrder()`)
M.sortByCreatedLast = nil

-- Sort order for `hs.window.filter:getWindows()`: windows are sorted in order of focus received, least recently first (see also `hs.window.filter:setSortOrder()`)
M.sortByFocused = nil

-- Sort order for `hs.window.filter:getWindows()`: windows are sorted in order of focus received, most recently first (see also `hs.window.filter:setSortOrder()`)
--
-- Notes:
--   * This is the default sort order for all windowfilters
M.sortByFocusedLast = nil

-- Subscribe to one or more events on the allowed windows
--
-- Parameters:
--  * event - string or list of strings, the event(s) to subscribe to (see the `hs.window.filter` constants); alternatively, this can be a map `{event1=fn1,event2=fn2,...}`: fnN will be subscribed to eventN, and the parameter `fn` will be ignored
--  * fn - function or list of functions, the callback(s) to add for the event(s); each will be passed 3 parameters
--    * a `hs.window` object referring to the event's window
--    * a string containing the application name (`window:application():name()`) for convenience
--    * a string containing the event that caused the callback, i.e. (one of) the event(s) you subscribed to
--  * immediate - (optional) if `true`, also call all the callbacks immediately for windows that satisfy the event(s) criteria
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * Passing lists means that *all* the `fn`s will be called when *any* of the `event`s fires, so it's *not* a shortcut for subscribing distinct callbacks to distinct events; use a map or chained `:subscribe` calls for that.
--  * Use caution with `immediate`: if for example you're subscribing to `hs.window.filter.windowUnfocused`, `fn`(s) will be called for *all* the windows except the currently focused one.
--  * If the windowfilter was paused with `hs.window.filter:pause()`, calling this will resume it.
---@return hs.window.filter
function M:subscribe(event, fn, immediate, ...) end

-- Callback to inform all windowfilters that the user initiated a switch to a (numbered) Mission Control Space.
--
-- Parameters:
--  * space - the Space number the user is switching to
--
-- Returns:
-- * None
--
-- Notes:
--  * Only use this function if "Displays have separate Spaces" and "Automatically rearrange Spaces" are OFF in System Preferences>Mission Control
--  * Calling this function will set `hs.window.filter.forceRefreshOnSpaceChange` to `false`
--  * If you defined one or more Spaces-aware windowfilters (i.e. when the `currentSpace` field of a filter is present), windows need refreshing at every space change anyway, so using this callback will not result in improved performance
--  * See `hs.window.filter.forceRefreshOnSpaceChange` for an overview of Spaces limitations in Hammerspoon. If you often (or always) change Space via the "numbered" Mission Control keyboard shortcuts (by default, `ctrl-1` etc.), you can call this function from your `init.lua` when intercepting these shortcuts; for example:
--  ```
--  hs.hotkey.bind('ctrl','1',nil,function()hs.window.filter.switchedToSpace(1)end)
--  hs.hotkey.bind('ctrl','2',nil,function()hs.window.filter.switchedToSpace(2)end)
--  -- etc.
--  ```
-- * Using this callback results in slightly better performance than setting `forceRefreshOnSpaceChange` to `true`, since already visited Spaces are remembered and no refreshing is necessary when switching back to those.
function M.switchedToSpace(space, ...) end

-- Removes one or more event subscriptions
--
-- Parameters:
--  * event - string or list of strings, the event(s) to unsubscribe; if omitted, `fn`(s) will be unsubscribed from all events;
--    alternatively, this can be a map `{event1=fn1,event2=fn2,...}`: fnN will be unsubscribed from eventN, and the parameter `fn` will be ignored
--  * fn - function or list of functions, the callback(s) to remove; if omitted, all callbacks will be unsubscribed from `event`(s)
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * You must pass at least one of `event` or `fn`
--  * If calling this on the default (or any other shared use) windowfilter, do not pass events, as that would remove
--    *all* the callbacks for the events including ones subscribed elsewhere that you might not be aware of. You should
--    instead keep references to your functions and pass in those.
---@return hs.window.filter
function M:unsubscribe(event, fn, ...) end

-- Removes all event subscriptions
--
-- Parameters:
--  * None
--
-- Returns:
--  * the `hs.window.filter` object for method chaining
--
-- Notes:
--  * You should not use this on the default windowfilter or other shared-use windowfilters
---@return hs.window.filter
function M:unsubscribeAll() end

-- Pseudo-event for `hs.window.filter:subscribe()`: a previously rejected window (or a newly created one) is now allowed
--
-- Notes:
--  * this pseudo-event will be emitted *before* the *actual* event(s) (e.g. `windowCreated`) that caused the window to be allowed
M.windowAllowed = nil

-- Event for `hs.window.filter:subscribe()`: a new window was created
M.windowCreated = nil

-- Event for `hs.window.filter:subscribe()`: a window was destroyed
M.windowDestroyed = nil

-- Event for `hs.window.filter:subscribe()`: a window received focus
M.windowFocused = nil

-- Event for `hs.window.filter:subscribe()`: a window was expanded to fullscreen
M.windowFullscreened = nil

-- Event for `hs.window.filter:subscribe()`: a window was hidden (its app was hidden, e.g. via `cmd-h`)
M.windowHidden = nil

-- Event for `hs.window.filter:subscribe()`: a window is now in the current Mission Control Space, due to
-- a Space switch or because it was hidden or minimized (hidden and minimized windows belong to all Spaces)
M.windowInCurrentSpace = nil

-- Event for `hs.window.filter:subscribe()`: a window was minimized
M.windowMinimized = nil

-- Event for `hs.window.filter:subscribe()`: a window was moved or resized, including toggling fullscreen/maximize
M.windowMoved = nil

-- Event for `hs.window.filter:subscribe()`: a window that used to be in the current Mission Control Space isn't anymore,
-- due to a Space switch or because it was unhidden or unminimized onto another Space
M.windowNotInCurrentSpace = nil

-- Event for `hs.window.filter:subscribe()`: a window is no longer *actually* visible on any screen because it was minimized, closed,
-- its application was hidden (e.g. via cmd-h) or closed, or because it's not in the current Mission Control Space anymore
M.windowNotOnScreen = nil

-- Event for `hs.window.filter:subscribe()`: a window is no longer "visible" (in *any* Mission Control Space, as per `hs.window:isVisible()`)
-- because it was minimized or closed, or its application was hidden (e.g. via `cmd-h`) or closed
M.windowNotVisible = nil

-- Event for `hs.window.filter:subscribe()`: a window became *actually* visible on screen (i.e. it's "visible" as per `hs.window:isVisible()`
-- *and* in the current Mission Control Space) after having been not visible, or when created
M.windowOnScreen = nil

-- Pseudo-event for `hs.window.filter:subscribe()`: a previously allowed window (or a window that's been destroyed) is now rejected
--
-- Notes:
--  * this pseudo-event will be emitted *after* the *actual* event(s) (e.g. `windowDestroyed`) that caused the window to be rejected
M.windowRejected = nil

-- Pseudo-event for `hs.window.filter:subscribe()`: the list of allowed windows (as per `windowfilter:getWindows()`) has changed
--
-- Notes:
--  * callbacks for this event will receive (as the first argument) either a random window among the currently allowed ones,
--    or nil if the windowfilter is rejecting all windows
--  * similarly, the second argument passed to callbacks (window's app name) will be nil if the windowfilter is rejecting all windows
--  * this pseudo-event will be emitted *after* the *actual* event(s) that caused the list of allowed windows to change
M.windowsChanged = nil

-- Gets all visible windows allowed by this windowfilter that lie to the east a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    eastward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned east (i.e. right) of the window, in ascending order of distance
--
-- Notes:
--  * This is a convenience wrapper that returns `hs.window.windowsToEast(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call (or just use
--    `hs.window.filter.defaultCurrentSpace`)
function M:windowsToEast(window, frontmost, strict, ...) end

-- Gets all visible windows allowed by this windowfilter that lie to the north a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    northward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned north (i.e. up) of the window, in ascending order of distance
--
-- Notes:
--  * This is a convenience wrapper that returns `hs.window.windowsToNorth(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call (or just use
--    `hs.window.filter.defaultCurrentSpace`)
function M:windowsToNorth(window, frontmost, strict, ...) end

-- Gets all visible windows allowed by this windowfilter that lie to the south a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the
--    southward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned south (i.e. down) of the window, in ascending order of distance
--
-- Notes:
--  * This is a convenience wrapper that returns `hs.window.windowsToSouth(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call (or just use
--    `hs.window.filter.defaultCurrentSpace`)
function M:windowsToSouth(window, frontmost, strict, ...) end

-- Gets all visible windows allowed by this windowfilter that lie to the west a given window
--
-- Parameters:
--  * window - (optional) an `hs.window` object; if nil, `hs.window.frontmostWindow()` will be used
--  * frontmost - (optional) boolean, if true unoccluded windows will be placed before occluded ones in the result list
--  * strict - (optional) boolean, if true only consider windows at an angle between 45° and -45° on the westward axis
--
-- Returns:
--  * A list of `hs.window` objects representing all windows positioned west (i.e. left) of the window, in ascending order of distance
--
-- Notes:
--  * This is a convenience wrapper that returns `hs.window.windowsToWest(window,self:getWindows(),...)`
--  * You'll likely want to add `:setCurrentSpace(true)` to the windowfilter used for this method call (or just use `hs.window.filter.defaultCurrentSpace`)
function M:windowsToWest(window, frontmost, strict, ...) end

-- Event for `hs.window.filter:subscribe()`: a window's title changed
M.windowTitleChanged = nil

-- Event for `hs.window.filter:subscribe()`: a window lost focus
M.windowUnfocused = nil

-- Event for `hs.window.filter:subscribe()`: a window was reverted back from fullscreen
M.windowUnfullscreened = nil

-- Event for `hs.window.filter:subscribe()`: a window was unhidden (its app was unhidden, e.g. via `cmd-h`)
M.windowUnhidden = nil

-- Event for `hs.window.filter:subscribe()`: a window was unminimized
M.windowUnminimized = nil

-- Event for `hs.window.filter:subscribe()`: a window became "visible" (in *any* Mission Control Space, as per `hs.window:isVisible()`)
-- after having been hidden or minimized, or if it was just created
M.windowVisible = nil

