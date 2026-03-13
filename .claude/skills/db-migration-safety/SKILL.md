---
name: db-migration-safety
description: Safe workflow for planning, writing, reviewing, and applying database migrations. Prevents data loss, table locks, and downtime from unsafe schema changes.
---

# Skill: DB Migration Safety

## Purpose
Ensure every schema change goes through a safety review before being applied. Prevent the most common migration disasters: irreversible drops, locking large tables, and breaking running application code.

## When to Use
- Adding, altering, or dropping tables, columns, or indexes
- Adding or removing constraints (FK, unique, not null)
- Running data backfills or transformations
- Any change that touches the database schema

## Workflow

### Step 1 — Describe the Change
State clearly:
- What schema change is needed
- Why it is needed
- Which tables/columns are affected
- Approximate row count for affected tables

### Step 2 — Risk Assessment
Before writing the migration, assess:

| Risk | Check |
|---|---|
| Table lock | Does this `ALTER TABLE` on a large table? Consider `CONCURRENTLY`, batching, or shadow table approach |
| Data loss | Is data being deleted or column dropped? Ensure soft-delete or transition period |
| Null constraint | Adding NOT NULL to a column with existing rows? Add nullable first, backfill, then constrain |
| Breaking current queries | Will the schema change break running application code before it is deployed? |
| Irreversibility | Can this be rolled back? If not, say so explicitly |

Invoke the `migration-operator` agent for the full risk analysis.

### Step 3 — Write the Migration
- Write both `up` and `down` (rollback) paths.
- If rollback is impossible (e.g., data was deleted), document it explicitly.
- For locking-risk changes, use safe alternatives (see Dangerous Patterns in migration-operator.md).
- Follow the project's migration naming convention.

### Step 4 — Review the Migration SQL
Before applying:
- Print the exact SQL that will execute.
- Confirm it matches the intended change.
- Confirm the rollback SQL is correct.
- Have a second set of eyes (human or reviewer agent) confirm.

### Step 5 — Pre-Apply Checklist
- [ ] Migration reviewed and approved
- [ ] Rollback path confirmed
- [ ] Tested in a non-production environment
- [ ] Application code is compatible with both old and new schema (for zero-downtime)
- [ ] Backup confirmed or assessed as not needed
- [ ] Locking risk assessed for large tables

### Step 6 — Apply with Confirmation
**Never apply without explicit user confirmation.**

State:
> "Ready to apply migration: [migration name]. This will [describe exact effect]. Rollback: [rollback steps]. Shall I proceed?"

Wait for explicit "yes" before applying.

### Step 7 — Verify and Document
- Confirm the migration applied cleanly.
- Run application smoke tests.
- Add a MEMORY.md entry with the migration context.

## Expected Outputs
- Risk assessment
- Migration SQL (up + down)
- Pre-apply checklist completed
- Applied status: PENDING / APPLIED / ROLLED BACK
- MEMORY.md entry

## Completion Criteria
- [ ] Risk assessment completed
- [ ] Migration has a rollback path (or irreversibility is documented)
- [ ] Explicit user confirmation received before applying
- [ ] Migration applied and verified
- [ ] MEMORY.md updated
