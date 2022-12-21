vim.cmd [[packadd packer.nvim]]

return require('packer').startup({ function(use)
    -- plugins
    use 'wbthomason/packer.nvim'

    -- style
    use 'catppuccin/nvim'
    use 'xiyaowong/nvim-transparent'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }
    use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use { 'norcalli/nvim-colorizer.lua',
        event = 'BufRead',
        config = function() require 'colorizer'.setup {} end,
    }

    -- manipulation
    use 'tpope/vim-surround'
    use 'folke/which-key.nvim'
    use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }

    -- navigation
    use 'theprimeagen/harpoon'
    use { 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'lmburns/lf.nvim', requires = { 'nvim-lua/plenary.nvim', 'akinsho/toggleterm.nvim' } }
    use { 'nvim-telescope/telescope.nvim',
        tag = '0.1.0', requires = 'nvim-lua/plenary.nvim'
    }

    -- lsp
    use { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim' }
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
            -- nvim
            { 'folke/neodev.nvim' }
        }
    }

    -- git
    use 'lewis6991/gitsigns.nvim'
    use 'rhysd/committia.vim'
    use { 'sindrets/diffview.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' }
    }
    use { 'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function() require 'octo'.setup {} end
    }

    -- tmux
    use 'christoomey/vim-tmux-navigator'

    -- tracking
    use 'wakatime/vim-wakatime'
    use 'ActivityWatch/aw-watcher-vim'
end, config = { display = { open_fn = require('packer.util').float } }
})
