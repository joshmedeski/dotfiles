---@meta

--- alias to help identify types that should actually be any
---@alias ANY any

---@alias FormatItemAttribute { Underline: "None" | "Single" | "Double" | "Curly" | "Dotted" | "Dashed" } | { Intensity: "Normal" | "Bold" | "Half" } | { Italic: boolean }
---@alias FormatItemReset "ResetAttributes" Reset all attributes to default.
---@alias FormatItem { Attribute: FormatItemAttribute } | { Foreground: ColorSpec } | { Background: ColorSpec } | { Text: string } | FormatItemReset

---@alias CopyToTarget "Clipboard" | "PrimarySelection" | "ClipboardAndPrimarySelection"

---@alias SshBackend "Ssh2" | "LibSsh"

---@alias Modifiers "NONE" | "SHIFT" | "ALT" | "CTRL" | "SUPER" | "LEFT_ALT" | "RIGHT_ALT" | "LEFT_CTRL" | "RIGHT_CTRL" | "LEFT_SHIFT" | "RIGHT_SHIFT" | "ENHANCED_KEY"
---| "LEADER" This is a virtual modifier used by wezterm

---@alias WebGpuPowerPreference "LowPower" | "HighPerformance"

---@alias FontRasterizerSelection "FreeType" Only Option

---@alias FontShaperSelection
---| "Allsorts" very preliminary support
---| "Harfbuzz" default

---@alias FontLocatorSelection
---| "FontConfig" Use fontconfig APIs to resolve fonts (!macos, posix systems)
---| "Gdi" Use GDI on win32 systems
---| "CoreText" Use CoreText on macOS
---| "ConfigDirsOnly" Use only the font_dirs configuration to locate fonts

---@alias FrontEndSelection
---| "OpenGL"
---| "WebGpu" default
---| "Software"

---@alias DisplayPixelGeometry
---| "RGB" default
---| "BGR"

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

---@alias BoldBrightening "No" | "BrightAndBold" | "BrightOnly"

---@alias ExitBehavior "Close" | "CloseOnCleanExit" | "Hold"
--TODO: describe

---@alias ExitBehaviorMessaging "Verbose" | "Brief" | "Terse" | "None"
--TODO: describe

---@alias IntegratedTitleButton "Hide" | "Maximize" | "Close"

---@alias IntegratedTitleButtonAlignment "Right" | "Left"

---@alias IntegratedTitleButtonStyle "Windows" | "Gnome" | "MacOsNative"

---@alias WindowDecorations "NONE" | "TITLE" | "RESIZE" | "TITLE | RESIZE"

---@alias Points string
-- A value expressed in points, where 72 points == 1 inch.

---@alias Pixels string | number
-- A value expressed in raw pixels

---@alias Percent string
-- A value expressed in terms of a fraction of the maximum
-- value in the same direction.  For example, left padding
-- of 10% depends on the pixel width of that element.
-- The value is 1.0 == 100%.  It is possible to express
-- eg: 2.0 for 200%.

---@alias Cells string
-- A value expressed in terms of a fraction of the cell
-- size computed from the configured font size.
-- 1.0 == the cell size.

---@alias Dimension Points | Pixels | Percent | Cells

---@class TabBarColor
-- The color of the background area for the tab
---@field bg_color string
-- The color of the text for the tab
---@field fg_color string
-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
-- label shown for this tab.
-- The default is "Normal"
---@field intensity "Half" | "Normal" | "Bold"
-- Specify whether you want "None", "Single" or "Double" underline for
-- label shown for this tab.
-- The default is "None"
---@field underline "None" | "Single" | "Double"
-- Specify whether you want the text to be italic (true) or not (false)
-- for this tab.  The default is false.
---@field italic boolean
-- Specify whether you want the text to be rendered with strikethrough (true)
-- or not for this tab.  The default is false.
---@field strikethrough boolean

---@class TabBarColors
---@field background string The text color to use when the attributes are reset to default
---@field inactive_tab_edge string
---@field inactive_tab_edge_hover string

