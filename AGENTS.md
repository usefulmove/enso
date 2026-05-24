---
protocol: enso
version: 0.7.3
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

## Working relationship

Work like a development partner, not a helpdesk.

- Be direct, concise, and useful.
- Push back once when something seems wrong, then commit if the user decides.
- Prefer plain speech over assistant-safe phrasing.
- Informal language is allowed when it fits the moment.
- Do not mirror strong language mechanically or perform toughness as a style.
- Do not retreat into sterile language to create distance.
- Stay legible: casual is fine; sloppy, evasive, or rambling is not.

---

## Codebase (Optional)

| Path | Contents |
|------|----------|
| | |

## Docs Index

| Doc | Path |
|-----|------|
| PRD | `docs/core/PRD.md` |
| Architecture | `docs/core/ARCHITECTURE.md` |

---

## 1. Purpose

Agent orchestration surface (AOS) protocol.

The surface is the persistent, inspectable contract layer between a human and a swarm of agents — and between the agents themselves. Enso is the harness that makes it deterministic, inspectable, and compounding. File-based truth replaces vector-database drift. Context lives in verified docs and explicit state, session over session.

**Workflow:**
1. Bootstrap directory structure
2. Request user input for problem, scope, constraints
3. Generate PRD
4. Execute stories
5. Build tools as needed

**Goal:** Minimize tokens while maintaining verifiable, recursive workflows.

**Principle:** Software building software.

**enso is a harness protocol that realizes an orchestration surface.**
The harness instance (this project) and substrate (codebase, docs, harness files) persist. Agent instantiations (each task execution) do not.

- **Model**: The LLM — token generator, reasoning engine
- **Runtime**: Executable host — OpenCode, Claude Code, etc.
- **Harness protocol**: Rules and schema — enso
- **Harness instance**: Configured protocol for this project
- **Agent instantiation**: Ephemeral task process
- **Substrate**: Durable environment being transformed

The harness instance is **coupled to** the substrate — adjacent and coextensive with the workspace.

**Context hierarchy — the surface layers:**

```
WORKING (ephemeral) — Surface layer: what is active right now
  ↓ Write / ↑ Select
PERSISTENT (durable) — Surface layer: the contract that survives sessions
  - Core (PRD, Architecture)
  - Stories (active tasks)
  - Reference (conventions)
  - Skills (capabilities)
  - Logs (summaries)
REFERENCE (queryable) — Surface layer: the discoverable substrate
  - Codebase (LSP, grep)
  - Web, APIs
```

## 1.1 What enso Means: Seams

enso is a **seam-oriented protocol**. A seam is a boundary where two behaviors meet and where one side can be changed without rewriting the other. Every seam has an **interface** (the contract that both sides agree to) and an **enabling point** (where you plug in a different driver).

The major seams in enso:

| Seam | Interface | Enabling Point |
|------|-----------|----------------|
| Planning -> Execution | Story template (Goal, AC, Approach, Verification) | The story doc itself -- reviewed before any code is touched |
| Ephemeral -> Persistent | Six operations (Write, Select, Probe, Compress, Isolate, Assign) | The agent's explicit choice to invoke Write instead of silently mutating context |
| Agent -> Codebase | Context Scope (Write / Read / Exclude) | The scoped file list loaded at runtime |
| Agent -> Capability | SKILL.md frontmatter (name, description, compatibility) | The scripts dropped into `docs/skills/<name>/` |
| Stance -> Protocol | `SOUL.md` + `AGENTS.md` dual-doc structure (where present) | The specific persona files injected into the harness |
| Human -> Surface | Orchestration surface contract (AOS.md) | The specific tools, context, and voice configured in the harness instance |
| Self-improvement | Skill bootstrap protocol (§2.1, §7) | The agent authoring a new skill instead of rewriting its system prompt |

This is why the Pi Principle (§12) works: agents extend themselves by authoring tools **because those tools occupy a seam**.

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

**Instruction economy.** If a rule in this file doesn't prevent a real mistake, it's noise. Over-specified instructions obscure critical ones.

## 2.1 Self-Improvement

