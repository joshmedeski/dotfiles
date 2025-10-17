return {
  'Bekaboo/dropbar.nvim',
  enabled = true,
  event = 'BufEnter',
  name = 'dropbar',

  config = function()
    local bar = require 'dropbar.bar'

    ---@class dropbar_source_t
    local sidekick = {
      get_symbols = function(buff, _, _)
        local status = require('sidekick.status').get()
        if status then
          return status.kind == 'Error' and 'DiagnosticError' or status.busy and 'DiagnosticWarn' or 'Special'
        end

        local status = require('sidekick.status').get()
        if not status then
          return {}
        end

        local lspIcons = require('utils.icons').lsp

        if status.kind == 'Error' then
          return {
            bar.dropbar_symbol_t:new {
              icon = lspIcons.error,
              icon_hl = 'DiagnosticError',
              name = status.message,
              name_hl = 'DiagnosticError',
            },
          }
        end

        if status.busy then
          return {
            bar.dropbar_symbol_t:new {
              icon = lspIcons.warn,
              icon_hl = 'DiagnosticWarn',
              name = status.message,
              name_hl = 'DiagnosticWarn',
            },
          }
        end

        return {}
      end,
    }

    ---@class dropbar_source_t
    local mini_diff_stats = {
      get_symbols = function(buff, _, _)
        local summary = vim.b[buff].minidiff_summary

        if not summary then
          return {}
        end

        local stats = {}

        if not summary.add and not summary.change and not summary.delete and not summary.n_ranges then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = '󱀶 ',
              icon_hl = 'Untracked',
              name = '',
              name_hl = 'Untracked',
            }
          )
        end

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
    local smart_path = {
      get_symbols = function(buff, _, _)
        local stats = {}

        local abs_path = vim.api.nvim_buf_get_name(buff) -- Get absolute path of current buffer
        local cwd = vim.fn.getcwd()
        local rel_path = vim.fs.relpath(cwd, abs_path)

        if rel_path then
          -- TODO: split path
          local fileName = vim.fn.fnamemodify(rel_path, ':t')
          local pathOnly = vim.fn.fnamemodify(rel_path, ':h')
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = '',
              icon_hl = 'FileName',
              name = fileName,
              name_hl = 'FileName',
            }
          )
          if pathOnly:match '^octo' then
            table.insert(
              stats,
              bar.dropbar_symbol_t:new {
                icon = ' ',
                icon_hl = 'FilePath',
                name = '',
                name_hl = 'FilePath',
              }
            )
          elseif pathOnly ~= '.' then
            table.insert(
              stats,
              bar.dropbar_symbol_t:new {
                icon = ' ',
                icon_hl = 'FilePath',
                name = pathOnly,
                name_hl = 'FilePath',
              }
            )
          end
        else
          local formatted_abs_path = vim.fn.fnamemodify(abs_path, ':~')
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = '',
              name = formatted_abs_path,
              name_hl = '',
            }
          )
        end

        return stats
      end,
    }

    ---@class dropbar_source_t
    require('dropbar').setup {
      icons = {
        enabled = true,
        ui = {
          bar = {
            separator = ' ',
            extends = '…',
          },
        },
      },
      bar = {
        sources = function()
          return { smart_path, mini_diff_stats, lsp_diagnostics }
        end,
      },
    }
  end,
}
