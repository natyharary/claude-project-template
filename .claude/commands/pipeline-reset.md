# Pipeline Reset

Archive the current pipeline state and clean up worktrees. Use this when a pipeline failed, got stuck, or you want to start fresh.

---

## 1. Check current state

Read `.claude/pipeline/tasks.md` using the Read tool (not Bash). If it doesn't exist, report "No active pipeline found" and skip to step 4.

Show the user the current state so they can confirm before proceeding.

## 2. Archive tasks.md

Use the Bash tool to run:

```bash
mkdir -p .claude/pipeline/archive && ts=$(date +%Y%m%d-%H%M%S) && test -f .claude/pipeline/tasks.md && cp .claude/pipeline/tasks.md ".claude/pipeline/archive/tasks-${ts}.md" && echo "Archived to .claude/pipeline/archive/tasks-${ts}.md" || echo "Nothing to archive"
```

## 3. Remove tasks.md

Use the Bash tool to run:

```bash
rm -f .claude/pipeline/tasks.md && echo "Removed .claude/pipeline/tasks.md"
```

## 4. List and remove worktrees

Use the Bash tool to run:

```bash
git worktree list 2>/dev/null || echo "Not a git repo"
```

```bash
ls .claude/worktrees/ 2>/dev/null && echo "Worktrees found" || echo "No worktrees to clean up"
```

For each worktree listed under `.claude/worktrees/`, use the Bash tool to remove it:

```bash
git worktree remove .claude/worktrees/<name> --force
```

If worktree removal fails (not a git repo, already removed), skip it silently.

## 5. Confirm

Report to the user:
- Whether tasks.md was archived and where
- Which worktrees were removed
- Current state: ready for a new `/pipeline <feature>` run

**Note**: Archived pipeline files in `.claude/pipeline/archive/` are kept so you can review what was attempted. Delete them manually if not needed.
