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
- **Never push directly to main or master.** All changes go through a PR.
- Always work on a feature branch. Use `/commit-push-pr` to open a PR, or `/pipeline` for larger work.
- Use Plan mode (shift+tab twice) for non-trivial tasks before writing code
- After planning, switch to auto-accept edits for execution
- Use subagents for parallel workstreams (see `.claude/agents/`)
- Use slash commands for repeated workflows (see `.claude/commands/`)

## Multi-Agent Pipeline

For feature-sized work, use the 5-agent pipeline instead of working directly in the session.

### When to use what

| Task size | Approach |
|---|---|
| Quick fix, typo, small change | Edit directly, `/commit` |
| Single feature, well-understood | `/verify` → `/commit-push-pr` |
| Feature with unclear requirements or multiple files | `/pipeline "description"` |

### The 5 agents and what they own

| Agent | Owns | Model |
|---|---|---|
| **PM** | Feature spec (start) + sign-off (end) | opus |
| **Planner** | Orchestration, task decomposition, worktree lifecycle | opus |
| **Coder** | Source file changes in assigned worktree | sonnet |
| **Tester** | Verification against acceptance criteria (read-only) | sonnet |
| **Git Handler** | All git mutations: stage, commit, push, PR | sonnet |

Only Planner has the Task tool. Only Git Handler runs `git add/commit/push`.

### Quick reference

```
/pipeline "add CSV export to the CLI"   # launch full pipeline
/pipeline-status                         # check current pipeline state
/pipeline-reset                          # archive state, clean worktrees, start fresh
```

### Shared state

All agents read and write `.claude/pipeline/tasks.md` — a flat markdown file with four sections:
1. `## Request` — original feature description (written by PM, immutable)
2. `## Spec` — goal + acceptance criteria checkboxes (written by PM)
3. `## Tasks` — TASK blocks with STATUS, ASSIGNED_TO, FILES_TOUCHED, RESULT (written by Planner, updated by each agent)
4. `## Sign-off` — final approval (written by PM at end)

Transient files (tasks.md, worktrees) are gitignored. Archived pipeline runs live in `.claude/pipeline/archive/`.

## CLI → API/Server Progression
This project starts as a CLI tool. To graduate to the next tier, the user must explicitly request it:
1. **CLI** (default): stdin/stdout, run with `node index.js` or equivalent
2. **API server**: add only when user asks — minimal HTTP layer over existing logic
3. **Full web app**: add only when user asks — frontend + backend
