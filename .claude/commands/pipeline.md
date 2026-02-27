# Pipeline

Launch the full multi-agent pipeline for feature-sized work.

**Usage**: `/pipeline <feature description>`

**When to use this** (vs simpler alternatives):
- Feature touches multiple files or has unclear requirements → use `/pipeline`
- Quick fix or single-file change → use `/commit` or `/verify` + `/commit-push-pr`
- Already know exactly what to do → use `/commit-push-pr`

---

Run the following steps:

## 1. Validate

Check that `.claude/pipeline/tasks.md` does not already exist with an in-progress pipeline. Use the Bash tool to run:

```bash
test -f .claude/pipeline/tasks.md && grep -q "STATUS: in_progress" .claude/pipeline/tasks.md && echo "CONFLICT" || echo "OK"
```

If the output is `CONFLICT`: stop and tell the user to run `/pipeline-reset` first.

## 2. Create pipeline directory

Use the Bash tool to run:

```bash
mkdir -p .claude/pipeline .claude/pipeline/archive .claude/worktrees
```

## 3. Launch PM (spec phase)

Check if `$ARGUMENTS` starts with `--with-review`:
- If yes: strip `--with-review` from the arguments. The remaining text is the feature description. Set `WITH_REVIEW=true`.
- If no: the full `$ARGUMENTS` is the feature description. Set `WITH_REVIEW=false`.

Spawn the PM agent to write the feature spec. Pass it:
- The feature description (with `--with-review` stripped if present)
- If `WITH_REVIEW=true`: instruct the PM to include `WITH_REVIEW: true` on its own line in the `## Request` block of `tasks.md`

The PM agent should:
- Read CLAUDE.md for project context
- Write `.claude/pipeline/tasks.md` with Request, Spec, empty Tasks, and pending Sign-off sections

Wait for PM to complete before proceeding.

## 4. Launch Planner (orchestration)

Spawn the Planner agent. Pass it:
- The feature description: **$ARGUMENTS**
- Location of tasks.md: `.claude/pipeline/tasks.md`

The Planner will:
- Read the spec
- Create a worktree
- Decompose into tasks
- Sequence Coder → Tester → Git Handler → PM sign-off
- Clean up worktree
- Return a final summary

## 5. Display result

Show the Planner's final summary to the user, including:
- PR URL (or reason it wasn't created)
- PM sign-off status
- Test results and fix cycle count
- Any failed tasks

---

**Note**: This command runs the full pipeline autonomously. For large or complex features, consider using Plan mode first to review the approach before running `/pipeline`.
