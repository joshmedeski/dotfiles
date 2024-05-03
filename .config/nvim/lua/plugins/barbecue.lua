return {
  "utilyre/barbecue.nvim",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  name = "barbecue",
  enabled = true,
  event = "BufEnter",
  ---@type barbecue.Config
  opts = {
    -- TODO: trouble
    theme = "catppuccin-frappe", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    show_navic = false,
    symbols = {
      separator = "/",
    },
  },
}
