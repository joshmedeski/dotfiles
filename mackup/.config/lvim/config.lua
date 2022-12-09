--    88\                                                   88\
--    88 |                                                  \__|
--    88 |88\   88\ 888888$\   888888\   888888\ 88\    88\ 88\ 888888\8888\
--    88 |88 |  88 |88  __88\  \____88\ 88  __88\\88\  88  |88 |88  _88  _88\
--    88 |88 |  88 |88 |  88 | 888888$ |88 |  \__|\88\88  / 88 |88 / 88 / 88 |
--    88 |88 |  88 |88 |  88 |88  __88 |88 |       \88$  /  88 |88 | 88 | 88 |
--    88 |\888888  |88 |  88 |\888888$ |88 |        \$  /   88 |88 | 88 | 88 |
--    \__| \______/ \__|  \__| \_______|\__|         \_/    \__|\__| \__| \__|
-- ------------------------------------------------------------------------------

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
  },
  {
    'folke/zen-mode.nvim',
    config = function()
      require('user.zen-mode')
    end
  },
  {
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
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function()
      require("user.trouble")
    end
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   -- event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup {
  --         plugin_manager_path = os.getenv "LUNARVIM_RUNTIME_DIR" .. "/site/pack/packer",
  --       }
  --     end, 100)
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua" },
  --   config = function()
  --     require("copilot_cmp").setup {
  --       formatters = {
  --         insert_text = require("copilot_cmp.format").remove_existing,
  --       },
  --     }
  --   end,
  -- },
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

vim.cmd [[
augroup clearcmdline
  autocmd!
  function! Echo_Nothing(timer)
    echo ''
  endfunction
  autocmd CmdlineLeave * call timer_start(1000, 'Echo_Nothing')
augroup END
]]

require("user.general").config()
require("user.mason").config()
require("user.emmet_ls").config()
reload "user.telescope"
require("user.gitsigns").config()
reload "user.lualine"
-- require("user.bufferline").config()
require("lspconfig.ui.windows").default_options.border = "rounded"

lvim.autocommands = {
  {
    "BufWinEnter", {
      pattern = { "*.mdx" },
      callback = function()
        vim.cmd [[set filetype=markdown]]
        vim.cmd [[set wrap linebreak]]
      end
    },
  }
}

for i = 1, 5 do
  local cmd = "<cmd>lua require('harpoon.ui').nav_file(" .. i .. ")<CR>"
  local name = "File " .. i
  lvim.builtin.which_key.mappings[tostring(i)] = { cmd, name }
end

lvim.builtin.which_key.mappings["0"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" }
lvim.builtin.which_key.mappings["f"] = { "<cmd>Lf<CR>", "Lf" }
lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo<CR>", "Goyo" }

lvim.builtin.which_key.mappings["n"] = { "<cmd>bn<cr>", "Previous buffer" }
lvim.builtin.which_key.mappings["p"] = { "<cmd>bp<cr>", "Next buffer" }

-- lvim.builtin.which_key.mappings["C"] = {
--   name = "Copilot",
--   C = { "<cmd>Copilot suggest<CR>", "Copilot" },
-- }

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
  -- g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
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
  -- C = {
  --   "<cmd>Telescope git_bcommits<cr>",
  --   "Checkout commit(for current file)",
  -- },
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
