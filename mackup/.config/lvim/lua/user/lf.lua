local M = {}

M.config = function()
  require("lf").setup({
    winblend = 0,
    highlights = {
      NormalFloat = { guibg = "NONE" }
    },
    border = "rounded", -- border kind: single double shadow curved
    height = 0.60, -- height of the *floating* window
    width = 0.80, -- width of the *floating* window
    escape_quit = true, -- map escape to the quit command (so it doesn't go into a meta normal mode)
  })
  vim.api.nvim_set_keymap("n", "<mapping>", "<cmd>lua require('lf').start()<CR>", { noremap = true })
end

return M
