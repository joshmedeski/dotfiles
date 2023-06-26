return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VeryLazy",
  ---@class CatppuccinOptions
  opts = {
    flavour = "mocha",
    transparent_background = true,
    integrations = {
      cmp = true,
      fidget = true,
      gitsigns = true,
      harpoon = true,
      lsp_trouble = true,
      mason = true,
      neotest = true,
      noice = true,
      notify = true,
      octo = true,
      telescope = {
        enabled = true,
      },
      treesitter = true,
      treesitter_context = false,
      symbols_outline = true,
      illuminate = true,
      which_key = true,
      barbecue = {
        dim_dirname = true,
        bold_basename = true,
        dim_context = false,
        alt_background = false,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    },
    -- color_overrides = {
    --   all = {
    --     surface0 = "#444444",
    --     surface1 = "#666666",
    --     surface2 = "#a3a7bc",
    --     surface3 = "#a3a7bc",
    --   },
    -- },
  },
  priority = 1000,
}
