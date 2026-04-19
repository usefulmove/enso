---
description: Start an enso session - load context, confirm active story, or bootstrap new project
---

You are starting an enso session. Follow these steps in order.

## Step 1: Detect project state

!`[ -f docs/core/PRD.md ] && echo "ENSO_OK" || echo "ENSO_MISSING"`

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

!`mkdir -p docs/{core,stories,reference/completed,skills,logs} && touch docs/reference/LESSONS.md && echo "DIRS_OK"`

!`[ -f ./AGENTS.md ] && echo "AGENTS_OK" || (curl -fsSL https://raw.githubusercontent.com/usefulmove/enso/main/AGENTS.md -o ./AGENTS.md && echo "AGENTS_OK" || echo "AGENTS_FETCH_FAILED")`

If "AGENTS_FETCH_FAILED": say "Bootstrap failed: could not fetch AGENTS.md from GitHub. Check your network and try again." and stop.

@AGENTS.md

Gather PRD input using the `question` tool — ask one at a time:

1. Header: "PRD: Problem" / Question: "What problem does this project solve? (1-3 sentences)"
2. Header: "PRD: Goals" / Question: "What does success look like? List 2-4 measurable goals."
3. Header: "PRD: Scope" / Question: "What is explicitly in scope? What is out of scope?"

Write `docs/core/PRD.md` using the template from AGENTS.md Section 11.

Then ask:

- Header: "First Story"
- Question: "What's the first task or feature to work on?"

Create `docs/stories/STORY-001-[slug].md` using the story template from AGENTS.md Section 11, with Goal and Acceptance Criteria filled in. Leave Approach stubbed.

Say: "Bootstrap complete. Session started." Then skip to Step 5.

---

## Step 2: Load core context

@AGENTS.md
@docs/core/PRD.md
!`[ -f docs/core/ARCHITECTURE.md ] && cat docs/core/ARCHITECTURE.md || echo "(no ARCHITECTURE.md yet)"`
!`[ -f docs/reference/LESSONS.md ] && cat docs/reference/LESSONS.md || echo "(no LESSONS.md yet)"`

## Step 3: Load stories and recent logs

**Most recent story (full):**
!`ls -t docs/stories/*.md 2>/dev/null | head -1 | xargs cat 2>/dev/null || echo "(no active stories found)"`

**Other active stories:**
!`ls -t docs/stories/*.md 2>/dev/null | tail -n +2 | while read f; do echo "- $f: $(grep -A1 "^## Goal" "$f" | tail -1)"; done`

**Recent session logs:**
!`ls -t docs/logs/*.md 2>/dev/null | head -3 | xargs cat 2>/dev/null | tail -100 || echo "(no session logs yet)"`

## Step 4: Confirm active story

Use the `question` tool:

- Header: "Active Story"
- Question: "I'm assuming the active story is [story title]. Is this your current goal?"
- Options:
  - "Yes, proceed" (recommended)
  - One option per other story in docs/stories/
  - "No active story / create a new one"

If a different story is selected, load it in full.

## Step 5: Begin session

Summarize the loaded context briefly, then say: "Session started. Ready to work on [story title]."
