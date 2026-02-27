---
layout: page
title: Getting Started
nav_order: 1
---

# Claude Code Project Template

A batteries-included starting point for new projects built with [Claude Code](https://docs.anthropic.com/claude/docs/claude-code). Clone it, fill in the TODOs, and start building.

---

## What's included

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | Claude's project instructions — fill in the TODOs |
| `.mcp.json` | MCP servers (GitHub, Slack, Postgres) — uncomment what you need |
| `.claude/settings.json` | Permissions, hooks, `acceptEdits` mode |
| `.claude/hooks/` | Auto-format on edit, notify on stop/permission prompt |
| `.claude/commands/` | Slash commands for common workflows |
| `.claude/agents/` | Specialized subagents for parallel workstreams |
| `.claude/memory/` | Persistent memory across sessions (`MEMORY.md` auto-loaded) |

---

## Prerequisites

- [Claude Code](https://docs.anthropic.com/claude/docs/claude-code) installed and authenticated
- [gh CLI](https://cli.github.com/) installed and authenticated (for PR workflows)
- Git configured with a remote (for push/PR commands)

---

## Setup

### 1. Copy the template

```bash
cp -r claude_project_template my-new-project
cd my-new-project
git init && git add . && git commit -m "init"
```

### 2. Run the init interview

Open Claude Code and run:

```
/init-project
```

This walks you through filling in all the TODOs in `CLAUDE.md` — project description, tech stack, test command, and so on. Takes about 2 minutes.

### 3. Start building

```
/ship "describe the first feature"
```

Claude will plan it, ask if anything is unclear, build it, review it, and open a PR — all in one command.

---

## Quick reference

| Command | When to use |
|---------|-------------|
| `/ship "feature"` | Full plan → build → review → PR loop |
| `/commit` | Quick fix, just need a commit message |
| `/commit-push-pr` | You built it, just want a PR opened |
| `/pr-review` | Review a PR without merging |
| `/pr-address` | Fix review comments on an open PR |
| `/pr-merge` | Merge when you're ready (runs review first) |
| `/pipeline "feature"` | Large feature, full multi-agent orchestration |
| `/verify` | Run tests and check output |

See the [Commands reference](commands.md) for full details, or the [Workflow guide](workflow.md) to understand the `/ship` loop.

---

## Next steps

- [Commands reference](commands.md) — every slash command explained
- [Agents reference](agents.md) — the subagents Claude uses automatically
- [Workflow guide](workflow.md) — how the `/ship` loop works end to end
