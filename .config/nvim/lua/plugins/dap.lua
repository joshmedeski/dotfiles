return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },
    'leoluz/nvim-dap-go',
  },

  keys = {
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Breakpoint Condition',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle Breakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Run/Continue',
    },
    -- {
    --   '<leader>da',
    --   function()
    --     require('dap').continue { before = get_args }
    --   end,
    --   desc = 'Run with Args',
    -- },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Run to Cursor',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = 'Go to Line (No Execute)',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Step Into',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = 'Down',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = 'Up',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = 'Run Last',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Step Out',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_over()
      end,
      desc = 'Step Over',
    },
    {
      '<leader>dP',
      function()
        require('dap').pause()
      end,
      desc = 'Pause',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Toggle REPL',
    },
    {
      '<leader>ds',
      function()
        require('dap').session()
      end,
      desc = 'Session',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Terminate',
    },
    {
      '<leader>dw',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = 'Widgets',
    },
  },

  config = function()
    -- load mason-nvim-dap here, after all adapters have been setup
    -- if LazyVim.has 'mason-nvim-dap.nvim' then
    --   require('mason-nvim-dap').setup(LazyVim.opts 'mason-nvim-dap.nvim')
    -- end

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    -- for name, sign in pairs(LazyVim.config.icons.dap) do
    --   sign = type(sign) == 'table' and sign or { sign }
    --   vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
    -- end

    -- setup dap config by VsCode launch.json file
    -- local vscode = require 'dap.ext.vscode'
    -- local json = require 'plenary.json'
    -- vscode.json_decode = function(str)
    --   return vim.json.decode(json.json_strip_comments(str))
    -- end
  end,
}
