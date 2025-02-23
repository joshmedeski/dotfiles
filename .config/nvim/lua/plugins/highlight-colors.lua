return {
  'brenoprata10/nvim-highlight-colors',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    enable_tailwind = true,
    enable_var_usage = true,
  },
  config = function(_, opts)
    require('nvim-highlight-colors').setup(opts)
    Snacks.toggle({
      name = 'Highlight Colors',
      get = function()
        return require('nvim-highlight-colors').is_active()
      end,
      set = function(_)
        require('nvim-highlight-colors').toggle()
      end,
    }):map [[\H]]
  end,
}
