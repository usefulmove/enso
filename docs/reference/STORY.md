# STORY-000 — `enso.story/v1`

`STORY-000` is the specification for enso story files. It defines the `enso.story/v1` contract that live execution stories must follow. The portable harness protocol in `AGENTS.md` uses this spec as its canonical story template.

A live story instance (`STORY-001+`) is the canonical persisted state object for one unit of work. In a planner-generator-evaluator loop, that story instance is the state value passed across role transitions.

Each live story contains:
1. the **contract**
2. the **current state**
3. the **role outputs**
4. the **verification evidence**
5. the **transition history**

The primitive is:

```text
state_next = transition(state_current, event)
```

## 1. Rules

- The story file is the source of truth.
- Agents coordinate through the story, not hidden chat state.
- There is exactly one authoritative runtime `state`.
- After plan approval, the contract is frozen unless the human explicitly reopens it.
- Role outputs are append-only.
- Acceptance requires structured verification evidence.
- Approval-required transitions fail closed when no interactive UI is available.

---

## 2. Required frontmatter

```yaml
schema: enso.story/v1
id: STORY-001
title: Example story
state: seeded
active_role: planner
iteration: 0
max_iterations: 3
created_at: 2026-05-27T00:00:00Z
updated_at: 2026-05-27T00:00:00Z
priority: high

scope:
  write:
    - path/to/file
  read:
    - docs/core/ARCHITECTURE.md
  exclude:
    - .git/

acceptance_criteria:
  - id: AC1
    text: Example criterion

verification:
  - id: V1
    command: npm test
    pass_when: exit_code == 0
```

### Required fields

- `schema`
- `id`
- `title`
- `state`
- `active_role`
- `iteration`
- `max_iterations`
- `created_at`
- `updated_at`
- `scope.write`
- `scope.read`
- `scope.exclude`
- `acceptance_criteria`
- `verification`

### Optional fields

```yaml
kind: execution
tags: []
parent: null
depends_on: []
dependent_stories: []  # stories blocked on this one
pending_gate: null
escalation_reason: null
blocked_reason: null
current_contract_version: 1
```

- `parent` — Parent story ID for sub-task delegation. A parent may spawn child stories; the orchestrator gates parent `ready` until all `depends_on` children reach `done`.
- `depends_on` — Story IDs that must reach `done` before this story may leave `seeded`.
- `dependent_stories` — Story IDs blocked on this one. The orchestrator updates these when this story transitions to `done`.

---

## 3. Legal states

```text
seeded
planning
plan_review
ready
generating
evaluating
evaluation_review
escalated
accepted
done
blocked
```

| State | Meaning |
|---|---|
| `seeded` | Story exists, no plan yet |
| `planning` | Planner is working |
| `plan_review` | Human reviews the plan |
| `ready` | Contract approved, ready to execute |
| `generating` | Generator is implementing |
| `evaluating` | Evaluator is verifying |
| `evaluation_review` | Human reviews evaluator verdict |
| `escalated` | Loop paused for human ruling |
| `accepted` | Human accepts the result |
| `done` | Complete |
| `blocked` | Cannot proceed until human unblocks |

---

## 4. Legal roles

```text
planner
generator
evaluator
human
orchestrator
none
```

| Role | Authority |
|---|---|
| Planner | May append to `## Planner Output` |
| Generator | May append to `## Generator Iterations` and modify files in `scope.write` |
| Evaluator | May append to `## Evaluator Results` and `## Evidence` |
| Human | May append to `## Human Decisions` and reopen the contract |
| Orchestrator | May update frontmatter runtime fields and `## Transition Log` |

Hard prohibitions:
- Planner MUST NOT implement.
- Generator MUST NOT modify acceptance criteria or verification.
- Evaluator MUST NOT edit implementation files.
- No agent may self-approve.
- No transition may skip a required human gate.

---

## 5. Required transitions

