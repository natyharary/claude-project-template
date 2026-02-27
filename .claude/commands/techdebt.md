# Tech Debt Scan

Scan the codebase for technical debt, duplication, and cleanup opportunities.

Run at the end of a session to capture what should be cleaned up next.

Project structure:
```
!`find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' | head -60`
```

Instructions:
1. Read the key source files identified above.
2. Look for:
   - Duplicated logic that could be extracted
   - TODOs and FIXMEs
   - Dead code (unused functions, variables, imports)
   - Overly complex functions that should be split
   - Missing error handling at system boundaries
   - Inconsistent naming or patterns
3. Output a prioritized list:
   - **High**: blocks correctness or maintainability
   - **Medium**: worth fixing soon
   - **Low**: nice-to-have cleanup
4. Do NOT fix anything — just report. Ask before making changes.

$ARGUMENTS
