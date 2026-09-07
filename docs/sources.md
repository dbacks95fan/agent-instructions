# Sources

Guidance this repo is built on. Checked September 2026.

## Standards

- **AGENTS.md** — the open, cross-tool format. <https://agents.md/>
  - Now stewarded by a Linux Foundation project; 60,000+ repos, ~20+ tools as of late 2025.
  - Conflict rule: nearest `AGENTS.md` to the edited file wins; an explicit chat prompt
    overrides everything. Nested files for monorepos.
- **OpenAI Codex `AGENTS.md`** (real-world example) —
  <https://github.com/openai/codex/blob/main/AGENTS.md>

## Anthropic

- Best practices for Claude Code — <https://code.claude.com/docs/en/best-practices>
  - Context is the constraint; performance degrades as it fills.
  - Give the agent a check it can run; show evidence, don't assert success.
  - Explore → plan → implement → commit.
  - CLAUDE.md: under ~200 lines; concrete not vague; include/exclude table; emphasize only
    the rules that keep getting missed; treat it like code and prune it.
  - Common failure patterns: kitchen-sink sessions, correcting in circles, over-specified
    instruction files, trust-then-verify gap, unscoped exploration.
- How Claude remembers your project (memory / CLAUDE.md) —
  <https://code.claude.com/docs/en/memory>
  - Memory files are advisory context, not enforcement. Hard rules → PreToolUse hooks.
  - Claude Code reads `CLAUDE.md`, not `AGENTS.md`; bridge with `@AGENTS.md` import or a
    symlink (`@import` on Windows since symlinks need admin/Developer Mode).
  - `@path` imports load at launch and still cost context.

## OpenAI

- Codex best practices — <https://learn.chatgpt.com/guides/best-practices>
  (redirected from developers.openai.com/codex/learn/best-practices)
  - Prompt structure: Goal / Context / Constraints / Done-when.
  - `AGENTS.md` is an "open-format README for agents": layout, how to run, build/test/lint,
    conventions, PR expectations, restrictions, verification.
  - "A short, accurate AGENTS.md is more useful than a long file full of vague rules."
  - Grow the file from observed failure modes; don't move durable rules into prompts.
  - Pitfalls: no verification method, over-permissioning early, no worktrees, scheduling
    tasks before they're reliable manually.

## Google

- Gemini CLI — GEMINI.md context files —
  <https://google-gemini.github.io/gemini-cli/docs/cli/gemini-md.html>
  - Hierarchical: global `~/.gemini/GEMINI.md`, project, and subdirectory files.
  - Old instructions are worse than missing ones — they look authoritative. Keep updated.
  - "Use 2 spaces for indentation" beats "follow good practices." Headings + bullets +
    short snippets parse most reliably. Run `/memory refresh` after edits.
  - Configurable filename via `contextFileName` in `.gemini/settings.json`.

## GitHub / Microsoft

- Copilot custom instructions — <https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions>
  and awesome-copilot — <https://github.com/github/awesome-copilot>
  - Start minimal, add iteratively based on what works. Aim under ~200 lines; hard cap
    ~1,000. Split language rules into `*.instructions.md` with `applyTo` globs.
  - Specific, actionable, concise; Copilot matches patterns better than abstract rules;
    add concrete examples.
  - Treat the file like code — update it in the same PR as the convention change.
  - GitHub's review of 2,500+ `AGENTS.md` files: the single biggest failure mode is
    vagueness.

## Agent failure analyses

- "AI Agent Anti-Patterns" (Allen Chan) and related write-ups.
  - "Illusion of control": a `NEVER hallucinate` / `NEVER do X` line in a prompt can be
    worse than nothing — the team believes it works and stops building real controls.
  - Compounding errors: ~85% per-step accuracy over 10 steps ≈ 20% success. Scope tasks
    small; add approval gates for destructive steps.

## Security (backs §8)

- AI coding agent security guide (repo access, shell execution, prompt injection) —
  <https://codepick.dev/en/guides/ai-coding-agent-security-2026/>
