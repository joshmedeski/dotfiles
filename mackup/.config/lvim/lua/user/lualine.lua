local theme = require('lualine.themes.catppuccin')
theme.normal.c.bg = nil

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { 'error', 'warn', 'info', 'hint' },
  symbols = { error = " ", warn = " ", info = " " },
  colored = true,
  update_in_insert = false,
  always_visible = false,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = { "mode", colored = false }

lvim.builtin.lualine.options = {
  icons_enabled = true,
  theme = theme,
  component_separators = { left = "", right = "" },
  section_separators = { left = "", right = "" },
  disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
  always_divide_middle = true,
}
lvim.builtin.lualine.sections = {
  lualine_a = {},
  lualine_b = {},
  -- lualine_b = { mode },
  lualine_c = { diff, diagnostics },
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}
lvim.builtin.lualine.inactive_sections = {
  lualine_a = {},
  lualine_b = { mode },
  lualine_c = { 'filename' },
  lualine_x = { 'location' },
  lualine_y = {},
  lualine_z = {},
}
