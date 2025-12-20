# Story: [ID] - [Title]

> **Note:** This template is a convenience artifact derived from `AGENTS.md` Section 11.C.
> The canonical specification lives in `AGENTS.md`. If this template drifts from the spec, regenerate it.

**Status:** [Todo/In Progress/Review/Done]
**Epic:** [Link to Epic or PRD]
**PRD Reference:** [Section/Requirement ID]
**Assigned Agent:** [Planning/Coding]
**Date Created:** YYYY-MM-DD
**Target Completion:** YYYY-MM-DD

---

## 1. Context & Background

### Problem Statement
*What specific problem does this story solve? Why is it needed now?*

### User Perspective
*As a [user/role], I want to [action], so that [benefit].*

### Dependencies
*What must be completed before this story can start?*
- Story/Feature X
- Environment setup Y

## 2. Acceptance Criteria (Definition of Done)

*Clear, testable conditions that must be met for this story to be considered complete.*

- [ ] **Criterion 1**: [Specific, measurable outcome]
- [ ] **Criterion 2**: [Specific, measurable outcome]
- [ ] **Criterion 3**: [Specific, measurable outcome]

### Quality Gates
- [ ] All unit tests pass
- [ ] Integration tests pass (if applicable)
- [ ] Linter/formatter green
- [ ] No new security vulnerabilities
- [ ] No new circular dependencies
- [ ] Code reviewed against Architecture standards
- [ ] Documentation updated

## 3. Technical Implementation

### Approach
*High-level technical strategy for implementing this story.*

**Core Changes:**
1. [Step 1: What and where]
2. [Step 2: What and where]
3. [Step 3: What and where]

### Context Audit (Required before build)
*Purpose: Ensure the agent has sufficient context before modifying the codebase.*

- [ ] **Reference Soil reviewed**: All files listed in "Reference Soil" have been read and understood.
- [ ] **Active Soil verified**: The current state of all files in "Active Soil" has been analyzed.
- [ ] **Symbols queried**: Key classes, functions, and types have been verified via LSP or `mgrep`.

### Pseudocode/Logic
*Optional: Key algorithms or logic flows.*
```
function exampleLogic():
    if condition:
        do something
    else:
        do alternative
```

### Test Strategy
*How will this be validated?*

**Unit Tests:**
- Test scenario 1: [Expected behavior]
- Test scenario 2: [Expected behavior]

**Integration Tests:**
- Test scenario A: [End-to-end flow]

## 4. Context Control Manifest (CCM)

**Purpose:** Explicitly define which files and symbols are active to prevent context pollution and scope drift.

### Active Soil (Write Access)
*Files that WILL be modified in this story.*
- `src/module/file1.ts`
- `src/module/file2.ts`
- `tests/module/file1.test.ts`

### Reference Soil (Read Access)
*Files needed for context but should NOT be modified.*
- `src/shared/types.ts` (for type definitions)
- `src/config/constants.ts` (for configuration values)
- `docs/foundation/arch/PROJECT_NAME.md` (architecture reference)

### Excluded Areas
*Directories/files to explicitly ignore to reduce noise.*
- `src/legacy/` (deprecated code, not relevant)
- `src/experimental/` (not stable)
- `node_modules/` (third-party dependencies)

### LSP Focus
*Specific classes, functions, or symbols to query via Language Server.*
- `ClassName.methodName()` in `file1.ts`
- Type definition: `InterfaceName` in `types.ts`
- Function: `helperFunction()` in `utils.ts`

### Context Boundaries
**Agent MUST:**
- Only modify files in "Active Soil"
- Query LSP for symbols in "LSP Focus" before making changes
- Reference "Reference Soil" for context but not modification

**Agent MUST NOT:**
- Modify files outside "Active Soil" without explicit human approval
- Make scope changes beyond the acceptance criteria
- Introduce dependencies not listed in the Architecture doc

## 5. Risk Register

*Identify and mitigate risks specific to this story.*

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| [e.g., API rate limits during testing] | High | Medium | Use mock data for tests; implement retry logic |
| [e.g., Breaking change in dependency] | Medium | Low | Pin dependency versions; add integration test |
| [e.g., Performance regression] | High | Medium | Add performance benchmark test |

## 6. Scope Baseline

### In Scope for This Story
*Explicit list of what WILL be delivered.*
- Feature/change 1
- Feature/change 2

### Out of Scope
*Explicit list of what will NOT be delivered (prevents scope creep).*
- Future enhancement X (deferred to Story-XXX)
- Edge case Y (logged as technical debt)

## 7. Implementation Notes

### Architecture Alignment
*How does this story align with the architecture document?*
- Follows [pattern/principle] from `docs/foundation/arch/PROJECT_NAME.md`
- Integrates with [component] as designed

### Code Conventions
*Specific coding standards to follow.*
- Follow style guide in `docs/foundation/standards/CODING_STANDARDS.md`
- Use [naming convention] for [specific elements]

### Performance Considerations
*Expected impact on system performance.*
- [e.g., "No significant impact expected"]
- [e.g., "May increase response time by ~50ms; acceptable per NFRs"]

### Security Considerations
*Security implications and controls.*
- [e.g., "Input validation required on all user inputs"]
- [e.g., "API endpoint requires authentication"]

## 8. Validation & Review

### Manual Testing Steps
*Steps to manually verify the implementation.*
1. Step 1: [Action and expected result]
2. Step 2: [Action and expected result]

### Review Checklist
- [ ] Code follows architecture patterns
- [ ] Tests provide adequate coverage
- [ ] No hardcoded values (use config)
- [ ] Error handling is comprehensive
- [ ] Logging is appropriate
- [ ] Documentation is updated

### Rollback Plan
*If this story introduces issues, how can it be safely reverted?*
- Revert commit [hash]
- Re-run database migration [file]
- Clear cache [location]

## 9. Post-Implementation

### Learnings & Insights
*To be filled after completion. What did we learn?*
- Insight 1:
- Insight 2:

### Technical Debt Created
*Any compromises made that should be addressed later.*
- Debt item 1: [Description + Plan to address]

### Follow-Up Stories
*New stories identified during implementation.*
- Story-XXX: [Title and brief description]

---

## Revision History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Name] | Initial story definition |
