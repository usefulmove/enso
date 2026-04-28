# QMS Brainstorm Synthesis for enso

## Core Thesis
A QMS for `enso` must be the opposite of a traditional quality bureaucracy. It should be a *constraint layer* that lives inside existing artifacts, not a parallel system. Quality is enforced by making the QMS invisible to the agent until a boundary is crossed.

## Philosophy: Embedded Quality
> "Quality is not a phase; it's a set of constraints on the existing workflow." — adapted from QMS Scope Brainstorm

The QMS lives in:
- The story template (gates, risks, reflection)
- The directory conventions (traceability via structure)
- The agent harness (behavioral rules in AGENTS.md)
- The audit trail (ambient logging, not active forms)

---

## Part 1: Scope & Minimum Viable QMS

**The MVP QMS is just 4 artifacts:**
1. `AGENTS.md` (process + policy — already exists)
2. Story template with Quality Gates (planning, verification, reflection — already exists, needs enforcement)
3. `LESSONS.md` (CAPA log — already exists)
4. `docs/logs/` (execution records — already exists)

This gives us traceability, planning, verification, and improvement loops. Everything else is optimization.

**Tier 1: Required Now**
- Quality Policy (`QUALITY.md`) — 1 page max, "enso produces verifiable, traceable software outputs with minimal token waste."
- Formal Quality Gates embedded in story lifecycle (Plan, Scope, Verify, Reflect, Persist)
- `RISKS.md` in `docs/reference/` for systemic risk tracking
- Story-as-Quality-Record (frontmatter is the audit trail)

**Tier 2: Automated Enforcement**
- Context Scope Sandbox (diff must match Write scope)
- Story Structural Validator (mandatory sections present)
- Acceptance Criteria Verifiability Engine (no vague verbs)
- Git Boundary Guard (reject STORY-XXX in commits, block force push)

**Tier 3: Intelligence & Feedback**
- Metrics Dashboard (`docs/logs/metrics.md`) — token efficiency, scope adherence, cycle time
- Architecture Drift Detector
- Agent Decision Audit Pipeline (ambient, non-blocking)
- Canary Agent (self-test the QMS)

**What NOT to build (Over-engineering Watchlist):**
- No ISO 9001 clause-by-clause manual
- No change control boards (user + story ARE the change board)
- No formal CAPA forms (`LESSONS.md` is the form)
- No separate training records for agents
- No agent certification logs

---

## Part 2: Automation & Tooling

**The Invisible Interface:**
Instead of a dashboard, the QMS becomes part of the prompt. The active story's Context Scope and Acceptance Criteria are injected into the agent's working context. The QMS doesn't "interact" with the agent; it becomes the harness.

**Tiered Enforcement:**
| Tier | Behavior | Example |
|------|----------|---------|
| Ambient | Runs silently, no feedback | Audit logger, drift detector |
| Advisory | Posts PR comments | Behavioral nudges, high diff warnings |
| Gating | Hard CI blocks | Scope breach, missing verification |

**Critical Automated Checks:**
1. **Traceability Gate:** PRD requirements ↔ Story ACs ↔ Code diff
2. **Scope Enforcer:** `git diff` must match `Write:` list in story
3. **Surgical Diff Budget:** Flag if diff bloat ratio is high (violates Simplicity First)
4. **Temporal Validator:** Approach section must be written before first code edit
5. **Behavioral Scanner:** Probe for evidence of "Probe first," "State assumptions," "Stop when confused"
6. **Skill Compliance:** Validate YAML frontmatter on skill edits
7. **Pre-Merge Curation Prompt:** If `LESSONS.md` > 5 unchecked items, require curation link
8. **Meta-Quality / Canary Agent:** Test the QMS by trying to violate it

**What Must Stay Human:**
- Ambiguity resolution (Is scope too narrow or agent too creative?)
- Architecture truth (Update doc or delete module?)
- Quality of acceptance criteria (Is it measuring the right thing?)
- Curation judgment (Promote/Observe/Deprecate)
- Exception handling (Override gates with recorded justification)

---

## Part 3: Process & Workflow Changes

