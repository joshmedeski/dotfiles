return {
  "ThePrimeagen/harpoon",
  enabled = false,
  dependencies = "nvim-lua/plenary.nvim",
  opts = {
    global_settings = { mark_branch = true },
    width = vim.api.nvim_win_get_width(0) - 4,
  },
}
