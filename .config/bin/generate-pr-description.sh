#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate PR Description
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Git

# Documentation:
# @raycast.description Generates a pull request description using the issue and commit details
# @raycast.author joshmedeski
# @raycast.authorURL https://raycast.com/joshmedeski

PANE_CURRENT_PATH=$(tmux display-message -p '#{pane_current_path}')

cd "$PANE_CURRENT_PATH" || exit 1

# Get current branch name
BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"

# Extract issue number from branch name (e.g., feature/123-some-feature -> 123)
ISSUE_NUMBER=$(echo "$BRANCH_NAME" | grep -o '[0-9]\+' | head -n 1)

# Exit if no issue number found
if [ -z "$ISSUE_NUMBER" ]; then
  echo "❌ No issue number found in branch name: $BRANCH_NAME"
  exit 1
fi

# Get issue content from GitHub
# ISSUE_CONTENT=$(gh issue view "$ISSUE_NUMBER" --json title,body --jq '.title + "\n\n" + .body' 2>/dev/null)

# if [ $? -ne 0 ]; then
#   echo "⚠️  Could not fetch issue #$ISSUE_NUMBER, continuing without it..."
#   ISSUE_CONTENT=""
# fi

# Get commits with clear formatting for AI parsing
COMMITS="$(git log main...HEAD --format="- %s%n%b")"

echo "## Commits for #$ISSUE_NUMBER\n
$COMMITS
" | pbcopy

# ## Issue #$ISSUE_NUMBER
# $ISSUE_CONTENT
# " | pbcopy

open raycast://ai-commands/pr-description-generator


