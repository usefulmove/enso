# Strategic Model Routing

## 1. Deep Reasoning & Planning
**What:** Strategic planning, architecture decisions, complex problem decomposition, ambiguous requirements
**Best:** Claude Opus 4.6
**Budget:** Claude Sonnet 4.6
**Open weights:** Qwen3.5 397A17B, GLM-5

## 2. Research & Synthesis
**What:** Literature review, competitive analysis, summarizing complex topics, cross-referencing sources
**Best:** Claude Opus 4.6 / Gemini 3.1 Pro (both 1M context)
**Budget:** GPT-5.4 Mini
**Open weights:** Qwen3.5 397A17B, Kimi K2.5

## 3. Creative & Narrative
**What:** Story creation, tone-sensitive writing, marketing copy, persona work
**Best:** Claude Opus 4.6 / Claude Sonnet 4.6
**Budget:** GPT-5.4 Mini
**Open weights:** Kimi K2.5, MiniMax M2.5

## 4. Coding
**What:** Code changes, bug fixes, refactoring, test writing
**Best:** GPT-5.4 (Terminal-Bench 75.1%), Claude Opus 4.6 (SWE-bench 80.8%)
**Budget:** GPT-5.4 Mini
**Open weights:** Qwen3 Coder 480B, MiniMax M2.7

## 5. Terminal & DevOps
**What:** CLI workflows, CI/CD debugging, infrastructure tasks, system administration
**Best:** GPT-5.4 (75.1% Terminal-Bench)
**Budget:** GPT-5.4 Mini
**Open weights:** Step 3.5 Flash, DeepSeek V3.2

## 6. Multimodal & Documents
**What:** Image analysis, document understanding, OCR tasks
**Best:** Qwen 3.6 Plus, Gemini 3.1 Pro
**Budget:** Qwen 3.6 Plus (free during preview)
**Open weights:** Gemma 4, Qwen3.6 Plus

---

# Default Strategy

| Bucket | Default | Fallback | Open Weights |
|--------|---------|----------|--------------|
| Planning/Reasoning | Claude Opus 4.6 | GPT-5.4 | Qwen3.5 397A17B |
| Research | Gemini 3.1 Pro | Claude Opus 4.6 | Qwen3.5 397A17B |
| Creative/Writing | Claude Sonnet 4.6 | Opus 4.6 | Kimi K2.5 |
| Coding | GPT-5.4 | Claude Opus 4.6 | Qwen3 Coder 480B |
| Terminal/DevOps | GPT-5.4 | GPT-5.4 Mini | Step 3.5 Flash |
| Multimodal | Gemma 4 | Gemini 3.1 Pro | Qwen3.6 Plus |
