---
schema: enso.story/v1
id: STORY-014
title: Make AGENTS runtime-agnostic
state: done
active_role: human
iteration: 1
max_iterations: 3
created_at: 2026-06-08T01:11:47Z
updated_at: 2026-06-08T01:21:02Z
priority: medium

scope:
  write:
    - AGENTS.md
    - docs/stories/STORY-014-runtime-agnostic-agents.md
  read:
    - /home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/skills.md
  exclude:
    - .git/

acceptance_criteria:
  - id: AC1
    text: AGENTS.md states that enso is runtime-agnostic and does not depend on OpenCode specifically.
  - id: AC2
    text: Bootstrapping separates core enso directory setup from runtime-specific skill discovery wiring.
  - id: AC3
    text: Skills documentation covers OpenCode, Claude Code, and pi discovery paths without presenting OpenCode as the assumed runtime.
  - id: AC4
    text: SKILL.md frontmatter guidance treats compatibility as optional/freeform and preserves required name/description rules.

verification:
  - id: V1
    command: grep -nE "OpenCode|Claude Code|\\bpi\\b|opencode|claude|\\.opencode|\\.claude|\\.pi" AGENTS.md
    pass_when: only labeled runtime-specific references remain
  - id: V2
    command: grep -nE "compatibility:|Runtime discovery|runtime-agnostic" AGENTS.md
    pass_when: updated runtime-agnostic and compatibility guidance is present
---

# STORY-014 Make AGENTS runtime-agnostic

## Goal

Correct AGENTS.md so the enso harness protocol does not assume an OpenCode runtime, while still giving concrete runtime wiring for OpenCode, Claude Code, and pi.

## Non-Goals

- Do not update README.md, AOS.md, or other docs.
- Do not change enso story protocol semantics.
- Do not add or remove skill files.

## Constraints

- Keep the edit surgical and limited to runtime-specific wording.
- Do not write unverified runtime discovery paths.

## Acceptance Criteria
- [x] AC1 AGENTS.md states that enso is runtime-agnostic and does not depend on OpenCode specifically.
- [x] AC2 Bootstrapping separates core enso directory setup from runtime-specific skill discovery wiring.
- [x] AC3 Skills documentation covers OpenCode, Claude Code, and pi discovery paths without presenting OpenCode as the assumed runtime.
- [x] AC4 SKILL.md frontmatter guidance treats compatibility as optional/freeform and preserves required name/description rules.

## Verification Contract
- [x] V1 `grep -nE "OpenCode|Claude Code|\bpi\b|opencode|claude|\.opencode|\.claude|\.pi" AGENTS.md`
- [x] V2 `grep -nE "compatibility:|Runtime discovery|runtime-agnostic" AGENTS.md`

## Context Scope
**Write:**
- AGENTS.md
- docs/stories/STORY-014-runtime-agnostic-agents.md

**Read:**
- /home/dedmonds/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/skills.md

**Exclude:**
- .git/

## Planner Output

### Plan v1
**Date:** 2026-06-08 01:11

#### Summary

Make AGENTS.md runtime-agnostic by separating the enso protocol from runtime wiring and documenting OpenCode, Claude Code, and pi as supported discovery configurations.

#### Steps
1. Add a sentence in Purpose that enso itself is runtime-agnostic.
2. Split §3 bootstrap into core structure and runtime-specific skill discovery wiring.
3. Replace §7's OpenCode-only discovery/bootstrap/priority language with runtime discovery guidance for OpenCode, Claude Code, and pi.
4. Soften frontmatter guidance so `compatibility` is optional/freeform while `name` and `description` remain required.
5. Run grep-based verification and record results.

#### Assumptions
- The user's "Go for it" approves the plan discussed in chat.
- AGENTS.md is the only implementation target.

#### Risks
- Runtime documentation can change; keep wording explicit about "supported/currently used" runtimes rather than universal claims.

#### Open Questions
- None.

## Generator Iterations

### Iteration 1
**Date:** 2026-06-08 01:14

Updated AGENTS.md to make runtime agnosticism explicit, split core bootstrap from runtime wiring, and replace the OpenCode-only skill discovery guidance with OpenCode, Claude Code, pi, and generic runtime guidance.

### Pre-Commit Review

**Status:** PASS

- **Simple Changes:** YES — AGENTS.md diff is limited to runtime-agnostic protocol wording, bootstrap wiring, and skill discovery/frontmatter guidance.
- **Simple Code:** YES — no abstractions, features, or adjacent refactors were added.
- **Verifiable Completion:** YES — all acceptance criteria are checked and verification output is recorded.
- **Action:** Ready for evaluator review.

## Evaluator Results

### Review v1
**Date:** 2026-06-08 01:21

**Verdict:** READY WITH NOTES

AGENTS.md satisfies the requested runtime-agnostic correction. The change is focused, preserves concrete runtime wiring for OpenCode, Claude Code, and pi, and passes the recorded verification checks. Non-blocking notes were documentation hygiene only and did not require changes before closure.

## Human Decisions
- 2026-06-08 01:11 User selected Option A and asked to cover OpenCode, Claude Code, and pi.
- 2026-06-08 01:11 User approved generation: "Go for it."
- 2026-06-08 01:21 User requested story closure.

## Evidence

### Verification Runs
| Verification ID | Command | Result | Exit Code | Output Ref |
|---|---|---|---|---|
| V1 | `grep -nE 'OpenCode|Claude Code|\\bpi\\b|opencode|claude|\\.opencode|\\.claude|\\.pi' AGENTS.md` | PASS | 0 | Runtime-specific references are labeled examples, runtime table entries, compatibility examples, or pre-existing references. |
| V2 | `grep -nE 'compatibility:|Runtime discovery|runtime-agnostic' AGENTS.md` | PASS | 0 | Runtime-agnostic statement, Runtime discovery heading, and optional/freeform compatibility example present. |

### Changed Files
- AGENTS.md
- docs/stories/STORY-014-runtime-agnostic-agents.md

## Transition Log
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|
| 2026-06-08T01:11:47Z | Assistant | story_created | none | ready | Created from approved chat plan. |
| 2026-06-08T01:14:08Z | Assistant | generation_complete | ready | review | AGENTS.md updated and verification passed. |
| 2026-06-08T01:21:02Z | Assistant | story_closed | review | done | Evaluator verdict recorded; user requested closure. |

## Reflection
- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [x] No new insights → proceed
