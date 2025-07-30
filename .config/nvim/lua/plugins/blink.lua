-- TODO: Deprioritize specific LSP (ex: eslint, biome)
-- TODO: style with lspkind?
-- TODO: get tailwindcss colors working on autocomplete

return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'brenoprata10/nvim-highlight-colors',
    'folke/lazydev.nvim',
    'Kaiser-Yang/blink-cmp-avante',
    'MahanRahmati/blink-nerdfont.nvim',
    'moyiz/blink-emoji.nvim',
    'rafamadriz/friendly-snippets',
    {
      'Kaiser-Yang/blink-cmp-git',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
      'onsails/lspkind.nvim',
      opts = {},
    },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = { nerd_font_variant = 'mono' },
    signature = { enabled = true },

    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
    },

    completion = {
      documentation = { auto_show = true },
      list = { selection = { preselect = true, auto_insert = true } },
      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if ctx.item.source_name == 'LSP' then
                  local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr then
                    icon = color_item.abbr
                  else
                    icon = require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                    })
                  end
                elseif vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                end

                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local highlight = 'BlinkCmpKind' .. ctx.kind
                if ctx.item.source_name == 'LSP' then
                  local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then
                    highlight = color_item.abbr_hl_group
                  end
                end
                return highlight
              end,
            },
          },
        },
      },
    },

    sources = {
      default = { 'avante', 'codecompanion', 'git', 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'emoji', 'nerdfont' },
      providers = {
        avante = {
          module = 'blink-cmp-avante',
          name = 'Avante',
        },
        git = {
          module = 'blink-cmp-git',
          name = 'Git',
          enabled = function()
            return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
          end,
          --- @module 'blink-cmp-git'
          --- @type blink-cmp-git.Options
          opts = {
            -- TODO: get neogit working
            -- options for the blink-cmp-git
          },
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        nerdfont = {
          -- TODO: update appearance to only show emoji and not lsp symbol
          module = 'blink-nerdfont',
          name = 'Nerd Fonts',
          score_offset = 15,
          opts = { insert = true },
        },
        emoji = {
          -- TODO: update appearance to only show emoji and not lsp symbol
          module = 'blink-emoji',
          name = 'Emoji',
          score_offset = 25,
          opts = { insert = true },
        },
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
