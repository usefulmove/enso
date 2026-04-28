# STORY-QMS-001 Embed Minimal QMS in Agent Workflow

## Goal
Update `AGENTS.md` to embed quality gates, a risk register, and a sign-off protocol into the agentic story lifecycle. This is Phase 1 of the QMS: policy-driven, no new tooling, strict enforcement by the agent via harness instructions.

## Acceptance Criteria
- [ ] `AGENTS.md` §4 (Planning Phase) is updated to include **Gate Q1**: no file modifications until `Approach & Verification Plan` is complete and contains a `### Risks & Unknowns` subsection with at least one identified risk.
- [ ] `AGENTS.md` §5 (Document Lifecycle) is updated to require **Gate Q3**: no story is moved to completed without all acceptance criteria checked `[x]` with linked evidence.
- [ ] `AGENTS.md` §5 is updated to require **Gate Q4**: no story is moved to completed without a completed `### Reflection` section, including extraction of lessons to `LESSONS.md` if applicable.
- [ ] A new section in `AGENTS.md` (or update to §4/§5) defines the **Sign-Off Protocol**: before requesting a state transition, the agent must append a self-certification block attesting that the diff is scoped, verified, and compliant.
- [ ] The Story Template in §9 is updated to include:
   - a `risks:` YAML frontmatter block
   - a `### Risks & Unknowns` subsection in `Approach & Verification Plan`
   - a `### Sign-Off` subsection in the story body
- [ ] `AGENTS.md` §5 formalizes `LESSONS.md` as the CAPA log: every reopened story or scope breach must leave an unchecked lesson.
- [ ] The proposal file `docs/reference/qms-proposal.md` is updated to reflect that Phase 1 is complete (or removed if fully merged into `AGENTS.md`).
- [ ] A session summary is written to `docs/logs/` documenting the QMS Phase 1 changes.

## Context Scope
**Write:**
- `AGENTS.md`
- `docs/reference/qms-proposal.md`
- `docs/logs/`

**Read:**
- `docs/reference/qms-brainstorm-synthesis.md`
- `docs/reference/LESSONS.md`

**Exclude:**
- Any other `docs/` files
- Source code changes
- New tooling/scripts

## Approach & Verification Plan

### Steps
1. Read current `AGENTS.md` and `docs/reference/qms-brainstorm-synthesis.md`.
2. Update `AGENTS.md` §4 to embed Gate Q1: planning completeness check including risk subsection.
3. Update `AGENTS.md` §5 to embed Gate Q3 (verification) and Gate Q4 (reflection).
4. Add Sign-Off Protocol to `AGENTS.md` (new subsection in §4 or §5).
5. Update the Story Template in §9 with risk frontmatter, risk subsection, and sign-off block.
6. Update `LESSONS.md` CAPA formalization in §5.
7. Update or remove `docs/reference/qms-proposal.md`.
8. Write session summary to `docs/logs/`.

### Risks & Unknowns
- Risk: Updating `AGENTS.md` while following `AGENTS.md` rules may create recursive confusion. Mitigation: treat `AGENTS.md` as a controlled document under QMS change control; every change maps to this story.
- Risk: Adding frontmatter might break existing parsers or skills. Mitigation: `risks:` is additive; existing `name`/`description`/`license` frontmatter is untouched.
- Risk: Sign-off block may feel bureaucratic to the user. Mitigation: keep it to one sentence; it's an attestation, not a form.

### Verification
- [ ] Run a diff on `AGENTS.md` and confirm all new sections are present and no unrelated sections were modified.
- [ ] Verify the Story Template in §9 contains the new fields.
- [ ] Verify `docs/logs/` has a new session summary.

### Reflection
- [ ] Encountered recurring friction → create skill?
- [ ] Discovered new pattern → update architecture doc?
- [ ] Lesson learned → add to LESSONS.md?
- [ ] No new insights → proceed

**Do not begin execution until this section is complete.**