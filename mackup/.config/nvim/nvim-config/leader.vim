" new keyboard shortcuts to learn
" coc-git
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" navigate conflicts of current buffer
nmap [c <Plug>(coc-git-prevconflict)
nmap ]c <Plug>(coc-git-nextconflict)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
nmap gb <Plug>(coc-git-blame)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" learned
nmap <leader>% :source %<cr>
nmap <leader>' :Marks<cr>
nmap <leader>/ :noh<cr>
nmap <leader>1 :source ~/.vimrc \| :PlugInstall<cr>
nmap <leader><return> :w!<cr>
nmap <leader><tab> :bp<cr>
nmap <leader>a :CocAction<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>bb :Buffers<cr>
nmap <leader>bd :bd<cr>
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>
nmap <leader>bsd :%bd\|e#\|bd#<cr>\|'"
nmap <leader>en <Plug>(coc-diagnostic-next)
nmap <leader>ep <Plug>(coc-diagnostic-prev)
nmap <leader>f :Lfcd<cr>
nmap <leader>g :Goyo<cr>
nmap <leader>h :HopWord<cr>
nmap <leader>j :Files<cr>
nmap <leader>l :HopLine<cr>
nmap <leader>m :MaximizerToggle!<cr>
nmap <leader>n :bn<cr>
nmap <leader>p :bp<cr>
nmap <leader>r :Rg<cr>
nmap <leader>wf :MaximizerToggle!<cr>
