---@meta

---@module "types.config"
---@module "types.enum"
---@module "types.events"
---@module "types.objects"
---@module "types.wezterm"

-- Alias to help identify types that should actually be any
---@alias ANY any

---@alias FormatItemAttribute
---|{ Underline: "None"|"Single"|"Double"|"Curly"|"Dotted"|"Dashed" }
---|{ Intensity: "Normal"|"Bold"|"Half" }
---|{ Italic: boolean }

-- Reset all attributes to default
---@alias FormatItemReset "ResetAttributes"

---@alias FormatItem
---|FormatItemReset
---|{ Attribute: FormatItemAttribute }
---|{ Foreground: ColorSpec }
---|{ Background: ColorSpec }
---|{ Text: string }

---@alias CopyToTarget
---|"Clipboard"
---|"PrimarySelection"
---|"ClipboardAndPrimarySelection"

---@alias SshBackend "Ssh2"|"LibSsh"

-- This is a virtual modifier used by wezterm
---@alias Modifiers
---|"ALT"
---|"CTRL"
---|"ENHANCED_KEY"
---|"LEADER"
---|"LEFT_ALT"
---|"LEFT_CTRL"
---|"LEFT_SHIFT"
---|"NONE"
---|"RIGHT_ALT"
---|"RIGHT_CTRL"
---|"RIGHT_SHIFT"
---|"SHIFT"
---|"SUPER"

---@alias WebGpuPowerPreference "LowPower"|"HighPerformance"

-- Only Option
---@alias FontRasterizerSelection "FreeType"

---@alias FontShaperSelection
---|"Allsorts" very preliminary support
---|"Harfbuzz" default

---@alias FontLocatorSelection
---|"FontConfig" Use fontconfig APIs to resolve fonts (!macos, posix systems)
---|"Gdi" Use GDI on win32 systems
---|"CoreText" Use CoreText on macOS
---|"ConfigDirsOnly" Use only the font_dirs configuration to locate fonts

---@alias FrontEndSelection
---|"OpenGL"
---|"WebGpu" default
---|"Software"

---@alias DisplayPixelGeometry
---|"RGB" default
---|"BGR"

---@alias f32 number

---@alias f64 number

---@alias u8 integer

---@alias u16 integer

---@alias u32 integer

---@alias u64 integer

---@alias i64 integer

---@alias Duration u64

---@alias usize number

---@alias String string

---@alias Regex string

---@alias RgbColor string
--
---@alias RgbaColor string

---@alias bool boolean

---@alias BoldBrightening "No"|"BrightAndBold"|"BrightOnly"

-- TODO: describe
---@alias ExitBehavior "Close"|"CloseOnCleanExit"|"Hold"

-- TODO: describe
---@alias ExitBehaviorMessaging "Verbose"|"Brief"|"Terse"|"None"

---@alias IntegratedTitleButton "Hide"|"Maximize"|"Close"

---@alias IntegratedTitleButtonAlignment "Right"|"Left"

---@alias IntegratedTitleButtonStyle "Windows"|"Gnome"|"MacOsNative"

---@alias WindowDecorations "NONE"|"TITLE"|"RESIZE"|"TITLE | RESIZE"

-- A value expressed in points, where 72 points == 1 inch
---@alias Points string

-- A value expressed in raw pixels
---@alias Pixels string|number

-- A value expressed in terms of a fraction of the maximum
-- value in the same direction.  For example, left padding
-- of 10% depends on the pixel width of that element.
-- The value is 1.0 == 100%.  It is possible to express
-- eg: 2.0 for 200%
---@alias Percent string

-- A value expressed in terms of a fraction of the cell
-- size computed from the configured font size.
-- 1.0 == the cell size
---@alias Cells string

---@alias Dimension Points|Pixels|Percent|Cells

---@class TabBarColor
-- The color of the background area for the tab
---@field bg_color? string
-- The color of the text for the tab
---@field fg_color? string
-- Specify whether you want `"Half"`, `"Normal"` or `"Bold"` intensity for the
-- label shown for this tab.
--
-- The default is `"Normal"`
---@field intensity? "Half"|"Normal"|"Bold"
-- Specify whether you want `"None"`, `"Single"` or `"Double"` underline for
-- label shown for this tab.
--
-- The default is `"None"`
---@field underline? "None"|"Single"|"Double"
-- Specify whether you want the text to be italic for this tab.
--
-- The default is `false`
---@field italic? boolean
-- Specify whether you want the text to be rendered with strikethrough (true)
-- or not for this tab.
--
-- The default is `false`
---@field strikethrough? boolean

