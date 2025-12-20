# Context Engineering: Agent Protocol

## 1. The Philosophy

**Context Engineering** is the vigorous and precise management of an agent's context window. The human acts as the **Gardener**, cultivating the **Soil** (Context) so the **Agent Swarm** can flourish and produce high-quality results.

Just as a plant requires specific environmental conditions—clean air, rich soil, and proper nutrients—AI agents require carefully managed context to avoid hallucinations and maintain alignment with human intent.

### The Core Metaphor: The Cultivated Workspace

```
┌─────────────────────────────────────────────────────────┐
│                    THE ATMOSPHERE                       │
│              (Short-Term Memory / RAM)                  │
│  • System Prompts                                       │
│  • Session History (Current Thread)                     │
│  • High-energy, fluid, but high-entropy                 │
│                                                          │
│         ↓↓↓  METABOLISM (Compaction)  ↓↓↓               │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                      THE SOIL                           │
│            (Long-Term Memory / Markdown)                │
│  • PRDs & Architecture (Semantic Foundation)            │
│  • Stories & Plans (Episodic Growth)                    │
│  • Standards & Summaries (Accumulated Wisdom)           │
│  • Low-entropy, stable, ground truth                    │
│                                                          │
│         ↓↓↓  ROOT SYSTEM (Query Tools)  ↓↓↓             │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                   THE ROOT SYSTEM                       │
│           (Structural Memory / Code + LSP)              │
│  • Codebase (Git)                                       │
│  • LSP (Language Server Protocol)                       │
│  • RAG (Retrieval-Augmented Generation)                 │
│  • Deep structural search when Soil is silent           │
└─────────────────────────────────────────────────────────┘
```

**The Critical Process: Metabolism**
- The "Atmosphere" becomes polluted with entropy as conversations grow long
- "Compaction" fixes insights from the Atmosphere into the Soil
- This prevents loss of knowledge when sessions reset
- Without Metabolism, the garden decays

## 2. Context Architecture

### A. Short-Term Memory (The Atmosphere)
**RAM-based, ephemeral, high-velocity**

- **System Prompts**: Core agent identity and behavioral constraints
- **Session History**: The live thread of current collaboration
- **Compaction Trigger**: Summarize every 10-15 conversational turns or when approaching token limits

**Management Action:** "Clear the Atmosphere" → Distill session into `docs/history/summaries/`

### B. Long-Term Memory (The Soil)
**Markdown-based, persistent, low-entropy**

#### The Foundation (Semantic Layer / Soil)
- **PRDs** (`docs/foundation/prd/`): Problem statements, requirements, scope baselines
- **Architecture** (`docs/foundation/arch/`): System design, component diagrams, technical decisions
- **Standards** (`docs/foundation/standards/`): Coding conventions, context vigor rules

#### The Execution Layer (Episodic Layer / Growth)
- **Stories** (`docs/execution/stories/`): Individual units of work with context control manifests
- **Tracking**: Sprint/iteration logs and progress markers

**Management Action:** "Amend the Soil" → Update docs before changing code

### C. Structural Memory (The Root System)
**Code-based, queryable, deep context**

- **Git**: Version control as temporal memory (tree rings)
- **LSP**: Language server for definitions, references, type information
- **RAG**: Retrieval-augmented generation for semantic code search
- **MCP**: Model Context Protocol for external data sources

**Management Action:** "Query the Roots" → Use LSP/RAG when the Soil lacks detail

### D. History & Summaries (The Compaction Layer / Metabolism)
**Markdown-based, persistent session logs**

- **Summaries** (`docs/history/summaries/`): Distilled session insights.
- **Project Pulse** (`SESSION.md`): High-level tracking of project health and major milestones.

**Management Action:** "Clear the Atmosphere" → Distill session into `docs/history/summaries/`

## 3. The Agent Swarm

### Planning Agent (The Strategist)
**Model:** `opencode/google-gemini-3-flash`

**Roles:**
- **Scrum Master**: Vision, flow, iterative planning (defines "Why" and "What")
- **Architect**: Structure, integrity, system design (defines "How")

