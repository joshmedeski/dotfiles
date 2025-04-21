return {
  'Bekaboo/dropbar.nvim',
  event = 'BufEnter',
  name = 'dropbar',
  opts = {
    bar = {
      sources = function()
        local sources = require 'dropbar.sources'
        return { sources.path }
      end,
    },
  },
}
