# Claude Code Project Template

Clone, fill in the TODOs in `CLAUDE.md`, and start building.

**Documentation**: [natyharary.github.io/claude-project-template](https://natyharary.github.io/claude-project-template)

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
| `Dockerfile`, `config/deploy.yml`, `Makefile` | Kamal 2 deploy infra — see [docs/deployment.md](docs/deployment.md) |

## Workflow

**For most work:**
```
/ship "describe the feature"
```
That's it. Claude plans (and asks if anything is unclear), builds, reviews its own work, fixes any issues it finds, then asks for your confirmation before merging.

**Escape hatches for when you need more control:**

| Command | When to use |
|---------|-------------|
| `/commit` | Quick fix, just need a commit message |
| `/commit-push-pr` | You built it, just want a PR opened |
| `/pr-review` | Review a PR without merging |
| `/pr-address` | Fix review comments on an open PR |
| `/pr-merge` | Merge when you're ready (runs review first) |
| `/pipeline "description"` | Large feature, want full multi-agent orchestration |
| `/verify` | Run tests and check output before committing |

## Deployment

Kamal 2 infra (Dockerfile, `config/deploy.yml`, `Makefile`) ships in the template. Built-in `kamal-proxy` for auto-TLS. See [docs/deployment.md](docs/deployment.md) for setup, the IPv6/HTTP-01 gotcha, and the escape hatch to nginx+certbot.
