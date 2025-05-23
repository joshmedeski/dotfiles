return {
  'ravitemer/mcphub.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
  },
  build = 'npm install -g mcp-hub@latest',
  config = function()
    require('mcphub').setup()
  end,
}
