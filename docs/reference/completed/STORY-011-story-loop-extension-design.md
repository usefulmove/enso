# STORY-011: Design the enso story-loop pi extension

## Goal

Design a reusable enso-level pi extension that orchestrates a real human-aware planner→generator→evaluator execution loop.

The extension must accept raw user requests, existing enso stories, and existing detailed plans. Its planner acts as a project/program manager: it determines whether work is execution-ready, refines underspecified tasks with bounded human-in-the-loop questioning, decides whether work should pass through unchanged, be sliced within one story, or be split into child stories, and re-enters when execution evidence shows the plan itself is defective.

The design must prioritize accuracy over autonomy theater, use explicit state rather than prompt-only control flow, and fit enso’s parent protocol rather than any downstream harness instance. Downstream projects should consume the extension through configuration/adapters, not by forking project-specific assumptions into the core implementation.

## Acceptance Criteria

- [x] Current `generator-evaluator-loop` skill limitations are documented with source-backed rationale.
- [x] Extension architecture supports raw requests, existing stories, and detailed plans.
- [x] Architecture distinguishes generic enso behavior from downstream harness adapters/configuration.
- [x] Planner outcomes are defined:
  - [x] `READY`
  - [x] `REFINE_WITH_HUMAN`
  - [x] `SLICE_WITHIN_STORY`
  - [x] `SPLIT_INTO_CHILD_STORIES`
  - [x] `REPLAN`
- [x] Planner questioning policy is proactive but bounded.
- [x] Planning failure vs implementation failure routing is defined.
- [x] Generator executes one bounded slice at a time.
- [x] Evaluator design covers objective, subjective, convention-based, and counterexample-based findings.
- [x] Replanning requires human approval.
- [x] State machine, persistence model, and operator commands are specified.
- [x] Machine-readable schemas are specified for planner, generator, and evaluator results.
- [x] Planning-artifact writes are scoped and approval-gated per the enso Write operation and story lifecycle.
- [x] Implementation is decomposed into child stories.
- [x] Success metrics and simplification / kill criteria are defined.

## Context Scope

**Write:**
- `docs/stories/STORY-011-story-loop-extension-design.md`

