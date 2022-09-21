" cSpell:ignore prevchunk prevconflict lfcd goyo
let mapleader=" "

nnoremap <silent><leader>0 :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent><leader>' :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent><leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent><leader>4 :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <silent><leader>5 :lua require("harpoon.ui").nav_file(5)<CR>
nnoremap <silent><leader>6 :lua require("harpoon.ui").nav_file(6)<CR>
nnoremap <silent><leader>7 :lua require("harpoon.ui").nav_file(7)<CR>
nnoremap <silent><leader>8 :lua require("harpoon.ui").nav_file(8)<CR>
nnoremap <silent><leader>9 :lua require("harpoon.ui").nav_file(9)<CR>

nmap <leader>% :source %<cr>
nmap <leader>/ :noh<cr>
nmap <leader><leader> <Plug>(coc-fix-current)
nmap <leader><tab> :bp<cr>
nmap <leader>a <Plug>(coc-codeaction)
nmap <leader>bsd :%bd\|e#\|bd#<cr>\|'"
nmap <leader>bd :bd<cr>
nmap <leader>en <Plug>(coc-diagnostic-next)
nmap <leader>ee <Plug>(coc-fix-current)
nmap <leader>ep <Plug>(coc-diagnostic-prev)
nmap <leader>f :Lfcd<cr>
nmap <leader>gb <Plug>(coc-git-blame)<cr>
nmap <leader>gc :CocCommand git.showCommit<cr>
nmap <leader>gdc :CocCommand git.diffCached<cr>
nmap <leader>gen <Plug>(coc-git-prevconflict)<cr>
nmap <leader>gep <Plug>(coc-git-nextconflict)<cr>
nmap <leader>gg :CocCommand git.chunkStage<cr>
nmap <leader>gi :CocCommand git.chunkInfo<cr>
nmap <leader>gn <Plug>(coc-git-nextchunk)<cr>
nmap <leader>go :CocCommand git.browserOpen<cr>
nmap <leader>gP :CocCommand git.push<cr>
nmap <leader>gp <Plug>(coc-git-prevchunk)<cr>
nmap <leader>gs :GitStatus<cr>
nmap <leader>gt :CocCommand git.toggleGutters<cr>
nmap <leader>gu :CocCommand git.chunkUndo<cr>
nmap <leader>gU :CocCommand git.chunkUnstage<cr>
nmap <leader>gy :CocCommand git.copyUrl<cr><cr>
nmap <leader>gz :CocCommand git.foldUnchanged<cr>
nmap <leader>h :HopWord<cr>
nmap <leader>j :<C-u>CocNext<CR>
nmap <leader>k :<C-u>CocPrev<CR>
nmap <leader>l :HopLine<cr>
nmap <leader>m :MaximizerToggle!<cr>
nmap <leader>n :bn<cr>
nmap <leader>o :<C-u>CocList outline<cr>
nmap <leader>p :bp<cr>
nmap <leader>q :wq!<cr>
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>s :<C-u>CocList -I symbols<cr>

nnoremap <leader>\ <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>bb <cmd>lua require('telescope.builtin').buffers()<cr>
omap ag <Plug>(coc-git-chunk-outer)
omap ig <Plug>(coc-git-chunk-inner)
xmap ag <Plug>(coc-git-chunk-outer)
xmap ig <Plug>(coc-git-chunk-inner)
