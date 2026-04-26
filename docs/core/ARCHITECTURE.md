# enso Architecture

## Overview

enso is a single-file seed protocol (`AGENTS.md`) that bootstraps a context management system for AI agent collaboration. Drop it into any project, point an agent to it, and the agent creates the persistent context structure. The harness is minimal by design — it grows through use.

## The Three-Layer Model

enso separates concerns into three distinct layers, each with a single responsibility:

| Layer | Role | Function |
|-------|------|----------|
| **Kernel** (`opencode`) | The runtime | Raw execution: tool calls, file I/O, process lifecycle. The minimal substrate. |
| **Operating System** (`enso`) | The harness | Context management, scope enforcement, story scheduling, tool orchestration. Turns primitives into a usable workspace. |
| **Interpreter** (the model) | The evaluator | Reads intent, reasons, generates action. Does not manage memory or files—it executes logic within the OS it finds. |

This is the GNU/Linux model applied to agentic systems. The kernel provides the raw system calls, but without the OS layer, there is no coherent environment—just a process with no file system. The interpreter runs *inside* the OS; it does not *become* it. The harness is what persists, scopes, and schedules. The model just interprets.

---

## The North Star: enso as a Fold

### Why does enso exist?

AI agent sessions are ephemeral. Each session starts cold. Without a system for persisting and selecting context, every session re-derives what the last one already knew. The human becomes the memory. That doesn't scale.

enso exists to make context durable — to give the model a persistent substrate it can read from and write to across sessions. But that framing undersells it. The deeper insight is this:

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
| **`/enso-persist`** | A checkpoint — serializes the accumulator between fold steps |
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

`/enso-start` reads the queue and dispatches the highest-priority `ready` story. The human sets intent (priority, goals). enso manages execution order and state transitions.

### Why the story template is a function signature

If a story is `context_new = story(context_old)`, then its structure should reflect that:

- **Read scope** = the inputs the function depends on
- **Write scope** = the outputs the function produces
- **Exclude scope** = what the function explicitly does not touch
- **Acceptance criteria** = the postcondition that must hold on `context_new`

This is already in the story template. The north star makes it explicit: the Context Scope section is not bookkeeping. It is the type signature of the transformation.

### The curried form (advanced)

`context_new = story(context_old)` is the user-facing interface — the curried function that every session calls. The story file itself is the partial application. It binds the goal (specification) and identity (agent) to produce a function that accepts only `context`.

The full, uncurried primitive lives beneath:

```
eval :: story_spec → agent → context → context
```

A story is `eval` partially applied. The story template is the partial application syntax. The agent reading it completes the call.

### The logical conclusion

If context has a schema — a definition of what a valid accumulator looks like at any point in the fold — then enso can:

- Detect when a story's preconditions aren't met (dependency checking)
- Verify a story's postconditions (acceptance criteria as assertions, not prose)
- Safely hand off between sessions (serialize/deserialize the accumulator)
- Compose stories with confidence that the output of story N is a valid input for story N+1

That is the north star. enso is not a task tracker. It is a structured execution environment for transforming a codebase — one verified step at a time.

---

## Components

| Component | Responsibility |
|-----------|----------------|
| `AGENTS.md` | The harness protocol. Always-present instructions for any agent working in the project. Single source of truth for operations, lifecycle, and guidelines. |
| `docs/core/` | Source of truth. PRD defines the problem and goals. ARCHITECTURE (this file) maps the system. |
| `docs/stories/` | Active work items. One file per story. Each declares goal, acceptance criteria, context scope, and approach before execution begins. |
| `docs/reference/` | Long-term memory. LESSONS.md accumulates patterns and gotchas. `completed/` holds finished stories. |
| `docs/skills/` | Self-extension. Agent-authored scripts and procedures for vertical workflows. Agents build tools here. |
| `docs/logs/` | Session history. Written by `/enso-persist` after each session. |
| `/enso-start` | Session entry point. Loads core context, detects active story, bootstraps new projects. |
| `/enso-persist` | Persist working state. Extracts lessons, saves progress, prepares for session handoff (complete or pausing). |
| `/enso-log` | Read-only log viewer. Shows recent session summaries and active stories. |
| `/enso-help` | Quick reference. Shows commands, workflow, and live project status. |

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| Markdown for all persistence | Plain text, git-friendly, readable by any agent or human without tooling |
| Single-file seed (AGENTS.md) | Minimal adoption friction — one file starts the whole system |
| Agent-authored skills | Self-extension compounds over time; downloaded tools don't fit specific workflows |
| Human approves before writing | `/enso-persist` drafts first — human reviews, then confirms |
| Stories declare scope explicitly | Write/Read/Exclude boundaries prevent scope creep and context pollution |
| Global slash commands | `/enso-xxxx` commands live in `~/.config/opencode/commands/` — available in any project |
