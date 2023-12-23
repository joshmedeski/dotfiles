return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  ---@class CatppuccinOptions
  opts = function()
    vim.cmd.colorscheme 'catppuccin'
    return {
      flavour = "mocha",
      transparent_background = true,
      color_overrides = { all = colors },
      custom_highlights = function(colors)
        return {
          CurSearch = { bg = colors.yellow },
          Diffchanged = { fg = colors.yellow },
          DiffChanged = { fg = colors.yellow },
        }
      end,
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
    }
  end,
}