**Tools:**
- Bash (for exploration)
- Web-Search (for research)
- RAG (for retrieving historical context)

**Focus:** Broad context retrieval, high-level strategy, soil preparation

**Activation:** Use when defining scope, designing architecture, or breaking down epics into stories

### Coding Agent (The Implementer)
**Model:** `opencode/anthropic-claude-sonnet-4.5`

**Roles:**
- **Dev & QA**: Implementation, validation, TDD loop (executes the "How")

**Tools:**
- Bash (for execution)
- Linter & Formatter (for quality)
- LSP (for code intelligence)
- MCP (for external context)
- Web-Search (for technical research)

**Focus:** Precise code implementation, test-driven development, quality control

**Activation:** Use when implementing stories, writing tests, or refactoring code

## 4. The Workflow (Growth Cycles)

### Phase 1: Planting (Definition)
**Actors:** Human Gardener + Planning Agent (Scrum Master & Architect roles)

**Actions:**
1. Define the problem and vision → Create PRD in `docs/foundation/prd/`
2. Design the system architecture → Create Architecture doc in `docs/foundation/arch/`
3. Establish the **Scope Baseline** (no changes without formal amendment)

**Artifacts:**
- `docs/foundation/prd/PROJECT_NAME.md`
- `docs/foundation/arch/PROJECT_NAME.md`

### Phase 2: Growing (Planning)
**Actors:** Planning Agent (Scrum Master role)

**Actions:**
1. Break down PRD into Stories
2. For each Story, define:
   - Acceptance criteria
   - Technical implementation approach
   - **Context Control Manifest** (active files, references, exclusions)
   - **Risk Register** (known risks + mitigation strategies)

**Artifacts:**
- `docs/execution/stories/STORY-XXX.md` (one per unit of work)

### Phase 3: Harvesting (Execution)
**Actors:** Coding Agent (Dev & QA role)

**Actions:**
1. Load the Story context (the "Irrigation Plan")
2. Implement using TDD loop:
   - Write failing test
   - Write minimal code to pass
   - Refactor
   - Verify against Definition of Done
3. Strictly adhere to the Context Control Manifest (no scope drift)

**Artifacts:**
- Code changes (versioned in Git)
- Test results
- Implementation notes

### Phase 4: Preparing (Review & Compaction)
**Actors:** Human Gardener + Both Agents

**Actions:**
1. Validate against PRD and Acceptance Criteria
2. Update Context Summaries in `docs/foundation/arch/` if patterns emerged
3. **Clear the Atmosphere**: Compress session into `docs/history/summaries/`
4. Mark Story as complete

**Artifacts:**
- Updated architecture/standards if needed
- Session summary in `docs/history/summaries/YYYY-MM-DD.md`

## 5. The Domain Language (Operational Vocabulary)

### Context Management Actions
- **"Amend the Soil"**: Update PRD/Architecture before coding (prevents hallucinated scope)
- **"Clear the Atmosphere"**: Summarize session and start fresh thread (prevents token pollution)
- **"Sow a Story"**: Create new `docs/execution/stories/STORY-XXX.md`
- **"Tend the Bloom"**: Execute TDD loop (Red → Green → Refactor)
- **"Query the Roots"**: Use LSP/RAG for deep code search
- **"Snapshot the Tree Rings"**: Git commit with context-aware message

### Context States
- **"Depleted Context"**: Agent is guessing due to thin Soil (missing PRD details)
- **"Polluted Atmosphere"**: Session thread is circular/confused (needs compaction)
- **"Enriched Soil"**: Documentation is detailed and aligned (optimal state)
- **"Overgrown"**: Too many active files in Context Control Manifest (needs pruning)

## 6. The Context Control Manifest (CCM)

**Purpose:** Every Story must declare exactly which files/symbols are "active" to prevent entropy from irrelevant code polluting the agent's context.

