-- NOTE: workaround for current bug
-- https://github.com/pwntester/octo.nvim/issues/466
vim.g.octo_viewer = "joshmedeski"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.syntax = "enable"
vim.o.breakindent = true
vim.o.ch = 0
vim.o.completeopt = "menuone,noselect"
vim.o.ls = 0
vim.o.mouse = "a"
vim.o.smartcase = true
vim.o.timeoutlen = 300
vim.o.updatetime = 250
vim.o.winblend = 0
vim.opt.backup = false
vim.opt.clipboard = ""
vim.opt.expandtab = true
vim.opt.guicursor = ""
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.number = false
vim.opt.scrolloff = 8 -- scroll page when cursor is 8 lines from top/bottom
vim.opt.shiftwidth = 2
vim.opt.showtabline = 0
vim.opt.sidescrolloff = 8 -- scroll page when cursor is 8 spaces from left/right
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = true
vim.wo.signcolumn = "yes"
