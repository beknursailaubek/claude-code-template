# MEMORY.md — Project Knowledge Index

This file is an index of accumulated project learnings.
Individual memory entries live in the `memory/` directory.

**This is not a log or a task list.** It stores durable, reusable knowledge about this specific project.

---

## How to Use This File

- Each entry below points to a memory file with details.
- Claude reads this index at session start to quickly identify relevant context.
- Add new entries here and create corresponding files in `memory/` as learnings accumulate.
- Remove or update entries when knowledge becomes stale.
- Keep this index under 200 lines so it fits in context.

---

## Architecture Observations

<!-- Add entries as you discover architectural facts not obvious from the code.
     Example:
     - [auth-flow.md](memory/arch-auth-flow.md) — JWT refresh is handled at the gateway, not in services
     - [db-access-pattern.md](memory/arch-db-access.md) — All DB access goes through repository layer; no direct ORM use in views
-->

*No entries yet. Add the first one when you make an architectural decision worth remembering.*

---

## Debugging Patterns

<!-- Document recurring bug types and how to diagnose them.
     Example:
     - [race-condition-pattern.md](memory/debug-race-condition.md) — Async task queue sometimes double-fires on restart; always check idempotency keys
     - [null-env-vars.md](memory/debug-null-env.md) — Startup failures are usually missing env vars; check .env.example first
-->

*No entries yet.*

---

## Known Traps

<!-- Document footguns, non-obvious behavior, and things that have burned the team before.
     Example:
     - [migration-trap.md](memory/trap-migration-order.md) — Migrations must run in a specific order; the ORM does NOT auto-sort them
     - [cache-invalidation.md](memory/trap-cache.md) — Cache TTL is set globally; per-key override requires a specific flag
-->

*No entries yet.*

---

## Deployment Notes

<!-- Capture deployment-specific knowledge not in README or CI config.
     Example:
     - [deploy-order.md](memory/deploy-order.md) — Always deploy DB migrations before new code; rollback is not automatic
     - [env-staging.md](memory/deploy-env-staging.md) — Staging uses a separate secret manager; not mirrored from prod
-->

*No entries yet.*

---

## Testing Notes

<!-- Document testing patterns, fixtures, and quirks specific to this project.
     Example:
     - [test-db-setup.md](memory/test-db-setup.md) — Tests require a running Postgres; use docker-compose.test.yml
     - [snapshot-tests.md](memory/test-snapshots.md) — Snapshot tests must be updated with --update-snapshots flag; never auto-accept
-->

*No entries yet.*

---

## Team Preferences

<!-- Capture preferences and conventions agreed by the team that are not enforced by tooling.
     Example:
     - [naming-conventions.md](memory/team-naming.md) — Use kebab-case for URL slugs, snake_case for DB columns, camelCase for JS vars
     - [pr-conventions.md](memory/team-prs.md) — PRs must include a test plan; no merge without at least one review
-->

*No entries yet.*

---

## Module-Specific Caveats

<!-- Per-module notes that are not obvious from reading the code.
     Example:
     - [auth-module.md](memory/module-auth.md) — Auth module has a legacy session handler that is still in use; do not remove
     - [billing-module.md](memory/module-billing.md) — Billing runs in a separate process; changes require a restart of the worker
-->

*No entries yet.*

---

## Decisions to Remember

<!-- Record significant decisions: what was decided, why, and what alternatives were rejected.
     Example:
     - [decision-no-graphql.md](memory/decision-no-graphql.md) — REST chosen over GraphQL; GraphQL was prototyped but added too much tooling overhead for current team size
     - [decision-monolith.md](memory/decision-monolith.md) — Staying monolith until > 3 independent teams; service split deferred
-->

*No entries yet.*

---

## How to Add a New Entry

1. Create a file in `memory/` with a descriptive name, e.g. `memory/arch-auth-flow.md`
2. Use frontmatter:
   ```markdown
   ---
   name: Auth flow architecture
   description: How JWT refresh is handled
   type: project
   ---

   JWT refresh is handled at the gateway layer...
   ```
3. Add a link to this index under the appropriate section.

---

*Last updated: 2026-03-13*
