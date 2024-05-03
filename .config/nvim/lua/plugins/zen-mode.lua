return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  deps = {
    "b0o/incline.nvim",
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    window = {
      zindex = 10,
      backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      -- height and width can be:
      -- * an absolute number of cells when > 1
      -- * a percentage of the width / height of the editor when <= 1
      -- * a function that returns the width or the height
      width = 0.85, -- width of the Zen window
      height = 0.85, -- height of the Zen window
      -- by default, no options are changed for the Zen window
      -- uncomment any of the options below, or add other vim.wo options you want to apply
      options = {
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        list = false, -- disable whitespace characters
      },
    },
    plugins = {
      -- disable some global vim options (vim.o...)
      -- comment the lines to not apply the options
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
      },
      twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
      gitsigns = { enabled = true }, -- disables git signs
      tmux = { enabled = true }, -- disables the tmux statusline
      -- this will change the font size on kitty when in zen mode
      -- to make this work, you need to set the following kitty options:
      -- - allow_remote_control socket-only
      -- - listen_on unix:/tmp/kitty
      kitty = {
        enabled = false,
        font = "+2", -- font size increment
      },
      -- this will change the font size on alacritty when in zen mode
      -- requires  Alacritty Version 0.10.0 or higher
      -- uses `alacritty msg` subcommand to change font size
      alacritty = {
        enabled = true,
        font = "22", -- font size
      },

      -- this will change the font size on wezterm when in zen mode
      -- See alse also the Plugins/Wezterm section in this projects README
      wezterm = {
        enabled = true,
        -- can be either an absolute font size or the number of incremental steps
        font = "+5", -- (10% increase per step)
      },
    },
    -- callback where you can add custom code when the Zen window opens
    on_open = function()
      require("noice").disable()
      require("incline").disable()
      require("barbecue.ui").toggle(false)
      vim.g.miniindentscope_disable = true
    end,
    -- callback where you can add custom code when the Zen window closes
    on_close = function()
      require("noice").enable()
      require("incline").enable()
      require("barbecue.ui").toggle(true)
      vim.g.miniindentscope_disable = false
    end,
  },
}
