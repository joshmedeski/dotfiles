--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Execute functions with various timing rules
--
-- **NOTE**: timers use NSTimer internally, which will be paused when computers sleep.
-- Especially, repeating timers won't be triggered at the specified time when there are sleeps in between.
-- The workaround is to prevent system from sleeping, configured in Energy Saver in System Preferences.
---@class hs.timer
local M = {}
hs.timer = M

-- Returns the absolute time in nanoseconds since the last system boot.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the time since the last system boot in nanoseconds
--
-- Notes:
--  * this value does not include time that the system has spent asleep
--  * this value is used for the timestamps in system generated events.
function M.absoluteTime() end

-- Converts days to seconds
--
-- Parameters:
--  * n - A number of days
--
-- Returns:
--  * The number of seconds in n days
function M.days(n) end

-- Calls a function after a delay
--
-- Parameters:
--  * sec - A number of seconds to wait before calling the function
--  * fn - A function to call
--
-- Returns:
--  * An `hs.timer` object
--
-- Notes:
--  * There is no need to call `:start()` on the returned object, the timer will be already running.
--  * The callback can be cancelled by calling the `:stop()` method on the returned object before `sec` seconds have passed.
---@return hs.timer
function M.doAfter(sec, fn, ...) end

-- Creates and starts a timer which will perform `fn` at the given (local) `time` and then (optionally) repeat it every `interval`.
--
-- Parameters:
--  * time - number of seconds after (local) midnight, or a string in the format "HH:MM" (24-hour local time), indicating
--    the desired trigger time
--  * repeatInterval - (optional) number of seconds between triggers, or a string in the format
--    "DDd", "DDdHHh", "HHhMMm", "HHh" or "MMm" indicating days, hours and/or minutes between triggers; if omitted
--    or `0` the timer will trigger only once
--  * fn - a function to call every time the timer triggers
--  * continueOnError - an optional boolean flag, defaulting to false, which indicates that the timer should not be automatically stopped if the callback function results in an error.
--
-- Returns:
--  * a timer object
--
-- Notes:
--  * The timer can trigger up to 1 second early or late
--  * The first trigger will be set to the earliest occurrence given the `repeatInterval`; if that's omitted,
--    and `time` is earlier than the current time, the timer will trigger the next day. If the repeated interval
--    results in exactly 24 hours you can schedule regular jobs that will run at the expected time independently
--    of when Hammerspoon was restarted/reloaded. E.g.:
--    * If it's 19:00, `hs.timer.doAt("20:00",somefn)` will set the timer 1 hour from now
--    * If it's 21:00, `hs.timer.doAt("20:00",somefn)` will set the timer 23 hours from now
--    * If it's 21:00, `hs.timer.doAt("20:00","6h",somefn)` will set the timer 5 hours from now (at 02:00)
--    * To run a job every hour on the hour from 8:00 to 20:00: `for h=8,20 do hs.timer.doAt(h..":00","1d",runJob) end`
---@return hs.timer
function M.doAt(time, repeatInterval, fn, continueOnError, ...) end

-- Repeats fn every interval seconds.
--
-- Parameters:
--  * interval - A number of seconds between triggers
--  * fn - A function to call every time the timer triggers
--
-- Returns:
--  * An `hs.timer` object
--
-- Notes:
--  * This function is a shorthand for `hs.timer.new(interval, fn):start()`
---@return hs.timer
function M.doEvery(interval, fn, ...) end

-- Creates and starts a timer which will perform `actionFn` every `checkinterval` seconds until `predicateFn` returns true.  The timer is automatically stopped when `predicateFn` returns true.
--
-- Parameters:
--  * predicateFn - a function which determines when to stop calling `actionFn`.  This function takes no arguments, but should return true when it is time to stop calling `actionFn`.
--  * actionFn - a function which performs the desired action.  This function may take a single argument, the timer itself.
--  * checkInterval - an optional parameter indicating how often to repeat the `predicateFn` check. Defaults to 1 second.
--
-- Returns:
--  * a timer object
--
-- Notes:
--  * The timer is passed as an argument to `actionFn` so that it may stop the timer prematurely (i.e. before predicateFn returns true) if desired.
--  * See also `hs.timer.doWhile`, which is essentially the opposite of this function
---@return hs.timer
function M.doUntil(predicateFn, actionFn, checkInterval, ...) end

