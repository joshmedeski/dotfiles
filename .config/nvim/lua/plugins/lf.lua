return {
  "lmburns/lf.nvim",
  cmd = "Lf",
  dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
  opts = {
    winblend = 0,
    highlights = { NormalFloat = { guibg = "NONE" } },
    border = "single", -- border kind: single double shadow curved
    escape_quit = true,
  },
  keys = {
    { "<leader>ff", "<cmd>Lf<cr>", desc = "NeoTree" },
  },
}
