-- cSpell:words yabai fullscreen unfloat
local function yabaiCommand(commands)
	for _, command in ipairs(commands) do
		os.execute("/opt/homebrew/bin/yabai -m " .. command)
	end
end

local function alt(key, commands)
	hs.hotkey.bind({ "alt" }, key, function()
		yabaiCommand(commands)
	end)
end

local function altShift(key, commands)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabaiCommand(commands)
	end)
end

local function altShiftNumber(number)
	altShift(number, { "window --space " .. number, "space --focus " .. number })
end

for i = 1, 9 do
	local numString = tostring(i)
	alt(numString, { "space --focus " .. numString })
	altShiftNumber(numString)
end

local homeRow = { h = "west", j = "south", k = "north", l = "east" }
for key, direction in pairs(homeRow) do
	alt(key, { "window --focus " .. direction })
	altShift(key, { "window --swap " .. direction })
end

alt("f", { "window --toggle zoom-fullscreen" })
alt("l", { "space --focus recent" })
alt("m", { "space --toggle mission-control" })
alt("p", { "window --toggle pip" })
alt("g", { "space --toggle padding", "space --toggle gap" })
alt("r", { "space --rotate 90" })
alt("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

alt("'", { "space --layout stack" })
alt(";", { "space --layout bsp" })
alt("tab", { "space --focus recent" })

-- FIX: get these working with non pad + and -
-- alt("pad+", { "space --create" })
-- alt("pad-", { "space --destroy" })
