# PR Review

Review an open GitHub PR for correctness, security, test coverage, and complexity.

**Usage**: `/pr-review [PR number]`

If no PR number is given, resolves from the current branch.

---

## Steps

### 1. Resolve PR Number

If `$ARGUMENTS` contains a number, use it as the PR number.

Otherwise, detect the current branch and find the associated PR:
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
gh pr list --head $BRANCH --json number -q '.[0].number'
```

If no PR is found, stop and tell the user: "No open PR found for branch `<branch>`. Pass a PR number explicitly: `/pr-review <number>`"

### 2. Spawn pr-reviewer Agent

Spawn the `pr-reviewer` agent via the Task tool. Pass:
- `PR_NUMBER`: the resolved PR number

Wait for the agent to complete.

### 3. Display Output

Print the full structured report from the pr-reviewer agent.

### 4. Recommend Next Step

Based on `REVIEW_STATUS` in the output:

- **`approved`** → "PR is approved. Run `/pr-merge` to merge."
- **`changes_requested`** → "Changes requested. Run `/pr-address` to address the blocking comments, then re-run `/pr-review`."
- **`commented`** → "Only non-blocking comments. You can run `/pr-merge` when ready, or `/pr-address` to address the nits first."
- **`unknown`** → "Could not determine PR status. Check that `gh` is installed and a remote is configured."

---

**Note**: This command is read-only — it does not post any comments to the PR.
