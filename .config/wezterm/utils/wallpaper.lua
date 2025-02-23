local wezterm = require("wezterm")
local h = require("utils/helpers")
local f = require("utils/files")
local M = {}

M.get_path_wallpaper = function(path)
	return {
		source = { File = { path = path } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = 1,
	}
end

M.get_wallpaper = function(dir)
	local glob = wezterm.glob(dir)
	local wallpaper = h.get_random_entry(glob)
	return {
		source = { File = { path = wallpaper } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = 1,
	}
end

M.get_gif_wallpaper = function(dir)
	local wallpapers = {}
	for _, v in ipairs(wezterm.glob(dir)) do
		if not string.match(v, "%.DS_Store$") then
			table.insert(wallpapers, v)
		end
	end
	local wallpaper = h.get_random_entry(wallpapers)
	return {
		source = { File = { path = wallpaper } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		vertical_align = "Middle",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = 0.32,
		-- speed = 1000,
	}
end

return M
