---Toogles focus of a given app
---@param appName string
local toggleFocus = function(appName)
	local app = hs.application.get(appName)
	if app then
		if app:isFrontmost() then
			app:hide()
		else
			app:activate()
		end
	else
		hs.application.launchOrFocus(appName)
	end
end

local bindings = {
	{ "a", "Wezterm" },
	{ "b", "MongoDB Compass" },
	{ "c", "" },
	{ "d", "Discord" },
	{ "e", "" },
	{ "f", "Finder" },
	{ "g", "Google Chrome" },
	{ "i", "" },
	-- NOTE: reserved for arrow keys
	-- { "h", "" },
	-- { "j", "" },
	-- { "k", "" },
	-- { "l", "" },
	{ "m", "Messages" },
	{ "n", "Notes" },
	{ "o", "Obsidian" },
	{ "p", "Music" },
	{ "q", "" },
	{ "r", "Reminders" },
	{ "s", "Obsidian" },
	{ "t", "" },
	{ "u", "" },
	{ "v", "DaVinci Resolve" },
	{ "w", "Arc" },
	{ "x", "" },
	{ "y", "" },
	{ "z", "zoom.us" },
}

for _, app in ipairs(bindings) do
	hs.hotkey.bind({ "alt" }, app[1], function()
		toggleFocus(app[2])
	end)
end
