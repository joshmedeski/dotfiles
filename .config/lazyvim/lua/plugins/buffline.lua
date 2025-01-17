return {
  "akinsho/bufferline.nvim",
  enabled = false,
  opts = function()
    local Offset = require("bufferline.offset")
    if not Offset.edgy then
      local get = Offset.get
      Offset.get = function()
        if package.loaded.edgy then
          local layout = require("edgy.config").layout
          local ret = { left = "", left_size = 0, right = "", right_size = 0 }
          for _, pos in ipairs({ "left", "right" }) do
            local sb = layout[pos]
            if sb and #sb.wins > 0 then
              local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
              ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
              ret[pos .. "_size"] = sb.bounds.width
            end
          end
          ret.total_size = ret.left_size + ret.right_size
          if ret.total_size > 0 then
            return ret
          end
        end
        return get()
      end
      Offset.edgy = true
    end

    return {
      ---@class bufferline.Options
      options = {
        separator_style = { "", "" },
        offsets = { { text_align = "left", separator = false } },
        indicator = { style = "none" },
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        always_show_bufferline = false,
      },
    }
  end,
}
