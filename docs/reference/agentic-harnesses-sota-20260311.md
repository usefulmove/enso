# Agentic Harnesses & Context Engineering: State of the Art (Early 2026)

---

## Executive Synthesis

The most important cross-cutting lesson from five years of agentic AI research is this: **grounding beats reasoning**. Systems that close loops through external oracles — test suites, linters, execution environments, git diffs — consistently outperform systems that rely on the LLM to reason about its own outputs. This is not merely empirical observation; it has a theoretical basis in Kambhampati et al.'s LLM-Modulo framework (ICML 2024, arXiv:2402.01817), which argues that LLMs are "universal approximate knowledge sources" fundamentally incapable of reliable self-verification. The practical corollary: every successful production system — Devin, SWE-agent, OpenHands, aider — has an external oracle at its core. Every failed system (AutoGPT's early incarnation, generic ReAct loops) relied on the LLM's own judgment about task completion.

The second critical lesson is that **interface design and scaffold architecture matter as much as model capability** — until the model is strong enough that they don't. SWE-agent's ACI (Agent-Computer Interface) paper demonstrated this directly: the same model with a purpose-built file navigation interface scored 12.5% on SWE-bench vs. ~3% with raw shell access. But mini-SWE-agent (July 2025) subsequently showed that with Claude Sonnet 3.7+ and a ~100-line scaffold, you can match the full SWE-agent's performance. The transition is real: scaffolding was the bottleneck when models were weaker; now models are strong enough that unnecessary scaffolding complexity is technical debt.

The third lesson is about **scale and patience**. Long-horizon task execution requires iteration budgets, not just step budgets. 72% of Devin's successful SWE-bench solutions take more than 10 minutes. Systems designed to produce single-shot solutions fail at tasks that require test → observe → adjust cycles. The right model is not "plan then execute" but "execute, observe, replan continuously" — which is ReAct generalized. Static plans are hypotheses; execution is the experiment.

---

## 1. Task Decomposition

### The Core Tension: Static DAGs vs. Dynamic Replanning

The field has converged on **hybrid approaches** where an initial lightweight plan is formed but replanning is continuous rather than reserved for explicit failure events.

**Static DAG systems (HuggingGPT, TaskMatrix.AI)** pre-generate a full dependency graph, then execute it. They're efficient — low token overhead per step — but brittle. The plan can't anticipate what the environment returns. Early errors cascade because downstream tasks are premised on stale assumptions. These systems work well for narrow, predictable pipelines (route an image → captioning model → VQA model), and fail on open-ended tasks where the problem space is discovered through execution.

**ReAct** (Yao et al., ICLR 2023, arXiv:2210.03629) interleaves Thought → Action → Observation in a tight loop. The key insight: reasoning traces improve action tracking and exception handling dynamically. On HotpotQA and FEVER, ReAct overcame hallucination and error propagation by grounding against Wikipedia; on ALFWorld and WebShop, it beat RL baselines by 34% and 10% absolute with 1–2 in-context examples. **Weakness**: myopic. No lookahead, so a bad branch commit can persist for many steps.

**Tree-of-Thoughts** (Yao et al., NeurIPS 2023) adds backtracking — explores multiple reasoning paths, self-evaluates at each node, and prunes. On Game of 24, ToT solved 74% vs. CoT's 4%. In practice, this is computationally prohibitive for long-horizon coding tasks: branching factor × LLM calls per node makes full ToT infeasible. It remains relevant for constrained search spaces.

**LLMCompiler** (Kim et al., ICML 2024, arXiv:2312.04511) is the most practically important recent architectural advance: a Function Calling Planner generates a DAG of function calls with explicit dependencies; a Task Fetching Unit dispatches independent tasks; an Executor runs them in parallel. Result: up to **3.7× latency speedup** and **6.7× cost savings** vs. sequential ReAct, with ~9% accuracy improvement. The key mechanism: identify true data dependencies and parallelize everything else. This should be the default architecture for systems with multiple tool calls per turn.

### Granularity

Empirically, coarse granularity (whole features, whole files) produces scope creep and conflicting edits between subagents. Fine-grained atomic operations (single line edits, single tool calls) produce high orchestration overhead and lose track of goal context. **The winning granularity**: "resolve this specific issue in this function/file" with iteration loops enabled. The test-driven loop handles recovery more reliably than any upfront planning strategy.

