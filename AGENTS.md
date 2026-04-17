---
protocol: enso
version: 0.5.2
audience: agent
operations: [Write, Select, Probe, Compress, Isolate, Assign]
directories:
  core: docs/core/
  stories: docs/stories/
  reference: docs/reference/
  skills: docs/skills/
  logs: docs/logs/
---

# enso

[Agent Harness Protocol](https://github.com/usefulmove/enso)

IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for framework-specific and domain-specific tasks.

---

## Codebase (Optional)

| Path | Contents |
|------|----------|
| | |

## Docs Index

| Doc | Path |
|-----|------|
| PRD | `docs/core/PRD.md` |
| Architecture | `docs/core/architecture/ARCHITECTURE.md` |

---

## 1. Purpose

Context management protocol for agentic software development.

**Workflow:**
1. Bootstrap directory structure
2. Request user input for problem, scope, constraints
3. Generate PRD
4. Execute stories
5. Build tools as needed

**Goal:** Minimize tokens while maintaining verifiable, recursive workflows.

**Principle:** Software building software.

## 2. The Six Operations

**Context is finite.** Treat tokens as a scarce resource.

| Operation | Action |
|-----------|--------|
| **Write** | Persist to durable storage |
| **Select** | Load only needed context |
| **Probe** | Search (grep, LSP, glob) for answers |
| **Compress** | Summarize to fit budget |
| **Isolate** | Split across scopes |
| **Assign** | Match task to agent capabilities |

**Keep current, not historical.** Git preserves history.

**Progressive disclosure.** Frontmatter before details.

## 2.1 Self-Improvement

**Trigger:** Recurring tasks, complex procedures, missing capabilities
**Action:** Build minimal tool/script/skill
**Location:** `docs/skills/`

## 2.2 Agentic Discovery

Architecture docs are maps drawn through exploration, not blueprints to read.

**Process:**
- Probe codebase using `grep`, LSP, file exploration
- Persist discoveries to `docs/core/architecture/`
- Validate against compilation, tests, tool results

## 3. Terminology

| Term | Definition |
|------|------------|
| **Working Context** | Ephemeral tokens in current call |
| **Persistent Context** | Durable markdown documents |
| **Reference Context** | Queryable sources (codebase, web) |
| **Compaction** | Summarize working → persistent |
| **Context Budget** | Token limit |
| **Context Scope** | Write/Read/Exclude boundaries |

**Hierarchy:**

```
WORKING (ephemeral)
  ↓ Write / ↑ Select
PERSISTENT (durable)
  - Core (PRD, Architecture)
  - Stories (active tasks)
  - Reference (conventions)
  - Skills (capabilities)
  - Logs (summaries)
REFERENCE (queryable)
  - Codebase (LSP, grep)
  - Web, APIs
```

## 4. Directory Structure

```
docs/
  core/
  stories/
  reference/
  skills/
  logs/
```

## 5. Bootstrapping

1. **Create structure**
   ```bash
   mkdir -p docs/{core,stories,reference/completed,skills,logs}
   touch docs/reference/LESSONS.md
   ```

2. **Optionally fill in Codebase/Docs Index tables** (see Section 5.1)

3. **Request user input** for problem, success criteria, scope, constraints

4. **Generate PRD** at `docs/core/PRD.md`

5. **System Mapping** — Create minimal `ARCHITECTURE.md`. Extend through [agentic discovery](#22-agentic-discovery) as you work.

6. **First story** at `docs/stories/`

7. **Begin work**

### 5.1 Optional: Codebase and Docs Index Tables

```markdown
## Codebase

| Path | Contents |
|------|----------|
| `src/` | Source code |
| `tests/` | Test files |

## Docs Index

| Doc | Path |
|-----|------|
| PRD | `docs/core/PRD.md` |
| Architecture | `docs/core/architecture/ARCHITECTURE.md` |
```

## 6. Planning Phase

No file modifications until story Approach section is complete.

**Required:**
1. Create/locate story in `docs/stories/`
2. Complete Approach (Steps, Risks, Verification)
3. Verify Context Scope (Write/Read/Exclude)
4. Then execute

**Small tasks:** Minimal story with one-line Steps is acceptable.

## 7. Document Lifecycle

**Core Docs** — Update in place. Don't preserve history—git does.

**Stories** — Create when planning, move to `reference/completed/` when done.

**Reference** — Read-only during execution. **Update `LESSONS.md` with new learnings.**

**Skills** — Add/remove as needed.

**Logs** — Append session summaries.

## 8. Context Scope

```markdown
## Context Scope

**Write:**
- src/auth/login.ts

**Read:**
- docs/core/ARCHITECTURE.md

**Exclude:**
- src/legacy/
```

**Enforcement:**
- Do not modify outside Write scope
- Read files are seeds; Probe for related context
- Scope changes require user approval

## 9. Skills

On-demand capabilities for vertical workflows (migrations, upgrades, refactor).

**Location:** `docs/skills/<skill-name>/`

**Structure:**
```
SKILL.md      # Required
scripts/      # Optional
references/   # Optional
assets/       # Optional
```

**Discovery:** Scan directories at session start, read frontmatter (~100 tokens).

**Priority:** Local skills (`docs/skills/`) take precedence over global skills. When a local and global skill serve the same purpose, load the local one.

## 9.2 Tool Building

**When:** Recurring tasks, complex procedures, capability gaps

**Process:**
1. Scan `docs/skills/` for existing tools
2. Build minimal solution
3. Persist to `docs/skills/<tool-name>/`
4. Iterate

## 9.1 Framework Documentation Index

Store version-matched docs in `docs/core/framework/`:

```markdown
## Framework Documentation
Location: docs/core/framework/

| Section | Files |
|---------|-------|
| Routing | routing.md |
```

## 10. Compaction

Move insights from working → persistent context.

**Triggers:** ~80% token utilization, story completion, session end.

**Process:** Summarize decisions, list artifacts, extract lessons to `LESSONS.md`, write to `logs/`.

## 11. Templates

### PRD

```markdown
# [Project] PRD

## Problem

## Goals

## Scope
**In scope:**
**Out of scope:**
```

### Architecture

```markdown
# [Project] Architecture

## Overview

## Components
| Component | Responsibility |
|-----------|----------------|

## Key Decisions
| Decision | Rationale |
```

### Story

```markdown
# [STORY-ID] [Title]

## Goal

## Acceptance Criteria
- [ ]

## Context Scope
**Write:**
**Read:**
**Exclude:**

## Approach & Verification Plan

### Steps
1.

### Risks & Unknowns
-

### Verification

- [ ] Update `docs/core/architecture/` if new subsystems discovered.

**Do not begin execution until this section is complete.**
```

### Session Summary

```markdown
# Session: [Topic]
**Date:** YYYY-MM-DD

## Overview

## Key Decisions
-

## Artifacts Modified
-

## Next Steps
-
```

## 12. Agent Guidelines

- Plan before executing
- Search before asking
- Skills for workflows, framework docs for APIs
- Prefer retrieval over training
- Read before writing
- Update, don't accumulate
- Compact proactively
- Stay in scope
- Be concise
- Test early
- Lint before done
- Use LSP, Context7 for accuracy
- Grow architecture incrementally
- Extend yourself
- Capture wisdom in skills
- Compound capabilities

## 13. Pi Principle

Agents extend themselves by authoring tools, not downloading them.
Source: https://github.com/badlogic/pi-mono/

## 14. References

- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Claude Code: Best practices](https://www.anthropic.com/engineering/claude-code-best-practices)
