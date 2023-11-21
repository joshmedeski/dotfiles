return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {
    view = {
      use_icons = true,
      default = {
        layout = "diff2_horizontal",
        winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
      },
    },
  },
  keys = {
    { "<leader>gdd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
    { "<leader>gdx", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
  },
}
