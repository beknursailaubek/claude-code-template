# Project Bootstrap Guide

What to do immediately after creating a new project from this template.

---

## Before You Start

This template is intentionally generic. Before writing a single line of code, spend 20–30 minutes configuring it for your specific project. That investment pays back every session.

---

## Step 1 — Identify Your Project Type

Choose the profile that fits:

| Profile | Description |
|---|---|
| Backend-only | API, service, worker, CLI — no frontend in this repo |
| Frontend-only | SPA, SSR, static site — no backend in this repo |
| Fullstack monolith | Frontend + backend in the same repo |
| Modular monolith | Multiple bounded modules, single deployable |
| Monorepo | Multiple packages or services under one repo |
| Microservice | One focused service; other services exist separately |

Your project type determines which agents and skills to keep. See [template-customization.md](template-customization.md).

---

## Step 2 — Replace All Placeholders in CLAUDE.md

```bash
grep -r "{{" . --include="*.md" --include="*.json"
```

Fill in every `{{PLACEHOLDER}}`:

```
{{PROJECT_NAME}}      → My API Service
{{STACK}}             → FastAPI + PostgreSQL + Redis
{{ARCHITECTURE}}      → Modular monolith, 4 bounded modules
{{REPO_URL}}          → https://github.com/org/my-api
{{TEAM}}              → Platform team
{{LINT_COMMAND}}      → ruff check . && mypy .
{{TEST_COMMAND}}      → pytest -x
{{BUILD_COMMAND}}     → docker build -t my-api .
{{PRIMARY_LANGUAGE}}  → Python 3.12
{{PACKAGE_MANAGER}}   → poetry
{{DATABASE}}          → PostgreSQL 15
{{TEST_FRAMEWORK}}    → pytest
{{LINTER}}            → ruff
{{FORMATTER}}         → black
{{CI_SYSTEM}}         → GitHub Actions
{{DEPLOY_METHOD}}     → Docker + Cloud Run
```

---

## Step 3 — Prune Irrelevant Agents

Remove agent files that don't apply:

```bash
# Backend-only project: remove frontend agent
rm .claude/agents/frontend-implementer.md

# No database: remove migration agent
rm .claude/agents/migration-operator.md
```

Do not leave unused agent files — they add noise and can confuse routing.

---

## Step 4 — Prune Irrelevant Skills

```bash
# No database
rm -rf .claude/skills/db-migration-safety/

# No frontend
# Remove frontend references from feature-delivery/SKILL.md
```

---

## Step 5 — Add Stack-Specific Rules to CLAUDE.md

Under the "Stack-Specific Conventions" section, add the patterns Claude must follow:

Examples for a Python/FastAPI project:
```markdown
- All endpoints must use Pydantic schemas for input validation and response serialization
- Use dependency injection for DB sessions: `db: Session = Depends(get_db)`
- Business logic lives in `services/`, not in route handlers
- Use `snake_case` for all Python names and `kebab-case` for URL paths
- Async endpoints preferred; use `async def` unless a sync reason exists
```

Examples for a TypeScript/Next.js project:
```markdown
- Server components by default; client components only when interactivity is needed
- API routes in `app/api/`; all responses use standard `ApiResponse<T>` wrapper
- Use `zod` for all input validation
- State management: Zustand for client state; React Query for server state
- Named exports preferred over default exports
```

---

## Step 6 — Populate Initial MEMORY.md

Add the first 2–4 entries covering decisions already made:

Example:
```markdown
## Decisions to Remember
- [decision-postgres.md](memory/decision-postgres.md) — PostgreSQL chosen over MySQL; team has stronger expertise and PostGIS may be needed later
- [decision-monolith.md](memory/decision-monolith.md) — Staying monolith until team > 5 engineers; service split deferred to v2
```

Create the corresponding memory files in `memory/` with proper frontmatter.

---

## Step 7 — Configure Permissions and Hooks (Optional)

**settings.json** — review `.claude/settings.json` and adjust the deny list for your project.
The format and pattern syntax are documented in [`.claude/hooks/README.md`](.claude/hooks/README.md) under "See Also: settings.json".

Key question to answer: are there commands specific to your stack that should always require confirmation? Add them to `deny`.

**Hooks** — if your team wants automatic checks or reminders:
1. Read `.claude/hooks/README.md`
2. Copy and adapt the example scripts
3. Register them in your Claude Code project or user settings

---

## Step 8 — Configure MCP Servers

Review `.mcp.json` and configure MCP servers for your project:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": { "DATABASE_URL": "${DATABASE_URL}" }
    }
  }
}
```

Add servers relevant to your stack:
- PostgreSQL → `@anthropic/mcp-postgres`
- Other databases or APIs → configure with appropriate transport (stdio, sse, http)

---

## Step 9 — Run Baseline Validation

If an existing codebase is being onboarded:
```bash
# Run your configured test and lint commands
ruff check .
pytest
```

Document the current baseline state in MEMORY.md:
- If tests are green: note it
- If tests are failing: document which tests and why, so Claude doesn't treat them as regressions

---

## Step 10 — Commit the Bootstrap

```bash
git add CLAUDE.md MEMORY.md .claude/ docs/ README.md .gitignore .mcp.json
git commit -m "chore: initialize project from ai-project-template"
```

---

## First Real Task

After bootstrap, your first development session with Claude Code should start with:

> "Read CLAUDE.md and MEMORY.md. I want to [describe first task]."

Claude will read the project constitution, check memory, and then apply the workflow from there.

---

## Checklist

- [ ] Project type identified
- [ ] All `{{PLACEHOLDER}}` values replaced
- [ ] Irrelevant agents removed
- [ ] Irrelevant skills removed
- [ ] Stack-specific conventions added to CLAUDE.md
- [ ] Initial MEMORY.md entries written
- [ ] MCP servers configured in `.mcp.json`
- [ ] Baseline validation run and documented
- [ ] Initial commit created
