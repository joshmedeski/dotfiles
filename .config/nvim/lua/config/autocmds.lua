-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  command = "execute 'silent !yazi --clear-cache'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "config.fish" },
  command = "execute 'silent !source <afile> --silent'",
})

-- TODO: purge all yabai references?
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = { ".yabairc" },
--   command = "!yabai --restart-service",
-- })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = { ".skhdrc" },
--   command = "!brew services restart skhd",
-- })

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "aerospace.toml" },
  command = "!aerospace reload-config",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "sketchybarrc" },
  command = "!brew services restart sketchybar",
})

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
--   pattern = { "bubu" },
--   callback = function()
--     vim.cmd([[set filetype=javascript]])
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*.conf" },
  callback = function()
    vim.cmd([[set filetype=sh]])
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*.conf" },
  callback = function()
    vim.cmd([[set filetype=sh]])
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "config" },
  callback = function()
    vim.cmd([[set filetype=toml]])
  end,
})

vim.api.nvim_create_augroup("HelpSplitRight", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "HelpSplitRight",
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "help" then
      vim.cmd("wincmd L")
    end
  end,
})
