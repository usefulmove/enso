---
name: convert-request-to-story
description: Transform a vague or imperative user request into a properly scoped enso story with clear acceptance criteria, context scope, and verification plan. Triggered automatically when a request lacks verifiable goals or structure.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill automatically when a user request exhibits ANY of these patterns:
- No explicit acceptance criteria: "Fix the bug" / "Add validation" / "Make it faster"
- No scope boundaries: "Refactor the auth system" / "Clean up the codebase"
- No verification plan: "Implement OAuth" / "Set up CI"
- Imperative, not declarative: "Do X" instead of "X should work like Y"
- Open-ended goals: "Improve the API" / "Make the dashboard look better"
- Multiple unrelated tasks in one request

This skill is a **workflow skill**. Run it, then follow its output.

---

## Workflow

### Step 1: Decompose

Restate the user's intent. Break multi-part requests into atomic tasks. Create a separate story for each.

If the request contains multiple tasks:
```
Task 1: Implement Google OAuth login
Task 2: Add session timeout logic
Task 3: Write tests for auth flow
```

→ Create 3 stories. Do not combine them.

### Step 2: Transform Each Task Into a Story

For each atomic task, fill out the enso story template by asking clarifying questions or inferring from context:

#### What to Ask the User

| Vague Request | Questions to Ask |
|---------------|-----------------|
| "Fix the bug" | "What is the error message? What file or page triggers it? What should happen instead?" |
| "Add validation" | "On which input fields? What are the valid vs invalid values? Should errors stop submission or just warn?" |
| "Refactor X" | "Why does X need refactoring? What tests should pass before and after? What behavior must NOT change?" |
| "Make it faster" | "Which operation is slow? What speedup is acceptable? What's the current benchmark?" |
| "Implement Y" | "What does Y do? Who uses it? What's the input/output contract? Are there existing examples to follow?" |

#### What to Infer From Context

Some answers come from the codebase, not the user:
- Existing style → match it
- Existing test patterns → follow them
- Existing architecture → grow incrementally
- Build/test commands → read `package.json`, `Makefile`, CI config, or `CLAUDE.md`

### Step 3: Write the Story

Create `docs/stories/STORY-XXX-[slug].md` with:

```markdown
# [STORY-XXX] [Descriptive Title]

## Goal
[Transformed from vague request into a declarative, verifiable goal.]

## Acceptance Criteria
- [ ] <criterion with evidence of completion>
- [ ] <another criterion>

## Context Scope
**Write:**
-

**Read:**
-

**Exclude:**
-

## Approach & Verification Plan

### Steps
1. <step> → verify: <how you know it's correct>
2. <step>

### Risks & Unknowns
- <risk and mitigation>

### Verification
- [ ] <check>

### Reflection
- [ ] No new insights → proceed
```

### Step 4: Return Control

Present the drafted story to the user:

```
I've drafted [STORY-XXX] for your request. Before proceeding:

1. Are the Acceptance Criteria correct?
2. Is the Context Scope right — should anything be added or excluded?
3. Does the Verification plan cover what "done" looks like for you?

Once confirmed, I'll begin execution.
```

Wait for user confirmation. Do not execute until approved.

---

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | What to Do Instead |
|--------------|-------------|-------------------|
| Single criterion: "Make it work" | Not verifiable. "Work" is vague. | List 3-5 specific, checkable criteria |
| No Write scope defined | Agent may drift across the codebase | Explicitly list files/directories that will change |
| No Read scope defined | Agent may miss critical context | Explicitly list key reference files |
| "Fix all tests" with no baseline | Can't verify what changed | State which tests fail now and which should pass |
| Skipping the Approach section | §10.1 violation: no planning | Fill out Steps and Risks before writing code |
| Accepting vague requests silently | §10.1 violation: assuming | Always ask for criteria or present your own |

---

## Checklist

- [ ] Request decomposed into atomic, one-purpose stories
- [ ] Each story has at least 3 specific, checkable acceptance criteria
- [ ] Context Scope is explicit (Write + Read + Exclude)
- [ ] Approach section includes Steps + Risks + Verification
- [ ] User confirmed the drafted story before execution began
- [ ] No code written before story is approved
