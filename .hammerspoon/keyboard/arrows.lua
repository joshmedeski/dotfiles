local function altShift(bindKey, mapKey)
	hs.hotkey.bind({ "alt", "shift" }, bindKey, function()
		hs.eventtap.keyStroke({}, mapKey)
	end)
end

altShift("h", "left")
altShift("j", "down")
altShift("k", "up")
altShift("l", "right")
