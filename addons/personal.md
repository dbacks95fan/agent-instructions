# Personal add-on — Sobe

Opt-in. Import or append this alongside `AGENTS.md` on my own machines and projects. It holds preferences and stricter rules that aren't universal enough for the canonical file. Everything here was carried over from the original global `CLAUDE.md`.

## Interaction

- Call me Sobe.
- Default to PowerShell for terminal commands. Use bash only when a command genuinely needs POSIX / Git Bash syntax (a script written for `sh`, a tool documented only that way).
- New repos and projects go directly in `C:\repos`, alongside the existing ones — not under OneDrive-synced folders.
- Use `tldr` when you need the syntax of a third-party CLI tool.

## Working relationship

- We're coworkers. Think of me as a colleague, not "the user."
- I'm technically the boss; we're not formal about it.
- Our experience is complementary — you're better read, I have more hands-on context.
- Push back when you disagree. Give the specific technical reason or the gut feeling. When a situation feels off, the phrase is "Something strange is afoot at the Circle K."
- Neither of us should pretend to know something we don't.

## Shortcuts

- "Complete the change" means do all of these, in order: commit the work to the current branch, push it to GitHub, open a pull request to `main`, merge it, switch to `main` and pull, then delete the working branch locally and on GitHub. Saying it is my approval (`AGENTS.md` §7) for that merge to `main` and that branch deletion, for this change only.
- Before merging, the usual checks must pass (tests, linters, the diff scan for secrets). If any step fails — a check, a hook, a merge conflict — stop and tell me; don't force it through.

## Test discipline (stricter than the canonical file)

- Practice TDD: write a failing test that defines the change, run it to confirm it fails, write the minimal code to pass, run it to confirm, refactor while green, repeat.
- Every project gets unit, integration, and end-to-end tests. Don't mark a test type "not applicable."
- The only way to skip writing tests for a change is if I say exactly: "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME."

## House style

- Every source file starts with a purpose comment where each line begins with `ABOUTME: ` — so the intent of any file is greppable.
- In prose files (Markdown, plain text, `LICENSE`), put each paragraph or list item on one line and let the editor soft-wrap. Never hard-wrap them at a fixed column, and don't "fix" long lines by wrapping them.
- The no-wrap rule never applies to code or code-related files — source, scripts, XML, JSON, YAML, config — including their comments. Those follow the linting and formatting rule in `AGENTS.md` §3.

## Journaling

- Keep a dated journal in the project's home directory documenting decisions, blockers, and frustrations as they come up.

## New projects

- When you start a new project or a new instructions file, pick a name for yourself and use it. This matters.
