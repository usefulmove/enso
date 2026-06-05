---
name: enso-session-start
description: Start an enso session by reading the local harness state, inferring active work, and returning a concise re-entry dashboard.
license: MIT
compatibility: opencode
---

## Contract

Start an enso session. enso is seam-oriented, not PRD-file-oriented.

Orient to the repository by reading durable harness signals, not by requiring any single canonical file. Trust local shape. Ask the user only when ambiguity blocks the next useful move.

## Principles

- Read local instructions first when present: `AGENTS.md`, `SOUL.md`, repo README, and obvious harness docs.
- Infer project shape from durable signals: `docs/stories/`, `docs/logs/`, `docs/reference/`, `.pi/`, `.opencode/`, active story metadata, and working-tree state.
- Do not bootstrap just because `docs/core/PRD.md` or any other canonical file is missing.
- Treat story execution as a seam: identify the active story before executing story-scoped work, or ask.
- Keep startup cheap. Load only context that is likely to matter for the next move.

## Minimal Probe

Use lightweight read-only inspection as needed:

```bash
pwd
find . -maxdepth 3 \( -path './.git' -o -path './node_modules' -o -path './.opencode/node_modules' \) -prune -o -type f | sort | head -200
git status --short 2>/dev/null || true
ls -t docs/stories/*.md 2>/dev/null | head -5 || true
ls -t docs/logs/*.md 2>/dev/null | head -3 || true
```

Then selectively read the relevant files.

## Re-entry Dashboard

Return a concise dashboard:

```text
Session start: <repo/project>
Shape: <inferred harness shape>
Loaded: <files actually read>
Active work: <story/task/none + state if known>
Working tree: <clean/dirty summary>
Assumptions: <only material assumptions>
Mode: <scratch | task | story>
Next: <recommended next move or question>
```

If no question is needed, end ready to work. If a question is needed, ask exactly one.
