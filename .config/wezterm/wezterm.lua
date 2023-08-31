local wezterm = require("wezterm")

local wez_dir = os.getenv("HOME") .. "/.config/wezterm"
local act = wezterm.action

local function multiple_actions(keys)
	local actions = {}
	for key in keys:gmatch(".") do
		table.insert(actions, act.SendKey({ key = key }))
	end
	table.insert(actions, act.SendKey({ key = "\n" }))
	return act.Multiple(actions)
end

local function key_table(mods, key, action)
	return {
		mods = mods,
		key = key,
		action = action,
	}
end

local function cmd_key(key, action)
	return key_table("CMD", key, action)
end

local function cmd_tmux_key(key, tmux_key)
	return cmd_key(
		key,
		act.Multiple({
			act.SendKey({ mods = "CTRL", key = "b" }),
			act.SendKey({ key = tmux_key }),
		})
	)
end

local config = {
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }),
	font_size = 18,

	window_padding = {
		left = 30,
		right = 30,
		top = 20,
		bottom = 10,
	},

	keys = {
		-- TODO: figure out how this works
		-- cmd_tmux_key("c", "\x20"),

		cmd_key(".", multiple_actions(":ZenMode")),
		cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
		cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
		cmd_key("f", multiple_actions(":Grep")),
		cmd_key("P", multiple_actions(":GoToCommand")),
		cmd_key("p", multiple_actions(":GoToFile")),

		cmd_tmux_key("1", "1"),
		cmd_tmux_key("2", "2"),
		cmd_tmux_key("3", "3"),
		cmd_tmux_key("4", "4"),
		cmd_tmux_key("5", "5"),
		cmd_tmux_key("6", "6"),
		cmd_tmux_key("7", "7"),
		cmd_tmux_key("8", "8"),
		cmd_tmux_key("9", "9"),
		cmd_tmux_key("e", "%"),
		cmd_tmux_key("E", '"'),
		cmd_tmux_key("n", "%"),
		cmd_tmux_key("N", '"'),
		cmd_tmux_key("G", "G"),
		cmd_tmux_key("g", "g"),
		cmd_tmux_key("k", "T"),
		cmd_tmux_key("l", "L"),
		cmd_tmux_key("o", "u"),
		cmd_tmux_key("t", "c"),
		cmd_tmux_key("w", "x"),
		cmd_tmux_key("z", "z"),
		cmd_tmux_key("{", "p"),
		cmd_tmux_key("}", "n"),

		cmd_key(
			"s",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				multiple_actions(":w"),
			})
		),
	},

	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	adjust_window_size_when_changing_font_size = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_decorations = "RESIZE",
}

local appearance = wezterm.gui.get_appearance()

if appearance:find("Dark") then
	config.color_scheme = "Catppuccin Mocha"
	config.background = {
		{
			source = {
				Gradient = {
					orientation = "Horizontal",
					colors = { "#00000C", "#000026", "#00000C" },
					interpolation = "CatmullRom",
					blend = "Rgb",
					noise = 0,
				},
			},
			width = "100%",
			height = "100%",
			opacity = 0.90,
		},
		{
			source = { File = { path = wez_dir .. "/blob_blue.gif", speed = 0.3 } },
			height = "100%",
			opacity = 0.50,
			hsb = {
				hue = 0.9,
				saturation = 0.9,
				brightness = 0.3,
			},
		},
		-- {
		-- 	source = { File = { path = wez_dir .. "/wallpapers/03-Blue_Purple_DM-4K.png" } },
		-- 	height = "100%",
		-- 	width = "100%",
		-- 	opacity = 0.30,
		-- },
	}
else
	config.color_scheme = "Catppuccin Latte"
	-- config.window_background_opacity = 0.9
	config.set_environment_variables = {
		THEME_FLAVOUR = "latte",
	}
end

return config
