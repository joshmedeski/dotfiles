vim.cmd [[packadd packer.nvim]]

return require('packer').startup({ function(use)
    use 'wbthomason/packer.nvim'

    use 'catppuccin/nvim'
    use 'christoomey/vim-tmux-navigator'
    use 'folke/neodev.nvim'
    use 'folke/which-key.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'rhysd/committia.vim'
    use 'theprimeagen/harpoon'
    use 'tpope/vim-surround'
    use 'xiyaowong/nvim-transparent'

    use {
        'sindrets/diffview.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' }
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    use { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use { 'norcalli/nvim-colorizer.lua',
        event = 'BufRead',
        config = function()
            require 'colorizer'.setup {}
        end,
    }

    use { 'lmburns/lf.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'akinsho/toggleterm.nvim' }
    }

    use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use { 'nvim-telescope/telescope.nvim',
        tag = '0.1.0', requires = 'nvim-lua/plenary.nvim'
    }

    use { -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make', cond = vim.fn.executable 'make' == 1
    }


    use { 'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }

    use { 'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
end, config = { display = { open_fn = require('packer.util').float } }
})
