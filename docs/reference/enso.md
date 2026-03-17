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

**Near Context** — discoverable. Docs on disk, search results. One tool call away from being in the context window.

**Persistent Context** — structured information that survives across sessions and evolves with the project. The harness. A structure with planning and architecture docs, active stories, lessons learned. This is the long-term memory layer.

### Agents

> "Models can't act"

A raw model can reason — it can write code, answer questions, plan. But it
can't act in the world on its own. No tools. No memory. No persistence.

An agent fixes this:

```
agent
  a. model          # Claude Sonnet 4.6, GPT 5.3, Kimi K2.5, ...
  b. shaping        # specialization: coding, planning, research, ...
  c. tools          # bridges between layers, tools make the layers dynamic
     - web search
     - command shell (bash)
     - files, git (version control)
     - mcp servers, language server protocol (lsp)
     - compiler/interpreter, static analysis (linter), type checker, formatter
     - unit/regression tests
     - custom tools # databases, api's, skills (Anthropic agent skills)
  d. agentic loop   # self-directed execution pattern
```

(agent vs. model coding example)

*But giving a model tools doesn't fix the context problem. That requires something else.*

### Agent Orchestration

An agent can be used for context transformation:

```
context:new = agent(context:orig)
```

Each agent receives context, does work, and returns an updated context. Chain
them together — or run them in parallel — and you have an ensemble: a team of
agents operating on a shared environment.

Careful bite-sizing and context management — a detailed plan before building,
one story (task) at a time — significantly increase agent accuracy. The
context engineering layer is what makes that coordination reliable.

---

## Enso

What is enso?
- a context management / agent orchestration framework
- an agentic operating system (agentOS)

An agent bootstraps a structured environment — PRD, architecture, stories, lessons, skills, session logs. Every agent, every session, reads from and writes to the same shared environment. They remember. They stay accurate. They improve over time.

```
docs/
  core/       # source of truth — PRD, architecture
  stories/    # active units of work (like tickets)
  reference/  # long-term memory — lessons, conventions
  skills/     # on-demand capabilities — scripts, migrations
  logs/       # session history
```

(demo)

