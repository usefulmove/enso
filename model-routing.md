# Strategic Model Routing

| Category | Use Cases | Best | Budget | Open Weights |
|----------|-----------|------|--------|--------------|
| Deep Reasoning & Planning | Strategic planning, architecture decisions, complex problem decomposition, ambiguous requirements | Claude Opus 4.6 | Claude Sonnet 4.6 | Qwen3.5 397A17B, GLM-5 |
| Research & Synthesis | Literature review, competitive analysis, summarizing complex topics, cross-referencing sources | Claude Opus 4.6 / Gemini 3.1 Pro (both 1M context) | GPT-5.4 Mini | Qwen3.5 397A17B, Kimi K2.5 |
| Creative & Narrative | Story creation, tone-sensitive writing, marketing copy, persona work | Claude Opus 4.6 / Claude Sonnet 4.6 | GPT-5.4 Mini | Kimi K2.5, MiniMax M2.5 |
| Coding | Code changes, bug fixes, refactoring, test writing | GPT-5.4 (Terminal-Bench 75.1%), Claude Opus 4.6 (SWE-bench 80.8%) | GPT-5.4 Mini | Qwen3 Coder 480B, MiniMax M2.7 |
| Terminal & DevOps | CLI workflows, CI/CD debugging, infrastructure tasks, system administration | GPT-5.4 (75.1% Terminal-Bench) | GPT-5.4 Mini | Step 3.5 Flash, DeepSeek V3.2 |
| Multimodal & Documents | Image analysis, document understanding, OCR tasks | Qwen 3.6 Plus, Gemini 3.1 Pro | Qwen 3.6 Plus (free during preview) | Gemma 4, Qwen3.6 Plus |

---

## Default Routing Strategy

| Category | Default | Fallback | Open Weights |
|----------|---------|----------|--------------|
| Planning / Reasoning | Claude Opus 4.6 | GPT-5.4 | Qwen3.5 397A17B |
| Research | Gemini 3.1 Pro | Claude Opus 4.6 | Qwen3.5 397A17B |
| Creative / Narrative | Claude Opus 4.6 | Claude Sonnet 4.6 | Kimi K2.5 |
| Coding | GPT-5.4 | Claude Opus 4.6 | Qwen3 Coder 480B |
| Terminal / DevOps | GPT-5.4 | GPT-5.4 Mini | Step 3.5 Flash |
| Multimodal | Gemma 4 | Gemini 3.1 Pro | Qwen3.6 Plus |
