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
    view = {
      use_icons = true,
      default = {
        layout = "diff2_horizontal",
        winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
      },
    },
    hooks = {
      view_opened = function()
        local stdout = vim.loop.new_tty(1, false)
        if stdout ~= nil then
          stdout:write(
            ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("DIFF_VIEW", vim.fn.system({ "base64" }, "+2"))
          )
          vim.cmd([[redraw]])
        end
      end,
      view_closed = function()
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
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
  },
}
