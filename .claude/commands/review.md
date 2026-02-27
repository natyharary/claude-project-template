# Code Review

Review the current changes as a senior engineer would. Be thorough and direct.

Changes to review:
```
!`git diff main...HEAD`
```

Instructions:
1. Review the diff above line by line.
2. Check for:
   - Correctness: does the logic do what it claims?
   - Security: injection, secrets in code, unvalidated input
   - Edge cases: null/empty/large inputs, error paths
   - Test coverage: are new behaviors tested?
   - Complexity: is this the simplest correct solution?
3. Grill me on any changes you're uncertain about — ask questions.
4. Do NOT approve until you're satisfied. Say "LGTM" only when it's genuinely good.
5. Suggest CLAUDE.md additions for any patterns that should be remembered.

$ARGUMENTS
