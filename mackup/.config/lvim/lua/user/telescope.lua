local actions = require "telescope.actions"

lvim.builtin.telescope = {
  active = true,
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
  }
}

lvim.builtin.telescope.on_config_done = function(telescope)
  -- pcall(telescope.load_extension, "frecency")
  -- pcall(telescope.load_extension, "neoclip")
  pcall(telescope.load_extension, "harpoon")
end
