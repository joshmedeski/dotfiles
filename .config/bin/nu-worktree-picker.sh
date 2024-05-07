#!/usr/bin/env bash

cd ~/c/nu
# echo all dirs in ~/c/nu with new line separator
WORKTREE=$(ls -d */ | tr -d '\n' | sed 's/\//\n/g' | gum filter --limit 1 --placeholder "Choose a Nutiliti worktree" --prompt="🏘️")
echo "🏘️ $WORKTREE"

cd ~/c/nu/$WORKTREE
CHOICES=$(sesh list -z | grep "~/c/nu/$WORKTREE" | gum filter --placeholder "Choose sessions" --prompt="🏠")

echo $CHOICES
