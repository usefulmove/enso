---
name: create-skill
description: Author a new reusable skill (SKILL.md) for the skills library. Use this when building a capability that should be discoverable and loadable in future sessions. Triggered by the Pi Principle — when you encounter friction, build the tool.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- A recurring task has no existing skill
- A complex procedure needs to be captured for reuse
- A capability gap is identified during a session
- The user asks to create or formalize a skill

---

## Spec Reference

The authoritative opencode skill specification lives at:
**https://opencode.ai/docs/skills/**

Consult it for current frontmatter fields, name validation rules, length limits, and permission configuration. The summary below reflects current best practice — when in doubt, the spec takes precedence.

---

## What Makes a Good Skill

A skill is a **reusable, loadable workflow** — not a one-off script. It should:
- Solve a specific, recurring problem
- Be general enough to apply across projects
- Be concise enough to load without bloating the context window
- Tell the agent *when* to use it, not just *how*

A skill is **not**:
- A project-specific script (put that in `docs/skills/<project>/` or `scripts/`)
- A reference document (put that in `docs/reference/`)
- A story or task (put that in `docs/stories/`)

---

## Skill Structure

```
docs/skills/<skill-name>/
  SKILL.md          # required — the skill itself
  scripts/          # optional — helper scripts
  references/       # optional — reference material
  assets/           # optional — templates, examples
```

`SKILL.md` is the only required file. Add supporting directories only when they add real value.

---

## SKILL.md Format

```markdown
---
name: <skill-name>
description: <One sentence. What it does and when to use it. This is what agents read to decide whether to load the skill.>
license: MIT
compatibility: opencode
---

## When to Use

<2-5 bullet points. Specific triggers. When should an agent load this skill?>

---

## <Workflow or Concept Section>

<The actual skill content. Structure depends on the skill type:>
- Procedural skills: numbered steps, phases, checklists
- Reference skills: tables, examples, decision trees
- Hybrid: both

## Checklist (if applicable)

- [ ] <Verifiable completion criteria>
```

### Frontmatter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `name` | yes | Lowercase alphanumeric + single hyphens. Must match the directory name exactly. 1–64 chars. |
| `description` | yes | **The primary discovery signal.** Agents read this to decide whether to load the skill. Be specific about what it does *and* when to use it. 1–1024 chars. |
| `license` | yes | MIT unless otherwise specified |
| `compatibility` | yes | `opencode` |
| `metadata` | no | String-to-string map for additional context (audience, workflow, etc.) |

---

## Naming for Discoverability

The skill `name` is the first thing an agent sees. It must be self-describing without reading the description.

**Rules:**
- Verb-noun preferred: `explain-code`, `create-skill`, `document-knowledge-base`
- Name the *action*, not the *artifact*: `document-knowledge-base` not `knowledge-base`
- Be specific enough to distinguish from similar skills: `document-knowledge-base` not `document`
- If you can't tell what the skill does from the name alone, rename it

**Test:** Read the name cold. Does it tell you what the skill *does* and roughly *when* to use it? If not, it's not discoverable enough.

---

## Workflow

1. **Name it** — verb-noun, action-oriented, self-describing (see Naming above)
2. **Write the description first** — if you can't describe it in one sentence, the scope is too broad
3. **Draft `When to Use`** — specific triggers, not vague categories
4. **Write the workflow** — procedural steps, reference tables, or both
5. **Add a checklist** if the skill has verifiable completion criteria
6. **Create the directory and file**
7. **Test it** — mentally walk through the skill as if loading it fresh. Is anything missing? Is anything redundant?

---

## Checklist

- [ ] Name is verb-noun, action-oriented, and self-describing without reading the description
- [ ] `name` in frontmatter matches directory name exactly
- [ ] `description` is one sentence, specific enough to distinguish from other skills, and tells the agent both what it does and when to use it
- [ ] `When to Use` has concrete triggers
- [ ] Workflow is complete enough to execute without prior context
- [ ] No project-specific content (keep it general)
- [ ] Spec consulted for any fields or rules not covered here: https://opencode.ai/docs/skills/
- [ ] File written to correct location (`~/.config/opencode/skills/` for global, `docs/skills/` for project-local)
