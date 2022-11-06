-- ------------------------------------------------------------------------------
--
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

-- Additional Plugins
lvim.plugins = {
  { "christoomey/vim-tmux-navigator" },
  { "folke/lsp-colors.nvim" },
  { "sindrets/diffview.nvim", event = "BufRead" }, {
    "catppuccin/nvim",
  }, {
    'xiyaowong/nvim-transparent',
    config = function()
      require("user.transparent")
    end
  }, {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({ global_settings = { mark_branch = true } })
    end
    -- }, { "github/copilot.vim",
    --   cmd = "Copilot",
    --   config = function()
    --     require("user.copilot")
    --   end
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
