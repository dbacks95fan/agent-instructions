# AGENTS.md

<!-- Python flavor. Replace bracketed values; delete rows that don't apply. -->

`<name>` — <one sentence>. Python `<version>`, managed with `<uv|poetry|pip-tools>`.

## Setup

- Create env + install: `<uv sync | poetry install | pip install -e ".[dev]">`
- Activate: `<source .venv/bin/activate | poetry shell>`
- Environment: copy `.env.example` to `.env`; required vars are `<...>`

## Build, test, lint

- Test: `<pytest | uv run pytest>` — single test while iterating: `pytest <path>::<test>`
- Lint: `ruff check .` (fix: `ruff check --fix .`)
- Format: `ruff format .` — don't hand-format
- Types: `<mypy . | pyright>` — must pass on changed modules
- Full check before committing: `<command or list>`

## Project layout

- `src/<package>/` — application code
- `src/<package>/<area>.py` — <responsibility>
- `tests/` — mirrors `src/` layout
- Never commit `.venv/`, `__pycache__/`, `*.pyc`

## Conventions

- Target Python `<version>`; don't use syntax newer than that
- Type hints on all public functions
- Follow the structure in `src/<package>/<example>.py` for new `<modules/handlers>`
- Errors: raise specific exceptions; no bare `except:`
- Logging via the stdlib `logging` module, never `print`
- Prefer standard library; adding a dependency needs approval (see AGENTS.md §7)

## Do not touch

- `<generated file>` — regenerate with `<command>`
- `alembic/versions/**` / migrations — additive only

## Done when

- Tests, lint, format check, and types pass, and <behavior-level verification>.
- New behavior has tests covering its edge and failure cases.
