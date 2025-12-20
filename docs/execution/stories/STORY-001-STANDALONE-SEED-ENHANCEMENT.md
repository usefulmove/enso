# Story: STORY-001 - Standalone Seed Enhancement

**Status:** Done
**Epic:** Context Engineering Framework
**PRD Reference:** N/A (Meta-project enhancement)
**Assigned Agent:** Coding
**Date Created:** 2025-12-20
**Target Completion:** 2025-12-20

---

## 1. Context & Background

### Problem Statement
`AGENTS.md` serves as the primary protocol, but for it to be a truly effective "standalone seed" for new projects, it needs explicit behavioral mandates and a stronger context verification loop to prevent agent drift and hallucinations in fresh environments.

### User Perspective
As a Gardener, I want to drop `AGENTS.md` into a new project and have an agent immediately understand not just the *structure* of the work, but the *vigor* required to execute it correctly.

### Dependencies
- None

## 2. Acceptance Criteria (Definition of Done)

- [ ] `AGENTS.md` contains a new Section 13: Core Mandates for Agentic Vigor.
- [ ] `AGENTS.md` Section 11.C (Story Spec) includes a "Context Audit" requirement.
- [ ] `AGENTS.md` Section 12 (Init Guide) recommends a consolidated standards file.
- [ ] `docs/templates/STORY_TEMPLATE.md` is updated to match the new specification.
- [ ] All changes follow the concise, technical style of the existing protocol.

### Quality Gates
- [ ] Linter/formatter green (N/A for Markdown, but clean formatting)
- [ ] Documentation updated (This IS the documentation)

## 3. Technical Implementation

### Approach
1. Amend `AGENTS.md` using the `edit` tool for precision.
2. Regenerate `STORY_TEMPLATE.md` from the new spec.

### Context Audit (Required before build)
- [ ] Reference Soil files read and understood
- [ ] Active Soil files analyzed for current state
- [ ] All relevant symbols queried via LSP/mgrep

## 4. Context Control Manifest (CCM)

### Active Soil (Write Access)
- `/home/dedmonds/repos/enso/AGENTS.md`
- `/home/dedmonds/repos/enso/docs/templates/STORY_TEMPLATE.md`

### Reference Soil (Read Access)
- `/home/dedmonds/repos/enso/AGENTS.md`
- `/home/dedmonds/repos/enso/docs/execution/stories/STORY-001-STANDALONE-SEED-ENHANCEMENT.md`

### Excluded Areas
- `node_modules/`

## 5. Risk Register

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| Protocol bloat | Medium | Medium | Keep additions concise and high-value only. |
| Template drift | Low | Low | Update template immediately after spec change. |

## 6. Scope Baseline

### In Scope for This Story
- Enhancing `AGENTS.md` with Core Mandates.
- Adding Context Audit to Story Spec.
- Updating Init Guide for consolidated standards.

### Out of Scope
- Creating the actual standards file (that's for the next project).
- Automating template generation (manual update for now).

---

## Revision History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-20 | Coding Agent | Initial story definition |
