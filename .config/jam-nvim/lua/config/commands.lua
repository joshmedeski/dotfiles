vim.cmd([[command! -nargs=0 GoToCommand :Telescope commands]])
vim.cmd([[command! -nargs=0 GoToFile :Telescope smart_open]])
vim.cmd([[command! -nargs=0 Grep :Telescope live_grep]])
vim.cmd([[command! -nargs=0 SmartGoTo :Telescope smart_goto]])
