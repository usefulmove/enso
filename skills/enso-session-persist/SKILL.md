---
name: enso-session-persist
description: Persist only the session state that improves future re-entry, coordination, or reuse.
license: MIT
compatibility: opencode
---

## Contract

Persist session state across the ephemeral -> durable seam. Write the smallest useful durable update. Skip ceremony that will not help a future agent or human resume work.

## Principles

- Persist deltas, not transcripts.
- Prefer active story progress, decisions, next steps, reusable lessons, and handoff notes.
- Do not create generic logs, lessons, or reflection prompts unless they have future value.
- Respect local harness shape. `docs/stories/`, `docs/logs/`, and `docs/reference/LESSONS.md` are conventions, not requirements.
- If write/edit tools are available, `/enso-persist` counts as permission to write the minimal checkpoint after a concise proposal.
- If only read-only tools are available, generate the proposed diff/content and ask the user to apply or switch modes.

## Minimal Probe

Use lightweight read-only inspection as needed:

```bash
git status --short 2>/dev/null || true
ls -t docs/stories/*.md 2>/dev/null | head -5 || true
ls -t docs/logs/*.md 2>/dev/null | head -3 || true
[ -f docs/reference/LESSONS.md ] && tail -80 docs/reference/LESSONS.md || true
```

Read only the files needed to decide what is worth persisting.

## Persistence Proposal

Before writing, show a compact proposal:

```text
Persist proposal:
- <file>: <why this durable update is useful>

Content:
- Decisions: <only new durable decisions>
- Progress: <only useful resume state>
- Next: <next concrete step>
- Lessons: <only reusable lessons, or "none">
```

Then proceed according to available tools:

- With write/edit tools: write the proposed minimal checkpoint.
- Read-only mode: provide a patch or exact content block and ask the user to apply it.

## Write Targets

Choose the smallest appropriate target:

- Active story: progress, decisions, verification state, next step.
- `docs/logs/YYYY-MM-DD-session.md`: session-level handoff when no active story is right, or when a log improves re-entry.
- `docs/reference/LESSONS.md`: only reusable lessons that should survive this task.
- New skill/story/reference doc: only when the session exposed a repeated capability or durable concept worth naming.

End with:

```text
Persisted: <files written or proposed>
Next: <one concrete resume step>
```
