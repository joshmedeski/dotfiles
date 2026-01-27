return {
  'rachartier/tiny-inline-diagnostic.nvim',
  enabled = false,
  event = 'VeryLazy',
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup {
      preset = 'minimal',
      transparent_bg = false,
      hi = {
        error = 'DiagnosticError',
        warn = 'DiagnosticWarn',
        info = 'DiagnosticInfo',
        hint = 'DiagnosticHint',
        arrow = 'NonText',
        background = 'CursorLine',
        mixing_color = 'None',
      },
      options = {
        show_source = {
          enabled = true,
        },
      },
    }
    vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
  end,
}