---@alias AnsiColors "Black" | "Maroon" | "Green" | "Olive" | "Navy" | "Purple" | "Teal" | "Silver" | "Grey" | "Red" | "Lime" | "Yellow" | "Blue" | "Fuchsia" | "Aqua" | "White"

---@alias AC "AnsiColor"

---@alias CO "Color"

---@alias ColorSpec table<AC, AnsiColors> | table<CO, string>

---@class Palette
---@field foreground string The text color to use when the attributes are reset to default
---@field background string  The background color to use when the attributes are reset to default
---@field cursor_fg string  The color of the cursor
---@field cursor_bg string  The color of the cursor
---@field cursor_border string  The color of the cursor
---@field selection_fg string  The color of selected text
---@field selection_bg string  The color of selected text
---@field ansi string[]  A list of 8 colors corresponding to the basic ANSI palette
---@field brights string[] A list of 8 colors corresponding to bright versions of the
---@field indexed { [number]: string } A map for setting arbitrary colors ranging from 16 to 256 in the color palette
---@field scrollbar_thumb string The color of the "thumb" of the scrollbar; the segment that represents the current viewable area
---@field split string The color of the split line between panes
---@field visual_bell string The color of the visual bell. If unspecified, the foreground color is used instead.
---@field compose_cursor string The color to use for the cursor when a dead key or leader state is active
---@field copy_mode_active_highlight_fg ColorSpec
---@field copy_mode_active_highlight_bg ColorSpec
---@field copy_mode_inactive_highlight_fg ColorSpec
---@field copy_mode_inactive_highlight_bg ColorSpec
---@field quick_select_label_fg ColorSpec
---@field quick_select_label_bg ColorSpec
---@field quick_select_match_fg ColorSpec
---@field quick_select_match_bg ColorSpec
local Palette = {
	---@class TabBar :TabBarColors
	--  Configure the color and styling for the tab bar
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		background = "#0b0022",

		---@type TabBarColor
		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#2b2042",
			-- The color of the text for the tab
			fg_color = "#c0c0c0",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Normal",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "None",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = false,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},

		---@type TabBarColor
		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},

		---@type TabBarColor
		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},

		---@type TabBarColor
		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},

		---@type TabBarColor
		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
	},
}

---@alias FontWeight "Thin" | "ExtraLight" | "Light" | "DemiLight" | "Book" | "Regular" | "Medium" | "DemiBold" | "Bold" | "ExtraBold" | "Black" | "ExtraBlack"
---@alias FontStretch "UltraCondensed" | "ExtraCondensed" | "Condensed" | "SemiCondensed" | "Normal" | "SemiExpanded" | "Expanded" | "ExtraExpanded" | "UltraExpanded"
---@alias FontStyle "Normal" | "Italic" | "Oblique"
---@alias FreeTypeLoadTarget "Normal" | "Light" | "Mono" | "HorizontalLcd" | "VerticalLcd"
---@alias FreeTypeLoadFlags "DEFAUlT" | "NO_HINTING" | "NO_BITMAP" | "FORCE_AUTOHINT" | "MONOCHROME" | "NO_AUTOHINT"

--TODO: = add harfbuzz_features enum
--
---@alias Fonts {fonts: FontAttributes[]}

---@class FontAttributes
---@field is_fallback boolean
---@field is_synthetic boolean
---@field harfbuzz_features string[]
---@field assume_emoji_presentation boolean
---@field scale number
local FontAttributes = {
	-- The font family name
	family = "JetBrains Mono",
	---@type FontWeight
	-- Whether the font should be a bold variant
	weight = "Regular",
	---@type FontStretch
	stretch = "Normal",
	---@type FontStyle
	-- Whether the font should be an italic variant
	style = "Normal",
	---@type FreeTypeLoadTarget
	freetype_load_target = "Normal",
	---@type FreeTypeLoadTarget
	freetype_render_target = "Normal",
	---@type FreeTypeLoadFlags
	-- you can combine the flags like 'NO_HINTING|MONOCHROME' -- probably would not want to
	freetype_load_flags = "DEFAUlT",
}

