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
require("config.options")
require("config.keymaps")
require("config.commands")
require("config.autocmds")
require("config.treesitter").configure()
require("config.auto-complete").configure()
