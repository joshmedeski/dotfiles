local wezterm = require("wezterm")
local M = {}

local DEFAULTS = {
	refresh_interval = 300,
	cache_dir = os.getenv("HOME") .. "/.cache/wezterm",
	cache_filename = "live-wallpaper.jpg",
}

local function is_dark(appearance)
	if appearance == nil then
		appearance = wezterm.gui.get_appearance()
	end
	return appearance:find("Dark")
end

local function get_random_entry(tbl)
	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

local function make_overlay(appearance, dark_opacity, light_opacity)
	dark_opacity = dark_opacity or 0.8
	light_opacity = light_opacity or 0.8
	return {
		source = {
			Gradient = {
				colors = { is_dark(appearance) and "#000000" or "#ffffff" },
			},
		},
		width = "100%",
		height = "100%",
		opacity = is_dark(appearance) and dark_opacity or light_opacity,
	}
end

local function make_wallpaper_layer(path, opacity)
	return {
		source = { File = { path = path } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = opacity or 1,
	}
end

local function get_random_wallpaper(glob_path)
	local glob = wezterm.glob(glob_path)
	local wallpaper = get_random_entry(glob)
	return make_wallpaper_layer(wallpaper)
end

local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function download(cache_dir, cache_path, tmp_path, url)
	wezterm.run_child_process({ "mkdir", "-p", cache_dir })
	local success, _, _ = wezterm.run_child_process({
		"curl",
		"-sfL",
		"-o",
		tmp_path,
		url,
	})
	if success then
		wezterm.run_child_process({ "mv", tmp_path, cache_path })
		wezterm.log_info("live-wallpaper: downloaded " .. url)
	else
		wezterm.log_error("live-wallpaper: failed to download " .. url)
	end
end

local function start_refresh_timer(interval, download_fn, callback)
	wezterm.time.call_after(interval, function()
		download_fn()
		if callback then
			callback()
		end
		start_refresh_timer(interval, download_fn, callback)
	end)
end

M.apply_to_config = function(config, opts)
	opts = opts or {}

	local wallpapers_glob = opts.wallpapers_glob

	local state = {
		dark_opacity = opts.dark_opacity or 0.85,
		light_opacity = opts.light_opacity or 0.65,
		last_appearance = nil,
	}

	-- Set initial background with random wallpaper from glob
	if wallpapers_glob then
		config.background = {
			get_random_wallpaper(wallpapers_glob),
			make_overlay(wezterm.gui.get_appearance(), state.dark_opacity, state.light_opacity),
		}
	end

	-- Live wallpaper setup
	if opts.live then
		local live = opts.live
		assert(live.url, "live-wallpaper: 'live.url' is required")

		local cache_dir = live.cache_dir or DEFAULTS.cache_dir
		local cache_filename = live.cache_filename or DEFAULTS.cache_filename
		local cache_path = cache_dir .. "/" .. cache_filename
		local tmp_path = cache_path .. ".tmp"
		local url = live.url
		local refresh_interval = live.refresh_interval or DEFAULTS.refresh_interval

		-- Override opacity when live wallpaper is active
		if live.dark_opacity then
			state.dark_opacity = live.dark_opacity
		end
		if live.light_opacity then
			state.light_opacity = live.light_opacity
		end

		local function do_download()
			download(cache_dir, cache_path, tmp_path, url)
		end

		-- Use cached image if available; skip blocking download at config load
		if file_exists(cache_path) then
			config.background = {
				make_wallpaper_layer(cache_path),
				make_overlay(wezterm.gui.get_appearance(), state.dark_opacity, state.light_opacity),
			}
		end

		local function update_all_windows()
			for _, window in ipairs(wezterm.gui.gui_windows()) do
				local overrides = window:get_config_overrides() or {}
				overrides.background = {
					make_wallpaper_layer(cache_path),
					(overrides.background and overrides.background[2])
						or make_overlay(
							wezterm.gui.get_appearance(),
							state.dark_opacity,
							state.light_opacity
						),
				}
				window:set_config_overrides(overrides)
			end
		end

		wezterm.on("gui-startup", function()
			-- Download once at startup (non-blocking from config load perspective)
			do_download()
			update_all_windows()
			-- Then refresh on timer
			start_refresh_timer(refresh_interval, do_download, update_all_windows)
		end)
	end

	-- Event: increase overlay opacity
	wezterm.on("increase-opacity", function(window)
		local overrides = window:get_config_overrides() or {}
		local appearance = window:get_appearance()

		if is_dark(appearance) then
			state.dark_opacity = math.min(1.0, state.dark_opacity + 0.01)
		else
			state.light_opacity = math.min(1.0, state.light_opacity + 0.01)
		end

		overrides.background = {
			(overrides.background and overrides.background[1]) or config.background[1],
			make_overlay(appearance, state.dark_opacity, state.light_opacity),
		}
		window:set_config_overrides(overrides)
	end)

	-- Event: decrease overlay opacity
	wezterm.on("decrease-opacity", function(window)
		local overrides = window:get_config_overrides() or {}
		local appearance = window:get_appearance()

		if is_dark(appearance) then
			if (state.dark_opacity - 0.01) < 0.0 then
				wezterm.log_info("Minimum dark opacity reached")
				return
			end
			state.dark_opacity = math.max(0.0, state.dark_opacity - 0.01)
		else
			if (state.light_opacity - 0.01) < 0.0 then
				wezterm.log_info("Minimum light opacity reached")
				return
			end
			state.light_opacity = math.max(0.0, state.light_opacity - 0.01)
		end

		overrides.background = {
			(overrides.background and overrides.background[1]) or config.background[1],
			make_overlay(wezterm.gui.get_appearance(), state.dark_opacity, state.light_opacity),
		}
		window:set_config_overrides(overrides)
	end)

	-- Event: pick random wallpaper from glob
	if wallpapers_glob then
		wezterm.on("random-wallpaper", function(window)
			local overrides = window:get_config_overrides() or {}

			overrides.background = {
				get_random_wallpaper(wallpapers_glob),
				(overrides.background and overrides.background[2])
					or make_overlay(wezterm.gui.get_appearance(), state.dark_opacity, state.light_opacity),
			}
			window:set_config_overrides(overrides)
		end)
	end

	-- Event: update overlay on appearance change
	wezterm.on("update-right-status", function(window)
		local appearance = window:get_appearance()

		-- Only update when appearance actually changes (dark/light switch)
		if appearance == state.last_appearance then
			return
		end
		state.last_appearance = appearance

		local overrides = window:get_config_overrides() or {}
		local current_background = overrides.background or config.background
		local wallpaper = current_background[1] or config.background[1]

		overrides.background = {
			wallpaper,
			make_overlay(appearance, state.dark_opacity, state.light_opacity),
		}

		window:set_config_overrides(overrides)
	end)

	-- Event: handle WALLPAPER user-var
	wezterm.on("user-var-changed", function(window, _, name, value)
		if name ~= "WALLPAPER" then
			return
		end
		local overrides = window:get_config_overrides() or {}
		overrides.background = {
			make_wallpaper_layer(value),
			make_overlay(window:get_appearance(), state.dark_opacity, state.light_opacity),
		}
		window:set_config_overrides(overrides)
	end)
end

return M
