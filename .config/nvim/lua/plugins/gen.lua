return {
  "David-Kunz/gen.nvim",
  commands = { "Gen" },
  opts = {
    model = "mistral", -- The default model to use.
    display_mode = "split", -- The display mode. Can be "float" or "split".
    show_prompt = true, -- Shows the Prompt submitted to Ollama.
    show_model = true, -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = false, -- Never closes the window automatically.
  },
}
