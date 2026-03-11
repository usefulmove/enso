# Goal: Effective agent orchestration

[agent orchestration flow :: diagram](../../assets/agent-orchestration-flow.png)

Agent orchestration: the coordination of the actions of multiple agents acting
on a common set of files (codebase, communication, plan, documentation, custom
tools) in a common environment.

> So, how do you get there?

# Model

Models are inaccurate and not useful enough on their own. How do we make them better?

Two distinct problems:
a. Models can't act
b. Models are inaccurate

# Agent

> "Models can't act"

A raw model can reason — it can write code, answer questions, plan. But it
can't act in the world on its own. No tools. No memory. No persistence.

An agent fixes this:

a. model          # claude-sonnet-4-6, kimi-k2
b. shaping        # specialization: coding, planning, research
c. tools
   - web search
   - bash
   - files, git
   - mcp servers, lsp
   - compliler, static analysis (linter), type checker, formatter
   - unit/regression tests
   - custom skills (Anthropic agent skills spec)
   - custom tools # database, etc.
d. agentic loop   # self-directed execution pattern

# Context Engineering

> "Models are inaccurate"

Models are only as accurate as the context they receive. You can improve
accuracy by improving the environment the model runs inside.

Three sources of inaccuracy:
- **Hallucination** — the model invents things that aren't true
- **Context rot** — the model forgets what it knew earlier in the session
- **Training lag** — the model doesn't know your specific codebase, your
  conventions, your architecture

The solution is a Context Management System (CMS) — a structured environment
that gives every agent the right information at the right time.

Three layers:

1. **Context window** — working memory. Ephemeral. Expensive. What's active
   right now.

2. **Discoverable context** ("agentic discovery") — files on disk, codebase
   search, docs. One tool call away. The agent can reach for it, if it
   knows to look.

3. **Persistent context** — structured information that survives across
   sessions and evolves with the project. This is what enables:
   - session-to-session continuity
   - agent-to-agent coordination (hand-offs)
   - iterating on a plan, codebase, knowledgebase, custom tools across sessions
   - plan-build-test lifecycles and task decomposition
 
With a persistent context layer, agents can iterate to build solutions to
bigger problems than any single session allows.

# Agent Orchestration

An agent can be used for context transformation:

[agent orchestration flow :: diagram](../../assets/visual-flow.svg)

```
new:context = agent(orig:context)
```

Each agent receives context, does work, and returns an updated context. Chain
them together — or run them in parallel — and you have an ensemble: a team of
agents operating on a shared environment.

Careful bite-sizing and context management — a detailed plan before building,
one story (task) at a time — significantly increase agent accuracy. The
context engineering layer is what makes that coordination reliable.

# enso

What is enso?
- an agentic operating system (agentOS)
- a context engineering / agent orchestration framework

enso is a single file (`AGENTS.md`) that seeds the entire system. Drop it in
a project root. The agent bootstraps the structure, probes the codebase,
drafts a PRD, and is ready to work — in minutes.

What it gives you:
- A shared environment (persistent context) that all agents read and write
- A standard `docs/` structure: plans, stories, lessons, skills, logs
- A protocol for session management: start focused, compact when full,
  hand off cleanly
- A compounding skill library: tools built during work are captured and
  reusable in future sessions
- The Six Operations: Write, Select, Probe, Compress, Isolate, Assign

```
docs/
  core/       # source of truth — PRD, architecture
  stories/    # active units of work (like tickets)
  reference/  # long-term memory — lessons, conventions
  skills/     # on-demand capabilities — scripts, migrations
  logs/       # session history
```

One file. One command. A team of agents that remembers, stays accurate,
and gets better over time.
