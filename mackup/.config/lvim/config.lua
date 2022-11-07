--    88\                                                   88\
--    88 |                                                  \__|
--    88 |88\   88\ 888888$\   888888\   888888\ 88\    88\ 88\ 888888\8888\
--    88 |88 |  88 |88  __88\  \____88\ 88  __88\\88\  88  |88 |88  _88  _88\
--    88 |88 |  88 |88 |  88 | 888888$ |88 |  \__|\88\88  / 88 |88 / 88 / 88 |
--    88 |88 |  88 |88 |  88 |88  __88 |88 |       \88$  /  88 |88 | 88 | 88 |
--    88 |\888888  |88 |  88 |\888888$ |88 |        \$  /   88 |88 | 88 | 88 |
--    \__| \______/ \__|  \__| \_______|\__|         \_/    \__|\__| \__| \__|
-- ------------------------------------------------------------------------------
require("user.general").config()
require("user.mason").config()
require("user.emmet_ls").config()
require("user.telescope").config()
require("user.gitsigns").config()
require("user.lualine").config()
-- require("user.bufferline").config()
require("lspconfig.ui.windows").default_options.border = "rounded"

lvim.autocommands = {
  {
    "BufWinEnter", {
      pattern = { "*.mdx" },
      callback = function()
        vim.cmd [[set filetype=markdown]]
        vim.cmd [[set wrap]]
      end
    },
  }
}

lvim.builtin.which_key.mappings["0"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" }
lvim.builtin.which_key.mappings["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "File 1" }
lvim.builtin.which_key.mappings["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "File 2" }
lvim.builtin.which_key.mappings["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "File 3" }
lvim.builtin.which_key.mappings["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", "File 4" }
lvim.builtin.which_key.mappings["5"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", "File 5" }
lvim.builtin.which_key.mappings["6"] = { "<cmd>lua require('harpoon.ui').nav_file(6)<CR>", "File 6" }
lvim.builtin.which_key.mappings["7"] = { "<cmd>lua require('harpoon.ui').nav_file(7)<CR>", "File 7" }
lvim.builtin.which_key.mappings["f"] = { "<cmd>Lf<CR>", "Lf" }
lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo<CR>", "Goyo" }
lvim.builtin.which_key.mappings["n"] = { "<cmd>lua require('harpoon.mark').nav_next()<CR>", "Next" }
lvim.builtin.which_key.mappings["p"] = { "<cmd>lua require('harpoon.mark').nav_prev()<CR>", "Next" }

-- lvim.builtin.which_key.mappings["C"] = {
--   name = "Copilot",
--   C = { "<cmd>Copilot suggest<CR>", "Copilot" },
-- }

lvim.builtin.which_key.mappings["b"] = {
  name = "Buffers",
  b = { "<cmd>Telescope buffers<cr>", "Delete" },
  d = { "<cmd>bd<cr>", "Delete" },
  D = { "<cmd>BufferLineSortByDirectory<cr>", "Sort by directory" },
  e = { "<cmd>BufferLinePickClose<cr>", "Pick which buffer to close" },
  f = { "<cmd>Telescope buffers<cr>", "Find" },
  h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
  j = { "<cmd>BufferLinePick<cr>", "Jump" },
  l = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right" },
  L = { "<cmd>BufferLineSortByExtension<cr>", "Sort by language" },
  n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
  p = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
}


lvim.builtin.which_key.mappings["g"] = {
  name = "Git",
  -- g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
  g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
  j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
  k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
  l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
  p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
  r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
  R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
  s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
  u = {
    "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
    "Undo Stage Hunk",
  },
  o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
  C = {
    "<cmd>Telescope git_bcommits<cr>",
    "Checkout commit(for current file)",
  },
  d = {
    "<cmd>Gitsigns diffthis HEAD<cr>",
    "Git Diff",
  },
}


lvim.builtin.which_key.mappings["'"] = {
  name = "Harpoon",
  ["'"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add File" },
  ["n"] = { "<cmd>lua require('harpoon.mark').nav_next()<CR>", "Next" },
  ["p"] = { "<cmd>lua require('harpoon.mark').nav_prev()<CR>", "Prev" },
}

-- Additional Plugins
lvim.plugins = {
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-surround" },
  { "folke/lsp-colors.nvim" },
  { "voldikss/vim-floaterm" },
  { "wakatime/vim-wakatime" },
  { "rktjmp/lush.nvim" },
  { "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup()
    end,
  },
  { "sindrets/diffview.nvim",
    event = "BufRead",
    config = function()
      require("user.diffview").config()
    end,
  },
  {
    "lmburns/lf.nvim",
    config = function()
      require("user.lf").config()
    end,
    requires = { "plenary.nvim", "toggleterm.nvim" }
  },
  {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
  },
  { "catppuccin/nvim" },
  {
    'xiyaowong/nvim-transparent',
    config = function()
      require("user.transparent")
    end
  }, {
    "junegunn/goyo.vim",
    cmd = "Goyo",
    config = function()
      require("user.goyo").config()
    end
  }, {
    "ThePrimeagen/harpoon",
    requires = { "plenary.nvim" },
    config = function()
      require("harpoon").setup({
        global_settings = { mark_branch = true },
        menu = { width = 60 }
      })
    end
  }, {
    "github/copilot.vim",
    cmd = "Copilot",
    config = function()
      require("user.copilot")
    end
  }, {
    "folke/todo-comments.nvim",
    config = function()
      require("user.todo-comments")
    end
  }, {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function()
      require("user.trouble")
    end
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "!tmux source <afile>"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!brew services restart yabai"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".skhdrc" },
  command = "!brew services restart skhd"
})
