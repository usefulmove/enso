# enso

> Intelligence is in the model. Control is in the harness.

**The emacs of agent orchestration.** Software that builds software.

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/usefulmove/enso/main/AGENTS.md
```

One file. No dependencies. No CLI. Drop it in your repo and your agent becomes a disciplined engineer.

---

## The Problem

If you code with agents, you know this fatigue.

You explain the architecture to an agent that *built* it three sessions ago. You find bugs reintroduced because last week's lesson evaporated. You watch a brilliant model behave like an amnesiac — writing code that contradicts its own conventions, touching files it promised to avoid, treating every task like opening night with no rehearsal.

The model is not the problem. The model is magnificent. The problem is **context rot** — the slow decay of coherence as an agent loses track of what it knows, what it's done, and what it's supposed to be doing. Intelligence without memory is chaos.

---

## The Solution: Harness Engineering

An agent harness is everything between user intent and model output that is *not* the language model itself — context assembly, tool orchestration, verification loops, feedback mechanisms, and lifecycle management.

The harness is the 80% factor in agent reliability. Same model, better harness, dramatically better results.

| Evidence | Result |
|----------|--------|
| **Vercel** agent evals | Persistent context via AGENTS.md achieved a **100% pass rate** vs. **79%** for on-demand skill retrieval — a +21 percentage point improvement ([source](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals)) |
| **LangChain** Terminal Bench 2.0 | Same model (Claude Opus 4.6), different harness: improved from **Top 30 to Top 5** by optimizing the harness alone ([source](https://blog.langchain.dev/the-anatomy-of-an-agent-harness/)) |

> *"Agent = Model + Harness. The model contains the intelligence; the harness makes that intelligence useful."* — LangChain

Enso treats context as a scarce resource. Every token competes for attention. Three principles govern the protocol:

1. **Separate concerns.** Working context (ephemeral thought), persistent context (durable docs that survive sessions), and reference context (codebase and external sources searched on demand).
2. **Progressive disclosure.** Load only what you need, when you need it. Summaries before details. Search before assuming.
3. **Stay current, not historical.** Documents reflect the present state. Git tracks history. Docs don't accumulate cruft.

---

## Quick Start

### 1. Plant the Seed

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/usefulmove/enso/main/AGENTS.md
```

`AGENTS.md` is not documentation — it is the seed that anchors your harness. The file must exist in your repo to persist context across sessions. Without it, agents lose the protocol between runs.

### 2. Activate

Paste exactly this into your agent:

| Tool | Prompt |
|------|--------|
| **Claude Code** | `/read AGENTS.md` then `/project "Bootstrap this project using the enso protocol."` |
| **Cursor** | `@AGENTS.md` in chat, then type `Bootstrap this project with enso.` |
| **OpenCode** | `Read @AGENTS.md and bootstrap this project.` |
| **Windsurf** | Add `AGENTS.md` to Cascade context, prompt: `Bootstrap using the enso protocol.` |

### 3. Watch It Grow

**00:00** — `> Read @AGENTS.md and bootstrap this project.`  
**00:03** — `Bootstrapping docs/ structure...`  
**00:08** — `Probing codebase — found 14 source files, 2 test suites.`  
**00:18** — `Mapping architecture...`  
**00:35** — `Drafting PRD.md and ARCHITECTURE.md.`  
**00:52** — `First story template ready at docs/stories/STORY-001.md.`  
**00:59** — `Harness active. What should we build first?`

From there, the cycle repeats: plan, execute, capture, extend. Each session leaves the harness sharper than the last.

---

## How It Works

### The Six Operations

The context window is a spotlight — you can illuminate only so much at once. Six operations control what's lit, what's just off-stage, and when to change scenes.

| Operation | Action |
|-----------|--------|
| **Write** | Persist insights to disk |
| **Select** | Load only what's needed now |
| **Probe** | Search actively — don't assume, discover |
| **Compress** | Summarize to fit the token budget |
| **Isolate** | Split work across scopes |
| **Assign** | Match task to the right agent |

### The Directory Structure

Enso creates a standard, predictable hierarchy that agents can navigate without guidance:

```
docs/
  core/           # Source of truth — PRD, Architecture
  stories/        # Active units of work
  reference/      # Long-term memory — lessons, conventions
  skills/         # Self-authored tools and capabilities
  logs/           # Session history
```

**Core** holds the vision — updated in place, never duplicated. **Stories** hold active work — each one scoped, planned, and verified before execution begins. **Reference** holds earned knowledge — completed work and the living `LESSONS.md` where every hard-won insight is recorded. **Skills** hold self-authored tools. **Logs** hold compressed session summaries.

### The Self-Extension Loop

Enso draws from the [Pi Principle](https://github.com/badlogic/pi-mono/): **agents extend themselves by authoring tools, not downloading them.**

When an agent encounters friction — a repetitive task, a complex procedure, a missing capability — it doesn't wait. It builds the minimal tool, persists it to `docs/skills/`, and moves on. The next session inherits the capability. The session after that refines it.

The compounding effect: a tool built today saves derivation cost in every future session. After months of work, an agent has dozens of custom tools tailored to its codebase — not downloaded dependencies, but authored capabilities. Software building software.

> *"The most powerful agents are not those with the most downloaded dependencies, but those that have built the most custom tools for their specific workflows."*

---

## Key Capabilities

| Capability | Payoff |
|------------|--------|
| **Plan-before-execute** | No file changes without a verified story |
| **Context scope** | Explicit Write/Read/Exclude boundaries on every task |
| **Retrieval-led reasoning** | Version-matched docs in `docs/` instead of stale training data |
| **Agentic discovery** | Agents probe the codebase and build a mental map before talking to you |
| **Institutional memory** | Lessons and anti-patterns captured in `LESSONS.md`, preventing repeat mistakes |
| **Self-extending agents** | Capabilities compound over time — the agent becomes uniquely capable for its domain |

---

## What Enso Is Not

<details>
<summary>Is enso a CLI, framework, or model-specific tool?</summary>

- **Not a CLI or library.** It's a protocol — a single markdown file that any agent can read.
- **Not a framework.** There's nothing to install, configure, or maintain. Drop a file, start working.
- **Not model-specific.** It works with any agent that can read a file and follow instructions.
- **Not rigid.** The protocol is a starting point. Adapt it to your codebase, your workflow, your domain.

</details>

---

## References

- **Pi Principle** — Agents extend themselves by authoring tools. [pi-mono](https://github.com/badlogic/pi-mono/)
- **Sisyphus Orchestration Loop** — Multi-step task execution with verification gates. [oh-my-opencode ecosystem](https://github.com/topics/sisyphus)
- **Agentic Context Engineering** — Research on context management for AI agents. [arXiv:2510.04618](https://arxiv.org/pdf/2510.04618)
- **Vercel Agent Evals** — Persistent context via AGENTS.md achieved 100% pass rate vs. 79% for skill retrieval. [Blog](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals)
- **LangChain Terminal Bench 2.0** — Harness optimization improved agent ranking from Top 30 to Top 5. [Blog](https://blog.langchain.dev/the-anatomy-of-an-agent-harness/)

## License

MIT
