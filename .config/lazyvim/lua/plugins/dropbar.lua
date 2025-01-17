return {
  "Bekaboo/dropbar.nvim",
  enabled = false,
  name = "dropbar",
  event = "BufEnter",
  opts = {
    bar = {
      sources = function()
        local sources = require("dropbar.sources")
        return { sources.path }
      end,
    },
    icons = {
      kinds = {
        dir_icon = function()
          return nil, nil
        end,
      },
    },
    sources = {
      path = {
        max_depth = 5,
      },
    },
    symbol = {
      on_click = function() end,
    },
  },
}
