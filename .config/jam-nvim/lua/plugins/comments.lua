return {
  {
    "numToStr/Comment.nvim",
    -- 🧠 💪 // Smart and powerful comment plugin for neovim.
    -- Supports treesitter, dot repeat, left-right/up-down motions, hooks, and more
    opts = {}
  },
  {
    "folke/todo-comments.nvim",
    -- ✅ Highlight, list and search todo comments in your projects
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    }
  }
}
