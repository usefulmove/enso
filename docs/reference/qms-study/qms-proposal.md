# Proposal: Embedded QMS for enso

## Decision Record

**Intent:** Process-grade improvement of agentic software quality.
**Scope:** Projects built using the enso harness.
**Rigor:** Strict gates for verification and scope control.
**Approach:** Minimal Phase 1, then iterate based on real usage.
**Artifact:** `AGENTS.md` evolves in place; no separate QMS manual.

---

## Phase 1: The Minimal QMS (Now)

**Goal:** Make every story verifiable and traceable with zero new files.

**What changes in `AGENTS.md`:**
1. Add **Quality Gates** to the story lifecycle:
   - **Gate Q1 (Plan):** No execution until `Approach & Verification Plan` is complete.
   - **Gate Q3 (Verify):** No story closure until all acceptance criteria are checked with evidence.
   - **Gate Q4 (Reflect):** No story closure until `### Reflection` is complete.
2. Add a **Risk Register** section to the story template (structured YAML in frontmatter).
3. Add a **Sign-Off** block before story closure: agent attests to scope, test, and compliance.
4. Formalize **LESSONS.md as the CAPA log**: Every reopened story or scope breach must leave an unchecked lesson.

**What changes in workflow:**
- Before moving a story to completed, the agent must run a self-audit:
  - Did I respect `Write` scope? (diff matches `Context Scope`)
  - Did I verify every acceptance criterion?
  - Did I log a lesson if something went wrong?
- If the answer is no, the story stays open.

**What is automated:**
- Nothing yet. Phase 1 is policy-driven. The agent enforces it via the updated `AGENTS.md` instructions.

**What remains human:**
- Final commit approval (per §11, the user owns the repo).
- Curation of `LESSONS.md` when > 5 items accumulate.

---

## Phase 2: Automated Gates (After Phase 1 is proven)

**Goal:** Remove the burden of self-enforcement by automating the checks.

**What gets built:**
1. **Context Scope Sandbox:** A script or CI check that validates `git diff --name-only` against `Write:` in the active story. Fails if out of scope.
2. **Story Structural Validator:** Mandates `Goal`, `Acceptance Criteria`, `Context Scope`, `Approach`, `Reflection` sections before code execution begins.
3. **Acceptance Criteria Verifiability Engine:** Blocks vague ACs (verbs like "handle" or "support" without quantifiers).

**What stays manual:**
- Architecture truth (update doc or delete module?)
- Curation judgment (Promote/Observe/Deprecate)
- Exception handling (human override with justification)

---

## Phase 3: Metrics & Feedback (After Phase 2)

**Goal:** Measure quality without gaming the system.

**Metrics (collected from logs, not self-reported):**
- Acceptance Criteria Pass Rate
- Scope Adherence Ratio (SAR)
- Story Cycle Time
- LESSONS.md Pending Ratio

**Alerts:**
- SAR < 1.0 → halt execution
- Unchecked lessons > 10 → block new stories until curation
- Orphan changes (diff with no active story) → prompt linkage

---

## Why This Order Matters

We are not building a dashboard. We are building *habits* into the harness.

1. **Policy first** (Phase 1) ensures the agent knows what "good" looks like.
2. **Automation second** (Phase 2) removes the willpower tax of following the policy.
3. **Metrics third** (Phase 3) tell us if the automation is working, not if the agent is cheating.

If we build metrics before gates, agents will game the metrics. If we build gates before policy, we won't know what we're enforcing.

---

## The Tensions Resolved

| Tension | Resolution |
|---------|------------|
| Speed vs. Verification | Most gates are advisory; only scope and verification are blocking |
| Tokens vs. Documentation | Risk register in frontmatter; evidence embedded in story; no separate forms |
| Autonomy vs. Control | Agents enforce QMS on themselves; QMS is the harness |
| Flexibility vs. Standard | Strict on gate logic, flexible on story size and scope |

---

## Immediate Next Step

Create a story to implement Phase 1: update `AGENTS.md` with the new quality gates, sign-off block, and risk register. This is one file change, no new tooling.
