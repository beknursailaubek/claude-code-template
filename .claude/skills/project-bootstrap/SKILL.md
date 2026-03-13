---
name: project-bootstrap
description: First-session workflow for initializing a new project from this template. Covers placeholder replacement, configuration, agent/skill pruning, and initial MEMORY.md population.
---

# Skill: Project Bootstrap

## Purpose
Get a new project from "just cloned from template" to "ready for first feature" in a single structured session.

## When to Use
- First session after creating a new project from this template
- When onboarding an existing project to this workflow

## Workflow

### Step 1 — Identify Project Type
Determine which project profile applies:
- Backend-only (API/service/worker)
- Frontend-only (SPA/SSR/static)
- Fullstack (monolith or separate repos)
- Monorepo (multiple packages/services)
- Modular monolith
- Microservice

See [docs/template-customization.md](../../docs/template-customization.md) for pruning guidance per type.

### Step 2 — Fill CLAUDE.md Placeholders
Replace all `{{PLACEHOLDER}}` values:
```bash
grep -r "{{" . --include="*.md" --include="*.json" -l
```

Required placeholders:
- `{{PROJECT_NAME}}` — project name
- `{{STACK}}` — language + framework + DB (e.g., "FastAPI + React + PostgreSQL")
- `{{ARCHITECTURE}}` — structure (e.g., "modular monolith")
- `{{REPO_URL}}` — GitHub URL
- `{{TEAM}}` — team name
- `{{LINT_COMMAND}}` — e.g., `ruff check .`
- `{{TEST_COMMAND}}` — e.g., `pytest`
- `{{BUILD_COMMAND}}` — e.g., `docker build .` or N/A
- `{{PRIMARY_LANGUAGE}}` — e.g., Python 3.12
- `{{PACKAGE_MANAGER}}` — e.g., pip/poetry/npm/pnpm
- `{{DATABASE}}` — e.g., PostgreSQL 15
- `{{TEST_FRAMEWORK}}` — e.g., pytest / vitest
- `{{LINTER}}` — e.g., ruff / eslint
- `{{FORMATTER}}` — e.g., black / prettier
- `{{CI_SYSTEM}}` — e.g., GitHub Actions
- `{{DEPLOY_METHOD}}` — e.g., Docker + Railway

### Step 3 — Prune Irrelevant Agents
Remove agent files that don't apply to this project:

| Remove if... | Agent |
|---|---|
| No frontend | `frontend-implementer.md` |
| No database | `migration-operator.md` |
| Single-person project | `reviewer.md` (optional) |

### Step 4 — Prune Irrelevant Skills
Remove skill directories that don't apply:

| Remove if... | Skill |
|---|---|
| No database | `db-migration-safety/` |
| No frontend | remove frontend references from `feature-delivery` |

### Step 5 — Populate Initial MEMORY.md
Add the first memory entries for decisions already made:
- Why this stack was chosen
- Architecture constraints (e.g., "must fit in a single Heroku dyno")
- Any known traps from day one (e.g., "ORM version X has a known bug with Y")
- Team preferences already established

### Step 6 — Verify Claude Code Environment
- Confirm the `codex` MCP server is connected (if using Codex)
- Test with: `Use the codex MCP tool to echo 'hello'`
- Confirm `.claude/settings.json` permissions are appropriate

### Step 7 — Run Baseline Validation
If a codebase already exists:
```
1. Run lint
2. Run tests
3. Confirm baseline is green before making any changes
```
Record the baseline state in MEMORY.md if tests are not all green.

### Step 8 — Commit the Bootstrap
```bash
git add CLAUDE.md MEMORY.md .claude/ docs/ README.md .gitignore
git commit -m "chore: initialize project from ai-project-template"
```

## Expected Outputs
- CLAUDE.md fully configured (no remaining `{{}}` placeholders)
- MEMORY.md with at least 2–3 initial entries
- Irrelevant agents and skills removed
- Baseline validation passing (or documented as failing)
- Initial commit created

## Completion Criteria
- [ ] All placeholders replaced
- [ ] Irrelevant agents/skills pruned
- [ ] MEMORY.md has initial entries
- [ ] Codex MCP confirmed working (if using)
- [ ] Baseline validation run and results documented
