return {
  "nvim-telescope/telescope.nvim",
  dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, "ThePrimeagen/harpoon" },
  -- apply the config and additionally load fzf-native
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("notify")
    telescope.load_extension("harpoon")
  end,
  opts = {
    defaults = {
      file_ignore_patterns = { ".git/", "node_modules" },
      layout_config = {
        preview_width = 0.6,
        prompt_position = "top",
      },
      path_display = { "smart" },
      prompt_position = "top",
      prompt_prefix = " ",
      selection_caret = " ",
      sorting_strategy = "ascending",
    },
    pickers = {
      buffers = {
        prompt_prefix = "﬘ ",
      },
      commands = {
        prompt_prefix = " ",
      },
      git_files = {
        prompt_prefix = " ",
        show_untracked = true,
      },
      find_files = {
        prompt_prefix = " ",
        find_command = { "rg", "--files", "--hidden" },
      },
    },
  },
  keys = function()
    return {}
  end,
}
