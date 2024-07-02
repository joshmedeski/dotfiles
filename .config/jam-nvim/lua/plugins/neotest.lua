return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    {
      "fredrikaverpil/neotest-golang",
      dependencies = {
        "leoluz/nvim-dap-go",
      },
    },
  },
  opts = {
    adapters = {
      require("neotest-vitest"),
      require("neotest-golang"),
    },
  },
  -- config = function()
  --   require("neotest").setup({
  --     adapters = {
  --       require("neotest-vitest"),
  --       require("neotest-golang"),
  --     }
  --   })
  -- end,
}