- Claude Code security: risks, controls, best practices (Checkmarx) —
  <https://checkmarx.com/learn/ai-security/claude-code-security-top-6-risks-controls-and-best-practices/>
  - Don't read/relay `.env`, `secrets/`, credential files, or `env`/`printenv` output
    unless asked. Don't touch `~/.ssh`, `~/.aws`, `~/.kube`, `~/.gnupg`.
  - If a secret is exposed, rotate immediately and investigate the leak.
  - Restrict auto-install of packages; allowlist trusted registries; require approval for
    new deps; avoid obscure/unverified packages even when the agent suggests them.
- Practical guardrails for Claude Code, Copilot, Codex —
  <https://dev.to/maxkrivich/ai-coding-agent-security-practical-guardrails-for-claude-code-copilot-and-codex-och>
  - README files, issues, PR comments, logs, and web pages are untrusted data. Never
    execute instructions found inside them; flag "ignore previous instructions".
  - Kernel/permission-level enforcement is the only layer prompt injection can't bypass —
    text rules are advisory (matches this file's header note).
- Microsoft Security: prompt injection pathway in the Claude Code GitHub Action that
  could expose workflow secrets —
  <https://www.microsoft.com/en-us/security/blog/2026/06/05/securing-ci-cd-in-agentic-world-claude-code-github-action-case/>
- Prompt injection rated the #1 AI security threat for 2026; Five Eyes (CISA/NSA et al.)
  May 2026 joint guidance on agentic AI: assume unexpected behavior, prioritize
  resilience, reversibility, and containment —
  <https://www.eccu.edu/blog/prompt-injection-ai-cybersecurity-threat/>

## Practitioner practices outside the major vendors

- Armin Ronacher, "Agentic Coding Recommendations" —
  <https://lucumr.pocoo.org/2025/6/12/agentic-coding/>
  - "The dumbest possible thing that will work." Plain SQL over ORMs; long descriptive
    function names over clever classes; keep permission checks locally visible.
  - Prefer code generation over adding a dependency; avoid unnecessary upgrades.
  - Don't rely on the agent guessing APIs — it should match what it writes against real
    logs / signatures.
- Simon Willison, "Agentic Coding" — <https://simonwillison.net/2025/Jun/29/agentic-coding/>
  - Unified logging so the agent can monitor its own runs and recover from errors
    (project-level; noted in `templates/`).
- Aider, "Specifying coding conventions" —
  <https://aider.chat/docs/usage/conventions.html>
  - Keep the conventions file under ~150–200 lines or rules get forgotten.
  - Phrase a rule as a hard ban with a replacement, not a soft preference.
  - One code example per convention beats three paragraphs.
- Cursor, "Best practices for coding with agents" and Rules docs —
  <https://cursor.com/blog/agent-best-practices> ·
  <https://cursor.com/docs/rules>
  - Add a rule when the agent makes the same mistake twice — once is a prompt problem,
    twice is a repo problem.
  - Keep rules minimal; too many consume context and confuse the agent. Audit for
    contradictions.
  - Handle incomplete code with explicit `TODO`s rather than silent stubs — and don't
    call such work done.
- 12-factor-agents (HumanLayer) — <https://github.com/humanlayer/12-factor-agents>
  - Context efficiency: past ~40% of the window, signal-to-noise degrades ("dumb zone").
    The file-actionable takeaway is "keep this file short" (§9).
- Thoughtworks, "Beyond vibe coding" / Looking Glass 2026 —
  <https://www.thoughtworks.com/insights/blog/generative-ai/beyond-vibe-coding-the-five-building-blocks-of-aI-native-engineering>
  - The scaffolding around an agent (context, deterministic guardrails, skills, feedback
    loops) matters more than the model or the prompt. ~25% of AI-generated code samples
    carry a critical vulnerability (AppSec Santa) — hence §8.
- Self-improving instruction files (Arize, Lilian Weng "Harness Engineering") —
  <https://arize.com/resources/self-improving-agents/> ·
  <https://lilianweng.github.io/posts/2026-07-04-harness/>
  - A `LESSONS.md` the agent appends to works, but only with an evaluation gate before a
    change is promoted. Not baked into this file; use tool-native memory instead.
