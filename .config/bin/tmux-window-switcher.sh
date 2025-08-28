#!/usr/bin/env bash

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
