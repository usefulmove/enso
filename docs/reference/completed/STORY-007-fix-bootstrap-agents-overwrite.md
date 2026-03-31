# STORY-007: Guard Bootstrap Against Overwriting Existing AGENTS.md

## Goal

Fix `/enso-start` bootstrap mode to skip fetching `AGENTS.md` from GitHub when one already exists in the project root, preventing silent destruction of customized harness seeds.

## Acceptance Criteria

- [x] `/enso-start` bootstrap skips the GitHub fetch if `./AGENTS.md` already exists
- [x] If `./AGENTS.md` is absent, fetch behavior and hard-fail on error are unchanged
- [x] Section label in the command reflects the skip behavior
- [x] Lesson captured in `LESSONS.md`

## Context Scope

**Write:**
- `~/.config/opencode/commands/enso-start.md`
- `docs/stories/STORY-007-fix-bootstrap-agents-overwrite.md`
- `docs/reference/LESSONS.md`

**Read:**
- Current `~/.config/opencode/commands/enso-start.md`

**Exclude:**
- All other enso commands

## Approach & Verification Plan

### Steps
1. Create this story file
2. Edit `enso-start.md` line 36: wrap curl in `[ -f ./AGENTS.md ]` existence check
3. Update section label to reflect skip behavior
4. Append lesson to `LESSONS.md`
5. Move story to `reference/completed/`

### Risks & Unknowns
- None — purely additive guard, no behavior change when file is absent

### Verification
- If `AGENTS.md` exists before bootstrap, it is untouched after bootstrap completes
- If `AGENTS.md` is absent, bootstrap fetches from GitHub as before
- Network failure still cancels bootstrap with clear error message
