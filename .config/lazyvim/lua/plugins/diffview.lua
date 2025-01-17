return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {
    file_panel = {
      position = "bottom",
      height = 20,
    },
    hooks = {
      view_opened = function()
        ---@diagnostic disable-next-line: undefined-field
        local stdout = vim.loop.new_tty(1, false)
        if stdout ~= nil then
          stdout:write(
            ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("DIFF_VIEW", vim.fn.system({ "base64" }, "+4"))
          )
          vim.cmd([[redraw]])
        end
      end,
      view_closed = function()
        ---@diagnostic disable-next-line: undefined-field
        local stdout = vim.loop.new_tty(1, false)
        if stdout ~= nil then
          stdout:write(
            ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("DIFF_VIEW", vim.fn.system({ "base64" }, "-1"))
          )
          vim.cmd([[redraw]])
        end
      end,
    },
  },
}
