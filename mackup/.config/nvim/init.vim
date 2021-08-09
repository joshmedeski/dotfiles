call plug#begin()
source $HOME/.config/nvim/nvim-config/plugins.vim
call plug#end()

source $HOME/.config/nvim/nvim-config/goyo.vim
source $HOME/.config/nvim/nvim-config/firenvim.vim
" source $HOME/.config/nvim/nvim-config/coc.vim
source $HOME/.config/nvim/nvim-config/general.vim
source $HOME/.config/nvim/nvim-config/theme.vim

let mapleader=" "
source $HOME/.config/nvim/nvim-config/leader.vim

source $HOME/.config/nvim/nvim-config/lsp.lua
source $HOME/.config/nvim/nvim-config/gitsigns.lua

" compe
source $HOME/.config/nvim/nvim-config/compe.lua
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" Miscellaneous
command! LF FloatermNew lf
let g:airline#extensions#tabline#enabled=1
let g:vim_markdown_folding_disabled = 1
let NERDTreeShowHidden=1

" lf Config
let g:lf_replace_netrw = 1 " Open lf when vim opens a directory
let g:lf_width = 0.9
let g:lf_height = 0.7

" Vim Wiki Setup
let g:vimwiki_list = [{'path': '~/repos/obsidian/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
