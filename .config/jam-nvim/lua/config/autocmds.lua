local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*tmux.conf" },
    command = "execute 'silent !tmux source <afile> --silent'",
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "config.fish" },
    command = "execute 'silent !source <afile> --silent'",
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { ".yabairc" },
    command = "!yabai --restart-service",
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { ".skhdrc" },
    command = "!brew services restart skhd",
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


  local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
  })
end

return M
