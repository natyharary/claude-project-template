#!/bin/bash
# PostToolUse hook: runs after Edit or Write tool calls.
# Auto-formats the modified file if a formatter is configured.
# Exit 0 = allow, exit 2 = block with message.

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE" ]; then
  exit 0
fi

# --- Prettier (JS/TS/JSON/CSS/MD) ---
if command -v npx &>/dev/null && [ -f "package.json" ]; then
  case "$FILE" in
    *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.md)
      npx prettier --write "$FILE" --log-level silent 2>/dev/null
      ;;
  esac
fi

# --- Black (Python) ---
if command -v black &>/dev/null; then
  case "$FILE" in
    *.py) black "$FILE" --quiet 2>/dev/null ;;
  esac
fi

# --- gofmt (Go) ---
if command -v gofmt &>/dev/null; then
  case "$FILE" in
    *.go) gofmt -w "$FILE" 2>/dev/null ;;
  esac
fi

exit 0
