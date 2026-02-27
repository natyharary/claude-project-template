# PR Address

Address open reviewer comments on the current branch's PR. Two-phase: plan first, implement only after confirmation.

**Usage**: `/pr-address [PR number]`

If no PR number is given, resolves from the current branch.

---

## Phase 1 — Fix Plan (read-only, runs immediately)

### 1. Resolve PR Number

If `$ARGUMENTS` contains a number, use it.

Otherwise:
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
gh pr list --head $BRANCH --json number -q '.[0].number'
```

If no PR found: stop with "No open PR found for the current branch. Pass a PR number explicitly."

### 2. Fetch Open Review Comments

```bash
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# Inline diff comments (unresolved)
gh api repos/$REPO/pulls/$PR_NUMBER/comments

# PR-level reviews with CHANGES_REQUESTED state
gh api repos/$REPO/pulls/$PR_NUMBER/reviews
```

Filter to only unresolved/open comments. Ignore comments that are already marked as resolved or that belong to approved reviews.

### 3. Group and Display Fix Plan

Group comments by file. For each comment, show:

```
FIX PLAN
========
PR #<n>: <title>
Total blocking comments: <count>
Total nits: <count>

FILE: <path>
  [<reviewer>] Line <n>: <comment body>
  Proposed fix: <1-sentence description of what to change>

FILE: <path>
  [<reviewer>] Line <n>: <comment body>
  Proposed fix: <1-sentence description of what to change>
```

If there are no open comments: "No open review comments found on PR #<n>. Nothing to address."

### 4. STOP — Wait for Confirmation

**Hard stop here.** Print:

```
---
Ready to implement the fixes above.
Type "yes" to proceed, or describe any changes to the plan.
---
```

Do NOT proceed to Phase 2 until the user explicitly confirms.

---

## Phase 2 — Implement (only after user says yes)

### 5. Spawn Coder Agents

For each blocking comment (and any nits the user wants addressed):

Spawn the `coder` agent via the Task tool. Pass:
- File path
- Line number
- Comment body (full text)
- Reviewer name
- Proposed fix description
- Instruction: work in the **current directory** (the PR branch is already checked out — no worktree)

Run coder agents sequentially if fixes touch the same file; parallel if different files.

### 6. Spawn Git Handler

After all coder agents complete, spawn the `git-handler` agent once with:
- Union of all `FILES_TOUCHED` from coder results
- Commit message: `address PR review comments: <comma-separated list of files>`
- Branch: current branch (push to existing PR — do NOT create a new PR)
- Instruction: commit + push only, no `gh pr create`

Wait for Git Handler to complete.

### 7. Report Results

Print:
```
ADDRESSED
=========
Commit: <hash>
Pushed to: <branch>
Comments addressed:
- <file>:<line> — <reviewer>: <short comment>
- ...
```

If any coder agent failed, list the failures and suggest running `/pr-address` again or fixing manually.

---

**Note**: This command only pushes to the existing PR branch. It never creates a new PR.
