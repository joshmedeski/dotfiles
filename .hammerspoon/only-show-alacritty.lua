-- Hide all apps after terminal is selected
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(_, appName)
	if appName == "Alacritty" then
		hs.eventtap.keyStroke({ "cmd", "option" }, "h")
	end

	-- hs.hotkey.bind({ "alt" }, "o", function()
	-- 	hs.notify.new({ title = "Yabai", informativeText = "Toggle opacity for " .. appName }):send()
	-- 	os.execute("$HOME/.config/bin/toggle-opacity " .. appName)
	-- end)
end)
