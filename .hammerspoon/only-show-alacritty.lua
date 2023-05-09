-- Hide all apps after terminal is selected
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(_, appName)
	if appName == "Alacritty" then
		hs.eventtap.keyStroke({ "cmd", "option" }, "h")
	end
end)
