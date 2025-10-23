--[[
   
       |\__/,|   (`\
     _.|o o  |_   ) )
   -(((---(((--------

Soothing pastel theme
--]]

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Make sure to load this before all the other start plugins.

  dependencies = {
    {
      'cormacrelf/dark-notify',
      init = function()
        require('dark_notify').run()
        vim.api.nvim_create_autocmd('OptionSet', {
          pattern = 'background',
          callback = function()
            vim.cmd('Catppuccin ' .. (vim.v.option_new == 'light' and 'latte' or 'mocha'))
          end,
        })
      end,
    },
  },

  init = function()
    vim.cmd.colorscheme 'catppuccin'
  end,

  ---@class CatppuccinOptions
  opts = function()
    vim.g.catppuccin_debug = true
    -- TODO: generate dynamics colors
    return {
      flavour = 'mocha',
      term_colors = true,
      transparent_background = true,
      -- TODO: add sesh custom color scheme overrides 👀
      -- color_overrides = { all = theme_colors },
      custom_highlights = function(colors)
        return {
          Visual = { bg = colors.yellow, fg = colors.base },
          StatusLine = { fg = colors.overlay0 },
          CoverageCovered = { fg = colors.green },
          CoverageUncovered = { fg = colors.red },
          CurSearch = { bg = colors.yellow },
          FloatBorder = { bg = 'NONE' },
          GitSignsChange = { fg = colors.blue },
          LspHoverBorder = { bg = 'NONE' },
          LspHoverNormal = { bg = 'NONE' },
          NormalFloat = { bg = 'NONE' },
          RenderMarkdownCode = { bg = 'NONE' },

          FileName = { fg = colors.text, bold = true },
          FilePath = { fg = colors.overlay1, italic = true },

          Added = { fg = colors.green },
          Removed = { fg = colors.red },
          Changed = { fg = colors.yellow },
          Untracked = { fg = colors.pink },

          OilGitAdded = { fg = colors.green },
          OilGitDeleted = { fg = colors.red },
          OilGitModified = { fg = colors.yellow },
          OilGitRenamed = { fg = colors.yellow },
          OilGitUntracked = { fg = colors.pink },
          OilGitIgnored = { fg = colors.overlay0 },

          FFFGitSignDeleted = { fg = colors.red },
          FFFGitSignDeletedSelected = { fg = colors.red, bg = colors.surface0 },
          FFFGitSignIgnored = { fg = colors.overlay0 },
          FFFGitSignIgnoredSelected = { fg = colors.overlay0, bg = colors.surface0 },
          FFFGitSignModified = { fg = colors.yellow },
          FFFGitSignModifiedSelected = { fg = colors.yellow, bg = colors.surface0 },
          FFFGitSignRenamed = { fg = colors.yellow },
          FFFGitSignRenamedSelected = { fg = colors.yellow, bg = colors.surface0 },
          FFFGitSignStaged = { fg = colors.green },
          FFFGitSignStagedSelected = { fg = colors.green, bg = colors.surface0 },
          FFFGitSignUntracked = { fg = colors.pink },
          FFFGitSignUntrackedSelected = { fg = colors.pink, bg = colors.surface0 },

          PackageInfoOutdatedVersion = { fg = colors.yellow },
          PackageInfoUpToDateVersion = { fg = colors.green },
          PackageInfoInErrorVersion = { fg = colors.red },
        }
      end,
      integrations = {
        avante = {
          enabled = true,
          windows_sidebar_header_rounded = true,
        },
        blink_cmp = true,
        cmp = true,
        copilot_vim = true,
        dropbar = {
          enabled = true,
          color_mode = true,
        },
        fidget = true,
        gitsigns = true,
        lsp_trouble = true,
        mason = true,
        neotest = true,
        noice = true,
        notify = true,
        octo = true,
        telescope = true,
        treesitter = true,
        treesitter_context = false,
        snacks = true,
        illuminate = true,
        which_key = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
        },
      },
    }
  end,
}
