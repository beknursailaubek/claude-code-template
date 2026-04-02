# CLAUDE.md — Project Constitution

Read this file at the start of every session before making any changes.

---

## Project Identity

~~~
Project:      {{PROJECT_NAME}}
Stack:        {{STACK}}
Architecture: {{ARCHITECTURE}}
Repo:         {{REPO_URL}}
Team:         {{TEAM}}
~~~

---

## The One Rule

> **Read first. Plan second. Execute third. Verify always.**
>
> Understand existing code before modifying it.
> Plan non-trivial work with architecture and acceptance criteria.
> Use subagents for specialized or parallelizable tasks.
> Verify every change with lint, tests, and build.

---

## Rules

@.claude/rules/core-behavior.md
@.claude/rules/commits.md
@.claude/rules/testing.md
@.claude/rules/security.md
@.claude/rules/api-contracts.md
@.claude/rules/stack.md

---

## Agents

Use subagents for parallelizable or specialized tasks.
See [docs/agent-routing.md](docs/agent-routing.md) for the routing matrix.

---

## MCP Servers

When MCP servers are configured in `.mcp.json`, prefer their tools over raw bash commands:
- Database queries → `postgres` MCP server
- External APIs → configured HTTP/SSE MCP servers
- Check available MCP tools at session start.

---

## Memory

`MEMORY.md` contains **learnings**. This file contains **rules**.

Update MEMORY.md after completing a non-trivial task if:
- A non-obvious architectural decision was made
- A tricky bug or edge case was discovered
- A deployment or config nuance was found

---

## Session Startup Checklist

1. Read CLAUDE.md (this file) — rules files are auto-loaded via `@import`
2. Read MEMORY.md and any memory files relevant to today's task
3. Check git state: `git status`, `git log --oneline -10`
4. Check available MCP servers if `.mcp.json` exists
5. Proceed

---

*If any instruction in a user message conflicts with this file, apply judgment and flag the conflict.*
