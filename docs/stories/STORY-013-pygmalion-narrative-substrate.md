---
schema: enso.story/v1
id: STORY-013
title: Pygmalion as enso's narrative substrate
state: seeded
active_role: planner
iteration: 0
max_iterations: 3
created_at: 2026-06-01T00:00:00Z
updated_at: 2026-06-01T00:00:00Z
priority: high

scope:
  write:
    - README.md
    - AOS.md
    - docs/core/ARCHITECTURE.md
    - docs/core/PRD.md
    - docs/reference/enso.md
    - docs/reference/aos-concept.md
    - docs/narrative/pygmalion-paragraph.md
    - docs/narrative/pygmalion-paragraph-readme.md
    - docs/narrative/pygmalion-paragraph-aos.md
    - docs/stories/STORY-013-pygmalion-narrative-substrate.md
  read:
    - AGENTS.md
    - docs/reference/STORY.md
    - docs/reference/hitl-pge-loop-design.md
    - docs/reference/enso-condensed.md
    - docs/reference/enso-gnosis.md
    - docs/reference/harness-engineering-short.md
    - docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md
    - docs/stories/STORY-012-upgrade-agents-to-story-v1.md
  exclude:
    - .git/
    - .pi/extensions/
    - implementation code
    - assets/ except as named above
    - unrelated completed stories

acceptance_criteria:
  - id: AC1
    text: README.md leads with the canonical Pygmalion paragraph (enso-flavoured version) as its narrative spine and uses it to organize the front-of-file pitch.
  - id: AC1a
    text: The canonical Pygmalion paragraph is pinned in `docs/narrative/pygmalion-paragraph.md` and matches the version recorded in this story's Planner Output byte-for-byte.
  - id: AC1b
    text: The README lead paragraph is byte-for-byte identical to `docs/narrative/pygmalion-paragraph-readme.md` after Generator iteration.
  - id: AC2
    text: AOS.md reframes the orchestration surface through the Pygmalion model — surface as the figure the human relates to, substrate as the persistent clay, handoffs as hand-lifts-and-presses.
  - id: AC3
    text: docs/core/ARCHITECTURE.md adds a short Pygmalion section that maps maker/medium/figure to model/runtime/harness-protocol/harness-instance/agent-instantiation/substrate.
  - id: AC4
    text: docs/reference/aos-concept.md (if it exists) and docs/reference/enso.md align terminology with the Pygmalion framing without restating the myth.
  - id: AC5
    text: PRD.md Goal section is updated to reflect that enso exists to enable Pygmalion-style figure-shaping against a persistent substrate, not merely to route between agents.
  - id: AC6
    text: Pygmalion is mentioned exactly once in the front door (README), once in AOS.md, once in ARCHITECTURE.md; deeper docs reference it as needed. No over-restating.
  - id: AC7
    text: Runtime-agnosticism is preserved: enso is still presented as a file-based harness protocol, not as a Pygmalion-specific runtime.
  - id: AC8
    text: Diff stays scoped to documentation files plus the active story file.

verification:
  - id: V1
    command: grep -n "Pygmalion\|maker\|medium\|figure" README.md AOS.md docs/core/ARCHITECTURE.md docs/core/PRD.md docs/reference/enso.md docs/reference/aos-concept.md
    pass_when: Pygmalion model terms appear in each updated doc; no more than the agreed number of mentions per file.
  - id: V2
    command: git diff -- README.md AOS.md docs/core/ARCHITECTURE.md docs/core/PRD.md docs/reference/enso.md docs/reference/aos-concept.md docs/narrative/ && git status --short
    pass_when: Diff and status limited to agreed documentation files, the docs/narrative/ pinned paragraphs, and the active story file.
  - id: V3
    command: grep -n "Pygmalion" README.md | wc -l
    pass_when: count is between 1 and 3 (front-door mention is intentional, not a refrain).
  - id: V4
    command: test -f docs/narrative/pygmalion-paragraph.md
    pass_when: canonical paragraph file exists at the named path.
  - id: V5
    command: diff <(sed -n '/^> /p' README.md) <(sed -n '/^> /p' docs/narrative/pygmalion-paragraph-readme.md)
    pass_when: README lead paragraph matches the pinned README-lead byte-for-byte (zero diff).