-- Creates and starts a timer which will perform `actionFn` every `checkinterval` seconds while `predicateFn` returns true.  The timer is automatically stopped when `predicateFn` returns false.
--
-- Parameters:
--  * predicateFn - a function which determines when to stop calling `actionFn`.  This function takes no arguments, but should return false when it is time to stop calling `actionFn`.
--  * actionFn - a function which performs the desired action.  This function may take a single argument, the timer itself.
--  * checkInterval - an optional parameter indicating how often to repeat the `predicateFn` check. Defaults to 1 second.
--
-- Returns:
--  * a timer object
--
-- Notes:
--  * The timer is passed as an argument to `actionFn` so that it may stop the timer prematurely (i.e. before predicateFn returns false) if desired.
--  * See also `hs.timer.doUntil`, which is essentially the opposite of this function
---@return hs.timer
function M.doWhile(predicateFn, actionFn, checkInterval, ...) end

-- Immediately fires a timer
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.timer` object
--
-- Notes:
--  * This cannot be used on a timer which has already stopped running
---@return hs.timer
function M:fire() end

-- Converts hours to seconds
--
-- Parameters:
--  * n - A number of hours
--
-- Returns:
--  * The number of seconds in n hours
function M.hours(n) end

-- Returns the number of seconds since local time midnight
--
-- Parameters:
--  * None
--
-- Returns:
--  * the number of seconds
---@return number
function M.localTime() end

-- Converts minutes to seconds
--
-- Parameters:
--  * n - A number of minutes
--
-- Returns:
--  * The number of seconds in n minutes
function M.minutes(n) end

-- Creates a new `hs.timer` object for repeating interval callbacks
--
-- Parameters:
--  * interval - A number of seconds between firings of the timer
--  * fn - A function to call every time the timer fires
--  * continueOnError - An optional boolean, true if the timer should continue to be triggered after the callback function has produced an error, false if the timer should stop being triggered after the callback function has produced an error. Defaults to false.
--
-- Returns:
--  * An `hs.timer` object
--
-- Notes:
--  * The returned object does not start its timer until its `:start()` method is called
--  * If `interval` is 0, the timer will not repeat (because if it did, it would be repeating as fast as your machine can manage, which seems generally unwise)
--  * For non-zero intervals, the lowest acceptable value for the interval is 0.00001s. Values >0 and <0.00001 will be coerced to 0.00001
---@return hs.timer
function M.new(interval, fn, continueOnError, ...) end

-- Returns the number of seconds until the timer will next trigger
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the number of seconds until the next firing
--
-- Notes:
--  * The return value may be a negative integer in two circumstances:
--   * Hammerspoon's runloop is backlogged and is catching up on missed timer triggers
--   * The timer object is not currently running. In this case, the return value of this method is the number of seconds since the last firing (you can check if the timer is running or not, with `hs.timer:running()`
---@return number
function M:nextTrigger() end

-- Returns a boolean indicating whether or not the timer is currently running.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether or not the timer is currently running.
---@return boolean
function M:running() end

-- Converts a string with a time of day or a duration into number of seconds
--
-- Parameters:
--  * timeOrDuration - a string that can have any of the following formats:
--    * "HH:MM:SS" or "HH:MM" - represents a time of day (24-hour clock), returns the number of seconds since midnight
--    * "DDdHHh", "HHhMMm", "MMmSSs", "DDd", "HHh", "MMm", "SSs", "NNNNms" - represents a duration in days, hours, minutes,
--      seconds and/or milliseconds
--
-- Returns:
--  * The number of seconds
function M.seconds(timeOrDuration, ...) end

-- Gets the (fractional) number of seconds since the UNIX epoch (January 1, 1970)
--
-- Parameters:
--  * None
--
-- Returns:
--  * The number of seconds since the epoch
--
-- Notes:
--  * This has much better precision than `os.time()`, which is limited to whole seconds.
function M.secondsSinceEpoch() end

-- Sets the next trigger time of a timer
--
-- Parameters:
--  * seconds - A number of seconds after which to trigger the timer
--
-- Returns:
--  * The `hs.timer` object, or nil if an error occurred
--
-- Notes:
--  * If the timer is not already running, this will start it
---@return hs.timer
function M:setNextTrigger(seconds, ...) end

-- Starts an `hs.timer` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.timer` object
--
-- Notes:
--  * The timer will not call the callback immediately, the timer will wait until it fires
--  * If the callback function results in an error, the timer will be stopped to prevent repeated error notifications (see the `continueOnError` parameter to `hs.timer.new()` to override this)
---@return hs.timer
function M:start() end

