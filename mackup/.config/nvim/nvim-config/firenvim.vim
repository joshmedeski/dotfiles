if exists('g:started_by_firenvim')
  set laststatus=0
else
  set laststatus=2
endif

au BufEnter github.com_*.txt set filetype=markdown