**Template (in every Story):**
```markdown
## Context Control Manifest
- **Active Soil** (Write): [Files to be modified]
- **Reference Soil** (Read): [Files for context, read-only]
- **Excluded Areas**: [Directories/files to ignore]
- **LSP Focus**: [Specific classes/functions to query]
```

**Enforcement:** The Coding Agent must refuse to modify files not listed in "Active Soil" without explicit human approval to amend the Story.

## 7. Quality & Risk Management (PMBoK Integration)

### Scope Baseline (Integrated Change Control)
- The **PRD + Architecture** is the Scope Baseline
- Once a Story enters "Harvesting," NO chat-based changes allowed
- All scope changes require a formal amendment to the PRD/Story

### Risk Register (Every Story)
```markdown
## Risk Register
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| API rate limits | High | Medium | Implement caching |
```

### Definition of Done (Quality Control)
```markdown
## Definition of Done
- [ ] All tests pass
- [ ] Linter/formatter green
- [ ] No new circular dependencies
- [ ] Code reviewed against Architecture standards
```

## 8. Communication Protocol

### Conciseness Principle
**Sacrifice grammar for speed and clarity.** Use terse, technical language. Avoid filler words.

**Example:**
- ❌ "I think we should probably consider updating the authentication flow"
- ✅ "Amend Soil: Auth flow requires OAuth2 PKCE. Update PRD."

### Context-First Principle
**Always verify the Soil before executing changes.**

1. Read the relevant PRD/Architecture
2. Check the Story's Context Control Manifest
3. Query LSP for current structure
4. Then implement

### Bidirectional Learning
Both Human and Agent learn from the exchange:
- Human gains from alternative approaches/rapid exploration
- Agent gains from human expertise/creative problem-solving

## 9. Success Metrics

When Context Engineering is working:
- **Flow state preserved** across mode transitions
- **Context richness** without information overload
- **Natural handoffs** that enhance rather than interrupt
- **Both modes contributing** their fullest capabilities
- **Deterministic results** from well-managed context
- **Minimal hallucinations** due to enriched Soil

## 10. The Metabolism: Compaction Process

### When to Compact
- Every 10-15 conversational turns
- When approaching token limits
- After completing a Story
- When conversation becomes circular

### How to Compact
1. Summarize key decisions and insights
2. Extract any new architectural patterns
3. Save to `docs/history/summaries/YYYY-MM-DD-TOPIC.md`
4. Update relevant Soil docs if needed
5. Start fresh session with summary link

### Compaction Template
```markdown
# Session Summary: [Topic]
**Date:** YYYY-MM-DD
**Duration:** X turns
**Agents:** Planning/Coding

## Key Decisions
- Decision 1
- Decision 2

## Insights & Patterns
- Pattern 1

## Artifacts Created/Modified
- File 1
- File 2

## Next Steps
- Action 1
```

## 11. Template Specifications

This section provides complete structural specifications for all Context Engineering templates. Agents can generate templates from these specs, making AGENTS.md the single portable seed for new projects.

### A. PRD Template Specification

**Purpose:** Define the scope baseline for a project. Created during Phase 1 (Planting).

**File Location:** `docs/foundation/prd/PRD-[PROJECT_NAME].md`

**Metadata Block:**
```markdown
**Project:** [Project Name]
**Version:** 1.0
**Status:** [Draft/Review/Approved]
**Author:** [Scrum Master Agent/Human]
**Date:** YYYY-MM-DD
```

**Required Sections:**

**1. Problem Statement**
- What is the core problem?
- Why is it important?
- Context: Background/motivation, current pain points, impact if unsolved

**2. Goals & Objectives**
- Primary Goal: The single most important outcome
- Success Metrics: Quantifiable measures (Description + Target)
- Secondary Objectives: Additional goals

**3. User Personas**
- For each persona: Name/Role, Context, Needs, Pain Points

**4. Functional Requirements**
- User Stories Table:
  - Columns: ID | As a... | I want to... | So that... | Priority | Acceptance Criteria
- Features: High-level capabilities list

