# enso

**The emacs of agent orchestrators.** Software that builds software.

Enso is an **agent harness** — the infrastructure layer that constrains, informs, verifies, and corrects AI agents in production. The harness encompasses everything between user intent and model output that is not the language model itself: context assembly, tool orchestration, verification loops, cost controls, and observability.

> *"The model is the horse—powerful but directionless. The harness is the tack, reins, and training that channels that power toward useful work without letting it run wild."*

The harness sees an LLM's context window as finite working memory. Every token competes for attention, so the goal is to keep only the smallest set of high-signal tokens needed for the next step.

## What is an Agent Harness?

An agent harness is everything between user intent and model output that is not the language model itself. It provides:

- **Context engineering** — what the agent knows and when
- **Architectural constraints** — boundaries, allowed tools, dependency rules
- **Verification loops** — tests, linters, output validation
- **Feedback mechanisms** — retries, self-correction, entropy management
- **Lifecycle management** — state, memory across sessions, task orchestration

The harness is the "80% factor" in agent reliability. Same model with a better harness can dramatically improve performance. The discipline of building these systems is **harness engineering**—the evolution beyond prompt engineering and context engineering.

> "[Context engineering is ...] the delicate art and science of filling the context window with just the right information for the next step." Andrej Karpathy

Three key principles:
1. *Separate concerns*: Working context (what you're thinking now), Persistent context (docs that survive sessions), Reference context (codebase/external sources you search on-demand)
2. *Progressive disclosure*: Load only what you need, when you need it. Summaries before details. Don't assume—search first.
3. *Stay current, not historical*: Documents reflect the present state. Git tracks history; docs shouldn't accumulate cruft.

Six operations to manage this scarce resource: Write (persist), Select (load minimally), Probe (search actively), Compress (summarize when full), Isolate (split tasks), Assign (right agent for the job).

Enso is a single-file "seed" (`AGENTS.md`) that builds out a structured environment for agentic development. It replaces ad-hoc prompt engineering with protocols for managing context and tools. Enso treats context as data—each action is a unary transformation (context → context)—enabling recursive, discoverable, and versioned agentic workflows.

## The Problem

AI agents (Claude, Codex, Gemini) are powerful, but they suffer from **context rot**.
- They forget established patterns.
- They hallucinate details.
- They write code that conflicts with the architecture.
- They lose "lessons learned" between sessions.

**Enso solves this by giving the agent a harness.**

## Why Harness Engineering Matters

The harness is the "80% factor" in agent reliability. Research shows:

- **Vercel**: Using AGENTS.md as persistent context achieved a **100% pass rate** vs. **79%** for on-demand skill retrieval — a **+21 percentage point improvement** ([source](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals))
- **LangChain**: Same model (Claude Opus 4.6), different harness: improved from **Top 30 to Top 5** on Terminal Bench 2.0 by optimizing the harness alone ([source](https://blog.langchain.dev/the-anatomy-of-an-agent-harness/))

> *"Agent = Model + Harness. The model contains the intelligence; the harness makes that intelligence useful."* — LangChain

## Features

*   **Agentic Discovery:** Agents don't ask "what is this project?" They run `ls -R`, read configs, and build a mental map *before* talking to you.
*   **Retrieval-Led Reasoning:** Agents consult version-matched documentation in `docs/` instead of relying on training data. This is a structured form of RAG — retrieval-augmented generation — where retrieval is deterministic and file-based rather than probabilistic and vector-based, keeping latency low and accuracy high. Vercel's agent evals found that always-present context achieved a 100% pass rate vs. 79% for on-demand skill retrieval — even with explicit instructions to use skills. ([source](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals))
*   **Framework Documentation Index:** A discoverable, always-present knowledge base for framework APIs and patterns that agents consult automatically.
*   **Plan-Before-Execute:** Agents are required to create a story and complete the Approach section—Steps, Risks, and Verification—before modifying any file. Planning is not optional; it is the first act of execution.
*   **Context Scope:** Every story declares explicit Write/Read/Exclude file boundaries. Agents cannot modify files outside their declared scope without explicit approval, keeping changes focused and reviewable.
*   **Fractal Architecture:** Supports projects ranging from single scripts to massive monorepos using scalable `docs/` structures.
*   **Adaptive Scaffolding:** Automatically detects project type (React, Python, Node.js, etc.) and tailors documentation structure, conventions, and templates to match the ecosystem.
*   **Verification-First:** Agents are mandated to define **Test Plans** before writing code.
*   **Institutional Memory:** The "Reflexion Loop" captures lessons and anti-patterns in `LESSONS.md`, preventing repeat mistakes.
*   **Self-Extending Agents:** When agents encounter friction—repetitive tasks, complex procedures, missing capabilities—they build tools. Scripts and skills are persisted to `docs/skills/` and reused across sessions. Capabilities compound over time; the agent becomes uniquely capable for its specific domain.
*   **MCP-Ready:** Designed to work seamlessly with (or without) the Model Context Protocol.

## Usage

### 1. Plant the Seed
Download `AGENTS.md` and place it in the root of your project.

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/usefulmove/enso/main/AGENTS.md
```

### 2. Activate an Agent
Point your agent manager (OpenCode, Cursor, Claude Code, Windsurf) to the file:

> "Read @AGENTS.md and bootstrap this project."

### 3. Watch it Grow

Enso acts as a Context Manager. It will ask you for the problem statement and constraints, then build out the context management structure.

The agent will:
1.  **Bootstraps** the `docs/` directory structure.
2.  **Probes** your codebase to understand the architecture.
3.  **Drafts** your `PRD.md` and `ARCHITECTURE.md`.
4.  **Aligns** with you on the next unit of work.

## The Six Operations

The context window is a spotlight—you can illuminate only so much at once. The Six Operations select what is lit, what's just off-stage, and when to change scenes.

| Operation | What It Does | Why It Matters |
|-----------|--------------|----------------|
| **Write** | Save insights to disk before they're lost | Working memory is temporary; persistence survives sessions |
| **Select** | Load only what's needed right now | Don't waste tokens on irrelevant context |
| **Probe** | Actively search (grep, LSP, glob) for answers | Don't assume you know what's in the codebase |
| **Compress** | Summarize to fit the token budget | When context gets full, condense instead of dropping |
| **Isolate** | Split work across multiple scopes | Divide complex tasks to stay within limits |
| **Assign** | Choose the ideal agent for each task | Match task requirements to agent capabilities |

## Directory Structure

Enso creates a standard, predictable hierarchy that agents can navigate blindly:

```text
docs/
  core/           # Source of Truth (PRD, Architecture)
  stories/        # Active Units of Work (The "Ticket" system)
  reference/      # Long-term Memory (Lessons, Conventions)
  skills/         # Local Capabilities (Scripts, Tests)
  logs/           # Session History
```

## The Pi Principle

Enso draws inspiration from [Pi](https://github.com/badlogic/pi-mono/), a minimal coding agent built around one core idea: **agents should extend themselves**.

Rather than downloading pre-built tools, Pi agents write their own extensions. When they need new functionality, they build it. The result is software that writes more software—an agent that becomes increasingly capable over time by authoring its own tooling.

**The self-extension loop:**
1. **Encounter friction** — a task you'll do again, a complex procedure, a missing capability
2. **Build the minimal tool** — a script, skill, or helper that solves the specific need
3. **Capture it** — persist to `docs/skills/` so it's discoverable in future sessions
4. **Use it** — future sessions benefit from past work
5. **Iterate** — improve the tool as you use it

The compounding effect: a tool built today saves derivation cost in every future session. After months of work, an agent should have dozens of custom tools tailored to its specific workflows and codebase—not downloaded dependencies, but authored capabilities.

> *"The most powerful agents are not those with the most downloaded dependencies, but those that have built the most custom tools for their specific workflows."*

## License

MIT
