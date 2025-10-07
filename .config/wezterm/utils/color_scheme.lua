local wezterm = require("wezterm")
local h = require("utils/helpers")
local M = {}

local function get_color_scheme()
	local color_schemes = {}
	local color_schemes_glob = os.getenv("HOME") .. "/c/iTerm2-Color-Schemes/wezterm/**"
	for _, v in ipairs(wezterm.glob(color_schemes_glob)) do
		local fileName = string.match(v, ".+/([^/]+)%.%w+$")
		table.insert(color_schemes, fileName)
	end
	local color_scheme = h.get_random_entry(color_schemes)
	return color_scheme
end

local mocha_scheme = wezterm.get_builtin_color_schemes()["Catppuccin Mocha"]
-- mocha_scheme.black = "#8289a2"
-- mocha_scheme.brightblack = "#8289a2"

local latte_scheme = wezterm.get_builtin_color_schemes()["Catppuccin Latte"]
-- latte_scheme.white = "#9fa5b6"
-- latte_scheme.brightwhite = "#9fa5b6"

M.get_color_scheme = function()
	-- TODO: integrate dynamic color switcher (with dark/light mode)
	-- return get_color_scheme()
	return h.is_dark() and "Catppuccin Mocha" or "Catppuccin Latte"
end

M.get_color_schemes = function()
	return {
		["Catppuccin Mocha"] = mocha_scheme,
		["Catppuccin Latte"] = latte_scheme,
	}
end

-- wezterm.on("user-var-changed", function(window, _, name, value)
-- 	wezterm.log_info("var", name, value)
-- 	local overrides = window:get_config_overrides() or {}
-- 	if string.match(name, "color_scheme") then
-- 		overrides.color_scheme = value
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)

return M
