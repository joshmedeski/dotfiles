-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")

vim.keymap.set("n", "*", "*zz")

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- folds
vim.keymap.set("n", "<leader>z", "<cmd>normal! zMzv<cr>", { desc = "Fold all others" })

-- lsp
vim.api.nvim_set_keymap(
  "n",
  "<leader><space>",
  "<cmd>lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true }
)

-- harpoon
-- vim.keymap.set("n", "<leader>'", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Add to Harpoon" })
-- vim.keymap.set("n", "<leader>0", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "Show Harpoon" })
-- vim.keymap.set("n", "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { desc = "Harpoon Buffer 1" })
-- vim.keymap.set("n", "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { desc = "Harpoon Buffer 2" })
-- vim.keymap.set("n", "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { desc = "Harpoon Buffer 3" })
-- vim.keymap.set("n", "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { desc = "Harpoon Buffer 4" })
-- vim.keymap.set("n", "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", { desc = "Harpoon Buffer 5" })
-- vim.keymap.set("n", "<leader>6", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", { desc = "Harpoon Buffer 6" })
-- vim.keymap.set("n", "<leader>7", "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", { desc = "Harpoon Buffer 7" })
-- vim.keymap.set("n", "<leader>8", "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", { desc = "Harpoon Buffer 8" })
-- vim.keymap.set("n", "<leader>9", "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", { desc = "Harpoon Buffer 9" })

-- buffer
vim.keymap.set(
  "n",
  "<leader>bb",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
  { desc = "Telescope buffers" }
)

-- line numbers
vim.keymap.set("n", "<leader>l", "<cmd>set number!<cr>", { desc = "Toggle line number" })

-- clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- gen
vim.keymap.set("v", "<leader>]", "<cmd>Gen<CR>")
vim.keymap.set("n", "<leader>]", "<cmd>Gen<CR>")

vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>") -- Sort highlighted text in visual mode with Control+S
vim.keymap.set("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>') -- Replace all instances of highlighted words
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move current line down
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv") -- Move current line up
