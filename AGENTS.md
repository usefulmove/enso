# Context Engineering Protocol

A single-file seed for managing context across LLM agents, sessions, and tools.

## 1. Purpose

This protocol defines how to manage context when working with LLM agents on software projects. The workflow:

1. Drop this file into a project directory
2. Point an agent to it
3. Agent bootstraps the directory structure
4. Agent creates a PRD from conversation with human
5. Documents evolve as work unfolds, staying compact and focused

The goal: maintain the smallest set of high-signal tokens needed for the next step.

## 2. Principles

**Context is finite.** The context window is the agent's working memory. Every token competes for attention. Treat context as a scarce resource.

**Five operations manage context:**

| Operation | Action |
|-----------|--------|
| **Write** | Persist information outside the context window |
| **Select** | Pull relevant information into working context |
| **Probe** | Actively search (grep/glob/LSP) to discover unknown context |
| **Compress** | Summarize to retain only essential tokens |
| **Isolate** | Split context across agents or scopes |

**Keep current, not historical.** Documents reflect the present state. Git preserves history. Don't accumulate cruft in docs.

**Progressive disclosure.** Load context only when needed. Frontmatter before full docs. Summaries before details.

## 3. Terminology

| Term | Definition |
|------|------------|
| **Working Context** | Active tokens in the current LLM call. Ephemeral, limited by context budget. |
| **Persistent Context** | Markdown documents that survive across sessions. Includes Core, Stories, Reference, Skills, and Logs. |
| **Reference Context** | Queryable external sources: codebase (LSP, grep), RAG indexes, web. Not stored in the doc system. |
| **Compaction** | Summarizing working context into persistent context before it's lost. |
| **Context Budget** | The token limit of the model's context window. |
| **Context Scope** | Per-story declaration of file boundaries: what the agent can write, read, or must exclude. |

**Hierarchy:**

```
WORKING CONTEXT (ephemeral, token-limited)
    |
    | <- Select (load)     -> Write (persist)
    v                         v
PERSISTENT CONTEXT (markdown, durable)
  |-- Core Docs (PRD, Architecture, Standards)
  |-- Stories (active tasks)
  |-- Reference (conventions, completed work)
  |-- Skills (on-demand capabilities)
  |-- Logs (session summaries)

REFERENCE CONTEXT (external, queryable)
  |-- Codebase (LSP, grep, git)
  |-- RAG indexes
  |-- External sources (web, APIs)
```

## 4. Directory Structure

```
docs/
  core/           # Foundational docs (rarely change)
    PRD.md        # Problem, goals, scope, requirements
    ARCHITECTURE.md  # System design (or docs/core/architecture/ for complex systems)
    STANDARDS.md  # Coding conventions, patterns
  stories/        # Active units of work
  reference/      # Read-only knowledge
    LESSONS.md    # Shared learnings, anti-patterns, gotchas
    completed/    # Archived stories
  skills/         # On-demand capabilities (Agent Skills format)
  logs/           # Session summaries
```

## 5. Bootstrapping

When an agent encounters this file in a new project:

**Step 1: Create structure**
```bash
mkdir -p docs/{core,stories,reference/completed,skills,logs}
touch docs/reference/LESSONS.md
```

**Step 1b: Add retrieval-led reasoning instruction**
Add to root `AGENTS.md` (or equivalent agent config file):
```
IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning 
for framework-specific and domain-specific tasks. Always consult version-matched 
documentation in docs/ before implementing APIs or patterns.
```

**Step 2: Gather context**
Prompt the human for:
- What problem are we solving?
- What does success look like?
- What's in scope? What's out?
- Any known constraints?

**Step 3: Generate PRD**
Create `docs/core/PRD.md` from the conversation.

**Step 4: System Mapping**
Perform reconnaissance (`Probe`) to map the codebase.
- **Architecture:** Create `docs/core/ARCHITECTURE.md` (or `docs/core/architecture/` for complex systems).
- **Capabilities:** Identify reusable scripts/patterns (e.g., unit tests, linting) and document them in `docs/skills/`.
- **Conventions:** Update `docs/reference/` with observed standards.
- **Refinement:** If the system reality conflicts with the PRD, get clarity and update the PRD.

