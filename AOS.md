# Agent Orchestration Surface

An orchestration surface is the persistent, inspectable contract layer between a
human and a swarm of agents — and between the agents themselves.

## What enso does here

Enso is the harness that makes this surface deterministic, inspectable, and
compounding. File-based truth replaces vector-database drift. Context lives in
verified architecture docs and explicit cross-package state, session over session.

## Coordination seams

| Seam | What crosses it | Direction |
|------|-----------------|-----------|
| **Human → Surface** | register, intent, voice | Human enters the surface with intent |
| **Surface → Agent** | routing, context handoff, specialization | Surface dispatches to the right specialist |
| **Agent → Agent** | synthesis, verification, continuity | Specialists collaborate across the surface |
| **Agent → System** | tools, runtime, mutation | Execution under harness rules |

## Substrate

- tmux, zsh, bash, git, nvim — runtime and mutation
- pi, opencode — agent interfaces
- enso — harness protocol (deterministic context, file-based truth)

## Every interface is a language

The surface is a language with deliberate vocabulary for intent, routing, and response.
Enso provides the grammar. The tools are the phonemes.