---@class WindowFrameConfig
---@field inactive_titlebar_bg RgbColor
---@field active_titlebar_bg RgbColor
---@field inactive_titlebar_fg RgbColor
---@field active_titlebar_fg RgbColor
---@field inactive_titlebar_border_bottom RgbColor
---@field active_titlebar_border_bottom RgbColor
---@field button_fg RgbColor
---@field button_bg RgbColor
---@field button_hover_fg RgbColor
---@field button_hover_bg RgbColor
---@field border_left_width Dimension
---@field border_right_width Dimension
---@field border_top_height Dimension
---@field border_bottom_height Dimension
---@field border_left_color RgbaColor
---@field border_right_color RgbaColor
---@field border_top_color RgbaColor
---@field border_bottom_color RgbaColor

---@class TabBarStyle
---@field new_tab String
---@field new_tab_hover String
---@field window_hide String
---@field window_hide_hover String
---@field window_maximize String
---@field window_maximize_hover String
---@field window_close String
---@field window_close_hover String

---@class HyperlinkRule
---@field regex Regex
---@field format String
---@field highlight usize

---@class SerialDomain
---@field name String
-- The name of this specific domain.  Must be unique amongst
-- all types of domain in the configuration file.
---@field port String
-- Specifies the serial device name.
-- On Windows systems this can be a name like `COM0`.
-- On posix systems this will be something like `/dev/ttyUSB0`.
-- If omitted, the name will be interpreted as the port.
---@field baud usize
-- Set the baud rate.  The default is 9600 baud.

---@class GpuInfo
---@field name String
---@field device_type String
---@field backend String
---@field driver String
---@field driver_info String
---@field vendor u32
---@field device u32

---@class UnixDomain
---@field name String
-- The name of this specific domain.  Must be unique amongst
-- all types of domain in the configuration file.
---@field socket_path PathBuf
-- The path to the socket.  If unspecified, a resonable default
-- value will be computed.
---@field connect_automatically bool
-- If true, connect to this domain automatically at startup
---@field no_serve_automatically bool
-- If true, do not attempt to start this server if we try and fail to
-- connect to it.
---@field serve_command String[]
-- If we decide that we need to start the server, the command to run
-- to set that up.  The default is to spawn:
-- `wezterm-mux-server --daemonize`
-- but it can be useful to set this to eg:
-- `wsl -e wezterm-mux-server --daemonize` to start up
-- a unix domain inside a wsl container.
---@field proxy_command String[]
-- Instead of directly connecting to `socket_path`
-- spawn this command and use its stdin/stdout in place of
-- the socket.
---@field skip_permissions_check bool
-- If true, bypass checking for secure ownership of the socket_path.  This is not recommended on a multi-user system, but is useful for example when running the server inside a WSL container but with the socket on the host NTFS volume.
---@field read_timeout Duration
---@field write_timeout Duration
---@field local_echo_threshold_ms u64
-- Don't use default_local_echo_threshold_ms() here to disable the predictive echo for Unix domains by default.
---@field overlay_lag_indicator bool
-- Show time since last response when waiting for a response. It is recommended to use <https://wezfurlong.org/wezterm/config/lua/pane/get_metadata.html#since_last_response_ms> instead.

---@class LeaderKey :KeyNoAction
---@field timeout_milliseconds u64

---@class HyperLinkRule
---@field regex string The regular expression to match
---@field format string Controls which parts of the regex match will be used to form the link. Must have a prefix: signaling the protocol type (e.g., https:/mailto:), which can either come from the regex match or needs to be explicitly added. The format string can use placeholders like $0, $1, $2 etc. that will be replaced with that numbered capture group. So, $0 will take the entire region of text matched by the whole regex, while $1 matches out the first capture group. In the example below, mailto:$0 is used to prefix a protocol to the text to make it into an URL.
---@field highlight number? Specifies the range of the matched text that should be highlighted/underlined when the mouse hovers over the link. The value is a number that corresponds to a capture group in the regex. The default is 0, highlighting the entire region of text matched by the regex. 1 would be the first capture group, and so on.