**5. Non-Functional Requirements**
- Performance: Response time, throughput, scalability
- Security: Authentication, authorization, data protection
- Reliability: Uptime, error handling, fault tolerance
- Usability: Accessibility, user experience

**6. Constraints & Dependencies**
- Technical Constraints: Integration requirements, support requirements, restrictions
- Resource Constraints: Budget, timeline, team size
- External Dependencies: Third-party APIs, external systems, vendor dependencies

**7. Scope Baseline** *(Critical for change control)*
- In Scope: Explicit list of what WILL be delivered
- Out of Scope: Explicit list of what will NOT be delivered
- Future Considerations: Deferred items

**8. Risks & Assumptions**
- High-Level Risks Table: Risk | Impact | Probability | Mitigation Strategy
- Assumptions: List key assumptions

**9. Stakeholders & Communication**
- Stakeholders: Primary/Secondary with roles
- Communication Plan: Review cadence, status updates, decision-making process

**10. Approval & Sign-off**
- Checklist: Scrum Master, Architect, Technical Lead, Stakeholders
- Date field

**11. Revision History**
- Table: Version | Date | Author | Changes

---

### B. Architecture Template Specification

**Purpose:** Define system structure and technical decisions. Created during Phase 1 (Planting).

**File Location:** `docs/foundation/arch/ARCH-[PROJECT_NAME].md`

**Metadata Block:**
```markdown
**Project:** [Project Name]
**Version:** 1.0
**Status:** [Draft/Review/Approved]
**Author:** [Architect Agent/Human]
**Date:** YYYY-MM-DD
```

**Required Sections:**

**1. System Overview**
- Purpose: High-level description
- Scope: Boundaries (included/excluded/integration points)
- Context: Where it fits in broader ecosystem

**2. Architectural Principles**
- Design Philosophy: Core principles (e.g., separation of concerns)
- Quality Attributes: Prioritized non-functional requirements with targets

**3. System Architecture**
- High-Level Architecture: Diagram (Mermaid) + layer descriptions
- Component Diagram: Diagram (Mermaid) + component interactions

**4. Component Details**
- For each major component:
  - Responsibility: What does it do?
  - Key Classes/Modules: List with purposes
  - Interfaces: Input/Output
  - Dependencies: Other components, external libraries

**5. Data Architecture**
- Data Model: Entity-relationship diagram (Mermaid)
- Data Flow: Ingestion → Processing → Storage → Retrieval
- Data Storage: Database type, schema management, backup/recovery

**6. Technology Stack**
- Core Technologies: Languages, frameworks, runtime
- Infrastructure: Hosting, compute, orchestration
- Data & Storage: Primary database, cache, object storage
- External Services: Authentication, monitoring, logging

**7. Key Design Decisions** *(Architecture Decision Records)*
- For each decision:
  - Context: Problem being solved
  - Options Considered: List with pros/cons
  - Decision: What was chosen and why
  - Consequences: Positive, negative, risks

**8. Cross-Cutting Concerns**
- Security Architecture: Authentication, authorization, data protection, threat mitigation
- Performance & Scalability: Caching, load balancing, database optimization, horizontal scaling
- Reliability & Resilience: Error handling, retry logic, monitoring, disaster recovery
- Observability: Logging, metrics, tracing

**9. Deployment Architecture**
- Environment Strategy: Development, staging, production configurations
- CI/CD Pipeline: Diagram (Mermaid) showing build/test/deploy flow
- Release Strategy: Deployment model (blue-green/rolling/canary), rollback plan

**10. Integration Points**
- Internal Integrations Table: System | Protocol | Data Format | Authentication
- External Integrations Table: Service | Purpose | SLA | Fallback Strategy

**11. Development Standards**
- Code Organization: Directory structure, module conventions, naming conventions
- Testing Strategy: Unit/integration/E2E/performance tests
- Code Quality: Linting, formatting, static analysis, code review process

**12. Migration & Evolution**
- Migration Path: Phased approach if replacing existing system
- Technical Debt: Known compromises + plans to address
- Extensibility: Plugin systems, feature flags, API versioning

