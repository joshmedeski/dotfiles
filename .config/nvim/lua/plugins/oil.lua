return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view_options = { show_hidden = true },
  },
  init = function()
    vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
  end,
}
