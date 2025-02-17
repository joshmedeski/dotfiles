return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown', 'Avante' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'Avante' },
    heading = {
      enabled = false,
    },
    code = {
      disable_background = true,
      style = 'normal',
      border = 'none',
    },
    dash = {
      icon = '󰇘',
    },
  },
}
