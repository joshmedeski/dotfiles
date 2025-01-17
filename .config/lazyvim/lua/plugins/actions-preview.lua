return {
  "aznhe21/actions-preview.nvim",
  lazy = false,
  opts = {},
  config = function()
    vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
  end,
}
