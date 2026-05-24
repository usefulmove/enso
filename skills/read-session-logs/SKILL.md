---
name: read-session-logs
description: Display recent enso session logs and show a summary of active stories. Use when reviewing past sessions, auditing project history, or getting oriented on session continuity. Read-only — no files are modified.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- You need to review what happened in recent sessions
- You are joining an existing project and need session continuity
- A user asks to see "recent logs," "session history," or "what happened last time"
- Before starting work, you want to confirm the state left by the previous session

**This is a read-only skill. No files are modified.**

---

## Workflow

Accept an optional argument: how many logs to show (default: 5).

### Step 1: List Available Logs

```bash
ls -t docs/logs/*.md 2>/dev/null | head -${1:-5} || echo "(no session logs found in docs/logs/)"
```

### Step 2: Display Each Log

```bash
ls -t docs/logs/*.md 2>/dev/null | head -${1:-5} | while read f; do
  echo ""
  echo "════════════════════════════════════════"
  echo "  $(basename $f)"
  echo "════════════════════════════════════════"
  cat "$f"
done || echo "No logs to display."
```

**Do not summarize or paraphrase log content — show it as-is.**

### Step 3: Quick Reference Summary

**Active stories:**
```bash
ls docs/stories/*.md 2>/dev/null | while read f; do
  echo "- $(basename $f): $(grep -A1 "^## Goal" "$f" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')"
done || echo "(none)"
```

**Recent key decisions (across shown logs):**
```bash
ls -t docs/logs/*.md 2>/dev/null | head -${1:-5} | xargs grep -h "^- " 2>/dev/null | head -10 || echo "(none found)"
```

Display all of this clearly and concisely.