return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      enable_builtin = true,
      file_panel = { use_icons = true },
      mappings = {
        review_diff = {
          select_next_entry = { lhs = "<Tab>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<S-Tab>", desc = "move to next changed file" },
        },
      },
    })
    vim.treesitter.language.register("markdown", "octo")
  end,
  keys = {
    { "<leader>o", "<cmd>Octo<cr>", desc = "Octo" },
  },
}
