return { -- Collection of various small independent plugins/modules

  -- TODO: combine with my config
  -- { -- Collection of various small independent plugins/modules
  --   'echasnovski/mini.nvim',
  --   config = function()
  --     -- Better Around/Inside textobjects
  --     --
  --     -- Examples:
  --     --  - va)  - [V]isually select [A]round [)]paren
  --     --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --     --  - ci'  - [C]hange [I]nside [']quote
  --     require('mini.ai').setup { n_lines = 500 }
  --
  --     -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --     --
  --     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  --     -- - sd'   - [S]urround [D]elete [']quotes
  --     -- - sr)'  - [S]urround [R]eplace [)] [']
  --     require('mini.surround').setup()
  --
  --     -- Simple and easy statusline.
  --     --  You could remove this setup call if you don't like it,
  --     --  and try some other statusline plugin
  --     local statusline = require 'mini.statusline'
  --     -- set use_icons to true if you have a Nerd Font
  --     statusline.setup { use_icons = vim.g.have_nerd_font }
  --
  --     -- You can configure sections in the statusline by overriding their
  --     -- default behavior. For example, here we set the section for
  --     -- cursor location to LINE:COLUMN
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     statusline.section_location = function()
  --       return '%2l:%-2v'
  --     end
  --
  --     -- ... and there is more!
  --     --  Check out: https://github.com/echasnovski/mini.nvim
  --   end,
  -- },
  'echasnovski/mini.nvim',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  event = 'VeryLazy',
  config = function()
    require('mini.surround').setup {
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - gsd'   - [S]urround [D]elete [']quotes
      -- - gsr)'  - [S]urround [R]eplace [)] [']
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    }

    -- require('mini.diff').setup()

    require('mini.ai').setup {
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]parenthen
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      n_lines = 500,
    }

    -- require('mini.basics').setup {
    --   options = {
    --     -- Basic options ('number', 'ignorecase', and many more)
    --     basic = true,
    --
    --     -- Extra UI features ('winblend', 'cmdheight=0', ...)
    --     extra_ui = false,
    --
    --     -- Presets for window borders ('single', 'double', ...)
    --     win_borders = 'default',
    --   },
    --
    --   -- Mappings. Set to `false` to disable.
    --   mappings = {
    --     -- Basic mappings (better 'jk', save with Ctrl+S, ...)
    --     basic = true,
    --
    --     -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
    --     -- Supply empty string to not create these mappings.
    --     option_toggle_prefix = '',
    --
    --     -- Window navigation with <C-hjkl>, resize with <C-arrow>
    --     windows = true,
    --
    --     -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    --     move_with_alt = true,
    --   },
    --
    --   -- Autocommands. Set to `false` to disable
    --   autocommands = {
    --     -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
    --     basic = true,
    --
    --     -- Set 'relativenumber' only in linewise and blockwise Visual mode
    --     relnum_in_visual_mode = false,
    --   },
    --
    --   -- Whether to disable showing non-error feedback
    --   silent = false,
    -- }

    -- require('mini.bracketed').setup()

    -- require('mini.comment').setup {
    --   options = {},
    -- }

    -- require('mini.git').setup()
    -- vim.keymap.set({ 'n', 'x' }, '<leader>gs', '<CMD>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at cursor' })

    -- require('mini.icons').setup()

    -- require('mini.move').setup()

    -- require('mini.operators').setup {
    --   -- Each entry configures one operator.
    --   -- `prefix` defines keys mapped during `setup()`: in Normal mode
    --   -- to operate on textobject and line, in Visual - on selection.
    --
    --   -- Evaluate text and replace with output
    --   evaluate = {
    --     prefix = 'g=',
    --
    --     -- Function which does the evaluation
    --     func = nil,
    --   },
    --
    --   -- Exchange text regions
    --   exchange = {
    --     prefix = 'gx',
    --
    --     -- Whether to reindent new text to match previous indent
    --     reindent_linewise = true,
    --   },
    --
    --   -- Multiply (duplicate) text
    --   multiply = {
    --     prefix = 'gm',
    --
    --     -- Function which can modify text before multiplying
    --     func = nil,
    --   },
    --
    --   -- Replace text with register
    --   replace = {
    --     prefix = 'gr',
    --
    --     -- Whether to reindent new text to match previous indent
    --     reindent_linewise = true,
    --   },
    --
    --   -- Sort text
    --   sort = {
    --     prefix = 'go',
    --
    --     -- Function which does the sort
    --     func = nil,
    --   },
    -- }

    -- require('mini.statusline').setup {
    --   use_icons = vim.g.have_nerd_font,
    --   content = {
    --     active = function()
    --       -- Show macro recording message in statusline
    --       -- From https://www.reddit.com/r/neovim/comments/1djkwif/show_recording_macros_message_in_ministatusline
    --       local check_macro_recording = function()
    --         if vim.fn.reg_recording() ~= '' then
    --           return 'Recording @' .. vim.fn.reg_recording()
    --         else
    --           return ''
    --         end
    --       end
    --
    --       local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
    --       local git = MiniStatusline.section_git { trunc_width = 40 }
    --       local diff = MiniStatusline.section_diff { trunc_width = 75 }
    --       local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
    --       -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
    --       local filename = MiniStatusline.section_filename { trunc_width = 140 }
    --       local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
    --       local location = MiniStatusline.section_location { trunc_width = 200 }
    --       local search = MiniStatusline.section_searchcount { trunc_width = 75 }
    --       local macro = check_macro_recording()
    --
    --       return MiniStatusline.combine_groups {
    --         { hl = mode_hl, strings = { mode } },
    --         { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
    --         '%<', -- Mark general truncate point
    --         { hl = 'MiniStatuslineFilename', strings = { filename } },
    --         '%=', -- End left alignment
    --         { hl = 'MiniStatuslineFilename', strings = { macro } },
    --         { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    --         { hl = mode_hl, strings = { search, location } },
    --       }
    --     end,
    --   },
    -- }

    -- require('mini.tabline').setup {
    --   format = function(buf_id, label)
    --     local suffix = vim.bo[buf_id].modified and '* ' or ''
    --     return MiniTabline.default_format(buf_id, label) .. suffix
    --   end,
    -- }
  end,
}
