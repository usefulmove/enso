---
id: STORY-001
title: Human-in-the-loop planner-generator-evaluator loop pi extension
kind: design-and-implementation-seed
state: evaluation
phase: evaluator
attempt: 4
human_gate: none
verdict: pending
next_allowed_transitions:
  evaluator_completed: eval_review
  block: blocked
  clarifying_question: needs_input
state_model:
  principle: STORY.md is the persisted state value; transitions are pure functions over parsed story state plus explicit events.
  transition_signature: "transition(story: StoryState, event: Event) -> Result<StoryState, TransitionError>"
  effect_boundary: "pi extension shell performs I/O, UI, model dispatch, and file writes only after pure transition validation."
---





# STORY-001 Human-in-the-loop Planner-Generator-Evaluator Loop Pi Extension

## Goal

Design and implement the first version of a strict pi extension that formalizes the planner -> generator <-> evaluator adversarial development loop, with `STORY.md` as the canonical persisted state object passed through every state transition and with human approval gates enabled at each state boundary.

The extension should make the orchestration pattern executable, inspectable, and recursive: each step consumes the current parsed story state and produces either a validated next story state, a proposed patch, or a human decision request.

## Acceptance Criteria

- [ ] A formal `STORY.md` state schema is defined with machine-readable frontmatter and fixed human-readable markdown sections.
- [ ] A pure state transition model is designed and implemented: `transition(story, event) -> Result<story, error>` with no file, UI, or model side effects inside the transition core.
- [ ] The pi extension provides an orchestration command, tentatively `/pge`, that loads the active story, validates it, shows current state, and proposes the next legal action.
- [ ] The extension enforces human approval gates for all state exits: plan approval, generation approval, evaluator verdict approval, revision approval, blocked/unblocked, and done.
- [ ] Planner, generator, and evaluator roles are separated by prompts, state permissions, and tool permissions.
- [ ] Evaluator cannot directly mutate implementation files; it can only produce critique, verdict, and proposed transition events.
- [ ] Generator cannot mark its own work accepted or done.
- [ ] All state transitions append an audit entry to the story transition log.
- [ ] The first implementation includes fixtures/tests for valid transitions, invalid transitions, malformed stories, and human-gated transitions.
- [ ] The extension can be loaded locally by pi from `.pi/extensions/hitl-pge-loop/index.ts`.
- [ ] Manual verification demonstrates a complete minimal loop: `planning -> plan_review -> generation -> evaluation -> eval_review -> accepted/done` using this story or a fixture story.

## Context Scope

**Write:**
- `.pi/extensions/hitl-pge-loop/index.ts`
- `.pi/extensions/hitl-pge-loop/story-schema.ts`
- `.pi/extensions/hitl-pge-loop/story-parser.ts`
- `.pi/extensions/hitl-pge-loop/state-machine.ts`
- `.pi/extensions/hitl-pge-loop/story-renderer.ts`
- `.pi/extensions/hitl-pge-loop/agents.ts`
- `.pi/extensions/hitl-pge-loop/ui.ts`
- `.pi/extensions/hitl-pge-loop/__fixtures__/STORY.valid.md`
- `.pi/extensions/hitl-pge-loop/__fixtures__/STORY.invalid-transition.md`
- `.pi/extensions/hitl-pge-loop/__fixtures__/STORY.malformed.md`
- `.pi/extensions/hitl-pge-loop/test.ts`
- `docs/stories/STORY-001.md`
- `docs/reference/hitl-pge-loop-design.md`

**Read:**
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/core/PRD.md`
- `docs/stories/STORY-009-prioritized-story-scheduler.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/README.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/extensions.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/tui.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/session-format.md`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/plan-mode/index.ts`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/question.ts`
- `/home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/subagent/index.ts`

**Exclude:**
- `.git/`
- `node_modules/`
- `assets/`
- unrelated `docs/reference/completed/` stories
- implementation files outside `.pi/extensions/hitl-pge-loop/`

## STORY.md State Spec Seed

The story file is the durable state value. The extension must parse it into a typed object, apply pure transitions, then render it back to markdown.

### Required frontmatter fields

```yaml
id: STORY-001
title: Human-in-the-loop planner-generator-evaluator loop pi extension
kind: design-and-implementation-seed
state: plan_review
phase: planner
attempt: 0
human_gate: required
verdict: pending
next_allowed_transitions:
  approve_plan: generation
  revise_plan: planning
  block: blocked
