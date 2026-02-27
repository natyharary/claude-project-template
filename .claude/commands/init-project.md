# Init Project

A step-by-step interview to set up a new project from this template. Goes through each topic one at a time, digs into answers, then writes everything to `CLAUDE.md`.

---

## How to run this interview

Work through each section below **sequentially**. Ask one section at a time, wait for the answer, ask follow-up questions if the answer is vague or incomplete, then move to the next section. Do not batch questions together.

At the end, summarize everything collected, write it to `CLAUDE.md`, show the result, and commit.

---

## Section 1: Project Overview

Ask:
> "What does this project do? Describe it like you're explaining to a new engineer joining the team."

Follow up if the answer is vague:
- "What problem does it solve?"
- "Who uses it — is it a tool for you, for end users, for other developers?"
- "What's the expected output or outcome when it works correctly?"

Goal: a clear 2-3 sentence description that captures what it does and why it exists.

---

## Section 2: Tech Stack

Ask:
> "What's the tech stack? Walk me through: language, runtime version, and package manager."

Follow up:
- If they say a language but not a version: "Which version?" (e.g. Python 3.12, Node 22, Go 1.22)
- If they say a framework (e.g. FastAPI, Next.js): "And the underlying language/runtime is...?"
- If they haven't picked yet: "That's fine — what are you leaning toward, or should I suggest something based on what you've described?"

Goal: `Language`, `Runtime`, `Package manager` all filled in with specific versions where known.

---

## Section 3: Commands

Ask:
> "What commands do you use to test, lint, and build? Even if you haven't set them up yet, what do you expect them to be?"

Cover each one explicitly if not mentioned:
- **Test**: "How do you run tests?" (e.g. `npm test`, `pytest`, `go test ./...`)
- **Lint/format**: "How do you lint or format?" (e.g. `ruff check .`, `eslint .`, `gofmt`) — "None" is a valid answer
- **Build**: "Is there a build step?" (e.g. `npm run build`, `tsc`) — "No" is valid

If a command doesn't exist yet: note it as `TBD` rather than leaving it blank.

Goal: `Test command`, `Lint/format command`, `Build command` all have values or explicit `TBD`.

---

## Section 4: Key Files & Directories

Ask:
> "Are there any important files or directories I should know about? Things like where the core logic lives, config files, important entry points."

If the project is brand new with no structure yet:
> "No worries if it's empty — are there any directories you plan to create, like `src/`, `lib/`, `api/`?"

Follow up:
- "What lives in `<directory they mentioned>`?"
- "Is there a main entry point file?"

Goal: a short annotated list of paths, e.g.:
```
src/         # source files
src/index.ts # entry point
tests/       # test suite
```

Skip this section if truly nothing exists and nothing is planned.

---

## Section 5: Code Style

Ask:
> "Any code style rules I should follow? Things that aren't covered by the linter — naming conventions, patterns you prefer, things you hate seeing in PRs."

Prompt if they're unsure:
- "Tabs or spaces? (or does the formatter handle it?)"
- "Any strong opinions on async/await vs callbacks, classes vs functions, etc.?"
- "Any patterns you want to avoid?"

Goal: 2-5 specific, actionable style rules beyond "follow existing patterns." If they have no strong opinions, that's fine — skip this section.

---

## Section 6: Common Mistakes to Avoid

Ask:
> "Are there any mistakes or pitfalls I should never repeat — either from past projects or things you know tend to go wrong with this kind of work?"

Examples to prompt with if they're blank:
- "Any API gotchas?"
- "Things that look right but aren't?"
- "Anything the linter won't catch but you'd catch in a PR?"

Goal: populate `## Common Mistakes to Avoid` with real entries. This section is especially valuable — push for at least one entry if possible.

---

## Section 7: Workflow Preferences

Ask:
> "Last one: any workflow preferences? For example — do you want me to always run tests before saying something is done? Always ask before pushing? Prefer small commits or squash at the end?"

This is open-ended. Capture anything that should change how Claude works in this project.

Goal: any project-specific additions to the `## Workflow` section. Often empty — that's fine.

---

## Write to CLAUDE.md

Once all sections are done, summarize what was collected:

> "Here's what I have. I'll write this to CLAUDE.md now."

Show a brief summary of each section's answers, then use the Edit tool to fill in `CLAUDE.md`:

- **Project Overview**: replace `<!-- TODO: Describe what this project does in 2-3 sentences -->`
- **Tech Stack**: replace `<!-- TODO: Fill in after project setup -->` and fill in `Language:`, `Runtime:`, `Package manager:`, `Test command:`, `Lint/format command:`, `Build command:`
- **Key Files**: replace `<!-- TODO: Fill in as the project grows -->` with the annotated list, or remove the comment if nothing yet
- **Code Style**: replace `<!-- TODO: Add project-specific conventions -->` with the style rules, or remove if none
- **Testing — Test command**: update `Test command: \`<!-- TODO -->\`` with the actual command
- **Common Mistakes**: add any entries collected under `## Common Mistakes to Avoid`
- **Workflow**: append any workflow preferences to `## Workflow`

Do not invent values. If a field is `TBD`, write `TBD`. If a section had no answer, remove the TODO comment and leave the section header with no content (don't delete the section).

---

## Confirm and commit

Show the updated `CLAUDE.md` sections to the user and ask:
> "Does this look right? Anything to adjust before I commit?"

After confirmation:

```bash
git add CLAUDE.md
git commit -m "init: fill in project setup in CLAUDE.md"
```

Report the commit hash.
