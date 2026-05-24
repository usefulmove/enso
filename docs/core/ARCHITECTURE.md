# enso Architecture

## Overview

enso is a single-file seed protocol (`AGENTS.md`) that bootstraps an **agent orchestration surface** for AI agent collaboration. An orchestration surface is the persistent, inspectable contract layer between a human and a swarm of agents — and between the agents themselves. Drop `AGENTS.md` into any project, point an agent to it, and the agent creates the persistent context structure. The harness protocol is minimal by design — it grows through use.

## The Surface

The canonical stack separates concerns into distinct layers. The surface — the harness instance — lives in the middle: the contract layer that coordinates across seams.

| Layer | Role | Example |
|-------|------|---------|
| **Model** | Token generator / reasoning engine | Claude Sonnet, GPT-5, Kimi K2.6 |
| **Runtime** | Loop execution, tool dispatch, session host | OpenCode, Claude Code, Cursor, Codex |
| **Harness protocol** | Rules and artifact schema for agentic work | `enso` |
| **Harness instance** | Configured runtime + protocol + project state — the surface | This project's `AGENTS.md`, docs, skills, logs |
| **Agent instantiation** | Ephemeral task process summoned by the runtime | Each prompt loop execution |
| **Substrate** | Durable environment being read and transformed | Codebase, docs, configs, harness artifacts |

The harness instance is **coupled to** the substrate — adjacent and coextensive with the workspace, not external infrastructure. Agent instantiations do not persist; the harness instance and substrate do.

### Surface Seams

| Seam | What crosses it | Role |
|------|-----------------|------|
| **Human → Surface** | Intent, register, voice | The human enters the surface with goals and identity |
| **Surface → Agent** | Routing, context handoff, specialization | The surface dispatches to the right specialist via Assign |
| **Agent → Agent** | Synthesis, verification, continuity | Specialists collaborate through shared persistent context |
| **Agent → System** | Tools, runtime, mutation | Execution under harness rules |

---

## The North Star: enso as a Fold

### Why does enso exist?

AI agent sessions are ephemeral. Each session starts cold. Without a system for persisting and selecting context, every session re-derives what the last one already knew. The human becomes the memory. That doesn't scale.

enso exists to make context durable — to give agent instantiations a persistent substrate they can read from and write to across sessions. The surface is how that durability becomes a contract. But that framing undersells it. The deeper insight is this:

**enso is a recursive fold-forward(story, context).**

Or, at the step level, the primitive equation:

```
context_new = story(context_old)
```

A story is a function. It takes the current state of the world — the codebase, the decisions made, the lessons learned — and transforms it. The output becomes the input to the next story. A project is just repeated application of this function until the goals in the PRD are met.

This is not a metaphor. It is the execution model.

### What this means for each primitive

| Primitive | Role in the fold |
|-----------|-----------------|
| **PRD** | The termination condition — the fold stops when this is satisfied |
| **Story** | A single step function: `context_new = story(context_old)` |
| **Context Scope** | The function signature: `story :: context → context` — what it reads, what it writes, what it ignores |
| **Acceptance Criteria** | The postcondition — what must be true about `context_new` |
| **`session-persist`** | A checkpoint — serializes the accumulator between fold steps |
| **Session logs** | The fold trace — a record of each step's inputs and outputs |
| **LESSONS.md** | Accumulated invariants — truths that hold across all fold steps |
| **The scheduler** | Determines the sequence — what `story_n` is at each step |

### Why the scheduler is a missing primitive

The fold requires an ordered sequence of stories. Right now, that sequence is implicit — determined by filesystem mtime and human memory. There is no authoritative process table. The human is the scheduler.

A real OS doesn't work that way. The scheduler is a first-class subsystem. It maintains a process table: what work exists, in what state, in what priority order. The kernel consults it to decide what runs next.

enso needs the same thing. The process table is `docs/core/QUEUE.md`:

```
backlog → ready → running → blocked → done
```

