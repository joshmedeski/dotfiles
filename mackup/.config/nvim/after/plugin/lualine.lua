local theme = require('lualine.themes.catppuccin')
theme.normal.c.bg = nil

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { 'error', 'warn', 'info', 'hint' },
  symbols = { error = " ", warn = " ", info = " ", hint = "﨧" },
  colored = true,
  update_in_insert = false,
  always_visible = false,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " },
  cond = hide_in_width
}

require('lualine').setup {
  options = {
    theme = theme,
    icons_enabled = true,
    always_divide_middle = false,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
  },

  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { diff, diagnostics },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename', 'location' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
}
