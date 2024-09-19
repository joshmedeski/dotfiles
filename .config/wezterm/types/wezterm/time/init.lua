---@meta

--TODO: finish

---@class TimeMod
---@field call_after fun(interval: number, function: function): nil Arranges to call your callback function after the specified number of seconds have elapsed.
---@field now fun(): TimeObj Returns a WezTermTimeObj object representing the time at which wezterm.time.now() was called.
---@field parse fun(string): TimeObj Parses a string that is formatted according to the supplied format string.
---@field parse_rfc3339 fun(string): TimeObj Parses a string that is formatted according to RFC 3339 and returns a Time object representing that time.
