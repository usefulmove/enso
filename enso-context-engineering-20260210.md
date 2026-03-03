# Context Engineering for Agentic Coding

An informal walkthrough and discussion.

---

## The Problem

When you use an AI coding agent (esp. on a large codebase), the results can be
inconsistent. Sometimes it nails it, sometimes it hallucinates or makes changes
that don't make sense. The difference isn't the model — it's what's in context
when the model runs.

**The quality of an agent's output depends on how well you manage context.**

The context window is working memory, and it's finite. Every token competes for
attention. Most people don't think about this deliberately — they paste in some
code, type a prompt, and hope for the best. That works for small tasks. It
breaks down on a large codebase with real complexity.

The question isn't "which model is best?" — it's "what information does the
model have access to when it makes decisions?"

---

## Mental Model

Introduce a layered view — not a framework to memorize, but a way to think
about where information lives and how it moves.

### The Layers

**Working Context** — what's in the context window right now. Ephemeral.
Expensive. This is the agent's active working memory. When it's gone, it's
gone.

**Near Context** — discoverable. Files on disk, codebase search results, docs
sitting in a `docs/` directory. One tool call away from being in the window.
The agent can reach for it, but only if it knows (or is told) to look.

**Persistent Context** — structured information that survives across sessions
and evolves with the project. A `docs/` directory with PRDs, architecture docs,
active stories, lessons learned. This is the long-term memory layer.

**Tools** — (bash, web search, LSP, MCP, ...) the bridges between layers.
Search loads near context into working context. Compaction moves working
context into persistent context before it's lost. Tools are what make the
layers dynamic instead of static.

---

## Managing Context in Practice

### The Seed

An `AGENTS.md` file drops into a project root. When an agent encounters it,
it bootstraps a directory structure and knows how to manage itself. One file
seeds the entire system.

### The docs/ Structure

```
docs/
  core/           # Source of truth — PRD, Architecture
  stories/        # Active units of work (like tickets)
  reference/      # Long-term memory — lessons, conventions
  skills/         # On-demand capabilities — migrations, scripts
  logs/           # Session history
```


| concept | analog |
|---------------|-----------------|
| PRD | requirements |
| Stories | work breakdown |
| Reference | system architecture, notes, standards & conventions |
| Skills | additional tools, procedures |
| Lessons | things learned the hard way |
| Logs | session notes, updates |


### Session Management

**Starting a session** — the agent loads what it needs from persistent context.
Not everything — just what's relevant to the current task. Progressive
disclosure: summaries first, details on demand.

**Staying focused** — each story declares a context scope: which files it can
write, which it should read for reference, and which to exclude entirely. This
prevents the agent from wandering into unrelated parts of the codebase.

**Compaction** — when the context window fills up (~80%), or when a story
completes, or when a session ends: summarize decisions, capture lessons, write a
log entry, and continue with fresh context. You're moving signal from working
memory into persistent storage before it's lost.

### The Recursive Loop

Docs evolve as work unfolds. They're living artifacts, not write-once documents.

- Lessons get captured in `LESSONS.md` as they're discovered
- Stale context gets pruned — if it's not useful, it's noise
- Core docs get updated in place — git preserves history, so the docs always
  reflect current state

A guided agent completes a unit of work, given the current context, and returns
an updated context.

### The Six Operations

- **Writing things down** so they survive beyond the current session
- **Selecting** only the relevant context for the task at hand
- **Probing** the codebase actively instead of assuming you know what's there
- **Compressing** when context gets full — condense, don't drop
- **Isolating** complex tasks into separate scopes so the agent stays focused
- **Assigning** the right tool or agent for each subtask
