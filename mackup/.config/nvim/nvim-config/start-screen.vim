let g:startify_session_dir = '~/.config/nvim/sessions'
let g:startify_enable_special = 0

function! s:gitModified()
  let files = systemlist('git ls-files -m 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

function! s:gitUntracked()
  let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
  \ { 'type': function('s:gitModified'),  'header': ['   Modified']},
  \ { 'type': function('s:gitUntracked'), 'header': ['   Untracked']},
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
\ ]
