# STORY-015: Implement evaluator aspect stack and retry/escalate/replan router

## Goal

Implement the evaluator and routing layer for `story-loop`. The evaluator checks execution results through aspect verifiers and produces grounded findings. The router distinguishes implementation defects from planning defects and routes to generator retry, human escalation, or approval-gated replan.

The evaluator must stay generic to enso. It may load convention mappings from the active harness configuration, story metadata, or explicit adapter files, but enso core must not encode downstream project-specific convention paths.

## Acceptance Criteria

- [x] Evaluator supports aspect verifiers:
  - [x] contract verifier
  - [x] scope/protocol verifier
  - [x] convention verifier
  - [x] counterexample verifier
- [x] Tool/test commands from the execution contract are run or marked not-run with reason.
- [x] Findings are classified:
  - [x] objective
  - [x] subjective
  - [x] convention-cited
  - [x] counterexample-backed
- [x] Objective implementation findings route to generator retry.
- [x] Subjective findings route to human escalation.
- [x] Planning-defect findings recommend `REPLAN`.
- [x] Replan requires approval before planner re-entry.
- [x] Router detects repeated same finding and escalates or recommends replan.
- [x] Evaluation result is machine-readable and persisted.
- [x] Convention verifier has a generic mapping/config seam for downstream harnesses.

## Context Scope

**Write:**
- `.pi/extensions/story-loop/evaluator.ts`
- `.pi/extensions/story-loop/verifiers/contract.ts`
- `.pi/extensions/story-loop/verifiers/scope.ts`
- `.pi/extensions/story-loop/verifiers/convention.ts`
- `.pi/extensions/story-loop/verifiers/counterexample.ts`
- `.pi/extensions/story-loop/router.ts`
- `.pi/extensions/story-loop/index.ts` *(approved scope expansion 2026-05-27)*
- `.pi/extensions/story-loop/types.ts` *(approved scope expansion 2026-05-27)*
- `.pi/extensions/story-loop/state.ts` *(approved scope expansion 2026-05-27 if needed)*
- `docs/stories/STORY-015-story-loop-evaluator-router.md`

**Read:**
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/reference/agentic-harnesses-sota-20260311.md`
- `skills/generator-evaluator-loop/references/EVALUATION_CONTRACT.md`
- `skills/generator-evaluator-loop/references/ESCALATION.md`
- `skills/generator-evaluator-loop/references/CONVENTIONS_MAP.md`

**Exclude:**
- approval-safe writes
- initial planner implementation
- downstream harness repos and codebases unless used only as read-only adapter examples
- git mutation

## Approach & Verification Plan

### Steps

1. Define evaluator result schema.
2. Implement contract verifier around execution contract checks.
3. Implement scope/protocol verifier around Write/Read/Exclude and enso protocol constraints.
4. Implement convention verifier requiring citation to loaded convention docs.
5. Add a generic convention mapping/config seam instead of hardcoding downstream project paths.
6. Implement counterexample verifier for non-mutating adversarial probes.
7. Implement verdict aggregation.
8. Implement router transitions:
   - retry
   - escalate
   - recommend replan
   - accept
9. Persist evaluator results and routing decisions.

### Risks & Unknowns

- Counterexample verifier must not invent vague new acceptance criteria.
- Convention verifier must not block without citation.
- Router must avoid infinite retry loops.
- A generic convention mapping may need to support both enso parent docs and downstream project docs.

### Verification

- [x] Passing mock execution routes to accepted.
- [x] Tool failure routes to generator retry.
- [x] Subjective ambiguity routes to escalation.
- [x] Repeated structural failure recommends replan and pauses for approval.
- [x] Convention finding without citation is not objective.
- [x] Counterexample must include concrete reproducible evidence to block.
- [x] No downstream project-specific paths are hardcoded in enso core.

### Progress

- 2026-05-27: Expanded Write scope with user approval to wire `/story-loop run` into `index.ts` with real generator subprocess and evaluator pipeline.
- 2026-05-27: Implemented `evaluator.ts`, `router.ts`, and four aspect verifiers: `contract.ts`, `scope.ts`, `convention.ts`, `counterexample.ts`.
- 2026-05-27: Wired `/story-loop run` to execute generator via `SubprocessRoleRunner` (or `--mock-*` shorthand for non-model testing), then evaluate, route, and persist state.
- 2026-05-27: Mock smoke-tested all five routing paths: `--mock-pass` → accepted, `--mock-tool-fail` → retry, `--mock-subjective` → escalated, `--mock-planning-defect` → replan, repeated tool-fail → replan.
- 2026-05-27: Confirmed no downstream harness paths in extension core.
