local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local theme = require('lualine.themes.catppuccin')
theme.normal.c.bg = nil

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "coc" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = true,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	fmt = function(str)
		return " " .. str
	end,
  cond = hide_in_width
}

local mode = {
	"mode",
	colored = false,
}

local location = {
	"location",
  fmt = function(str)
    return str .. " "
  end,
	padding = 0,
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = false,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { diff, diagnostics },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "filetype", "encoding" },
		lualine_z = { location },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
