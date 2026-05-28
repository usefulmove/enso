---
schema: enso.story/v1
id: STORY-012
title: Upgrade AGENTS.md to enso.story/v1
state: evaluating
active_role: evaluator
iteration: 1
max_iterations: 3
created_at: 2026-05-27T00:00:00Z
updated_at: 2026-05-27T00:00:00Z
priority: high

scope:
  write:
    - AGENTS.md
    - docs/core/ARCHITECTURE.md
    - docs/reference/STORY.md
    - docs/stories/STORY-012-upgrade-agents-to-story-v1.md
  read:
    - README.md
    - docs/reference/hitl-pge-loop-design.md
    - docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md
  exclude:
    - .git/
    - .pi/extensions/
    - implementation code

acceptance_criteria:
  - id: AC1
    text: AGENTS.md identifies enso.story/v1 as the canonical story contract and distinguishes STORY-000 from live STORY-001+ instances.
  - id: AC2
    text: AGENTS.md Planning Phase and Document Lifecycle use story states, role sections, transition logs, and human gates from the v1 spec.
  - id: AC3
    text: AGENTS.md Story template is upgraded from the legacy lightweight template to a compact enso.story/v1 template.
  - id: AC4
    text: Architecture/reference docs reflect that the harness protocol now uses enso.story/v1 as the canonical story substrate.
  - id: AC5
    text: Bootstrapping instructions fetch the canonical STORY.md spec from the enso repo with curl.
  - id: AC6
    text: Diff stays scoped to protocol/documentation changes only.

verification:
  - id: V1
    command: grep -n "enso.story/v1\|STORY-000\|Planner Output\|Generator Iterations\|Evaluator Results\|Human Decisions\|Transition Log" AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md
    pass_when: Required story-v1 terms appear in AGENTS.md and supporting docs.
  - id: V2
    command: git diff -- AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md && git status --short
    pass_when: Diff/status is limited to agreed documentation/protocol files and active story files.
---

# STORY-012 Upgrade AGENTS.md to enso.story/v1

## Goal

Upgrade the portable harness protocol in `AGENTS.md` so live stories use the `enso.story/v1` state-object contract instead of the legacy lightweight story template.

## Non-Goals

- Do not modify pi extension implementation code.
- Do not migrate old completed story files.
- Do not make the planner-generator-evaluator loop mandatory for every runtime; present it as the canonical strict loop for story-v1 execution.

## Constraints

- Keep `AGENTS.md` portable: do not depend on repo-local assets like diagrams.
- Keep the template compact enough for a seed protocol while preserving required v1 fields and sections.
- Preserve the existing behavioral principles and git boundaries.

## Acceptance Criteria

- [x] AC1 AGENTS.md identifies `enso.story/v1` as the canonical story contract and distinguishes `STORY-000` from live `STORY-001+` instances.
- [x] AC2 AGENTS.md Planning Phase and Document Lifecycle use story states, role sections, transition logs, and human gates from the v1 spec.
- [x] AC3 AGENTS.md Story template is upgraded from the legacy lightweight template to a compact `enso.story/v1` template.
- [x] AC4 Architecture/reference docs reflect that the harness protocol now uses `enso.story/v1` as the canonical story substrate.
- [x] AC5 Bootstrapping instructions fetch the canonical `STORY.md` spec from the enso repo with `curl`.
- [x] AC6 Diff stays scoped to protocol/documentation changes only.

## Verification Contract

- [x] V1 `grep -n "enso.story/v1\|STORY-000\|Planner Output\|Generator Iterations\|Evaluator Results\|Human Decisions\|Transition Log" AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md`
- [x] V2 `git diff -- AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md && git status --short`

## Context Scope