`session-start` reads the queue and dispatches the highest-priority `ready` story. The human sets intent (priority, goals). enso manages execution order and state transitions.

### Why the story template is a function signature

If a story is `context_new = story(context_old)`, then its structure should reflect that:

- **Read scope** = the inputs the function depends on
- **Write scope** = the outputs the function produces
- **Exclude scope** = what the function explicitly does not touch
- **Acceptance criteria** = the postcondition that must hold on `context_new`

This is already in the story template. The north star makes it explicit: the Context Scope section is not bookkeeping. It is the type signature of the transformation.

### The curried form (advanced)

`context_new = story(context_old)` is the user-facing interface — the curried function that every session calls. The story file itself is the partial application. It binds the goal (specification) to produce a function that accepts only `context`.

The full, uncurried primitive lives beneath:

```
eval :: story_spec → agent_instantiation → context → context
```

A story is `eval` partially applied. The story template is the partial application syntax. The runtime completes the call with an agent instantiation.

### The logical conclusion

If context has a schema — a definition of what a valid accumulator looks like at any point in the fold — then enso can:

- Detect when a story's preconditions aren't met (dependency checking)
- Verify a story's postconditions (acceptance criteria as assertions, not prose)
- Safely hand off between sessions (serialize/deserialize the accumulator)
- Compose stories with confidence that the output of story N is a valid input for story N+1

That is the north star. enso is not a task tracker. It is a structured execution environment for transforming a codebase — one verified step at a time — across a persistent orchestration surface.

---

## Components

| Component | Responsibility | Seam Role |
|-----------|--------------|-----------|
| `AGENTS.md` | The harness protocol. Always-present instructions for any agent working in the project. Single source of truth for operations, lifecycle, and guidelines. | The surface protocol — the contract any agent reads when entering |
| `docs/core/` | Source of truth. PRD defines the problem and goals. ARCHITECTURE (this file) maps the system. | Durable contract state — the surface's persistent memory |
| `docs/stories/` | Active work items. One file per story. Each declares goal, acceptance criteria, context scope, and approach before execution begins. | The fold step — context transformation in progress |
| `docs/reference/` | Long-term memory. LESSONS.md accumulates patterns and gotchas. `completed/` holds finished stories. | Accumulated invariants — truths that hold across all fold steps |
| `docs/skills/` | Self-extension. Agent-authored scripts and procedures for vertical workflows. Agents build tools here. | Self-extension — the surface becomes more capable over time |
| `docs/logs/` | Session history. Written by `session-persist` after each session. | The fold trace — what happened, when |
| `session-start` | Session entry point. Loads core context, detects active story, bootstraps new projects. | Surface activation — human intent enters the system |
| `session-persist` | Persist working state. Extracts lessons, saves progress, prepares for session handoff (complete or pausing). | Checkpoint — serialize the accumulator |
| `read-session-logs` | Read-only log viewer. Shows recent session summaries and active stories. | Retrospective — inspect the fold trace |
| `enso-reference` | Quick reference. Shows skills, workflow, and live project status. | Onboarding — orient an agent entering the surface |
| `agent/` | Specialist definitions — Reasoner, Coder, Curator, Evaluator, etc. Templates for the Assign operation. | Routing layer — who does what on the surface |

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| Markdown for all persistence | Plain text, git-friendly, readable by any agent or human without tooling |
| Single-file seed (AGENTS.md) | Minimal adoption friction — one file starts the whole system |
| Agent-authored skills | Self-extension compounds over time; downloaded tools don't fit specific workflows |
| Human approves before writing | `session-persist` drafts first — human reviews, then confirms |
| Stories declare scope explicitly | Write/Read/Exclude boundaries prevent scope creep and context pollution |
| Skills for session lifecycle | Session skills (`session-start`, `session-persist`, `read-session-logs`, `enso-reference`) use standard `SKILL.md` frontmatter — runtime-agnostic, discoverable by any agent |