| From | Event | To | Actor |
|---|---|---|---|
| `seeded` | `begin_planning` | `planning` | orchestrator |
| `planning` | `submit_plan` | `plan_review` | planner |
| `plan_review` | `approve_plan` | `ready` | human |
| `plan_review` | `reject_plan` | `planning` | human |
| `plan_review` | `block` | `blocked` | human |
| `ready` | `start_generation` | `generating` | orchestrator |
| `generating` | `submit_generation` | `evaluating` | generator |
| `evaluating` | `submit_evaluation` | `evaluation_review` | evaluator |
| `evaluation_review` | `accept_result` | `accepted` | human |
| `evaluation_review` | `request_revision` | `generating` | human |
| `evaluation_review` | `escalate` | `escalated` | human |
| `evaluation_review` | `block` | `blocked` | human |
| `escalated` | `ruling_to_planning` | `planning` | human |
| `escalated` | `ruling_to_ready` | `ready` | human |
| `escalated` | `ruling_to_generating` | `generating` | human |
| `escalated` | `block` | `blocked` | human |
| `accepted` | `mark_done` | `done` | human |
| `accepted` | `reopen_for_revision` | `generating` | human |
| `blocked` | `unblock_to_planning` | `planning` | human |
| `blocked` | `unblock_to_ready` | `ready` | human |
| `blocked` | `unblock_to_generating` | `generating` | human |
| `blocked` | `unblock_to_done` | `done` | human |

Invalid transitions MUST hard-fail, including:
- generator → `accepted`
- evaluator → `generating`
- any actor progressing past a gate state without human decision
- any state change without a transition log row

---

## 6. Contract freeze

When the story enters `ready`, these are frozen:

- `## Goal`
- `## Non-Goals`
- `## Constraints`
- `acceptance_criteria`
- `verification`
- `scope`

They may change only if:
1. the human records a reopen decision
2. the change is logged
3. `current_contract_version` increments

---

## 7. Required sections

A conforming story MUST contain these sections:

```md
# {ID} {Title}

## Goal
## Non-Goals
## Constraints
## Acceptance Criteria
## Verification Contract
## Context Scope
## Planner Output
## Generator Iterations
## Evaluator Results
## Human Decisions
## Evidence
## Transition Log
```

---

## 7.1 The contract ladder

The contract sections form one outcome ladder. Each rung has a distinct job; they are not restatements of each other.

| Rung | Section | Job |
|---|---|---|
| Objective | `## Goal` | The qualitative outcome — what is true in the world after the story, and why it matters. Baselines (e.g. "p95 is currently ~800ms") live here as motivation. |
| Key Results | `## Acceptance Criteria` | Measurable, binary, outcome-framed statements that, together, prove the objective is met. |
| Proof | `## Verification Contract` | The executable evidence for each key result. A `pass_when` is the threshold made runnable. |

**Key results are binary.** Each acceptance criterion is true or false — no grading (0.0-1.0), no partial credit. Magnitude is carried by a threshold, not a score: write `p95 <= 200ms`, not "improve p95." A threshold is both measurable and binary.

**Outcome, not activity.** State what becomes true, not which files change: prefer "malformed input is rejected with HTTP 400" over "add validation to the handler." Escape hatch: trivial or mechanical stories (e.g. a rote rename) may state the activity directly — enso §2 instruction economy beats ceremony.

**No stretch.** A story is sized so its full success is its acceptance. There are no required-vs-optional or "nice-to-have" key results. Optional work is a separate story. An egg hatches or it does not.

---

## 8. Entry formats

### Planner entry

```md
### Plan v{N}
**Date:** YYYY-MM-DD HH:MM

#### Summary
...

#### Steps
1. ...

#### Assumptions
- ...

#### Risks
- ...

#### Open Questions
- ...
```

### Generator entry

```md
### Iteration {N}
**Date:** YYYY-MM-DD HH:MM

#### Summary
...

#### Files Changed
- path/to/file

#### Commands Run
- `npm test`

#### Assumptions
- ...

#### Disputes
- ...
```

### Evaluator entry

