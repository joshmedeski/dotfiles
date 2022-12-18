require('telescope').setup {
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
    git_files = {
      show_untracked = true,
    }
  }
}

-- TODO: add harpoon
