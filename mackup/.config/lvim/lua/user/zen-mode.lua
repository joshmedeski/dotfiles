-- https://github.com/folke/zen-mode.nvim
require("zen-mode").setup {
  window = {
    -- backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an absolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    -- * a function that returns the width or the height
    width = 70, -- width of the Zen window
    height = 40, -- height of the Zen window
    -- by default, no options are changed for the Zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      signcolumn = "yes", -- disable signcolumn
      wrap = true, -- wraps text
      number = false, -- disable number column
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = "0", -- disable fold column
      list = false, -- disable whitespace characters
      -- relativenumber = false, -- disable relative numbers
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = true, -- disables the ruler text in the cmd line area
      showcmd = true, -- disables the command in the last line of the screen
    },
    gitsigns = { enabled = true }, -- disables git signs
    tmux = { enabled = true }, -- disables the tmux statusline
  },
  -- callback where you can add custom code when the Zen window opens
  on_open = function(win)
    lvim.builtin.terminal.active = false
  end,
  -- callback where you can add custom code when the Zen window closes
  on_close = function()
    lvim.builtin.terminal.active = true
  end,
}
