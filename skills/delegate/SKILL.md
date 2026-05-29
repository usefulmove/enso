---
name: delegate
description: Delegate a task to a child pi agent by spawning a new harness instance. Use when a story is too large for one session, requires isolated verification, or calls for a different stance or skill set.
---

# Delegate

Spawn a child pi agent from within a running harness. The child runs in its own context directory and returns through an explicit return path.

## Interface (the contract)

| Parameter | Description |
|---|---|
| **context_dir** | The child's working directory. Inherits parent `.pi/skills/` unless overridden. |
| **prompt** | The task envelope: goal, acceptance criteria, and any loaded skills. |
| **return_path** | `stdout`, `<context_dir>/.pi/return.md`, or a named tmux session. |
| **name** | Optional tmux session name for re-attachment. |

## Canonical invocation

```bash
pi -p --cwd ./runs/<task-id> <<< "$PROMPT"
```

Or wrapped:

```bash
./delegate.sh <context-dir> <prompt-file> [session-name]
```

## Patterns

- **Fan-out:** Spawn multiple agents against sibling directories; collect `return.md` files.
- **Pipeline:** Child stdout piped into next child stdin, or into parent post-processor.
- **Supervisor:** Named tmux session for long-running work. Re-attach with `tmux attach -t <name>`.

## Why This Skill Exists

The harness is self-composing. An agent that can invoke `pi` via `bash` is a Lisp `eval`. Without a documented envelope every spawn is bespoke. This skill provides the minimal contract so that recursive delegation remains inspectable and portable across enso instances.
