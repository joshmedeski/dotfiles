local M = {}

M.config = function()
  -- general
  lvim.format_on_save.enabled = true
  lvim.transparent_window = true

  -- keymappings
  lvim.leader = "space"
  vim.cmd [[
  nnoremap <esc><esc> <cmd>nohlsearch<cr>
  nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
  nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
  nnoremap J mzJ`z
  nnoremap N Nzzzv
  nnoremap n nzzzv
  nnoremap Y yg_
  vnoremap J :m '>+1<CR>gv=gv
  vnoremap K :m '<-2<CR>gv=gv
  vnoremap p "_dP
]]

  -- highlights
  vim.cmd([[
  hi BufferLineFill ctermbg=none
  hi Comment ctermfg=grey
  hi Search ctermfg=black ctermbg=yellow
  hi Sneak ctermfg=black ctermbg=yellow
  hi SneakScope ctermfg=black ctermbg=yellow
  hi Visual ctermfg=black ctermbg=yellow
  hi clear CursorLine
]] )

  -- Center next search results
  -- TODO: revisit why these are helpful (ThePrimeagen YouTube video)
  -- Undo break points
  -- vim.cmd([[inoremap , ,<c-g>u]])
  -- vim.cmd([[inoremap { {<c-g>u]])
  -- vim.cmd([[inoremap } }<c-g>u]])
  -- vim.cmd([[inoremap [ [<c-g>u]])
  -- vim.cmd([[inoremap] ]<c-g>u ]])
  -- vim.cmd([[inoremap ( (<c-g>u]])
  -- vim.cmd([[inoremap ) )<c-g>u]])
  -- Jumplist mutation
  -- Shift text
end

return M
