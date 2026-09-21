# Changelog

## v0.1.1 — 2026-09-07

- `AGENTS.md` §6 Version control: all code changes happen on a branch created before the
  first edit, never a direct commit to `main`, with branch names that name the change.
  §2 points at it, since that is the section read before editing starts.

## v0.1.0 — 2026-09-06

Initial version.

- `AGENTS.md` — canonical tool-agnostic behavior rules, built from the original global
  `CLAUDE.md` plus published guidance from Anthropic, OpenAI, Google, and GitHub/Microsoft
  (see `docs/sources.md`). Trimmed from ~250 lines to ~145; emphasis reduced to four
  load-bearing rules. Named `AGENTS.md` for zero-config pickup by Codex, Cursor, Zed,
  Junie, VS Code Copilot, Aider, and others.
- `AGENTS.md` §8 Security covers agent-specific risks alongside classic appsec: treating
  read content as untrusted (prompt injection), not accessing or relaying local credential
  stores, scanning diffs for secrets before commit, not weakening security controls to
  pass a check, and supply-chain caution when adding dependencies.
- `AGENTS.md` folds in practitioner practices from outside the major vendors (Ronacher,
  Aider, Cursor rules guidance, Cursor best practices): don't edit a test to make it pass,
  no placeholder/TODO code in work called done, don't guess unfamiliar APIs, prefer the
  boring solution, three-strikes stop rule, and rule-writing guidance in §9.
- `addons/personal.md` — opt-in personal preferences and stricter rules moved out of the
  canonical file.
- `pointers/` — per-tool wiring for Claude Code, Gemini CLI, Codex/Cursor/Zed/etc., and
  Copilot.
- `templates/` — project `AGENTS.md` starters: minimal, Node/TypeScript, Python, monorepo
  package.
- `install.ps1` — copies the canonical file and the right pointer into a project or the
  global tool config dirs.
