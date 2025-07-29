---@meta

---@alias LocalProcessStatus 'Idle' | 'Run' | 'Sleep' | 'Stop' | 'Zombie' | 'Tracing' | 'Dead' | 'Wakekill' | 'Waking' | 'Parked' | 'LockBlocked' | 'Unknown'

---@class LocalProcessInfo
---@field pid number  The process identifier
---@field ppid number  The parent process identifier
---@field name string  The COMM name of the process. May not bear any relation to the executable image name. May be changed at runtime by the process. Many systems truncate this field to 15-16 characters.
---@field executable PathBuf  Path to the executable image
---@field argv string[]  The argument vector. Some systems allow changing the argv block at runtime eg: setproctitle().
---@field cwd string  The current working directory for the process, or an empty path if it was not accessible for some reason.
---@field status LocalProcessStatus -- The status of the process. Not all possible values are portably supported on all systems.
---@field start_time number  A clock value in unspecified system dependent units that indicates the relative age of the process.
---@field console number  The console handle associated with the process, if any.
---@field children table<u32, LocalProcessInfo> -- Child processes, keyed by pid