---

# STORY-013 Pygmalion as enso's narrative substrate

## Goal

Adopt the **Pygmalion model — maker, medium, figure** — as the narrative substrate for enso's front door, AOS doc, and architecture. The story is told once, in its strongest form, in the README; every other doc references it without restating the myth. The result: a reader who arrives at enso from anywhere in the public docs gets one coherent story, and that story explains *why* the seam graph and the persistent substrate matter, not just *that* they do.

This is a documentation-only story. It is the upstream half of the broader Pygmalion alignment that toni's `STORY-001` will mirror locally. The two stories are independent in scope; together they make the Pygmalion model load-bearing across both repos.

## Non-Goals

- Do not modify the `enso.story/v1` spec, `AGENTS.md`, or the harness protocol itself.
- Do not introduce new seams, new operations, or new roles.
- Do not migrate old completed story files.
- Do not embed the Pygmalion myth as a *feature* of enso (e.g., do not name files `pygmalion.md` or add a `figure` directory). The myth is a *narrative substrate* — it organizes how the docs read, not what the repo contains.
- Do not turn the Pygmalion framing into a hard runtime requirement; enso remains runtime-agnostic.
- Do not retitle enso, the AOS concept, or any of the existing layers (model, runtime, harness protocol, harness instance, agent instantiation, substrate).

## Constraints

- **Surgical diff.** Only the files in `scope.write` may change.
- **Naming hygiene.** "Maker" is the human user. "Medium" is the substrate (codebase, docs, configs, repo state). "Figure" is the orchestration surface the human relates to — and, by extension, the agent instantiations the surface coordinates. Use these terms in their canonical English meanings, not as if they were enso-specific terms-of-art.
- **Front door discipline.** The README is the place the story is told. Other docs *reference* it (e.g., "see README for the Pygmalion framing") or *use* it (e.g., AOS.md reads as an instance of the framing). No doc re-tells the myth.
- **Tone.** Match the existing voice of each doc. README prose is direct and architectural. AOS.md is compact and contract-shaped. ARCHITECTURE.md is technical. Do not import SOUL-style register into any of these.
- **Myth fidelity.** Pygmalion carries a specific commitment: the maker is responsible for the figure but not in control of it; the figure has its own read, its own voice; the test of success is whether the figure stands on its own when the hand lifts. Honor that. Do not let the framing collapse into "shapes a tool" — that loses the load-bearing point.

## Acceptance Criteria

- [ ] AC1 README.md names the Pygmalion model (maker, medium, figure) as enso's narrative substrate and uses it to organize the front-of-file pitch.
- [ ] AC2 AOS.md reframes the orchestration surface through the Pygmalion model — surface as the figure the human relates to, substrate as the persistent clay, handoffs as hand-lifts-and-presses.
- [ ] AC3 docs/core/ARCHITECTURE.md adds a short Pygmalion section that maps maker/medium/figure to model/runtime/harness-protocol/harness-instance/agent-instantiation/substrate.
- [ ] AC4 docs/reference/aos-concept.md (if it exists) and docs/reference/enso.md align terminology with the Pygmalion framing without restating the myth.
- [ ] AC5 PRD.md Goal section is updated to reflect that enso exists to enable Pygmalion-style figure-shaping against a persistent substrate, not merely to route between agents.
- [ ] AC6 Pygmalion is mentioned exactly once in the front door (README), once in AOS.md, once in ARCHITECTURE.md; deeper docs reference it as needed. No over-restating.
- [ ] AC7 Runtime-agnosticism is preserved: enso is still presented as a file-based harness protocol, not as a Pygmalion-specific runtime.
- [ ] AC8 Diff stays scoped to documentation files plus the active story file.

## Verification Contract

