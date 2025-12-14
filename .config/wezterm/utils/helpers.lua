local wezterm = require("wezterm")
local M = {}

M.is_dark = function(appearance)
	if appearance == nil then
		appearance = wezterm.gui.get_appearance()
	end
	return appearance:find("Dark")
end

M.get_random_entry = function(tbl)
	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

return M
