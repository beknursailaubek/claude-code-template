# Workflow Guide

How Claude Code processes tasks, routes work, and validates results in this template.

---

## Task Processing Model

Every task follows this lifecycle:

```
Receive task
    │
    ▼
Understand & clarify (if needed)
    │
    ▼
Explore codebase (read before editing)
    │
    ▼
Classify: complexity and routing decision
    │
    ├── Simple / single-file → Claude handles directly
    │
    ├── Multi-module or interface-changing → Architect agent first
    │
    ├── Bounded implementation → Implementer subagent
    │
    └── Review / audit → Reviewer agent
         │
         ▼
    Validate (lint → test → build)
         │
         ▼
    Update MEMORY.md if needed
         │
         ▼
    Done
```

---

## Decision: Keep in Claude vs. Route to Subagent

### Keep in Claude (handle directly)
Use when:
- The task requires cross-module reasoning or context
- The task is primarily analysis, planning, or review
- The answer depends on understanding accumulated project history
- The task is short enough (< ~50 lines of code change) that delegation overhead exceeds benefit

Examples:
- Explaining how a module works
- Reviewing a diff
- Writing a plan or architecture proposal
- Answering a question about trade-offs

### Route to a Subagent
Use when:
- The task is specialized and falls clearly within an agent's role
- The task can run in parallel with other work
- You want to protect the main context window from a deep, narrow exploration

Examples:
- Architecture design for a new module → `architect` agent
- Writing tests for an existing feature → `test-engineer` agent
- Reviewing a PR diff → `reviewer` agent
- Applying a schema migration → `migration-operator` agent

See [agent-routing.md](agent-routing.md) for the full routing matrix.

---

## Validation Sequence

Always run in this order:

1. **Format / lint** — catch style and obvious errors fast
2. **Unit tests** — confirm logic correctness
3. **Build** — confirm the project compiles/bundles (if applicable)
4. **Integration tests** — confirm components work together (if applicable)
5. **Migrations** — only when relevant, always with explicit confirmation

If any step fails: fix before proceeding. Do not skip steps.

---

## MCP Server Usage

When `.mcp.json` is configured:
- Use `postgres` MCP for database queries instead of raw psql/SQL in bash
- Use configured HTTP/SSE servers for external API interactions
- Check available tools at session start: review `.mcp.json` configuration

---

## When to Update MEMORY.md

Update after completing a task if:
- An architectural decision was made that isn't obvious from the code
- A non-obvious bug pattern was discovered
- A deployment or configuration nuance was found
- An existing assumption turned out to be wrong

Do NOT update for:
- Routine implementations that follow obvious patterns
- Task progress or to-do state
- Information that is already in the code or git history

---

## Session Startup Protocol

At the start of every session:
1. Read `CLAUDE.md`
2. Read `MEMORY.md` (index) and any memory files relevant to today's task
3. Check `git status` and `git log --oneline -10`
4. Check `.mcp.json` for available MCP servers
5. Then proceed

Skipping this leads to repeated context-setting and preventable mistakes.
