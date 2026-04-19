# enso PRD

## Problem

AI agent sessions are ephemeral. Context windows are finite. Without a system for persisting and selecting context, every session starts cold — losing decisions, lessons, and momentum. The result is repeated derivation, drift from intent, and high orchestration overhead for the human.

## Goals

1. Enable reliable, persistent AI collaboration across sessions and tools
2. Treat context as a scarce resource — load only what's needed, persist before it's lost
3. Give agents a self-extending substrate — the harness reshapes itself through use
4. Reduce cold-start cost through structured persistent context (PRD, stories, logs, lessons)
5. Make the harness usable by any agent in any project via a single-file seed (AGENTS.md)

## Scope

**In scope:**
- Harness protocol (AGENTS.md) — the six operations, document lifecycle, bootstrapping
- Directory structure (`docs/core`, `stories`, `reference`, `skills`, `logs`)
- Slash commands (`/enso-start`, `/enso-persist`, `/enso-log`, `/enso-help`)
- Self-extension model — agents author their own skills and tools
- Bootstrap flow for new projects

**Out of scope:**
- IDE plugins or GUI tooling
- Cloud sync or multi-user collaboration
- Agent registry or named-agent identity system (future)
- Distribution/installation tooling for other users (future)
