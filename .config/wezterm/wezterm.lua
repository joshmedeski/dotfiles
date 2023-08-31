local wezterm = require("wezterm")

local wezdir = os.getenv("HOME") .. "/.config/wezterm"
local act = wezterm.action

local function group_action(keys)
	local actions = {}
	for key in keys:gmatch(".") do
		table.insert(actions, act.SendKey({ key = key }))
	end
	table.insert(actions, act.SendKey({ key = "\n" }))
	return act.Multiple(actions)
end

local config = {
	window_background_opacity = 0.95,
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }),
	font_size = 18,
	adjust_window_size_when_changing_font_size = false,
	native_macos_fullscreen_mode = false,
	keys = {
		{
			key = "n",
			mods = "SHIFT|CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = "c",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL|SHIFT", key = "b" }),
				act.SendKey({ key = "\x20" }),
			}),
		},
		{
			key = "e",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = '"' }),
			}),
		},
		{
			key = "e",
			mods = "CMD|SHIFT",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }), -- prefix
				act.SendKey({ key = "%" }),
			}),
		},
		{
			key = "f",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ key = ":" }),
				act.SendKey({ key = "G" }),
				act.SendKey({ key = "r" }),
				act.SendKey({ key = "e" }),
				act.SendKey({ key = "p" }),
				act.SendKey({ key = "\n" }),
			}),
		},
		{
			key = "g",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }), -- prefix
				act.SendKey({ key = "g" }),
			}),
		},
		{
			key = "g",
			mods = "CMD|SHIFT",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }), -- prefix
				act.SendKey({ key = "G" }),
			}),
		},
		{
			key = "k",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }), -- prefix
				act.SendKey({ key = "T" }),
			}),
		},
		{
			key = "l",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }), -- prefix
				act.SendKey({ key = "L" }),
			}),
		},
		{
			key = "o",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }), -- prefix
				act.SendKey({ key = "u" }),
			}),
		},
		{
			key = "p",
			mods = "CMD",
			action = group_action(":GoToFile"),
		},
		{
			key = "p",
			mods = "CMD|SHIFT",
			action = group_action(":GoToCommand"),
		},
		{
			key = "s",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				act.SendKey({ key = ":" }),
				act.SendKey({ key = "w" }),
				act.SendKey({ key = "\n" }),
			}),
		},
		{
			key = "t",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "c" }),
			}),
		},
		{
			key = "w",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "x" }),
			}),
		},
		{
			key = "z",
			mods = "CMD",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "z" }),
			}),
		},
		{
			key = ".",
			mods = "CMD",
			action = group_action(":ZenMode"),
		},
	},
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 20,
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
}

local appearance = wezterm.gui.get_appearance()

if appearance:find("Dark") then
	config.color_scheme = "Catppuccin Mocha"
	config.background = {
		{
			source = {
				Gradient = {
					orientation = "Horizontal",
					colors = {
						"#00000C",
						"#000026",
						"#00000C",
					},
					interpolation = "CatmullRom",
					blend = "Rgb",
					noise = 0,
				},
			},
			width = "100%",
			height = "100%",
			opacity = 0.75,
		},
		{
			source = {
				File = { path = wezdir .. "/blob_blue.gif", speed = 0.3 },
			},
			repeat_x = "Mirror",
			height = "100%",
			opacity = 0.40,
			hsb = {
				hue = 0.9,
				saturation = 0.9,
				brightness = 0.3,
			},
		},
	}
else
	config.color_scheme = "Catppuccin Latte"
	config.window_background_opacity = 1
	config.set_environment_variables = {
		THEME_FLAVOUR = "latte",
	}
end

return config
