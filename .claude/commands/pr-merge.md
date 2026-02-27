# PR Merge

Safety-gated merge of an open GitHub PR with confirmation before any destructive action.

**Usage**: `/pr-merge [PR number]`

If no PR number is given, resolves from the current branch.

---

## Steps

### 1. Resolve PR Number

If `$ARGUMENTS` contains a number, use it.

Otherwise:
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
gh pr list --head $BRANCH --json number -q '.[0].number'
```

If no PR found: stop with "No open PR found for the current branch. Pass a PR number explicitly."

### 2. Run Claude Review

Before anything else, spawn the `pr-reviewer` agent via the Task tool. Pass `PR_NUMBER`.

Parse the output:
- If `REVIEW_STATUS: changes_requested`: stop and tell the user "Claude review found blocking issues. Run `/pr-address` to fix them before merging." Print the blocking comments.
- If `REVIEW_STATUS: approved` or `REVIEW_STATUS: commented`: continue.

### 3. Fetch PR Status

```bash
gh pr view $PR_NUMBER --json number,title,state,reviews,statusCheckRollup,mergeable,headRefName,baseRefName
```

### 4. Safety Gate

Check each condition in order. Stop with a specific error if any fail:

| Condition | Error message |
|-----------|---------------|
| `state != OPEN` | "PR #<n> is not open (state: <state>). Nothing to merge." |
| `mergeable == CONFLICTING` | "PR #<n> has merge conflicts. Resolve conflicts and push before merging." |
| Any CI check with `conclusion: FAILURE` | "CI is failing on PR #<n> (<check name>). Run `/fix-ci` to address failures before merging." |
| Any CI check with `conclusion: null` and `status: IN_PROGRESS` | "CI checks are still running on PR #<n>. Wait for them to complete or check with `/pr-review`." |
| Any review with `state: CHANGES_REQUESTED` | "PR #<n> has unaddressed review requests from <reviewer>. Run `/pr-address` to fix them." |

If all conditions pass, proceed.

### 5. Show Merge Confirmation

Display:

```
MERGE PREVIEW
=============
PR #<n>: <title>
Branch: <headRefName> → <baseRefName>
Strategy: squash (default) — or specify: merge | rebase

CI: <passing|pending|unknown>
Reviews: <approved by X reviewers | no reviews>
Files changed: <count>
```

Then ask:
```
Merge strategy? [squash (default) / merge / rebase]
Type "yes" or the strategy name to confirm, or "no" to cancel.
```

Default to `squash` if the user just types "yes".

### 6. STOP — Wait for Confirmation

**Hard stop.** Do NOT merge until the user explicitly confirms.

### 7. Execute Merge

```bash
gh pr merge $PR_NUMBER --<strategy> --delete-branch
```

Where `<strategy>` is `squash`, `merge`, or `rebase` based on user input.

### 8. Update Local Main

```bash
git checkout <baseRefName>
git pull origin <baseRefName>
```

### 9. Report Result

```
MERGED
======
PR #<n>: <title>
Merge commit: <hash from gh pr merge output>
Branch deleted: <headRefName>
Local <baseRefName> up to date.
```

If any step fails, report the exact error and do not proceed further.

---

**Note**: This command always deletes the feature branch after merge (`--delete-branch`). If you want to keep the branch, merge manually with `gh pr merge <n> --<strategy>`.
