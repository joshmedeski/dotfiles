vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

vim.api.nvim_create_autocmd({
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.o.filetype = "markdown"
    vim.o.wrap = true
    vim.o.linebreak = true
    vim.o.list = false
  end,
}, { "BufNewFile", "BufFilePre", "BufRead" })
