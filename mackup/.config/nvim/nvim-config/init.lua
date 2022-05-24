require('catppuccin').setup {
  transparent_background = true,
}
vim.cmd[[set termguicolors]]
vim.cmd[[syntax enable]]
vim.cmd[[colorscheme catppuccin]]
vim.cmd[[hi CursorLine guibg=none]]
vim.cmd[[hi CursorLineNr guifg=#F5C2E7]]

-- NOTE: https://github.com/neoclide/coc.nvim/blob/master/doc/coc.txt
-- NOTE: https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/core/color_palette.lua
vim.cmd[[hi CocErrorHighlight guifg=#F28FAD]]
vim.cmd[[hi CocErrorSign guifg=#F28FAD]]
vim.cmd[[hi CocErrorVirtualText guifg=#F28FAD]]
-- vim.cmd[[hi CocErrorLine guifg=#F28FAD]]

vim.cmd[[hi CocHintHighlight guifg=#F5E0DC]]
vim.cmd[[hi CocHintSign guifg=#F5E0DC]]
vim.cmd[[hi CocHintVirtualText guifg=#F5E0DC]]
-- vim.cmd[[hi CocHintLine guifg=#F5E0DC]]

vim.cmd[[hi CocInfoHighlight guifg=#89DCEB]]
vim.cmd[[hi CocInfoSign guifg=#89DCEB]]
vim.cmd[[hi CocInfoVirtualText guifg=#89DCEB]]
-- vim.cmd[[hi CocInfoLine guifg=#89DCEB]]

vim.cmd[[hi CocWarningHighlight guifg=#FAE3B0]]
vim.cmd[[hi CocWarningSign guifg=#FAE3B0]]
vim.cmd[[hi CocWarningVirtualText guifg=#FAE3B0]]
-- vim.cmd[[hi CocWarningLine guifg=#FAE3B0]]

-- vim.cmd[[hi CocDeprecatedHighlight guifg=#f28fad]]
-- vim.cmd[[hi CocFadeOut guifg=#f28fad]]
-- vim.cmd[[hi CocStrikeThrough guifg=#f28fad]]
-- vim.cmd[[hi CocUnusedHighlight guifg=#f28fad]]

require("transparent").setup({
  enable = true,
  extra_groups = {
    -- akinsho/nvim-bufferline.lua
    "BufferLineTabClose",
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineSeparator",
    "BufferLineIndicatorSelected",
  },
})

require('colorizer').setup()
require('hop').setup()
require('Comment').setup()
require("harpoon").setup({
  global_settings = {
    mark_branch = true
  }
})
require'lspconfig'.tailwindcss.setup {}

require("null-ls").setup({
    sources = { },
})

require'nvim-web-devicons'.setup()

local telescope = require('telescope')

telescope.setup {
  defaults = {
    sorting_strategy = "ascending",
    prompt_prefix = " ",
    prompt_position = "top"
  },
  pickers = {
    git_files = {
      layout_config = {
        preview_width = 0.6,
        prompt_position = "top"
      }
    },
    commands = {
      layout_config = {
        prompt_position = "top"
      }
    },
    git_status = {
      layout_config = {
        prompt_position = "top"
      }
    }
  }
}

telescope.load_extension('coc')
telescope.load_extension('harpoon')

require("bufferline").setup {
  options = {
    separator_style = {"", ""},
    indicator_icon = "",
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false
  }
}

require("todo-comments").setup { }

require('gitsigns').setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
}

vim.cmd[[command! -nargs=0 GitFiles :Telescope git_files ]]
vim.cmd[[command! -nargs=0 Commands :Telescope commands ]]
vim.cmd[[command! -nargs=0 GitStatus :Telescope git_status ]]