- [ ] V1 `grep -n "Pygmalion\|maker\|medium\|figure" README.md AOS.md docs/core/ARCHITECTURE.md docs/core/PRD.md docs/reference/enso.md docs/reference/aos-concept.md`
- [ ] V2 `git diff -- README.md AOS.md docs/core/ARCHITECTURE.md docs/core/PRD.md docs/reference/enso.md docs/reference/aos-concept.md docs/narrative/ && git status --short`
- [ ] V3 `grep -n "Pygmalion" README.md | wc -l` (count between 1 and 3)
- [ ] V4 `test -f docs/narrative/pygmalion-paragraph.md`
- [ ] V5 `diff <(sed -n '/^> /p' README.md) <(sed -n '/^> /p' docs/narrative/pygmalion-paragraph-readme.md)`

## Context Scope

**Write:**
- `README.md`
- `AOS.md`
- `docs/core/ARCHITECTURE.md`
- `docs/core/PRD.md`
- `docs/reference/enso.md`
- `docs/reference/aos-concept.md`
- `docs/stories/STORY-013-pygmalion-narrative-substrate.md`

**Read:**
- `AGENTS.md`
- `docs/reference/STORY.md`
- `docs/reference/hitl-pge-loop-design.md`
- `docs/reference/enso-condensed.md`
- `docs/reference/enso-gnosis.md`
- `docs/reference/harness-engineering-short.md`
- `docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md`
- `docs/stories/STORY-012-upgrade-agents-to-story-v1.md`

**Exclude:**
- `.git/`
- `.pi/extensions/`
- implementation code
- `assets/` except as named above
- unrelated completed stories

## Planner Output

### Plan v1
**Date:** 2026-06-01 00:00

#### Summary

This story makes the Pygmalion model the narrative spine of enso's public docs. The README tells the story once. AOS.md applies the framing. ARCHITECTURE.md maps the model onto the existing layer table. PRD.md's Goal is tightened so the *why* of enso reads as Pygmalion-shaped, not call-center-routing-shaped. The deeper reference docs align their terminology without restating the myth.

The work is documentation-only, scoped, and verifiable with grep. It is a sibling to toni's STORY-014 (local Pygmalion alignment); the two are independent in scope but share the same narrative commitment.

#### Steps

1. **Lock the framing vocabulary — paragraph set pinned in `docs/narrative/`.**
   
   Three paragraphs are the contract. The Generator must drop them into the named files byte-for-byte. Pin them in `docs/narrative/` so both the README lead and any future AOS/ARCHITECTURE references can be diff-checked against a single source of truth.
   
   **(a) Canonical paragraph — `docs/narrative/pygmalion-paragraph.md`** (target: ~280 words):
   > *enso is built on the Pygmalion model.*
   >
   > The myth is short. A maker shapes a figure from yielding material. The maker's hand lifts. What stands there has its own face, its own voice, its own name. The maker is responsible for the figure, but not in control of it. That is the test: when the hand lifts, is what remains alive?
   >
   > The three roles map onto enso directly. **The maker** is the human — the user who decides what needs doing and when. **The medium** is the persistent substrate the maker works against: codebase, docs, configs, the durable project state that survives the session. It is the clay, the marble, the yielding stuff. It does not belong to any one figure. It is what every figure is shaped from.
   >
   > **The figure** is the orchestration surface — and through it, the agent instantiations that do the work. A figure has a read of the maker, a stance, a voice. The surface exists so the human never feels the handoff. The maker touches one figure; the figure keeps the thread.
   >
   > This framing commits enso to specific things. The maker is responsible for the medium — the substrate has to be honest, current, and well-shaped, or every figure that comes out of it is malformed. The figure is responsible for standing on its own — its read of you is its own, offered as a hypothesis and open to correction, not as a service. And the seam graph — the technique the maker's hand uses against the medium — is the part that has to be quietly excellent, so the maker can stay focused on shaping and not on plumbing.
   >
   > The unfinished sculpture is the failure mode to design against. A figure that returns work but has no read of its own is a shaped thing, not a figure. A substrate that holds the shape but doesn't carry voice produces figures that pass tests and miss the point. The standard is whether the figure is alive when the hand lifts. Everything in this protocol is in service of that standard.
   
   **(b) Tightened README lead — `docs/narrative/pygmalion-paragraph-readme.md`** (target: ~110 words):
   > enso is built on the Pygmalion model. **The maker** is the human — the user who shapes the work. **The medium** is the persistent substrate: codebase, docs, harness instance, knowledge base, the durable state that survives the session. **The figure** is the orchestration surface, and through it, the agents that do the work. The maker's hand shapes figures against the medium. When the hand lifts, what stands there has to be alive — has to have its own read, its own voice. The seam graph is the technique that lets the hand work the medium without breaking it. The unfinished sculpture is the failure mode to design against. The standard, in every session, is whether the figure stands on its own.
   
   **(c) One-line AOS opener — `docs/narrative/pygmalion-paragraph-aos.md`** (target: 1 line):
   > *enso is built on the Pygmalion model: the maker is the human, the medium is the persistent substrate, the figure is the orchestration surface the human relates to.*
   
   V4 enforces that the canonical paragraph file exists. V5 enforces that the README lead matches the tightened version byte-for-byte. The byte-for-byte rule is what keeps the two repos aligned.
   
   -> verify: V4 + V5 pass.