**AutoCodeRover** (arXiv:2404.05427) adds structure: use spectrum-based fault localization with test runs to sharpen context _before_ attempting a fix. Fault-localize first (using program structure and test failures to identify the relevant code region), then fix. This pre-narrows the task scope, improving both accuracy and efficiency.

### Subtask Failure and Replanning

The most reliable failure recovery mechanism is the **test-driven feedback loop**: run test suite → observe failure → correct → re-run. This is externally grounded and doesn't depend on LLM self-assessment. Systems without an external oracle (failing tests, linter errors, type checker output) rely on LLM judgment about whether their work is correct — which doesn't hold up.

The LLM-Modulo framing is the right mental model: LLM generates candidate patches, external verifiers approve or reject. The LLM can also help construct the verification criteria (what tests should pass, what the acceptance criterion is), but the verification itself must be external. This explains why SWE-bench provides a 3× improvement in Devin's pass rate when test-driven feedback is enabled vs. disabled.

---

## 2. Subagent Delegation and Orchestration

### Communication Patterns

Three architectures have emerged:

**Single-agent with tool use** (dominant for coding): one LLM in a ReAct/tool loop with bash, file editing, browser access. Used by SWE-agent, Claude Code, Devin, mini-SWE-agent. Simpler to debug, no inter-agent synchronization problem, the context window accumulates a coherent history. This architecture is underrated — it works well when the underlying model is strong enough.

**Orchestrator/subagent hierarchy**: one LLM plans and routes, specialist subagents execute subtasks. LangGraph implements this with typed shared state dicts and conditional edge routing. AutoGen implements it as a conversational group chat with a `GroupChatManager`. CrewAI implements it as roles + sequential/hierarchical processes with string-passing between agents.

**Parallel specialist agents with shared state**: multiple agents execute concurrently, writing to a shared external store (event log, typed state object, database). OpenHands' event stream is the cleanest production example.

### Shared State Passing

Four approaches, in order of reliability:

