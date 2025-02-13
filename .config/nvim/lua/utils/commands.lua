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
vim.cmd [[command! -nargs=0 GoToFile :Telescope smart_open]]
vim.cmd [[command! -nargs=0 GoToSymbol :Telescope lsp_document_symbols]]
vim.cmd [[command! -nargs=0 Grep :Telescope live_grep]]
vim.cmd [[command! -nargs=0 SmartGoTo :Telescope smart_goto]]
vim.cmd [[command! -nargs=0 Zen :lua Snacks.zen()]]

-- snacks picker
-- vim.cmd [[command! -nargs=0 GoToCommand :lua Snacks.picker.command_history()]]
-- vim.cmd [[command! -nargs=0 GoToFile :lua Snacks.picker.smart()]]
-- vim.cmd [[command! -nargs=0 GoToSymbol :lua Snacks.picker.lsp_symbols()]]
-- vim.cmd [[command! -nargs=0 Grep :lua Snacks.picker.grep()]]
