# Lessons Learned

## 2026-03-31 — Bootstrap Safety

### On Guarding Destructive Bootstrap Operations

Bootstrap operations must never overwrite user-modified files without an explicit guard. `curl -o` (and similar write operations) are only safe on first write. Always check existence before overwriting — a customized seed file is irreplaceable if the user hasn't committed it. The pattern: `[ -f ./file ] && echo "OK" || (fetch_or_fail)`.

## 2026-03-31 — Slash Command Refresh

### On Command Discovery
OpenCode slash commands auto-discover from `~/.config/opencode/commands/` — no explicit registration in `opencode.json` required. Files just need to exist in that directory with `.md` extension.

### On Silent Failures
`@file` references in slash commands fail silently if the file is missing. Use `!` shell commands to detect and report missing files explicitly rather than relying on `@` references alone.

### On Bootstrap Design
Bootstrap should fetch canonical seed files from remote source (GitHub) rather than copying local files. This ensures new projects always get the latest version and avoids confusion between tool config files (e.g., `~/.config/opencode/AGENTS.md`) and project seed files (enso `AGENTS.md`). Hard-fail on network errors — no silent fallback.

### On Eating Your Own Dog Food
Using the harness to improve itself surfaces real friction fast. The first `/enso-start` run revealed the missing AGENTS.md copy step and the silent `@file` failure — neither would have been caught otherwise.

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

## 2026-03-28 — Public Presence Integration

### On Framing and Messaging

"The emacs of agent orchestrators" works because it:
- Communicates self-extensibility in one phrase
- References a system technical audiences respect
- Creates immediate curiosity ("what does that mean?")

Supporting phrase "software building software" reinforces the recursive nature without jargon.

### On Multi-Property Integration

Four properties, one message — but different tones:
- **Website**: Terminal aesthetic, embedded in HIGHLIGHTS
- **GitHub README**: Hero tagline, immediate impact
- **Resume**: Hybrid strategy (ATS-friendly + visionary)
- **LinkedIn**: Founder voice, emacs parallel as narrative anchor

Key insight: Same core message, adapted to medium constraints and audience expectations.

### On Content Creation Workflow

Draft → Review → Approve → Execute works well for founder-facing content. Presenting multiple options (Draft 1/2/3) lets the founder choose voice and angle. Final deliverable includes posting instructions and verification checklist.

### Open Questions

- How do agents discover each other's capabilities in a multi-agent team?
- What is the minimal viable harness that still enables full self-extension?
- What is the "elisp" of ensoOS — the primitive language agents use to reshape their own environment?
- Where does the harness/agent distinction fully dissolve?

## 2026-03-31 — Agent-Only Documentation

### On Documentation Audience

When documentation targets agents exclusively, remove:
- Explanations of "why" (agents execute, don't need persuasion)
- Analogies and rhetorical framing
- Conversational language and motivational text
- "How to use this" instructions (implied by structure)

Keep:
- Declarative commands and constraints
- Machine-readable metadata (YAML frontmatter)
- Reference links for deeper reading
- Templates with structure only (no narrative prompts)

Result: 40%+ token reduction, higher signal-to-noise ratio.
