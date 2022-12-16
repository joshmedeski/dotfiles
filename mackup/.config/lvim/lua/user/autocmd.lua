-- Autocommands (https://neovim.io/doc/user/autocmd.html)

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "!tmux source <afile>"
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!brew services restart yabai"
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".skhdrc" },
  command = "!brew services restart skhd"
})

lvim.autocommands = {
  {
    "BufWinEnter", {
      pattern = { "*.mdx" },
      callback = function()
        vim.cmd [[set filetype=markdown]]
        vim.cmd [[set wrap linebreak]]
      end
    },
  }
}
