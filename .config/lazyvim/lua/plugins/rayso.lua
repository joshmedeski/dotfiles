return {
  "TobinPalmer/rayso.nvim",
  cmd = "Rayso",
  opts = {
    base_url = "https://ray.so/", -- Default URL
    open_cmd = "Arc", -- On MacOS, will open with open -a firefox.app. Other OS's are untested.
    options = {
      background = true, -- If the screenshot should have a background.
      dark_mode = true, -- If the screenshot should be in dark mode.
      logging_path = "", -- Path to create a log file in.
      logging_file = "rayso", -- Name of log file, will be a markdown file, ex rayso.md.
      logging_enabled = false, -- If you enable the logging file.
      padding = 32, -- The default padding that the screenshot will have.
      theme = "raindrop", -- Theme
    },
  },
  keys = {
    { "<leader>rs", "<cmd>Rayso<cr>", desc = "Share with Rayso" },
  },
}
