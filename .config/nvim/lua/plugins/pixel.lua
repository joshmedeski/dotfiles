return {
  'bjarneo/pixel.nvim',
  priority = 1000,
  enabled = false,
  config = function()
    vim.opt.termguicolors = false
    vim.cmd.colorscheme 'pixel'
  end,
}
