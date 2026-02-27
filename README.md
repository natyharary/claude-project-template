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
| Single feature | `/verify` → `/commit-push-pr` |
| Complex feature | `/pipeline "description"` |
| With PR review + merge | `/pipeline --with-review "description"` |
