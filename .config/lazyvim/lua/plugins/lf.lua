return {
  "lmburns/lf.nvim",
  cmd = "Lf",
  dependencies = {
    "akinsho/toggleterm.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    border = "single",
    escape_quit = true,
    highlights = { NormalFloat = { guibg = "NONE" } },
    winblend = 0,
  },
  keys = {
    { "<leader>ff", "<cmd>Lf<cr>", desc = "Lf" },
  },
}
