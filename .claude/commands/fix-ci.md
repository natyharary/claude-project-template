# Fix CI

Investigate and fix failing CI tests or checks.

Recent CI runs:
```
!`gh run list --limit 5 2>/dev/null || echo "gh CLI not configured"`
```

Failed checks on current branch:
```
!`gh run view --branch $(git rev-parse --abbrev-ref HEAD) 2>/dev/null | head -40 || echo "No CI data available"`
```

Current test output:
```
!`npm test 2>&1 | tail -40 || echo "No test command configured"`
```

Instructions:
1. Review the failing tests and error output above.
2. Read the failing test files and the source they test.
3. Fix the root cause — do not delete tests or mock away real failures.
4. Re-run tests to confirm they pass.
5. Check for any related failures that may have been introduced.

$ARGUMENTS
