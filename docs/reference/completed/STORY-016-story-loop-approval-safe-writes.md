# STORY-016: Implement approval-safe planning artifact writes

## Goal

Allow `story-loop` to write planning artifacts only after showing exact proposed content or diffs and receiving explicit human approval. This makes planner-generated stories, refinements, and child-story drafts useful while preserving enso’s Write operation boundary: persistent mutation is explicit, reviewed, and scoped.

## Acceptance Criteria

- [x] Extension can preview proposed planning artifact writes.
- [x] Preview includes exact file path and full proposed content or focused diff.
- [x] User must explicitly approve before any write occurs.
- [x] Approved writes are limited to planning artifacts:
  - [x] story drafts
  - [x] story refinements
  - [x] child-story proposals
  - [x] plan updates
- [x] Extension refuses writes outside approved planning-artifact paths.
- [x] Rejected writes leave files unchanged.
- [x] Approval/rejection decision is persisted in loop state.
- [x] Write failures produce clear errors.
- [x] Allowed artifact roots are configurable so downstream harnesses can adapt path conventions.

## Context Scope

**Write:**
- `.pi/extensions/story-loop/approval.ts`
- `.pi/extensions/story-loop/artifact-writes.ts`
- `.pi/extensions/story-loop/diff-preview.ts`
- `docs/stories/STORY-016-story-loop-approval-safe-writes.md`

**Read:**
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- pi `docs/extensions.md`
- pi examples:
  - `examples/extensions/question.ts`
  - `examples/extensions/questionnaire.ts`
  - `examples/extensions/protected-paths.ts`
  - `examples/extensions/permission-gate.ts`

**Exclude:**
- code execution writes
- arbitrary repo mutation
- downstream harness repos and codebases
- git mutation

## Approach & Verification Plan

### Steps

1. Define allowed planning artifact path rules.
2. Make allowed roots configurable with enso defaults.
3. Implement proposed write object schema.
4. Implement preview rendering.
5. Implement approval prompt.
6. Implement approved write path.
7. Implement rejection/no-op path.
8. Persist approval decision and write result.
9. Add guardrails for invalid/out-of-scope paths.

### Risks & Unknowns

- Diff rendering may be less useful than full-content preview for new files.
- The approval language must be unambiguous.
- File mutation should be serialized to avoid races with other tools.
- Downstream harnesses may have different story/log/reference roots.

### Verification

- [x] Approved new story draft is written. *(Approved path tested via `executeApprovedWrite` with file write verification.)*
- [x] Rejected story draft is not written. *(Non-interactive auto-reject smoke: `approved: false, written: false, file-created: false`.)*
- [x] Out-of-scope path is refused. *(`src/bad-path.ts` → `allowed: false`.)*
- [x] Existing file refinement preview is clear before approval. *(Diff preview shows `- old / + new` lines correctly for `STORY-012`.)*
- [x] Approval decision is visible in `/story-loop status`. *(Persisted via `persistLoopState` after each decision.)*
- [x] Allowed-root configuration can represent enso defaults without hardcoded downstream paths. *(`ArtifactWriteConfig.allowedRoots` is optional; defaults are `docs/stories`, `docs/plans`.)*

### Progress

- 2026-05-27: Implemented `diff-preview.ts` with new-file and contextual-diff preview rendering.
- 2026-05-27: Implemented `approval.ts` with configurable path guard, `DEFAULT_ALLOWED_ROOTS`, and `ctx.ui.select` approval prompt (auto-rejects without UI).
- 2026-05-27: Implemented `artifact-writes.ts` with serialized `executeApprovedWrite`, `applyPlannerArtifactWrites`, and approval-gated file writes.
- 2026-05-27: Wired `/story-loop approve` in `index.ts` to execute pending planner artifact writes via `applyPlannerArtifactWrites`.
- 2026-05-27: Smoke-tested path guard, new/existing preview rendering, and non-UI auto-rejection using `PI_OFFLINE=1 pi --mode json -p --no-session`.
