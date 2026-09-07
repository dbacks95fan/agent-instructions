# AGENTS.md — `<packages/name>`

<!--
  Nested AGENTS.md for one package in a monorepo. Agents read the NEAREST AGENTS.md to
  the file being edited, so this one only needs what differs from the repo-root file.
  Don't repeat the root's rules here.

  Root AGENTS.md: shared setup, conventions, the behavior rules, and the map of packages.
  This file: how THIS package builds, tests, and what's special about it.
-->

What this package is and what depends on it.

## Commands (from this directory)

- Test: `<command>` — or from the repo root: `<turbo run test --filter=<name> | nx test <name>>`
- Build: `<command>`
- Lint: `<command>`

## Layout

- `src/<...>` — <responsibility>
- Public API is `src/index.<ext>` — changing its exports is a breaking change; call it out
  in the PR.

## Local rules

- <what differs from the root conventions for this package>
- Don't import from `<sibling package>` directly — go through `<...>`.

## Done when

- This package's tests and lint pass, and any package that imports it still builds.
