#!/usr/bin/env bash

cd ~/c/nu || exit
WORKTREE=$(ls -d */ | tr -d '\n' | sed 's/\//\n/g' | gum filter --limit 1 --placeholder "Choose a Nutiliti worktree" --prompt="🏘️")
echo "🏘️ $WORKTREE"

cd ~/c/nu/$WORKTREE || exit
CHOICE=$(sesh list -z | grep "~/c/nu/$WORKTREE" | gum filter --limit 1 --placeholder "Choose sessions" --prompt="🏠")

sesh connect "$CHOICE"
tmux kill-session -t nutiliti\ worktrees
