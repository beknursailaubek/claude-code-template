# Template Customization Guide

How to adapt this template for different project types.

---

## Backend-Only (API / Service / Worker)

**Keep:**
- `architect.md`
- `reviewer.md`
- `backend-implementer.md`
- `test-engineer.md`
- `migration-operator.md` (if there's a database)
- All skills except frontend-specific parts

**Remove:**
- `frontend-implementer.md`
- Frontend references in `feature-delivery/SKILL.md`

**Add to CLAUDE.md:**
- API versioning policy
- Authentication/authorization pattern
- Background job queue conventions (if applicable)
- Rate limiting or throttling rules
- Error response format standard

**MEMORY.md initial entries to add:**
- API design decisions (REST vs RPC vs GraphQL)
- Authentication mechanism chosen
- Service boundaries (if there are dependent services)

---

## Frontend-Only (SPA / SSR / Static)

**Keep:**
- `architect.md`
- `reviewer.md`
- `frontend-implementer.md`
- `test-engineer.md`

**Remove:**
- `backend-implementer.md`
- `migration-operator.md`
- `db-migration-safety/` skill

**Add to CLAUDE.md:**
- Component library or design system in use
- State management approach
- API client pattern (how frontend calls backend)
- Build and bundle conventions
- Accessibility standards

**MEMORY.md initial entries to add:**
- Why this framework/library was chosen
- CSS approach (CSS Modules, Tailwind, styled-components, etc.)
- Which API environment (mock, staging, prod) is used in which context

---

## Fullstack (Monolith)

**Keep everything.**

**Add to CLAUDE.md:**
- Clear boundary between frontend and backend code paths
- Where shared types/schemas live
- How the frontend is served (same process, or separate static host)
- Which part owns the API contract definition

**MEMORY.md initial entries to add:**
- Frontend/backend co-location rationale
- Shared code boundaries

---

## Modular Monolith

**Keep everything.**

**Add to CLAUDE.md:**
- Module boundary rules: which modules can import from which
- Shared kernel vs. module-private code distinction
- Event/message patterns between modules (if any)
- How to add a new module (naming, structure, registration)

**Customize agents:**
- Consider creating module-specific implementer agents if modules have very different patterns
  (e.g., `billing-implementer.md`, `notifications-implementer.md`)

**MEMORY.md initial entries to add:**
- Module boundary decisions
- Inter-module communication patterns
- Which modules are stable vs. actively changing

---

## Monorepo

**Extend the structure:**
```
/
├─ packages/
│  ├─ api/
│  │  └─ CLAUDE.md      ← package-specific overrides
│  ├─ web/
│  │  └─ CLAUDE.md
│  └─ shared/
│     └─ CLAUDE.md
├─ CLAUDE.md             ← monorepo-level rules
└─ MEMORY.md             ← shared learnings
```

**Root CLAUDE.md additions:**
- Workspace tool (turborepo, nx, lerna, pnpm workspaces)
- Cross-package dependency rules
- Versioning and release strategy
- Which packages are public vs. internal
- Build order and dependency graph

**Per-package CLAUDE.md:**
- Package-specific stack and conventions
- Package-specific validation commands

**Customize agents:**
- Route implementation tasks to the appropriate package-level agents
- Consider adding a `release-operator.md` agent for versioning/publishing

---

## Microservice (Single Service in a Fleet)

**Keep:**
- `architect.md`
- `reviewer.md`
- `backend-implementer.md`
- `test-engineer.md`
- `migration-operator.md` (if the service has its own DB)

**Remove:**
- `frontend-implementer.md`

**Add to CLAUDE.md:**
- Service contract definition (what this service exposes and consumes)
- Other services this one depends on (as READ-ONLY references)
- Message/event schema ownership rules
- SLA/reliability expectations
- How this service is deployed and rolled back

**Add to MEMORY.md:**
- Why this service was split out
- Contracts with other services (endpoints, events, schemas)
- Known integration quirks with downstream services

**Key principle:** Changes that affect other services' contracts are architecture decisions, not implementation tasks. Always route to `architect` agent first.

---

## Quick Reference: What to Keep/Remove

| Component | Backend | Frontend | Fullstack | Monolith | Monorepo | Microservice |
|---|---|---|---|---|---|---|
| architect | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| reviewer | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| backend-implementer | ✓ | — | ✓ | ✓ | ✓ | ✓ |
| frontend-implementer | — | ✓ | ✓ | ✓ | ✓ | — |
| test-engineer | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| migration-operator | ✓* | — | ✓* | ✓* | ✓* | ✓* |
| feature-delivery | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| bugfix-workflow | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| code-review | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| db-migration-safety | ✓* | — | ✓* | ✓* | ✓* | ✓* |
| project-bootstrap | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| documentation-sync | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

`*` = only if the project has a database
