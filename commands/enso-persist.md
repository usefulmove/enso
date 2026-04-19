---
description: Persist working state - extract lessons, save progress, prepare for handoff
---

Do NOT write any files until the user approves.

## Step 1: Gather session data

**Git status:**
!`git status --short 2>/dev/null || echo "(not a git repo or no changes)"`

**Active stories:**
!`ls -t docs/stories/*.md 2>/dev/null | while read f; do echo "--- $f ---"; head -10 "$f"; echo ""; done || echo "(no stories found)"`

**Existing lessons:**
!`[ -f docs/reference/LESSONS.md ] && cat docs/reference/LESSONS.md || echo "(no LESSONS.md yet)"`

**Most recent log:**
!`ls -t docs/logs/*.md 2>/dev/null | head -1 | xargs cat 2>/dev/null || echo "(no previous logs)"`

## Step 2: Determine session state

Use the `question` tool:

- Header: "Session State"
- Question: "Is this session complete or are you pausing?"
- Options:
  - "Session complete - close out" (recommended)
  - "Pausing - will resume later"

## Step 3: Draft artifacts

### Draft A: Session Record

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

### Draft B: Lessons

New entries for `docs/reference/LESSONS.md` — append as unchecked checklist items:
- `- [ ] [lesson as actionable insight]`

### Draft C: Reflection Prompts

Questions for the user:
- Did any task feel repetitive enough to warrant a skill?
- Any architectural discoveries to document?
- Lessons worth capturing before session ends?

## Step 4: Present drafts and confirm

Show all drafts, then use the `question` tool:

- Header: "Persist State"
- Question: "Here are the drafted artifacts. How would you like to proceed?"
- Options:
  - "Looks good - write everything" (recommended)
  - "Edit session record first"
  - "Edit lessons first"
  - "Skip lessons"
  - "Cancel"

## Step 5: Execute writes

1. `mkdir -p docs/logs docs/reference/completed`
2. **If session complete:**
   - Write Draft A to `docs/logs/YYYY-MM-DD-session.md`
   - Move completed stories to `docs/reference/completed/`
3. **If pausing:**
   - Append Draft A to active story in `docs/stories/`
4. Append Draft B to `docs/reference/LESSONS.md` (create with header if missing)

Say: "State persisted. Wrote: [files]." + next step hint