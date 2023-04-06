-- cSpell:words yabai fullscreen unfloat
local yabai = "/opt/homebrew/bin/yabai "

local function yabaiCommand(cmd)
	os.execute(yabai .. cmd)
end

local function alt(key, cmd)
	hs.hotkey.bind({ "alt" }, key, function()
		yabaiCommand(cmd)
	end)
end

local function altShift(key, cmd)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabaiCommand(cmd)
	end)
end

local function altShiftNumber(number)
	altShift(number, "-m window --space " .. number .. "; " .. yabai .. "-m space --focus " .. number)
end

for i = 1, 9 do
	local numString = tostring(i)
	alt(numString, "-m space --focus " .. numString)
	altShiftNumber(numString)
end

local homeRow = { h = "west", j = "south", k = "north", l = "east" }
for key, direction in pairs(homeRow) do
	alt(key, "-m window --focus " .. direction)
	altShift(key, "-m window --swap " .. direction)
end

alt("'", "-m space --layout stack")
alt(";", "-m space --layout bsp")
alt("f", "-m window --toggle zoom-fullscreen")
alt("g", "-m space --toggle padding;" .. yabai .. "-m space --toggle gap")
alt("r", "-m space --rotate 90")
alt("t", "-m window --toggle float;\\" .. yabai .. "-m window --grid 4:4:1:1:2:2")
alt("tab", "-m space --focus recent")