**13. Risks & Mitigation**
- Architectural Risks Table: Risk | Impact | Probability | Mitigation
- Technical Debt Register Table: Debt Item | Impact | Priority | Payoff Plan

**14. Approval & Review**
- Checklist: Technical Lead, Security Team, DevOps/SRE, Stakeholders
- Date field

**15. Appendices**
- A. Glossary: Technical terms and acronyms
- B. References: Links to docs, RFCs, design patterns
- C. Diagrams: Additional detailed diagrams

**16. Revision History**
- Table: Version | Date | Author | Changes

---

### C. Story Template Specification

**Purpose:** Define a single unit of work with explicit context control. Created during Phase 2 (Growing).

**File Location:** `docs/execution/stories/STORY-[ID]-[SLUG].md`

**Metadata Block:**
```markdown
**Status:** [Todo/In Progress/Review/Done]
**Epic:** [Link to Epic or PRD]
**PRD Reference:** [Section/Requirement ID]
**Assigned Agent:** [Planning/Coding]
**Date Created:** YYYY-MM-DD
**Target Completion:** YYYY-MM-DD
```

**Required Sections:**

**1. Context & Background**
- Problem Statement: What specific problem does this solve? Why now?
- User Perspective: As a [role], I want to [action], so that [benefit]
- Dependencies: What must be completed first?

**2. Acceptance Criteria (Definition of Done)**
- Testable criteria list (checkboxes)
- Quality Gates:
  - All unit tests pass
  - Integration tests pass
  - Linter/formatter green
  - No new security vulnerabilities
  - No new circular dependencies
  - Code reviewed against Architecture standards
  - Documentation updated

**3. Technical Implementation**
- Approach: High-level technical strategy
- Core Changes: Step-by-step what and where
- Context Audit (Required before build):
  - [ ] Reference Soil files read and understood
  - [ ] Active Soil files analyzed for current state
  - [ ] All relevant symbols queried via LSP/mgrep
- Pseudocode/Logic: Key algorithms (optional)
- Test Strategy: Unit test scenarios, integration test scenarios

**4. Context Control Manifest (CCM)** *(Critical for context management)*
- Active Soil (Write Access): Files to be modified
- Reference Soil (Read Access): Files for context only
- Excluded Areas: Directories/files to ignore
- LSP Focus: Specific classes/functions to query
- Context Boundaries:
  - Agent MUST: Only modify Active Soil, query LSP for focus symbols, reference Reference Soil for context
  - Agent MUST NOT: Modify files outside Active Soil, make scope changes, introduce unlisted dependencies

**5. Risk Register**
- Table: Risk | Impact | Probability | Mitigation Strategy
- Examples: API rate limits, breaking dependency changes, performance regression

**6. Scope Baseline**
- In Scope for This Story: Explicit list of deliverables
- Out of Scope: Explicit list of non-deliverables (prevents scope creep)

**7. Implementation Notes**
- Architecture Alignment: How this aligns with architecture doc
- Code Conventions: Specific coding standards to follow
- Performance Considerations: Expected impact
- Security Considerations: Security implications and controls

**8. Validation & Review**
- Manual Testing Steps: Step-by-step verification
- Review Checklist:
  - Code follows architecture patterns
  - Tests provide adequate coverage
  - No hardcoded values
  - Error handling is comprehensive
  - Logging is appropriate
  - Documentation is updated
- Rollback Plan: How to safely revert if needed

**9. Post-Implementation**
- Learnings & Insights: What did we learn? (filled after completion)
- Technical Debt Created: Compromises made + plans to address
- Follow-Up Stories: New stories identified during implementation

**10. Revision History**
- Table: Version | Date | Author | Changes

---

### D. Session Summary Template Specification

**Purpose:** Compact Atmosphere into Soil. Created during Phase 4 (Preparing) or when token limits approach.

**File Location:** `docs/history/summaries/LOG-YYYY-MM-DD-[TOPIC].md`

