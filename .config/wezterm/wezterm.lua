--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local cs = require("utils/color_scheme")
local h = require("utils/helpers")
local k = require("utils/keys")

---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action
local live_wallpaper = dofile(os.getenv("HOME") .. "/.config/wezterm/plugins/wezterm-live-wallpaper/plugin/init.lua")

-- TODO: config saving / loading
-- local config_file_path = os.getenv("HOME") .. "/.wezterm_config"
--
-- local function save_config_to_file(config)
-- 	local file = io.open(config_file_path, "w")
-- 	if file then
-- 		file:write(wezterm.serde.json_encode(config))
-- 		file:close()
-- 	else
-- 		wezterm.log_error("Failed to open config file for writing")
-- 	end
-- end

-- Types come from https://github.com/DrKJeff16/wezterm-types

---@type Config
local config = {
	-- rendering
	front_end = "WebGpu",
	max_fps = 120,
	-- TODO: change this when unplugged?
	webgpu_power_preference = "HighPerformance", -- LowPower | HighPerformance

	-- text
	font_size = 20,
	line_height = 1.0,

	font = wezterm.font_with_fallback({
		"Maple Mono",
		-- "CommitMono",
		-- "DengXian",
		-- "Departure Mono",
		-- "GohuFont uni14 Nerd Font Mono",
		-- "Monaspace Argon",
		-- "Monaspace Krypton",
		-- "Monaspace Neon",
		-- "Monaspace Radon",
		-- "Monaspace Xenon",
		-- { family = "Apple Color Emoji" },
		-- { family = "Noto Color Emoji" }, -- default?
		-- NOTE: fallback font for Nerd Font icons
		{ family = "Symbols Nerd Font Mono" },
	}),

	color_schemes = cs.get_color_schemes(),
	color_scheme = cs.get_color_scheme(),

	window_padding = {
		left = 40,
		right = 40,
		top = 40,
		bottom = 15,
	},

	set_environment_variables = {
		BAT_THEME = h.is_dark(nil) and "Catppuccin-mocha" or "Catppuccin-latte",
		LC_ALL = "en_US.UTF-8",
		-- TODO: audit what other variables are needed
	},

	-- general options
	adjust_window_size_when_changing_font_size = false,
	debug_key_events = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	window_background_opacity = 0,
	macos_window_background_blur = 10,

	-- keys
	keys = {
		k.cmd_key(".", k.multiple_actions(":Zen")),
		k.cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
		k.cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
		k.cmd_key("f", k.multiple_actions(":Grep")),
		k.cmd_key("F", k.multiple_actions(":FindAndReplace")),
		k.cmd_key("w", act.SendKey({ mods = "CTRL", key = "q" })),
		-- k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
		-- k.cmd_key("i", k.multiple_actions(":SmartGoTo")),
		-- k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
		k.cmd_key("O", k.multiple_actions(":GoToSymbol")),
		k.cmd_key("P", k.multiple_actions(":GoToCommand")),
		k.cmd_key("p", k.multiple_actions(":GoToFile")),
		k.cmd_key("q", k.multiple_actions(":qa!")),

		k.cmd_key("r", act.EmitEvent("random-wallpaper")),
		k.cmd_key("UpArrow", act.EmitEvent("decrease-opacity")),
		k.cmd_key("DownArrow", act.EmitEvent("increase-opacity")),

		k.cmd_to_tmux_prefix("`", "n"),
		k.cmd_to_tmux_prefix("1", "1"),
		k.cmd_to_tmux_prefix("2", "2"),
		k.cmd_to_tmux_prefix("3", "3"),
		k.cmd_to_tmux_prefix("4", "4"),
		k.cmd_to_tmux_prefix("5", "5"),
		k.cmd_to_tmux_prefix("6", "6"),
		k.cmd_to_tmux_prefix("7", "7"),
		k.cmd_to_tmux_prefix("8", "8"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_to_tmux_prefix("a", "A"),
		k.cmd_to_tmux_prefix("b", "b"),
		k.cmd_to_tmux_prefix("C", "C"),
		k.cmd_to_tmux_prefix("d", "D"),
		k.cmd_to_tmux_prefix("e", "E"),
		k.cmd_to_tmux_prefix("G", "G"),
		k.cmd_to_tmux_prefix("g", "g"),
		k.cmd_to_tmux_prefix("j", "J"),
		k.cmd_to_tmux_prefix("k", "K"),
		k.cmd_to_tmux_prefix("K", "R"),
		k.cmd_to_tmux_prefix("l", "L"),
		k.cmd_to_tmux_prefix("n", "%"),
		k.cmd_to_tmux_prefix("N", '"'),
		k.cmd_to_tmux_prefix("o", "u"),
		k.cmd_to_tmux_prefix("T", "B"),
		k.cmd_to_tmux_prefix("t", "c"),
		k.cmd_to_tmux_prefix("W", "x"),
		k.cmd_to_tmux_prefix("Y", "Y"),
		k.cmd_to_tmux_prefix("Z", "Z"),
		k.cmd_to_tmux_prefix("z", "z"),

		k.cmd_ctrl_to_tmux_prefix("t", "J"),

		k.cmd_key(
			"R",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":source %"),
			})
		),

		k.cmd_key(
			"s",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":w"),
			})
		),

		{
			mods = "CMD|SHIFT",
			key = "}",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "{",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "p" }),
			}),
		},

		{
			mods = "CTRL",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},

		{
			mods = "CTRL|SHIFT",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},

		-- FIX: disable binding
		-- {
		-- 	mods = "CMD",
		-- 	key = "`",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },

		{
			mods = "CMD",
			key = "~",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "p" }),
			}),
		},
	},
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	wezterm.log_info("name", name)
	wezterm.log_info("value", value)

	-- TODO: remove?
	-- if name == "T_SESSION" then
	-- 	local session = value
	-- 	wezterm.log_info("is session", session)
	-- 	overrides.background = {
	-- 		w.set_tmux_session_wallpaper(value),
	-- 		{
	-- 			source = {
	-- 				Gradient = {
	-- 					colors = { "#000000" },
	-- 				},
	-- 			},
	-- 			width = "100%",
	-- 			height = "100%",
	-- 			opacity = 0.95,
	-- 		},
	-- 	}
	-- end

	if name == "COLOR_SCHEME" then
		print("COLOR_SCHEME")
		print(value)
		overrides.color_scheme = value
	end

	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
		else
			overrides.font_size = number_value
		end
	end

	-- NOTE: disabled for now
	-- if name == "DIFF_VIEW" then
	-- 	local incremental = value:find("+")
	-- 	local number_value = tonumber(value)
	-- 	if incremental ~= nil then
	-- 		while number_value > 0 do
	-- 			window:perform_action(wezterm.action.DecreaseFontSize, pane)
	-- 			number_value = number_value - 1
	-- 		end
	-- 		-- overrides.background = {
	-- 		-- 	w.set_nvim_wallpaper("Diffview.jpeg"),
	-- 		--
	-- 		-- 	{
	-- 		-- 		source = {
	-- 		-- 			Gradient = {
	-- 		-- 				colors = { "#000000" },
	-- 		-- 			},
	-- 		-- 		},
	-- 		-- 		width = "100%",
	-- 		-- 		height = "100%",
	-- 		-- 		opacity = 0.95,
	-- 		-- 	},
	-- 		-- }
	-- 	elseif number_value < 0 then
	-- 		window:perform_action(wezterm.action.ResetFontSize, pane)
	-- 		overrides.background = nil
	-- 		overrides.font_size = nil
	-- 	else
	-- 		overrides.font_size = number_value
	-- 	end
	-- end
	window:set_config_overrides(overrides)
end)

live_wallpaper.apply_to_config(config, {
	wallpapers_glob = os.getenv("HOME") .. "/.config/wezterm/wallpapers/**",
	dark_opacity = 0.85,
	light_opacity = 0.65,
	live = {
		url = "https://cdn.star.nesdis.noaa.gov/GOES16/ABI/CONUS/GEOCOLOR/2500x1500.jpg",
		refresh_interval = 300, -- seconds between refetches (default: 300)
		dark_opacity = 0.78,
		light_opacity = 0.6,
	},
})

return config