---@class TabBarColors
-- The text color to use when the attributes are reset to default
---@field background? string
---@field inactive_tab_edge? string
---@field inactive_tab_edge_hover? string

-- Configure the color and styling for the tab bar
---@class TabBar: TabBarColors
-- The color of the strip that goes along the top of the window
-- (does not apply when fancy tab bar is in use)
---@field background string
-- The active tab is the one that has focus in the window
---@field active_tab TabBarColor
-- Inactive tabs are the tabs that do not have focus
---@field inactive_tab TabBarColor
-- You can configure some alternate styling when the mouse pointer
-- moves over inactive tabs
---@field inactive_tab_hover TabBarColor
-- The new tab button that let you create new tabs
---@field new_tab TabBarColor
-- You can configure some alternate styling when the mouse pointer
-- moves over the new tab button
---@field new_tab_hover TabBarColor

---@alias AnsiColors
---|"Aqua"
---|"Black"
---|"Blue"
---|"Fuchsia"
---|"Green"
---|"Grey"
---|"Lime"
---|"Maroon"
---|"Navy"
---|"Olive"
---|"Purple"
---|"Red"
---|"Silver"
---|"Teal"
---|"White"
---|"Yellow"

---@alias AC "AnsiColor"

---@alias CO "Color"

---@alias ColorSpec table<AC, AnsiColors>|table<CO, string>

---@class Palette
-- The text color to use when the attributes are reset to default
---@field foreground string
--  The background color to use when the attributes are reset to default
---@field background string
-- The color of the cursor
---@field cursor_fg string
---@field cursor_bg string
-- The border of the cursor
---@field cursor_border string
-- The color of selected text
---@field selection_fg string
---@field selection_bg string
-- A list of 8 colors corresponding to the basic ANSI palette
---@field ansi string[]
-- TODO: Description
---@field brights string[]
-- A map for setting arbitrary colors ranging from 16 to 256 in the color palette
---@field indexed { [number]: string }
-- The color of the "thumb" of the scrollbar; the segment that represents the current viewable area
---@field scrollbar_thumb string
-- The color of the split line between panes
---@field split string
-- The color of the visual bell. If unspecified, the foreground color is used instead
---@field visual_bell string
-- The color to use for the cursor when a dead key or leader state is active
---@field compose_cursor string
---@field copy_mode_active_highlight_fg ColorSpec
---@field copy_mode_active_highlight_bg ColorSpec
---@field copy_mode_inactive_highlight_fg ColorSpec
---@field copy_mode_inactive_highlight_bg ColorSpec
---@field quick_select_label_fg ColorSpec
---@field quick_select_label_bg ColorSpec
---@field quick_select_match_fg ColorSpec
---@field quick_select_match_bg ColorSpec
---@field tab_bar TabBar

---@alias FontWeight
---|"Regular"
---|"Black"
---|"Bold"
---|"Book"
---|"DemiBold"
---|"DemiLight"
---|"ExtraBlack"
---|"ExtraBold"
---|"ExtraLight"
---|"Light"
---|"Medium"
---|"Thin"

---@alias FontStretch
---|"Normal"
---|"Condensed"
---|"Expanded"
---|"ExtraCondensed"
---|"ExtraExpanded"
---|"SemiCondensed"
---|"SemiExpanded"
---|"UltraCondensed"
---|"UltraExpanded"

---@alias FontStyle "Normal"|"Italic"|"Oblique"

---@alias FreeTypeLoadTarget
---|"Normal"
---|"HorizontalLcd"
---|"Light"
---|"Mono"
---|"VerticalLcd"

---@alias FreeTypeLoadFlags "DEFAUlT"
---|"NO_HINTING"
---|"NO_BITMAP"
---|"FORCE_AUTOHINT"
---|"MONOCHROME"
---|"NO_AUTOHINT"

--TODO: = add harfbuzz_features enum
--
---@alias Fonts { fonts: FontAttributes[] }

---@class FontAttributes
-- Whether the font should be a bold variant
---@field weight? FontWeight
---@field stretch? FontStretch
-- Whether the font should be an italic variant
---@field style? FontStyle
---@field freetype_load_target? FreeTypeLoadTarget
---@field freetype_render_target? FreeTypeLoadTarget
-- you can combine the flags like "NO_HINTING|MONOCHROME" -- probably would not want to
---@field freetype_load_flags? FreeTypeLoadFlags
---@field is_fallback? boolean
---@field is_synthetic? boolean
---@field harfbuzz_features? string[]
---@field assume_emoji_presentation? boolean
---@field scale? number

