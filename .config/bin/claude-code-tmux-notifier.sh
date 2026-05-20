#!/usr/bin/env bash
# Claude Code notification hook
# Usage: notify.sh <title> [jq_expression] [icon_path]
# Reads JSON from stdin, extracts message, sends macOS notification

set -euo pipefail

TITLE="${1:?Usage: notify.sh <title> [jq_expression] [icon_path]}"
JQ_EXPR="${2:-.message}"
ICON="${3:-}"

SESS=$(tmux display-message -p '#S')
CLIENT=$(tmux display-message -p '#{client_tty}')
EXEC_CMD="/opt/homebrew/bin/tmux switch-client -c $CLIENT -t '$SESS'; open -b com.github.wez.wezterm"
MSG=$(jq -r "$JQ_EXPR")

# Skip notification if user is already looking at this session in WezTerm
FRONTMOST=$(osascript -e 'tell application "System Events" to get bundle identifier of first application process whose frontmost is true' 2>/dev/null || echo "")
if [[ "$FRONTMOST" == "com.github.wez.wezterm" ]]; then
  CURRENT_SESS=$(tmux list-clients -F '#{client_activity} #{session_name}' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2- || echo "")
  if [[ "$CURRENT_SESS" == "$SESS" ]]; then
    exit 0
  fi
fi

NOTIFIER_ARGS=(
  --app-icon "/Applications/Claude.app/Contents/Resources/electron.icns"
  --title "$SESS"
  --subtitle "$TITLE"
  --message "$MSG"
  --group "$SESS"
)

if [[ -n "$ICON" && -f "$ICON" ]]; then
  NOTIFIER_ARGS+=(--content-image "$ICON")
fi

RESULT=$(alerter "${NOTIFIER_ARGS[@]}" 2>/dev/null || true)

if [[ "$RESULT" == "@CONTENTCLICKED" ]]; then
  eval "$EXEC_CMD"
fi
