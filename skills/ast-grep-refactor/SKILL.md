---
name: ast-grep-refactor
description: Safely search and rewrite code using AST patterns (ast-grep/sg) across large TypeScript, TSX, JavaScript, or C++ codebases. Use when making multi-file changes that must be syntax-correct — prop renames, API migrations, import path updates, pattern replacements, or any codemod-style transform where text-based tools (sed, grep, Python scripts) would be ambiguous or unsafe.
license: MIT
compatibility: opencode
---

## When to Use

Load this skill when:
- Renaming a prop, type, function, or symbol across many files where text-replace would be ambiguous
- Migrating an API pattern (e.g., deprecated import path → new path, callback style → async/await)
- Enforcing a code convention at scale (e.g., `console.log` → `logger.debug` everywhere)
- The agent would otherwise reach for `sed`, `awk`, or a custom Python parser to modify source files
- The change touches 5+ files where broken syntax would be hard to detect without running the compiler

**Do not use** for single-file edits — use the Edit tool directly. This skill is for codebase-scale changes.

---

## Prerequisites

Verify ast-grep is installed before starting:

```bash
sg --version
# Expected: ast-grep 0.x.x
```

If missing:
```bash
npm install -g @ast-grep/cli
# Then ensure ~/.npm-global/bin is on PATH
export PATH="$HOME/.npm-global/bin:$PATH"
```

---

## Language Reference

| Language     | `--lang` flag | File extensions       |
|--------------|---------------|-----------------------|
| TypeScript   | `ts`          | `.ts`                 |
| TSX (React)  | `tsx`         | `.tsx`                |
| JavaScript   | `js`          | `.js`, `.jsx`         |
| C++          | `cpp`         | `.cpp`, `.h`, `.hpp`  |

Omit `--lang` to let ast-grep infer from file extensions (safe for single-language directories).

---

## Pattern Syntax

Patterns look like the code you want to match. Replace variable parts with metavariables.

| Metavariable | Matches                          | Example                        |
|--------------|----------------------------------|--------------------------------|
| `$VAR`       | Any single AST node              | `$OBJ.$METHOD()`               |
| `$$$ARGS`    | Zero or more nodes (variadic)    | `foo($$$ARGS)`                 |
| `$_`         | Any node (unnamed/throwaway)     | `if ($_ ) { $$$ }`             |

### Common Patterns for TS/TSX/JS

| Goal                              | Pattern                              | Rewrite                          |
|-----------------------------------|--------------------------------------|----------------------------------|
| Rename function call              | `oldFn($$$ARGS)`                     | `newFn($$$ARGS)`                 |
| Rename method on any object       | `$OBJ.oldMethod($$$ARGS)`            | `$OBJ.newMethod($$$ARGS)`        |
| Replace import path               | `import $X from 'old-path'`          | `import $X from 'new-path'`      |
| Replace named import              | `import { oldName } from '$MOD'`     | `import { newName } from '$MOD'` |
| Null guard → optional chaining    | `$X && $X.$METHOD()`                 | `$X?.$METHOD()`                  |
| JSX prop rename                   | `<$C $OLD={$V} />`                   | `<$C $NEW={$V} />`               |
| console.log → logger              | `console.log($$$ARGS)`               | `logger.debug($$$ARGS)`          |

### Common Patterns for C++

| Goal                              | Pattern                              | Rewrite                          |
|-----------------------------------|--------------------------------------|----------------------------------|
| Rename method call                | `$OBJ.oldMethod($$$ARGS)`            | `$OBJ.newMethod($$$ARGS)`        |
| Replace function call             | `oldFn($$$ARGS)`                     | `newFn($$$ARGS)`                 |
| Replace include path              | `#include "old/path.h"`              | `#include "new/path.h"`          |

---

## Workflow

### Phase 1 — Verify Installation

```bash
sg --version
```

Hard stop if this fails. Do not proceed.

---

### Phase 2 — Develop the Pattern (Single File First)

**Never run a pattern at scale before verifying it on a single known file.**

1. Identify one file that definitely contains the target pattern.
2. Run search-only (no rewrite) against that file:

```bash
sg -p '<pattern>' -l <lang> path/to/one/file.ts
```

3. Inspect the output. Verify:
   - It matches the intended nodes
   - It does NOT match unintended nodes (false positives)
   - It captures the right metavariables

4. Iterate on the pattern until the single-file result is exactly correct.

**Do not proceed to Phase 3 until the single-file result is clean.**

---

### Phase 3 — Dry Run at Scale

Run the full rewrite in dry-run mode across the target directory:

```bash
sg -p '<pattern>' --rewrite '<rewrite>' -l <lang> <directory> --dry-run
```

Review the dry-run output:
- Count total matches. Is the number plausible?
- Sample 3–5 matches from different files. Are they all correct?
- Look for any false positives — matches that should NOT be rewritten.

**Do not proceed to Phase 4 if any false positives are found.** Refine the pattern and re-run Phase 3.

---

### Phase 4 — Apply

Once the dry run is clean:

```bash
sg -p '<pattern>' --rewrite '<rewrite>' -l <lang> <directory>
```

---

### Phase 5 — Verify

Run the project's type-checker and/or linter immediately after applying:

```bash
# TypeScript projects
npx tsc --noEmit

# ESLint
npx eslint <directory>

# Run tests if available
npm test
```

Zero new errors is the acceptance criterion. If errors appear, the pattern had false positives — revert with `git checkout` and refine.

---

## Checklist

- [ ] `sg --version` succeeds
- [ ] Pattern verified against a single known file (Phase 2)
- [ ] Single-file output is correct — right nodes matched, no false positives
- [ ] Dry run reviewed — match count is plausible, sampled matches are correct
- [ ] No false positives in dry run
- [ ] Rewrite applied (Phase 4)
- [ ] Type-checker / linter run post-apply — zero new errors
- [ ] Tests run if available — all pass
