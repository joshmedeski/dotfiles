" cSpell:words goyo floaterm
call plug#begin()
source $HOME/.config/nvim/nvim-config/plugins.vim
call plug#end()

source $HOME/.config/nvim/nvim-config/general.vim
source $HOME/.config/nvim/nvim-config/theme.vim

source $HOME/.config/nvim/nvim-config/init.lua
source $HOME/.config/nvim/nvim-config/lualine.lua
source $HOME/.config/nvim/nvim-config/nvim-treesitter.lua

source $HOME/.config/nvim/nvim-config/abbreviations.vim
source $HOME/.config/nvim/nvim-config/coc.vim
source $HOME/.config/nvim/nvim-config/goyo.vim
source $HOME/.config/nvim/nvim-config/start-screen.vim
source $HOME/.config/nvim/nvim-config/vim-test.vim

source $HOME/.config/nvim/nvim-config/leader.vim

" Miscellaneous
let g:python3_host_prog='/opt/homebrew/bin/python3'

command! LF FloatermNew lf
let g:airline#extensions#tabline#enabled=1
let g:vim_markdown_folding_disabled = 1

let g:rooter_patterns = ['.git']

" lf Config
let g:lf_replace_netrw = 1 " Open lf when vim opens a directory
let g:lf_width = 0.9
let g:lf_height = 0.7

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