```md
### Evaluation {N}
**Date:** YYYY-MM-DD HH:MM
**Status:** ACCEPTED | REJECTED | ESCALATED

#### Tool Findings
| Verification ID | Command | Result | Output Ref |
|---|---|---|---|

#### Convention Findings
| File | Line | Convention Doc | Section | Violation |
|---|---|---|---|---|

#### Design Findings
| Concern | Story Ref | Generator Approach | Quality Concern |
|---|---|---|---|

#### Actionable Feedback
- [ ] ...
```

### Human decision entry

```md
### Decision {N}
**Date:** YYYY-MM-DD HH:MM
**At state:** plan_review | evaluation_review | escalated | accepted | blocked
**Decision:** approve_plan | reject_plan | accept_result | request_revision | escalate | block | reopen_for_revision | unblock_to_*
**Rationale:** ...
**Binding:** true | false
```

---

## 9. Evidence requirements

`## Evidence` MUST support:

### Verification Runs

```md
| Verification ID | Command | Result | Exit Code | Output Ref |
|---|---|---|---|---|
```

### Changed Files

```md
- path/to/file
```

### Conventions Loaded

```md
- docs/reference/some-convention.md#section
```

Citation rule: every objective convention rejection MUST cite doc path, section, file, and line.

---

## 10. Transition log

Every state change MUST append one row.

```md
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|
```

Rules:
- `From` must match prior state.
- `To` must match new state.
- actor must be authorized.
- rows must be chronological.

---

## 10.1 Sub-story delegation

A story may delegate work to child stories. The orchestrator enforces these rules:

- A story enters `ready` only when `depends_on` is empty or every listed story has `state: done`.
- A story with `parent` set MUST NOT modify `parent`'s `scope.write` paths; the parent contract may read child `## Evidence` sections for its own verification.
- When a child reaches `done`, the orchestrator updates any story with that child in `depends_on`, removing it or re-checking readiness.
- A parent story's generator may append a `## Child Stories` section listing spawned IDs; this is advisory, not authoritative.

---

## 11. Validation rules

A validator MUST enforce:

### Structure
- frontmatter exists
- all required fields exist
- all required sections exist
- `schema == enso.story/v1`

### State
- `state` is legal
- `active_role` is legal
- `iteration >= 0`
- `max_iterations >= 1`

### Contract
- acceptance criteria are non-empty
- verification list is non-empty
- IDs are unique
- `scope.write` is non-empty before `generating`

### Freeze
If state is `ready` or later, frozen contract fields must not change without a human reopen decision.

### Authority
Each role may write only its owned sections.

### Acceptance
If evaluator status is `ACCEPTED`:
- every verification item must have a result
- every required result must pass
- no required verification may be `NOT RUN`

### Iteration
- generator/evaluator iteration numbers must increase monotonically
- if `iteration >= max_iterations`, next non-terminal path must be `escalated` or `blocked`

### HITL
If UI is unavailable at an approval-required state, the orchestrator MUST fail closed.

---

## 12. Canonical template

```md
---
schema: enso.story/v1
id: STORY-001
title: Example story
state: seeded
active_role: planner
iteration: 0
max_iterations: 3
created_at: 2026-05-27T00:00:00Z
updated_at: 2026-05-27T00:00:00Z
priority: high

scope:
  write:
    - path/to/file
  read:
    - docs/core/ARCHITECTURE.md
  exclude:
    - .git/

acceptance_criteria:
  - id: AC1
    text: Example criterion

verification:
  - id: V1
    command: npm test
    pass_when: exit_code == 0
---

# STORY-001 Example story

## Goal
...

## Non-Goals
...

## Constraints
...

## Acceptance Criteria
- [ ] AC1 Example criterion

## Verification Contract
- [ ] V1 `npm test`

## Context Scope
**Write:**
- path/to/file

**Read:**
- docs/core/ARCHITECTURE.md

**Exclude:**
- .git/

## Planner Output

## Generator Iterations

## Evaluator Results

## Human Decisions

## Evidence

## Transition Log
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|
```

---

## 13. Reserved ID

`STORY-000` is reserved for this specification and MUST NOT be used as an execution story. Execution stories use concrete IDs such as `STORY-001`, conform to this schema, and carry the live state for one unit of work.
