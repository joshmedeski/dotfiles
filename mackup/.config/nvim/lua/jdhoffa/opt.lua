-- colors
vim.opt.termguicolors = true

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- gutter
vim.opt.number = true

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

-- misc
vim.opt.guicursor = ''
vim.opt.isfname:append("@-@")
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.wrap = false
