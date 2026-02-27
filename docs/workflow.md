---
layout: page
title: Workflow
nav_order: 4
---

# Workflow Guide

This template is designed around a simple loop: **describe what you want → Claude plans and confirms → Claude builds and reviews → you approve the merge**.

---

## The `/ship` loop

`/ship` is the primary command. Here's what happens when you run it:

### Step 1: Plan (with your confirmation)

Claude enters plan mode with your feature description. It explores the codebase, asks clarifying questions if anything is ambiguous, and produces a concrete implementation plan.

When the plan is ready, Claude summarizes it and asks:

> "Does this look right? Say yes to start building, or tell me what to change."

**Hard stop.** Claude waits for your confirmation before writing any code. If you have feedback, Claude revises the plan. This is the right moment to catch misunderstandings before they become code.

---

### Step 2: Build

Claude implements the feature. If a test command is configured in `CLAUDE.md`, it runs tests after implementing. If tests fail, Claude fixes and re-runs before proceeding — it won't move forward with a broken build.

---

### Step 3: Commit and open PR

Claude creates a feature branch, commits, pushes, and opens a PR with a summary.

---

### Step 4: Review

Claude spawns the `pr-reviewer` agent on the PR. The reviewer returns a structured report:

- **`approved`** or **`commented`** (nits only): Continue to merge
- **`changes_requested`**: Claude fixes each blocking issue, pushes to the same branch, and re-runs the review (up to 2 rounds)

If review still has blocking issues after 2 fix rounds, Claude stops and surfaces the remaining issues for your input.

---

### Step 5: Merge (with your confirmation)

Claude shows a final summary:

```
READY TO MERGE
==============
PR #42: add CSV export
CI: passing
Review: approved
Commits: 3
Files changed: 4
```

Then asks:

> "Merge to main? [yes / no]"

**Hard stop.** Claude waits. On yes, it squash-merges, deletes the branch, and syncs local main.

---

## Choosing the right command

| Situation | Command |
|-----------|---------|
| Building a new feature | `/ship "description"` |
| Quick fix, just need a commit | `/commit` |
| Already built something, want a PR | `/commit-push-pr` |
| Review a PR before merging | `/pr-review` |
| Address review comments | `/pr-address` |
| Merge after review | `/pr-merge` |
| Large feature, multiple files | `/pipeline "description"` |
| Check tests before committing | `/verify` |
| Audit for tech debt | `/techdebt` |
| CI is failing | `/fix-ci` |

---

## When to use `/pipeline` instead of `/ship`

`/ship` handles most work. Use `/pipeline` when:

- The feature touches many files and you want full task traceability
- You want an isolated git worktree per feature (keeps main clean during implementation)
- You want PM-style acceptance criteria and sign-off
- The feature is large enough that it benefits from a structured decomposition into subtasks

The pipeline runs autonomously and posts a final summary. Add `--with-review` to also run the PR review and merge cycle:

```
/pipeline --with-review "add user authentication"
```

---

## Rules Claude always follows

- **Never pushes directly to main.** All changes go through a PR.
- **Never skips the review step.** Even in `/ship`, the `pr-reviewer` agent always runs.
- **Never merges without your confirmation.** Both `/ship` and `/pipeline --with-review` ask before merging.
- **Stops on unexpected failures.** Claude reports issues and waits for input rather than working around them silently.

---

## Configuring the workflow

The behavior Claude follows is controlled by `CLAUDE.md`. Key things to set after cloning:

- **Test command** — Claude runs this after building and before merging
- **Tech stack** — informs how Claude writes code and installs dependencies
- **Key files** — helps Claude navigate the codebase faster
- **Common mistakes** — add entries here when Claude does something wrong; it reads this section before starting

Run `/init-project` to fill in these fields interactively.
