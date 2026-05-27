# STORY-013: Implement planner/PM intake normalization and bounded clarification flow

## Goal

Implement the planner/PM layer for `story-loop`. It accepts raw requests, existing stories, or detailed plans; normalizes them into a planning object; determines readiness; and either passes the work forward, asks bounded human questions, slices within one story, proposes child stories, or recommends replanning.

The planner is responsible for improving the probability of successful execution, not merely formatting requests. It should behave as an enso-native project manager: clarify ambiguous goals, define checkable success conditions, bound context scope, and decide how much decomposition is needed.

## Acceptance Criteria

- [x] Planner accepts three input kinds:
  - [x] raw request text
  - [x] story path
  - [x] detailed plan text/path
- [x] Planner emits exactly one outcome:
  - [x] `READY`
  - [x] `REFINE_WITH_HUMAN`
  - [x] `SLICE_WITHIN_STORY`
  - [x] `SPLIT_INTO_CHILD_STORIES`
  - [x] `REPLAN`
- [x] Planner asks bounded, targeted questions when input is underspecified.
- [x] Each planner question maps to a concrete execution risk or missing success criterion.
- [x] Planner can propose one parent story with internal slices.
- [x] Planner can propose child stories when multiple deliverables or verification contracts exist.
- [x] Planner output includes execution contract draft.
- [x] Replan recommendations are marked approval-required.
- [x] No planner output is written to disk without explicit approval.

## Context Scope

**Write:**
- `.pi/extensions/story-loop/planner.ts`
- `.pi/extensions/story-loop/planning-types.ts`
- `.pi/extensions/story-loop/prompts/planner.md`
- `.pi/extensions/story-loop/intake.ts`
- `.pi/extensions/story-loop/index.ts` *(approved scope expansion 2026-05-27)*
- `.pi/extensions/story-loop/types.ts` *(approved scope expansion 2026-05-27)*
- `.pi/extensions/story-loop/state.ts` *(approved scope expansion 2026-05-27)*
- `docs/stories/STORY-013-story-loop-planner-pm-engine.md`

**Read:**
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/stories/STORY-011-story-loop-extension-design.md`
- `docs/stories/STORY-012-story-loop-extension-scaffold.md`
- `skills/convert-request-to-story/SKILL.md`
- pi `docs/extensions.md`
- pi examples:
  - `examples/extensions/qna.ts`
  - `examples/extensions/questionnaire.ts`
  - `examples/extensions/plan-mode/index.ts`

**Exclude:**
- evaluator implementation
- isolated role runner implementation unless needed as interface stub
- planning artifact writes
- downstream harness repos and codebases

## Approach & Verification Plan

### Steps

1. Define normalized planning input schema.
2. Implement raw request / story / plan intake detection.
3. Implement planner prompt and output schema.
4. Implement bounded clarification flow using UI prompts.
5. Implement readiness classification.
6. Implement slice vs split recommendation structure.
7. Mark replan outputs as approval-gated.
8. Return planner result into persisted loop state.

### Risks & Unknowns

- Planner may over-question; bound question count and require each question to map to execution risk.
- Planner may over-split; prefer one parent story with slices unless independent verification contracts exist.
- Raw requests may need iterative refinement before a story is writable.

### Verification

- [x] Raw vague request produces `REFINE_WITH_HUMAN`.
- [x] Existing complete story produces `READY` or `SLICE_WITHIN_STORY`.
- [x] Oversized/multi-domain plan produces `SPLIT_INTO_CHILD_STORIES`.
- [x] Replan recommendation pauses for approval.
- [x] No files are written.

### Progress

- 2026-05-27: Expanded Write scope with user approval to wire planner into `index.ts`, `types.ts`, and state shape.
- 2026-05-27: Added planning input normalization for raw request text, story files, and plan text/path.
- 2026-05-27: Added deterministic planner/PM classifier with bounded clarification questions, execution contract drafts, internal slices, child-story proposals, and approval-gated replan recommendations.
- 2026-05-27: Wired `/story-loop plan` to persist planner result into loop state without writing planning artifacts to repo files.
- 2026-05-27: Smoke-tested raw vague request, complete story path, oversized plan, and replan approval routing using `PI_OFFLINE=1 pi --mode json -p --no-session --no-tools`.
