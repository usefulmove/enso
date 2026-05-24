---
name: session-persist
description: Persist working state by extracting lessons, saving progress, and preparing for session handoff. Use when ending or pausing a session, or when the user explicitly asks to checkpoint state.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- A session is ending and needs to be recorded
- A session is pausing and may resume later
- The user explicitly asks to "persist," "save state," "checkpoint," or "hand off"
- Context feels heavy and the agent needs to serialize its accumulator to durable storage

**Do not write any files until the user approves.**

---

## Workflow

### Step 1: Gather Session Data

Collect the following dynamically:

**Git status:**
```bash
git status --short 2>/dev/null || echo "(not a git repo or no changes)"
```

**Active stories:**
```bash
ls -t docs/stories/*.md 2>/dev/null | while read f; do echo "--- $f ---"; head -10 "$f"; echo ""; done || echo "(no stories found)"
```

**Existing lessons:**
```bash
[ -f docs/reference/LESSONS.md ] && cat docs/reference/LESSONS.md || echo "(no LESSONS.md yet)"
```

**Most recent log:**
```bash
ls -t docs/logs/*.md 2>/dev/null | head -1 | xargs cat 2>/dev/null || echo "(no previous logs)"
```

---

### Step 2: Determine Session State

Use the `question` tool:

- Header: "Session State"
- Question: "Is this session complete or are you pausing?"
- Options:
  - "Session complete - close out" (recommended)
  - "Pausing - will resume later"

---

### Step 3: Draft Artifacts

#### Draft A: Session Record

**If session complete:**
File: `docs/logs/YYYY-MM-DD-session.md`
```markdown
# Session: [topic]
**Date:** YYYY-MM-DD

## Overview
-

## Key Decisions
-

## Artifacts Modified
-

## Next Steps
-
```

**If pausing:**
Append to active story in `docs/stories/`:
```markdown
## Progress Update: YYYY-MM-DD

### Completed
-

### Key Decisions
-

### In Progress
-

### Remaining
-
```

#### Draft B: Lessons

New entries for `docs/reference/LESSONS.md` — append as unchecked checklist items:
```markdown
- [ ] [lesson as actionable insight]
```

#### Draft C: Reflection Prompts

Questions for the user:
- Did any task feel repetitive enough to warrant a skill?
- Any architectural discoveries to document?
- Lessons worth capturing before session ends?

---

### Step 4: Present Drafts and Confirm

Show all drafts, then use the `question` tool:

- Header: "Persist State"
- Question: "Here are the drafted artifacts. How would you like to proceed?"
- Options:
  - "Looks good - write everything" (recommended)
  - "Edit session record first"
  - "Edit lessons first"
  - "Skip lessons"
  - "Cancel"

---

### Step 5: Execute Writes

1. `mkdir -p docs/logs docs/reference/completed`
2. **If session complete:**
   - Write Draft A to `docs/logs/YYYY-MM-DD-session.md`
   - Move completed stories to `docs/reference/completed/`
3. **If pausing:**
   - Append Draft A to active story in `docs/stories/`
4. Append Draft B to `docs/reference/LESSONS.md` (create with header if missing)

Say: "State persisted. Wrote: [files]." + next step hint