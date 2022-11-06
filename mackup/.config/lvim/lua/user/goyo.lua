local M = {}

M.config = function()
  -- Color name (:help cterm-colors) or ANSI code
  vim.cmd([[
    function! s:goyo_enter()
      if executable('tmux') && strlen($TMUX)
        silent !tmux set status off
        silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
      endif
      set noshowcmd
      set noshowmode
      set scrolloff=999
      set spell spelllang=en_us
      set wrap
      set nolist
      set linebreak
      lua require('lualine').hide()
    endfunction

    function! s:goyo_leave()
      if executable('tmux') && strlen($TMUX)
        silent !tmux set status on
        silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
      endif
      set nospell
      set nowrap
      set scrolloff=5
      set showcmd
      set showmode
      lua require('lualine').hide({unhide=true})
    endfunction

    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
  ]])
end

return M