state_model:
  principle: "STORY.md is the persisted state value"
  transition_signature: "transition(story: StoryState, event: Event) -> Result<StoryState, TransitionError>"
  effect_boundary: "pi extension shell performs I/O, UI, model dispatch, and file writes"
```

### Canonical states

| State | Owner | Tools | Exit gate | Legal exits |
|-------|-------|-------|-----------|-------------|
| `intake` | Human / orchestrator | read-only | human | `planning`, `blocked` |
| `planning` | Planner | read-only | automatic after valid plan draft | `plan_review`, `blocked` |
| `plan_review` | Human | no autonomous mutation | human pre-approves detailed `STORY.md` update | `generation`, `planning`, `blocked` |
| `generation` | Generator | write scope only | automatic after generator output | `evaluation`, `needs_input`, `blocked` |
| `evaluation` | Evaluator | read + verification only | automatic after verdict | `eval_review`, `revision`, `needs_input`, `blocked` |
| `eval_review` | Human | no autonomous mutation | human | `accepted`, `revision`, `generation`, `blocked` |
| `revision` | Planner / Generator | scoped by revision request | human or automatic depending on event | `generation`, `evaluation`, `needs_input`, `blocked` |
| `needs_input` | Human | no autonomous mutation | human answers clarifying question | interrupted state |
| `accepted` | Human / orchestrator | verification only | human | `done`, `revision`, `blocked` |
| `done` | Orchestrator | none | terminal | none |
| `blocked` | Human | no autonomous mutation | human | `intake`, `planning`, prior state |

### Event model seed

```ts
type Event =
  | { type: "submit_intake"; actor: "human"; summary: string }
  | { type: "planner_completed"; actor: "planner"; planPatch: StoryPatch }
  | { type: "approve_plan"; actor: "human"; notes?: string }
  | { type: "revise_plan"; actor: "human"; notes: string }
  | { type: "generator_completed"; actor: "generator"; implementationSummary: string; evidence: Evidence[] }
  | { type: "evaluator_completed"; actor: "evaluator"; verdict: "pass" | "fail"; critique: string; evidence: Evidence[] }
  | { type: "clarifying_question"; actor: "planner" | "generator" | "evaluator"; question: string; returnState?: StoryStateName }
  | { type: "answer_input"; actor: "human"; answer: string }
  | { type: "approve_evaluator_verdict"; actor: "human"; notes?: string }
  | { type: "request_revision"; actor: "human" | "evaluator"; notes: string }
  | { type: "accept"; actor: "human"; evidence: Evidence[] }
  | { type: "mark_done"; actor: "human" | "orchestrator"; evidence: Evidence[] }
  | { type: "block"; actor: "human" | "orchestrator"; reason: string }
  | { type: "unblock"; actor: "human"; targetState: StoryStateName; notes?: string };
```

### Pure core / effect shell boundary

The extension should be organized around this boundary:

```ts
// Pure core
parseStory(markdown: string): Result<StoryState, ParseError>
validateStory(story: StoryState): ValidationResult
transition(story: StoryState, event: Event): Result<StoryState, TransitionError>
renderStory(story: StoryState): string
nextActions(story: StoryState): Action[]

