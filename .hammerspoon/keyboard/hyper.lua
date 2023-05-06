-- cSpell:words eventtap

-- Map the hyper key to a key event
-- (cmd + ctrl + alt + shift + key)
-- @param key string the key to map
-- @param keyEvent string the key event to send
local function hyper(key, keyEvent)
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
