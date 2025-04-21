return {
  'salkin-mada/openscad.nvim',
  ft = 'openscad',
  dependencies = { 'L3MON4D3/LuaSnip', 'junegunn/fzf.vim' },
  config = function()
    vim.g.openscad_load_snippets = true
    require 'openscad'
  end,
}
