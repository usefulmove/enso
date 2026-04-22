# Lessons Learned

Unchecked items are pending review. Check items when integrated into the harness. Remove checked items on cleanup.

- [ ] Bootstrap operations must never overwrite user-modified files without an explicit guard — check existence before writing
- [ ] OpenCode slash commands auto-discover from `~/.config/opencode/commands/` — no registration in `opencode.json` required
- [ ] `@file` references in slash commands fail silently when files are missing — use `!` shell commands to detect and report
- [ ] Bootstrap should fetch canonical seed files from remote source, not copy local files — hard-fail on network errors
- [ ] Using the harness to improve itself surfaces real friction fast — dogfooding is essential
- [ ] Agents as teammates (not tools) shifts interaction from command execution to collaborative delegation — requires persistent identity and handoff mechanisms
- [ ] "The emacs of X" communicates self-extensibility in one phrase — the harness must be agent-modifiable
- [ ] The recursive loop `Harness_t → Agent → Harness_{t+1}` is the core primitive — each session's output is the next session's input
- [ ] The human is the God agent — technical program manager who sets vision, hires specialists, delegates work
- [ ] Cold-start cost is the primary friction target — warm starts (resuming with full context) are significantly more productive
- [x] Defer loading source files until the story that needs them is executing — probe first, assume nothing → Integrated into AGENTS.md §10.1 and §4 cross-reference
- [ ] Same core message, adapted to medium constraints and audience expectations
- [x] Draft → Review → Approve → Execute works for founder-facing content — multiple drafts let the founder choose voice → Integrated into `convert-request-to-story` skill Step 4
- [ ] Agent-facing docs: remove persuasion, analogy, and "how to use" — keep declarative commands, frontmatter, and structured templates (40%+ token reduction)
- [x] Agents self-evaluate poorly — dedicated QA pass after implementation catches gaps; human intervenes only on disagreements → Integrated into `review-before-commit` skill (§10.4) and AGENTS.md §10.4
- [ ] `/enso-persist` → `/enso-start` is a valid full context reset — gap between steps is a good time to commit to git
- [ ] Workflow templates outlast persona prompts — as models improve, personas become unnecessary scaffolding; keep model choice with the human
- [ ] Review-only modes must deny mutating tools via config, not just prompt text — behavior drifts based on fallback permissions
- [ ] Planning/reasoning modes need shell access scoped to a read-only allowlist — treat safe bash as a first-class capability separate from implementation authority
- [ ] Agent modes defined solely by model choice are unnecessary scaffolding — model routing is a reference concern, not a mode concern