-- Stops an `hs.timer` object
--
-- Parameters:
--  * None
--
-- Returns:
--  * The `hs.timer` object
---@return hs.timer
function M:stop() end

-- Blocks Lua execution for the specified time
--
-- Parameters:
--  * microsecs - A number containing a time in microseconds to block for
--
-- Returns:
--  * None
--
-- Notes:
--  * Use of this function is strongly discouraged, as it blocks all main-thread execution in Hammerspoon. This means no hotkeys or events will be processed in that time, no GUI updates will happen, and no Lua will execute. This is only provided as a last resort, or for extremely short sleeps. For all other purposes, you really should be splitting up your code into multiple functions and calling `hs.timer.doAfter()`
function M.usleep(microsecs, ...) end

-- Creates and starts a timer which will perform `actionFn` when `predicateFn` returns true.  The timer is automatically stopped when `actionFn` is called.
--
-- Parameters:
--  * predicateFn - a function which determines when `actionFn` should be called.  This function takes no arguments, but should return true when it is time to call `actionFn`.
--  * actionFn - a function which performs the desired action.  This function may take a single argument, the timer itself.
--  * checkInterval - an optional parameter indicating how often to repeat the `predicateFn` check. Defaults to 1 second.
--
-- Returns:
--  * a timer object
--
-- Notes:
--  * The timer is stopped before `actionFn` is called, but the timer is passed as an argument to `actionFn` so that the actionFn may restart the timer to be called again the next time predicateFn returns true.
--  * See also `hs.timer.waitWhile`, which is essentially the opposite of this function
---@return hs.timer
function M.waitUntil(predicateFn, actionFn, checkInterval, ...) end

-- Creates and starts a timer which will perform `actionFn` when `predicateFn` returns false.  The timer is automatically stopped when `actionFn` is called.
--
-- Parameters:
--  * predicateFn - a function which determines when `actionFn` should be called.  This function takes no arguments, but should return false when it is time to call `actionFn`.
--  * actionFn - a function which performs the desired action.  This function may take a single argument, the timer itself.
--  * checkInterval - an optional parameter indicating how often to repeat the `predicateFn` check. Defaults to 1 second.
--
-- Returns:
--  * a timer object
--
-- Notes:
--  * The timer is stopped before `actionFn` is called, but the timer is passed as an argument to `actionFn` so that the actionFn may restart the timer to be called again the next time predicateFn returns false.
--  * See also `hs.timer.waitUntil`, which is essentially the opposite of this function
---@return hs.timer
function M.waitWhile(predicateFn, actionFn, checkInterval, ...) end

-- Converts weeks to seconds
--
-- Parameters:
--  * n - A number of weeks
--
-- Returns:
--  * The number of seconds in n weeks
function M.weeks(n) end

