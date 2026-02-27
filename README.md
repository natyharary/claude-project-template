# Claude Code Project Template

Clone, fill in the TODOs in `CLAUDE.md`, and start building.

```bash
cp -r claude_project_template my-new-project
cd my-new-project
git init && git add . && git commit -m "init"
# Edit CLAUDE.md, then:
claude
```

## What's included

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | Claude's instructions — fill in TODOs |
| `.mcp.json` | MCP servers (GitHub, Slack, Postgres) — uncomment what you need |
| `.claude/settings.json` | Permissions, hooks, `acceptEdits` mode |
| `.claude/hooks/` | Auto-format on edit, notify on stop/permission prompt |
| `.claude/commands/` | `/commit`, `/commit-push-pr`, `/verify`, `/review`, `/fix-ci`, `/techdebt`, `/pipeline`, `/pr-review`, `/pr-address`, `/pr-merge` |
| `.claude/agents/` | `simplifier`, `verifier`, `researcher`, `pm`, `planner`, `coder`, `tester`, `git-handler`, `pr-reviewer` |
| `.claude/memory/` | Persistent memory across sessions (`MEMORY.md` auto-loaded) |

## Workflow tiers

| Task size | Approach |
|-----------|----------|
| Quick fix / typo | Edit directly → `/commit` |
| Single feature | Plan → build → `/verify` → `/commit-push-pr` → `/pr-merge` |
| Complex feature | `/pipeline "description"` → `/pr-merge` |

## Feature workflow (step by step)

```
1. Plan        shift+tab twice → enter Plan mode, describe the feature,
                iterate until the plan is right

2. Build       switch to auto-accept, Claude implements

3. Verify      /verify
                Claude runs tests and checks output — won't proceed if broken

4. Commit+PR   /commit-push-pr
                Claude writes the commit message, pushes a branch, opens a PR

5. Review      /pr-review
                Claude reviews the diff for correctness, security, test coverage
                → if issues: /pr-address (Claude fixes, pushes to same PR)
                → if clean: proceed

6. Merge       /pr-merge
                Re-runs review, checks CI, asks for confirmation, squash-merges,
                deletes branch, pulls main
```

`/pr-merge` always runs the review internally — steps 5 and 6 can be collapsed into just `/pr-merge` if you trust it.
