return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = true,
  keys = {
    { "[c", "<cmd>lua require('treesitter-context').go_to_context()<cr>", desc = "Attach to the nearest test" },
  },
}
