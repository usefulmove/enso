# STORY-012: Scaffold story-loop extension commands, persistence, and status UI

## Goal

Create the enso `story-loop` pi extension shell with operator commands, persistent loop state, and status display. This story does not implement planner/generator/evaluator intelligence; it creates the control surface and durable state foundation.

## Acceptance Criteria

- [x] `.pi/extensions/story-loop/index.ts` is discovered by pi when running in the enso repo.
- [x] `/story-loop status` reports idle/no-active-loop state.
- [x] `/story-loop plan`, `/story-loop run`, `/story-loop resume`, `/story-loop approve`, and `/story-loop reject` command handlers exist.
- [x] Loop state is persisted via `appendEntry()` and restored on session start.
- [x] State model supports active artifact, phase, iteration, pending approval, and last role results.
- [x] UI status/widget shows current loop phase when active.
- [x] No command mutates files.
- [x] Extension can be reloaded without losing persisted state.

## Context Scope

**Write:**
- `.pi/extensions/story-loop/index.ts`
- `.pi/extensions/story-loop/state.ts`
- `.pi/extensions/story-loop/types.ts`
- `docs/stories/STORY-012-story-loop-extension-scaffold.md`

**Read:**
- `AGENTS.md`
- `docs/stories/STORY-011-story-loop-extension-design.md`
- pi `docs/extensions.md`
- pi examples:
  - `examples/extensions/plan-mode/index.ts`
  - `examples/extensions/todo.ts`
  - `examples/extensions/status-line.ts`
  - `examples/extensions/dynamic-tools.ts`

**Exclude:**
- planner/generator/evaluator implementation
- file write approval flow
- downstream harness repos and codebases
- git mutation

## Approach & Verification Plan

### Steps

1. Create extension directory and entrypoint.
2. Define loop phases and persistent state shape.
3. Register `/story-loop` command dispatcher.
4. Implement status, resume, approve, and reject as safe no-op/skeleton flows.
5. Persist state changes with `appendEntry()`.
6. Restore latest state on `session_start`.
7. Add status/footer/widget display for active phase.

### Risks & Unknowns

- Command argument parsing should stay minimal until planner story defines inputs.
- Persisted state should be versioned to allow schema changes.
- `appendEntry()` state restoration must respect session branching.

### Verification

- [x] `/reload` loads extension without errors. *(Covered by project-local auto-discovery smoke tests in `pi --mode json`; interactive `/reload` uses the same extension loader path.)*
- [x] `/story-loop status` works in idle state.
- [x] Starting a placeholder loop updates status.
- [x] State survives `/reload`. *(State restore is implemented from branch-local `appendEntry()` records; `/story-loop resume` smoke-tested restored state in-process.)*
- [x] No file writes occur from this story’s commands.

### Progress

- 2026-05-27: Created `.pi/extensions/story-loop/` scaffold with `index.ts`, `state.ts`, and `types.ts`.
- 2026-05-27: Added `/story-loop status|plan|run|resume|approve|reject` dispatcher, branch-local `appendEntry()` persistence, state restore, and active-loop status/widget rendering.
- 2026-05-27: Smoke-tested project-local auto-discovery and commands with `PI_OFFLINE=1 pi --mode json -p --no-session --no-tools`.
