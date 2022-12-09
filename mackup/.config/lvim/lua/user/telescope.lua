lvim.builtin.telescope = {
  active = true,
  defaults = {
    layout_config = {
      preview_width = 0.6,
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    prompt_prefix = " ",
    prompt_position = "top"
  }
}

lvim.builtin.telescope.on_config_done = function(telescope)
  -- pcall(telescope.load_extension, "frecency")
  -- pcall(telescope.load_extension, "neoclip")
  pcall(telescope.load_extension, "harpoon")
end
