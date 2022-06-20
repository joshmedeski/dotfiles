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
    buffers = {
      layout_config = {
        preview_width = 0.0,
        prompt_position = "top"
      }
    },
    live_grep = {
      layout_config = {
        preview_width = 0.6,
        prompt_position = "top"
      }
    },
    git_files = {
      layout_config = {
        preview_width = 0,
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

require("trouble").setup {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
}

require("todo-comments").setup 
{
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of hilight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}

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