---@class WindowFrameConfig
---@field inactive_titlebar_bg? RgbColor
---@field active_titlebar_bg? RgbColor
---@field inactive_titlebar_fg? RgbColor
---@field active_titlebar_fg? RgbColor
---@field inactive_titlebar_border_bottom? RgbColor
---@field active_titlebar_border_bottom? RgbColor
---@field button_fg? RgbColor
---@field button_bg? RgbColor
---@field button_hover_fg? RgbColor
---@field button_hover_bg? RgbColor
---@field border_left_width? Dimension
---@field border_right_width? Dimension
---@field border_top_height? Dimension
---@field border_bottom_height? Dimension
---@field border_left_color? RgbaColor
---@field border_right_color? RgbaColor
---@field border_top_color? RgbaColor
---@field border_bottom_color? RgbaColor

---@class TabBarStyle
---@field new_tab? String
---@field new_tab_hover? String
---@field window_hide? String
---@field window_hide_hover? String
---@field window_maximize? String
---@field window_maximize_hover? String
---@field window_close? String
---@field window_close_hover? String

---@class HyperlinkRule
---@field regex? Regex
---@field format? String
---@field highlight? usize

---@class SerialDomain
-- The name of this specific domain.  Must be unique amongst
-- all types of domain in the configuration file
---@field name String
-- Specifies the serial device name.
-- On Windows systems this can be a name like `COM0`.
-- On posix systems this will be something like `/dev/ttyUSB0`.
-- If omitted, the name will be interpreted as the port
---@field port String
-- Set the baud rate.  The default is 9600 baud
---@field baud usize

---@class GpuInfo
---@field name String
---@field device_type String
---@field backend String
---@field driver String
---@field driver_info String
---@field vendor u32
---@field device u32

---@class UnixDomain
-- The name of this specific domain. Must be unique amongst
-- all types of domain in the configuration file.
---@field name String
-- The path to the socket. If unspecified, a resonable default
-- value will be computed
---@field socket_path PathBuf
-- If true, connect to this domain automatically at startup
---@field connect_automatically bool
-- If true, do not attempt to start this server if we try and fail to
-- connect to it.
---@field no_serve_automatically bool
-- If we decide that we need to start the server, the command to run
-- to set that up. The default is to spawn:
--
-- ```sh
-- wezterm-mux-server --daemonize
-- ```
--
-- To start up a UNIX domain inside a WSL container:
--
-- ```sh
-- wsl -e wezterm-mux-server --daemonize
-- ```
---@field serve_command String[]
-- Instead of directly connecting to `socket_path`
-- spawn this command and use its stdin/stdout in place of
-- the socket
---@field proxy_command String[]
-- If true, bypass checking for secure ownership of the socket_path.  This is not recommended on a multi-user system, but is useful for example when running the server inside a WSL container but with the socket on the host NTFS volume.
---@field skip_permissions_check bool
---@field read_timeout Duration
-- Don"t use default_local_echo_threshold_ms() here to disable the predictive echo for Unix domains by default
---@field write_timeout Duration
-- Show time since last response when waiting for a response.
-- It is recommended to use <https://wezfurlong.org/wezterm/config/lua/pane/get_metadata.html#since_last_response_ms>
-- instead
---@field local_echo_threshold_ms u64
---@field overlay_lag_indicator bool

---@class LeaderKey: KeyNoAction
---@field timeout_milliseconds? u64

---@class HyperLinkRule
-- The regular expression to match
---@field regex string
-- Controls which parts of the regex match will be used to form the link.
-- Must have a prefix: signaling the protocol type (e.g., `https:/mailto:`),
-- which can either come from the regex match or needs to be explicitly added.
-- The format string can use placeholders like `$0`, `$1`, `$2` etc.
-- that will be replaced with that numbered capture group.
-- So, `$0` will take the entire region of text matched by the whole regex,
-- while `$1` matches out the first capture group.
--
-- In the example below: mailto:$0 is used to prefix a protocol to the text to make it into an URL
---@field format string
-- Specifies the range of the matched text that should be highlighted/underlined
-- when the mouse hovers over the link.
-- The value is a number that corresponds to a capture group in the regex.
--
-- The default is `0`, highlighting the entire region of text matched by the regex.
-- `1` would be the first capture group, and so on...
---@field highlight? number

