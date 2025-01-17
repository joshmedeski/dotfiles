return {
  'nvim-lualine/lualine.nvim',
  -- TODO: ensure this is correct name
  dependencies = {
    { 'folke/trouble.nvim' },
    -- { 'bezhermoso/todos-lualine.nvim' },
    -- { 'folke/todo-comments.nvim' },
  },
  enabled = true,
  event = 'VeryLazy',
  opts = function(plugin)
    if plugin.override then
      require('lazyvim.util').deprecate('lualine.override', 'lualine.opts')
    end

    -- local todos = require('todos-lualine').component()

    -- local trouble = require("trouble")
    -- local trouble_symbols = trouble.statusline({
    --   mode = "lsp_document_symbols",
    --   groups = {},
    --   title = false,
    --   filter = { range = true },
    --   format = "{kind_icon}{symbol.name:Normal}",
    --   -- The following line is needed to fix the background color
    --   -- Set it to the lualine section you want to use
    --   hl_group = "lualine_c_normal",
    -- })

    -- local icons = require 'config.icons'

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn', 'info', 'hint' },
      symbols = {
        error = '🚨',
        hint = '🤔',
        info = '💁',
        warn = '🚧',
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
    }

    local diff = {
      'diff',
      symbols = {
        added = ' ' .. ' ',
        untracked = '󱀶 ' .. ' ',
        modified = ' ' .. ' ',
        removed = ' ' .. ' ',
      },
      colored = true,
      always_visible = false,
      source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end,
    }

    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == '' then
        return ''
      else
        return 'Recording @' .. recording_register
      end
    end

    return {
      options = {
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'lazy', 'alpha' } },
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          -- {
          --   "buffers",
          --   -- TODO: investigate this can be updated
          --   show_filename_only = false, -- Shows shortened relative path when set to false.
          --   -- hide_filename_extension = false, -- Hide filename extension when set to true.
          --   -- show_modified_status = true, -- Shows indicator when the buffer is modified.
          --   --
          --   -- mode = 0, -- 0: Shows buffer name
          --   -- -- 1: Shows buffer index
          --   -- -- 2: Shows buffer name + buffer index
          --   -- -- 3: Shows buffer number
          --   -- -- 4: Shows buffer name + buffer number
          --   --
          --   -- max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
          --   -- -- it can also be a function that returns
          --   -- -- the value of `max_length` dynamically.
          --   filetype_names = {
          --     TelescopePrompt = "Telescope",
          --   }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
          --   --
          --   -- -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
          --   -- use_mode_colors = true,
          --   --
          --   -- buffers_color = {
          --   --   -- Same values as the general color option can be used here.
          --   --   active = "lualine_{section}_normal", -- Color for active buffer.
          --   --   inactive = "lualine_{section}_inactive", -- Color for inactive buffer.
          --   -- },
          --   --
          --   -- symbols = {
          --   --   modified = " ●", -- Text to show when the buffer is modified
          --   --   alternate_file = "#", -- Text to show to identify the alternate file
          --   --   directory = "", -- Text to show when the buffer is a directory
          --   -- },
          -- },
          {
            'filename',
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            path = 1,

            -- shorting_target = 40,
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '🔒', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
          },
          -- { trouble_symbols.get, cond = trouble_symbols.has },
          diff,
          diagnostics,
          -- todos,
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'macro-recording', fmt = show_macro_recording } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
