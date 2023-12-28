return {
  "neovim/nvim-lspconfig",
  depedencies = {
    {
      "dnlhc/glance.nvim",
      cmd = "Glance",
      ---@class GlanceOpts
      opts = {
        border = {
          enable = true,
          top_char = "―",
          bottom_char = "―",
        },
      },
    },
  },
  ---@class PluginLspOpts
  opts = {
    diagnostics = { virtual_text = true },
    servers = {
      yamlls = {
        settings = {
          yaml = { keyOrdering = false },
        },
      },
      graphql = {
        filetypes = { "graphql", "typescript", "typescriptreact" },
      },
    },
  },
  init = function()
    -- NOTE: https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "gD", "<CMD>Glance definitions<CR>" }
    keys[#keys + 1] = { "gM", "<CMD>Glance implementations<CR>" }
    keys[#keys + 1] = { "gR", "<CMD>Glance references<CR>" }
    keys[#keys + 1] = { "gY", "<CMD>Glance type_definitions<CR>" }
  end,
}
