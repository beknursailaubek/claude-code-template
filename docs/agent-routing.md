# Agent Routing Guide

Which agent to use for which task. Use this as a quick reference during task decomposition.

---

## Routing Matrix

| Task Type | Primary Agent | Notes |
|---|---|---|
| System design, new module architecture | `architect` | Always before multi-module implementation |
| Trade-off analysis, technology choice | `architect` | Produces a recommendation, not a decision |
| API contract design | `architect` | Coordinate with frontend/backend implementers |
| Implementing a backend endpoint/service | `backend-implementer` | Plan must exist first |
| Implementing a DB query, repository, worker | `backend-implementer` | |
| Implementing a UI component/page | `frontend-implementer` | |
| Wiring frontend to backend API | `frontend-implementer` | Requires API contract from architect |
| Writing unit/integration tests | `test-engineer` | Can run in parallel with implementation |
| Reviewing a diff or PR | `reviewer` | After implementation, before merge |
| Policy compliance audit | `reviewer` | |
| Database schema migration | `migration-operator` | Always requires explicit apply confirmation |
| Data backfill or transformation | `migration-operator` | |
| General analysis, explanation, planning | Claude (direct) | No agent needed |
| Debugging and root cause analysis | Claude (direct) | Use bugfix-workflow skill |

---

## Task Classification Guide

### Architecture vs. Implementation

**Architecture tasks:**
- Designing a new service, module, or integration
- Deciding how two components should communicate
- Choosing between two technical approaches
- Defining a data model or API contract

**Implementation tasks:**
- Writing a function, class, or endpoint to a spec
- Refactoring within a defined boundary
- Writing tests for described behavior
- Generating boilerplate

Never route architecture tasks to implementation agents. Implementation agents do not produce architecture decisions; they execute them.

---

## How to Route a Multi-Step Task

Given a task that requires multiple agents:

1. **Start with Claude** to understand the task and produce a plan
2. **Route to `architect`** if any step involves cross-module design
3. **Decompose into subtasks** once the architecture is clear
4. **Route each subtask** to the appropriate implementer subagent
5. **Route to `test-engineer`** for test coverage (can run in parallel with implementation)
6. **Route to `reviewer`** for the final diff review
7. **Route to `migration-operator`** for any schema changes (with confirmation gate)

---

## When to Use Subagents vs. Handle Directly

| Factor | Use Subagent | Handle Directly |
|---|---|---|
| Task requires reading multiple files for context | Subagent (protects main context) | |
| Task is purely mechanical (known pattern) | | Yes (faster) |
| Task benefits from conversational clarification | | Yes |
| Task is specialized (security audit, migration) | Subagent | |
| Multiple independent tasks | Parallel subagents | |

---

## Example Routing Decisions

### "Add a new REST endpoint for user profile updates"
1. `architect` — define the request/response shape, validation rules, auth requirements
2. `backend-implementer` — implement the route handler and service method
3. `test-engineer` — write tests for the endpoint
4. `reviewer` — review the complete diff

### "Fix a bug where the order total calculation is wrong"
1. Claude (direct) — diagnose root cause using `bugfix-workflow` skill
2. `test-engineer` — write the failing regression test
3. `backend-implementer` — apply the fix
4. `reviewer` — review if the fix is non-trivial

### "Add a new column to the users table"
1. Claude (direct) — check if the column needs a code change too
2. `migration-operator` — write and apply the migration (with confirmation)
3. `backend-implementer` — update any code that reads/writes this column

### "Refactor the payment module to reduce duplication"
1. `architect` — define the refactor boundary and approach
2. `backend-implementer` (multiple subtasks) — apply the refactor in stages
3. `test-engineer` — confirm existing tests still pass after each stage
4. `reviewer` — final review
