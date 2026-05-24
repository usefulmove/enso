# Agent Orchestration Surface

## What it is

An orchestration surface is the persistent, inspectable contract layer between a
human and a swarm of agents — and between the agents themselves.

Without a surface, every session starts cold. Decisions vanish. Lessons evaporate.
The human becomes the memory system. That doesn't scale.

## Coordination seams

| Seam | What crosses it | Direction |
|------|-----------------|-----------|
| **Human → Surface** | register, intent, voice | Human enters the surface with intent |
| **Surface → Agent** | routing, context handoff, specialization | Surface dispatches to the right specialist |
| **Agent → Agent** | synthesis, verification, continuity | Specialists collaborate across the surface |
| **Agent → System** | tools, runtime, mutation | Execution under harness rules |

## What enso does here

Enso is the harness that makes the surface deterministic, inspectable, and
compounding. File-based truth replaces vector-database drift. Context lives in
verified architecture docs and explicit cross-package state, session over session.

## The fold

The surface in motion:

```
context_new = story(context_old)
```

Each story is a function. The harness instance is the accumulator. The surface
persists it across agent instantiations.

## Every interface is a language

The surface is a language with deliberate vocabulary for intent, routing, and
response. Enso provides the grammar (file-based context, deterministic rules,
no hidden state). The tools are the phonemes.

## Substrate

- tmux, zsh, bash, git, nvim — runtime and mutation
- pi, opencode — agent interfaces
- enso — harness protocol (deterministic context, file-based truth)
