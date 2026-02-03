# enso

**a context management structure for agentic coding**

Enso is a single-file "seed" (`AGENTS.md`) builds out a high-performance environment for agentic development. It replaces ad-hoc prompt engineering with a structured, rigorous protocol for managing context, agentic discovery, and tools.

## The Problem

AI agents (Claude, Codex, Gemini) are powerful, but they suffer from **context rot**.
- They forget established patterns.
- They hallucinate details.
- They write code that conflicts with the architecture.
- They lose "lessons learned" between sessions.

**Enso solves this by giving the agent an Operating System.**

## Features

*   **Autonomic Discovery:** Agents don't ask "what is this project?" They run `ls -R`, read configs, and build a mental map *before* talking to you.
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

### 2. Activate the Agent
Point your agent manager (OpenCode, Cursor, Claude Code, Windsurf) to the file:

> "Read @AGENTS.md and bootstrap this project."

### 3. Watch it Grow

Enso acts as a Context Manager. It will ask you for the problem statement and constraints, then build out the context management structure.

The agent will:
1.  **Bootstraps** the `docs/` directory structure.
2.  **Probes** your codebase to understand the architecture.
3.  **Drafts** your `PRD.md` and `ARCHITECTURE.md`.
4.  **Aligns** with you on the next unit of work.

## The Protocol

Enso operates on five core primitives to manage the finite context window:

| Operation | Action |
|-----------|--------|
| **Write** | Persist information outside the context window |
| **Select** | Pull relevant information into working context |
| **Probe** | Actively search (grep/glob/LSP) to discover unknown context |
| **Compress** | Summarize to retain only essential tokens |
| **Isolate** | Split context across agents or scopes |

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
