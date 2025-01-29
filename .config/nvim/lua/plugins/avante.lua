return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  enabled = true,
  version = false, -- set this if you want to always pull the latest change

  opts = {
    provider = 'copilot',
    windows = {
      postion = 'right',
      width = 30,
      sidebar_header = {
        enabled = true,
        align = 'center',
        rounded = false,
      },
    },
    file_selector = {
      provider = 'telescope',
    },
  },

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = true,
          prompt_for_file_name = true,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = false,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
