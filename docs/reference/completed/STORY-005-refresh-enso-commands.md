# STORY-005: Refresh enso Slash Commands to v0.5.0

## Goal

Fix the registration issue, update all 5 enso slash commands to align with harness v0.5.0, and implement "ask-first" bootstrap behavior in `/enso-start`.

## Acceptance Criteria

- [x] Slash commands auto-discovered from `~/.config/opencode/commands/` (no registration needed)
- [x] `/enso-start` updated to handle bootstrap mode (ask-first)
- [x] Version references updated from v0.3.0 to v0.5.0
- [x] `/enso-help` shows current project status correctly
- [x] All commands tested and functional (`/enso-start` bootstrap verified in clean folder)
- [x] Story moved to completed

## Context Scope

**Write:**
- `~/.config/opencode/opencode.json`
- `~/.config/opencode/commands/enso-start.md`
- `~/.config/opencode/commands/enso-help.md`
- `~/.config/opencode/commands/enso-close.md`
- `~/.config/opencode/commands/enso-compact.md`
- `docs/stories/STORY-005-refresh-enso-commands.md`

**Read:**
- `AGENTS.md`
- Existing command files in `~/.config/opencode/commands/`

**Exclude:**
- Other projects' configs

## Approach & Verification Plan

### Steps
1. Create this story file
2. Add slash registration to `~/.config/opencode/opencode.json`
3. Rewrite `/enso-start` with ask-first bootstrap mode
4. Update `/enso-help` to v0.5.0
5. Minor updates to `/enso-close`, `/enso-compact`, `/enso-log`
6. Bootstrap this repo (create PRD, ARCHITECTURE)
7. Test all commands

### Risks & Unknowns
- OpenCode `!command` syntax behavior with missing files
- Bootstrap multi-step prompting UX

### Verification
Manual test each command in sequence: help → start (bootstrap) → compact → close
