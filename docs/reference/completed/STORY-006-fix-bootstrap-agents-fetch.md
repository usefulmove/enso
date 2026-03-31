# STORY-006: Fix Bootstrap to Fetch AGENTS.md from GitHub

## Goal

Fix the `/enso-start` bootstrap mode to fetch the enso AGENTS.md seed from GitHub (main branch) instead of leaving projects without the seed file.

## Acceptance Criteria

- [x] `/enso-start` bootstrap mode fetches AGENTS.md from `https://raw.githubusercontent.com/usefulmove/enso/main/AGENTS.md`
- [x] AGENTS.md is saved to project root (`./AGENTS.md`) before `@AGENTS.md` reference
- [x] If fetch fails, bootstrap is cancelled with clear error message
- [x] No fallback or skip option - hard failure only
- [x] Story moved to completed

## Context Scope

**Write:**
- `~/.config/opencode/commands/enso-start.md`
- `docs/stories/STORY-006-fix-bootstrap-agents-fetch.md`

**Read:**
- Current `/enso-start.md` bootstrap mode implementation

**Exclude:**
- Other enso commands

## Approach & Verification Plan

### Steps
1. Create this story file
2. Modify `/enso-start.md` bootstrap mode — after mkdir, add curl fetch with hard-fail on error
3. Test bootstrap in clean folder
4. Move story to completed

### Risks & Unknowns
- curl may not be available on all systems (but likely is)
- No offline fallback by design (hard failure)

### Verification
- Bootstrap creates `./AGENTS.md` with content matching GitHub main branch
- If network unavailable, bootstrap cancels with clear error message
