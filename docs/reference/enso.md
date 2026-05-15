# Context Engineering and Agent Orchestration

An informal walkthrough and discussion.

---

## The Problem

When you use an AI model, the results can be inconsistent. Sometimes it nails it, sometimes it hallucinates or makes changes that don't make sense. The question most people as is *"which model is best?"* That's usually the wrong question. A better question is *"what relevant information does the model have when it makes decisions?"* The difference often isn't the model — it's the context that the model runs in.

**The quality of a model's output depends on how well you manage context.**

Common failure modes:
- Hallucination — invents things
- Context rot — forgets what it knew earlier in the session
- Training lag — doesn't know your codebase, your system architecture, your conventions

All three are context problems. All three are solvable.

---

## The Mental Model

The context window is working memory, and it's finite. Every token competes for attention. Most people don't think about this deliberately. That can be fine for small tasks, but it breaks down for tasks with real complexity.

> "Context engineering is the delicate art and science of filling the context window with just the right information for the next step." Andrej Karpathy

### The Layers

**Working Context** — what's in the context window right now. Ephemeral and expensive.

**Reference Context** — discoverable. Docs on disk, search results. One tool call away from being in the context window.

**Persistent Context** — structured information that survives across sessions and evolves with the project. The harness. A structure with planning and architecture docs, active stories, lessons learned. This is the long-term memory layer.

### The Harness

> "Models can't act"

A raw model can reason — it can write code, answer questions, plan. But it
can't act in the world on its own. No tools. No memory. No persistence.

A harness fixes this:

```
harness
  a. runtime        # OpenCode, Claude Code, Codex, Cursor...
  b. protocol       # enso: rules, document schema, lifecycle
  c. instance       # This project's configured AGENTS.md, docs, skills
  d. tools          # bridges between layers
     - web search
     - command shell (bash)
     - files, git (version control)
     - mcp servers, language server protocol (lsp)
     - compiler/interpreter, static analysis (linter), type checker, formatter
     - unit/regression tests
     - custom tools # databases, api's, skills
  e. agent instantiation # ephemeral task process summoned by runtime
```

Agent instantiations do not persist. The harness and substrate do.

(agent vs. model coding example)

*But giving a model tools doesn't fix the context problem. That requires something else.*

### Agent Orchestration

An agent instantiation can be used for context transformation:

```
context:new = agent_instantiation(context:orig)
```

Each agent instantiation receives context, does work, and returns an updated context. Chain
them together — or run them in parallel — and you have an ensemble: a team of
agent instantiations operating on a shared environment.

Careful bite-sizing and context management — a detailed plan before building,
one story (task) at a time — significantly increase agent instantiation accuracy. The
context engineering layer is what makes that coordination reliable.

### The Six Operations

The harness defines six primitives — Write, Select, Probe, Compress, Isolate, Assign — for managing context as a scarce resource. Together they cover the full lifecycle: persist what matters, load only what's needed, search before assuming, condense when full, divide what's too big, and match the right agent to the right task.

---

## Enso

What is enso?
- an agent harness for context management and agent orchestration
- the infrastructure layer between user intent and model output

An agent bootstraps a structured environment — PRD, architecture, stories, lessons, skills, session logs. Every agent, every session, reads from and writes to the same shared environment. They remember. They stay accurate. They improve over time.

---

## The Pi Principle

> "Software building software. The agent extends itself."

The harness draws from [Pi](https://github.com/badlogic/pi-mono/), a minimal agent with a powerful idea: agents should write their own extensions. When an agent encounters friction — a task done repeatedly, a missing capability — it doesn't push through. It builds a tool.

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

(demo)

