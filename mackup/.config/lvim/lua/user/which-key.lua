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

lvim.builtin.which_key.mappings["t"] = {
  name = "Trouble",
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  j = { "<cmd>lua require('todo-comments').jump_next()<cr>", "Next TODO comment" },
  k = { "<cmd>lua require('todo-comments').jump_prev()<cr>", "Prev TODO comment" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  n = { "<cmd>lua require('todo-comments').jump_next()<cr>", "Next TODO comment" },
  p = { "<cmd>lua require('todo-comments').jump_prev()<cr>", "Prev TODO comment" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  t = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
  T = { "<cmd>TodoTrouble<cr>", "TODO Trouble" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
  -- jump to the next item, skipping the groups
  -- require("trouble").next({skip_groups = true, jump = true});

  -- jump to the previous item, skipping the groups
  -- require("trouble").previous({skip_groups = true, jump = true});

  g = {
    g = {
      "<cmd>lua require('trouble').first({skip_groups = true, jump = true})<cr>",
      "Jump to the first item, skipping the groups"
    },
  },
  G = {
    "<cmd>lua require('trouble').last({skip_groups = true, jump = true})<cr>",
    "Jump to the last item, skipping the groups"
  }
}

vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  { silent = true, noremap = true }
)
