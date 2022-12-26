local telescope = require("telescope")

telescope.setup({
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
  },
})

telescope.load_extension("harpoon")
