lvim.builtin.which_key.mappings["'"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add to Harpoon" }
lvim.builtin.which_key.mappings["0"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" }
lvim.builtin.which_key.mappings["f"] = { "<cmd>Lf<CR>", "Lf" }
lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo<CR>", "Goyo" }
lvim.builtin.which_key.mappings["n"] = { "<cmd>bn<cr>", "Previous buffer" }
lvim.builtin.which_key.mappings["p"] = { "<cmd>bp<cr>", "Next buffer" }

for i = 1, 5 do
  local cmd = "<cmd>lua require('harpoon.ui').nav_file(" .. i .. ")<CR>"
  local name = "File " .. i
  lvim.builtin.which_key.mappings[tostring(i)] = { cmd, name }
end

lvim.builtin.which_key.mappings["b"] = {
  name = "Buffers",
  b = { "<cmd>Telescope buffers<cr>", "Telescope" },
  d = { "<cmd>bd<cr>", "Delete" },
  x = { "<cmd>bd<cr>", "Delete" },
  n = { "<cmd>bn<cr>", "Next" },
  p = { "<cmd>bp<cr>", "Previous" },
}

lvim.builtin.which_key.mappings["g"] = {
  name = "Git",
  j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>zt", "Next Hunk" },
  n = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>zt", "Next Hunk" },
  k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>zt", "Prev Hunk" },
  p = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>zt", "Prev Hunk" },
  l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
  x = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
  R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
  s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
  u = {
    "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
    "Undo Stage Hunk",
  },
  o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
  d = {
    "<cmd>Gitsigns diffthis HEAD<cr>",
    "Git Diff",
  },
}
