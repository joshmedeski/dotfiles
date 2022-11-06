-- https://docs.github.com/en/enterprise-cloud@latest/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim
vim.g.copilot_autocomplete = 1
vim.g.copilot_autoimport = 1
vim.g.copilot_autosignature = 1
vim.g.copilot_autotype = 1
vim.g.copilot_autowrite = 1
vim.g.copilot_delay = 100
vim.g.copilot_enabled = 1
vim.g.copilot_fuzzy = 1
vim.g.copilot_ignored = { 'node_modules', 'dist' }
vim.g.copilot_import = 1
vim.g.copilot_importer = 'coc'
vim.g.copilot_imports = 1
vim.g.copilot_imports_autocomplete = 1
vim.g.copilot_imports_autosignature = 1
vim.g.copilot_imports_autotype = 1
vim.g.copilot_imports_autowrite = 1
vim.g.copilot_imports_delay = 100
vim.g.copilot_imports_enabled = 1
vim.g.copilot_imports_fuzzy = 1
vim.g.copilot_imports_ignored = { 'node_modules', 'dist' }
vim.g.copilot_imports_import = 1
vim.g.copilot_imports_importer = 'coc'
vim.g.copilot_imports_log = 0
vim.g.copilot_imports_log_file = '/tmp/copilot.log'
vim.g.copilot_imports_log_level = 'INFO'
vim.g.copilot_imports_log_max_bytes = 10485760
vim.g.copilot_imports_log_max_files = 10
vim.g.copilot_imports_log_to_console = 0
vim.g.copilot_imports_log_to_file = 1
vim.g.copilot_imports_max_bytes = 10485760
vim.g.copilot_imports_max_files = 10
vim.g.copilot_imports_min_chars = 3
vim.g.copilot_imports_no_autocomplete = 0
vim.g.copilot_imports_no_autosignature = 0
vim.g.copilot_imports_no_autotype = 0
vim.g.copilot_imports_no_autowrite = 0
vim.g.copilot_imports_no_import = 0
vim.g.copilot_imports_no_log = 0
-- set variables for this plugin
vim.g.copilot_autostart = 1
vim.g.copilot_autoimport = 1
vim.g.copilot_autocomplete = 1
vim.g.copilot_autocomplete_delay = 100
vim.g.copilot_autocomplete_key = '<C-Space>'
vim.g.copilot_autocomplete_priority = 10
vim.g.copilot_autocomplete_trigger = 0
vim.g.copilot_autocomplete_trigger_characters = { '.', '->', '::', ' ' }
vim.g.copilot_autocomplete_trigger_key = '<C-Space>'
vim.g.copilot_autocomplete_trigger_timeout = 100
vim.g.copilot_autocomplete_trigger_words = {
  'as',
  'assert',
  'from',
  'import',
  'is',
  'return',
  'self',
  'super',
  'true',
  'false',
  'not',
  'and',
  'or',
  'if',
  'else',
  'elif',
  'for',
  'while',
  'try',
  'except',
  'finally',
  'with',
  'in',
  'lambda',
  'yield',
  'raise',
  'def',
  'class',
  'async',
  'await',
  'pass',
  'break',
  'continue',
  'del',
  'global',
  'nonlocal',
  'False',
  'True',
  'None',
}
vim.g.copilot_autocomplete_words = 1
vim.g.copilot_autocomplete_words_priority = 9
vim.g.copilot_autocomplete_words_trigger = 1
vim.g.copilot_autocomplete_words_trigger_characters = { '.' }
vim.g.copilot_autocomplete_words_trigger_key = '<C-Space>'
vim.g.copilot_autocomplete_words_trigger_timeout = 100
vim.g.copilot_autocomplete_words_words = {
  'as',
  'assert',
  'from',
  'import',
  'is',
  'return',
  'self',
  'super',
  'true',
  'false',
  'not',
  'and',
  'or',
  'if',
  'else',
  'elif',
  'for',
  'while',
  'try',
  'except',
  'finally',
  'with',
  'in',
  'lambda',
  'yield',
}
-- set variables
vim.g.copilot_auto_start = 1
vim.g.copilot_auto_start_filetypes = { "markdown", "text", "tex", "latex" }

-- set keybindings
vim.api.nvim_set_keymap("n", "<leader>o", ":Copilot<CR>", { noremap = true, silent = true })

-- set autocommands
vim.cmd [[
  augroup Copilot
    autocmd!
    autocmd BufEnter * if exists('b:copilot') | call copilot#start() | endif
  augroup END
]]

-- set autocmds
vim.cmd [[
  augroup Copilot
    autocmd!
    autocmd BufEnter * if exists('b:copilot') | call copilot#start() | endif
  augroup END
]]

-- set keybindings
vim.api.nvim_set_keymap("n", "<leader>o", ":Copilot<CR>", { noremap = true, silent = true })

-- set variables
vim.g.copilot_auto_start = 1
vim.g.copilot_auto_start_filetypes = { "markdown", "text", "tex", "latex" }

-- set autocommands
vim.cmd [[
  augroup Copilot
    autocmd!
    autocmd BufEnter * if exists('b:copilot') | call copilot#start() | endif
  augroup END
]]

-- set keybindings
vim.api.nvim_set_keymap("n", "<leader>o", ":Copilot<CR>", { noremap = true, silent = true })

-- set variables
vim.g.copilot_auto_start = 1
vim.g.copilot_auto_start_filetypes = { "markdown", "text", "tex", "latex" }

-- set autocommands
vim.cmd [[
  augroup Copilot
    autocmd!
    autocmd BufEnter * if exists('b:copilot') | call copilot#start() | endif
  augroup END
]]

-- set variables
vim.g.copilot_auto_start = 1
vim.g.copilot_auto_start_filetypes = { "typescript", "markdown", "text", "tex", "latex" }

-- set autocommands
vim.cmd [[
  augroup Copilot
    autocmd!
    autocmd BufEnter * if exists('b:copilot') | call copilot#start() |
]]
