---
layout: page
title: Commands
nav_order: 2
---

# Commands Reference

Slash commands live in `.claude/commands/`. Type `/command-name` in Claude Code to invoke them.

---

## Primary workflow

### `/ship`

**Usage**: `/ship "feature description"`

The main command. Runs the full plan → build → review → PR loop in one shot.

1. Enters plan mode with your feature description
2. Asks clarifying questions until the plan is concrete
3. Gets your confirmation before writing any code
4. Builds the feature, runs tests
5. Opens a PR and spawns the `pr-reviewer` agent
6. Fixes any blocking review issues (up to 2 rounds)
7. Asks for your confirmation before merging
8. Merges with squash and cleans up the branch

**When to use it**: For most feature work. Claude handles the loop; you confirm at the plan stage and again before merge.

---

## Commit and PR commands

### `/commit`

**Usage**: `/commit`

Stages all changes and writes a commit message. Does not push.

**When to use it**: Quick fixes where you just need a clean commit message.

---

### `/commit-push-pr`

**Usage**: `/commit-push-pr`

Stages, commits, pushes the branch, and opens a PR with a summary and test plan.

**When to use it**: You've already built something and just want to get it into a PR without going through the full `/ship` loop.

---

### `/pr-review`

**Usage**: `/pr-review [PR number]`

Spawns the `pr-reviewer` agent on an open PR. If no PR number is given, detects the PR from the current branch.

Returns a structured report with:
- `REVIEW_STATUS`: `approved`, `commented`, or `changes_requested`
- Blocking comments with file paths and line numbers
- Non-blocking nits

**Note**: Read-only — does not post any comments to the PR.

---

### `/pr-address`

**Usage**: `/pr-address [PR number]`

Reads all open review comments on the PR and fixes them. Commits and pushes the fixes. Use after `/pr-review` finds blocking issues.

---

### `/pr-merge`

**Usage**: `/pr-merge [PR number]`

Runs a final review, shows a summary, and asks for your confirmation before squash-merging and deleting the branch.

---

## Quality commands

### `/verify`

**Usage**: `/verify`

Runs the project's test command (from `CLAUDE.md`) and checks output. Reports pass/fail with evidence. Use before opening a PR to catch issues early.

---

### `/review`

**Usage**: `/review`

Code review of the current changes (staged + unstaged). Checks for correctness, security issues, complexity, and test coverage.

---

### `/fix-ci`

**Usage**: `/fix-ci [run ID or URL]`

Fetches a failing CI run, reads the error output, diagnoses the root cause, and fixes it. Commits the fix.

---

### `/techdebt`

**Usage**: `/techdebt`

Scans the codebase for tech debt: dead code, duplicated logic, missing tests, over-engineering. Returns a prioritized list of issues without making changes.

---

## Pipeline commands

For large features with multiple files or unclear requirements, use the 5-agent pipeline instead of `/ship`.

### `/pipeline`

**Usage**: `/pipeline "feature description"`

Launches the full multi-agent pipeline:
1. PM agent writes the feature spec
2. Planner decomposes into tasks and orchestrates
3. Coder implements each task in an isolated git worktree
4. Tester verifies against acceptance criteria
5. Git Handler commits, pushes, and opens a PR
6. PM signs off

Add `--with-review` to also run the PR review and merge cycle:
```
/pipeline --with-review "add CSV export"
```

**When to use it**: Feature touches multiple files, has unclear requirements, or you want full traceability via `tasks.md`.

---

### `/pipeline-status`

**Usage**: `/pipeline-status`

Shows the current state of `.claude/pipeline/tasks.md` — which tasks are pending, in-progress, done, or failed.

---

### `/pipeline-reset`

**Usage**: `/pipeline-reset`

Archives the current `tasks.md` to `.claude/pipeline/archive/` and cleans up any leftover worktrees. Run this if a pipeline gets stuck or you want to start fresh.

---

## Setup

### `/init-project`

**Usage**: `/init-project`

Interactive interview that fills in all the TODOs in `CLAUDE.md`. Asks about:
- What the project does
- Tech stack (language, runtime, package manager)
- Test, lint, and build commands
- Key files and directories

Run this once after cloning the template.
