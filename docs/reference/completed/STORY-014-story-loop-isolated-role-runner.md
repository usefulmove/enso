# STORY-014: Implement isolated role runner and structured role results

## Goal

Implement isolated role execution for planner, generator, and evaluator phases using separate pi subprocesses in JSON mode, plus structured terminating result output so the orchestrator receives machine-readable role results instead of prose.

The runner should be generic to enso. Downstream harness instances can provide configuration, additional prompts, or convention mappings, but the core runner should not encode project-specific paths or policies.

## Acceptance Criteria

- [x] Role runner can invoke an isolated pi subprocess.
- [x] Runner supports role-specific prompt/context injection.
- [x] Runner captures JSON-mode events and final assistant/tool result output.
- [x] Structured result tool/schema exists for:
  - [x] planner result
  - [x] generator result
  - [x] evaluator result
- [x] Runner reports subprocess failures clearly.
- [x] Runner supports cancellation via abort signal.
- [x] Role result history is stored in loop state.
- [x] Runner interface can support a future SDK-backed implementation.
- [x] No role runner path silently mutates files outside the active execution contract.

## Context Scope

**Write:**
- `.pi/extensions/story-loop/runner.ts`
- `.pi/extensions/story-loop/role-prompts.ts`
- `.pi/extensions/story-loop/result-tool.ts`
- `.pi/extensions/story-loop/result-schemas.ts`
- `docs/stories/STORY-014-story-loop-isolated-role-runner.md`

**Read:**
- `AGENTS.md`
- `agent/generator.md`
- `agent/evaluator.md`
- `agent/reasoner.md`
- pi `docs/extensions.md`
- pi `docs/sdk.md`
- pi examples:
  - `examples/extensions/subagent/index.ts`
  - `examples/extensions/subagent/agents.ts`
  - `examples/extensions/structured-output.ts`
  - `examples/sdk/01-minimal.ts`
  - `examples/sdk/12-full-control.ts`

**Exclude:**
- full evaluator logic
- approval-safe writes
- downstream harness repos and codebases
- git mutation

## Approach & Verification Plan

### Steps

1. Define `RoleRunner` interface.
2. Implement subprocess-based runner using `pi --mode json -p --no-session`.
3. Add role prompt construction.
4. Add structured result schemas.
5. Register or inject structured terminating result behavior.
6. Parse JSON events and extract final structured result.
7. Persist role result summaries into loop state.
8. Add error handling for nonzero exit, malformed result, and cancellation.

### Risks & Unknowns

- Subprocess resource discovery must include project-local extension/prompts.
- Structured result tool availability inside subprocess may require extension loading strategy.
- SDK runner may be cleaner later; keep runner interface swappable.

### Verification

- [x] Test planner role subprocess returns valid structured planner result.
- [x] Malformed role output produces clear failure.
- [x] Nonzero subprocess exit produces clear failure.
- [x] Cancellation terminates subprocess.
- [x] Runner interface can support future SDK-backed implementation.

### Progress

- 2026-05-27: Added `RoleRunner` interface, subprocess-backed `SubprocessRoleRunner`, role prompt builders, structured result schemas, and terminating result tools for planner/generator/evaluator.
- 2026-05-27: Added generator subprocess Write-scope enforcement through `STORY_LOOP_ENFORCE_WRITE_SCOPE` / `STORY_LOOP_WRITE_SCOPE` environment handoff handled by the result-tool extension.
- 2026-05-27: Smoke-tested direct planner result tool, runner import, runner planner subprocess result extraction, subprocess failure handling, and abort handling using `pi --mode json`.
