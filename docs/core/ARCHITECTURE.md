# enso Architecture

## Overview

enso is a single-file seed protocol (`AGENTS.md`) that bootstraps a context management system for AI agent collaboration. Drop it into any project, point an agent to it, and the agent creates the persistent context structure. The harness is minimal by design — it grows through use.

## Components

| Component | Responsibility |
|-----------|----------------|
| `AGENTS.md` | The harness protocol. Always-present instructions for any agent working in the project. Single source of truth for operations, lifecycle, and guidelines. |
| `docs/core/` | Source of truth. PRD defines the problem and goals. ARCHITECTURE (this file) maps the system. |
| `docs/stories/` | Active work items. One file per story. Each declares goal, acceptance criteria, context scope, and approach before execution begins. |
| `docs/reference/` | Long-term memory. LESSONS.md accumulates patterns and gotchas. `completed/` holds finished stories. |
| `docs/skills/` | Self-extension. Agent-authored scripts and procedures for vertical workflows. Agents build tools here. |
| `docs/logs/` | Session history. Written by `/enso-persist` after each session. |
| `/enso-start` | Session entry point. Loads core context, detects active story, bootstraps new projects. |
| `/enso-persist` | Persist working state. Extracts lessons, saves progress, prepares for session handoff (complete or pausing). |
| `/enso-log` | Read-only log viewer. Shows recent session summaries and active stories. |
| `/enso-help` | Quick reference. Shows commands, workflow, and live project status. |

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| Markdown for all persistence | Plain text, git-friendly, readable by any agent or human without tooling |
| Single-file seed (AGENTS.md) | Minimal adoption friction — one file starts the whole system |
| Agent-authored skills | Self-extension compounds over time; downloaded tools don't fit specific workflows |
| Human approves before writing | `/enso-persist` drafts first — human reviews, then confirms |
| Stories declare scope explicitly | Write/Read/Exclude boundaries prevent scope creep and context pollution |
| Global slash commands | `/enso-xxxx` commands live in `~/.config/opencode/commands/` — available in any project |