**Read:**
- `AGENTS.md`
- `AOS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/core/PRD.md`
- `docs/reference/agentic-harnesses-sota-20260311.md`
- `skills/generator-evaluator-loop/SKILL.md`
- `skills/generator-evaluator-loop/references/**`
- `agent/reasoner.md`
- `agent/generator.md`
- `agent/evaluator.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/extensions.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/sdk.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/subagent/**`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/plan-mode/**`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/structured-output.ts`

**Exclude:**
- downstream harness repos and codebases
- git mutation
- upstream pi package changes
- implementation of the extension itself
- story/plan writes without explicit user approval

## Approach & Verification Plan

### Steps

1. Audit current skill against actual pi capabilities and enso protocol constraints.
2. Define intake normalization for raw request, story, and plan inputs.
3. Define planner-as-project-manager behavior and bounded questioning.
4. Specify planner outcomes and pass-through/refine/slice/split/replan policy.
5. Define isolated role runner and structured output contracts.
6. Define generator slice execution behavior.
7. Define evaluator aspects, counterexample behavior, and router transitions.
8. Define persistence, operator UX, approval-gated replanning, and approval-safe artifact writes.
9. Identify which behavior belongs in generic enso core vs downstream project adapters.
10. Break implementation into child stories and define ROI metrics.

### Risks & Unknowns

- Accuracy may require more human checkpoints than expected.
- Planner may over-split straightforward work without tuning.
- Approval-safe writes may add friction.
- Multi-aspect evaluation may become expensive if findings are not grounded.
- Some downstream projects may need convention-doc adapters that should not leak into enso core.

### Verification

- [x] Every control-flow mechanism maps to an actual pi extension or SDK capability.
- [x] No design step depends on nonexistent built-in subagent/task machinery.
- [x] Planner policy defines human-questioning triggers and stopping conditions.
- [x] Router distinguishes implementation retry from planner re-entry.
- [x] Replanning is approval-gated.
- [x] Generic enso responsibilities are separated from downstream harness adapter responsibilities.
- [x] Child-story plan is bounded and executable.
- [x] Design includes metrics proving whether the loop improves accuracy.

## Design

### Source-backed constraints

| Source | Design implication |
|--------|--------------------|
| pi `docs/extensions.md` | Project-local auto-discovery requires `.pi/extensions/*/index.ts`; commands use `pi.registerCommand()`; durable extension state uses `pi.appendEntry()` and restores from session entries; UI prompts use `ctx.ui`; `ctx.hasUI` must be checked for non-interactive modes. |
| pi `docs/json.md` | Subprocess role isolation can use `pi --mode json -p --no-session`; stdout is JSONL event stream; final role output must be extracted from `message_end`, `tool_execution_end`, or a terminating structured result tool. |
| pi `examples/extensions/subagent/` | There is no built-in subagent/task primitive. Isolated agents are implemented by spawning pi subprocesses, passing prompts/system prompts, parsing JSON events, and handling abort/nonzero exits explicitly. |
| pi `examples/extensions/structured-output.ts` | Machine-readable role completion should use a custom result tool that returns `terminate: true`, avoiding an extra freeform assistant turn. |
| pi `examples/extensions/plan-mode/` | Mode/stateful orchestration should use explicit in-memory state, `appendEntry()` persistence, status widgets, and tool restrictions rather than prompt-only control. |
| `AGENTS.md` §4, §6, §10 | Planning must complete before mutation; Context Scope is the execution boundary; every changed line must map to the story. |
| `docs/reference/agentic-harnesses-sota-20260311.md` | Grounding beats self-evaluation; original task constraints must survive subagent hops; typed state and external verification are preferred over freeform summaries. |

### Current skill limitations

The existing `skills/generator-evaluator-loop/SKILL.md` is a useful workflow description but not an executable orchestration surface.

1. **Story-only intake.** The skill starts from an already complete story with a Verification section. It cannot accept raw user requests or existing detailed plans.
2. **No planner/PM role.** It assumes the Reasoner has already produced an execution-ready contract and does not define pass-through, refinement, slice, split, or replan decisions.
3. **Prompt-only control flow.** Loop state is appended to the story as prose. There is no extension-owned state machine that commands can resume, inspect, or route.
4. **No real subagent primitive.** The skill says to invoke Generator/Evaluator sub-agents via a `task` tool, but pi does not provide that as a built-in. The actual implementation must use subprocess JSON mode, RPC, or SDK sessions.
5. **No machine-readable role output.** Evaluator output is a markdown template, not a guaranteed schema. Routing therefore depends on prose parsing.
6. **Writes are not approval-safe.** The current loop appends notes/results directly to the story. The new extension must separate proposed planning-artifact writes from approved writes.
7. **No generic adapter seam.** `CONVENTIONS_MAP.md` is project-shape-aware. The new extension needs generic enso defaults plus downstream-configurable convention and artifact roots.
8. **No explicit planning-defect route.** The skill distinguishes objective retry vs subjective escalation, but it does not route evidence that the plan itself is defective back to a planner under human approval.

### Architecture

The extension is a project-local pi extension:

```text
.pi/extensions/story-loop/
  index.ts              # extension entrypoint; commands/events/status
  types.ts              # loop state and shared result types
  state.ts              # state restore/persist helpers
  intake.ts             # raw/story/plan input normalization
  planner.ts            # planner orchestration
  planning-types.ts     # planner-specific schemas
  runner.ts             # isolated role runner interface + subprocess implementation
  role-prompts.ts       # role prompt composition
  result-tool.ts        # terminating structured result tool registration/injection
  result-schemas.ts     # planner/generator/evaluator schemas
  evaluator.ts          # evaluator orchestration
  router.ts             # routing transitions
  verifiers/
    contract.ts
    scope.ts
    convention.ts
    counterexample.ts
  approval.ts           # human approval state and commands
  artifact-writes.ts    # scoped planning-artifact writes
  diff-preview.ts       # preview rendering
  prompts/
    planner.md
