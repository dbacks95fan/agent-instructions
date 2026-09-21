# agent-instructions

One canonical set of behavior rules for AI coding agents — Claude Code, Codex, Gemini CLI,
Copilot, Cursor, and others — kept in version control and wired into each tool.

The canonical file is named **`AGENTS.md`**, the [open cross-tool standard](https://agents.md/).
Codex, Cursor, Zed, JetBrains Junie, current VS Code Copilot, Aider, and ~20 other tools
auto-discover that filename with no configuration. Claude Code and Gemini CLI look for
their own filenames, so they get a one-line pointer file that imports `AGENTS.md`.

## What's here

| Path | What it is |
|---|---|
| `AGENTS.md` | **The canonical file.** Tool-agnostic behavior rules, ~150 lines. Copy or import this everywhere. |
| `addons/personal.md` | Opt-in personal preferences and stricter rules (PowerShell, working relationship, strict TDD, `ABOUTME:` headers, journaling). Import alongside `AGENTS.md` on your own machine. |
| `pointers/` | Thin per-tool files for the tools that don't read `AGENTS.md`. `CLAUDE.md` and `GEMINI.md` `@import` it; `.github/copilot-instructions.md` needs a copy (no import syntax). |
| `templates/` | Project-level `AGENTS.md` starters — minimal, Node/TypeScript, Python, and a monorepo package stub. The project layer holds commands and layout; the canonical file holds behavior. |
| `docs/sources.md` | The Anthropic / OpenAI / Google / GitHub guidance this is built on. |
| `install.ps1` | Copies `AGENTS.md` + the right pointer into a target directory. |

## The two layers

1. **Behavior** — `AGENTS.md` in this repo. How the agent works: plan first, verify before
   claiming done, don't rewrite working code, ask before destructive actions. Same for
   every project.
2. **Project** — a repo-root `AGENTS.md` from `templates/`. Commands, directory layout,
   what not to touch, this project's "done when". Different per repo.

Combine them per repo one of two ways:

- **Copy** the canonical rules into the top of the project `AGENTS.md`, then add the
  project sections below. Simple; re-copy when the canonical file changes.
- **Import** — keep the canonical `AGENTS.md` at the repo root and have `CLAUDE.md` /
  `GEMINI.md` `@import` it. One copy of the rules, but only Claude and Gemini follow the
  import; tools that read `AGENTS.md` directly see only what's in that file.

## Wiring each tool

Import paths resolve relative to the file doing the import, so an imported file must sit
beside the pointer (or be referenced by an absolute `~/` path).

| Tool | Reads | How to wire |
|---|---|---|
| **Codex, Cursor, Zed, JetBrains Junie, VS Code Copilot, Aider, Devin** | `AGENTS.md` | Copy this repo's `AGENTS.md` to the repo root. Nothing else. |
| **Claude Code** | `CLAUDE.md` | Copy `pointers/CLAUDE.md` + `AGENTS.md` to the repo root (or `~/.claude/`). Keeps the `@import`. |
| **Gemini CLI** | `GEMINI.md` | Copy `pointers/GEMINI.md` + `AGENTS.md`, **or** set `"contextFileName": "AGENTS.md"` in `.gemini/settings.json` and skip the pointer. Run `/memory refresh` after edits. |
| **GitHub Copilot (repo instructions)** | `.github/copilot-instructions.md` | Copy `AGENTS.md` into it. Current VS Code also reads a root `AGENTS.md`, so this is only needed for older Copilot or github.com. |

### Precedence, everywhere

1. An instruction typed in chat wins.
2. The instruction file nearest the edited file wins over ones higher up (nested
   `AGENTS.md` in a monorepo package overrides the root).
3. These files **guide** behavior. They don't enforce it. For a hard guarantee use a hook
   (Claude Code `PreToolUse`), a CI check, or permission settings.

## Maintaining it

- Keep `AGENTS.md` short and concrete. If a line wouldn't change what an agent does, cut
  it.
- When a convention changes, change it here in the same commit.
- Add a rule only after you've seen an agent get it wrong more than once.
- Re-run `install.ps1` (or re-copy) in projects that hold a full copy rather than an
  import, so they don't drift.

## Usage

```powershell
# Codex/Cursor/etc. — just the canonical file
.\install.ps1 -Target C:\repos\my-project -Tools codex

# Claude Code — pointer + canonical file
.\install.ps1 -Target C:\repos\my-project -Tools claude

# Multiple tools at once
.\install.ps1 -Target C:\repos\my-project -Tools claude,codex,gemini

# Global install for Claude Code (~/.claude/)
.\install.ps1 -Global -Tools claude
```
