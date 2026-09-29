# Changelog

## v0.2.1 — 2026-09-29

- `AGENTS.md` §5: agents end every task with a plain-language summary a 15-year-old could follow — what changed, what was checked, and what's still open — placed before any evidence or technical detail.

## v0.2.0 — 2026-09-29

- `LICENSE`: the repo is now MIT-licensed. `AGENTS.md` §9 makes MIT the default license for new work and has agents offer it as the default when asking which license a new repo gets.
- `AGENTS.md`: the copyright section is now numbered §9 (Maintaining moves to §10) and says the copyright line comes first, then the purpose comment. The copyright line drops "All rights reserved", which contradicts an MIT grant.
- `AGENTS.md`: dropped the personal "think of me as a colleague" line (it lives in `addons/personal.md`); precedence wording no longer implies files replace each other.
- All prose files are unwrapped to one line per paragraph or list item, so text soft-wraps in the editor; stray double spaces removed.
- README states the rules are DPSystems-specific.
- Tool wiring brought up to date: Claude Code reads `AGENTS.md` natively (v2.1.277+) when a project has no `CLAUDE.md`; Gemini CLI's setting is `context.fileName`; Copilot CLI reads `AGENTS.md` and a user-level file, while several Copilot surfaces still read only `.github/copilot-instructions.md`. README documents importing straight from this checkout for a global setup.
- Removed leftover references to the deleted `templates/`.
- `addons/personal.md`: dropped the `social.md` status-update requirement.
- `addons/personal.md` House style: prose files (Markdown, plain text, `LICENSE`) use one line per paragraph or list item and soft-wrap; the rule never applies to code or code-related files (source, scripts, XML, JSON, YAML, config).
- `AGENTS.md` §3: new Linting and formatting rule for every non-prose file — the project's own tools first, otherwise a named default formatter and linter per file type; zero findings on new files and touched lines; no silencing findings without a provable reason; adding a tool needs approval (§7).
- `install.ps1` passes PSScriptAnalyzer's default rules and OTBS formatting (`PSScriptAnalyzerSettings.psd1`). Instead of `Write-Host` text it now outputs one object per file (`Tool`, `Action`: `Wrote` / `Skipped` / `AlreadyWritten`, `Path`); the target folder and drift reminder moved to `-Verbose`; skipped files still warn.
- `tests/install.Tests.ps1`: Pester unit, integration, and end-to-end tests for `install.ps1`, including `-Global` against a redirected home folder.

## v0.1.3 — 2026-09-25

- `AGENTS.md`: added a Copyright and licensing section — DPSystems, LLC ownership, a copyright line on new source files, a `LICENSE` in every new repo, and rules against copying unlicensed code or stripping third-party notices.
- `AGENTS.md` §7: removed the "beyond a negligible amount" exception from the paid-API approval rule.

## v0.1.2 — 2026-09-21

- `AGENTS.md` §6 Version control: commit to the working branch and push it to GitHub (`git push -u origin <branch>`), pre-approved as a standing exception to §7's outward-actions gate; pushes to `main` and force-pushes still need approval. Keep using the existing branch when already on the one for the change.

## v0.1.1 — 2026-09-20

- `AGENTS.md` §6 Version control: all code changes happen on a branch created before the first edit, never a direct commit to `main`, with branch names that name the change. §2 points at it, since that is the section read before editing starts.
- Removed the `templates/` project starters.

## v0.1.0 — 2026-09-06

Initial version.

- `AGENTS.md` — canonical tool-agnostic behavior rules, built from the original global `CLAUDE.md` plus published guidance from Anthropic, OpenAI, Google, and GitHub/Microsoft (see `docs/sources.md`). Trimmed from ~250 lines to ~145; emphasis reduced to four load-bearing rules. Named `AGENTS.md` for zero-config pickup by Codex, Cursor, Zed, Junie, VS Code Copilot, Aider, and others.
- `AGENTS.md` §8 Security covers agent-specific risks alongside classic appsec: treating read content as untrusted (prompt injection), not accessing or relaying local credential stores, scanning diffs for secrets before commit, not weakening security controls to pass a check, and supply-chain caution when adding dependencies.
- `AGENTS.md` folds in practitioner practices from outside the major vendors (Ronacher, Aider, Cursor rules guidance, Cursor best practices): don't edit a test to make it pass, no placeholder/TODO code in work called done, don't guess unfamiliar APIs, prefer the boring solution, three-strikes stop rule, and rule-writing guidance in §9.
- `addons/personal.md` — opt-in personal preferences and stricter rules moved out of the canonical file.
- `pointers/` — per-tool wiring for Claude Code, Gemini CLI, Codex/Cursor/Zed/etc., and Copilot.
- `templates/` — project `AGENTS.md` starters: minimal, Node/TypeScript, Python, monorepo package.
- `install.ps1` — copies the canonical file and the right pointer into a project or the global tool config dirs.
