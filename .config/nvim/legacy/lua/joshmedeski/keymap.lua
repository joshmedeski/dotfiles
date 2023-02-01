vim.keymap.set(
  "n",
  "[g",
  "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>zt"
)
vim.keymap.set(
  "n",
  "]g",
  "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>zt"
)
