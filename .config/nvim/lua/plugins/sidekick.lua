return {
  'folke/sidekick.nvim',
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
      },
    },
  },
  keys = {
    -- {
    --   '<tab>',
    --   function()
    --     -- if there is a next edit, jump to it, otherwise apply it if any
    --     if not require('sidekick').nes_jump_or_apply() then
    --       return '<Tab>' -- fallback to normal tab
    --     end
    --   end,
    --   expr = true,
    --   desc = 'Goto/Apply Next Edit Suggestion',
    -- },
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle { focus = true }
      end,
      desc = 'Sidekick Toggle CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle { name = 'claude', focus = true }
      end,
      desc = 'Sidekick Claude Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ag',
      function()
        require('sidekick.cli').toggle { name = 'grok', focus = true }
      end,
      desc = 'Sidekick Grok Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').select_prompt()
      end,
      desc = 'Sidekick Ask Prompt',
      mode = { 'n', 'v' },
    },
  },
}
