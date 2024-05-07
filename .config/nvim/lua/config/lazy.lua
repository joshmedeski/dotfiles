local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
vim.cmd([[command! -nargs=0 GoToCommand :Telescope commands]])
vim.cmd([[command! -nargs=0 GoToFile :Telescope smart_open]])
vim.cmd([[command! -nargs=0 GoToSymbol :Telescope lsp_document_symbols]])
vim.cmd([[command! -nargs=0 Grep :Telescope live_grep]])
vim.cmd([[command! -nargs=0 SmartGoTo :Telescope smart_goto]])
vim.o.cursorlineopt = "number"

require("lazy").setup({
  spec = {
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "catppuccin",
        defaults = { keymaps = true },
      },
    },

    -- TODO: create my own plugin configs?
    -- { "joshmedeski/medeskvim", import = "medeskivim.plugins" },
    -- { import = "medeskivim.plugins.vim-tmux-navigator" },

    -- my plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { "catppuccin" } },
  ui = { border = "single" },
  checker = { enabled = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
