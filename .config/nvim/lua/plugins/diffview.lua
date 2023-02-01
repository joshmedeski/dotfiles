return {
  "sindrets/diffview.nvim",
  lazy = false,
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "NeoTree" },
    { "<leader>dx", "<cmd>DiffviewClose<cr>", desc = "NeoTree" },
  },
  opts = {
    view = {
      -- Configure the layout and behavior of different types of views.
      -- Available layouts:
      --  'diff1_plain'
      --    |'diff2_horizontal'
      --    |'diff2_vertical'
      --    |'diff3_horizontal'
      --    |'diff3_vertical'
      --    |'diff3_mixed'
      --    |'diff4_mixed'
      -- For more info, see ':h diffview-config-view.x.layout'.
      use_icons = true,
      default = {
        -- Config for changed files, and staged files in diff views.
        layout = "diff2_horizontal",
        winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
      },
    },
  },
}
