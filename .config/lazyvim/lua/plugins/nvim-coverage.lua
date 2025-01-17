return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>tc", "<cmd>CoverageToggle<cr>", desc = "Coverage in gutter" },
    { "<leader>tC", "<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>", desc = "Coverage summary" },
  },
  opts = {
    auto_reload = true,
    lang = {
      go = {
        coverage_file = vim.fn.getcwd() .. "/coverage.out",
      },
    },
  },
}
