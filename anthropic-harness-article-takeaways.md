Here are the main takeaways from the Anthropic article:

**Key Problems with Naive Agent Implementations:**

1.  **Context Window & "Context Anxiety":** Models lose coherence as context windows fill, and some models start "wrapping up" prematurely when they think they're approaching their limit.
2.  **Self-Evaluation Failure:** Agents are terrible at evaluating their own work; they tend to give overly positive reviews, even for mediocre outputs. This is especially bad for subjective tasks (like design).

**The "GAN-Inspired" Solution (Generator + Evaluator):**

*   The article proposes a multi-agent structure inspired by Generative Adversarial Networks.
*   **Generator:** Creates the output (code, design).
*   **Evaluator:** Judges the output against specific criteria.
*   **Why it works:** Separating the creator from the judge makes it much easier to tune the evaluator to be skeptical and critical, which is harder to do when the agent is judging its own work.

**Frontend Design Application:**

*   The evaluator was given four grading criteria:
    1.  **Design Quality:** Does it feel like a coherent whole with a distinct mood?
    2.  **Originality:** Is it custom or just a template? (Penalized "AI slop" like purple gradients).
    3.  **Craft:** Technical execution (typography, spacing, contrast).
    4.  **Functionality:** Usability.
*   **Result:** After 5-15 iterations, the quality improved significantly. The evaluator's feedback pushed the generator toward more distinctive and creative designs.

**Full-Stack Coding Application:**

*   The harness evolved into a **three-agent architecture**:
    1.  **Planner:** Takes a simple 1-4 sentence prompt and expands it into a full product spec.
    2.  **Generator:** Works in "sprints," implementing one feature at a time.
    3.  **Evaluator:** Uses Playwright to click through the running app, testing UI, API, and database, then grades against a contract.
*   **"Sprint Contracts":** Before each sprint, the generator and evaluator agree on what "done" looks like and how it will be verified.
*   **Comparison:** A solo agent run cost $9 and produced a broken game in 20 minutes. The harness run cost $200, took 6 hours, but produced a working, feature-rich application with AI integration.

**Simplifying the Harness:**

*   As models improved (Opus 4.6), some scaffolding became unnecessary.
*   The "sprint" construct was removed; the model could handle longer continuous sessions.
*   The evaluator was moved to a single pass at the end.
*   **Key Principle:** "Every component in a harness encodes an assumption about what the model can't do on its own... it is generally good practice to re-examine a harness, stripping away pieces that are no longer load-bearing."
*   Even with a simpler harness, the evaluator still caught real gaps that the generator missed.

**Key Lessons:**

1.  **Experiment and Tune:** Read model traces on realistic problems and tune prompts.
2.  **Decompose:** Break complex tasks into smaller, manageable chunks.
3.  **Specialize:** Use specialized agents for different aspects of a problem.
4.  **Re-evaluate with New Models:** As models improve, remove unnecessary complexity and add new capabilities that weren't possible before.

**Main Takeaways:**

**1. Generator + Evaluator Pattern (GAN-Inspired)**
Separate creation from evaluation. Agents can't judge their own work well—they're overly positive. A dedicated evaluator tuned to be skeptical catches issues the generator misses.

**2. Make Subjective Quality Gradable**
For design, use concrete criteria: **Design Quality** (coherent mood), **Originality** (avoid "AI slop"), **Craft** (technical execution), **Functionality** (usability). This turns vague judgments into actionable feedback.

**3. Three-Agent Architecture for Full-Stack**
- **Planner:** Expands 1-4 sentence prompts into full specs
- **Generator:** Works feature-by-feature in sprints
- **Evaluator:** Tests running app via Playwright, grades against contracts

**4. Context Resets > Compaction**
Models suffer "context anxiety" and lose coherence. Full context resets with structured handoffs work better than compaction for long-running tasks.

**5. Simplify as Models Improve**
Opus 4.6 needed less scaffolding than 4.5. Remove components that are no longer "load-bearing" when models improve. The evaluator remains valuable for tasks at the edge of the model's capabilities.

**6. Sprint Contracts**
Before coding, generator and evaluator agree on what "done" looks like and how to verify it. Bridges the gap between high-level specs and testable implementation.

**Results:** Solo agent ($9, 20 min) produced broken code. Harness ($200, 6 hrs) produced working, feature-rich apps with AI integration.