```

Core loop:

```text
intake → planner → approval? → generator(slice) → evaluator → router
          ↑              │                         │          │
          └── replan ◀── approval ◀── planning defect ◀──────┘
```

The parent extension owns state, commands, human questions, approvals, and routing. Role subprocesses produce structured results only.

### Generic enso core vs downstream adapters

| Belongs in generic story-loop core | Belongs in downstream adapter/config |
|------------------------------------|--------------------------------------|
| Loop state machine and command surface | Additional convention-doc path mappings |
| Intake normalization for raw text, story path, plan text/path | Project-specific story ID formats beyond enso defaults |
| Planner outcome enum and schemas | Downstream identity/principles doc lookup overrides |
| Role runner interface and subprocess implementation | Custom verification command discovery |
| Evaluator finding taxonomy and router | Allowed artifact roots beyond `docs/stories/` / selected plan roots |
| Approval-gated planning-artifact writes | Project-specific prompt appendices or role tone |
| Metrics collection | Domain-specific counterexample probes |

No downstream harness repository paths should be hardcoded in enso core.

### Intake normalization

Supported inputs:

1. **Raw request text** — default when args do not resolve to a file and do not contain a recognized story header.
2. **Story path** — existing file whose content contains `## Goal`, `## Acceptance Criteria`, and `## Context Scope`.
3. **Detailed plan text/path** — file or inline text with steps but not a full enso story contract.

Normalized object:

```ts
type PlanningInputKind = "raw_request" | "story" | "plan";

interface PlanningInput {
  kind: PlanningInputKind;
  source: "args" | "file" | "editor" | "session";
  label: string;
  content: string;
  path?: string;
  detectedStoryId?: string;
}
```

### Planner/PM behavior

The planner improves execution probability. It does not merely format requests.

Planner responsibilities:
- identify the active artifact and desired outcome
- determine whether success criteria are checkable
- identify missing Context Scope inputs/outputs
- decide whether the work is one bounded slice, multiple slices in one story, or multiple child stories
- ask targeted human questions only when needed
- recommend replan when execution evidence shows the plan is defective

Planner outcomes:

| Outcome | Meaning | Next state |
|---------|---------|------------|
| `READY` | Existing contract is execution-ready as-is. | `READY` |
| `REFINE_WITH_HUMAN` | Required information is missing and cannot be safely inferred. | `AWAITING_HUMAN_CLARIFICATION` |
| `SLICE_WITHIN_STORY` | One story is valid, but execution must proceed in bounded slices. | `READY` with `slices[]` |
| `SPLIT_INTO_CHILD_STORIES` | Work has independent deliverables or verification contracts. | `AWAITING_APPROVAL` for child-story proposals |
| `REPLAN` | Existing plan is defective or obsolete. | `AWAITING_APPROVAL` before planner re-entry |

Bounded questioning policy:
- Ask at most 3 questions per planning pass by default.
- Every question must name the missing field and the execution risk it reduces.
- Prefer multiple-choice questions when choices are knowable.
- Do not ask about information that can be retrieved from project files.
- Stop questioning when remaining uncertainty can be represented as a risk in the execution contract.
- If no UI is available, return `REFINE_WITH_HUMAN` with questions in the planner result instead of blocking.

### State machine

```text
IDLE
  └─ plan → PLANNING
PLANNING
  ├─ READY / SLICE_WITHIN_STORY → READY
  ├─ REFINE_WITH_HUMAN → AWAITING_HUMAN_CLARIFICATION
  ├─ SPLIT_INTO_CHILD_STORIES → AWAITING_APPROVAL
  └─ REPLAN → AWAITING_APPROVAL
READY
  └─ run → RUNNING_GENERATOR
RUNNING_GENERATOR
  └─ generator result → RUNNING_EVALUATOR
RUNNING_EVALUATOR
  ├─ accepted → COMPLETE
  ├─ objective implementation finding → READY retry next slice/iteration
  ├─ subjective finding → ESCALATED
  └─ planning defect → AWAITING_APPROVAL
AWAITING_APPROVAL
  ├─ approve → approved transition/write/replan
  └─ reject → prior safe state or ESCALATED
ERROR
  └─ resume/reject → safe state
```

