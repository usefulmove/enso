# STORY-010 README canonical stack alignment

## Goal

Update the public README so it consistently presents enso through the canonical stack: Model, Runtime, Harness protocol, Harness instance, Agent instantiation, and Substrate.

## Acceptance Criteria
- [x] README replaces the three-layer/kernel metaphor section with the canonical stack.
- [x] README explains what persists and what does not.
- [x] Quick Start language distinguishes harness protocol, harness instance, agent instantiation, and substrate.
- [x] "What Enso Is Not" explicitly says enso is not a model or runtime.
- [x] Public-facing tone remains concise and accessible.

## Context Scope
**Write:**
- `README.md`
- `docs/stories/STORY-010-readme-canonical-stack.md`
- `docs/logs/2026-05-16-readme-canonical-stack.md`

**Read:**
- `README.md`
- `AGENTS.md`
- `docs/core/ARCHITECTURE.md`

**Exclude:**
- source code
- slash command implementation
- non-README reference docs

## Approach & Verification Plan

### Steps
1. Replace README public-facing stack framing with the canonical stack.
2. Add persistence explanation and align Quick Start, How It Works, Directory Structure, Self-Extension, and What Enso Is Not wording.
3. Verify the README contains all canonical terms and review the diff for scope.

### Risks & Unknowns
- README must stay understandable to external readers and not become an internal architecture document.
- Existing evidence and quick-start flow should remain intact.

### Verification

- [x] `README.md` contains all six canonical stack terms.
- [x] `README.md` no longer uses the old "Three-Layer Stack" section.
- [x] `git diff -- README.md docs/stories/STORY-010-readme-canonical-stack.md docs/logs/2026-05-16-readme-canonical-stack.md` shows only scoped documentation changes.
- [x] Update `docs/core/architecture/` if new subsystems discovered. No architecture update needed; this was README alignment only.

### Reflection
- [x] Encountered recurring friction → create skill? No.
- [x] Discovered new pattern → update architecture doc? No.
- [x] Lesson learned → add to LESSONS.md? No.
- [x] No new insights → proceed

## Pre-Commit Review: STORY-010

**Status:** PASS

### Simple Changes
YES — Diff is surgical and limited to README wording plus story/log artifacts.

### Simple Code
YES — Documentation-only change; no speculative implementation added.

### Verifiable Completion
YES — Canonical terms are present, old stack metaphor terms are absent, and `git diff --check` passed.

### Action
- Proceed to persist.

**Do not begin execution until this section is complete.**
