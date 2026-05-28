---
schema: enso.story/v1
id: STORY-013
title: OKR-sharpened story contract
state: evaluating
active_role: evaluator
iteration: 1
max_iterations: 3
created_at: 2026-05-28T00:00:00Z
updated_at: 2026-05-28T00:10:00Z
priority: medium

scope:
  write:
    - docs/reference/STORY.md
    - AGENTS.md
    - skills/convert-request-to-story/SKILL.md
    - docs/stories/STORY-013-okr-sharpened-story-contract.md
  read:
    - docs/core/PRD.md
    - docs/core/ARCHITECTURE.md
    - /home/dedmonds/repos/socrates/org/OKRs.md
    - docs/stories/STORY-012-upgrade-agents-to-story-v1.md
  exclude:
    - .git/
    - .pi/extensions/
    - implementation code

acceptance_criteria:
  - id: AC1
    text: docs/reference/STORY.md defines the Acceptance Criteria section as measurable, binary, outcome-framed key results and documents the objective -> key-result -> proof ladder over the existing Goal / Acceptance Criteria / Verification Contract sections.
  - id: AC2
    text: STORY.md states that baselines belong in the Goal as motivation, that key results are binary threshold conditions, and that grading and stretch structures are excluded.
  - id: AC3
    text: AGENTS.md protocol version reads 0.10.0, and its Planning Phase and §9 template guidance instruct the planner to write outcome-framed key-result acceptance criteria, with an explicit escape hatch allowing trivial/mechanical stories to state the activity directly.
  - id: AC4
    text: The enso.story/v1 schema is unchanged - no frontmatter field, required section, or legal state is added, removed, or renamed.
  - id: AC5
    text: skills/convert-request-to-story/SKILL.md teaches outcome-framed, binary acceptance criteria consistent with the ladder.
  - id: AC6
    text: The diff is limited to the four files in Write scope.

verification:
  - id: V1
    command: grep -ni "key result\|outcome\|ladder\|threshold" docs/reference/STORY.md AGENTS.md
    pass_when: Ladder and key-result/outcome terms are present in both STORY.md and AGENTS.md.
  - id: V2
    command: grep -n "schema: enso.story/v1" docs/reference/STORY.md && grep -n "version: 0.10.0" AGENTS.md
    pass_when: Story schema id stays enso.story/v1 and AGENTS.md protocol version reads 0.10.0.
  - id: V3
    command: git diff --name-only && git status --short
    pass_when: Changed/untracked paths are limited to the four Write-scope files.
---

# STORY-013 OKR-sharpened story contract

## Goal

Sharpen the enso story contract using OKR discipline so that a self-contained story ("egg") defines its own success as measurable outcomes, not a list of edits. Today the contract's middle rung — `## Acceptance Criteria` — straddles goal and verification and routinely drifts into activity ("upgrade X", "add Y"), which says what files get touched but not what becomes true in the world. After this work, the contract reads as a clear three-rung ladder: Objective (Goal) -> Key Results (Acceptance Criteria) -> Proof (Verification), with no schema change.

Baseline as motivation: the existing v1 spec and template treat acceptance criteria as binary checkboxes with no outcome discipline, and the planning guidance never tells the planner to frame them as measurable outcomes.

## Non-Goals

- No change to the `enso.story/v1` schema: no new frontmatter fields, sections, or states.
- No PRD alignment spine, story->goal pointers, or required cross-references between stories and the PRD. Eggs stay sovereign.
- No graded (0.0-1.0) key results and no stretch / required-vs-optional KR structure.
- No migration of existing stories.
- No implementation/runtime/extension changes.

## Constraints

- Keep the contract fully backward-compatible: existing v1 stories must remain valid.
- Keep AGENTS.md portable; do not depend on repo-local assets.
- Honor enso §2 instruction economy: the new discipline is a default with an explicit escape hatch, not a hard rule that taxes trivial stories.
- Match existing document style in STORY.md and AGENTS.md.

## Acceptance Criteria

- [x] AC1 STORY.md defines Acceptance Criteria as measurable, binary, outcome-framed key results and documents the objective -> key-result -> proof ladder.
- [x] AC2 STORY.md states baselines belong in the Goal, key results are binary thresholds, and grading/stretch are excluded.
- [x] AC3 AGENTS.md version reads 0.10.0 and its Planning Phase + §9 guidance direct the planner to write outcome-framed key results, with a trivial-story escape hatch.
- [x] AC4 The `enso.story/v1` schema is unchanged (no field/section/state added, removed, or renamed).
- [x] AC5 convert-request-to-story teaches outcome-framed, binary acceptance criteria consistent with the ladder.
- [x] AC6 Diff is limited to the four Write-scope files.

## Verification Contract

- [x] V1 `grep -ni "key result\|outcome\|ladder\|threshold" docs/reference/STORY.md AGENTS.md`
- [x] V2 `grep -n "schema: enso.story/v1" docs/reference/STORY.md && grep -n "version: 0.10.0" AGENTS.md`
- [x] V3 `git diff --name-only && git status --short`

## Context Scope

**Write:**
- `docs/reference/STORY.md`
- `AGENTS.md`
- `skills/convert-request-to-story/SKILL.md`
- `docs/stories/STORY-013-okr-sharpened-story-contract.md`

**Read:**
- `docs/core/PRD.md`
- `docs/core/ARCHITECTURE.md`
- `/home/dedmonds/repos/socrates/org/OKRs.md`
- `docs/stories/STORY-012-upgrade-agents-to-story-v1.md`

