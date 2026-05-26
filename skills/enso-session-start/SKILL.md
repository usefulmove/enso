---
name: enso-session-start
description: Start an enso session by loading core context, detecting the active story, or bootstrapping a new project. Use when beginning work in an enso project or when no harness instance is detected.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- Beginning work in a project that uses the enso protocol
- The `docs/core/PRD.md` file is present or missing (bootstrap needed)
- An agent instantiation needs to orient itself: load PRD, architecture, lessons, active stories, and recent logs
- You need to confirm which story is currently active before executing

---

## Workflow

### Step 1: Detect Project State

Run:

```bash
[ -f docs/core/PRD.md ] && echo "ENSO_OK" || echo "ENSO_MISSING"
```

**If "ENSO_OK"** — proceed to Step 2.

**If "ENSO_MISSING"** — use the `question` tool:

- Header: "Bootstrap enso?"
- Question: "No enso project found (docs/core/PRD.md is missing). Bootstrap this project with enso?"
- Options:
  - "Yes, bootstrap" (recommended)
  - "Cancel"

If Cancel: say "Bootstrap cancelled." and stop.

If Yes: enter **Bootstrap Mode**.

---

### Bootstrap Mode

```bash
mkdir -p docs/{core,stories,reference/completed,skills,logs} && touch docs/reference/LESSONS.md
```

Then fetch `AGENTS.md` if missing:

```bash
[ -f ./AGENTS.md ] && echo "AGENTS_OK" || curl -fsSL https://raw.githubusercontent.com/usefulmove/enso/main/AGENTS.md -o ./AGENTS.md
```

If fetch fails, report the failure and stop.

Read `AGENTS.md` fully.

Gather PRD input using the `question` tool — ask one at a time:

1. Header: "PRD: Problem" / Question: "What problem does this project solve? (1-3 sentences)"
2. Header: "PRD: Goals" / Question: "What does success look like? List 2-4 measurable goals."
3. Header: "PRD: Scope" / Question: "What is explicitly in scope? What is out of scope?"

Write `docs/core/PRD.md` using the PRD template from `AGENTS.md` §9.

Then ask:

- Header: "First Story"
- Question: "What's the first task or feature to work on?"

Create `docs/stories/STORY-001-[slug].md` using the story template from `AGENTS.md` §9, with Goal and Acceptance Criteria filled in. Leave Approach stubbed.

Say: "Bootstrap complete. Session started." Then skip to Step 5.

---

### Step 2: Load Core Context

Read these files:

- `@AGENTS.md`
- `@docs/core/PRD.md`
- `docs/core/ARCHITECTURE.md` (if it exists)
- `docs/reference/LESSONS.md` (if it exists)

---

### Step 3: Load Stories and Recent Logs

Load the most recent active story in full:

```bash
ls -t docs/stories/*.md 2>/dev/null | head -1
```

Read that file.

List other active stories:

```bash
ls -t docs/stories/*.md 2>/dev/null | tail -n +2
```

For each, show the file path and its Goal line.

Show recent session logs (last 3):

```bash
ls -t docs/logs/*.md 2>/dev/null | head -3
```

Read each log file (or the tail of their concatenated content).

---

### Step 4: Confirm Active Story

Use the `question` tool:

- Header: "Active Story"
- Question: "I'm assuming the active story is [story title]. Is this your current goal?"
- Options:
  - "Yes, proceed" (recommended)
  - One option per other story in `docs/stories/`
  - "No active story / create a new story or work without one"

If a different story is selected, load it in full.

---

### Step 5: Begin Session

Summarize the loaded context briefly, then say: "Session started. Ready to work on [story title]."
