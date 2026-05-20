#!/usr/bin/env bash

tmux set-option status off 

sesh connect $(fd -t d -d 1 | xargs ls -dt | awk '{print $NF}' | fzf --ansi  --preview-window 'right:70%' --preview 'eza --tree --level 2 --color=always --icons=always --git-ignore {}')

exit

