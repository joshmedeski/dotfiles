return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  event = 'VeryLazy',
  opts = {
    strategies = {
      chat = { adapter = 'copilot' },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