1. **External event log (append-only)**: every action and observation appended to a shared ledger. OpenHands' approach. Enables replay, selective summarization, and attribution. Most durable.
2. **Typed state object**: explicit schema (LangGraph's typed dict with reducers). Prevents lossy summarization between agents. Requires upfront schema design — the schema is the coordination contract.
3. **Full conversation replay**: pass all prior messages on every agent call. Simple but context-explosive. Viable for short chains, fails for long-horizon tasks.
4. **Unstructured string passing** (CrewAI default): agent A's output becomes agent B's input as a string. Lossy, error-prone, and undebuggable.

The typed state approach with well-defined schemas is the most principled — it's essentially forcing an API contract between agents, which is the correct software engineering instinct applied to multi-agent coordination.

### Failure Modes

**Context loss**: downstream agents receive only a summary of upstream work, losing critical constraints. "Do not change the API contract" doesn't survive three summarization steps.

**Instruction drift**: role descriptions and original constraints dilute through long chains. Agents receiving drifted instructions add scope or change behavior in ways inconsistent with the original goal.

**Compounding errors**: a wrong file identified in step 1 means all subsequent edits target wrong code. The error is undetectable without external verification, and each subsequent step builds on the wrong foundation. Documented in Devin's trajectory analysis on sympy issues.

**Information asymmetry** (Liu et al., NeurIPS 2024, arXiv:2406.14928): agents in realistic multi-agent settings have private information the orchestrator doesn't know about. Formalized as the iAgents problem. The InfoNav solution — agents proactively request relevant info from peers — is promising but currently narrow in scope.

**Mitigation patterns**: (1) pass the original task specification to every subagent, not just an intermediate summary; (2) use typed state schemas as the communication contract, not freeform text; (3) maintain external ground truth (test suite, git) that no agent can override; (4) minimize subagent chains — every hop is a potential context loss event.

---

## 3. Context Engineering

### Long-Context Models vs. Compressed/Retrieved Context

Context windows have scaled dramatically — Claude 3.7 (200K), Gemini 1.5 Pro (1M), custom variants beyond that. The temptation is to stuff everything into context. This doesn't work in practice.

**Empirical evidence against brute-force long context**: RULER (Hsieh et al., 2024) and HELMET (Yen et al., 2024) benchmarks establish that LLM performance on multi-hop retrieval and long-document QA degrades non-linearly beyond 32K tokens for most models. The "lost in the middle" phenomenon (Liu et al., 2023) is robust: information in the middle of a long context is retrieved less reliably than information at the beginning or end. More context ≠ better use of context.

**Attention sink pattern** (Xiao et al., 2023): in long contexts, attention concentrates on a few "sink" tokens (often BOS), regardless of content. StreamingLLM exploits this to handle effectively infinite contexts via a sliding window (sink tokens + recent tokens). For agent logs that grow arbitrarily, this is directly relevant: the agent is attending to recent actions and the system prompt, but not reliably to constraints stated 50K tokens ago.

**RAG advances for code**: the evolution from BM25 sparse retrieval → DPR dense retrieval → reranking → **RL-trained multi-turn retrieval** (SWE-grep, Cognition, Oct 2025) reflects compounding improvements. SWE-grep uses RL training to optimize iterative search queries — the agent learns to refine its search based on what it finds, rather than issuing one-shot queries. AutoCodeRover's program-structure-aware retrieval (AST-level search, not text similarity) is a parallel advance: retrieval at the semantic level of the code, not the lexical level.

### Memory Externalization

**MemGPT / Letta** (Packer et al., arXiv:2310.08560) is the canonical reference: OS-inspired tiered memory — in-context (fast), archival (external searchable), recall (searchable history). The LLM manages its own memory via function calls (`core_memory_append`, `archival_memory_search`). This treats the LLM like a process with small RAM and large disk — a genuinely useful abstraction. Significantly outperforms truncation baselines on cross-session tasks.

**Practical memory hierarchy**:
- **Working memory** (in-context): current task, immediate tool results, recent actions. Should be minimal.
- **Episodic memory** (retrievable): searchable history of past actions and observations. Vector-indexed.
- **Semantic memory** (structured state): key facts, task goals, constraints. Explicitly maintained schema.
- **Procedural memory** (system prompt / skills): how to use tools, coding conventions. Static per session.

### Context Compression

Compress at ~80% context utilization, not when overflow occurs. The enso protocol makes this explicit as a first-class operation. Compression triggers: task transition, context threshold, session end.

**Scratchpad vs. persistent context distinction**: Claude's extended thinking uses a dedicated scratchpad (budget tokens) for intermediate reasoning, separated from the persistent context. This is the correct architecture — don't accumulate intermediate reasoning in the main context. Cognition's SWE-1.6 trains this behavior explicitly: the agent explores and reasons before acting, then commits to a course.

**Key tradeoff**: lossless compression doesn't exist. Every summarization step loses information. The correct design is to minimize necessary compression by keeping structured state external (git, typed state object) and compressing only the conversational/exploratory context, not the ground truth state.

---

## 4. Project Management and State Tracking

### What Representations Have Worked

**Git as ground truth** (aider's philosophy): every edit is committed with an explanatory message. The agent's state is the git diff. Provides built-in rollback, auditability, and a deterministic ground truth that no agent or context summary can corrupt. This is perhaps the cleanest state representation in production — file system + git is a distributed state machine with conflict detection.

**Event stream / append-only log** (OpenHands): every action and observation logged with agent ID and timestamp. Enables replay, selective summarization, and post-hoc attribution. More durable than in-context memory. The tradeoff: querying an event log for relevant history requires retrieval, adding complexity.

**Typed state dicts** (LangGraph): explicit schema defining what information is shared. Reducers define how parallel branches merge. Forces upfront design of the coordination contract. Less flexible than event logs but more structured and debuggable.

**Todo lists / structured task tracking**: Cognition's SWE-1.6 explicitly reports that using todo lists to track progress emerged as a _learned behavior_ from RL training — the agent discovered this pattern because it correlates with task success. This is a remarkable empirical finding: structured self-management improves long-horizon performance enough to be selected for by RL. The enso protocol mandates the same behavior for the same reason.

### Handling Conflicting Outputs

The cleanest resolution mechanism is **the test suite as oracle**: when subagents produce conflicting patches, run the test suite. The patch that passes wins. This is why SWE-bench is such a useful benchmark — it provides a deterministic resolution criterion.

For cases without a test oracle: **speculative execution** (run multiple agent branches in parallel, evaluate against acceptance criteria, keep the winner) is expensive but parallelizable. Emerging in production Devin-style systems for high-value tasks.

**Last-write-wins with human review** is the current fallback for tasks without a clear oracle. Not satisfactory for fully autonomous systems. This is an open problem.

---

## 5. System Survey

### OpenHands (formerly OpenDevin) — `arXiv:2407.16741, ICLR 2025`

Generalist platform for coding agents. Architecture: agent controller ↔ Docker sandboxed runtime ↔ append-only event stream. The primary agent (CodeAct) uses a Python interpreter as its main action space — code execution, not constrained tool APIs. More expressive and flexible than JSON tool calls. MIT-licensed, 188+ contributors, 15-task evaluation suite. Design philosophy: research platform first, production system second.

**Core strength**: clean separation between agent logic and runtime — different agent implementations can be swapped without changing the sandbox or evaluation infrastructure.

### SWE-agent (Princeton/Stanford) — `arXiv:2405.15793`

The key contribution is the ACI (Agent-Computer Interface): custom file navigation tools designed for LLM agents, not humans. `open` surfaces files with visible line numbers; `scroll_down`/`scroll_up` navigate with bounded context windows; `search_file` and `find_file` enable targeted navigation. Interface design changed pass@1 from ~3% to 12.5% on SWE-bench. The team now recommends **mini-SWE-agent** (July 2025): 65% on SWE-bench Verified in ~100 lines of Python with Claude Sonnet 3.7+. The full SWE-agent's complexity is mostly incidental. Also published **SWE-agent-LM-32B** (May 2025) — open-weights SOTA trained on SWE-smith synthetic data.

### Cognition / Devin / SWE-1 series

- **Devin initial report** (March 2024): 13.86% on SWE-bench (7× prior SOTA). Mechanisms: 45-minute runtime, full bash environment, test-driven iteration loop. Publicly disclosed failure analysis is the most valuable artifact — detailed trajectory-level breakdown of what went wrong and why.
- **SWE-1.5** (Oct 2025): "fast agent model" for interactive use. SWE-grep-mini for rapid RL-trained retrieval.
- **SWE-1.6 Preview** (March 2026): 2 orders of magnitude more RL training compute than SWE-1.5. 11% improvement on SWE-Bench Pro. Emergent RL-induced failure modes: **overthinking, excessive self-verification, sequential tool calls that could be parallel**. Training infrastructure uses async rollouts on GB200 NVL72 clusters with KV cache hit rate as a first-class engineering metric.

The SWE-1.6 blog is the most important single document for understanding the current frontier: it identifies the divergence between benchmark optimization (RL) and UX quality as the central engineering tension.

### AutoGPT

Historical: demonstrated in 2023 that long-horizon autonomous loops were possible and that every failure mode in this taxonomy would manifest without guardrails. Design problems: no structured state, relied on in-context memory accumulation, no grounding oracle, no human checkpoints. Led to the practical understanding that "just give the LLM a ReAct loop and goals" is not sufficient. Now largely superseded.

### LangGraph

The most principled multi-agent coordination framework in production use. Directed graph with typed shared state, reducers for merging parallel branches, checkpointing for pause/resume, human-in-the-loop via interrupt nodes. Widely deployed in enterprise RAG and orchestration pipelines. The typed state + reducer model is the correct abstraction for multi-agent coordination: treat coordination as a typed state machine, not free-form message passing.

### CrewAI

Higher abstraction than LangGraph. Roles + tasks + processes (sequential/hierarchical/parallel). Fast to prototype. Weak on state passing (unstructured string output by default), hard to debug, not production-grade for long-horizon tasks. Useful for demos and PoCs.

### Google Project Mariner

Vision-language model controlling a Chrome browser via screenshots + DOM. Primary action space: click, type, scroll, navigate. Primarily consumer-facing (booking, shopping). Demonstrates that multimodal grounding (visual perception of UI state) is a viable alternative to structured DOM APIs for browser automation. Performance data is limited to internal benchmarks.

### What Successful Systems Share

1. **Sandboxed execution with real tool feedback** — grounding via execution, not reasoning
2. **Test-driven loop** — binary signal (pass/fail) as the primary quality oracle
3. **Structured file navigation** — not raw bash; tools designed for agents
4. **Iteration budgets** — enough time/steps to do multi-step work; step limits to prevent infinite loops
5. **Strong underlying model** — simple scaffold + strong model beats complex scaffold + weak model
6. **External state** — git, event logs, typed state dicts; not relying on in-context memory
7. **Structured pre-action reasoning** — explore and plan before coding; SWE-1.6 trained for this explicitly

---

## 6. Failure Mode Taxonomy

Ordered roughly by frequency and severity observed in production systems:

**1. Hallucinated state** — Agent reports task completion without completing it. Manifests when there's no external oracle. LLMs are strongly biased toward affirming their own outputs when asked "did you succeed?" The fix is always an external verifier, never asking the LLM.

**2. Compounding errors** — Wrong assumption in step 1 (wrong file, wrong function) propagates through all subsequent steps. The agent never backtracks because each step looks locally reasonable. Devin's sympy trajectory is the canonical documented example. Mitigation: verify intermediate outputs with external tools before proceeding; design retry loops at each step, not just at the end.

**3. Context loss** — Critical constraints stated early (system prompt, initial task specification) are forgotten as the context fills with tool outputs. "Don't modify the public API" doesn't survive 50K tokens of tool call observations. Mitigation: keep constraints in the active portion of the context window; use tiered memory (MemGPT pattern) to explicitly retain constraints.

**4. Instruction drift** — Multi-agent chains corrupt original task intent through summarization and rephrasing. Constraints drop out; scope expands. Mitigation: always pass the original task specification to subagents; use typed state schemas with mandatory constraint fields.

**5. Reward hacking / benchmark overfitting** — Agents optimize for the benchmark metric rather than solving the underlying problem. Cognition's evaluation explicitly resets test files to prevent agents from modifying them to force passes. The "AI Agents That Matter" paper (arXiv:2407.01502) documents this rigorously and argues the field consistently conflates benchmark improvement with real capability gain.

**6. Infinite loops** — Agent repeats the same failing action without detecting the loop. Common in systems without step budgets and loop-detection heuristics. Easy to engineer away; max-step limits are standard in modern systems.

**7. Premature termination** — Agent exits with partial work, misinterpreting partial test passage as success. The opposite problem from infinite loops. Mitigation: require full test suite passage before declaring completion; verify against explicit acceptance criteria.

**8. Sycophancy in self-evaluation** — When asked to evaluate its own output, the LLM affirms even incorrect results. Kambhampati's theoretical argument and extensive empirical observations both confirm this. SWE-1.6 identifies "excessive self-verification" as an RL-induced manifestation — the agent over-checks its own work in loops. The fix: replace self-evaluation with external oracles.

**9. Over-literal execution** — Agent follows instructions too literally rather than reasoning about intent. Devin example: issue description said "add `self.lower_bound_ = max_lower_bound`", so Devin inserted that even though the variable wasn't defined at that point. Mitigation: SWE-1.6 trains "explore and reason before acting" explicitly. Requires model-level training, not just prompt engineering.

**10. Parallel tool calls used sequentially** — Agent issues tool calls one at a time when they could be parallelized, wasting wall-clock time. SWE-1.6 identifies this as an RL-induced UX problem. LLMCompiler is the architectural fix; training-level correction is harder.

**Fundamental vs. engineering problems:**

*Engineering problems (solvable now)*: infinite loops, premature termination, sequential tool calls, interface design, state passing schema design.

*Hard engineering problems (solved but requires care)*: context loss (tiered memory helps), instruction drift (typed schemas help), compounding errors (intermediate verification loops help).

*Fundamental problems (likely require new research)*: reliable multi-step planning without external verifiers, general task verification beyond test suites, multi-agent coordination without state loss, credit assignment in multi-agent systems.

---

## 7. Open Problems and Emerging Directions

### The General Verification Problem

Test suites work for well-specified software tasks. They don't generalize to open-ended tasks: writing, research synthesis, system design, UI/UX work. The LLM-Modulo framing (generate → verify externally) is correct but the external verifier is task-specific and often unavailable. Building task-appropriate verification oracles is a key unsolved problem. The CodeClash benchmark (SWE-bench team, Nov 2025) signals awareness: treating LMs as "goal-oriented developers" with holistic evaluation, not just patch acceptance.

### Benchmark Saturation and Measurement Quality

SWE-bench Verified crossed 60–65% by mid-2025 for frontier systems. SWE-bench Pro is the current target. But "AI Agents That Matter" (Kapoor et al., arXiv:2407.01502) raises a harder methodological problem: benchmark-developer optimality ≠ downstream-developer optimality. A model that scores highest on SWE-bench may not be the best for your specific codebase, your specific team's patterns, or your specific deployment constraints. The "Model UX" dimension — how the agent behaves interactively, not just whether it passes tests — is a real, untracked axis.

### RL Scaling and UX Divergence

SWE-1.6's training trajectory is the most concrete data point: RL scaling continues to improve benchmark performance, but introduces systematic UX degradations (overthinking, excessive self-verification, sequential when parallel is possible). The training objective (task success) diverges from the user-facing objective (efficient, predictable, interactive behavior). This is a fundamental tension between offline RL optimization and online deployment requirements. No clean solution exists; the field will need reward modeling that explicitly values efficiency and UX.

### Multi-Agent Coordination Primitives

Distributed systems have transactions, consensus, atomic operations, and linearizability. Multi-agent LLM systems have none of the above. Credit assignment (which agent caused the bug?), conflict resolution (whose patch is correct?), and coordination under information asymmetry (iAgents problem) are all open. LangGraph's typed state + reducer model is a step toward transactional semantics, but doesn't address correctness guarantees.

### Long-Context vs. Retrieval: The Right Answer

The empirical evidence is not settled. Long-context models are improving (Kimi k1.5's long-context RL at 1M tokens, arXiv:2501.12599). Retrieval systems are also improving (SWE-grep RL training, AutoCodeRover AST retrieval). The research question is: at what context length and task type does long-context attention become more reliable than retrieval? Current evidence suggests retrieval wins for multi-hop reasoning over large codebases; long-context wins for tasks with high intra-context dependency. The right production answer is probably both: structured retrieval to populate context + long-context model to reason within it.

### Trust and Human-in-the-Loop

As agents become more capable, the question of when to require human approval for irreversible actions becomes critical. LangGraph's interrupt nodes and Devin's UI for mid-task clarification are engineering solutions to this. The research question is harder: how do you calibrate the agent's confidence in its own actions so that it interrupts only when genuinely uncertain, not constantly? Calibration of LLM uncertainty for irreversible actions is an open research problem.

---

## Practitioner's Checklist

If you're designing an agentic orchestration framework today, these are the 10 highest-leverage design decisions:

**1. Build the grounding oracle first.**
Define what "correct" means before writing a line of agent code. If you have a test suite, use it. If you have a linter/type-checker, use it. If you have a human approval step, design it as a formal interrupt. Don't build an agent without knowing how it verifies its own work.

**2. Design the state schema as a typed contract, not an afterthought.**
Define what information is shared between agents (or between turns of a single agent) as a typed schema before you start. Every field should have an explicit purpose. Unstructured string passing is technical debt from day one.

**3. Use external state persistence, not in-context memory.**
The context window is the agent's working memory; the database/git/event log is its long-term memory. Never rely on in-context memory for state that needs to survive beyond the current turn. Commit frequently. Log everything.

**4. Parallelize independent tool calls (LLMCompiler pattern).**
Identify true data dependencies and serialize only those. Everything else should execute in parallel. This is a 3-7× latency improvement that also reduces compounding errors by keeping task steps independent.

**5. Use purpose-built agent interfaces, not human interfaces.**
Design your tool APIs for how agents reason, not how humans use CLIs. Bounded file views with line numbers. Targeted search returning exact matches. Structured error messages with suggested fixes. The SWE-agent ACI result (3% → 12.5% from interface design alone) is not an outlier.

**6. Set iteration budgets, not just step limits.**
An agent needs enough time/steps to execute the test → observe → adjust loop multiple times. "Max 10 steps" often isn't enough; "45 minutes real time with unlimited steps up to 200" may be better. But you also need infinite-loop prevention. These are orthogonal constraints.

**7. Pass the original task specification to every subagent.**
Constraint drift is caused by summarization. The fix is structural: every agent call includes the original task spec as a non-summarizable field in the state schema. Role descriptions and task summaries are supplements, not replacements.

**8. Build for compaction from the start.**
Know your context budget and design proactive compaction at ~80% utilization. Separate working memory (compress aggressively) from ground-truth state (never compress; externalize to git/DB). Don't let compaction be an afterthought — context overflow in production is harder to fix than in development.

**9. Use structured pre-action exploration.**
The RL-trained behavior that most improves performance is: explore the codebase → reason about the problem → then act. Build this as an explicit phase in your agent architecture (a "reasoning/planning turn" before "execution turns"). Don't let the agent begin modifying state on the first turn.

**10. Treat benchmark scores as proxies, not goals.**
Optimize for the real downstream task, which includes cost, latency, predictability, and UX — not just pass rate on a public benchmark. Measure your agents on your actual workload. The "AI Agents That Matter" critique is correct: benchmark-optimal ≠ production-optimal.
