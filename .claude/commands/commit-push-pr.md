# Commit, Push, and Open PR

Full ship workflow: commit all changes, push, and open a pull request.

Current branch:
```
!`git rev-parse --abbrev-ref HEAD`
```

Current status:
```
!`git status --short`
```

Changes since branching from main:
```
!`git diff main...HEAD`
```

Recent commits:
```
!`git log --oneline -10`
```

Instructions:
1. Review the diffs above.
2. Stage and commit any uncommitted changes with a clear message.
3. Push the branch: `git push -u origin HEAD`
4. Create a PR using `gh pr create` with:
   - A short title (under 70 chars)
   - A body with: Summary (bullet points), Test plan (checklist)
5. Return the PR URL.

$ARGUMENTS
