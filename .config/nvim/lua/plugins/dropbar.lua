return {
  'Bekaboo/dropbar.nvim',
  enabled = true,
  event = 'BufEnter',
  name = 'dropbar',

  config = function()
    local bar = require 'dropbar.bar'

    ---@class dropbar_source_t
    local mini_diff_stats = {
      get_symbols = function(buff, _, _)
        local summary = vim.b[buff].minidiff_summary

        if not summary then
          return {}
        end

        local stats = {}

        if summary.n_ranges and summary.n_ranges > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Modified',
              name = tostring(summary.n_ranges),
              name_hl = 'Modified',
            }
          )
        end

        if summary.delete and summary.delete > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Removed',
              name = tostring(summary.delete),
              name_hl = 'Removed',
            }
          )
        end

        if summary.change and summary.change > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Changed',
              name = tostring(summary.change),
              name_hl = 'Changed',
            }
          )
        end

        if summary.add and summary.add > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Added',
              name = tostring(summary.add),
              name_hl = 'Added',
            }
          )
        end

        return stats
      end,
    }

    ---@class dropbar_source_t
    local lsp_diagnostics = {
      get_symbols = function(buff, _, _)
        local lspIcons = require('utils.icons').lsp

        local errors = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.ERROR })
        local warnings = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.WARN })
        local infos = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.INFO })
        local hints = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.HINT })

        local stats = {}

        if #errors > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = lspIcons.error,
              icon_hl = 'DiagnosticError',
              name = tostring(#errors),
              name_hl = 'DiagnosticError',
            }
          )
        end

        if #warnings > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = lspIcons.warn,
              icon_hl = 'DiagnosticWarn',
              name = tostring(#warnings),
              name_hl = 'DiagnosticWarn',
            }
          )
        end

        if #infos > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = lspIcons.info,
              icon_hl = 'DiagnosticInfo',
              name = tostring(#infos),
              name_hl = 'DiagnosticInfo',
            }
          )
        end

        if #hints > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = lspIcons.hint,
              icon_hl = 'DiagnosticHint',
              name = tostring(#hints),
              name_hl = 'DiagnosticHint',
            }
          )
        end

        return stats
      end,
    }

    ---@class dropbar_source_t
    require('dropbar').setup {
      bar = {
        sources = function()
          local sources = require 'dropbar.sources'
          return { sources.path, mini_diff_stats, lsp_diagnostics }
        end,
      },
    }
  end,
}