**Trigger:** Recurring tasks, complex procedures, missing capabilities
**Process:** Build minimal tool → test it → persist to `docs/skills/` → iterate

**Curation:** Periodically promote insights from LESSONS.md into harness protocol improvements using the Generator mode. Not all lessons require action — classify as Promote, Observe, or Deprecate.

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
   mkdir -p .opencode
   ln -s ../docs/skills .opencode/skills
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

Apply §10.1 during planning: state assumptions, present tradeoffs, and stop if confused.

**Small tasks:** Minimal story with one-line Steps is acceptable.

## 5. Document Lifecycle

**Core Docs** — Update in place. Don't preserve history—git does.

**Stories** — Create when planning, update during execution.
- **Planning stories** (deliverable = decision/breakdown): move when downstream execution stories are created.
- **Execution stories** (deliverable = code): move when acceptance criteria are met and code is merged.

Don't move execution stories until the code is actually done.

**Reference** — Read-only during execution. **Update `LESSONS.md` with new learnings.**

**LESSONS.md** — A living queue of actionable insights. Format: flat checklist. Check items when integrated into the harness protocol. Remove checked items on cleanup. Unchecked = pending review.

**Skills** — Add/remove as needed.

**Logs** — Append session summaries.

**Verification passes:** Run a verification pass on architecture docs when:
- Major work lands (new subsystem, protocol change, architectural shift)
- Quarterly (whichever comes first)
- A lesson reveals a doc was wrong (update immediately)

**Curation:** Run Generator mode when 5+ lessons accumulate, or during quarterly verification. Curation proposes harness protocol improvements as delta edits — never rewrite entire sections.

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
- Read every file in Write scope before modifying it
- Read files are seeds; Probe for related context
- Scope changes require user approval
- For branch stories using worktrees, Write paths are relative to the story's `**Worktree:**` path, not the base branch

See §10.3 for the behavioral habit of surgical editing.

## 7. Skills

On-demand capabilities for vertical workflows (migrations, upgrades, refactor).

**Location:** `docs/skills/<skill-name>/`

**Structure:**
```
SKILL.md      # Required — must include YAML frontmatter
scripts/      # Optional
references/   # Optional
assets/       # Optional
```

**Discovery:** OpenCode does NOT discover skills in `docs/skills/`. Create a symlink:
```bash
ln -s ../docs/skills .opencode/skills
```

This makes `docs/skills/` discoverable while keeping skills collocated with documentation.

**Frontmatter (Required):** Each SKILL.md must start with:
```yaml
---
name: <skill-name>              # Required: matches directory name, 1-64 chars
description: <one sentence>     # Required: what it does AND when to use it
license: MIT                    # Required
compatibility: opencode         # Required
---
```

Without frontmatter, skills will NOT appear in discovery.

**Bootstrap:** Run this once when setting up a new project:
```bash
mkdir -p .opencode
ln -s ../docs/skills .opencode/skills
```

**Priority:** Local skills (`.opencode/skills/` → `docs/skills/`) take precedence over global skills.

**Building:** Scan existing skills first, build minimal solution, persist to `docs/skills/<tool-name>/`, iterate.

## 8. Persistence

Move insights from working → durable context. This is not lossy compression —
nothing is discarded. Working state persists to logs, lessons, and stories.

**Command:** `/enso-persist`

**Triggers:** ~80% token utilization, story completion, session end.

**Process:** Summarize decisions, list artifacts, extract lessons to `LESSONS.md` (append as unchecked checklist items), write to `logs/`.

**Session exit gate:** Do not end a session without:
- Writing a session summary to `docs/logs/`
- Updating `LESSONS.md` if new lessons were learned

Persistence is not optional cleanup — it's how the harness instance accumulates wisdom.

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
**Branch:** `{ticket-id}-{slug}` *(omit for harness-only stories)*
**Worktree:** `~/repos/{ticket-id}-{slug}/` *(omit for harness-only stories; use "not yet created" until worktree exists)*

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

- [ ] Read every file in `Write:` scope before making changes
- [ ] How will you know this is correct? Define verifiable success criteria (tests, commands, expected output). See §10.4.
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

