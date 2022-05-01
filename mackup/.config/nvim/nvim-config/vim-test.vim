" vim-test
" https://github.com/vim-test/vim-test
" See leader.vim for related snippets
let g:test#runner_commands = ['Jest']
let g:test#javascript#runner = 'jest'
let test#javascript#jest#executable = 'npx vitest'

if has('nvim')
  let test#strategy = "vimux"
  let test#neovim#term_position = "belowright"
else
  let test#strategy = "vimterminal"
  let test#vim#term_position = "belowright"
endif

