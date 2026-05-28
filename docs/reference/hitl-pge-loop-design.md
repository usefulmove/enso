# Human-in-the-loop PGE Loop Design

## Purpose

The HITL PGE loop is a strict pi extension pattern for running a planner -> generator <-> evaluator adversarial development loop with `STORY.md` as the canonical persisted state object.

The design goal is not to make agents autonomous. It is to make agent state transitions explicit, auditable, and human-gated.

## Core Model

```ts
transition(story: StoryState, event: Event) -> Result<StoryState, TransitionError>
```

The transition core is pure:

- no file I/O
- no pi UI calls
- no model calls
- no tool execution
- no hidden session state

The pi extension shell performs effects only after pure validation succeeds:

- load active story
- ask human for approval
- dispatch role prompts
- write rendered story
- block unsafe tool calls

## STORY.md as State Value

`STORY.md` has two layers:

1. YAML frontmatter: canonical machine state.
2. Markdown body: human-readable contract and audit trail.

Required frontmatter fields:

```yaml
id: STORY-001
title: Human-readable title
kind: design-and-implementation-seed
state: plan_review
phase: planner
attempt: 0
human_gate: required
verdict: pending
next_allowed_transitions:
  approve_plan: generation
```

Required sections:

- `## Goal`
- `## Acceptance Criteria`
- `## Context Scope`
- `## Approach & Verification Plan`
- `## Transition Log`

## State Table

| State | Owner | Tool posture | Exit gate | Legal exits |
|-------|-------|--------------|-----------|-------------|
| `intake` | Human / orchestrator | read-only | human | `planning`, `blocked` |
| `planning` | Planner | read-only | automatic after valid plan draft | `plan_review`, `blocked` |
| `plan_review` | Human | review-only | human | `generation`, `planning`, `blocked` |
| `generation` | Generator, then Human gate after output | Write scope only before output; review-only while approval is pending | human approval after generator event | `evaluation`, `revision`, `needs_input`, `blocked` |
| `evaluation` | Evaluator | read + verification only | automatic after verdict submission | `eval_review`, `needs_input`, `blocked` |
| `eval_review` | Human | review-only | human verdict approval or revision request | `accepted`, `revision`, `blocked` |
| `revision` | Planner / Generator, then Human gate after output | scoped mutation before output; review-only while approval is pending | human approval after revision output | `generation`, `evaluation`, `blocked`, `needs_input` |
| `needs_input` | Human | review-only | human | interrupted state |
| `accepted` | Human / orchestrator | verification-only | human | `done`, `revision`, `blocked` |
| `done` | Orchestrator | none | terminal | none |
| `blocked` | Human | review-only | human | chosen non-terminal state |

## Event Model

Events are typed records with an actor. The state machine rejects illegal actor/event/state combinations.

Additional v0 human gate events beyond the seed model:

- `approve_generation` — human approves pending generator output and enters evaluation.
- `approve_revision` — human approves pending revision output and resumes generation or evaluation based on the recorded target.

Important invariants:

- Generator cannot approve, accept, or mark done.
- Evaluator cannot generate implementation, accept, or mark done.
- `done` can only be reached from `accepted`.
- `accept` and `mark_done` require evidence.
- Human-gated states require an explicit human event.
- Generator output requires explicit human `approve_generation` before evaluation; the generator cannot advance itself into evaluation.
- Evaluator output always enters `eval_review`; pass and fail verdicts both require a human `approve_evaluator_verdict` or `request_revision` decision before the loop exits review.
- Revision output requires explicit human `approve_revision` before generation/evaluation resumes.
- Plan review requires explicit pre-approval of the current detailed `STORY.md` plan/story update before entering generation.
- Planner/generator/evaluator may emit `clarifying_question`, which moves the story to `needs_input`; the human `answer_input` event resumes the interrupted state.
- Every successful transition appends a transition-log entry.

## Role Contracts

### Planner

Planner owns story shape: goal, acceptance criteria, context scope, approach, risks, and verification. Planner does not edit implementation files.

Completion event: `planner_completed`.

A planner-completed event stops at `plan_review`. At that gate the human pre-approves the current detailed `STORY.md` update before the orchestrator dispatches generation. The planner cannot directly enter generation.

### Generator

Generator performs scoped implementation. It may mutate only declared `Write:` scope paths while state is `generation` or `revision`.

Completion event: `generator_completed` with implementation summary and evidence. This records pending generated work and opens a human `approve_generation` / `request_revision` gate; it does not let the generator enter evaluation by itself.

### Evaluator

Evaluator is adversarial and read/verification-only. It reviews implementation against the story contract and external evidence. It cannot mutate implementation files.

Completion event: `evaluator_completed` with verdict, critique, and evidence. Both pass and fail verdicts go to `eval_review`; the human approves a passing verdict or requests revision.

## pi Extension Commands

The primary operator interface is intentionally small:

```text
/pge [storyPath]
/pge run [storyPath]
```

Run the orchestrator. It inspects the story state and chooses the next role automatically. The human does not pick planner/generator/evaluator. The human only sees approval, revision, clarification, block, or done prompts when the state machine reaches a human gate.

```text
/pge status [storyPath]
```

Load and validate the active story, show current state and legal next actions without advancing.

```text
/pge gate [storyPath]
```

Force only the current human-gated decision, then continue automatically if that decision unlocks a planner/generator/evaluator state.

```text
/pge prompt <planner|generator|evaluator> [storyPath]
```

Advanced/debugging escape hatch: generate a role-specific prompt and place it in the editor. Normal operation should not require this.

## Tool Enforcement

The extension applies tool posture based on current story state:

- planning: read tools plus edit/write only for the active `STORY.md`; this lets the planner produce the detailed story update that the human pre-approves at `plan_review`
- evaluation: read-only tools plus a narrow bash allowlist (`pwd`, `ls`, and read-only `git status/diff/log/show/branch/worktree list`); arbitrary interpreters, package scripts, shell redirection, and mutating commands are blocked
- generation/revision: read/write tools enabled before role output, but write/edit targets must be inside story `Write:` scope; once `pending_approval` is set the same state becomes a review-only human gate
- review states: review-only, human gate expected

Bash is blocked outside generation/revision unless it exactly matches the narrow read-only allowlist. Do not allow arbitrary `node`, `npx`, package-manager scripts, shell redirection, or mutating commands in planner/evaluator/review phases.

## Parser and Renderer Rules

- Frontmatter is parsed with a small conservative YAML subset: scalar values and nested mappings.
- Machine state is normalized on render.
- `next_allowed_transitions` must exactly match the pure state machine for the current state plus any pending human approval metadata.
- Markdown body is preserved except `## Transition Log`, which is normalized from state.
- Parse-render-parse must preserve semantic machine state.

## v0 Limitations

- The YAML parser intentionally supports only the subset used by enso stories.
- Tool enforcement for bash is conservative and pattern-based, not a sandbox; v0 intentionally sacrifices general shell-based test execution in evaluator mode to prevent direct file mutation through interpreters or package scripts.
- Subagents are not required in v0; role separation is via prompts, event validation, and tool posture.
- The extension targets interactive pi for human gates. Non-interactive modes fail closed for approval flows.

## Verification

Run pure core tests:

```bash
node --experimental-strip-types .pi/extensions/hitl-pge-loop/test.ts
```

Load extension locally:

```bash
pi --extension .pi/extensions/hitl-pge-loop/index.ts
```

Then inspect active story:

```text
/pge status docs/stories/STORY-001.md
```
