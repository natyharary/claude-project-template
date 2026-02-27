#!/bin/bash
# Notification hook: fires when Claude needs user input or approval.
# Useful when running parallel sessions across terminal tabs.

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude needs your attention"')

# --- macOS ---
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\" sound name \"Ping\"" 2>/dev/null
fi

# --- Linux ---
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code" "$MESSAGE" 2>/dev/null
fi

# --- Terminal bell fallback ---
echo -e "\a"

exit 0
