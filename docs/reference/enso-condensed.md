# Context Engineering and Agent Orchestration

---

## The Problem

AI output quality is inconsistent — not because of the model, but because of context. The better question isn't *"which model is best?"* — it's *"what relevant information does the model have when it makes decisions?"*

**The quality of a model's output depends on how well you manage context.**

Common failure modes:
- **Hallucination** — invents things
- **Context rot** — forgets what it knew earlier in the session
- **Training lag** — doesn't know your codebase, architecture, or conventions

All three are context problems. All three are solvable.

---

## The Mental Model

The context window is working memory — finite, and every token competes for attention.

> "Context engineering is the delicate art and science of filling the context window with just the right information for the next step." — Andrej Karpathy

### The Layers

**Working Context** — what's in the context window right now. Ephemeral and expensive.

**Reference Context** — discoverable. Docs on disk, search results. One tool call away.

**Persistent Context** — structured information that survives sessions and evolves with the project. Planning docs, architecture, active stories, lessons learned. Long-term memory.

### The Canonical Stack

A model alone can reason but can't act. The full stack separates concerns so each layer does one thing well:

```
model              # token generator / reasoning engine — Claude, GPT, Kimi, ...
runtime            # executable host that exposes tools — OpenCode, Claude Code, ...
  └─ tools         # bridges between layers: web search, shell, files, git, MCP, LSP, tests, ...
harness protocol   # rules and schema — enso
harness instance   # configured protocol for this project
agent instantiation # ephemeral task process running on the runtime
substrate          # durable environment being transformed (codebase, docs, infra)
```

The runtime exposes tools; the harness protocol defines *how* to use them. The harness instance lives on the substrate and persists context across agent instantiations.

### Agent Orchestration

An agent instantiation transforms context through a harness instance on a substrate:

```
context:new = agent_instantiation(context:orig)
```

Chain them together — or run them in parallel — and you have an ensemble: multiple agent instantiations operating on a shared substrate through the same harness instance. Careful bite-sizing and context management (detailed plan upfront, one story at a time) significantly increase accuracy. Context engineering is what makes that coordination reliable.

### The Six Operations

Write · Select · Probe · Compress · Isolate · Assign — six primitives for managing context as a scarce resource.

---

## Enso

Enso is a harness protocol — the rules and schema that constrain, inform, verify, and correct agent instantiations in production.

A harness instance bootstraps a structured substrate. Every agent instantiation reads from and writes to the same shared environment. They remember. They stay accurate. They improve over time.

---

## The Pi Principle

> "Software building software. The agent extends itself."

Inspired by [Pi](https://github.com/badlogic/pi-mono/): when an agent instantiation encounters friction, it builds a tool. Captures it to `docs/skills/`. Reuses it. Iterates. Capabilities compound — a month of work should leave the harness instance significantly more capable than when it started.

```
docs/
  core/       # source of truth — PRD, architecture
  stories/    # active units of work (like tickets)
  reference/  # long-term memory — lessons, conventions
  skills/     # on-demand capabilities — scripts, migrations
  logs/       # session history
```
