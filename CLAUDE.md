# Project Instructions for Claude Code

## Project Overview
<!-- TODO: Describe what this project does in 2-3 sentences -->

## Development Philosophy
- Start as a CLI tool (stdin/stdout). Only add a web server or API layer when explicitly requested.
- Keep it simple. Don't add abstractions, error handling, or features that weren't asked for.
- Verify your own work — run tests, check output, diff behavior before calling something done.

## Tech Stack
<!-- TODO: Fill in after project setup -->
- Language:
- Runtime:
- Package manager:
- Test command:
- Lint/format command:
- Build command:

## Key Files & Directories
<!-- TODO: Fill in as the project grows -->

## Code Style
<!-- TODO: Add project-specific conventions -->
- Follow existing patterns in the codebase
- Keep functions small and focused
- No commented-out code; delete it

## Testing
- Always run tests before marking a task done
- Write tests for new behavior, not just happy paths
- Test command: `<!-- TODO -->`

## Common Mistakes to Avoid
<!-- Add entries here whenever Claude does something wrong — prevents repetition -->

## Workflow
- Use Plan mode (shift+tab twice) for non-trivial tasks before writing code
- After planning, switch to auto-accept edits for execution
- Use subagents for parallel workstreams (see `.claude/agents/`)
- Use slash commands for repeated workflows (see `.claude/commands/`)

## CLI → API/Server Progression
This project starts as a CLI tool. To graduate to the next tier, the user must explicitly request it:
1. **CLI** (default): stdin/stdout, run with `node index.js` or equivalent
2. **API server**: add only when user asks — minimal HTTP layer over existing logic
3. **Full web app**: add only when user asks — frontend + backend
