vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- colors
vim.opt.termguicolors = true

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- default position
vim.opt.scrolloff = 5

-- ex line
vim.o.ls = 0
vim.o.ch = 0

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true

-- gutter
vim.opt.number = true
vim.opt.relativenumber = true

-- indent
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- backup
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- spelling
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }

-- misc
vim.opt.guicursor = ""
vim.opt.isfname:append("@-@")
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.wrap = false
