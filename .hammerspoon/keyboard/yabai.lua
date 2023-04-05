-- cSpell:words yabai fullscreen unfloat
local yabai = "/opt/homebrew/bin/yabai "

local function alt(key, command)
	hs.hotkey.bind({ "alt" }, key, function()
		os.execute(yabai .. command)
	end)
end

local function altShift(key, command)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		os.execute(yabai .. command)
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

alt("f", "-m window --toggle zoom-fullscreen")
alt("r", "-m space --rotate 90")

-- # alt - s : yabai -m window --toggle
-- alt - s : yabai -m window --toggle sticky;\
--           yabai -m window --toggle topmost;\
--           yabai -m window --toggle pip
--
-- # toggle padding and gap
-- alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap
--
-- # float / unfloat window and center on screen
-- alt - t : yabai -m window --toggle float;\
--           yabai -m window --grid 4:4:1:1:2:2
--
-- # toggle window split type
-- alt - e : yabai -m window --toggle split
--
-- # toggle window split type
-- alt - m : yabai -m space --toggle mission-control
--
-- # balance size of windows
-- shift + alt - 0 : yabai -m space --balance
--
-- # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
-- shift + alt - n : yabai -m space --create && \
--                    index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
--                    yabai -m window --space "${index}" && \
--                    yabai -m space --focus "${index}"
--
-- # fast focus desktop
-- alt - tab : yabai -m space --focus recent
--
-- # send window to monitor and follow focus
-- shift + alt - n : yabai -m window --display next; yabai -m display --focus next
-- shift + alt - p : yabai -m window --display previous; yabai -m display --focus previous
-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'f4', function()
--   os.execute("/opt/homebrew/bin/yabai -m space --layout stack")
-- end)
