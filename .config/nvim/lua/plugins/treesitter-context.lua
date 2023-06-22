return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = { enable = true },
  keys = {
    { "[c", "<cmd>lua require('treesitter-context').go_to_context()<cr>", desc = "Attach to the nearest test" },
  },
}