**Exclude:**
- `.git/`
- `.pi/extensions/`
- implementation code

## Planner Output

### Plan v1
**Date:** 2026-05-28 00:00

#### Summary
Land the OKR discipline as a contract clarification, not a schema bump. The story is a self-contained egg; OKR applies inside it. The deliverable is a sharper definition of three rungs that already exist plus the planner discipline to fill them. AGENTS.md protocol version moves to 0.10.0 to signal the added discipline; the `enso.story/v1` schema id stays put.

#### Steps
1. STORY.md: reframe the `## Acceptance Criteria` definition as key results (measurable, binary, outcome-framed); add a short ladder explanation (Objective=Goal, Key Results=Acceptance Criteria, Proof=Verification); state baselines live in the Goal; state thresholds carry magnitude; exclude grading and stretch. -> verify: V1, and manual read confirms no schema fields/sections/states changed.
2. AGENTS.md: bump frontmatter `version` to 0.10.0; update Planning Phase and §9 template guidance so the planner writes outcome-framed key-result acceptance criteria, with an explicit escape hatch for trivial/mechanical stories. -> verify: V2.
3. convert-request-to-story: update the acceptance-criteria guidance to teach outcome-framed, binary criteria consistent with the ladder. -> verify: manual read.
4. Run V1-V3 and update this story's checklists and evidence. -> verify: V3 scope-clean.

#### Assumptions
- Discipline-only change; no field/section/state edits to the schema.
- Existing stories are not migrated.
- 0.10.0 is the agreed protocol version bump.

#### Risks
- Scope creep into a schema redesign. Mitigation: AC4 + V2 lock the schema id; manual read confirms no structural edits.
- Over-specification that taxes trivial stories. Mitigation: ship the rule as a default with an explicit escape hatch (Constraint + AC3).
- AGENTS.md and STORY.md drifting out of sync on the ladder wording. Mitigation: one canonical phrasing reused in both.

#### Open Questions
- None; design was settled in the planning conversation.

## Generator Iterations

### Iteration 1
**Date:** 2026-05-28 00:10

#### Summary
Landed the OKR discipline as a contract clarification with no schema change. Added §7.1 "The contract ladder" to `docs/reference/STORY.md` defining Objective (Goal) -> Key Results (Acceptance Criteria) -> Proof (Verification), with binary/threshold, outcome-not-activity (plus escape hatch), and no-stretch rules. Bumped `AGENTS.md` protocol version to 0.10.0 and added outcome-framed key-result guidance to the Planning Phase and the §9 template. Updated convert-request-to-story to teach outcome-framed, binary acceptance criteria and added an activity-framed anti-pattern row.

#### Files Changed
- `docs/reference/STORY.md`
- `AGENTS.md`
- `skills/convert-request-to-story/SKILL.md`

#### Commands Run
- `grep -ni "key result\|outcome\|ladder\|threshold" docs/reference/STORY.md AGENTS.md`
- `grep -n "schema: enso.story/v1" docs/reference/STORY.md && grep -n "version: 0.10.0" AGENTS.md`
- `git diff --name-only && git status --short`

#### Assumptions
- Discipline-only change; the `enso.story/v1` schema (fields, sections, states) is untouched.

#### Disputes
- None.

## Evaluator Results

## Human Decisions

### Decision 1
**Date:** 2026-05-28 00:05
**At state:** plan_review
**Decision:** approve_plan
**Rationale:** User approved the plan after settling the design (no schema bump, AGENTS.md -> 0.10.0).
**Binding:** true

## Evidence

### Verification Runs
| Verification ID | Command | Result | Exit Code | Output Ref |
|---|---|---|---|---|
| V1 | `grep -ni "key result\|outcome\|ladder\|threshold" docs/reference/STORY.md AGENTS.md` | PASS | 0 | Terms present in both files (STORY.md §7.1; AGENTS.md L224, L375) |
| V2 | `grep -n "schema: enso.story/v1" docs/reference/STORY.md && grep -n "version: 0.10.0" AGENTS.md` | PASS | 0 | schema id unchanged; version 0.10.0 set |
| V3 | `git diff --name-only && git status --short` | PASS | 0 | Changes limited to the four Write-scope files |

### Changed Files
- `docs/reference/STORY.md`
- `AGENTS.md`
- `skills/convert-request-to-story/SKILL.md`
- `docs/stories/STORY-013-okr-sharpened-story-contract.md`

## Transition Log
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|
| 2026-05-28T00:00:00Z | orchestrator | begin_planning | seeded | planning | Planning settled in conversation. |
| 2026-05-28T00:00:01Z | planner | submit_plan | planning | plan_review | Plan v1 submitted; awaiting human approval. |
| 2026-05-28T00:05:00Z | human | approve_plan | plan_review | ready | User approved the plan. |
| 2026-05-28T00:05:01Z | orchestrator | start_generation | ready | generating | Begin scoped edits. |
| 2026-05-28T00:10:00Z | generator | submit_generation | generating | evaluating | Landed contract ladder, version bump, and skill update; V1-V3 pass. |

## Reflection
- [ ] Encountered recurring friction -> create skill?
- [ ] Discovered new pattern -> update architecture doc?
- [ ] Lesson learned -> add to LESSONS.md?
- [ ] No new insights -> proceed

**Do not begin generation until the plan is approved and state is `ready`.**
