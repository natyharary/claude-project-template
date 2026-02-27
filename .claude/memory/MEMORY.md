# Project Memory

This file is auto-loaded at session start (first 200 lines). Keep it concise.
Link to topic files for details. Update entries as you learn — don't accumulate stale notes.

## Architecture
<!-- Link to architecture.md when filled in -->
- Stack: <!-- TODO -->
- Entry point: <!-- TODO -->
- Key dependencies: <!-- TODO -->

## Patterns & Conventions
See [patterns.md](patterns.md):
<!-- Summarize top patterns here as they emerge -->

## Recurring Issues & Solutions
See [debugging.md](debugging.md):
<!-- Summarize gotchas here as they're discovered -->

## Multi-Agent Pipeline
- 5 agents: pm (opus), planner (opus), coder (sonnet), tester (sonnet), git-handler (sonnet)
- Shared state: `.claude/pipeline/tasks.md` (gitignored)
- Only Planner has Task tool; only Git Handler runs git mutations
- Commands: `/pipeline`, `/pipeline-status`, `/pipeline-reset`
- Worktrees: `.claude/worktrees/` (gitignored)
- Archive: `.claude/pipeline/archive/` (kept in git)

## User Preferences
<!-- Things the user has explicitly asked to always/never do -->
- CLI-first: do not add web server or API unless user asks
- Keep it simple: no premature abstractions
