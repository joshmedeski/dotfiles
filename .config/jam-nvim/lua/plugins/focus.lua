return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  deps = "b0o/incline.nvim",
  opts = {
    window = {
      zindex = 10,
      backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      width = 0.85,
      height = 0.85,
    },
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = true },
      tmux = { enabled = true },
      wezterm = {
        enabled = true,
        font = "+2", -- (10% increase per step)
      },
    },
    on_open = function()
      require("noice").disable()
      require("incline").disable()
    end,
    on_close = function()
      require("noice").enable()
      require("incline").enable()
    end,
  },
}
