--
--      ██╗ █████╗ ███╗   ███╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗
--      ██║██╔══██╗████╗ ████║    ████╗  ██║██║   ██║██║████╗ ████║
--      ██║███████║██╔████╔██║    ██╔██╗ ██║██║   ██║██║██╔████╔██║
-- ██   ██║██╔══██║██║╚██╔╝██║    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ╚█████╔╝██║  ██║██║ ╚═╝ ██║    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
--  ╚════╝ ╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
-- Minimalistic and efficient custom Neovim config by Josh Medeski

vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("utils.lazy").ensure_install()
require("lazy").setup({ import = "plugins" }, {})
vim.cmd.colorscheme 'catppuccin'
require("config.options").setup()
require("config.keymaps").setup()
require("config.commands").setup()
require("config.autocmds").setup()
require("config.treesitter").configure()
require("config.lsp").configure()
require("config.auto-complete").configure()
