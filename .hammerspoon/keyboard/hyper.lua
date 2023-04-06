-- cSpell:words eventtap
local function hyper(key, keyEvent) -- cmd + ctrl + alt + shift + key
	hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, key, function()
		hs.eventtap.event.newKeyEvent(keyEvent, true):post()
	end)
end

hyper("h", "left")
hyper("j", "down")
hyper("k", "up")
hyper("l", "right")
hyper("n", "down")
hyper("p", "up")
