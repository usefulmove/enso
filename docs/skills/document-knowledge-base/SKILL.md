---
name: document-knowledge-base
description: Create and update a folder/file knowledge base using agentic discovery. Covers KB bootstrap, single entry creation, and entry updates. Use this when asked to document a system, subsystem, concept, or domain — or when existing KB entries need refreshing.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- Asked to create or update a knowledge base
- Documenting a codebase, system, API, domain, or process for the first time
- Refreshing a KB entry that may be stale
- Bootstrapping a `docs/core/architecture/` structure in a new project

---

## The Core Idea

**A knowledge base is not a library. It's a web.**

Coverage is not the goal. The value is in the connections between entries — the relationships that let an agent (or a human) navigate from what they know to what they need. An entry with five accurate cross-references is worth more than a comprehensive entry with none.

---

## Core Concepts

### Entry Lifecycle

Every KB entry has a status:

| Status | Meaning |
|--------|---------|
| `stub` | Node is known to exist; not yet documented |
| `draft` | Documented from discovery; not yet verified against source |
| `verified` | Confirmed accurate against source |
| `stale` | Previously accurate; source has changed |

### Recommended Frontmatter

Keep frontmatter minimal. These fields matter for KB health:

```yaml
---
title: <human-readable name>
source: <path, URL, or concept identifier — whatever was probed>
status: stub | draft | verified | stale
related: [<other entry paths or titles>]
last_updated: <YYYY-MM-DD>
---
```

Add domain-specific fields as needed (e.g., `tags`, `owner`, `version`). Don't over-engineer frontmatter for a first pass — `status` and `last_updated` are the minimum viable fields.

### Naming for Navigability

KB entries and files are discovered by name before their content is read. Names should be self-describing.

**Entry names (titles and filenames):**
- Use the subject's actual name, not a generic label: `websocket-communication` not `layer-3`
- Prefer noun phrases that match how the subject is referred to in the codebase or domain
- Avoid abbreviations unless they're universally understood in context
- Directory names should match the entry title in kebab-case: `websocket-communication/README.md`

**File naming:**
- `MAP.md` — always the agent entry point at the KB root
- `README.md` — the main entry for a subdirectory node
- `<concept>.md` — for flat KBs or standalone reference entries
- `INDEX.md` — for directory-level summaries within a node

**Test:** Can an agent scanning the directory listing identify what each entry covers without opening any files? If not, rename.

### The KB Map

Every KB should have an entry point — a `MAP.md` or `README.md` at the root that:
- States what the KB covers
- Lists top-level entries with one-line descriptions
- Guides an agent to the right entry without reading everything

This is the most important file in the KB. Keep it current.

---

## Workflows

### 1. Bootstrap — KB Does Not Exist Yet

Use when starting from scratch. Goal: create a navigable skeleton quickly, then fill in depth selectively.

**Phase 1 — Scope**
- Clarify what the KB will cover (codebase, domain, API, process, etc.)
- Identify the root location (e.g., `docs/core/architecture/`)
- Identify the top-level nodes (subsystems, modules, concepts, services)

**Phase 2 — Agentic Discovery (Probe + Select)**

*Goal: build a structural map without reading everything.*

Probe breadth-first:
- Map the top-level structure (directories, modules, major concepts)
- Identify entry points — the files or concepts that everything else depends on or flows through
- Note relationships and dependencies between nodes
- Flag nodes that are clearly important but not yet understood

Select depth where it matters:
- Read entry points and interfaces, not implementations
- Pull in only what's needed to write an accurate one-liner per node
- Resist the urge to read everything — stubs are valid

**Phase 3 — Write**

Create the KB structure:

```
<kb-root>/
  MAP.md              # agent entry point — required
  <node-a>/
    README.md         # or <node-a>.md at the root level for flat KBs
  <node-b>/
    README.md
  ...
```

For each node:
- If you have enough to document it: write a `draft` entry (see Entry Format below)
- If you know it exists but don't have enough: write a `stub` (see Stub Format below)

Write `MAP.md` last — it should reflect what actually exists.

**Phase 4 — Cross-Reference**

After all entries are written:
- Add `related` links between connected entries
- Note any open questions or unknowns in the entries themselves
- Update `MAP.md` with the full node list

---

### 2. Create — Single New Entry

Use when adding one entry to an existing KB.

1. **Locate** — find the right place in the KB. Check `MAP.md` for structure.
2. **Probe** — discover the source material for this entry (see Discovery below).
3. **Select** — pull only what's needed to write an accurate entry.
4. **Write** — create the entry file (see Entry Format below).
5. **Update MAP** — add the new entry to `MAP.md`.
6. **Cross-reference** — add `related` links in this entry and in related entries.

---

### 3. Update — Refreshing a Stale or Draft Entry

Use when an existing entry needs to reflect changes in the source.

**Do not restructure the KB.** Update the entry in place. Preserve the existing structure and surrounding entries.

