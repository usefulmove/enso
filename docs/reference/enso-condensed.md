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

**Near Context** — discoverable. Docs on disk, search results. One tool call away.

**Persistent Context** — structured information that survives sessions and evolves with the project. Planning docs, architecture, active stories, lessons learned. Long-term memory.

### Agents

A raw model can reason but can't act — no tools, no memory, no persistence. An agent adds:

```
agent
  a. model          # Claude Sonnet 4.6, GPT 5.3, Kimi K2.5, ...
  b. shaping        # specialization: coding, planning, research, ...
  c. tools          # bridges between layers
     - web search, command shell, files, git
     - mcp servers, lsp, compiler, linter, tests
     - custom tools: databases, apis, skills
  d. agentic loop   # self-directed execution pattern
```

*But giving a model tools doesn't fix the context problem. That requires something else.*

### Agent Orchestration

An agent can be used for context transformation:

```
context:new = agent(context:orig)
```

Chain them together — or run them in parallel — and you have an ensemble: a team of agents operating on a shared environment. Careful bite-sizing and context management (detailed plan upfront, one story at a time) significantly increase accuracy. Context engineering is what makes that coordination reliable.

---

## Enso

Enso is a context management and agent orchestration framework — an agentic operating system (agentOS).

An agent bootstraps a structured environment. Every agent, every session, reads from and writes to the same shared environment. They remember. They stay accurate. They improve over time.

```
docs/
  core/       # source of truth — PRD, architecture
  stories/    # active units of work (like tickets)
  reference/  # long-term memory — lessons, conventions
  skills/     # on-demand capabilities — scripts, migrations
  logs/       # session history
```
