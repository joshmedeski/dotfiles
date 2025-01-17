return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "prochri/telescope-all-recent.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
      },
      opts = {},
    },
    {
      "danielfalk/smart-open.nvim",
      branch = "0.2.x",
      dependencies = {
        "kkharji/sqlite.lua",
        { "nvim-telescope/telescope-fzy-native.nvim" },
      },
    },

    "AckslD/nvim-neoclip.lua",
    "danielvolchek/tailiscope.nvim",
    "debugloop/telescope-undo.nvim",
    -- "natecraddock/telescope-zf-native.nvim",
    "piersolenski/telescope-import.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
    "vuki656/package-info.nvim",
  },
  -- apply the config and additionally load fzf-native
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("import")
    telescope.load_extension("live_grep_args")
    telescope.load_extension("neoclip")
    telescope.load_extension("notify")
    telescope.load_extension("package_info")
    telescope.load_extension("smart_open")
    telescope.load_extension("tailiscope")
    telescope.load_extension("undo")
    -- telescope.load_extension("zf-native")
  end,

  opts = {
    defaults = {
      border = false,
      file_ignore_patterns = { ".git/", "node_modules" },
      layout_config = {
        height = 0.9999999,
        width = 0.99999999,
        preview_cutoff = 0,
        horizontal = { preview_width = 0.60 },
        vertical = { width = 0.999, height = 0.9999, preview_cutoff = 0 },
        prompt_position = "top",
      },
      path_display = { "smart" },
      prompt_position = "top",
      prompt_prefix = " ",
      selection_caret = "👉",
      sorting_strategy = "ascending",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--hidden",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
      },
    },
    pickers = {
      buffers = {
        prompt_prefix = "󰸩 ",
      },
      commands = {
        prompt_prefix = " ",
        layout_config = {
          height = 0.99,
          width = 0.99,
        },
      },
      command_history = {
        prompt_prefix = " ",
        layout_config = {
          height = 0.99,
          width = 0.99,
        },
      },
      git_files = {
        prompt_prefix = "󰊢 ",
        show_untracked = true,
      },
      find_files = {
        prompt_prefix = " ",
        find_command = { "fd", "-H" },
        layout_config = {
          height = 0.999,
          width = 0.999,
        },
      },
      live_grep = {
        prompt_prefix = "󰱽 ",
      },
      grep_string = {
        prompt_prefix = "󰱽 ",
      },
    },
    extensions = {
      ["zf-native"] = {
        file = { -- options for sorting file-like items
          enable = true, -- override default telescope file sorter
          highlight_results = true, -- highlight matching text in results
          match_filename = true, -- enable zf filename match priority
        },
        generic = { -- options for sorting all other items
          enable = true, -- override default telescope generic item sorter
          highlight_results = true, -- highlight matching text in results
          match_filename = false, -- disable zf filename match priority
        },
      },
      smart_open = {
        cwd_only = true,
        filename_first = true,
      },
    },
  },
  keys = function()
    return {
      -- TODO: last telescope
      { "<leader>*", "<cmd>Telescope grep_string<cr>", { silent = true, desc = "Grep Word Under Cursor" } },
      { "<leader>.", "<cmd>Telescope resume<cr>", { silent = true, desc = "Resume Telescope" } },
    }
  end,
}
