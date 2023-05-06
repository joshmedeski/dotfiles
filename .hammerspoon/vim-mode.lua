local VimMode = hs.loadSpoon("VimMode")
if VimMode ~= nil then
	local vim = VimMode:new()
	vim:enterWithSequence("jk")
	vim:disableForApp("Terminal")
	vim:disableForApp("Kitty")
	vim:disableForApp("Alacritty")
end
