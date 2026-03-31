# Agent Research Summary - March 30, 2026

Based on research of the latest state-of-the-art findings on agent harnesses, orchestration tooling, and context management, with specific recommendations for Enso and OpenCode workflows.

---

## 1. New Agent Harnesses & Frameworks

### The Harness Engineering Movement
The field has shifted from "prompt engineering" to **"harness engineering"** — designing the environment, constraints, and feedback loops that AI agents operate within. Key frameworks include:

- **Superpowers** (76.5K stars): TDD-driven autonomous dev workflow supporting Claude Code, Codex, Cursor, and OpenCode. Enforces red → green → refactor cycles with automated code review and branch cleanup.

- **Oh-my-claudecode / Oh-my-codex / Oh-my-openagent**: Team-first multi-agent orchestration with 21+ specialized agents (code reviewer, debugger, architect) that collaborate like a team.

- **OpenHarness**: A composable SDK based on Vercel's AI SDK for building general-purpose agents programmatically. Supports AGENTS.md, MCP integration, and subagent delegation.

- **Ouroboros**: Socratic intent extraction framework that prevents oscillation loops in agent reasoning.

### Agent Client Protocol (ACP) Maturation
OpenCode's ACP has become a standard for IDE integration:
- Zed has native ACP support
- OpenCode ACP enables session continuity across multiple sessions
- JSON-RPC 2.0 based communication with session management
- OpenClaw's `sessions_spawn` with `streamTo: "parent"` now provides orchestrator visibility into ACP harness streaming output (merged March 2026)

### Agent Harness Comparison (2026)
| Harness | Philosophy | Key Feature | Supported Agents |
|---------|-----------|-------------|------------------|
| Superpowers | TDD-driven | Enforced test-first workflow | Claude Code, Codex, Cursor, OpenCode |
| Oh-my-* | Team simulation | 21 specialized role agents | Claude Code, Codex, OpenCode |
| OpenHarness | Composable SDK | Vercel AI SDK base, MCP native | Custom |

*Note: Full output was truncated in run logs. Next run will include complete report via file output.*

---

*Generated: March 30, 2026*
*Job ID: ebd30d70-9d0d-48bf-b1df-e16c0ecd0fb9*
