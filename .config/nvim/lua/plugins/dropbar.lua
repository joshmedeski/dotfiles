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

    local gitsigns_stats = {
      get_symbols = function(_, _, _)
        local gitsigns_stats = get_gitsigns_stats()
        if not gitsigns_stats then
          return {}
        end

        local stats = {}

        if gitsigns_stats.added and gitsigns_stats.added > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Added',
              name = tostring(gitsigns_stats.added),
              name_hl = 'Added',
            }
          )
        end

        if gitsigns_stats.removed and gitsigns_stats.removed > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Removed',
              name = tostring(gitsigns_stats.removed),
              name_hl = 'Removed',
            }
          )
        end

        if gitsigns_stats.modified and gitsigns_stats.modified > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Changed',
              name = tostring(gitsigns_stats.modified),
              name_hl = 'Changed',
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
