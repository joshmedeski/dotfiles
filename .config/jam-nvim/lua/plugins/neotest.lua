return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
  },
  opts = {
    adapters = {
      require('neotest-vitest')
    }
  },
  -- config = function()
  --   require("neotest").setup({
  --     adapters = {
  --       require("neotest-vitest"),
  --     }
  --   })
  -- end,
}
