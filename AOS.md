# Agent Orchestration Surface

*enso is built on the Pygmalion model: the maker is the human, the medium is the persistent substrate, the figure is the orchestration surface the human relates to.*

An orchestration surface is the persistent, inspectable contract layer between a human and a swarm of agents—and between the agents themselves.

A surface is not just many interfaces. A pile of APIs is not a surface. A surface is a coherent collection of interfaces presented as one thing: the human touches it as one object, each interface has a role, the seams are intentional, transitions don't feel like abandonment, and the vocabulary is shared enough to become usable.

Most systems treat handoffs like a phone tree: transfer the human, drop the context, hope someone picks up. The human feels it. Distance replaces contact.

A surface fixes this by making every boundary explicit. Human intent enters through a voice contract. Work routes through a specialization contract. Execution happens under a scope contract. Tools are discovered through a capability contract. Each contract has an interface and an enabling point—so the machinery can change without breaking the surface.

enso is the harness protocol that realizes this surface. It is file-based, project-local, and compounding. The surface gets stronger every session because the contracts persist in the repo, not in a vector database that drifts.

## What crosses the surface

| Direction | What travels | Contract |
|:---|:---|:---|
| Human in | intent, register, voice | persona / stance file |
| Surface out | routing, scope, specialization | story template / context scope |
| Agent in | tools, execution, mutation | runtime + harness rules |
| Time across | continuity, memory, lessons | logs, reference docs, skills |

## Why this matters

The surface is not the UI. It is not the model. It is the grammar that lets a human and a fleet of ephemeral agents work as one team over time.

Every interface is a language. Design the vocabulary deliberately. Respect the learner.
