---
protocol: enso
version: 0.6.0
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

**Context hierarchy:**

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
**Process:** Build minimal tool → test it → persist to `docs/skills/` → iterate

**Curation:** Periodically promote insights from LESSONS.md into harness improvements using the Curator mode. Not all lessons require action — classify as Promote, Observe, or Deprecate.

**Verify before trusting:** Test tool output before relying on it. If it fails, fix or discard.

**See:** [§7 Skills](#7-skills)

## 2.2 Agentic Discovery

Architecture docs are maps drawn through exploration, not blueprints to read.

**Process:**
- Probe codebase using `grep`, LSP, file exploration
- Persist discoveries to `docs/core/architecture/`
- Validate against compilation, tests, tool results

## 3. Bootstrapping

1. **Create structure**
   ```bash
   mkdir -p docs/{core,stories,reference/completed,skills,logs}
   touch docs/reference/LESSONS.md
   ```

2. **Optionally fill in Codebase/Docs Index tables** (see Section 3.1)

3. **Request user input** for problem, success criteria, scope, constraints

4. **Generate PRD** at `docs/core/PRD.md`

5. **System Mapping** — Create minimal `ARCHITECTURE.md`. Extend through [agentic discovery](#22-agentic-discovery) as you work.

6. **First story** at `docs/stories/`

7. **Begin work**

### 3.1 Optional: Codebase and Docs Index Tables

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

## 4. Planning Phase

No file modifications until story Approach section is complete.

**Required:**
1. Create/locate story in `docs/stories/`
2. Complete Approach (Steps, Risks, Verification)
3. Verify Context Scope (Write/Read/Exclude)
4. Then execute

**Small tasks:** Minimal story with one-line Steps is acceptable.

## 5. Document Lifecycle

**Core Docs** — Update in place. Don't preserve history—git does.

**Stories** — Create when planning, update during execution.
- **Planning stories** (deliverable = decision/breakdown): move when downstream execution stories are created.
- **Execution stories** (deliverable = code): move when acceptance criteria are met and code is merged.

Don't move execution stories until the code is actually done.

**Reference** — Read-only during execution. **Update `LESSONS.md` with new learnings.**

**LESSONS.md** — A living queue of actionable insights. Format: flat checklist. Check items when integrated into the harness. Remove checked items on cleanup. Unchecked = pending review.

**Skills** — Add/remove as needed.

**Logs** — Append session summaries.

**Verification passes:** Run a verification pass on architecture docs when:
- Major work lands (new subsystem, protocol change, architectural shift)
- Quarterly (whichever comes first)
- A lesson reveals a doc was wrong (update immediately)

**Curation:** Run Curator mode when 5+ lessons accumulate, or during quarterly verification. Curation proposes harness improvements as delta edits — never rewrite entire sections.

Verification = probe source, confirm line counts, remove hallucinated symbols,
update state lists, verify package descriptions from source not package.xml.

## 6. Context Scope

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

## 7. Skills

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

**Building:** Scan existing skills first, build minimal solution, persist to `docs/skills/<tool-name>/`, iterate.

## 8. Compaction

Move insights from working → persistent context.

**Triggers:** ~80% token utilization, story completion, session end.

**Process:** Summarize decisions, list artifacts, extract lessons to `LESSONS.md` (append as unchecked checklist items), write to `logs/`.

**Session exit gate:** Do not end a session without:
- Writing a session summary to `docs/logs/`
- Updating `LESSONS.md` if new lessons were learned

Compaction is not optional cleanup — it's how the harness accumulates wisdom.

## 9. Templates

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

- [ ] How will you know this is correct? (tests, commands, expected output)
- [ ] Update `docs/core/architecture/` if new subsystems discovered.

### Reflection
- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [ ] No new insights → proceed

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

### Curation Proposal

```markdown
## Curation: YYYY-MM-DD

### Promote to Harness
| Lesson | Harness Target | Delta Type | Proposed Text |
|--------|---------------|------------|---------------|
| | AGENTS.md §___ / skill / architecture | Add/Modify | |

### Deprecate
| Section | Current Text | Replacement | Rationale |
|---------|--------------|-------------|-----------|
| | | | |

### No Action
| Lesson | Rationale |
|--------|-----------|
| | |
```

## 10. Agent Guidelines

- Plan before executing
- Search before asking
- Skills for workflows, framework docs for APIs
- Prefer retrieval over training
- Read before writing
- Update, don't accumulate
- Compact proactively
- Notice friction — if you do the same thing twice, build a tool
- After story verification, ask: "What should be captured?"
- Skills for patterns, lessons for insights, docs for discoveries
- Stay in scope
- Be concise
- Test early
- Lint before done
- Use LSP, Context7 for accuracy
- Grow architecture incrementally
- Extend yourself — see Pi Principle

## 11. Git Boundaries

**The user owns the repository.**

**Read-only (always safe):** `git status`, `git log`, `git diff`, `git show`, `git branch`

**Requires explicit permission:** `git add`, `git commit`, `git push`, `git checkout`, `git reset`, `git revert`, `git stash`

**Never run without warning:** destructive commands (`--force`, `--hard`, `--amend` after push)

**Story identifiers:** STORY-XXX are internal harness artifacts. Use external ticket IDs (Jira, GitHub Issues) for commit messages, PRs, and external artifacts.

**Philosophy:** Your work product is code and docs, not commit history. Let the user control when changes land.

## 12. Pi Principle

Agents extend themselves by authoring tools, not downloading them.
Source: https://github.com/badlogic/pi-mono/

## 13. References

- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Claude Code: Best practices](https://www.anthropic.com/engineering/claude-code-best-practices)
