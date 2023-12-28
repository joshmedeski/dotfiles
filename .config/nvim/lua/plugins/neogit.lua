return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  cmd = "Neogit",
  opts = {
    signs = {
      hunk = { "", "" },
      item = { "", "" },
      section = { "", "" },
    },
    integrations = {
      diffview = true,
    },
  },
  keys = {
    { "<leader>gc", "<cmd>lua require('neogit').open({'commit'})<CR>", desc = "Git commit" },
    { "<leader>gg", "<cmd>lua require('neogit').open()<CR>", desc = "Git commit" },
  },
}
