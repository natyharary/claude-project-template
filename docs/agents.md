---
layout: page
title: Agents
nav_order: 3
---

# Agents Reference

Agents live in `.claude/agents/`. Claude spawns them automatically via the Task tool when a command needs specialized work. You don't invoke agents directly — commands like `/ship` and `/pipeline` handle that.

---

## Pipeline agents

These five agents run as part of the `/pipeline` command. Each owns a specific slice of the work.

### `pm`

**Role**: Product Manager — writes the spec at the start, signs off at the end
**Model**: opus
**Tools**: Read, Edit, Write, Glob, Grep, WebSearch

Runs twice per pipeline:
1. **Spec phase**: Reads `CLAUDE.md`, writes the feature spec to `tasks.md` with goal, acceptance criteria, out-of-scope, and open questions
2. **Sign-off phase**: Reviews evidence from Tester, checks each acceptance criterion, writes approved/rejected status

Never touches source files. If acceptance criteria aren't met, rejects sign-off rather than approving partial work.

---

### `planner`

**Role**: Orchestrator — the only agent with the Task tool
**Model**: opus
**Tools**: Read, Edit, Write, Glob, Grep, Bash, Task, WebFetch

Runs after PM writes the spec. Responsibilities:
- Reads the spec and decomposes into TASK blocks (max 6 per run)
- Creates a git worktree for the feature branch
- Sequences: Coder → Tester → (fix cycle up to 3 rounds) → Git Handler → PM sign-off
- Updates `tasks.md` throughout so all agents share state
- Cleans up the worktree on completion
- Prints a final pipeline summary

The only agent that runs `git worktree` commands. All other git mutations go through Git Handler.

---

### `coder`

**Role**: Implements tasks in the assigned worktree
**Model**: sonnet
**Tools**: Read, Edit, Write, Glob, Grep, Bash

Receives a task description, worktree path, and acceptance criteria. Writes code, runs tests locally, and reports `FILES_TOUCHED` and `RESULT` back to Planner.

Never commits or pushes — that's Git Handler's job.

---

### `tester`

**Role**: Verifies implementation against acceptance criteria
**Model**: sonnet
**Tools**: Read, Bash, Glob, Grep

Read-only — never modifies source files. Runs the project's test command, checks output against the spec's acceptance criteria, and returns a structured pass/fail report.

If it fails, Planner enters a fix cycle: Coder fixes → Tester re-runs, up to 3 rounds.

---

### `git-handler`

**Role**: Owns all git mutations
**Model**: sonnet
**Tools**: Read, Bash

The only agent that runs `git add`, `git commit`, `git push`, and `gh pr create`. Receives a worktree path, branch name, list of files, and commit message. Stages specific files (never `git add .`), commits, pushes, opens a PR, and returns the PR URL.

---

## Utility agents

These agents are used by commands like `/ship`, `/pr-review`, and `/review`.

### `pr-reviewer`

**Role**: Reviews open GitHub PRs
**Model**: sonnet
**Tools**: Read, Bash, Glob, Grep

Fetches the PR diff and all review comments via `gh api`. Returns a structured report with:
- `REVIEW_STATUS`: `approved`, `commented`, or `changes_requested`
- `BLOCKING_COMMENTS`: list with file path, line number, and comment body
- `CI_STATUS`: passing/failing/unknown
- Non-blocking nits

Read-only — never posts comments to the PR.

---

### `simplifier`

**Role**: Cleans up code after a feature is implemented
**Model**: sonnet
**Tools**: Read, Edit, Grep, Glob, Bash

Removes duplication, simplifies logic, and eliminates over-engineering — without changing behavior. Run after a feature is complete, before opening a PR.

---

### `verifier`

**Role**: Verifies that a feature or fix works correctly
**Model**: sonnet
**Tools**: Read, Bash, Grep, Glob

Runs tests, executes the CLI with real inputs, diffs behavior against main, and reports pass/fail with evidence. Used by `/verify`.

---

### `researcher`

**Role**: Researches a technical question before implementation
**Model**: sonnet
**Tools**: Read, Glob, Grep, Bash, WebSearch, WebFetch

Investigates a library, API, or approach and returns a structured recommendation. Use before implementing something unfamiliar to avoid going down the wrong path.
