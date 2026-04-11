# [STORY-2026-04-09-REASONER] Reasoner Mode Guardrails

## Goal

Make Reasoner mode proposal-only by blocking file edits while still allowing safe read-only shell exploration.

## Acceptance Criteria
- [x] Reasoner mode explicitly denies write and edit access.
- [x] Reasoner mode allows only read-only bash commands used for inspection.
- [x] Reasoner prompt clearly states proposal-only behavior and directs implementation to Coder mode.

## Context Scope

**Write:**
- `/home/dedmonds/.config/opencode/opencode.json`
- `/home/dedmonds/.config/opencode/prompts/reasoner.md`
- `/home/dedmonds/repos/enso/docs/stories/2026-04-09-reasoner-mode-guardrails.md`
- `/home/dedmonds/repos/enso/docs/reference/LESSONS.md`

**Read:**
- `/home/dedmonds/repos/enso/AGENTS.md`
- `/home/dedmonds/.config/opencode/AGENTS.md`
- `/home/dedmonds/.config/opencode/opencode.json`
- `/home/dedmonds/.config/opencode/prompts/reasoner.md`

**Exclude:**
- `/home/dedmonds/repos/enso/src/`

## Approach & Verification Plan

### Steps
1. Add explicit `write: false` and `edit: false` to the Reasoner mode tool config.
2. Add a Reasoner-mode bash allowlist limited to read-only inspection commands.
3. Rewrite the Reasoner prompt so it frames output as proposals for review, not implementation.
4. Validate the JSON config parses successfully.

### Risks & Unknowns
- The mode-level `bash` schema may differ from the global permission schema.
- Tightening the prompt should not remove legitimate codebase exploration behavior.

### Verification
- [x] Parse `~/.config/opencode/opencode.json` successfully.
- [x] Confirm the Reasoner mode block contains the expected `write`, `edit`, and `bash` settings.
- [x] Confirm the prompt says Reasoner proposes and Coder implements.
- [x] No new subsystems discovered; `docs/core/architecture/` did not require changes.

**Do not begin execution until this section is complete.**