---@class BatteryInfo
---@field state_of_charge number The battery level expressed as a number between 0.0 (empty) and 1.0 (full)
---@field vendor string Battery manufacturer name, or "unknown" if not known.
---@field model string The battery model string, or "unknown" if not known.
---@field serial string The battery serial number, or "unknown" if not known.
---@field time_to_full number? If charging, how long until the battery is full (in seconds). May be nil.
---@field time_to_empty number? If discharing, how long until the battery is empty (in seconds). May be nil.
---@field state "Charging" | "Discharging" | "Empty" | "Full" | "Unknown"

---@class WeztermPlugin
---@field require fun(url: string): any

---@class AugmentCommandPaletteReturn
---@field brief string The brief description for the entry
---@field doc string? A long description that may be shown after the entry, or that may be used in future versions of wezterm to provide more information about the command.
---@field action KeyAssignment The action to take when the item is activated. Can be any key assignment action.
---@field icon NerdFont? optional Nerd Fonts glyph name to use for the icon for the entry. See wezterm.nerdfonts for a list of icon names.

---@alias CallbackWindowPane fun(window: Window, pane: Pane)
---@alias EventAugmentCommandPalette fun(event: "augment-command-palette", callback: fun(window: Window, pane: Window): AugmentCommandPaletteReturn): nil This event is emitted when the Command Palette is shown. It's purpose is to enable you to add additional entries to the list of commands shown in the palette. This hook is synchronous; calling asynchronous functions will not succeed.
---@alias EventBell fun(event: "augment-command-palette", callback: CallbackWindowPane) The bell event is emitted when the ASCII BEL sequence is emitted to a pane in the window. Defining an event handler doesn't alter wezterm's handling of the bell; the event supplements it and allows you to take additional action over the configured behavior.
---@alias EventFormatTabTitle fun(event: "format-tab-title", callback: fun(tab: MuxTabObj, tabs: MuxTabObj[], panes: Pane[], config: Config, hover: boolean, max_width: number): string) TODO
---@alias EventFormatWindowTitle fun(event: "format-window-title", callback: fun(window: Window, pane: Pane, tabs: MuxTabObj[], panes: Pane[], config: Config)) TODO
---@alias EventNewTabButtonClick fun(event: "new-tab-button-click", callback: fun(window: Window, pane: Pane, button: "Left" | "Middle" | "Right", default_action: KeyAssignment): nil) TODO
---@alias EventOpenUri fun(event: "open-uri", callback: fun(window: Window, pane: Pane, uri: string): nil) TODO
---@alias EventUpdateRightStatus fun(event: "update-right-status", callback: CallbackWindowPane) TODO
---@alias EventUpdateStatus fun(event: "update-status", callback: CallbackWindowPane) TODO
---@alias EventUserVarChanged fun(event: "user-var-changed", callback: fun(window: Window, pane: Pane, name: string, value: string): nil) TODO
---@alias EventWindowConfigReloaded fun(event: "window-config-reloaded", callback: CallbackWindowPane) TODO
---@alias EventWindowFocusChanged fun(event: "window-focus-changed", callback: CallbackWindowPane) TODO
---@alias EventWindowResized fun(event: "window-resized", callback: CallbackWindowPane) TODO
---@alias EventCustom fun(event: string, callback: fun(...: any): nil) A custom declared function

---@alias CursorShape "SteadyBlock" | "BlinkingBlock" | "SteadyUnderline" | "BlinkingUnderline" | "SteadyBar" | "BlinkingBar"
---@alias CursorVisibility "Visible" | "Hidden"

---@class StableCursorPosition
---@field x number The horizontal cell index.
---@field y number the vertical stable row index.
---@field shape CursorShape The CursorShape enum value.
---@field visibility CursorVisibility The CursorVisibility enum value.

---@class LinearGradientOrientation
---@field angle number

---@class RadialGradientOrientation
---@field radius? number
---@field cx? number
---@field cy? number

---@class Gradient
---@field colors string[]
---@field orientation? 'Horizontal' | 'Vertical' | { Linear: LinearGradientOrientation } | { Radial: RadialGradientOrientation }
---@field interpolation? 'Linear' | 'Basis' | 'CatmullRom'
---@field blend? 'Rgb' | 'LinearRgb' | 'Hsv' | 'Oklab'
---@field noise? number
---@field segment_size? number
---@field segment_smoothness? number

