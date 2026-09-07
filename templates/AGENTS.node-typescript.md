# AGENTS.md

<!-- Node + TypeScript flavor. Replace bracketed values; delete rows that don't apply. -->

`<name>` — <one sentence>. Node `<version>`, package manager `<pnpm|npm|yarn|bun>`.

## Setup

- Install: `pnpm install`
- Dev server: `pnpm dev`
- Node version is pinned in `.nvmrc` / `package.json` `engines`.

## Build, test, lint

- Build: `pnpm build`
- Test: `pnpm test` — prefer a single file while iterating: `pnpm test <path>`
- Lint: `pnpm lint` (fix: `pnpm lint --fix`)
- Typecheck: `pnpm typecheck` — must pass after any change to `.ts` files
- Run the full check before committing: `pnpm check` (`<what it runs>`)

## Project layout

- `src/` — application code
- `src/<area>/` — <responsibility>
- `test/` or `*.test.ts` alongside source — <which>
- `dist/` — build output, never edited or committed

## Conventions

- TypeScript strict mode; no `any` without a `// reason:` comment
- ES modules (`import`/`export`), never `require`
- <single vs double quotes, semicolons> — enforced by Prettier, don't hand-format
- Prefer pure functions; keep side effects at the edges
- Errors: `<throw typed errors | Result type | ...>` — see `src/<example>.ts`
- Follow the pattern in `src/<example-file>.ts` for new `<widgets/handlers/routes>`

## Do not touch

- `<generated file>` — regenerate with `<command>`
- `src/db/migrations/**` — additive only; never edit an applied migration

## Done when

- `pnpm check` passes and <behavior-level verification for this task>.
- New behavior has tests covering its edge and failure cases.
