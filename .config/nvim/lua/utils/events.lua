vim.api.nvim_create_autocmd('User', {
  pattern = 'NeogitCommitComplete',
  callback = function()
    os.execute "open -g 'raycast://extensions/raycast/raycast/confetti'"
  end,
})
