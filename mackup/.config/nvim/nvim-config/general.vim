set nocompatible
filetype indent plugin on
set updatetime=100
set cursorline
set hidden
set wildmenu
set showcmd
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set lazyredraw
set autoindent
set nostartofline
set ruler
set cmdheight=1
set laststatus=2
set confirm
set mouse=a
set number
set hid
set notimeout ttimeout ttimeoutlen=200
set nowrap
set t_Co=256

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set encoding=UTF-8

" Turn backup off
set nobackup
set nowb
set noswapfile

" Indentation 
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set colorcolumn=80,120

set rtp+=/usr/local/opt/fzf

" Remap yank & paste
vnoremap <C-c> "+y
map <C-p> "+P

" Yank to end of line
nnoremap Y yg_

" Center next search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Better J cursor position
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap ( (<c-g>u
inoremap ) )<c-g>u

" Jumplist mutation
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

set completeopt=menuone,noselect

