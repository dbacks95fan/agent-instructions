<!--
  Pointer file for Claude Code. Claude Code reads CLAUDE.md, not AGENTS.md. The @import
  below pulls in the canonical AGENTS.md at session start.

  Placement:
  - Per project:  copy this file AND AGENTS.md to the repo root; keep the relative import.
  - Global:       put this at ~/.claude/CLAUDE.md and change the import to an absolute
                  home path, e.g.  @~/.claude/AGENTS.md

  Import paths resolve relative to THIS file's location. HTML comments like this one are
  stripped before Claude sees the file, so they cost no context.
-->

@AGENTS.md

# Claude Code notes

<!-- Add Claude-specific rules below this line. Anything here is appended after the
     canonical file. Keep it to things that only apply to Claude Code. -->

- Before editing under paths you were told are sensitive, use plan mode and get sign-off.
- When a factual answer is needed, use web search to verify rather than answering froms memory.
