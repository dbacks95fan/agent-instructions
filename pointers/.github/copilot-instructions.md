<!--
  Every GitHub Copilot surface reads .github/copilot-instructions.md. Most don't follow
  @import (Copilot CLI does), so the canonical content must live in this file directly:
  copy AGENTS.md here and re-copy after edits (install.ps1 -Tools copilot does this).

  Notes:
  - Copilot CLI, the cloud agent, VS Code chat, and github.com code review also read a
    root AGENTS.md. github.com chat, VS Code code review, Visual Studio, and JetBrains /
    Eclipse / Xcode chat read only this file, so keep it even with a root AGENTS.md.
  - Copilot CLI also reads a user-level ~/.copilot/copilot-instructions.md.
  - Keep this under ~1,000 lines; move language-specific rules to
    .github/instructions/*.instructions.md with `applyTo` globs.
-->

Copy the contents of the repo-root `AGENTS.md` into this file.
