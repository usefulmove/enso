<div align="center">
  <img src="assets/enso-logo.png" alt="enso" />
</div>

**a context management structure for agentic coding**

```markdown
# enso

> Context is precious—treat it like RAM, not a hard drive.

The framework sees an LLM's context window as finite working memory. Every token competes for attention, so the goal is to keep only the smallest set of high-signal tokens needed for the next step.

Three key principles:
1. *Separate concerns*: Working context (what you're thinking now), Persistent context (docs that survive sessions), Reference context (codebase/external sources you search on-demand)
2. *Progressive disclosure*: Load only what you need, when you need it. Summaries before details. Don't assume—search first.
3. *Stay current, not historical*: Documents reflect the present state. Git tracks history; docs shouldn't accumulate cruft.

Six operations to manage this scarce resource: Write (persist), Select (load minimally), Probe (search actively), Compress (summarize when full), Isolate (split tasks), Assign (right agent for the job).
```

Enso is a single-file "seed" (`AGENTS.md`) that builds out a structured environment for agentic development. It replaces ad-hoc prompt engineering with protocols for managing context and tools. Enso treats context as data—each action is a unary transformation (context → context)—enabling recursive, discoverable, and versioned agentic workflows.

## The Problem

AI agents (Claude, Codex, Gemini) are powerful, but they suffer from **context rot**.
- They forget established patterns.
- They hallucinate details.
- They write code that conflicts with the architecture.
- They lose "lessons learned" between sessions.

**Enso solves this by giving the agent an Operating System.**

## Features

*   **Agentic Discovery:** Agents don't ask "what is this project?" They run `ls -R`, read configs, and build a mental map *before* talking to you.
*   **Retrieval-Led Reasoning:** Agents consult version-matched documentation in `docs/` instead of relying on training data—achieving 100% accuracy on framework-specific tasks vs 79% with on-demand approaches.
*   **Framework Documentation Index:** A discoverable, always-present knowledge base for framework APIs and patterns that agents consult automatically.
*   **Fractal Architecture:** Supports projects ranging from single scripts to massive monorepos using scalable `docs/` structures.
*   **Verification-First:** Agents are mandated to define **Test Plans** before writing code.
*   **Institutional Memory:** The "Reflexion Loop" captures lessons and anti-patterns in `LESSONS.md`, preventing repeat mistakes.
*   **MCP-Ready:** Designed to work seamlessly with (or without) the Model Context Protocol.

## Usage

### 1. Plant the Seed
Download `AGENTS.md` and place it in the root of your project.

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/dedmonds/enso/main/AGENTS.md
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

## License

MIT
