require "lf".setup {
    winblend = 0,
    highlights = {
        NormalFloat = { guibg = "NONE" }
    },
    border = "rounded", -- border kind: single double shadow curved
    height = 0.70, -- height of the *floating* window
    width = 0.85, -- width of the *floating* window
    escape_quit = true, -- map escape to the quit command (so it doesn't go into a meta normal mode)
}

vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua require('lf').start()<CR>", { noremap = true, desc = 'Lf' })
