return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
      },
    })
  end,
  keys = {
    -- { "<leader>t", "<cmd><cr>", desc = "" },
    { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach to the nearest test" },
    { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Toggle Test Summary" },
    { "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle Test Output Panel" },
    { "<leader>tp", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop the nearest test" },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Test Summary" },
    { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run the nearest test" },
    { "<leader>tT", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run test the current file" },
  },
}
