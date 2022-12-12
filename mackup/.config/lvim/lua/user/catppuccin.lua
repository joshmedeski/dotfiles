require("catppuccin").setup({
  -- latte, frappe, macchiato, mocha
  flavour = "mocha",
  -- flavour = "latte",
  -- flavour = "frappe",
  -- flavour = "macchiato",
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true,
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {
    all = {
      surface1 = "#a3a7bc",
      surface2 = "#a3a7bc",
    }
  },
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = false,
    telescope = true,
    notify = false,
    mini = false,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
