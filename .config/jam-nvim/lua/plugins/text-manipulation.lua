return {
  {
    "nat-418/boole.nvim",
    -- Neovim plugin for toggling booleans, etc.
    opts = {
      mappings = {
        increment = "<C-a>",
        decrement = "<C-x>",
      },
      additions = {
        { "frappe", "latte", "macchiato", "mocha" },
        { "production", "development", "test" },
        { "production", "development", "test" },
        { "let", "const" },
        { "start", "end" },
        { "before", "after" },
        { "plus", "minus" },
        { "smart", "truncate" },
        { "left", "right" },
      },
    },
  },
}
