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
    ├── Bounded implementation → Implementer agent or Codex
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

## Decision: Keep in Claude vs. Route to Subagent vs. Delegate to Codex

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

### Delegate to Codex via MCP
Use when:
- The task is implementation work (writing/editing code)
- The task is bounded to specific files
- The plan and acceptance criteria are already clear
- The task requires no cross-module reasoning

Always use the `codex-task-contract` skill before calling Codex.
See [codex-mcp-policy.md](codex-mcp-policy.md) for full rules.

---

## Reintegrating Codex Output

After Codex returns:

1. **Read the diff** — every changed file, not just the summary
2. **Check against acceptance criteria** — each criterion must be verifiable
3. **Run validation commands** — do not skip
4. **Accept or reject** — never auto-accept
   - If output is correct: proceed to review
   - If output is partially wrong: prepare a corrective contract with specific fix instructions
   - If output is entirely wrong: consider whether the contract was underspecified

Do not accept output you haven't read.

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
4. Then proceed

Skipping this leads to repeated context-setting and preventable mistakes.
