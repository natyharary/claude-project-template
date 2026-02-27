# Ship

Plan, build, review, and merge a feature end-to-end. One command for the full loop.

**Usage**: `/ship <feature description>`

---

## Step 1: Plan

Enter Plan mode with the feature description: **$ARGUMENTS**

Ask clarifying questions if anything is ambiguous — don't assume. Iterate on the plan until it's concrete enough to implement without further questions.

When the plan is ready, summarize it in 3-5 bullet points and ask:
> "Does this look right? Say yes to start building, or tell me what to change."

**Hard stop.** Do not proceed until the user confirms.

---

## Step 2: Build

Switch to implementation. Use the coder agent or implement directly depending on scope.

Run tests or verification after implementing:
- If a test command is configured in CLAUDE.md, run it
- If tests fail, fix and re-run before proceeding — do not move forward with a broken build

---

## Step 3: Commit and open PR

Use the Bash tool to:
1. Create a feature branch if not already on one:
   ```bash
   git checkout -b feature/<slug-from-description>
   ```
2. Stage all changed files and commit with a descriptive message
3. Push the branch and open a PR:
   ```bash
   gh pr create --title "<title>" --body "<summary of changes>"
   ```

---

## Step 4: Review

Spawn the `pr-reviewer` agent via the Task tool. Pass the PR number from step 3.

Parse the result:

**If `REVIEW_STATUS: approved` or `REVIEW_STATUS: commented` (nits only):**
- Show the review summary
- Continue to Step 5

**If `REVIEW_STATUS: changes_requested`:**
- Show the blocking comments
- Fix each blocking issue (spawn coder agent or fix directly)
- Commit and push the fixes to the same branch
- Re-run the reviewer (Step 4 again, max 2 rounds)
- If still `changes_requested` after 2 rounds: stop and ask the user:
  > "Review still has blocking issues after 2 fix attempts. Here's what's left: <list>. How would you like to proceed?"
  Wait for user input before continuing.

---

## Step 5: Merge

Show a final summary:
```
READY TO MERGE
==============
PR #<n>: <title>
CI: <status>
Review: approved | nits only
Commits: <count>
Files changed: <count>
```

Ask:
> "Merge to main? [yes / no]"

**Hard stop.** Wait for confirmation.

On yes:
```bash
gh pr merge <n> --squash --delete-branch
git checkout main
git pull origin main
```

Report the merge commit hash and confirm local main is up to date.

---

## Rules

- Never push directly to main
- Never skip the review step
- Never merge without user confirmation
- If anything fails unexpectedly, stop and report — don't try to silently work around it
