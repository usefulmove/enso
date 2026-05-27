# Session: story-loop planner→generator→evaluator extension build
**Date:** 2026-05-27

## Overview

Built the complete `story-loop` pi extension (STORY-011 through STORY-016) in a single session. The extension implements a planner→generator→evaluator adversarial loop as a project-local pi extension with persistent state, bounded human checkpoints, and approval-gated planning artifact writes.

## Key Decisions

- **Execution order changed** from numeric to dependency order: 011 → 012 → 014 → 013 → 015 → 016. STORY-014 (runner seam) was built before STORY-013 (planner) so the planner could use the real subprocess runner seam rather than retrofitting it later.
- **Deterministic heuristic planner** implemented in `planner.ts` instead of model-backed planning. The planner classifies inputs by structural markers (section headers, list density, word count, keyword patterns) and emits READY / REFINE_WITH_HUMAN / SLICE_WITHIN_STORY / SPLIT_INTO_CHILD_STORIES / REPLAN without an LLM turn. This keeps planning cost-free and fast; a model-backed planner can be added through the runner seam later if the heuristic proves insufficient.
- **Subprocess runner** (`SubprocessRoleRunner`) uses `pi --mode json -p --no-session` with temp-file system prompt injection. No SDK session management — simpler and already demonstrated by the `subagent` example.
- **Mock modes** (`--mock-pass`, `--mock-tool-fail`, `--mock-subjective`, `--mock-planning-defect`, `--mock-counterexample`) added to `/story-loop run` for deterministic testing without model calls.
- **Write-scope enforcement** in generator subprocesses uses environment variable handoff (`STORY_LOOP_ENFORCE_WRITE_SCOPE`, `STORY_LOOP_WRITE_SCOPE`) picked up by `result-tool.ts` loaded in the child process.
- **Convention verifier** uses a generic `ConventionConfig` seam with default `rules` keyed on file path patterns — no downstream project paths hardcoded.
- **Artifact writes** auto-reject without UI (`ctx.hasUI === false`), preventing accidental writes in non-interactive/print/json modes.

## Artifacts Modified

- `docs/stories/STORY-011-story-loop-extension-design.md` — completed design
- `docs/stories/STORY-012-story-loop-extension-scaffold.md` — completed
- `docs/stories/STORY-013-story-loop-planner-pm-engine.md` — completed (scope expanded)
- `docs/stories/STORY-014-story-loop-isolated-role-runner.md` — completed
- `docs/stories/STORY-015-story-loop-evaluator-router.md` — completed (scope expanded)
- `docs/stories/STORY-016-story-loop-approval-safe-writes.md` — completed
- `docs/stories/STORY-017-story-loop-pilot-and-tuning.md` — pre-pilot context added
- `.pi/extensions/story-loop/` — 19 files created

## Verified (smoke tests)

| Test | Result |
|------|--------|
| `/story-loop status` (idle) | ✓ idle state |
| `/story-loop plan "fix bug"` (vague) | ✓ REFINE_WITH_HUMAN |
| `/story-loop plan docs/stories/STORY-012...` (complete story) | ✓ SLICE_WITHIN_STORY, 8 slices |
| `/story-loop plan` (5-step inline plan) | ✓ SPLIT_INTO_CHILD_STORIES, 5 proposed writes |
| `/story-loop plan "...needs replan"` | ✓ REPLAN, awaiting approval |
| `/story-loop run --mock-pass` | ✓ ACCEPTED, 0 findings |
| `/story-loop run --mock-tool-fail` | ✓ REJECTED → RETRY_GENERATOR |
| `/story-loop run --mock-subjective` | ✓ ESCALATED → ESCALATE_HUMAN |
| `/story-loop run --mock-planning-defect` | ✓ REJECTED → REPLAN, awaiting approval |
| `/story-loop run --mock-tool-fail` × 2 | ✓ repeated finding → REPLAN, awaiting approval |
| Structured planner result tool (model call) | ✓ READY, outcome in details |
| Runner failure (missing extension path) | ✓ RoleRunnerError |
| Runner abort (AbortController) | ✓ caught abort RoleRunnerError |
| Path guard: `docs/stories/test.md` | ✓ allowed |
| Path guard: `src/config.ts` | ✓ refused |
| Preview: new file | ✓ full content rendered |
| Preview: existing file (diff) | ✓ contextual diff with `- / +` lines |
| Auto-reject without UI | ✓ approved: false, written: false, file-created: false |

## Next Steps

- STORY-017: Run live pilot with real model calls on enso pilot tasks.
- Recommended first real-work pilot: update `docs/core/ARCHITECTURE.md` to document the new `story-loop` extension as a component/seam. This exercises raw request planning, clarification or READY classification, real generator subprocess, single-file Write scope, and evaluator verification.
- Tune planner thresholds based on first pilot observations.
- Consider whether runner model-backed planner option should be added after pilot data.

## Closeout

- Completed stories moved to `docs/reference/completed/`: STORY-011 through STORY-016.
- Active stories left in `docs/stories/`: STORY-017 pilot/tuning, STORY-009 prioritized scheduler.
