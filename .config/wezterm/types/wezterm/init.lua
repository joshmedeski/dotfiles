---@meta

--TODO: specify "any" types where possible

---@alias PathBuf string

---@class Wezterm :ExecDomain
---@field GLOBAL table<string, ANY>
---@field action Action
---@field action_callback fun(win: Window, pane: Pane, ...: any): (nil | false)
---@field add_to_config_reload_watch_list fun(path: string): nil Adds path to the list of files that are watched for config changes. If `automatically_reload_config` is enabled, then the config will be reloaded when any of the files that have been added to the watch list have changed.
---@field background_child_process fun(args: string[]): nil Accepts an argument list; it will attempt to spawn that command in the background.
---@field battery_info fun(): BatteryInfo[] Returns battery information for each of the installed batteries on the system. This is useful for example to assemble status information for the status bar.
---@field column_width fun(string): number Given a string parameter, returns the number of columns that that text occupies in the terminal, which is useful together with format-tab-title and update-right-status to compute/layout tabs and status information.
---@field config_builder fun(): Config Returns a config builder object that can be used to define your configuration.
---@field config_dir string This constant is set to the path to the directory in which your wezterm.lua configuration file was found.
---@field config_file string This constant is set to the path to the wezterm.lua that is in use.
---@field color ColorMod The `wezterm.color` module exposes functions that work with colors.
---@field default_hyperlink_rules fun(): HyperLinkRule[] Returns the compiled-in default values for hyperlink_rules.
---@field default_ssh_domains fun(): SSHDomainObj[] Computes a list of SshDomain objects based on the set of hosts discovered in your ~/.ssh/config. Each host will have both a plain SSH and a multiplexing SSH domain generated and returned in the list of domains. The former don't require wezterm to be installed on the remote host, while the latter do require it. The intended purpose of this function is to allow you the opportunity to edit/adjust the returned information before assigning it to your config.
---@field default_wsl_domains fun(): { name: string, distribution: string }[] Computes a list of WslDomain objects, each one representing an installed WSL distribution on your system. This list is the same as the default value for the wsl_domains configuration option, which is to make a WslDomain with the distribution field set to the name of WSL distro and the name field set to name of the distro but with "WSL:" prefixed to it.
---@field emit fun(event: string, ...)
---@field enumerate_ssh_hosts fun(ssh_config_file_name: string?): { [string] : { hostname: string, identityagent: string, identityfile: string, port: string, user: string, userknownhostsfile: string } } This function will parse your ssh configuration file(s) and extract from them the set of literal (non-pattern, non-negated) host names that are specified in Host and Match stanzas contained in those configuration files and return a mapping from the hostname to the effective ssh config options for that host.  You may optionally pass a list of ssh configuration files that should be read, in case you have a special configuration.
---@field executable_dir string This constant is set to the directory containing the wezterm executable file.
---@field font fun(font_attributes: FontAttributes): Fonts | fun(name: string, font_attributes: FontAttributes?): Fonts https://wezfurlong.org/wezterm/config/lua/wezterm/font.html
---@field font_with_fallback fun(fonts: string[] | FontAttributes[]): Fonts https://wezfurlong.org/wezterm/config/lua/wezterm/font_with_fallback.html
---@field format fun(...: FormatItem[]): string Can be used to produce a formatted string with terminal graphic attributes such as bold, italic and colors. The resultant string is rendered into a string with wezterm compatible escape sequences embedded.
---@field get_builtin_color_schemes any #TODO
---@field glob fun(pattern: string, relative_to: string?): string[] This function evalutes the glob pattern and returns an array containing the absolute file names of the matching results. Due to limitations in the lua bindings, all of the paths must be able to be represented as UTF-8 or this function will generate an error.
---@field gui GuiMod
---@field has_action fun(action: string): boolean
---@field mux MuxMod
---@field home_dir string This constant is set to the home directory of the user running wezterm.
---@field hostname fun(): string This function returns the current hostname of the system that is running wezterm. This can be useful to adjust configuration based on the host.
---@field json_encode fun(value: any): string Encodes the supplied lua value as json.
---@field json_parse fun(value: string): any Parses the supplied string as json and returns the equivalent lua values.
---@field log_error fun(msg: string, ...: any): nil Logs the provided message string through wezterm's logging layer at 'ERROR' level. If you started wezterm from a terminal that text will print to the stdout of that terminal. If running as a daemon for the multiplexer server then it will be logged to the daemon output path.
---@field log_info fun(msg: string, ...: any): nil Logs the provided message string through wezterm's logging layer at 'INFO' level. If you started wezterm from a terminal that text will print to the stdout of that terminal. If running as a daemon for the multiplexer server then it will be logged to the daemon output path.
---@field log_warn fun(msg: string, ...: any): nil Logs the provided message string through wezterm's logging layer at 'WARN' level. If you started wezterm from a terminal that text will print to the stdout of that terminal. If running as a daemon for the multiplexer server then it will be logged to the daemon output path.
---@field nerdfonts NerdFont
---@field open_with fun(path_or_url: string, application: string?) This function opens the specified path_or_url with either the specified application or uses the default application if application was not passed in.
---@field on EventAugmentCommandPalette | EventBell | EventFormatTabTitle | EventFormatWindowTitle | EventNewTabButtonClick | EventOpenUri | EventUpdateRightStatus | EventUpdateStatus | EventUserVarChanged | EventWindowConfigReloaded | EventWindowFocusChanged | EventWindowResized | EventCustom
---@field pad_left fun(string: string, min_width: integer): string Returns a copy of string that is at least min_width columns (as measured by wezterm.column_width)
---@field pad_right fun(string: string, min_width: integer): string Returns a copy of string that is at least min_width columns (as measured by wezterm.column_width).
---@field permute_any_or_no_mods any #TODO
---@field plugin WeztermPlugin
---@field read_dir fun(path: string): string Returns an array containing the absolute file names of the directory specified. Due to limitations in the lua bindings, all of the paths must be able to be represented as UTF-8 or this function will generate an error.
---@field reload_configuration fun(): nil Immediately causes the configuration to be reloaded and re-applied.
---@field run_child_process fun(args: string[]): { success: boolean, stdout: string, stderr: string } Will attempt to spawn that command and will return a tuple consisting of the boolean success of the invocation, the stdout data and the stderr data.
---@field running_under_wsl fun(): boolean Returns a boolean indicating whether we believe that we are running in a Windows Services for Linux (WSL) container.
---@field shell_join_args fun(args: string[]): string Joins together its array arguments by applying posix style shell quoting on each argument and then adding a space.
---@field shell_quote_arg fun(string: string): string Quotes its single argument using posix shell quoting rules.
---@field shell_split fun(line: string): string[] Splits a command line into an argument array according to posix shell rules.
---@field sleep_ms fun(milliseconds: number): nil wezterm.sleep_ms suspends execution of the script for the specified number of milliseconds. After that time period has elapsed, the script continues running at the next statement.
---@field split_by_newlines fun(string: string): string[] takes the input string and splits it by newlines (both \n and \r\n are recognized as newlines) and returns the result as an array of strings that have the newlines removed.
---@field strftime fun(format: string): string Formats the current local date/time into a string using the Rust chrono strftime syntax.
---@field strftime_utc fun(format: string): string Formats the current UTC date/time into a string using the Rust chrono strftime syntax.
---@field target_triple string This constant is set to the Rust target triple for the platform on which wezterm was built. This can be useful when you wish to conditionally adjust your configuration based on the platform.
---@field time TimeMod
---@field truncate_left fun(string: string, max_width: number): string Returns a copy of string that is no longer than max_width columns (as measured by wezterm.column_width). Truncation occurs by reemoving excess characters from the left end of the string.
---@field truncate_right fun(string: string, max_width: number): string Returns a copy of string that is no longer than max_width columns (as measured by wezterm.column_width). Truncation occurs by reemoving excess characters from the right end of the string.
---@field utf16_to_utf8 fun(string: string): string Overly specific and exists primarily to workaround this wsl.exe issue. It takes as input a string and attempts to convert it from utf16 to utf8.
---@field version string This constant is set to the wezterm version string that is also reported by running wezterm -V. This can potentially be used to adjust configuration according to the installed version.
Wezterm = {}

---@param table MouseBindingBase
---@return MouseBinding
---@overload fun(table: KeyBindingBase): KeyBinding
Wezterm.permute_any_mods = function(table) end

---@param gradient Gradient
---@param num_colors number
---@return Color[]
Wezterm.gradient_colors = function(gradient, num_colors) end

---@param callback ActionCallback
---@return Action
Wezterm.action_callback = function(callback) end