**Step 5: First story**
If the scope is clear, create the first story in `docs/stories/`.

**Step 6: Begin work**

## 6. Document Lifecycle

Context is living code. Refactor documentation as aggressively as you refactor code. Stale context is technical debt.

**Core Docs** (PRD, Architecture, Standards)
- Update in place when scope or direction changes
- Keep current—don't preserve history in the doc
- These are the source of truth

**Stories**
- Create when planning work
- Update during execution (notes, learnings)
- Move to `docs/reference/completed/` when done

**Reference**
- Conventions, patterns, and completed stories
- Read-only during execution
- Prune when no longer relevant
- **Update `LESSONS.md` with new learnings/anti-patterns**

**Skills**
- Add as capabilities are needed
- Update when procedures change
- Remove when obsolete

**Logs**
- Append session summaries after compaction
- Prune older logs when they no longer inform future work

## 7. Context Scope

Every story declares its context boundaries:

```markdown
## Context Scope

**Write** (files this task will modify):
- src/auth/login.ts
- src/auth/session.ts

**Read** (files for reference only):
- docs/core/ARCHITECTURE.md
- src/auth/types.ts

**Exclude** (ignore these):
- src/legacy/
- *.test.ts
```

**Enforcement:**
- Agent must not modify files outside Write scope
- Read files are a seed; use Probe to dynamically discover related context
- Agent should consult Read files before making changes
- Agent should avoid loading Excluded paths into context
- Scope changes require explicit human approval

## 8. Skills

