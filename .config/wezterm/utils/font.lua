local wezterm = require("wezterm")
local h = require("utils/helpers")
local M = {}

M.get_font = function()
	local fonts = {
		"CommitMono",
		-- "Monaspace Argon",
		-- "Monaspace Krypton",
		-- "Monaspace Neon",
		-- "Monaspace Radon",
		-- "Monaspace Xenon",
	}
	local family = h.get_random_entry(fonts)
	return wezterm.font_with_fallback({ { family = family, weight = "Bold" }, { family = "Symbols Nerd Font Mono" } })
end

return M
