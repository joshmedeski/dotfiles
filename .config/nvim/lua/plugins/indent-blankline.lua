return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = true,
  event = "LazyFile",
  opts = {
    indent = {
      char = "",
      tab_char = "",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  main = "ibl",
  -- init = function()
  --   local highlight = {
  --     "RainbowRed",
  --     "RainbowYellow",
  --     "RainbowBlue",
  --     "RainbowOrange",
  --     "RainbowGreen",
  --     "RainbowViolet",
  --     "RainbowCyan",
  --   }
  --
  --   local hooks = require("ibl.hooks")
  --   -- create the highlight groups in the highlight setup hook, so they are reset
  --   -- every time the colorscheme changes
  --   hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#1e1e2e" })
  --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#313244" })
  --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#45475a" })
  --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#585b70" })
  --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#6c7086" })
  --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#7f849c" })
  --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#9399b2" })
  --   end)
  --
  --   require("ibl").setup({ indent = { highlight = highlight } })
  -- end,
}
