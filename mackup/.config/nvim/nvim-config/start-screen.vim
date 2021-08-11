let g:startify_session_dir = '~/.config/nvim/sessions'

let g:startify_lists = [
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'files',     'header': ['   Files']            },
  \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
\ ]

let g:startify_bookmarks = [
  \ { 'a': '~/.config/alacritty/alacritty.yml' },
  \ { 'f': '~/.config/fish/config.fish' },
  \ { 'p': '~/.config/nvim/nvim-config/plugins.vim' },
  \ { 'r': '~/repos' },
  \ { 't': '~/.config/tmux/tmux.conf' },
  \ { 'v': '~/.config/nvim/init.vim' },
\ ]