---@class BatteryInfo
-- The battery level expressed as a number between `0.0` (empty) and `1.0` (full)
---@field state_of_charge number
-- If known, shows battery manufacturer name or "unknown" otherwise
---@field vendor string
-- If known, shows the battery model string or `"unknown"` otherwise
---@field model string
-- If known, shows the battery serial number or `"unknown"` otherwise
---@field serial string
-- If charging, how long until the battery is full (in seconds)
---@field time_to_full? number
-- If discharing, how long until the battery is empty (in seconds)
---@field time_to_empty? number
---@field state "Charging"|"Discharging"|"Empty"|"Full"|"Unknown"

---@class WeztermPlugin
---@field require fun(url: string): any

---@class AugmentCommandPaletteReturn
-- The brief description for the entry
---@field brief string
-- A long description that may be shown after the entry, or that may be used in
-- future versions of wezterm to provide more information about the command
---@field doc? string
-- The action to take when the item is activated.
-- Can be any key assignment action
---@field action KeyAssignment
-- optional Nerd Fonts glyph name to use for the icon for the entry.
--
---@see wezterm.nerdfonts for a list of icon names
---@field icon? NerdFont

---@alias CallbackWindowPane fun(window: Window, pane: Pane)

-- This event is emitted when the Command Palette is shown.
-- Its purpose is to enable you to add additional entries to the list of commands shown in the palette.
-- This hook is synchronous; calling asynchronous functions will not succeed
---@alias EventAugmentCommandPalette fun(event: "augment-command-palette", callback: fun(window: Window, pane: Window): AugmentCommandPaletteReturn): nil

-- The bell event is emitted when the ASCII BEL sequence is emitted to a pane in the window.
-- Defining an event handler doesn"t alter wezterm's handling of the bell;
-- the event supplements it and allows you to take additional action over the configured behavior
---@alias EventBell fun(event: "augment-command-palette", callback: CallbackWindowPane)
-- TODO: Description
---@alias EventFormatTabTitle fun(event: "format-tab-title", callback: fun(tab: MuxTabObj, tabs: MuxTabObj[], panes: Pane[], config: Config, hover: boolean, max_width: number): string)
-- TODO: Description
---@alias EventFormatWindowTitle fun(event: "format-window-title", callback: fun(window: Window, pane: Pane, tabs: MuxTabObj[], panes: Pane[], config: Config))
-- TODO: Description
---@alias EventNewTabButtonClick fun(event: "new-tab-button-click", callback: fun(window: Window, pane: Pane, button: "Left"|"Middle"|"Right", default_action: KeyAssignment): nil)
-- TODO: Description
---@alias EventOpenUri fun(event: "open-uri", callback: fun(window: Window, pane: Pane, uri: string): nil)
-- TODO: Description
---@alias EventUpdateRightStatus fun(event: "update-right-status", callback: CallbackWindowPane)
-- TODO: Description
---@alias EventUpdateStatus fun(event: "update-status", callback: CallbackWindowPane)
-- TODO: Description
---@alias EventUserVarChanged fun(event: "user-var-changed", callback: fun(window: Window, pane: Pane, name: string, value: string): nil)
-- TODO: Description
---@alias EventWindowConfigReloaded fun(event: "window-config-reloaded", callback: CallbackWindowPane)
-- TODO: Description
---@alias EventWindowFocusChanged fun(event: "window-focus-changed", callback: CallbackWindowPane)
-- TODO: Description
---@alias EventWindowResized fun(event: "window-resized", callback: CallbackWindowPane)

-- A custom declared function
---@alias EventCustom fun(event: string, callback: fun(...: any): nil)

---@alias CursorShape
---|"BlinkingBlock"
---|"BlinkingBar"
---|"BlinkingUnderline"
---|"SteadyBar"
---|"SteadyBlock"
---|"SteadyUnderline"

---@alias CursorVisibility "Visible"|"Hidden"

---@class StableCursorPosition
-- The horizontal cell index
---@field x number
-- The vertical stable row index
---@field y number
-- The CursorShape enum value
---@field shape CursorShape
-- The CursorVisibility enum value
---@field visibility CursorVisibility

---@class LinearGradientOrientation
---@field angle number

---@class RadialGradientOrientation
---@field radius? number
---@field cx? number
---@field cy? number

---@alias GradientOrientation
---|"Horizontal"
---|"Vertical"
---|{ Linear: LinearGradientOrientation }
---|{ Radial: RadialGradientOrientation }

---@class Gradient
---@field colors string[]
---@field orientation? GradientOrientation
---@field interpolation? "Linear"|"Basis"|"CatmullRom"
---@field blend? "Rgb"|"LinearRgb"|"Hsv"|"Oklab"
---@field noise? number
---@field segment_size? number
---@field segment_smoothness? number

