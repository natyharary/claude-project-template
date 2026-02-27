#!/bin/bash
# Stop hook: runs when Claude finishes a session/task.
# Use this to trigger verification agents, send notifications, or run cleanup.

# --- System notification (macOS) ---
if command -v osascript &>/dev/null; then
  osascript -e 'display notification "Claude has finished. Check output." with title "Claude Code"' 2>/dev/null
fi

# --- Linux notification ---
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code" "Claude has finished. Check output." 2>/dev/null
fi

# --- Optional: run tests after every session ---
# Uncomment to auto-verify after each stop:
# npm test --silent 2>&1 | tail -5

exit 0
