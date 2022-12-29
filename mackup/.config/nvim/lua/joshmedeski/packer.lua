-- cSpell:words packadd wbthomason xiyaowong catppuccin christoomey octo devicons pwntester sindrets rhysd committia weilbith onsails folke rafamadriz conventionalcommits davidsierradz hrsh7th saadparwaiz1 williamboman Heikemen lmburns theprimeagen airblade mbbill tpope norcalli toggleterm akinsho autopairs windwp textobjects kyazdani
vim.cmd([[packadd packer.nvim]])

return require("packer").startup({
  function(use)
    -- plugins
    use("wbthomason/packer.nvim")

    -- cache
    use({
      "lewis6991/impatient.nvim",
      config = function()
        require("impatient")
      end,
    })

    -- theme
    use("catppuccin/nvim")

    -- style
    use("xiyaowong/nvim-transparent")
    use({
      "nvim-lualine/lualine.nvim",
      requires = { "nvim-tree/nvim-web-devicons" },
    })

    -- highlighting
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
    })
    use({
      "norcalli/nvim-colorizer.lua",
      event = "BufRead",
      config = function()
        require("colorizer").setup({})
      end,
    })

    -- manipulation
    use({
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    })
    use("folke/which-key.nvim")
    use("tpope/vim-surround")
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })

    -- undo
    use("mbbill/undotree")

    -- navigation
    use("airblade/vim-rooter")
    use("theprimeagen/harpoon")
    use({
      "lmburns/lf.nvim",
      requires = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    })
    use({
      "nvim-telescope/telescope.nvim",
      tag = "0.1.0",
      requires = "nvim-lua/plenary.nvim",
    })

    -- lists
    use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
    use({ "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" })

    -- window
    use({
      "beauwilliams/focus.nvim",
      cmd = { "FocusSplitNicely", "FocusSplitCycle" },
      module = "focus",
      config = function()
        require("focus").setup({ hybridnumber = true })
      end,
    })

    -- lsp
    use({
      "VonHeikemen/lsp-zero.nvim",
      requires = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "jay-babu/mason-null-ls.nvim" },
        -- null-ls
        { "jose-elias-alvarez/null-ls.nvim" },
        -- cmp
        { "hrsh7th/nvim-cmp" },
        -- cmp plugins
        { "davidsierradz/cmp-conventionalcommits" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "mtoohey31/cmp-fish" },
        { "saadparwaiz1/cmp_luasnip" },
        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
        -- nvim
        { "folke/neodev.nvim" },
        -- icons
        { "nvim-tree/nvim-web-devicons" },
        { "onsails/lspkind.nvim" },
      },
    })
    use({ "weilbith/nvim-code-action-menu" })
    use({
      "ThePrimeagen/refactoring.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
    })

    -- git
    use("lewis6991/gitsigns.nvim")
    use("rhysd/committia.vim")
    use({
      "sindrets/diffview.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    })
    use({
      "pwntester/octo.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("octo").setup({})
      end,
    })

    -- tmux
    use("christoomey/vim-tmux-navigator")

    -- AI
    use("github/copilot.vim")

    -- tracking
    use("wakatime/vim-wakatime")
    use("ActivityWatch/aw-watcher-vim")
  end,
  config = { display = { open_fn = require("packer.util").float } },
})
