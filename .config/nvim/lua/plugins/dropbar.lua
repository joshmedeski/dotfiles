-- TODO: find solution that can properly fetch per split
local function get_gitsigns_stats()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

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
    require('dropbar').setup {
      bar = {
        sources = function()
          local sources = require 'dropbar.sources'

          return { sources.path, gitsigns_stats }
        end,
      },
    }
  end,
}
