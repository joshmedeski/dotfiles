---@meta

---@class DaemonOptions
---@field pid_file string Specify the location of the pid and lock file. The default location is `$XDG_RUNTIME_DIR/wezterm/pid` on X11/Wayland systems, or `$HOME/.local/share/wezterm/pid`.
---@field stdout string Specifies where a log of the stdout stream from the daemon will be placed. The default is `$XDG_RUNTIME_DIR/wezterm/stdout` on X11/Wayland systems, or `$HOME/.local/share/wezterm/stdout`.
---@field stderr string Specifies where a log of the stderr stream from the daemon will be placed. The default is `$XDG_RUNTIME_DIR/wezterm/stderr` on X11/Wayland systems, or `$HOME/.local/share/wezterm/stderr`.