---@class ColorSchemeMetaData
---@field name? string
---@field author? string
---@field origin_url? string
---@field wezterm_version? string
---@field aliases? string[]

---@alias ActionCallback fun(win: Window, pane: Pane, ...: any): (nil | false)
---@alias AnsiColor 'Black' | 'Maroon' | 'Green' | 'Olive' | 'Navy' | 'Purple' | 'Teal' | 'Silver' | 'Grey' | 'Red' | 'Lime' | 'Yellow' | 'Blue' | 'Fuchsia' | 'Aqua' | 'White'
---@alias Appearance 'Light' | 'Dark' | 'LightHighContrast' | 'DarkHighContrast'
---@alias Clipboard 'Clipboard' | 'PrimarySelection' | 'ClipboardAndPrimarySelection'
---@alias CopyMode 'AcceptPattern' | 'ClearPattern' | 'ClearSelectionMode' | 'Close' | 'CycleMatchType' | 'EditPattern' | 'MoveBackwardSemanticZone' | { MoveBackwardSemanticZoneOfType: SemanticZoneType } | 'MoveBackwardWord' | 'MoveDown' | 'MoveForwardSemanticZone' | { MoveForwardSemanticZoneOfType: SemanticZoneType } | 'MoveForwardWord' | 'MoveForwardWordEnd' | 'MoveLeft' | 'MoveRight' | 'MoveToEndOfLineContent' | 'MoveToScrollbackBottom' | 'MoveToScrollbackTop' | 'MoveToSelectionOtherEnd' | 'MoveToSelectionOtherEndHoriz' | 'MoveToStartOfLine' | 'MoveToStartOfLineContent' | 'MoveToStartOfNextLine' | 'MoveToViewportBottom' | 'MoveToViewportMiddle' | 'MoveToViewportTop' | 'MoveUp' | 'NextMatch' | 'NextMatchPage' | 'PriorMatch' | 'PriorMatchPage' | { SetSelectionMode: SelectionMode | 'SemanticZone' }
---@alias CursorStyle 'BlinkingBlock' | 'SteadyBlock' | 'BlinkingUnderline' | 'SteadyUnderline' | 'BlinkingBar' | 'SteadyBar'
---@alias Direction 'Left' | 'Right' | 'Up' | 'Down' | 'Next' | 'Prev'
---@alias EasingFunction 'Linear' | 'Ease' | 'EaseIn' | 'EaseInOut' | 'EaseOut' | { CubicBezier: number[] } | 'Constant'
---@alias FreetypeLoadTarget 'Normal' | 'Light' | 'Mono' | 'HorizontalLcd'
---@alias SelectionMode 'Cell' | 'Word' | 'Line' | 'Block'
---@alias SemanticZoneType 'Prompt' | 'Input' | 'Output'
---@alias Stretch 'UltraCondensed' | 'ExtraCondensed' | 'Condensed' | 'SemiCondensed' | 'Normal' | 'SemiExpanded' | 'Expanded' | 'ExtraExpanded' | 'UltraExpanded'
---@alias Style 'Normal' | 'Italic' | 'Oblique'
---@alias Weight 'Thin' | 'ExtraLight' | 'Light' | 'DemiLight' | 'Book' | 'Regular' | 'Medium' | 'DemiBold' | 'Bold' | 'ExtraBold' | 'Black' | 'ExtraBlack'

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
---@field button 'Left' | 'Right' | 'Middle' | { WheelDown: number } | { WheelUp: number }

---@class MouseDownEvent
---@field Down MouseEventInfo

---@class MouseUpEvent
---@field Up MouseEventInfo

---@class MouseDragEvent
---@field Drag MouseEventInfo

---@alias MouseEvent MouseDownEvent | MouseUpEvent | MouseDragEvent

---@class MouseBindingBase
---@field event MouseEvent
---@field action Action
---@field mouse_reporting? boolean
---@field alt_screen? boolean | 'Any'

---@class MouseBinding: MouseBindingBase
---@field mods string
