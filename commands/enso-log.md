---
description: Show recent enso session logs
---

Display the last $1 session logs (default: 5 if no argument provided). This is a read-only command.

## Step 1: List available logs

!`ls -t docs/logs/*.md 2>/dev/null | head -${1:-5} || echo "(no session logs found in docs/logs/)"`

## Step 2: Display each log

!`ls -t docs/logs/*.md 2>/dev/null | head -${1:-5} | while read f; do echo ""; echo "════════════════════════════════════════"; echo "  $(basename $f)"; echo "════════════════════════════════════════"; cat "$f"; done || echo "No logs to display."`

## Step 3: Quick reference summary

**Active stories:**
!`ls docs/stories/*.md 2>/dev/null | while read f; do echo "- $(basename $f): $(grep -A1 "^## Goal" "$f" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')"; done || echo "(none)"`

**Recent key decisions (across shown logs):**
!`ls -t docs/logs/*.md 2>/dev/null | head -${1:-5} | xargs grep -h "^- " 2>/dev/null | head -10 || echo "(none found)"`

Display this information clearly and concisely. Do not summarize or paraphrase the log content — show it as-is.
