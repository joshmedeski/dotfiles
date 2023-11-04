local M = {}
local h = require("utils/helpers")

M.get_background = function(opacity)
	return {
		source = {
			Gradient = {
				colors = { h.is_dark() and "#000000" or "#ffffff" },
			},
		},
		width = "100%",
		height = "100%",
		opacity = opacity,
	}
end

return M
