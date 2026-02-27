# Commit

Stage and commit all changes with a descriptive message.

Current status:
```
!`git status --short`
```

Staged diff:
```
!`git diff --cached`
```

Unstaged diff:
```
!`git diff`
```

Recent commits (for message style):
```
!`git log --oneline -5`
```

Instructions:
1. Review the diffs above.
2. Stage all relevant changes (avoid .env or secrets).
3. Write a concise commit message that explains *why*, not just *what*.
4. Commit with: `git commit -m "<message>"`
5. Do NOT push unless explicitly asked.