### Persistence model

Use `pi.appendEntry("story-loop", snapshot)` for every state transition. Restore by scanning `ctx.sessionManager.getBranch()` and selecting the latest valid `story-loop` custom entry.

```ts
interface LoopState {
  version: 1;
  phase: LoopPhase;
  active?: ActiveArtifact;
  iteration: number;
  currentSliceIndex?: number;
  pendingApproval?: PendingApproval;
  lastPlannerResult?: PlannerResult;
  lastGeneratorResult?: GeneratorResult;
  lastEvaluatorResult?: EvaluatorResult;
  roleHistory: RoleResultSummary[];
  metrics: LoopMetrics;
  updatedAt: string;
}
```

State entries do not participate in LLM context. Human-visible status is rendered from restored state.

### Operator commands

| Command | Behavior |
|---------|----------|
| `/story-loop status` | Show phase, active artifact, current slice, pending approval, last verdict, metrics summary. |
| `/story-loop plan <input>` | Normalize input, run planner, ask bounded clarification if needed, persist planner result. No file writes. |
| `/story-loop run` | Execute one ready slice, evaluate it, route result. Rejects if no ready execution contract exists. |
| `/story-loop resume` | Re-render restored state and continue the next safe transition. Does not auto-write. |
| `/story-loop approve [id]` | Approve pending replan or planning-artifact write after preview. |
| `/story-loop reject [id]` | Reject pending approval and leave files unchanged. |

### Role runner

Initial implementation uses a subprocess runner, not SDK sessions, because pi already exposes JSON event mode and examples demonstrate that path.

Runner behavior:
- spawn `pi --mode json -p --no-session`
- pass role-specific system prompt with `--append-system-prompt <temp-file>`
- pass role tools explicitly:
  - planner: `read,bash,grep,find,ls,story_loop_planner_result`
  - generator: `read,bash,edit,write,story_loop_generator_result`
  - evaluator: `read,bash,grep,find,ls,story_loop_evaluator_result`
- parse JSONL stdout
- stream progress into parent status where useful
- extract final terminating result tool details
- fail clearly on nonzero exit, malformed result, missing final result, or abort

The runner interface remains swappable for a future SDK-backed implementation.

### Machine-readable schemas

Planner result:

```ts
interface PlannerResult {
  schema: "story-loop/planner-result@1";
  outcome: "READY" | "REFINE_WITH_HUMAN" | "SLICE_WITHIN_STORY" | "SPLIT_INTO_CHILD_STORIES" | "REPLAN";
  confidence: "low" | "medium" | "high";
  rationale: string;
  questions: PlannerQuestion[];
  executionContract?: ExecutionContract;
  proposedSlices?: ExecutionSlice[];
  proposedArtifactWrites?: ProposedArtifactWrite[];
  approvalRequired: boolean;
  risks: string[];
}
```

Generator result:

```ts
interface GeneratorResult {
  schema: "story-loop/generator-result@1";
  status: "COMPLETED" | "BLOCKED" | "FAILED";
  sliceId: string;
  summary: string;
  filesChanged: Array<{ path: string; reason: string }>;
  commandsRun: Array<{ command: string; exitCode?: number; summary: string }>;
  assumptions: string[];
  blockers: string[];
  scopeConcerns: string[];
}
```

Evaluator result:

```ts
interface EvaluatorResult {
  schema: "story-loop/evaluator-result@1";
  status: "ACCEPTED" | "REJECTED" | "ESCALATED";
  sliceId: string;
  findings: EvaluatorFinding[];
  toolChecks: ToolCheckResult[];
  routingRecommendation: "ACCEPT" | "RETRY_GENERATOR" | "ESCALATE_HUMAN" | "REPLAN";
  repeatedFindingFingerprint?: string;
  replanApprovalRequired: boolean;
}
```