**Story Lifecycle with Quality Gates:**
```
Draft → Planned (QG0: Approach complete) → Executing → Under Review (QG1: Self-certification) → Validated (QG2: Evidence) → Approved → Closed
```

**New Workflow Elements:**
1. **Self-Certification Block:** Before state transition, agent attests: "I verify this diff is scoped, tested, and compliant."
2. **Risk Register Frontmatter:** Structured YAML risks in story, not just free text. High-impact risks must be mitigated before Gate 0.
3. **Independent Verification via `Assign`:** Builder vs. Auditor role separation for high-risk stories.
4. **Hold State for Confusion:** `Status: Pending Clarification` — agent must stop and document blocker.
5. **Digital Sign-Off:** `qms_signed_by`, `qms_signed_at`, `qms_evidence` in story frontmatter.
6. **Kaizen Story Type:** Quarterly harness audit with sampling of closed stories.
7. **Non-Conformance Reports (NCR):** In `docs/logs/ncr/` when scope is violated or criteria missed.
8. **Evidence Compression:** Auto-generate evidence logs (diff summaries, test outputs) via `Compress` operation.
9. **Just-in-Time Documentation:** Compliance artifacts generated at gates, not continuously:
   - Gate 0 → Risk register
   - Gate 1 → Evidence log
   - Gate 2 → Sign-off certificate

---

## Part 4: Metrics & Feedback Loops

**Agentic Performance:**
- Acceptance Criteria Pass Rate (% stories with all [x] at closure)
- Scope Adherence Ratio (SAR — in-scope LOC vs out-of-scope)
- Verification Completion Rate
- Skill Hit Rate

**Documentation Health:**
- LESSONS.md Pending Ratio
- Architecture Doc Staleness (time since last update vs code change)
- Story-to-Traceability Index
- PRD Coverage Score

**Process Metrics:**
- Story Cycle Time
- Rework Rate
- Token Efficiency (proxy via tool call count)
- Planning Overhead Ratio

**Risk Metrics:**
- Unresolved Risk Count at closure
- Risk-to-Mitigation Lag
- Skill Failure Rate

**Anti-Gaming Guardrails:**
- Cross-reference verification ([x] must correlate with file changes)
- Outcome over output (measure tests passed, not checkboxes checked)
- Unannounced audits
- Rotate/shadow metrics
- Human gate always required for commits

**Alert Thresholds:**
- SAR < 1.0 → halt execution
- Unchecked lessons > 10 → block new stories, schedule curation
- Orphan changes (no story) → prompt linkage
- Stagnant architecture > 30 days → warn

---

## The Tensions (To Be Resolved)

Adding a QMS creates natural tensions with enso's core principles:

| Tension | Description | Resolution proposed in synthesis |
|---------|-------------|---------------------------------|
| Minimize Tokens vs. Document More | A QMS demands more documentation. | Just-in-time docs at gates only; ambient logging; evidence compression |
| Speed vs. Verification | Gates slow down execution. | Most gates are advisory; only scope and verification are gating |
| Autonomy vs. Control | Agents should self-improve, but QMS limits them. | Agents enforce QMS on themselves; QMS is in the harness, not a separate inspector |
| Flexibility vs. Standardization | enso is lightweight; ISO is heavy. | Map to ISO mentally, but write for agentic workflows, not auditors |
| Human-in-the-loop vs. Automation | Where does the human stop and the machine start? | Human resolves ambiguity and curation; machine enforces syntax, scope, traceability |

---

## What is NOT yet decided

These require user alignment before any file is touched:
1. The level of QMS rigor: Is this regulatory-grade (e.g., FDA pre-submission) or process-grade (just improve our agentic workflow)?
2. Commit boundaries: The user owns commits per §11. Should the QMS add commit hooks, or only CI-level gates?
3. Role separation: Should high-risk stories require an independent Auditor agent?
4. Metrics: What is the minimum metric set we need to feel confident?
5. Existing artifacts: Do we update `AGENTS.md` in place, or create a new `QUALITY.md` next to it?
6. Scope: Does the QMS apply to enso itself, or to projects using enso, or both?
