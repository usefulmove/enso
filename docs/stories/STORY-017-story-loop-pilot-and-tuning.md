# STORY-017: Pilot story-loop extension and tune planner/evaluator behavior

## Goal

Run the completed `story-loop` extension on representative enso work, measure whether it improves accuracy, and tune or simplify behavior based on evidence.

The pilot should validate the generic enso extension first. Downstream harness instances may be used later as adapter tests, but this story’s primary target is the enso parent repo and protocol workflow.

## Acceptance Criteria

- [ ] Pilot includes at least three task types:
  - [ ] raw request
  - [ ] existing story
  - [ ] detailed plan
- [ ] At least one pilot exercises `REFINE_WITH_HUMAN`.
- [ ] At least one pilot exercises slice vs split decision-making.
- [ ] At least one pilot exercises evaluator retry or escalation.
- [ ] Metrics are captured:
  - [ ] first-pass acceptance rate
  - [ ] average retries per accepted slice
  - [ ] planner re-entry rate
  - [ ] subjective escalation rate
  - [ ] counterexample hit rate
  - [ ] human override rate
  - [ ] token/time cost per accepted slice
- [ ] Planner aggressiveness is adjusted if it over-splits or over-questions.
- [ ] Evaluator rules are adjusted if findings are noisy or insufficiently grounded.
- [ ] Final recommendation is recorded: keep, simplify, expand, or replace.

## Context Scope

**Write:**
- `docs/stories/STORY-017-story-loop-pilot-and-tuning.md`
- `docs/logs/<session-log>.md`
- `docs/reference/LESSONS.md` *(only if durable lessons are learned)*
- `.pi/extensions/story-loop/**` *(only for tuning changes discovered during pilot)*

**Read:**
- `docs/stories/STORY-011-story-loop-extension-design.md`
- `docs/stories/STORY-012-story-loop-extension-scaffold.md`
- `docs/stories/STORY-013-story-loop-planner-pm-engine.md`
- `docs/stories/STORY-014-story-loop-isolated-role-runner.md`
- `docs/stories/STORY-015-story-loop-evaluator-router.md`
- `docs/stories/STORY-016-story-loop-approval-safe-writes.md`
- selected enso pilot stories/plans

**Exclude:**
- unrelated harness cleanup
- downstream harness repos and codebases unless explicitly selected as read-only adapter examples
- git mutation

## Approach & Verification Plan

### Steps

1. Select pilot tasks covering raw request, story, and detailed plan inputs.
2. Run `/story-loop plan` and `/story-loop run` flows.
3. Record state transitions, role results, and human interventions.
4. Capture metrics.
5. Tune planner questioning/splitting thresholds if needed.
6. Tune evaluator aspect behavior if needed.
7. Record final recommendation.

### Risks & Unknowns

- Early pilot failures may reflect implementation bugs rather than architecture flaws.
- Human-in-loop flow may need UX tuning before metrics are meaningful.
- Evaluator may be too strict or too passive; pilot should distinguish both failure modes.
- Adapter needs from downstream harnesses may tempt premature generalization before enso core is proven.

### Verification

- [ ] Pilot tasks complete or produce useful escalation/replan artifacts.
- [ ] Metrics are recorded.
- [ ] Tuning changes map to observed evidence.
- [ ] Final keep/simplify/expand/replace recommendation is written.
- [ ] Session log captures outcomes.

### Pre-pilot context

The extension was built and smoke-tested this session (2026-05-27). File inventory:

```
.pi/extensions/story-loop/
  index.ts            # commands, state machine, /plan /run /approve /reject /status
  types.ts            # LoopState, LoopPhase, ActiveArtifact, PendingApproval
  state.ts            # appendEntry() persist/restore
  intake.ts           # raw request / story / plan normalization
  planner.ts          # deterministic PM: READY / REFINE_WITH_HUMAN / SLICE / SPLIT / REPLAN
  planning-types.ts   # PlanningInput, PlannerRunResult
  runner.ts           # SubprocessRoleRunner (pi --mode json subprocess)
  role-prompts.ts     # role system prompt builders
  result-tool.ts      # terminating result tools; generator write-scope enforcement
  result-schemas.ts   # PlannerResult / GeneratorResult / EvaluatorResult schemas
  evaluator.ts        # aspect evaluator: contract + scope + convention + counterexample
  router.ts           # route to accept / retry / escalate / replan
  verifiers/
    contract.ts       # execution contract checks + tool/command runner
    scope.ts          # Write/Read scope and git mutation checks
    convention.ts     # cited convention verifier with generic config seam
    counterexample.ts # concrete-evidence-only counterexample blocker
  approval.ts         # path guard, approval prompt, configurable allowed roots
  artifact-writes.ts  # applyPlannerArtifactWrites, executeApprovedWrite
  diff-preview.ts     # new-file / contextual-diff preview rendering
  prompts/planner.md  # planner subprocess system prompt
```

**Suggested pilot tasks:**

1. **Raw request** — `/story-loop plan Update LESSONS.md with a lesson about bounded planner questioning` → should produce `REFINE_WITH_HUMAN` (short, lacks scope/success criteria)
2. **Existing story** — `/story-loop plan docs/stories/STORY-009-prioritized-story-scheduler.md` → should produce `READY` or `SLICE_WITHIN_STORY`; then `/story-loop run` with real subprocess
3. **Multi-step plan** — `/story-loop plan` with a 5+ step inline plan → should produce `SPLIT_INTO_CHILD_STORIES`

**Metrics baseline:** all currently zero. First pilot run will establish the baseline.
