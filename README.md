# agent-instructions

DPSystems, LLC's canonical behavior rules for AI coding agents — Claude Code, Codex, Gemini CLI, Copilot, Cursor, and others — kept in version control and wired into each tool. The rules are DPSystems-specific (ownership, copyright headers, license defaults); fork and edit them rather than installing them as-is elsewhere. Licensed under MIT (see `LICENSE`).

The canonical file is named **`AGENTS.md`**, the [open cross-tool standard](https://agents.md/). Codex, Cursor, Zed, JetBrains Junie, VS Code Copilot, Copilot CLI, Aider, and ~20 other tools auto-discover that filename with no configuration. Claude Code (v2.1.277+) reads it too, but only when the project has no `CLAUDE.md`. Gemini CLI looks for `GEMINI.md` unless configured otherwise. Where a tool needs its own filename, a one-line pointer file imports `AGENTS.md`.

## What's here

| Path | What it is |
|---|---|
| `AGENTS.md` | **The canonical file.** Tool-agnostic behavior rules, kept under 200 lines. Copy or import this everywhere. |
| `addons/personal.md` | Opt-in personal preferences and stricter rules (PowerShell, working relationship, strict TDD, `ABOUTME:` headers, journaling). Import alongside `AGENTS.md` on your own machine. |
| `chat/general.md` | Default behavior for chat assistants (ChatGPT, Claude, Gemini, Copilot chat) used for research, writing, analysis, and other non-coding work. Separate from `AGENTS.md`; paste it into the assistant's custom instructions or project instructions. Not installed by `install.ps1`. |
| `pointers/` | Thin per-tool files for tools, or tool surfaces, that don't read `AGENTS.md` on their own. `CLAUDE.md` and `GEMINI.md` `@import` it; `.github/copilot-instructions.md` needs a full copy, because most Copilot surfaces don't follow imports. |
| `docs/sources.md` | The Anthropic / OpenAI / Google / GitHub guidance this is built on. |
| `install.ps1` | Copies `AGENTS.md` + the right pointer into a target directory. |

## The two layers

1. **Behavior** — `AGENTS.md` in this repo. How the agent works: plan first, verify before claiming done, don't rewrite working code, ask before destructive actions. Same for every project.
2. **Project** — written per repo: commands, directory layout, what not to touch, this project's "done when". Different per repo.

Combine them per repo one of two ways:

- **Copy** the canonical rules into the top of the project `AGENTS.md`, then add the project sections below. Simple; re-copy when the canonical file changes.
- **Import** — keep the canonical `AGENTS.md` at the repo root and have `CLAUDE.md` / `GEMINI.md` `@import` it. One copy of the rules, but only Claude and Gemini follow the import; tools that read `AGENTS.md` directly see only what's in that file.

## Wiring each tool

Import paths resolve relative to the file doing the import, so an imported file must sit beside the pointer (or be referenced by an absolute or `~/` path).

| Tool | Reads | How to wire |
|---|---|---|
| **Codex, Cursor, Zed, JetBrains Junie, Aider, Devin** | `AGENTS.md` | Copy this repo's `AGENTS.md` to the repo root. Nothing else. |
| **Claude Code** | `CLAUDE.md`; `AGENTS.md` only when no project `CLAUDE.md` or `CLAUDE.local.md` exists (v2.1.277+) | Copy `pointers/CLAUDE.md` + `AGENTS.md` to the repo root. The pointer is optional on current versions, but keep it if the project needs Claude-only rules or a `CLAUDE.local.md`, or runs older versions. The import never loads `AGENTS.md` twice. |
| **Gemini CLI** | `GEMINI.md` | Copy `pointers/GEMINI.md` + `AGENTS.md`, **or** set `{ "context": { "fileName": ["AGENTS.md", "GEMINI.md"] } }` in `.gemini/settings.json` and skip the pointer. Run `/memory refresh` after edits. |
| **GitHub Copilot** | CLI, cloud agent, VS Code chat, and github.com code review read `AGENTS.md`; every surface reads `.github/copilot-instructions.md` | Copy `AGENTS.md` to the repo root **and** into `.github/copilot-instructions.md`. github.com chat, VS Code code review, Visual Studio, and JetBrains/Eclipse/Xcode chat read only the latter. |

### Global setup: import from this repo

For your own machine, import the files straight from this checkout instead of copying them, so there is nothing to drift. In `~/.claude/CLAUDE.md`:

```markdown
@C:/repos/agent-instructions/AGENTS.md
@C:/repos/agent-instructions/addons/personal.md

# Claude Code notes
- ...
```

`install.ps1 -Global` does the copying version of this, for machines without a checkout.

### Precedence, everywhere

1. An instruction typed in chat wins.
2. The instruction file nearest the edited file takes precedence over ones higher up (nested `AGENTS.md` in a monorepo package over the root). Most tools load every file together rather than replacing one with another — Claude Code, for one, concatenates them and may follow either side of a conflict — so remove conflicts instead of relying on this.
3. These files **guide** behavior. They don't enforce it. For a hard guarantee use a hook (Claude Code `PreToolUse`), a CI check, or permission settings.

## Maintaining it

- Keep `AGENTS.md` short and concrete. If a line wouldn't change what an agent does, cut it.
- When a convention changes, change it here in the same commit.
- Add a rule only after you've seen an agent get it wrong more than once.
- Re-run `install.ps1` (or re-copy) in projects that hold a full copy rather than an import, so they don't drift.

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

# Show the target folder and the drift reminder too
.\install.ps1 -Target C:\repos\my-project -Tools claude -Verbose
```

The script outputs one object per file, with `Tool`, `Action` (`Wrote`, `Skipped`, or `AlreadyWritten`), and `Path`, so the result can be piped or filtered. A file that already exists is skipped with a warning unless you pass `-Force`.

## Development

`install.ps1` has Pester tests (unit, integration, and end-to-end) and is linted with PSScriptAnalyzer using `PSScriptAnalyzerSettings.psd1`: the default rules plus the OTBS formatting preset. Both must be clean before a change is done.

```powershell
# Tests (Pester 5 or later)
Invoke-Pester -Path .\tests -Output Detailed

# Lint and format check, one file at a time
Invoke-ScriptAnalyzer -Path .\install.ps1 -Settings .\PSScriptAnalyzerSettings.psd1
Invoke-Formatter -ScriptDefinition (Get-Content .\install.ps1 -Raw) -Settings .\PSScriptAnalyzerSettings.psd1
```
