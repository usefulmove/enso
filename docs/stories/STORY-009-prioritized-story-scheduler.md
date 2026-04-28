# STORY-009: Prioritized Story Scheduler

## Goal

Design and implement a light-weight process table (`docs/core/QUEUE.md`) that serves as enso's authoritative scheduler — replacing the implicit filesystem-order dispatch with an explicit, priority-driven queue.

## Acceptance Criteria

- [ ] `docs/core/QUEUE.md` exists with a defined format (state transitions, priority field, story references)
- [ ] `/enso-start` is updated to read QUEUE.md and dispatch the highest-priority `ready` story
- [ ] `enso-start` falls back to `ls docs/stories/` if QUEUE.md is missing (backward compat)
- [ ] `/enso-persist` is updated to advance story states in QUEUE.md during closeout
- [ ] Story template in AGENTS.md §9 is optionally updated to reflect explicit function-signature framing (Context Scope = inputs/outputs)
- [ ] `docs/reference/LESSONS.md` updated with any new insights
- [ ] All changes reviewed and approved before execution

## Context Scope

**Write:**
- `docs/core/QUEUE.md`
- `~/.config/opencode/commands/enso-start.md`
- `~/.config/opencode/commands/enso-persist.md`

**Read:**
- `docs/core/ARCHITECTURE.md` (especially "The Scheduler" section)
- `docs/reference/LESSONS.md`
- `docs/reference/completed/STORY-005-refresh-enso-commands.md`
- `docs/reference/enso-gnosis.md`

**Exclude:**
- All other code and docs outside the Write scope
- No changes to AGENTS.md template unless explicitly called out

## Approach & Verification Plan

### Steps

1. **Design QUEUE.md format** — Propose the markdown table schema (story ID, title, priority, state, dependencies, notes). Get user approval.
2. **Write `docs/core/QUEUE.md`** — Create the file with initial state (backlog of any active stories, empty if none).
3. **Update `enso-start.md`** — Replace `ls -t docs/stories/*.md` with reading QUEUE.md; dispatch highest-priority `ready` story; fallback to filesystem if QUEUE.md missing.
4. **Update `enso-persist.md`** — Add a step to advance story state (`ready → running → done` / `running → blocked`) during closeout.
5. **Review story template** — Assess whether AGENTS.md §9 should be updated to reflect the function-signature framing (already implicit; may only need a note).
6. **Update LESSONS.md** — Capture any new insights about the scheduler primitive.

### Risks & Unknowns

- The four enso commands live in `~/.config/opencode/commands/` — they are global, not project-local. QUEUE.md is project-local. The commands must resolve the project root to find QUEUE.md.
- State transitions must be idempotent — two agents should not race on the same transition.
- Backward compatibility: existing projects without QUEUE.md must continue to work.

### Verification

- [ ] Run `enso-start` on this project → confirms it reads QUEUE.md and dispatches the highest-priority ready story
- [ ] Run `enso-start` on a project without QUEUE.md → falls back to `ls docs/stories/`
- [ ] Run `enso-persist` with a completed story → confirms the story transitions to `done` in QUEUE.md
- [ ] `grep` to confirm no remaining hardcoded `ls -t docs/stories/` pattern outside the fallback path

### Reflection
- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [ ] No new insights → proceed

**Do not begin execution until this section is complete.**