2. **Rewrite the README front-of-file to lead with Pygmalion.**
   The current README leads with "Intelligence lives in the model…" and dives straight into seams. Replace that lead with the Pygmalion paragraph, then let the existing seam graph and canonical stack sections *hang from* it. The seam table is still the architecture; the substrate-distinction paragraph is still the conceptual move. They just arrive second now, not first.
   
   Keep the front door short. A new reader should be able to read the Pygmalion paragraph and the seam table in under two minutes.
   
   -> verify: README lead reads as one coherent narrative from title to "The Seams" header; Pygmalion is mentioned once in the front door (V3 enforces this).

3. **Reframe AOS.md around the figure.**
   The current AOS.md reads as a contract catalog (what crosses the surface, why it matters). Keep that structure. Add a short opening paragraph that names the surface as the *figure* the human relates to — and makes the substrate explicit as the *medium* the figure is shaped against. The existing handoff-as-phone-tree framing is preserved; the new layer is the Pygmalion commitment underneath it: the human never feels the handoff because the figure keeps the thread.
   
   -> verify: AOS.md reads as a Pygmalion-shaped instance of an orchestration-surface contract, not a parallel concept system.

4. **Add a Pygmalion section to ARCHITECTURE.md.**
   The current ARCHITECTURE.md is technical and stays technical. Add a short subsection — no more than half a page — that maps maker/medium/figure to the existing layer table (model / runtime / harness protocol / harness instance / agent instantiation / substrate). This is the bridge doc: it makes the Pygmalion framing *operational* without importing prose into the architecture.
   
   The mapping: maker → the human user; medium → substrate (durable, persistent); figure → orchestration surface (the thing the maker relates to); agent instantiation → the ephemeral gestures against the medium that the figure coordinates; harness protocol / harness instance → the technique the maker's hand uses against the medium.
   
   -> verify: ARCHITECTURE.md now has a named Pygmalion section and the layer table is unchanged in shape (no new layers added, no relabeling).

5. **Tighten the PRD Goal.**
   The current PRD.md Goal is short. Add a sentence (not a paragraph) that names Pygmalion as the *test* enso is built to pass: figures must have their own voice when the maker's hand lifts. Do not import the myth into Non-Goals or Constraints.
   
   -> verify: PRD.md Goal mentions Pygmalion once, in the test-form ("the standard is whether the figure stands on its own"); no other PRD section changes.

6. **Align reference docs.**
   `docs/reference/enso.md` and `docs/reference/aos-concept.md` (if present) should use the same vocabulary when they describe the surface and the substrate. No new sections. No restating the myth. If a section already says "the surface is what the human touches," it can stay that way — the Pygmalion framing doesn't require renaming.
   
   -> verify: grep confirms `maker`, `medium`, and `figure` appear in these docs where they describe the corresponding concepts; no doc adds a Pygmalion heading.

