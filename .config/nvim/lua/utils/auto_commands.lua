--[[
 █████╗ ██╗   ██╗████████╗ ██████╗  ██████╗███╗   ███╗██████╗ ███████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝
███████║██║   ██║   ██║   ██║   ██║██║     ██╔████╔██║██║  ██║███████╗
██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║╚██╔╝██║██║  ██║╚════██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗██║ ╚═╝ ██║██████╔╝███████║
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝╚═╝     ╚═╝╚═════╝ ╚══════╝
See `:help lua-guide-autocommands`
--]]

vim.api.nvim_create_augroup('HelpSplitRight', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'HelpSplitRight',
  pattern = '*',
  callback = function()
    if vim.bo.buftype == 'help' then
      vim.cmd 'wincmd L'
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*tmux.conf' },
  command = "execute 'silent !tmux source <afile> --silent'",
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { 'yazi.toml' },
  command = "execute 'silent !yazi --clear-cache'",
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { 'config.fish' },
  command = "execute 'silent !source <afile> --silent'",
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { 'aerospace.toml' },
  command = "execute 'silent !aerospace reload-config'",
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufFilePre', 'BufRead' }, {
  pattern = { '*.mdx', '*.md' },
  callback = function()
    vim.cmd [[set filetype=markdown wrap linebreak nolist nospell]]
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead' }, {
  pattern = { '*.conf' },
  callback = function()
    vim.cmd [[set filetype=sh]]
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead' }, {
  -- https://ghostty.org/docs/config/reference
  pattern = { 'config' },
  callback = function()
    vim.cmd [[set filetype=toml]]
    vim.cmd [[LspStop]]
  end,
})

-- vim.api.nvim_create_autocmd('BufWritePost', {
--   pattern = { 'sketchybarrc' },
--   command = '!brew services restart sketchybar',
-- })
