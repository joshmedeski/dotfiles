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
}
