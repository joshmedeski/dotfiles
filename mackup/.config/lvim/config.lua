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

lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo<CR>", "Goyo" }
lvim.builtin.which_key.mappings["f"] = { "<cmd>Lf<CR>", "Lf" }
-- lvim.builtin.which_key.mappings["C"] = {
--   name = "Copilot",
--   C = { "<cmd>Copilot suggest<CR>", "Copilot" },
-- }
lvim.builtin.which_key.mappings["'"] = {
  name = "Harpoon",
  ["'"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add File" },
  ["n"] = { "<cmd>lua require('harpoon.mark').nav_next()<CR>", "Next" },
  ["p"] = { "<cmd>lua require('harpoon.mark').nav_prev()<CR>", "Prev" },
}
lvim.builtin.which_key.mappings["0"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" }
lvim.builtin.which_key.mappings["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "File 1" }
lvim.builtin.which_key.mappings["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "File 2" }
lvim.builtin.which_key.mappings["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "File 3" }

lvim.builtin.which_key.mappings["b"] = {
  name = "Buffers",
  f = { "<cmd>Telescope buffers<cr>", "Find" },
  j = { "<cmd>BufferLinePick<cr>", "Jump" },
  n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
  p = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
  -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
  e = {
    "<cmd>BufferLinePickClose<cr>",
    "Pick which buffer to close",
  },
  h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
  l = {
    "<cmd>BufferLineCloseRight<cr>",
    "Close all to the right",
  },
  D = {
    "<cmd>BufferLineSortByDirectory<cr>",
    "Sort by directory",
  },
  L = {
    "<cmd>BufferLineSortByExtension<cr>",
    "Sort by language",
  },
}

-- Additional Plugins
lvim.plugins = {
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-surround" },
  { "folke/lsp-colors.nvim" },
  { "voldikss/vim-floaterm" },
  { "wakatime/vim-wakatime" },
  { "sindrets/diffview.nvim", event = "BufRead" },
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
        global_settings = {
          mark_branch = true
        },
        menu = {
          width = 60
        }
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
  pattern = { "config.lua" },
  command = "LvimReload"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!brew services restart yabai"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".skhdrc" },
  command = "!brew services restart skhd"
})
