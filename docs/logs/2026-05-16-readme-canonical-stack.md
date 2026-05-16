# Session: README canonical stack alignment
**Date:** 2026-05-16

## Overview

Updated the public README to use the canonical enso stack: Model, Runtime, Harness protocol, Harness instance, Agent instantiation, and Substrate.

## Key Decisions
- Replaced the old kernel/OS/interpreter metaphor with the canonical stack as the primary public explanation.
- Added a persistence section clarifying that agent instantiations disappear while harness instances and substrates persist.
- Kept README tone public-facing and concise rather than internal-architecture-heavy.

## Artifacts Modified
- `README.md`
- `docs/stories/STORY-010-readme-canonical-stack.md`
- `docs/logs/2026-05-16-readme-canonical-stack.md`

## Next Steps
- Consider aligning `docs/reference/enso.md`, `docs/reference/enso-condensed.md`, and `docs/reference/harness-engineering-short.md` to the same stack in a follow-up story.
