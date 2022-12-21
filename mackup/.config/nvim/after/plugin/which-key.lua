local wk = require("which-key")

wk.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 25, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 80 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  triggers = "auto", -- automatically setup triggers
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by deafult for Telescope
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
}

vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to clipboard' })

wk.register({
  -- Harpoon
  ["'"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add to Harpoon" },
  ["0"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Show Harpoon" },
  ["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Harpoon Buffer 1" },
  ["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Harpoon Buffer 2" },
  ["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Harpoon Buffer 3" },
  ["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "Harpoon Buffer 4" },
  ["5"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", "Harpoon Buffer 5" },
  ["6"] = { "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", "Harpoon Buffer 6" },
  ["7"] = { "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", "Harpoon Buffer 7" },
  ["8"] = { "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", "Harpoon Buffer 8" },
  ["9"] = { "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", "Harpoon Buffer 9" },

  ["/"] = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },

  b = {
    name = "buffer",
    b = { "<cmd>Telescope buffers<cr>", "Telescope" },
    d = { "<cmd>bd<cr>", "Delete" },
    j = { "<cmd>bn<cr>", "Next" },
    k = { "<cmd>bp<cr>", "Previous" },
    n = { "<cmd>bn<cr>", "Next" },
    p = { "<cmd>bp<cr>", "Previous" },
    s = {
      name = "Surroding",
      d = { "<cmd>%bd|e#|bd#<cr>|'<cr>", "Delete surrounding" }
    }
  },

  f = { "<cmd>Lf<cr>", "Lf" }, -- create a binding with label

  g = {
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
  },

  t = {
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
  },

  -- nmap <leader>% :source %<cr>
  -- nmap <leader><leader> <Plug>(coc-fix-current)
  -- nmap <leader>a <Plug>(coc-codeaction)
  -- nmap <leader>en <Plug>(coc-diagnostic-next)
  -- nmap <leader>ee <Plug>(coc-fix-current)
  -- nmap <leader>ep <Plug>(coc-diagnostic-prev)
  -- nmap <leader>f :Lfcd<cr>
  -- nmap <leader>gb <Plug>(coc-git-blame)<cr>
  -- nmap <leader>gc :CocCommand git.showCommit<cr>
  -- nmap <leader>gdc :CocCommand git.diffCached<cr>
  -- nmap <leader>gen <Plug>(coc-git-prevconflict)<cr>
  -- nmap <leader>gep <Plug>(coc-git-nextconflict)<cr>
  -- nmap <leader>h :HopWord<cr>
  -- nmap <leader>j :<C-u>CocNext<CR>
  -- nmap <leader>k :<C-u>CocPrev<CR>
  -- nmap <leader>l :HopLine<cr>
  -- nmap <leader>m :MaximizerToggle!<cr>
  -- nmap <leader>o :<C-u>CocList outline<cr>
}, { prefix = "<leader>" })
