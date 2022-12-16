reload "user.autocmd"
reload "user.emmet_ls"
reload "user.general"
reload "user.gitsigns"
reload "user.lualine"
reload "user.mason"
reload "user.telescope"
reload "user.which-key"

lvim.plugins = {
  { "catppuccin/nvim",
    config = function()
      reload "user.catppuccin"
    end
  },
  { "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup()
    end,
  },
  { "lmburns/lf.nvim",
    requires = { "plenary.nvim", "toggleterm.nvim", "lmburns/lf.nvim" },
    config = function()
      require("user.lf").config()
    end,
  },
  { "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require "octo".setup()
    end
  },
  { "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("user.todo-comments")
    end
  },
  { "folke/zen-mode.nvim",
    config = function()
      reload "user.zen-mode"
    end
  },
  { "ThePrimeagen/harpoon",
    requires = "plenary.nvim",
    config = function()
      require("harpoon").setup({
        global_settings = { mark_branch = true },
        menu = { width = 60 }
      })
    end
  },
  { "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function()
      reload "user.trouble"
    end
  },
  { "christoomey/vim-tmux-navigator" },
  { "folke/lsp-colors.nvim" },
  { "tpope/vim-surround" },
  { "wakatime/vim-wakatime" },
  { "xiyaowong/nvim-transparent" },
}