// Effect shell
loadActiveStory(cwd): Promise<string>
askHuman(action, story): Promise<Event | Cancelled>
runPlanner(story): Promise<Event>
runGenerator(story): Promise<Event>
runEvaluator(story): Promise<Event>
writeStory(path, renderedStory): Promise<void>
```

The pure core must be independently testable with fixture markdown files. The shell may use pi APIs, TUI dialogs, model prompts, and file tools.

## Approach & Verification Plan

### Steps

1. **Confirm extension contract and story state model**  
   Define the exact v0 state schema, required markdown sections, event names, legal transitions, and owner permissions.  
   → verify: `docs/reference/hitl-pge-loop-design.md` contains a transition table, event model, role permissions, and parser/rendering rules.

2. **Create extension skeleton**  
   Create `.pi/extensions/hitl-pge-loop/` with `index.ts` as the pi extension entrypoint and separate pure modules for schema, parser, renderer, and state machine.  
   → verify: pi can discover/load the extension path without syntax errors.

3. **Implement pure story parser and validator**  
   Parse YAML frontmatter plus fixed markdown sections into `StoryState`. Validate required fields, allowed states, legal `next_allowed_transitions`, and section presence.  
   → verify: fixture tests pass for valid, invalid-transition, and malformed stories.

4. **Implement pure transition function**  
   Encode all legal state transitions as table-driven logic. Reject illegal actor/state/event combinations. Append transition-log entries in the returned story state.  
   → verify: tests prove generator cannot approve itself, evaluator cannot mutate, done cannot be reached without accepted state/evidence, and human gates cannot be bypassed.

5. **Implement renderer**  
   Render `StoryState` back into stable markdown with preserved human sections where possible and normalized frontmatter.  
   → verify: parse-render-parse roundtrip preserves semantic state for valid fixture.

6. **Implement pi command `/pge`**  
   Command loads active story, validates it, displays current state and next legal actions, and prompts human when state is gated.  
   → verify: manual run shows current story state and legal next actions.

7. **Implement human gate UI**  
   Use `ctx.ui.select`, `ctx.ui.confirm`, or `ctx.ui.custom` for explicit transition decisions: approve detailed story/plan update, answer clarifying question, revise, block, accept, done.  
   → verify: cancellation does not mutate `STORY.md`; approval appends a transition-log entry and advances state.

8. **Implement role dispatch prompts**  
   Add planner/generator/evaluator prompt builders that always include original goal, acceptance criteria, context scope, current state, and transition rules.  
   → verify: generated prompts are inspectable and include anti-drift constraints.

9. **Implement tool permission enforcement by phase**  
   Use `pi.setActiveTools()` and/or `tool_call` interception to restrict tools: planning may edit only the active `STORY.md`, generation is write-scoped, evaluation is read/verify-only, review states have no autonomous mutation.  
   → verify: attempted writes outside planning story update, generation, or Write scope are blocked with clear reason.

10. **Implement minimal model-driven loop**  
    Wire `/pge run` or `/pge next` to dispatch the correct role based on current state and then feed its proposed event into `transition`.  
    → verify: using a fixture story, the loop can move from planning through eval review with human approvals.

11. **Document usage and limitations**  
    Write concise operator instructions and v0 limitations in the design reference.  
    → verify: a new session can follow the document to load the extension and run a fixture loop.

12. **Self-review and reduce scope**  
    Remove speculative abstractions, keep only the pure state core, pi shell, human gates, role prompts, and fixtures required for v0.  
    → verify: diff is limited to declared Write scope and acceptance criteria map directly to changed files.

### Risks & Unknowns

- **Markdown as state can drift.** Mitigation: frontmatter is canonical for machine state; fixed sections are validated; transition log is normalized by renderer.
- **Roundtrip rendering may destroy human formatting.** Mitigation: preserve raw body sections initially; only normalize known machine-owned blocks and frontmatter.
- **Human-in-loop at every micro-step could become annoying.** Mitigation: gate state exits, not every tool call; still block illegal tools by phase.
- **Subagents may be overkill for v0.** Mitigation: start with role-specific prompts in one extension; leave spawned pi subagents as a later enhancement if isolation is needed.
- **pi extension APIs differ across modes.** Mitigation: v0 targets interactive mode; non-interactive mode should fail closed when `ctx.hasUI` is false for human gates.
- **Strict tool scope enforcement may be hard with arbitrary bash.** Mitigation: v0 blocks write/edit tools outside generation and constrains bash using conservative command allowlists in planning/evaluation.
- **Existing enso story lifecycle may conflict with new state fields.** Mitigation: preserve existing story sections and add frontmatter/state log without removing current enso fields.

### Verification

- [ ] Read every file in `Write:` scope before modifying it; for new files, verify parent directory and naming before creation.
- [ ] Run fixture/unit tests for parser, validator, transition table, and render roundtrip.
- [ ] Load pi with the local extension and confirm no startup errors.
- [ ] Manually run `/pge` against `docs/stories/STORY-001.md` and verify it reports `state=plan_review` with legal actions `approve_plan`, `revise_plan`, and `block`.
- [ ] Approve a fixture plan and verify state advances to `generation` with an appended transition log entry.
- [ ] Attempt illegal transitions and verify rejection: generator self-accept, evaluator write attempt, done without accepted state, generation outside Write scope.
- [ ] Run a minimal end-to-end fixture loop through planning, generation, evaluation, eval review, accepted, and done.
- [ ] Update `docs/reference/LESSONS.md` if implementation reveals reusable patterns or pitfalls.
- [ ] Update architecture docs if this becomes a new enso subsystem rather than a local pi extension experiment.

### Reflection

- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [ ] No new insights → proceed

**Do not begin execution until this section is approved by the human.**

## Planner Output

This story is currently the planner output for the first recursive state-function seed. The next legal transition is a human decision:

1. `approve_plan` → enter `generation` and let the generator implement the extension v0.
2. `revise_plan` → return to `planning` with requested changes.
3. `block` → mark blocked with a reason.

## Generator Input Contract

When approved, the generator must treat this file as the canonical input state. It must not infer hidden requirements from conversation memory if they conflict with this file. If something is missing, it must request a transition back to `planning` or `blocked` rather than silently expanding scope.

## Evaluator Input Contract

The evaluator must judge the implementation against this story's Acceptance Criteria and Verification section. It must provide evidence from tests, file inspection, or command output. It must not approve based only on model reasoning.

## Transition Log

- 2026-05-27T00:00:00Z | actor=planner | event=planner_completed | from=planning | to=plan_review | note=Initial seed story generated with pure state function model and pi extension implementation plan.
- 2026-05-27T00:00:01.000Z | actor=human | event=approve_plan | from=plan_review | to=generation | note=User approved plan.
- 2026-05-27T00:00:02.000Z | actor=generator | event=generator_completed | from=generation | to=evaluation | note=Implemented v0 pi extension with pure parser/validator/renderer/state-machine core, pge command, pge_event tool, human gate UI, role prompts, phase-based tool enforcement, fixtures, tests, and design reference.
- 2026-05-27T00:00:03.000Z | actor=evaluator | event=evaluator_completed | from=evaluation | to=revision | note=fail: Interface exposed manual role dispatch. Desired UX is one front-door command that chooses planner/generator/evaluator automatically and only interrupts for human decisions or clarifying questions.
- 2026-05-27T00:00:04.000Z | actor=generator | event=generator_completed | from=revision | to=evaluation | note=Revised interface to make /pge and /pge run the primary front door. The orchestrator now infers the next role from story state, auto-continues after pge_event, reserves /pge prompt as an advanced/debug escape hatch, and keeps humans responsible only for gated decisions.
- 2026-05-27T00:00:05.000Z | actor=evaluator | event=evaluator_completed | from=evaluation | to=revision | note=fail: Needed first-class needs_input state and explicit pre-approval of the detailed STORY.md plan/story update before exiting plan_review.
- 2026-05-27T00:00:06.000Z | actor=generator | event=generator_completed | from=revision | to=evaluation | note=Added needs_input state, clarifying_question/answer_input events, resume-to-interrupted-state behavior, explicit plan pre-approval confirmation at plan_review exit, role prompt guidance, tests, and documentation updates.
- 2026-05-27T00:00:07.000Z | actor=evaluator | event=evaluator_completed | from=evaluation | to=revision | note=fail: Planner needed an actual way to create the detailed story update before plan_review; read-only planning made pre-approval meaningless.
- 2026-05-27T00:00:08.000Z | actor=generator | event=generator_completed | from=revision | to=evaluation | note=Allowed planner state to edit/write only the active STORY.md while keeping implementation files protected; plan_review now pre-approves that current detailed story update before generation.
