return {
  'ravitemer/mcphub.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
  },
  build = 'npm install -g mcp-hub@latest',
  config = function()
    require('mcphub').setup {
      ui = {
        window = {
          width = 0.9, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
          height = 0.9, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
          border = 'rounded', -- "none", "single", "double", "rounded", "solid", "shadow"
          relative = 'editor',
          winblend = 0,
          zindex = 50,
        },
        wo = { -- window-scoped options (vim.wo)
          winhl = 'Normal:NormalFloat,FloatBorder:MCPHubBorder',
        },
      },
    }
  end,
}