---@class ColorSchemeMetaData
---@field name? string
---@field author? string
---@field origin_url? string
---@field wezterm_version? string
---@field aliases? string[]

---@alias ActionCallback fun(win: Window, pane: Pane, ...: any): (nil|false)

---@alias AnsiColor
---|"Black"
---|"Maroon"
---|"Green"
---|"Olive"
---|"Navy"
---|"Purple"
---|"Teal"
---|"Silver"
---|"Grey"
---|"Red"
---|"Lime"
---|"Yellow"
---|"Blue"
---|"Fuchsia"
---|"Aqua"
---|"White"

---@alias Appearance
---|"Dark"
---|"DarkHighContrast"
---|"Light"
---|"LightHighContrast"

---@alias Clipboard
---|"Clipboard"
---|"PrimarySelection"
---|"ClipboardAndPrimarySelection"

---@alias CopyMode
---|"AcceptPattern"
---|"ClearPattern"
---|"ClearSelectionMode"
---|"Close"
---|"CycleMatchType"
---|"EditPattern"
---|"MoveBackwardSemanticZone"
---|"MoveBackwardWord"
---|"MoveDown"
---|"MoveForwardSemanticZone"
---|"MoveForwardWord"
---|"MoveForwardWordEnd"
---|"MoveLeft"
---|"MoveRight"
---|"MoveToEndOfLineContent"
---|"MoveToScrollbackBottom"
---|"MoveToScrollbackTop"
---|"MoveToSelectionOtherEnd"
---|"MoveToSelectionOtherEndHoriz"
---|"MoveToStartOfLine"
---|"MoveToStartOfLineContent"
---|"MoveToStartOfNextLine"
---|"MoveToViewportBottom"
---|"MoveToViewportMiddle"
---|"MoveToViewportTop"
---|"MoveUp"
---|"NextMatch"
---|"NextMatchPage"
---|"PriorMatch"
---|"PriorMatchPage"
---|{ MoveBackwardSemanticZoneOfType: SemanticZoneType }
---|{ MoveForwardSemanticZoneOfType: SemanticZoneType }
---|{ SetSelectionMode: SelectionMode|"SemanticZone" }

---@alias CursorStyle
---|"BlinkingBlock"
---|"SteadyBlock"
---|"BlinkingUnderline"
---|"SteadyUnderline"
---|"BlinkingBar"
---|"SteadyBar"

---@alias Direction
---|"Left"
---|"Right"
---|"Up"
---|"Down"
---|"Next"
---|"Prev"

---@alias EasingFunction
---|"Constant"
---|"Ease"
---|"EaseIn"
---|"EaseInOut"
---|"EaseOut"
---|"Linear"
---|{ CubicBezier: number[] }

---@alias FreetypeLoadTarget
---|"Normal"
---|"HorizontalLcd"
---|"Light"
---|"Mono"

---@alias SelectionMode
---|"Block"
---|"Cell"
---|"Line"
---|"Word"

---@alias SemanticZoneType
---|"Input"
---|"Output"
---|"Prompt"

---@alias Stretch
---|"Normal"
---|"Condensed"
---|"Expanded"
---|"ExtraCondensed"
---|"ExtraExpanded"
---|"SemiCondensed"
---|"SemiExpanded"
---|"UltraCondensed"
---|"UltraExpanded"

---@alias Style
---|"Normal"
---|"Italic"
---|"Oblique"

---@alias Weight
---|"Regular"
---|"Black"
---|"Bold"
---|"Book"
---|"DemiBold"
---|"DemiLight"
---|"ExtraBlack"
---|"ExtraBold"
---|"ExtraLight"
---|"Light"
---|"Medium"
---|"Thin"

---@class ScreenInformation
---@field name string
---@field x number
---@field y number
---@field height number
---@field width number
---@field max_fps? number

---@class KeyBindingBase
---@field key string
---@field action Action

---@class KeyBinding: KeyBindingBase
---@field mods string

---@class MouseEventInfo
---@field streak number
---@field button "Left"|"Right"|"Middle"|{ WheelDown: number }|{ WheelUp: number }

---@class MouseDownEvent
---@field Down MouseEventInfo

---@class MouseUpEvent
---@field Up MouseEventInfo

---@class MouseDragEvent
---@field Drag MouseEventInfo

---@alias MouseEvent
---|MouseDownEvent
---|MouseDragEvent
---|MouseUpEvent

---@class MouseBindingBase
---@field event MouseEvent
---@field action Action
---@field mouse_reporting? boolean
---@field alt_screen? boolean|"Any"

---@class MouseBinding: MouseBindingBase
---@field mods string
