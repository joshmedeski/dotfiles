return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmds = { 'Obsidian' },
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

    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    daily_notes = {
      folder = 'Periodic 🌄/Days 🌄',
      -- Optional, if you want to change the date format for the ID of daily notes.
      -- date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
    },

    disable_frontmatter = true,

    -- TODO: configure to my liking
    -- Optional, alternatively you can customize the frontmatter data.
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      -- local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- -- `note.metadata` contains any manually added fields in the frontmatter.
      -- -- So here we just make sure those fields are kept in the frontmatter.
      -- if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
      --   for k, v in pairs(note.metadata) do
      --     out[k] = v
      --   end
      -- end
      -- return out
    end,

    -- Optional, for templates (see below).
    templates = {
      subdir = 'Resources 🛠️/Templates 📋',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
    },

    follow_url_func = function(url)
      vim.fn.jobstart { 'open', url }
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = true,

    open = {
      func = function(uri)
        vim.ui.open(uri, { cmd = { 'open', '-a', '/Applications/Obsidian.app' } })
      end,
    },

    ui = {
      enable = true, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
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