7. **Run the verification gate.**
   V1 (grep), V2 (git diff/status), V3 (Pygmalion mention count in README). Update the checklists and evidence in this story.

#### Assumptions

- The Pygmalion model is the right *narrative* substrate even though it isn't an enso runtime concept. The story is a *frame* for the docs, not a feature of the protocol.
- toni's STORY-014 will mirror the same commitment locally; the two repos stay aligned by sharing the vocabulary, not by sharing files.
- The seam graph and canonical stack remain the technical spine. Pygmalion is the *why*; the seam graph is the *how*.
- The Pygmalion framing does not require renaming the layers. The existing layer table is good. It just gets one paragraph of Pygmalion context above it.
- The reader arriving at enso's README does not need to know the Pygmalion myth. The paragraph should *work* even if the reader has never heard the name; the name is a *spine* the reader can google later, not a *prerequisite* for understanding.

#### Risks

- **Overclaim risk.** Pygmalion is a framing, not a guarantee. If a doc claims enso *produces* alive figures, that's a claim enso can't back. Mitigation: the framing is always *what enso exists to defend*, not *what enso delivers*.
- **Myth drift risk.** Restating the myth in three places invites drift. Mitigation: V1 + V3 enforce mention count. The README gets the full paragraph; other docs get one line max.
- **Tone risk.** Pygmalion has poetic weight. enso's docs are technical. Mitigation: the README paragraph is direct and architectural. No myth-language outside it.
- **Coupling risk.** If toni's STORY-014 ships a different framing, the two repos will diverge. Mitigation: toni STORY-014's Pygmalion paragraph will be a near-copy of enso's; cross-link the two story files in `## Evidence` for traceability.
- **Runtime-coupling risk.** The Pygmalion framing could be read as requiring a specific runtime model. Mitigation: AC7 + the Plan's "Assumptions" section keep enso runtime-agnostic. PRD.md Non-Goals explicitly do not change.

#### Open Questions

- None. The Pygmalion framing is settled; the work is documentation, not architecture.

## Generator Iterations

## Evaluator Results

## Human Decisions

## Evidence

### Verification Runs
| Verification ID | Command | Result | Exit Code | Output Ref |
|---|---|---|---|---|
| V1 | `grep -n "Pygmalion\|maker\|medium\|figure" README.md AOS.md docs/core/ARCHITECTURE.md docs/core/PRD.md docs/reference/enso.md docs/reference/aos-concept.md` | TBD | TBD | TBD |
| V2 | `git diff -- README.md AOS.md docs/core/ARCHITECTURE.md docs/core/PRD.md docs/reference/enso.md docs/reference/aos-concept.md && git status --short` | TBD | TBD | TBD |
| V3 | `grep -nc "Pygmalion" README.md` | TBD | TBD | TBD |
| V4 | `test -f docs/narrative/pygmalion-paragraph.md` | TBD | TBD | TBD |
| V5 | `diff <(sed -n '/^> /p' README.md) <(sed -n '/^> /p' docs/narrative/pygmalion-paragraph-readme.md)` | TBD | TBD | TBD |

### Changed Files
- TBD

### Conventions Loaded
- `docs/reference/STORY.md#12` (canonical template)
- `docs/stories/STORY-011-pge-narrative-and-story-substrate-alignment.md` (precedent: doc-only narrative story)
- `docs/stories/STORY-012-upgrade-agents-to-story-v1.md` (precedent: surgical doc diff)
- Sibling: `../toni/docs/stories/STORY-001-pygmalion-local-story-substrate.md` (downstream mirror; the *toni* repo owns the canonical Pygmalion paragraph at `docs/narrative/pygmalion-paragraph.md`; the enso README lead carries the enso-flavoured mirror pinned at `docs/narrative/pygmalion-paragraph-readme.md`)

## Transition Log
| Time | Actor | Event | From | To | Note |
|---|---|---|---|---|---|
| 2026-06-01T00:00:00Z | human | seed | seeded | seeded | Story seeded. Awaiting planner output and plan-review approval. |
