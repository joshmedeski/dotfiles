--  ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗ ██████╗ ███████╗   ███╗   ██╗██╗   ██╗██╗███╗   ███╗
-- ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝   ████╗  ██║██║   ██║██║████╗ ████║
-- ██║     ██║     ███████║██║   ██║██║  ██║█████╗  ██║     ██║   ██║██║  ██║█████╗     ██╔██╗ ██║██║   ██║██║██╔████╔██║
-- ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  ██║     ██║   ██║██║  ██║██╔══╝     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗╚██████╗╚██████╔╝██████╔╝███████╗██╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
--  ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
--  Neovim plugin emulating Claude Code's AI coding assistant, enabling WebSocket-based MCP protocol for integrated AI assistance.

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    terminal = {
      split_side = 'left', -- "left" or "right"
      split_width_percentage = 0.40,
      provider = 'snacks', -- "auto", "snacks", or "native"
      auto_close = true,
    },
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file (from oil)', ft = { 'oil' } },

    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
