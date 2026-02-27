# Claude Code Project Template

A starting point for new projects built with Claude Code.
Clone this repo, fill in the TODOs, and start building.

---

## Quick Start

```bash
# 1. Copy the template
cp -r claude_project_template my-new-project
cd my-new-project

# 2. Initialize git
git init && git add . && git commit -m "init from claude-project-template"

# 3. Fill in CLAUDE.md (project overview, tech stack, test command)
# 4. Start Claude Code
claude
```

---

## What's Included

```
.
├── CLAUDE.md                        # Claude's instructions for this project
├── .mcp.json                        # MCP server config (uncomment what you need)
├── .gitignore
└── .claude/
    ├── settings.json                # Permissions, hooks, default mode
    ├── hooks/
    │   ├── post-edit-format.sh      # Auto-format after every file edit
    │   ├── on-stop.sh               # Notification + optional verification on stop
    │   └── notify.sh                # System notification when Claude needs input
    ├── commands/                    # Slash commands (/commit, /verify, etc.)
    │   ├── commit.md
    │   ├── commit-push-pr.md
    │   ├── techdebt.md
    │   ├── verify.md
    │   ├── fix-ci.md
    │   └── review.md
    ├── agents/                      # Subagents for modular roles
    │   ├── simplifier.md            # Cleans up code without changing behavior
    │   ├── verifier.md              # Proves implementation works with evidence
    │   └── researcher.md            # Investigates options before implementing
    ├── memory/                      # Persistent project memory across sessions
    │   ├── MEMORY.md                # Index (auto-loaded, keep under 200 lines)
    │   ├── patterns.md
    │   └── debugging.md
    └── rules/                       # Optional: path-scoped rule files
```

---

## Development Approach: CLI First

This template follows a **CLI-first** development pattern:

| Stage | When | How |
|-------|------|-----|
| **1. CLI tool** | Default | stdin/stdout, run directly |
| **2. API server** | User requests it | Thin HTTP layer over existing logic |
| **3. Web app** | User requests it | Frontend + backend |

Don't jump ahead. Build the logic as a CLI tool first — it's faster to iterate,
easier to test, and the core logic transfers cleanly when you do add a server.

---

## Workflow: How to Work Effectively with Claude Code

### Before Writing Code: Plan Mode
For any non-trivial task, start in Plan mode:
```
shift+tab (twice) → enter Plan mode
```
Iterate on the plan until it's right, then switch to auto-accept edits.
Claude can usually execute a good plan in one shot.

### Parallel Sessions
Run multiple Claude instances simultaneously for independent workstreams:
- Open 5 terminal tabs, number them 1–5
- Use **git worktrees** so each tab has its own checkout (no conflicts):
  ```bash
  git worktree add ../my-project-feature-auth -b feature-auth
  cd ../my-project-feature-auth && claude
  ```
- Enable the `notify.sh` hook so you get a system notification when a tab needs input

### Slash Commands (Daily Workflows)
Use these for repeated inner-loop tasks:

| Command | Use it when... |
|---------|----------------|
| `/commit` | You're ready to commit and want Claude to write the message |
| `/commit-push-pr` | Done with a feature, ready to ship |
| `/verify` | You want proof the implementation works, not just claims |
| `/review` | You want a thorough code review before merging |
| `/techdebt` | End of session — capture what should be cleaned up |
| `/fix-ci` | CI is failing and you want Claude to just fix it |

### Subagents (Pipeline Approach)
Use agents to break work into phases with independent "minds":

```
spec → implement → /simplifier → /verifier
```

- **simplifier**: cleans up after implementation, removes over-engineering
- **verifier**: proves it works with actual output, not just claims
- **researcher**: investigates options before committing to an approach

Ask Claude to use an agent:
> "Use the verifier agent to prove this works"
> "Run the simplifier on the auth module"

### Give Claude a Way to Verify Its Own Work
This is the single biggest quality multiplier. Before asking for a feature:
1. Make sure tests exist (or add them)
2. Or provide a runnable command Claude can use to check its output

> "Implement X, then run the tests and show me the output"
> "Prove to me this works — diff the behavior between main and this branch"

### Bug Fixing Without Context Switching
If you use Slack MCP:
> "Here's the bug thread: [paste]. Fix it."

Or for CI failures:
> "Go fix the failing CI tests" — don't explain how

### After a Bad Fix
> "Knowing everything you know now, scrap this and implement the elegant solution"

---

## Configuration

### CLAUDE.md
Edit `CLAUDE.md` to add:
- Project description and tech stack
- Test/build/lint commands
- Key directories
- **Common mistakes** — add an entry every time Claude does something wrong

### Permissions (`.claude/settings.json`)
The default config uses `acceptEdits` mode (auto-accept file edits, ask for bash).
Add pre-approved bash commands to the `allow` list for commands you run constantly:
```json
"allow": [
  "Bash(npm test)",
  "Bash(npm run build)",
  "Bash(git diff)"
]
```

### MCP Servers (`.mcp.json`)
Uncomment the servers you need. Common ones:
- **GitHub**: issue/PR context without leaving the terminal
- **Slack**: paste a bug thread, say "fix"
- **Postgres**: let Claude query your database directly

### Hooks
All hooks are in `.claude/hooks/`. They're shell scripts — edit them directly.
- `post-edit-format.sh`: add your formatter if it's not already handled
- `on-stop.sh`: add auto-verification steps (run tests, check logs)
- `notify.sh`: customise notification style

---

## Memory System

Claude maintains project memory in `.claude/memory/`:
- **MEMORY.md**: auto-loaded index — keep it under 200 lines
- **patterns.md**: confirmed code patterns and conventions
- **debugging.md**: non-obvious problems and their solutions

Add entries manually or ask Claude to update memory:
> "Remember that we always use X pattern for Y"
> "Add this bug and fix to debugging.md"

---

## Tips from Boris Cherny (Anthropic)

- **Use Opus with thinking** for complex tasks — slower per token but faster overall because you steer it less
- **Update CLAUDE.md constantly** — whenever Claude does something wrong, add it so it never repeats
- **Encode every repeated workflow** as a slash command in `.claude/commands/`
- **Worktrees are the top productivity unlock** for parallel work
- **"Grill me on these changes"** — make Claude be your reviewer before you open a PR
- **Invest in verification** — giving Claude a way to check its own work is a 2-3x quality improvement
- **Write detailed specs** and reduce ambiguity before handing off to Claude

---

## .gitignore Additions

The following files are personal and should not be committed:
```
CLAUDE.local.md
.claude/settings.local.json
```
They are already in `.gitignore`.
