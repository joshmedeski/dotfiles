--[[
 ██████╗██╗  ██╗ █████╗ ████████╗
██╔════╝██║  ██║██╔══██╗╚══██╔══╝
██║     ███████║███████║   ██║
██║     ██╔══██║██╔══██║   ██║
╚██████╗██║  ██║██║  ██║   ██║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
AI Chat in the editor is a feature that allows you to chat with an
AI assistant directly in your editor. This can be helpful for generating
code snippets, writing documentation, or even just having a conversation.

My Choice:
- [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) A Github Copilot chat interface

Alternatives:
- [avante.nvim](https://github.com/yetone/avante.nvim) Emulates Cursor AI IDE behavior
- [ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim) Effortless natural language generation

--]]

return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'main',
  cmd = 'CopilotChat',
  opts = function()
    return {
      auto_insert_mode = true,
      question_header = ' ',
      answer_header = ' ',
      window = {
        width = 0.4,
      },
    }
  end,
  keys = {
    { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
    { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
    {
      '<leader>ap',
      function()
        local actions = require 'CopilotChat.actions'
        require('CopilotChat.integrations.snacks').pick(actions.prompt_actions())
      end,
      desc = 'CopilotChat - Prompt actions',
    },
    {
      '<leader>aa',
      function()
        return require('CopilotChat').toggle()
      end,
      desc = 'Toggle (CopilotChat)',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ax',
      function()
        return require('CopilotChat').reset()
      end,
      desc = 'Clear (CopilotChat)',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aq',
      function()
        local input = vim.fn.input 'Quick Chat: '
        if input ~= '' then
          require('CopilotChat').ask(input)
        end
      end,
      desc = 'Quick Chat (CopilotChat)',
      mode = { 'n', 'v' },
    },
    -- Show prompts actions with telescope
    -- { '<leader>ap', M.pick 'prompt', desc = 'Prompt Actions (CopilotChat)', mode = { 'n', 'v' } },
  },
  config = function(_, opts)
    local chat = require 'CopilotChat'

    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'copilot-chat',
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
  end,
}
