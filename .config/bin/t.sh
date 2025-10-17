#!/usr/bin/env bash

CURRENT_SESSION="$(tmux display-message -p '#S')"
IS_ATTACHED="$(tmux ls | grep attached)"
eval "$(zoxide init bash)"

if tmux info &> /dev/null; then
  # tmux is running
  tmux a && tmux choose-session;
else
  # tmux is NOT running
  REPO="$(ls ~/repos | fzf)"
  z $REPO
  tmux new -s $REPO
  exit;
fi


if [ "$#" -eq  "0" ]; then
  # has argument
  if [ "$IS_ATTACHED" = '' ]; then
    # is NOT attached
    tmux a && tmux choose-session;
  else
    # is attached
    tmux choose-session;
  fi
else
  if [ "$CURRENT_SESSION" = "$1" ]; then
    # arugment matches session
    echo "Already in $1"
  else
    # arugment does NOT matche session
    tmux switch -t $1 || z $1 && tmux new -ds $1 && tmux switch -t $1
  fi
fi