Finding taxonomy:

```ts
type FindingKind = "objective" | "subjective" | "convention-cited" | "counterexample-backed" | "planning-defect";
type FindingSeverity = "blocker" | "concern" | "nitpick";
```

### Generator slice execution

Generator executes exactly one `ExecutionSlice` per `/story-loop run` transition.

Rules:
- receive original task/spec, full execution contract, current slice, and prior evaluator feedback
- modify only paths allowed by the execution contract Write scope
- do not modify planning artifacts, acceptance criteria, or verification contract
- report changed files and commands via `GeneratorResult`
- if the slice cannot be completed without expanding scope, return `BLOCKED` with `scopeConcerns[]`

### Evaluator and router

Evaluator aspects:

| Aspect | Evidence |
|--------|----------|
| contract verifier | story/plan verification commands and acceptance criteria |
| scope/protocol verifier | Write/Read/Exclude scope, enso §10, disallowed git mutation |
| convention verifier | cited convention docs from generic config/adapters |
| counterexample verifier | concrete non-mutating repro or adversarial check |

Routing:

| Evaluator evidence | Route |
|--------------------|-------|
| all required checks pass, no blockers | `ACCEPT` |
| objective/tool/convention-cited implementation defect | `RETRY_GENERATOR` |
| subjective ambiguity/design concern | `ESCALATE_HUMAN` |
| missing/incorrect plan, impossible scope, invalid verification contract | `REPLAN` pending approval |
| same finding fingerprint repeats | `ESCALATE_HUMAN` or `REPLAN` pending approval |

Planning failure vs implementation failure:
- **Implementation failure**: the contract is valid, but generated work failed it. Retry generator.
- **Planning failure**: the contract is ambiguous, impossible, stale, missing required scope, or decomposed at the wrong granularity. Pause for human approval, then re-enter planner.

### Approval-safe planning artifact writes

Planner may propose artifact writes but cannot perform them. Proposed writes enter `pendingApproval`.

Allowed write classes:
- story drafts
- story refinements
- child-story proposals
- plan updates

Approval requirements:
- show exact path and full proposed content for new files
- show focused diff for existing files
- require explicit `/story-loop approve`
- refuse paths outside configured planning-artifact roots
- persist approval/rejection decision
- rejected writes are no-ops

Default allowed roots are enso planning roots such as `docs/stories/`. Downstream harnesses can configure additional roots.

### Implementation decomposition

Execution order approved for the implementation stories:

1. `STORY-012` — scaffold commands, persistent state, status UI.
2. `STORY-014` — implement isolated role runner and structured role results.
3. `STORY-013` — implement planner/PM intake normalization and bounded clarification using the runner seam.
4. `STORY-015` — implement evaluator aspect stack and retry/escalate/replan router.
5. `STORY-016` — implement approval-safe planning artifact writes.
6. `STORY-017` — pilot the loop and tune planner/evaluator behavior.

### Success metrics and kill criteria

Pilot metrics:
- first-pass acceptance rate
- average retries per accepted slice
- planner re-entry rate
- subjective escalation rate
- counterexample hit rate
- human override rate
- token/time cost per accepted slice

Keep if:
- evaluator catches real objective defects before handoff
- planner reduces ambiguous execution starts
- replan path prevents repeated generator churn
- operator status makes the loop resumable after reload/session switch

Simplify if:
- planner asks more than 3 questions on routine tasks
- most evaluator findings are subjective/noisy
- subprocess isolation cost dominates small stories
- approval UX adds more friction than safety for planning artifacts

Kill or replace if:
- structured role results are unreliable even with terminating tools
- metrics show no improvement over direct enso story execution
- repeated human overrides indicate planner/router policy is wrong

### Progress

- 2026-05-27: Completed source-backed architecture design for the story-loop pi extension. Defined intake, planner outcomes, state machine, persistence model, operator commands, structured role schemas, evaluator/router behavior, approval-safe artifact writes, implementation order, and ROI criteria.

### Reflection

- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [x] No new insights → proceed

**Do not begin execution until this section is complete.**
