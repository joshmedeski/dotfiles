return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "NeoTree" },
    { "<leader>dx", "<cmd>DiffviewClose<cr>", desc = "NeoTree" },
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
}
