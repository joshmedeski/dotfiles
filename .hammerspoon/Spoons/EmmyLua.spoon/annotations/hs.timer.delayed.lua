--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Specialized timer objects to coalesce processing of unpredictable asynchronous events into a single callback
---@class hs.timer.delayed
local M = {}
hs.timer.delayed = M

-- Creates a new delayed timer
--
-- Parameters:
--  * delay - number of seconds to wait for after a `:start()` invocation (the "callback countdown")
--  * fn - a function to call after `delay` has fully elapsed without any further `:start()` invocations
--
-- Returns:
--  * a new `hs.timer.delayed` object
--
-- Notes:
--  * These timers are meant to be long-lived: once instantiated, there's no way to remove them from the run loop; create them once at the module level.
--  * Delayed timers have specialized methods that behave differently from regular timers. When the `:start()` method is invoked, the timer will wait for `delay` seconds before calling `fn()`; this is referred to as the callback countdown. If `:start()` is invoked again before `delay` has elapsed, the countdown starts over again.
--  * You can use a delayed timer to coalesce processing of unpredictable asynchronous events into a single callback; for example, if you have an event stream that happens in "bursts" of dozens of events at once, set an appropriate `delay` to wait for things to settle down, and then your callback will run just once.
---@return hs.timer.delayed
function M.new(delay, fn, ...) end

-- Returns the time left in the callback countdown
--
-- Parameters:
--  * None
--
-- Returns:
--  * if the callback countdown is running, returns the number of seconds until it triggers; otherwise returns nil
function M:nextTrigger() end

-- Returns a boolean indicating whether the callback countdown is running
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean
---@return boolean
function M:running() end

-- Changes the callback countdown duration
--
-- Parameters:
--  * None
--
-- Returns:
--  * the delayed timer object
--
-- Notes:
--  * if the callback countdown is running, calling this method will restart it
---@return hs.timer.delayed
function M:setDelay(delay, ...) end

-- Starts or restarts the callback countdown
--
-- Parameters:
--  * delay - (optional) if provided, sets the countdown duration to this number of seconds for this time only; subsequent calls to `:start()` will revert to the original delay (or to the delay set with `:setDelay(delay)`)
--
-- Returns:
--  * the delayed timer object
---@return hs.timer.delayed
function M:start(delay, ...) end

-- Cancels the callback countdown, if running; the callback will therefore not be triggered
--
-- Parameters:
--  * None
--
-- Returns:
--  * the delayed timer object
---@return hs.timer.delayed
function M:stop() end

