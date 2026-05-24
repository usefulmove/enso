# enso PRD

## Problem

AI agent sessions are ephemeral. There is no persistent contract layer — no surface — between a human and the agents they work with. Every session starts cold. Decisions vanish. Lessons evaporate. The human becomes the memory system. The result is repeated derivation, drift from intent, and high orchestration overhead.

Without an **orchestration surface**, agents cannot coordinate. They cannot hand off. They cannot compound. They forget what they knew, violate their own conventions, and treat every task like opening night with no rehearsal.

## Goals

1. Enable reliable, persistent AI collaboration across sessions and tools through a project-local orchestration surface
2. Treat context as a scarce resource — load only what's needed, persist before it's lost
3. Make the surface self-extending through agent instantiations — agents author capabilities that persist across sessions
4. Reduce cold-start cost through structured persistent context (PRD, stories, logs, lessons)
5. Make the surface usable by any agent in any project via a single-file seed (AGENTS.md)
6. Enable multi-agent coordination through a shared, inspectable contract layer — specialists (Coder, Reasoner, Evaluator, Curator, etc.) activated by the Assign operation and coordinated through shared context

## Scope

**In scope:**
- Harness protocol (AGENTS.md) — the six operations, document lifecycle, bootstrapping
- Directory structure (`docs/core`, `stories`, `reference`, `skills`, `logs`)
- Slash commands (`/enso-start`, `/enso-persist`, `/enso-log`, `/enso-help`)
- Self-extension model — agents author their own skills and tools
- Bootstrap flow for new projects
- Agent specialist definitions — identity and routing contracts for the Assign operation

**Out of scope:**
- IDE plugins or GUI tooling
- Cloud sync or multi-user collaboration
- Distribution/installation tooling for other users (future)
