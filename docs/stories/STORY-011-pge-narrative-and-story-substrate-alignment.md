# STORY-011 PGE Narrative and Story Substrate Alignment

## Goal

Make the enso docs tell one coherent story from concept to execution: enso as an orchestration surface, the planner -> generator <-> evaluator loop as a concrete executable orchestration pattern, and live story files as the persisted execution substrates that carry state across role transitions.

Important distinction: `STORY-000` is the story protocol/specification, not a live execution story. Live stories (`STORY-001+`) conform to that spec and serve as the execution substrate for a unit of work.

## Acceptance Criteria

- [x] `README.md` explicitly explains the planner -> generator <-> evaluator loop as a concrete execution pattern for enso.
- [x] `README.md` clearly distinguishes `STORY-000` as the story spec from `STORY-001+` as live execution stories.
- [x] `README.md` links the public narrative to `docs/reference/STORY.md` and `docs/reference/hitl-pge-loop-design.md`.
- [x] `docs/core/ARCHITECTURE.md` bridges the abstract fold model (`context_new = story(context_old)`) to the concrete PGE state-machine loop.
- [x] `docs/reference/STORY.md` explicitly states near the top that `STORY-000` is the specification and live stories conform to it.
- [x] `docs/reference/hitl-pge-loop-design.md` uses terminology consistent with the spec/instance distinction.
- [x] Diff stays surgical: only documentation changes in the agreed files.

## Context Scope

**Write:**
- `README.md`
- `docs/core/ARCHITECTURE.md`
- `docs/reference/STORY.md`
- `docs/reference/hitl-pge-loop-design.md`
- `docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md`

**Read:**
- `AGENTS.md`
- `AOS.md`
- `docs/reference/enso.md`
- `docs/reference/completed/STORY-010-readme-canonical-stack.md`
- `docs/reference/completed/STORY-010-planner-generator-evaluator-loop-diagram.md`
- `assets/planner-generator-evaluator-adversarial-loop.avif`
- `README.md`
- `docs/core/ARCHITECTURE.md`
- `docs/reference/STORY.md`
- `docs/reference/hitl-pge-loop-design.md`

**Exclude:**
- `.pi/extensions/`
- implementation code
- unrelated completed stories
- `assets/` except reading the existing diagram

## Approach & Verification Plan

### Steps

1. **Lock the canonical wording**  
   Establish the shared wording used across docs: enso is the harness protocol; the PGE loop is one concrete executable orchestration pattern; `STORY-000` defines the persisted story contract; `STORY-001+` story instances are the execution substrates passed through the loop.  
   -> verify: one 2-4 sentence narrative can be reused across the docs without contradiction.

2. **Update `README.md` as the front door**  
   Add an explicit execution-loop section near the canonical stack / how-it-works narrative. Explain planner, generator, evaluator, human gates, and persisted story instances. Link to `docs/reference/STORY.md` and `docs/reference/hitl-pge-loop-design.md`. Optionally reference the existing PGE diagram if it fits without making the README too heavy.  
   -> verify: a new reader can understand the full concept without opening internal implementation files.

3. **Bridge concept to mechanism in `docs/core/ARCHITECTURE.md`**  
   Add a short subsection connecting the fold model to the PGE role loop and human-gated state transitions over a persisted story instance.  
   -> verify: the architecture doc no longer stops at abstraction before explaining the concrete operational loop.

4. **Clarify spec vs instance in `docs/reference/STORY.md`**  
   Tighten the opening paragraphs and expand the reserved-ID note so the file teaches that `STORY-000` is the specification while live story instances conform to it.  
   -> verify: no reader can mistake `STORY-000` for a live execution story.

5. **Align terminology in `docs/reference/hitl-pge-loop-design.md`**  
   Make the design doc explicitly downstream of the story spec. Clarify that “story state object” means a live story instance conforming to the `STORY-000` spec.  
   -> verify: the design doc reads as an implementation pattern for the story contract, not a parallel concept system.

6. **Run a documentation coherence pass**  
   Review the changed files for contradictions and overclaims. Ensure enso remains runtime-agnostic and PGE is presented as one strong executable realization, not the only possible orchestration model.  
   -> verify: grep/manual reads confirm the same terminology is used consistently.

### Risks & Unknowns

- **Overclaim risk:** making PGE sound like enso's only valid orchestration model instead of one concrete executable realization.
- **Terminology risk:** confusing `docs/reference/STORY.md` the spec file with a generic live `STORY.md` execution artifact.
- **README risk:** turning the public front page into internal architecture jargon.
- **Diagram risk:** embedding the PGE diagram may help, but could distract from the lightweight one-file README narrative. Treat diagram inclusion as optional.

### Verification

- [x] Read every file in `Write:` scope before making changes.
- [x] `grep -n "planner\|generator\|evaluator\|STORY-000\|STORY-001\|execution loop\|story substrate" README.md docs/core/ARCHITECTURE.md docs/reference/STORY.md docs/reference/hitl-pge-loop-design.md`
- [x] Manual read of `README.md` from top through “How It Works” confirms the narrative lands in order.
- [x] Manual read of `docs/reference/STORY.md` top section confirms spec vs instance is unambiguous.
- [x] `git diff -- README.md docs/core/ARCHITECTURE.md docs/reference/STORY.md docs/reference/hitl-pge-loop-design.md docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md` shows only scoped doc edits. Note: the new story file is untracked, so `git status --short` is also needed to see it.
- [x] Existing canonical-stack language remains intact and runtime-agnostic.
- [x] Update `docs/core/architecture/` if new subsystems discovered. This story already includes `docs/core/ARCHITECTURE.md`; no additional architecture docs expected.

### Reflection

- [x] Encountered recurring friction -> create skill? No recurring friction; no skill needed.
- [x] Discovered new pattern -> update architecture doc? Yes; `docs/core/ARCHITECTURE.md` now bridges fold model to PGE loop.
- [x] Lesson learned -> add to LESSONS.md? No new durable lesson requiring `LESSONS.md`.
- [x] No new insights -> proceed? Not applicable; architecture was updated.

**Do not begin execution until this section is complete and approved.**

## Execution Notes

- Added a public README execution-loop section tying Planner, Generator, Evaluator, Human gates, and live story files together.
- Clarified `STORY-000` as the story specification and `STORY-001+` as live execution story instances.
- Bridged the architecture fold model to the concrete PGE loop.
- Aligned HITL PGE design terminology around live story instances.

## Pre-Commit Review: STORY-011

**Status:** PASS

### Simple Changes
YES — Diff is surgical and limited to the agreed documentation files plus this story.

### Simple Code
YES — No code or speculative abstractions were introduced.

### Verifiable Completion
YES — Acceptance criteria are checked, grep/manual review passed, and `git diff`/`git status --short` confirm the changed file set.

### Action
- Proceed to handoff.