1. **Read the existing entry** — understand what it currently claims.
2. **Check `status`** — `stale` means known-outdated; `draft` means unverified; `verified` means confirmed-accurate.
3. **Probe the source** — re-examine whatever the entry documents (see Discovery below).
4. **Diff mentally** — what has changed? What is still accurate?
5. **Edit in place** — update only what changed. Don't rewrite sections that are still correct.
6. **Update frontmatter** — set `status: verified` (if confirmed accurate) or `status: draft` (if updated but not yet confirmed), bump `last_updated`.
7. **Check related entries** — if the change affects other entries, mark them `stale` or update them too.

---

## Agentic Discovery

Discovery is the Probe + Select phase. The goal is to build an accurate mental model of the subject with minimum token cost.

### Probe — Map Before You Read

Probe for structure before reading content:
- What are the top-level nodes? (directories, modules, services, concepts)
- What are the entry points? (main files, root interfaces, primary concepts)
- What depends on what? (imports, references, call chains, relationships)
- What is the boundary of this node? (what's in, what's out)

Use whatever tools fit the domain:
- **Codebase**: glob for structure, grep for patterns, LSP for interfaces
- **Documents**: directory listing, frontmatter scan, heading extraction
- **APIs**: endpoint listing, schema inspection
- **Domains**: outline the concept hierarchy before reading any detail

### Select — Read What Matters

After probing, read selectively:
- Entry points and interfaces over implementations
- The first and last sections of long documents (structure + conclusions)
- Grep for specific patterns rather than reading whole files
- Stop when you can write an accurate one-liner — that's enough for a draft

**Token discipline:** A KB entry that accurately describes a node in 200 words is more valuable than one that reproduces the source in 2000 words. Compress.

---

## Cross-References

Cross-references are what make a KB a web. Treat them as first-class content, not afterthoughts.

### Bidirectionality

If entry A links to entry B, entry B must link back to entry A. One-way links create dead ends. When adding a cross-reference, always update both sides.

### Connection Descriptions

A bare link is nearly useless. Describe *why* the entries are related — from the perspective of the entry you're writing.

❌ `[WebSocket Layer](../websocket/README.md)`

✅ `[WebSocket Layer](../websocket/README.md) — the transport this subsystem depends on for all robot commands; changes to the message protocol here require updates there`

The description should answer: "Why would someone reading *this* entry care about *that* one?"

### Density

Aim for 3–8 connections per entry. Fewer suggests the entry is isolated; more suggests the scope is too broad or the connections aren't meaningful.

---

## Entry Formats

### Full Entry

```markdown
---
title: <name>
source: <path or identifier>
status: draft
related: []
last_updated: <YYYY-MM-DD>
---

# <name>

<One-sentence description of what this is and why it exists.>

## What It Does

<2-5 sentences. What problem does it solve? What are its inputs and outputs?>

## Structure / Key Components

<Bullet list or small table of the main parts. Not exhaustive — just what matters.>

## Data Flow (if applicable)

<ASCII diagram or bullet flow. Source → transformation → destination.>

## Key Decisions

<Why this approach? What tradeoffs were made? What would break if this changed?>

## Open Questions

<What is unknown, unverified, or needs follow-up? Remove this section when empty.>
```

### Stub

```markdown
---
title: <name>
source: <path or identifier>
status: stub
related: []
last_updated: <YYYY-MM-DD>
---

# <name>

<One-sentence description of what this is, based on what was discovered during top-down mapping.>

> **Stub** — not yet fully documented. Discovered during [parent entry] mapping.
```

### Index / MAP.md

```markdown
# Knowledge Base — <subject>

<One paragraph: what this KB covers and who it's for.>

## Entries

| Entry | Status | Description |
|-------|--------|-------------|
| [Node A](node-a/README.md) | verified | <one-liner> |
| [Node B](node-b/README.md) | stub | <one-liner> |

## Navigation

<Optional: quick-reference table mapping questions to entries.>

## Notes

<Anything an agent needs to know before using this KB: known gaps, stale sections, tool-generated vs. hand-written entries, etc.>
```

---

## Checklist

### Bootstrap
- [ ] Scope defined — what the KB covers
- [ ] Top-level nodes identified via Probe
- [ ] Entry points read via Select
- [ ] All nodes have at least a stub
- [ ] Full entries written for nodes that matter most
- [ ] `MAP.md` written and reflects actual structure
- [ ] Cross-references added with descriptions (both directions)

### Create
- [ ] Correct location in KB identified
- [ ] Source probed and entry points read
- [ ] Entry written with accurate frontmatter
- [ ] `MAP.md` updated
- [ ] Cross-references added with descriptions (both directions)

### Update
- [ ] Existing entry read before making changes
- [ ] Source re-probed
- [ ] Only changed sections updated
- [ ] Frontmatter `status` and `last_updated` bumped
- [ ] Related entries checked for downstream impact — mark `stale` or update cross-references as needed
