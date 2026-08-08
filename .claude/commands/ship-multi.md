# Ship Multi

Plan, build, review, and merge **multiple** independent features end-to-end, back-to-back. Same loop as `/ship`, run N times — but planning happens once as a batch, and execution runs unattended after a single approval, saving you from babysitting a hard stop per feature.

**Usage**: `/ship-multi <feature 1> ||| <feature 2> ||| <feature 3>`

Separate features with `|||`. Any number of features is supported.

---

## Step 0: Parse input

Split `$ARGUMENTS` on `|||`, trim whitespace from each piece. Result is an ordered list `F1..FN`.

Echo the parsed list back to the user before doing anything else:
```
Parsed N features:
1. <F1>
2. <F2>
...
```
If splitting produces only one feature (no `|||` found), tell the user this looks like a single feature and that `/ship` is the better fit — then stop without proceeding. Do not ask for confirmation to continue anyway; Phase 1's approval is the command's only interactive checkpoint, and this early exit must not become a second one.

---

## Phase 1: Plan all features (sequential, ONE approval)

For each feature `Fi` in order:
1. Enter Plan mode with the feature description.
2. Explore the codebase, ask clarifying questions if genuinely ambiguous — don't assume.
3. Produce a concrete plan with a `- [ ]` acceptance checklist, detailed enough to implement without further questions.

Do this for all N features before asking for approval — planning is sequential, but nothing gets built yet.

When all N plans are ready, present a consolidated summary:
```
PLAN 1/N: <title>
- <bullet>
- <bullet>

PLAN 2/N: <title>
- <bullet>
...
```

Then ask:
> "Here are all N plans. Approve all to build, review, and merge them one after another unattended — or tell me what to change."

**Hard stop.** This is the only interactive checkpoint in the whole command. Do not proceed until the user confirms all plans. If the user only wants changes to some plans, iterate on those, then re-ask for approval of the full batch.

---

## Phase 2: Execute each feature, unattended, one after another

Once approved, loop over `F1..FN` in order. For each feature, run the following WITHOUT stopping for confirmation (the batch approval in Phase 1 covers all of this):

### 2a. Fresh base
```bash
git status --porcelain
git checkout main
git pull origin main
git checkout -b feature/<slug-from-Fi>
```
Branching off a freshly-pulled `main` means each feature builds on the previous feature's merge.

`git status --porcelain` must be empty before branching. If it isn't, a previous feature left uncommitted or untracked changes on `main` — **stop the whole loop and report** (this is the "anything fails outside the defined skip cases" rule); do not carry those changes into `Fi`'s branch. This check is what prevents one feature's diff from silently riding along inside the next feature's PR.

### 2b. Build
Implement `Fi`'s plan (coder agent or directly, depending on scope). Run the test command from CLAUDE.md if configured; fix and re-run until green.

If the build cannot be made green after reasonable attempts: **skip this feature** — record `Fi: SKIPPED (build failed) — <reason>`, `git checkout main`, delete the local feature branch (`git branch -D feature/<slug>` — safe here since it was never pushed), and move to the next feature.

### 2c. Commit and open PR
Stage the explicit changed files (never `git add -A`), commit with a conventional-commit message, push, and:
```bash
gh pr create --title "<title>" --body "<summary>"
```
Before staging, diff the changed files against what `Fi`'s plan actually touches. Stage only files that plan produced. If unexpected files show up (leftovers from a prior feature, stale build artifacts), that is the same "unexpected state" case as 2a — stop and report rather than folding them into this PR.

The PR title and body must describe `Fi` specifically — never a generic label like the command name itself. A PR whose diff doesn't match its title is worse than no PR: it hides what actually shipped from anyone reading history later.

### 2d. Self-review
Spawn the `pr-reviewer` agent against the new PR.

- `approved` or `commented` (nits only) → continue to 2e.
- `changes_requested` → fix the blocking issues, commit, push, re-run reviewer. Max 2 rounds.
  - Still blocked after 2 rounds → **skip this feature** — record `Fi: SKIPPED (review blocked) — <summary of blockers>`, leave the PR and its remote branch open (do not close or delete — the branch is pushed and the PR needs manual attention), `git checkout main`, move to the next feature.

### 2e. CI gate
Run `gh pr checks <n>`:
- All required checks passing → continue to 2f.
- Any required check FAILING → **skip this feature** — record `Fi: SKIPPED (CI failed) — <which check>`, leave the PR and its remote branch open, `git checkout main`, move to the next feature.
- Any required check PENDING/IN_PROGRESS → wait (poll), then re-check. Do not skip solely for pending checks. Cap polling at 30 minutes total; if checks are still pending after that, **skip this feature** — record `Fi: SKIPPED (CI timeout)`, leave PR open, `git checkout main`, move to the next feature.

### 2f. Auto-merge
No confirmation prompt here — the batch was pre-approved in Phase 1.
```bash
gh pr merge <n> --squash --delete-branch
git checkout main
git pull origin main
```
Record `Fi: MERGED (<commit hash>)`.

Move to the next feature.

---

## Phase 3: Final report

After all N features have been attempted, print a summary table:
```
SHIP-MULTI COMPLETE
===================
1. <title>  — MERGED (<hash>)
2. <title>  — SKIPPED (review blocked): <reason>
3. <title>  — MERGED (<hash>)
...
```

Local `main` ends up pulled and up to date. For any SKIPPED feature, its PR is left open with the blocking detail visible — tell the user it needs manual attention.

---

## Rules

- Never push directly to main.
- Each feature gets exactly one PR of its own, titled and described for that feature specifically — never inherit another feature's title, and never let one feature's diff ride along inside another's PR. `git status --porcelain` must be clean before branching for `Fi` (2a); stage only files `Fi`'s plan produced (2c).
- Never skip the self-review step for any feature.
- Auto-merge without a per-feature prompt is allowed here ONLY because the whole batch was approved once, up front, in Phase 1.
- A skipped feature (build failure, blocked review, or failing CI) never blocks later features — always continue the loop.
- CI gate always applies before merge, same as a normal `/ship`; never merge on a failing or incomplete required check.
- If anything fails outside the defined skip cases (e.g. git/gh errors, unexpected state), stop the whole loop and report — don't silently work around it.
