return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'LazyFile',
  enabled = false,
  opts = function()
    local tsc = require 'treesitter-context'
    Snacks.toggle({
      name = 'Treesitter Context',
      get = tsc.enabled,
      set = function(state)
        if state then
          tsc.enable()
        else
          tsc.disable()
        end
      end,
    }):map '<leader>ut'
    return { mode = 'cursor', max_lines = 3 }
  end,
}
