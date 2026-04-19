---
name: sisyphus-orchestration-loop
description: Orchestrated multi-step coding with todo breakdown, parallel execution, and verification gates. Use for complex implementation work requiring structured persistence.
license: MIT
compatibility: opencode
---

## When to Use

- Complex feature implementation (3+ files or steps)
- Refactoring that requires coordinated changes across modules
- Bug fixes with unknown root cause requiring exploration
- Any coding task where "just start coding" would be reckless
- Work that benefits from parallel subagent execution

**Do NOT use for:**
- Single-file changes (use direct implementation)
- Quick fixes with obvious solutions
- Research/exploration without implementation goals

---

## Core Principles

1. **Todo-first discipline** — Never start 2+ step work without explicit atomic todos (mentally tracked)
2. **Parallel when independent** — Use subagents for simultaneous execution of independent tasks
3. **Verify before complete** — Build passes, tests pass, files read and confirmed
4. **Persistent iteration** — Failures are data; adjust approach and continue
5. **No batch completions** — Mark each todo complete immediately after verification

---

## Workflow

### Phase 1: Plan

**Before writing any code:**

1. **Understand the request** — Clarify ambiguous requirements
2. **Break into atomic todos** — Each todo should be:
   - Single responsibility
   - Independently verifiable
   - Completable in one subagent session
3. **Identify dependencies** — What must happen in sequence vs. parallel
4. **State the plan** — Present todo list to user for complex work

**Example breakdown:**
```
Task: "Add JWT authentication to the API"

Todos:
- [ ] Explore existing auth patterns in codebase
- [ ] Create JWT middleware module
- [ ] Add token validation to protected routes
- [ ] Write unit tests for middleware
- [ ] Integration test: auth flow end-to-end
- [ ] Update API documentation
```

### Phase 2: Execute

**Subagent Strategy (Dynamic):**

| Scenario | Approach |
|----------|----------|
| Independent todos | Dispatch multiple subagents in parallel |
| Sequential dependencies | One subagent, verify, then next |
| Complex + simple mix | Complex → subagent; Simple → direct |
| Exploration needed | Subagent with explore focus |
| Deep implementation | Subagent with implementation focus |

**Subagent Dispatch Format:**
```
Context: [What we're doing and why]
Goal: [Specific, verifiable outcome]
Constraints: [What not to change, patterns to follow]
Files: [Expected files to touch]
Verify: [How to confirm completion]
```

**During Execution:**
- Track which todos are in_progress (one at a time per thread)
- Read changed files after each subagent completes
- Run builds/tests after each meaningful change

### Phase 3: Verify

**Per-Step Verification (Standard):**

```
□ Code compiles / no type errors
□ Relevant tests pass
□ Changed files read and confirmed correct
□ No unexpected side effects in related code
```

**Final Verification:**
```
□ All todos marked completed
□ Full build passes
□ Full test suite passes (if applicable)
□ Original requirements satisfied
□ No regressions introduced
```

### Phase 4: Iterate

**When a step fails:**

1. **Diagnose** — Read error output, understand failure mode
2. **Adjust** — Modify approach based on failure data
3. **Retry** — Send back to same or different subagent
4. **Escalate** — After 2 failures, reassess the whole plan

**Failure is expected.** The loop continues until convergence.

---

## Anti-Patterns

- ❌ Starting multi-step work without todo breakdown
- ❌ Marking todos complete without verification
- ❌ Running sequential tasks in parallel (dependency violations)
- ❌ Running parallel tasks sequentially (wasted time)
- ❌ "It should work" without reading files or running tests
- ❌ Giving up after first failure
- ❌ Batch-completing multiple todos at once

---

## Completion Signal

When all work is done and verified:

```
DONE — Sisyphus Orchestration Loop Complete

Verified:
- Build: [command + result]
- Tests: [command + result]
- Files: [list of changed files confirmed]

Remaining issues: [none OR list with mitigation]
```

---

## Context Management

**For long-running orchestrations:**

- After every 3 completed todos: write brief progress summary
- Before dispatching subagents after heavy context: mentally compact
- Capture subagent results in structured format:
  ```
  [RESULT todo="X" status="success|fail"]
  One-line summary
  [/RESULT]
  ```

---

## Checklist

- [ ] Todo breakdown created before any code changes
- [ ] Dependencies identified (parallel vs. sequential)
- [ ] Each todo verified before marking complete
- [ ] Parallel execution used where possible
- [ ] Failures handled with adjusted approach (not abandonment)
- [ ] Final verification: build + tests + requirements met