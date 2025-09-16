#!/usr/bin/env bash

# NOTE: use this instead, the -S flag will switch the the window name if it exists
# bind -N "⌘+g lazygit" g new-window -S -n '🌳' 'lazygit'

WINDOW_NAME="$1"
CMD="$2"

if [ -z "$WINDOW_NAME" ]; then
  exit 1
fi

if [ -z "$CMD" ]; then
  exit 1
fi

if tmux list-windows -F "#{window_name}" | grep -q -x "$WINDOW_NAME"; then
  tmux select-window -t "$WINDOW_NAME"
else
  tmux new-window -n "$WINDOW_NAME" "$CMD"
fi
