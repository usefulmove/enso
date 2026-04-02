# STORY-005 Enso QA + Prompt Templates

## Goal

Add `/enso-qa` command and prompt templates (workflows) to enso harness.

## Acceptance Criteria

- [ ] `/enso-qa` command exists in `~/.config/opencode/commands/`
- [ ] `/enso-qa` loads active story and lists unchecked acceptance criteria
- [ ] `/enso-qa` allows human to confirm or flag each criterion
- [ ] `/enso-qa` flags criteria with QA comments when human disagrees
- [ ] Prompt templates documented in `docs/skills/prompt-templates/`
- [ ] Implementation template (story → execute → qa → close)
- [ ] Research template (probe → summarize → report)
- [ ] QA template (review → verify → flag/confirm)
- [ ] Architecture template (design → document → validate)

## Context Scope

**Write:**
- `~/.config/opencode/commands/enso-qa.md`
- `docs/skills/prompt-templates/SKILL.md`
- `docs/skills/prompt-templates/templates/*.md`

**Read:**
- `AGENTS.md`
- `docs/core/PRD.md`
- `docs/core/architecture/ARCHITECTURE.md`
- `~/.config/opencode/commands/enso-*.md` (existing commands for reference)

**Exclude:**
-

## Approach & Verification Plan

### Steps

1. **Research existing commands** — Read `enso-close.md`, `enso-compact.md` for command structure patterns
2. **Create `/enso-qa` command** — Draft command file with:
   - Load active story
   - List unchecked ACs
   - Interactive confirm/flag workflow
   - Update story with QA comments
3. **Create prompt-templates skill** — Create `docs/skills/prompt-templates/` with:
   - SKILL.md (overview, when to use each template)
   - templates/implementation.md
   - templates/research.md
   - templates/qa.md
   - templates/architecture.md
4. **Update enso-help** — Add `/enso-qa` to command list
5. **Test** — Run `/enso-qa` on a completed story to verify

### Risks & Unknowns

- Story file format for QA comments — need to decide format (inline vs block)
- How to detect "active story" — need to probe docs/stories/ for latest file
- Verification method for prompt templates — just documentation, no code to test

### Verification

- [ ] `/enso-qa` command loads and executes without error
- [ ] Checked ACs are correctly identified
- [ ] QA comments are persisted to story file
- [ ] Prompt templates are readable and usable
- [ ] Update `docs/core/architecture/ARCHITECTURE.md` if new subsystems discovered.

**Do not begin execution until this section is complete.**

## Progress Update: 2026-04-01

### Completed
- Reviewed `agent-research-2026-03-30.md` and `anthropic-harness-article-takeaways.md`
- Discussed all four candidate improvements with human
- Created and scoped this story

### Key Decisions
- `/enso-qa` acts as the evaluator pass: reviews ACs on the active story, confirms or flags with QA comments. Human only reviews disagreements.
- Keep `/enso-compact` → `/enso-start` as the context-reset pattern; no `/enso-reset` command.
- Prompt templates = workflow templates (not persona prompts); model selection stays with human.
- Story contracts deferred (not in scope for this story).

### In Progress
- No implementation yet; story is planned and approved.

### Remaining
- All steps in Approach & Verification Plan above.