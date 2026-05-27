# STORY-010 Planner Generator Evaluator Loop Diagram

## Goal

Create a planner -> generator <-> evaluator adversarial loop diagram matching the hand-drawn black-on-white style of `assets/evaluator-optimizer-pattern.avif`.

## Acceptance Criteria
- [x] Diagram includes Planner, Generator, and Evaluator boxes.
- [x] Flow shows Planner -> Generator and an adversarial Generator <-> Evaluator loop.
- [x] Visual style matches the reference asset: white background, sketch-like black lines, dashed rounded agent boxes, simple brain icons.
- [x] Output asset is saved under `assets/`.

## Context Scope
**Write:**
- `assets/planner-generator-evaluator-adversarial-loop.avif`
- `assets/planner-generator-evaluator-adversarial-loop.png`
- `docs/stories/STORY-010-planner-generator-evaluator-loop-diagram.md`

**Read:**
- `assets/evaluator-optimizer-pattern.avif`
- `assets/orchestrator-subagents-synthesizer-pattern.avif`

**Exclude:**
- `.git/`

## Approach & Verification Plan

### Steps
1. Inspect reference diagrams for layout, line style, dimensions, and icon placement.
2. Generate a new hand-drawn style diagram using local drawing tools.
3. Export PNG and AVIF versions into `assets/`.
4. Verify dimensions and visually inspect the result.

### Risks & Unknowns
- Exact source font for the reference image is unavailable locally; use the closest handwritten/local font and sketch effects.

### Verification

- [x] Read every file in `Write:` scope before making changes (new asset files do not exist yet; this story file was created before execution).
- [x] Verify generated files exist and have expected image dimensions.
- [x] Visually inspect generated PNG.
- [x] Update `docs/core/architecture/` if new subsystems discovered (not applicable).

### Reflection
- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [x] No new insights → proceed

**Do not begin execution until this section is complete.**
