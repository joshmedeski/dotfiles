--[[
 ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ ███████╗
██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝
██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║███████╗
██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║╚════██║
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝███████║
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
--]]

-- telescope pickers
vim.cmd [[command! -nargs=0 Commit :Neogit commit]]
vim.cmd [[command! -nargs=0 GoToCommand :Telescope commands]]
vim.cmd [[command! -nargs=0 GoToFile :lua vim.defer_fn(function() require('fff').find_files() end, 100)]]
vim.cmd [[command! -nargs=0 GoToSymbol :Telescope lsp_document_symbols]]
vim.cmd [[command! -nargs=0 Grep :Telescope live_grep]]
vim.cmd [[command! -nargs=0 SmartGoTo :Telescope smart_goto]]
vim.cmd [[command! -nargs=0 Zen :lua Snacks.zen()]]
vim.cmd [[command! -nargs=0 FindAndReplace :lua require('grug-far').open()]]

-- TODO: implement command for grabbing window id for aerospace
-- aerospace list-apps | fzf --delimiter '|' --with-nth '{3}{2}' --accept-nth '{2}' | sed 's/^[ ]*//' | tr -d '\n'
-- pass this fzf command into a neovim fzf picker

-- snacks picker
-- vim.cmd [[command! -nargs=0 GoToCommand :lua Snacks.picker.command_history()]]
-- vim.cmd [[command! -nargs=0 GoToFile :lua Snacks.picker.smart()]]
-- vim.cmd [[command! -nargs=0 GoToSymbol :lua Snacks.picker.lsp_symbols()]]
-- vim.cmd [[command! -nargs=0 Grep :lua Snacks.picker.grep()]]
