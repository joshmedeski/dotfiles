return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "marilari88/neotest-vitest",
    "fredrikaverpil/neotest-golang",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {},
      ["neotest-golang"] = {
        -- FIX: doesn't work when in subdirectory of repo (ex: "sesh/v2/namer")
        args = { "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out" },
      },
    },
  },
  keys = {
    { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach to the nearest test" },
    { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Toggle Test Summary" },
    { "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle Test Output Panel" },
    { "<leader>tp", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop the nearest test" },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Test Summary" },
    { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run the nearest test" },
    {
      "<leader>tT",
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      desc = "Run test the current file",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ suite = false, strategy = "dap" })
      end,
      desc = "Debug nearest test",
    },
  },
}