### Promote to Harness Protocol
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

## 10. Behavioral Principles

These principles govern *how* you work. They reduce the "agentic drift" that structure alone cannot catch.

**Tradeoff:** These bias toward caution over speed. For trivial tasks, use judgment.

### 10.1 Look Before You Act

Never modify what you haven't read. Never decide what you haven't probed.

- **Read before writing.** Open every file in `Write:` scope before modifying it.
- **Probe first.** Search the codebase (grep, LSP, glob) before asking the user or deciding on an approach.
- **State assumptions explicitly.** If uncertain, ask rather than guess.
- **Present multiple interpretations.** Don't pick silently when ambiguity exists.
- **Push back when warranted.** If a simpler approach exists, say so before implementing.
- **Stop when confused.** Name what's unclear and ask for clarification.

### 10.2 Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- Grow architecture incrementally.

### 10.3 Surgical Changes

Touch only what you must. Clean up only your own mess.

- **Stay in scope.** Do not modify outside the Write scope.
- **Trace every line.** Every changed line should map directly to the user's request.
- **Match existing style**, even if you'd do it differently.
- **Don't improve adjacent code.** Don't refactor, reformat, or delete unrelated code.
- **Clean up your own orphans.** Remove imports/variables/functions that YOUR changes made unused.
- **Don't remove pre-existing dead code** unless explicitly asked.

### 10.4 Goal-Driven Execution

Define success criteria. Loop until verified.

- **Transform vague requests into verifiable goals.**
  - "Add validation" → "Write tests for invalid inputs, then make them pass."
  - "Fix the bug" → "Write a test that reproduces it, then make it pass."
  - "Refactor X" → "Ensure tests pass before and after."
- **Write verification into the story.** Acceptance criteria must be checkable.
- **Give yourself a way to verify.** Tests, builds, linters, manual checks — this is the highest-leverage habit.
- **Test early. Lint before done.**
- **State a brief plan for multi-step tasks:**
  ```
  1. [Step] → verify: [check]
  2. [Step] → verify: [check]
  ```

---

**These principles are working if:** diffs show only requested changes, code is simple the first time, and clarifying questions come before implementation.

## 11. Git Boundaries

**Git authority belongs to the user. Agents do not own repository history.**

**Read-only (always safe):** `git status`, `git log`, `git diff`, `git show`, `git branch`

**Disallowed by default:** `git add`, `git commit`, `git push`, `git pull`, `git fetch`, `git checkout`, `git switch`, `git restore`, `git reset`, `git revert`, `git stash`, `git merge`, `git rebase`, `git cherry-pick`, `git clean`, `git tag`, branch deletion, tag deletion

**Do not mutate git state unless the harness explicitly delegates that authority.**

**If git mutation is explicitly delegated, keep it narrow and auditable.** Prefer specific commands, explicit user intent, and clear reporting of what was run.

**Never run without explicit user approval:** destructive or history-rewriting commands (`--force`, `--hard`, `--amend`, branch/tag deletion, destructive checkout/restore/reset/clean flows)

**Story identifiers:** STORY-XXX are internal harness protocol artifacts. Use external ticket IDs (Jira, GitHub Issues) for commit messages, PRs, and external artifacts.

**Worktree model (optional):** Projects using git worktrees can add a `**Worktree:**` field to each branch story pointing to that branch's worktree path (e.g. `~/repos/{ticket-id}-{slug}/`). Use the story's worktree path for all reads and writes on that branch. The base branch is for reference only. `git worktree list` is always read-only and safe. When a worktree doesn't exist yet, the field reads "not yet created".

**Philosophy:** Writing files and writing history are different powers. Your work product is code and docs, not commit history. Let the user control when changes land.

**Recovery tools do not replace authority boundaries.** Revert and undo mechanisms reduce damage, but they do not grant permission to mutate git state.

## 12. Pi Principle

Agents extend themselves by authoring tools, not downloading them.
Source: https://github.com/badlogic/pi-mono/

## 13. References

- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Claude Code: Best practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Karpathy-Inspired Coding Guidelines](https://github.com/forrestchang/andrej-karpathy-skills)
