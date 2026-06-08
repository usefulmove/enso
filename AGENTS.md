---
protocol: enso
version: 0.10.0
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

For the human-readable story of why seams matter, see `README.md`. This document is the protocol specification.

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
| Story Spec | `docs/reference/STORY.md` |

---

## 1. Purpose

**enso is a seam-oriented harness protocol for agentic work.**

A seam is a boundary where two behaviors meet and where one side can be changed without rewriting the other. Every seam has an **interface** (the contract that both sides agree to) and an **enabling point** (where you plug in a different driver). enso places intentional seams at every boundary where behavior changes hands in an agent system.

The major seams in enso:

| Seam | Interface | Enabling Point |
|------|-----------|----------------|
| Planning -> Execution | `enso.story/v1` story contract (frontmatter state + required sections) | The live story doc itself -- planned and reviewed before implementation |
| Role -> Role | Story state, role-owned sections, transition log, human gates | Planner, Generator, Evaluator, Human, and Orchestrator transitions over the same story instance |
| Ephemeral -> Persistent | Six operations (Write, Select, Probe, Compress, Isolate, Assign) | The agent's explicit choice to invoke Write instead of silently mutating context |
| Agent -> Codebase | Context Scope (Write / Read / Exclude) | The scoped file list loaded at runtime |
| Agent -> Capability | SKILL.md frontmatter (name, description, compatibility) | The scripts dropped into `docs/skills/<name>/` |
| Stance -> Protocol | `SOUL.md` / `AGENTS.md` dual-document structure | Which persona files are injected into the harness |
| Human -> Surface | Orchestration surface contract (AOS.md) | The specific tools, context, and voice configured in the harness instance |
| Self-improvement | Skill bootstrap protocol (§2.1, §7) | The agent authoring a new skill instead of rewriting its system prompt |

Every interface is a language. enso's vocabulary is its seam graph.

**Agent orchestration surface (AOS).** The surface is the persistent, inspectable contract layer between a human and a swarm of agents — and between the agents themselves. It is not just many interfaces or a pile of APIs; it is a coherent collection of interfaces presented as one thing. The human touches it as one object, each interface has a role, seams are intentional, transitions do not feel like abandonment, and the vocabulary is shared enough to become usable. Enso is the harness that makes it deterministic, inspectable, and compounding. File-based truth replaces vector-database drift. Context lives in verified docs and explicit state, session over session.

**Workflow:**
1. Bootstrap directory structure and fetch the canonical story spec
2. Request user input for problem, scope, constraints
3. Generate PRD
4. Create live `enso.story/v1` stories (`STORY-001+`)
5. Execute stories through Planner, Generator, and Evaluator roles with Human gates
6. Build tools as needed

**Story substrate:** `STORY-000` is reserved for the `enso.story/v1` specification. Live stories (`STORY-001+`) are persisted state objects containing the contract, current state, role outputs, verification evidence, and transition history for one unit of work.

**Goal:** Minimize tokens while maintaining verifiable, recursive workflows.

**Principle:** Software building software.

**enso is a harness protocol that realizes an orchestration surface.**
The protocol is runtime-agnostic: OpenCode, Claude Code, pi, and other hosts can implement the same seams with different discovery and configuration paths.
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

## 1.1 Why Seams Work

This is why the Pi Principle (§12) works: agents extend themselves by authoring tools **because those tools occupy a seam**.

When an agent writes a skill, it creates a stable contract (`SKILL.md`) and a swappable driver (the script). Future instantiations discover the contract without re-deriving the capability. The agent grows by extending the seam graph, not by bloating its system prompt.

Similarly, the stance → protocol seam means an agent's warmth or intensity lives in a document, not in weights. The interface is the dual-document structure; the enabling point is which files get loaded. This keeps the protocol legible while allowing the voice to adapt.

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

1. **Create core structure**
   ```bash
   mkdir -p docs/{core,stories,reference/completed,skills,logs}
   touch docs/reference/LESSONS.md
   if [ ! -f docs/reference/STORY.md ]; then
     curl -fsSL -o docs/reference/STORY.md https://raw.githubusercontent.com/usefulmove/enso/main/docs/reference/STORY.md
   fi
   ```

   **Wire skill discovery for your runtime** (choose one or more):
   ```bash
   # OpenCode
   mkdir -p .opencode
   ln -s ../docs/skills .opencode/skills

   # Claude Code
   mkdir -p .claude
   ln -s ../docs/skills .claude/skills

   # pi
   mkdir -p .pi
   ln -s ../docs/skills .pi/skills
   ```

2. **Optionally fill in Codebase/Docs Index tables** (see Section 3.1)

3. **Request user input** for problem, success criteria, scope, constraints

4. **Generate PRD** at `docs/core/PRD.md`