**Write:**
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/reference/STORY.md`
- `docs/stories/STORY-012-upgrade-agents-to-story-v1.md`

**Read:**
- `README.md`
- `docs/reference/hitl-pge-loop-design.md`
- `docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md`

**Exclude:**
- `.git/`
- `.pi/extensions/`
- implementation code

## Planner Output

### Plan v1
**Date:** 2026-05-27 00:00

#### Summary
Upgrade the harness seed protocol so the story seam uses `enso.story/v1` directly. Keep the changes textual and portable: no diagram embeds, no runtime-specific extension behavior, and no implementation changes.

#### Steps
1. Update AGENTS frontmatter/docs index/seams/workflow to name `enso.story/v1`, `STORY-000`, live `STORY-001+` instances, and the role loop.
2. Update AGENTS bootstrapping so a new harness creates `docs/reference/` and fetches the canonical story spec with `curl -fsSL -o docs/reference/STORY.md https://raw.githubusercontent.com/usefulmove/enso/main/docs/reference/STORY.md`.
3. Update AGENTS planning/document lifecycle rules so stories move through `seeded -> planning -> plan_review -> ready -> generating -> evaluating -> evaluation_review -> accepted -> done` with human gates.
4. Replace the legacy story template in AGENTS §9 with a compact v1 template containing required frontmatter and required sections.
5. Add small architecture/reference notes that AGENTS now treats `enso.story/v1` as canonical.
6. Run grep/diff verification and update this story's checklists/evidence.

#### Assumptions
- `docs/reference/STORY.md` remains the full spec; AGENTS carries the compact bootstrap template.
- Existing lightweight stories do not need immediate migration.

#### Risks
- AGENTS could become too verbose if the full spec is copied in; mitigate with a compact template and pointer to `docs/reference/STORY.md`.
- Overstating PGE as the only runtime model would reduce enso's portability; keep runtime-agnostic wording.

#### Open Questions
- None; user approved upgrading the harness protocol.

## Generator Iterations

### Iteration 1
**Date:** 2026-05-27 00:00

#### Summary
Upgraded `AGENTS.md` to protocol version 0.9.0 using `enso.story/v1` as the canonical story contract. Bootstrapping now fetches `docs/reference/STORY.md` from the enso repo with `curl -fsSL` if absent. The story template now includes v1 frontmatter, required role sections, evidence, and transition log. Architecture and story spec docs now note that `enso.story/v1` is canonical for the harness protocol.

#### Files Changed
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/reference/STORY.md`
- `docs/stories/STORY-012-upgrade-agents-to-story-v1.md`

#### Commands Run
- `grep -n "enso.story/v1\\|STORY-000\\|Planner Output\\|Generator Iterations\\|Evaluator Results\\|Human Decisions\\|Transition Log" AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md`
- `grep -n "curl -fsSL -o docs/reference/STORY.md https://raw.githubusercontent.com/usefulmove/enso/main/docs/reference/STORY.md" AGENTS.md`
- `git diff -- AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md && git status --short`

#### Assumptions
- Existing historical stories are not migrated in this story.
- `AGENTS.md` should remain portable and therefore does not embed the PGE diagram.

#### Disputes
- None.

## Evaluator Results

## Human Decisions

### Decision 1
**Date:** 2026-05-27 00:00
**At state:** plan_review
**Decision:** approve_plan
**Rationale:** User explicitly approved upgrading the harness protocol to the new story spec.
**Binding:** true

## Evidence

### Verification Runs
| Verification ID | Command | Result | Exit Code | Output Ref |
|---|---|---|---|---|
| V1 | `grep -n "enso.story/v1\\|STORY-000\\|Planner Output\\|Generator Iterations\\|Evaluator Results\\|Human Decisions\\|Transition Log" AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md` | PASS | 0 | Command output in session |
| V2 | `git diff -- AGENTS.md docs/core/ARCHITECTURE.md docs/reference/STORY.md && git status --short` | PASS | 0 | Command output in session; untracked story visible via `git status --short` |

### Changed Files
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/reference/STORY.md`
- `docs/stories/STORY-012-upgrade-agents-to-story-v1.md`

## Transition Log
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|
| 2026-05-27T00:00:00Z | human | approve_plan | plan_review | ready | User approved harness protocol upgrade. |
| 2026-05-27T00:00:01Z | generator | submit_generation | ready | evaluating | Upgraded AGENTS.md and supporting docs to story-v1 protocol. |
