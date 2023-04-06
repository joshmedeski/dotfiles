-- cSpell:words eventtap
local function hyper(key, keyEvent)
	hs.hotkey.bind({ "alt", "shift", "cmd", "ctrl" }, key, function()
		hs.eventtap.event.newKeyEvent(keyEvent, true):post()
	end)
end

hyper("h", "left")
hyper("j", "down")
hyper("k", "up")
hyper("l", "right")
hyper("n", "down")
hyper("p", "up")