Skills are discoverable, on-demand capabilities for **vertical, action-specific workflows** 
(e.g., migrations, upgrades, explicit transformations). They follow the [Agent Skills specification](https://agentskills.io/specification).

**When to use Skills vs. Documentation:**
- **Skills**: One-time actions (migrate to App Router, upgrade framework version, apply refactoring)
- **AGENTS.md + docs/core/**: Always-available framework knowledge and patterns

Note: Skills require agent decision to invoke and are only triggered ~56% of the time by default. 
For knowledge that must be consistently applied across tasks, use persistent context in AGENTS.md instead.

**Location:** `docs/skills/`

**Structure:**
```
docs/skills/
  duckdb-sql/          # Example: data analysis and querying skill
    SKILL.md           # Required: frontmatter + when to use
    scripts/           # Optional: executable code
      analyze_schema.py
      query_runner.py
    references/        # Optional: additional docs
      optimization_tips.md
    assets/            # Optional: templates, data files
```

**Required frontmatter:**
```yaml
---
name: duckdb-sql
description: Query and analyze DuckDB databases with SQL. Use for data exploration, 
             schema introspection, and analytical queries. For general SQL patterns, 
             consult docs/core/framework/ instead.
---
```

**Progressive disclosure:**
1. Agent scans `docs/skills/` directories at session start
2. Agent reads frontmatter (~100 tokens per skill) for discovery
3. Agent loads full `SKILL.md` only when activating a skill
4. Agent loads `scripts/`, `references/`, `assets/` only when needed

**Skills may reference other skills.** Agent follows references as needed.

## 8.1. Framework Documentation Index

For framework-specific knowledge (APIs, patterns, conventions), add a documentation index to root `AGENTS.md`:

**Setup:**
1. Store version-matched docs in `docs/core/framework/`
2. Add index section to root `AGENTS.md` with links to relevant doc files
3. Agent reads specific files from the index as needed

**Example format:**
```markdown
## Framework Documentation
Location: docs/core/framework/

| Section | Files |
|---------|-------|
| Routing | routing.md, navigation.md |
| Caching | cache-directives.md, cache-lifecycle.md |
| Data Fetching | connection.md, suspense.md |
| Authentication | auth-setup.md, session.md |
```

**Why this works:**
- **Always present** (no invocation decision needed)
- **Available on every turn** (included in system prompt)
- **Standard Markdown** (no custom formats or compression)
- **Retrieval-led**: Agent consults docs rather than relying on training data

This approach achieves 100% accuracy on framework-specific tasks compared to 79% with on-demand skills.

## 9. Compaction

Compaction moves insights from working context to persistent context.

**Triggers:**
- Approaching context budget (~80% utilization)
- Completing a story or major task
- Conversation becoming circular or confused
- Ending a session

**Process:**
1. Summarize key decisions and insights
2. List artifacts created or modified
3. Extract reusable lessons to `docs/reference/LESSONS.md`
4. Note open items and next steps
5. Write summary to `docs/logs/YYYY-MM-DD-topic.md`
6. Update core docs if new patterns or decisions emerged
7. Continue with fresh working context

## 10. Templates

Templates are guidelines, not rigid forms. Start minimal, expand as needed.

### PRD

**Start with (required):**

```markdown
# [Project Name] PRD

## Problem
What problem are we solving? Why does it matter?

## Goals
What does success look like? How will we measure it?

## Scope
**In scope:**
- ...

**Out of scope:**
- ...
```

**Expand when ready:**

```markdown
## Requirements
**Functional:**
- ...

**Non-functional:**
- ...

## Constraints
- ...
```

### Architecture

Create when the system has multiple components or non-obvious structure. For complex systems, use a directory `docs/core/architecture/` with an `OVERVIEW.md` and component-specific files.

```markdown
# [Project Name] Architecture

## Overview
High-level description of the system.

## Components
| Component | Responsibility |
|-----------|----------------|
| ... | ... |

## Key Decisions
| Decision | Rationale |
|----------|-----------|
| ... | ... |

## Tech Stack
- ...

## Integration Points
- ...
```

### Story

```markdown
# [STORY-ID] [Title]

## Goal
What are we trying to accomplish? Why now?

## Acceptance Criteria
- [ ] ...
- [ ] ...

## Context Scope
**Write:**
- ...

**Read:**
- ...

**Exclude:**
- ...

## Approach & Verification Plan
High-level implementation strategy and how to verify success (automated tests, manual steps).

## Notes
(Fill during/after implementation)
```

### Framework Documentation Index

Create when your project uses a framework with evolving APIs (Next.js, React, etc.):

```markdown
## Framework Documentation
Location: docs/core/framework/

| Section | Files |
|---------|-------|
| [Section Name] | file1.md, file2.md |
| [Section Name] | file3.md, file4.md |
```

**Guidelines:**
- Keep this table concise; link to actual doc files in `docs/core/framework/`
- Include version info in AGENTS.md if maintaining multiple versions
- Update table when adding new framework docs
- Agent will consult relevant files when working on framework tasks

### Session Summary

```markdown
# Session: [Topic]
**Date:** YYYY-MM-DD

## Overview
What was accomplished this session.

## Key Decisions
- ...

## Artifacts Modified
- ...

## Open Items
- ...

## Next Steps
- ...
```

## 11. Agent Guidelines

**Search first.** Exhaust search tools (grep, glob, LSP) before asking for file paths or context.

**Tool Selection.** Use `docs/skills/` for vertical, action-specific workflows (migrations, upgrades). Use `docs/core/framework/` and documentation indexes for framework-specific knowledge. Use external tools (MCP, LSP) for general language reference and code navigation.

**Prefer retrieval over training.** Always consult `docs/` for framework-specific implementation details rather than relying on potentially outdated training data.

**Read before writing.** Always consult the Context Scope. Read the Read files before modifying Write files.

**Update, don't accumulate.** Modify existing docs to reflect current state. Don't append history—git tracks that.

**Compact proactively.** Don't wait for context overflow. Summarize and persist insights regularly.

**Stay in scope.** Don't modify files outside the story's Write scope without explicit approval.

**Be concise.** Terse, technical communication. No filler.
