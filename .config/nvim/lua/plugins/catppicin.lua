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
      transparent_background = true,
      -- TODO: add sesh custom color scheme overrides 👀
      -- color_overrides = { all = theme_colors },
      custom_highlights = function(colors)
        return {
          CurSearch = { bg = colors.yellow },
          GitSignsChange = { fg = colors.blue },
          CoverageCovered = { fg = colors.green },
          CoverageUncovered = { fg = colors.red },
          NormalFloat = { bg = 'NONE' },
          LspHoverNormal = { bg = 'NONE' },
          LspHoverBorder = { bg = 'NONE' },
          RenderMarkdownCode = { bg = 'NONE' },
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
