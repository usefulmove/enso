# Lessons Learned

## 2026-03-27 — Founding Session

### On Agent Orchestration Metaphors

The "hiring/sculpting" metaphor fundamentally changes interface design. When agents become
teammates rather than tools, the interaction shifts from command execution to collaborative
delegation. This requires persistence of agent identity, role clarity, and handoff mechanisms
between agents.

Named agents with defined roles (e.g., Toni the architect) create cognitive clarity for the
human orchestrator. Treating agents as a team you *hire and shape* — not a tool you *invoke* —
changes how you think about context, continuity, and accountability.

### On the Emacs Parallel

"The emacs of X" communicates both technical depth and self-extensibility in a single phrase.
It signals: (1) programmable at its core, (2) grows with the user over time, (3) becomes
uniquely personalized to its operator. For agent systems, this means the interface itself
must be agent-modifiable — the harness reshapes itself through use.

### On First Principles

Starting from "agents that participate in the construction of their own operational context"
yields fundamentally different architecture than starting from "agents that execute tasks."
The former demands recursive state management and persistent identity. The latter treats
agents as transient functions.

The recursive loop — `Harness_t → Agent → Harness_{t+1}` — is the core primitive. Each
session's output is the next session's input. The harness is the persistence layer that
makes agent continuity possible.

### On the Human Role

The human is not a user. The human is the God agent — the technical program manager and
systems architect who sets vision, hires specialists, sculpts teams, and delegates work.
The harness is the organizational infrastructure that makes this orchestration possible.

### On Bootstrap Friction

The "bring up" ritual (terminal → tmux → opencode → bootload AGENTS.md → kickoff meeting →
PRD → stories → execute) is the current cold-start cost. Reducing this friction is a high-value
target. Warm starts (resuming a session with full context already loaded) are significantly
more productive than cold starts.

### On Lazy Loading

Defer loading source files until the story that needs them is executing. Don't assume structure
or content — probe first. This keeps the harness lean and prevents stale assumptions from
polluting context.

### Open Questions

- How do agents discover each other's capabilities in a multi-agent team?
- What is the minimal viable harness that still enables full self-extension?
- What is the "elisp" of ensoOS — the primitive language agents use to reshape their own environment?
- Where does the harness/agent distinction fully dissolve?