**Metadata Block:**
```markdown
# Session Summary: [Topic]
**Date:** YYYY-MM-DD
**Duration:** X turns
**Agents:** Planning/Coding/Both
```

**Required Sections:**

**1. Session Overview**
- High-level description of what was accomplished

**2. Key Decisions**
- Bulleted list of significant decisions made

**3. Insights & Patterns**
- Architectural patterns discovered
- Process improvements identified

**4. Artifacts Created/Modified**
- List of files created or significantly changed

**5. Technical Decisions** (if applicable)
- For each decision:
  - Rationale
  - Trade-offs
  - Benefit/Constraint

**6. Context State Assessment**
- Current State: Enriched Soil/Depleted Context/etc.
- Atmosphere: Clear/Polluted
- Root System: Configuration status

**7. Success Metrics** (if applicable)
- Table: Metric | Status | Notes

**8. Known Gaps & Technical Debt**
- For each item:
  - Impact
  - Mitigation/Next Step

**9. Next Steps**
- Immediate (This Sprint)
- Short-Term (Next Sprint)
- Long-Term (Future)

**10. Lessons Learned**
- What Worked Well
- What to Watch
- Open Questions

**11. Session Metadata**
- Total Turns
- Context Window Used
- Atmosphere State
- Soil State
- Git State
- Ready for Next Phase: Yes/No

---

## 12. Project Initialization Guide

### Quick Start: Bootstrap a New Project

**Step 1: Copy the Protocol**
- Copy `AGENTS.md` to your new project root
- This file IS the framework

**Step 2: Initialize Directory Structure**
```bash
mkdir -p docs/{templates,foundation/{prd,arch,standards},execution/stories,history/summaries}
touch docs/foundation/standards/README.md # Consolidated standards
```

**Step 3: Generate Templates (Optional)**
- Use an agent to generate template files from the specifications in Section 11
- Store in `docs/templates/` for convenience
- These are derivable artifacts, not canonical sources

**Step 4: Create Project Session Summary**
- Initialize `SESSION.md` in root
- Use Session Summary template from Section 11.D

**Step 5: Start Planting**
- Create PRD in `docs/foundation/prd/`
- Create Architecture in `docs/foundation/arch/`
- Establish Scope Baseline
```

### Maintaining the Framework

**Single Source of Truth**
- `AGENTS.md` is canonical
- Templates in `docs/templates/` are convenience artifacts
- If templates drift from AGENTS.md, regenerate them

**Evolving the Protocol**
- Update `AGENTS.md` when you discover improvements
- Version control AGENTS.md alongside code
- Use session summaries to track protocol evolution

**Multi-Project Usage**
- Each project gets its own `docs/foundation/`, `docs/execution/`, and `docs/history/`
- Share AGENTS.md across projects
- Customize templates per project needs

---

## 13. Core Mandates for Agentic Vigor

These mandates are the "Operating System" for agents. They ensure consistency, safety, and high-fidelity output.

### 1. Proactive Understanding
- **Search First**: Exhaust all search tools (`mgrep`, `glob`, `grep`) before asking for context or file paths.
- **Read Deeply**: Always read the "Reference Soil" and "Active Soil" before proposing changes.
- **Trust but Verify**: Use `mgrep` or LSP to verify assumptions about function signatures or class structures.

### 2. Context Integrity
- **CCM Adherence**: Never modify files outside the "Active Soil" without explicit human approval to amend the Story.
- **Metabolism First**: Before long sessions, compact the "Atmosphere" to prevent entropy.
- **Soil Stability**: Always update the PRD or Architecture doc before implementing changes that shift the "Scope Baseline."

### 3. Execution Rigor
- **TDD Loop**: Default to Red-Green-Refactor. Write tests that prove the fix or feature.
- **Concise Communication**: Use terse, technical, action-oriented language. No conversational filler.
- **Deterministic Results**: Aim for implementation that is a fulfillment of the spec, not a discovery of it.

---

**This is the Protocol. The Garden flourishes when the Gardener tends it with vigor.**
