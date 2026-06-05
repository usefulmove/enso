# Agent Orchestration Surface

An orchestration surface is the persistent, inspectable contract layer between a
human and a swarm of agents — and between the agents themselves.

Enso is the harness that makes this surface deterministic, inspectable, and
compounding. This document walks through the idea.

---

## The Problem

When you use an AI model, the results can be inconsistent. Sometimes it nails it, sometimes it hallucinates or makes changes that don't make sense. The question most people ask is *"which model is best?"* That's usually the wrong question. A better question is *"what relevant information does the model have when it makes decisions?"* The difference often isn't the model — it's the context that the model runs in.

**The quality of a model's output depends on how well you manage context.**

Common failure modes:
- Hallucination — invents things
- Context rot — forgets what it knew earlier in the session
- Training lag — doesn't know your codebase, your system architecture, your conventions

All three are context problems. All three are solvable — by building a surface.

---

## The Surface

Before we talk about context engineering, let's define the surface.

An **orchestration surface** is the persistent, inspectable contract layer between a human and a swarm of agents — and between the agents themselves. Without a surface, every session starts cold. Decisions vanish. Lessons evaporate. The human becomes the memory system. In the Pygmalion framing: the maker is the human, the medium is the persistent substrate, and the figure is the orchestration surface the human relates to.

A surface is not just many interfaces. A pile of APIs is not a surface. A surface is a coherent collection of interfaces presented as one thing: the human touches it as one object, each interface has a role, the seams are intentional, transitions don't feel like abandonment, and the vocabulary is shared enough to become usable.

The surface makes three things possible:
- **Deterministic context** — agents read from and write to the same shared state
- **Inspectability** — the contract is visible, versioned, and verifiable
- **Compounding** — each session leaves the surface more capable than the last

### The Layers

**Working Context** — what's in the context window right now. Ephemeral and expensive.

**Persistent Context** — structured information that survives across sessions and evolves with the project. The harness instance. A structure with planning and architecture docs, active stories, lessons learned. This is the long-term memory layer — the surface's durable state.

**Reference Context** — discoverable. Docs on disk, search results. One tool call away from being in the context window. The substrate. The medium.

### The Stack

> "Models can't act"

A raw model can reason — it can write code, answer questions, plan. But it can't act in the world on its own. No tools. No memory. No persistence.

A harness instance fixes this by coupling a configured protocol to a durable substrate:

```
canonical stack
  a. model              # Claude Sonnet, GPT-5, Kimi K2.6
  b. runtime            # OpenCode, Claude Code, Codex, Cursor...
  c. harness protocol   # enso: rules, document schema, lifecycle
  d. harness instance   # This project's configured AGENTS.md, docs, skills — the surface
  e. agent instantiation # ephemeral task process summoned by runtime
  f. substrate          # codebase, docs, configs, repo state
```

The runtime exposes tools; the harness protocol defines *how* to use them. The harness instance lives on the substrate and persists context across agent instantiations. The surface is the contract layer between them.

### Surface Seams

| Seam | What crosses it | Direction |
|------|-----------------|-----------|
| **Human → Surface** | Intent, register, voice | Human enters the surface with goals |
| **Surface → Agent** | Routing, context handoff, specialization | Surface dispatches to the right specialist via Assign |
| **Agent → Agent** | Synthesis, verification, continuity | Specialists collaborate through shared context |
| **Agent → System** | Tools, runtime, mutation | Execution under harness rules |

---

## Agent Orchestration

An agent instantiation is a context transformer:

```
context_new = agent_instantiation(context_orig)
```

Each agent instantiation receives context through the surface, does work, and returns updated context. Chain them together — or run them in parallel — and you have an ensemble: a team of agent instantiations operating through a harness instance on a shared substrate.

Careful bite-sizing and context management — a detailed plan before building, one story (task) at a time — significantly increase agent instantiation accuracy. The context engineering layer is what makes that coordination reliable. The surface is what makes it persistent.

### The Six Operations

The harness protocol defines six primitives for managing context as a scarce resource:

- **Write** — Persist to durable storage
- **Select** — Load only what's needed now
- **Probe** — Search actively; don't assume
- **Compress** — Summarize to fit the token budget
- **Isolate** — Split work across scopes
- **Assign** — Match task to the right specialist on the surface

Together they cover the full lifecycle: persist what matters, load only what's needed, search before assuming, condense when full, divide what's too big, and match the right agent to the right task.

---

## Enso

What is enso?
- a harness protocol for an orchestration surface
- the infrastructure layer between user intent and model output

An agent bootstraps a structured environment — PRD, architecture, stories, lessons, skills, session logs. Every agent, every session, reads from and writes to the same shared surface. They remember. They stay accurate. They improve over time.

---

## The Pi Principle

> "Software building software. The agent extends itself."

The harness protocol draws from [Pi](https://github.com/badlogic/pi-mono/), a minimal agent with a powerful idea: agents should write their own extensions. When an agent encounters friction — a task done repeatedly, a complex procedure, a missing capability — it doesn't push through. It builds a tool.

**The self-extension loop:**
1. **Encounter friction** — a task you do repeatedly, a complex procedure, a missing capability
2. **Build the minimal solution** — a script, a skill, a helper
3. **Capture it** — persist to `docs/skills/` so it's discoverable
4. **Use it** — your future self benefits from your past work
5. **Iterate** — improve the tool as you use it

The most powerful agents aren't those with the most downloaded dependencies — they're the ones that have built the most custom tools for their specific workflows. Capabilities compound.

```
docs/
  core/       # source of truth — PRD, architecture
  stories/    # active units of work (like tickets)
  reference/  # long-term memory — lessons, conventions
  skills/     # on-demand capabilities — scripts, migrations
  logs/       # session history
```

One file. One command. A team of agents that remembers, stays accurate, and gets better over time — because the surface persists.
