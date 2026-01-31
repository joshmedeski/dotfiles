return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmds = { 'Obsidian' },
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/c/second-brain/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/c/second-brain/*.md',
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/c/second-brain',
      },
    },
    completion = {
      blink = true,
      nvim_cmp = false,
      min_chars = 2,
    },

    legacy_commands = false,

    -- TODO: replace with Keymaps autocommand
    -- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps
    -- mappings = {
    --   -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    --   ['gf'] = {
    --     action = function()
    --       return require('obsidian').util.gf_passthrough()
    --     end,
    --     opts = { noremap = false, expr = true, buffer = true },
    --   },
    --   -- Toggle check-boxes.
    --   ['<leader>ch'] = {
    --     action = function()
    --       return require('obsidian').util.toggle_checkbox()
    --     end,
    --     opts = { buffer = true },
    --   },
    --   -- Smart action depending on context, either follow link or toggle checkbox.
    --   ['<cr>'] = {
    --     action = function()
    --       return require('obsidian').util.smart_action()
    --     end,
    --     opts = { buffer = true, expr = true },
    --   },
    -- },

    daily_notes = {
      folder = 'Days',
    },

    -- Optional, for templates (see below).
    templates = {
      subdir = 'Resources 🛠️/Templates 📋',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
    },

    follow_url_func = function(url)
      vim.fn.jobstart { 'open', url }
    end,

    open = {
      func = function(uri)
        vim.ui.open(uri, { cmd = { 'open', '-a', '/Applications/Obsidian.app' } })
      end,
    },

    ui = {
      enable = true, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      -- Define how various check-boxes are displayed
      -- checkboxes = {
      --   -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      --   [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
      --   ['x'] = { char = '', hl_group = 'ObsidianDone' },
      --   ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
      --   ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
      --   -- Replace the above with this if you don't have a patched font:
      --   -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
      --   -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
      --
      --   -- You can also add more custom ones...
      -- },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      bullets = { char = '-', hl_group = 'ObsidianBullet' },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },
  },
}
