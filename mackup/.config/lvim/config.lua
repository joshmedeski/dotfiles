-- ------------------------------------------------------------------------------
--
--    88\                                                   88\
--    88 |                                                  \__|
--    88 |88\   88\ 888888$\   888888\   888888\ 88\    88\ 88\ 888888\8888\
--    88 |88 |  88 |88  __88\  \____88\ 88  __88\\88\  88  |88 |88  _88  _88\
--    88 |88 |  88 |88 |  88 | 888888$ |88 |  \__|\88\88  / 88 |88 / 88 / 88 |
--    88 |88 |  88 |88 |  88 |88  __88 |88 |       \88$  /  88 |88 | 88 | 88 |
--    88 |\888888  |88 |  88 |\888888$ |88 |        \$  /   88 |88 | 88 | 88 |
--    \__| \______/ \__|  \__| \_______|\__|         \_/    \__|\__| \__| \__|
-- ------------------------------------------------------------------------------
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "catppuccin"
lvim.transparent_window = true
lvim.builtin.lualine.style = "lvim"

vim.cmd([[hi BufferLineFill ctermbg=none]])
vim.cmd([[hi clear CursorLine]])
vim.cmd([[hi Comment ctermfg=grey]])
vim.cmd([[hi LineNr term=bold ctermfg=gray]])
vim.cmd([[hi Search ctermfg=black ctermbg=yellow]])
vim.cmd([[hi Sneak ctermfg=black ctermbg=yellow]])
vim.cmd([[hi SneakScope ctermfg=black ctermbg=yellow]])
vim.cmd([[hi Visual ctermfg=black ctermbg=yellow]])
-- Yank to end of line
vim.cmd([[nnoremap Y yg_]])
-- Better J cursor position
vim.cmd([[nnoremap J mzJ`z]])
-- Center next search results
vim.cmd([[nnoremap n nzzzv]])
vim.cmd([[nnoremap N Nzzzv]])
-- Undo break points
vim.cmd([[inoremap , ,<c-g>u]])
vim.cmd([[inoremap { {<c-g>u]])
vim.cmd([[inoremap } }<c-g>u]])
vim.cmd([[inoremap [ [<c-g>u]])
vim.cmd([[inoremap] ]<c-g>u ]])
vim.cmd([[inoremap ( (<c-g>u]])
vim.cmd([[inoremap ) )<c-g>u]])
-- Jumplist mutation
vim.cmd([[nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k']])
vim.cmd([[nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j']])
vim.cmd([[vnoremap J :m '>+1<CR>gv=gv]])
vim.cmd([[vnoremap K :m '<-2<CR>gv=gv]])

lvim.builtin.gitsigns.opts = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn"
    },
    change = {
      hl = "GitSignsChange",
      text = "",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn"
    },
    delete = {
      hl = "GitSignsDelete",
      text = "",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn"
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn"
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn"
    }
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = { interval = 1000, follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false
  },
  current_line_blame_formatter_opts = { relative_time = false },
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
    col = 1
  },
  yadm = { enable = false }
}

-- Additional Plugins
lvim.plugins = {
  { "christoomey/vim-tmux-navigator" },
  { "folke/lsp-colors.nvim" },
  { "sindrets/diffview.nvim", event = "BufRead" }, {
    "catppuccin/nvim",
  }, {
    'xiyaowong/nvim-transparent',
    config = function()
      require("transparent").setup({
        enable = true,
        extra_groups = {
          -- akinsho/nvim-bufferline.lua
          "BufferLineTabClose", "BufferLineFill",
          "BufferLineBackground", "BufferLineSeparator",
          "BufferLineIndicatorSelected"
        }
      })
    end
  }, {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({ global_settings = { mark_branch = true } })
    end
  }, {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup({
        signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        -- keywords recognized as todo comments
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = {
            icon = " ",
            color = "warning",
            alt = { "WARNING", "XXX" }
          },
          PERF = {
            icon = " ",
            alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" }
          },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } }
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
          exclude = {} -- list of file types to exclude highlighting
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of hilight groups or use the hex color if hl not found as a fallback
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" }
        },
        search = {
          command = "rg",
          args = {
            "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column"
          },
          -- regex that will be used to match keywords.
          -- don't replace the (KEYWORDS) placeholder
          pattern = [[\b(KEYWORDS):]] -- ripgrep regex
          -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        }
      })
    end
  }, {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function()
      require("trouble").setup {
        position = "top", -- position of the list can be: bottom, top, left, right
        height = 5, -- height of the trouble list when position is top or bottom
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
          jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
          open_split = { "<c-x>" }, -- open buffer in new split
          open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
          open_tab = { "<c-t>" }, -- open buffer in new tab
          jump_close = { "o" }, -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "P", -- toggle auto_preview
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          close_folds = { "zM", "zm" }, -- close all folds
          open_folds = { "zR", "zr" }, -- open all folds
          toggle_fold = { "zA", "za" }, -- toggle fold of current file
          previous = "k", -- preview item
          next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
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
    end
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "!tmux source <afile>"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "config.lua" },
  command = "LvimReload"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!brew services restart yabai"
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".skhdrc" },
  command = "!brew services restart skhd"
})
