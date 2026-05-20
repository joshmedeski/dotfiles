#!/bin/bash

# TODO: read the issue and smartly compare it to the work
# TODO: call out any work that might be missing and ask clarifying questions
# TODO: generate a concise PR description based on the issue and commits
# TODO: make it clear if it's follow up work from issue comments (seeing if there are any previous PRs linked to the issue)
# TODO: automatically move the issue to the "In Review" column on PR creation (using GitHub Actions?)
# TODO: genreate a title
# TODO: have the script automatically generate the PR instead of a popup
# TODO: create a PR chat instead of a command (to ask clarifying questions and be able to hit the github MPC when done.
# TODO: ask me who might be a good reviewer based on past PRs on this issue or files changed
# TODO: open the PR web page once everything is done
# TODO: verify if any of the suggested tests have been written
# TODO: audit to make sure nothing important was missing
# TODO: do code review on the diff to make sure nothing looks out of place (like debug statements, or incomplete work, or potential bugs)
# TODO: run build and tests locally before confirming PR is ready
# TODO: automatically fix any ovious issues (like linting errors, or debug statements)
# TODO: audit the commit history and suggest squashing or reordering commits for clarity
# TODO: move all of this to an CLI skill
# TODO: automatically capture screenshots of the integration test(s) and upload to the PR description (if relevant)

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
COMMITS="$(git log main..HEAD --format="- %s%n%b")"

echo "## Commits for #$ISSUE_NUMBER\n
$COMMITS
" | pbcopy

# ## Issue #$ISSUE_NUMBER
# $ISSUE_CONTENT
# " | pbcopy

open raycast://ai-commands/pr-description-generator


