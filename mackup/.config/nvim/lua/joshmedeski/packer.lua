vim.cmd [[packadd packer.nvim]]

return require('packer').startup({ function(use)
  -- plugins
  use 'wbthomason/packer.nvim'

  -- cache
  use { 'lewis6991/impatient.nvim',
    config = function() require 'impatient' end,
  }

  -- theme
  use 'catppuccin/nvim'

  -- style
  use 'xiyaowong/nvim-transparent'
  use { 'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }
  use { 'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function() require 'colorizer'.setup {} end,
  }

  -- manipulation
  use { 'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }
  use 'folke/which-key.nvim'
  use 'tpope/vim-surround'
  use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }

  -- navigation
  use 'airblade/vim-rooter'
  use 'theprimeagen/harpoon'
  use { 'lmburns/lf.nvim', requires = { 'nvim-lua/plenary.nvim', 'akinsho/toggleterm.nvim' } }
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = 'nvim-lua/plenary.nvim' }

  -- lists
  use { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons' }

  -- lsp
  use { 'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      -- null-ls
      { 'jose-elias-alvarez/null-ls.nvim' },
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
      { 'folke/neodev.nvim' },
      -- icons
      { 'nvim-tree/nvim-web-devicons' },
      { 'onsails/lspkind.nvim' }
    }
  }

  -- git
  use 'lewis6991/gitsigns.nvim'
  use 'rhysd/committia.vim'
  use { 'sindrets/diffview.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' }
  }
  use { 'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function() require 'octo'.setup {} end
  }

  -- tmux
  use 'christoomey/vim-tmux-navigator'

  -- AI
  use 'github/copilot.vim'

  -- tracking
  use 'wakatime/vim-wakatime'
  use 'ActivityWatch/aw-watcher-vim'
end, config = { display = { open_fn = require('packer.util').float } }
})
