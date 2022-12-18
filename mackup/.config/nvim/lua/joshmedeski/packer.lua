return require('packer').startup({ function(use)
    use 'wbthomason/packer.nvim'

    use 'catppuccin/nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'theprimeagen/harpoon'
    use 'tpope/vim-surround'
    use 'xiyaowong/nvim-transparent'

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use { 'nvim-telescope/telescope.nvim',
        tag = '0.1.0', requires = 'nvim-lua/plenary.nvim'
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
