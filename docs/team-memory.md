# Team Memory Guide

How to share project knowledge across team members using Claude Code's memory system.

---

## Overview

Team memory allows shared learnings to persist across all team members' Claude Code sessions. Individual memories stay in `memory/`, team memories in `memory/team/`.

---

## Directory Structure

```
memory/
├── decision-postgres.md           ← individual memory
├── debugging-auth-race.md         ← individual memory
└── team/                          ← shared team memories
    ├── architecture-decisions.md
    ├── deployment-runbook.md
    └── onboarding-gotchas.md
```

---

## Writing Team Memories

Team memories should be:
- **Durable** — won't change week to week
- **Shared** — useful to every team member, not just the author
- **Verified** — confirmed by at least one real incident or decision

### Good Team Memories
- Architecture decisions with rationale ("We use event sourcing for audit because regulatory compliance requires full history")
- Deployment gotchas ("Always run migrations before deploying workers — workers will crash on schema mismatch")
- Integration quirks ("Payment API returns 200 with error body on validation failure — check `status` field")

### Bad Team Memories
- Individual preferences ("I like tabs over spaces")
- Temporary state ("Currently debugging the auth bug")
- Information in code/docs ("The API is at /api/v1" — this is in code already)

---

## Security Considerations

When working with team memory paths, validate:

### Path Traversal Prevention
```
# REJECT these patterns:
memory/team/../../etc/passwd         ← directory traversal
memory/team/%2e%2e/secrets           ← URL-encoded traversal
memory/team/valid/../../../etc       ← nested traversal
```

### Symlink Protection
- Always resolve paths with `realpath` before reading/writing
- Verify the resolved path is still within `memory/team/`
- Reject dangling symlinks

### Validation Rules
1. Memory keys must be alphanumeric + hyphens only (`[a-z0-9-]+`)
2. No path separators in keys (`/`, `\`)
3. Resolved path must start with the team memory directory
4. File must be `.md` extension only
5. Max file size: 50KB per memory file
6. Max total team memory: 1MB

---

## MEMORY.md Integration

Team memories appear in MEMORY.md alongside individual ones:

```markdown
## Architecture Decisions
- [decision-postgres.md](memory/decision-postgres.md) — PostgreSQL chosen over MySQL
- [architecture-decisions.md](memory/team/architecture-decisions.md) — 🔗 Team: core architecture record

## Deployment
- [deployment-runbook.md](memory/team/deployment-runbook.md) — 🔗 Team: step-by-step deploy process
```

---

## Memory Consolidation

Run `/memory-consolidation` periodically to:
- Merge duplicate individual + team memories
- Promote individual memories to team if they're universally useful
- Archive stale team memories
- Keep MEMORY.md under 200 lines