5. **System Mapping** — Create minimal `ARCHITECTURE.md`. Extend through [agentic discovery](#22-agentic-discovery) as you work.

6. **First live story** at `docs/stories/STORY-001.md` using `enso.story/v1`

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
| Story Spec | `docs/reference/STORY.md` |
```

## 4. Planning Phase

No implementation file modifications until the live story reaches `ready`.

**Required:**
1. Create/locate an `enso.story/v1` story in `docs/stories/`
2. Ensure frontmatter state, active role, scope, acceptance criteria, and verification are present
3. Planner completes `## Planner Output` with Steps, Risks, Assumptions, and Verification
4. Human approves the plan (`plan_review` -> `ready`) before generation
5. Verify Context Scope (Write/Read/Exclude)
6. Then execute only inside the declared Write scope

Apply §10.1 during planning: state assumptions, present tradeoffs, and stop if confused.

**Outcome-framed key results.** Acceptance criteria are the story's key results: write them as measurable, binary outcomes (what becomes true), not activities (what files change). Carry magnitude in a threshold (`p95 <= 200ms`), never a 0.0-1.0 grade; put baselines in the Goal as motivation; do not use stretch or optional criteria. Trivial or mechanical stories may state the activity directly (§2 instruction economy beats ceremony). The full contract ladder — Objective (Goal) -> Key Results (Acceptance Criteria) -> Proof (Verification) — is specified in `docs/reference/STORY.md`.

**Small tasks:** Minimal `enso.story/v1` stories are acceptable, but they still need acceptance criteria, verification, scope, and a transition log.

## 5. Document Lifecycle

**Core Docs** — Update in place. Don't preserve history—git does.

**Stories** — Live `enso.story/v1` state objects in `docs/stories/`.
- `STORY-000` is reserved for the specification and MUST NOT be used as an execution story.
- Live stories use concrete IDs (`STORY-001+`) and carry frontmatter state plus role-owned sections.
- Planning output is written under `## Planner Output`; implementation notes under `## Generator Iterations`; review under `## Evaluator Results`; decisions under `## Human Decisions`.
- Every state change appends `## Transition Log`.
- Do not move execution stories until they reach `done` or until the human explicitly closes/migrates them.
- Planning stories (deliverable = decision/breakdown) may move when downstream execution stories are created and the transition is logged.

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

**Discovery:** `docs/skills/` is enso's persistent source of truth. Runtimes discover skills from their own configuration paths, so expose `docs/skills/` to the active runtime with a symlink or runtime setting.

### Runtime discovery

| Runtime | Project discovery path(s) | Example wiring from repo root |
|---------|---------------------------|--------------------------------|
| OpenCode | `.opencode/skills/<name>/SKILL.md`, `.claude/skills/<name>/SKILL.md`, `.agents/skills/<name>/SKILL.md` | `mkdir -p .opencode && ln -s ../docs/skills .opencode/skills` |
| Claude Code | `.claude/skills/<name>/SKILL.md` | `mkdir -p .claude && ln -s ../docs/skills .claude/skills` |
| pi | `.pi/skills/<name>/SKILL.md`, `.agents/skills/<name>/SKILL.md`, configured skill paths | `mkdir -p .pi && ln -s ../docs/skills .pi/skills` |
| Other runtimes | Runtime-specific Agent Skills location | Follow the runtime's Agent Skills integration docs |

Use `.agents/skills/` when a runtime supports it and you want a shared agent-compatible path; otherwise use the runtime's native path.

**Frontmatter (Required):** Each SKILL.md must start with:
```yaml
---
name: <skill-name>              # Required: match directory name for Agent Skills compatibility; pi is lenient
description: <one sentence>     # Required: what it does AND when to use it
license: MIT                    # Required by enso
compatibility: <runtime-or-requirements> # Optional/freeform example: opencode, claude-code, pi, etc.
---
```

Without usable frontmatter, skills may not appear in discovery.

**Bootstrap:** During project setup, wire `docs/skills/` to your active runtime's discovery path (see the table above). Project-local skills take precedence according to the runtime's own precedence rules.

**Building:** Scan existing skills first, build minimal solution, persist to `docs/skills/<tool-name>/`, iterate.

## 8. Persistence

Move insights from working → durable context. This is not lossy compression —
nothing is discarded. Working state persists to logs, lessons, and stories.

**Skill:** Load the `session-persist` skill when ~80% token utilization is reached, at story completion, or at session end.

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

### Story (`enso.story/v1`)

`STORY-000` is reserved for the story specification. Live execution stories use `STORY-001+`. Fetch the full spec into `docs/reference/STORY.md` during bootstrap; use this compact template for new stories. Write acceptance criteria as outcome-framed, binary key results (see the contract ladder in `docs/reference/STORY.md`); trivial stories may state the activity directly.

```markdown
---
schema: enso.story/v1
id: STORY-001
title: Example story
state: seeded
active_role: planner
iteration: 0
max_iterations: 3
created_at: YYYY-MM-DDTHH:MM:SSZ
updated_at: YYYY-MM-DDTHH:MM:SSZ
priority: medium

scope:
  write:
    - path/to/file
  read:
    - docs/core/ARCHITECTURE.md
  exclude:
    - .git/

acceptance_criteria:
  - id: AC1
    text: Example criterion

verification:
  - id: V1
    command: npm test
    pass_when: exit_code == 0
---

# STORY-001 Example story
**Branch:** `{ticket-id}-{slug}` *(optional; omit for harness-only stories)*
**Worktree:** `~/repos/{ticket-id}-{slug}/` *(optional; use "not yet created" until created)*

## Goal

## Non-Goals

## Constraints

## Acceptance Criteria
- [ ] AC1 Example criterion

## Verification Contract
- [ ] V1 `npm test`

## Context Scope
**Write:**
- path/to/file

**Read:**
- docs/core/ARCHITECTURE.md

**Exclude:**
- .git/

## Planner Output

### Plan v1
**Date:** YYYY-MM-DD HH:MM

#### Summary

#### Steps
1.

#### Assumptions
-

#### Risks
-

#### Open Questions
-

## Generator Iterations

## Evaluator Results

## Human Decisions

## Evidence

### Verification Runs
| Verification ID | Command | Result | Exit Code | Output Ref |
|---|---|---|---|---|

### Changed Files
-

## Transition Log
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|

## Reflection
- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [ ] No new insights → proceed

**Do not begin generation until the plan is approved and state is `ready`.**
```

**Minimum story gate:** acceptance criteria, verification, scope, planner output, and transition log must be present before generation. Generator must not change the frozen contract after plan approval; evaluator must not edit implementation files; no agent may self-approve.

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
