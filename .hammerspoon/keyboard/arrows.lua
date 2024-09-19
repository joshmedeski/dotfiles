local function alt(bindKey, mapKey)
	hs.hotkey.bind({ "alt" }, bindKey, function()
		hs.eventtap.keyStroke({}, mapKey)
	end)
end

alt("h", "left")
alt("j", "down")
alt("k", "up")
alt("l", "right")
