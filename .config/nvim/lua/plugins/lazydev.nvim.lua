return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    dependencies = {
      { 'DrKJeff16/wezterm-types', lazy = true },
    },
    opts_extend = { 'library' },
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        'lazy.nvim',
        { path = 'wezterm-types', mods = { 'wezterm' } },
        { path = '${3rd}/luassert/library', words = { 'assert' } },
        { path = '${3rd}/busted/library', words = { 'describe' } },
      },
    },
  },
}
