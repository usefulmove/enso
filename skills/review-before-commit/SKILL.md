---
name: review-before-commit
description: Run a behavioral self-check before persisting story results. Verifies diff simplicity, scope adherence, and verifiable completion against enso §10 behavioral principles. Use when a story's implementation is complete and ready to close.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- A story's implementation is complete and you're about to move/close it
- Before running `git add`/`git commit` at the end of a story
- Before `/enso-persist` when code changes have been made
- You want a final sanity check against behavioral drift

Invoke it explicitly. This is an advisory skill — it does not block execution.

---

## Workflow

### Step 1: Gather Evidence

1. Read the active story document (the one in `docs/stories/` you're closing)
2. Run `git diff` to see what actually changed
3. Review the story's **Acceptance Criteria** and **Verification** sections

### Step 2: Check Principles

Run each check. If any fails, report the violation and suggest a fix.

#### §10.1 Think Before Coding — Did I plan?
- [ ] The Approach section was filled out before execution started
- [ ] No file modifications happened between "create story" and "complete approach"
- [ ] Risks were identified upfront, not discovered during implementation
- [ ] **If failed:** Reopen planning. Do not persist.

#### §10.2 Simplicity First — Is this the minimum?
- [ ] No new abstractions were introduced for single-use code
- [ ] No "flexibility" was added that wasn't explicitly requested
- [ ] No features beyond the ask were implemented
- [ ] **If failed:** List the speculative additions. Ask the user if they should stay.

#### §10.3 Surgical Changes — Did I touch only what I must?
- [ ] No lines were changed that don't trace directly to the user's request
- [ ] No adjacent code was "improved" (refactored, reformatted, commented)
- [ ] Dead code created by MY changes was cleaned up
- [ ] Pre-existing dead code was NOT removed unless explicitly asked
- [ ] **If failed:** Revert unrelated changes, or flag them for user review.

#### §10.4 Goal-Driven Execution — Can I verify completion?
- [ ] Every acceptance criterion has a checkmark or explicit reason why it's irrelevant
- [ ] Verification steps (tests, builds, output checks) were run and passed
- [ ] "Done" is not a gut feeling — it has evidence (passing tests, clean build, etc.)
- [ ] **If failed:** Do not close the story. Run the missing verification steps.

### Step 3: Report

```markdown
## Pre-Commit Review: [STORY-ID]

**Status:** PASS / FAIL

### Simple Changes
[YES/NO] — Diff is surgical. [If NO: list files with unrelated changes]

### Simple Code
[YES/NO] — No speculative additions. [If NO: list additions]

### Verifiable Completion
[YES/NO] — Evidence attached. [If NO: list missing verifications]

### Action
- If PASS: Proceed to persist.
- If FAIL with minor issues: Fix in place, re-run review.
- If FAIL with significant drift: `/clear`, rewrite prompt incorporating findings, re-execute.
```

---

## Checklist

- [ ] `git diff` reviewed against §10.3
- [ ] Story Acceptance Criteria show evidence of completion
- [ ] Speculative additions flagged or absent
- [ ] Report generated and appended to story log
