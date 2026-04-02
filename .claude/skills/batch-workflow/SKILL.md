---
name: batch-workflow
description: Orchestrate large-scale changes across the codebase using parallel isolated agents. Decomposes work into independent units, spawns agents in parallel, each handles its own scope.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Agent
  - TodoWrite
---

# Skill: Batch Workflow

## Purpose
Execute large-scale refactors, migrations, or bulk changes by decomposing them into independent work units and running them in parallel via isolated agents.

## When to Use
- Renaming a pattern across 10+ files
- Migrating an API across multiple modules
- Applying a code style change across the codebase
- Bulk-generating tests, documentation, or boilerplate
- Any change that affects 5+ independent files/modules

## Workflow

### Phase 1 — Plan and Decompose

1. **Understand the scope** — read affected files, identify the full blast radius
2. **Define the change pattern** — what exactly changes in each unit
3. **Decompose into work units** — each unit must be:
   - Independently implementable (no dependencies between units)
   - Independently mergeable (each can land on its own)
   - Roughly uniform in size
   - Self-contained in its prompt (no shared context between workers)
4. **Create a tracking table:**

```
| # | Work Unit | Files | Status |
|---|-----------|-------|--------|
| 1 | Rename X in module A | src/a/*.ts | pending |
| 2 | Rename X in module B | src/b/*.ts | pending |
...
```

### Phase 2 — Execute in Parallel

For each work unit, spawn an isolated subagent with this prompt structure:

```
You are working on: [specific unit description]
Files to modify: [explicit list]
Change pattern: [exact before/after]
Constraints: [do not touch other files, follow existing patterns]
After changes: run lint and tests
Commit with message: [specific message]
```

**Rules for parallel execution:**
- Spawn 3–5 agents at a time (avoid overwhelming the system)
- Each agent works in isolation — no shared state
- Monitor progress and track completed/failed units
- If a unit fails, note the error and continue with others

### Phase 3 — Review and Integrate

1. **Check each unit's output** — review diffs, verify tests pass
2. **Fix failed units** — retry with more specific instructions
3. **Run full test suite** — after all units are complete
4. **Update tracking table** with final status

## Work Unit Quality Checklist
- [ ] Unit has explicit file list (no "find and fix everywhere")
- [ ] Unit has clear before/after examples
- [ ] Unit can be tested independently
- [ ] Unit's commit message is pre-defined
- [ ] Unit has no dependency on other units' changes

## Anti-Patterns
- Spawning agents without a clear plan → leads to conflicts
- Work units that depend on each other → sequential, not parallel
- Vague prompts ("fix all the things") → inconsistent results
- Skipping the review phase → unverified changes

## Expected Outputs
- Tracking table with all units and their status
- Individual commits per work unit
- Full test suite passing after integration
- Summary of what changed and any remaining issues

## Completion Criteria
- [ ] All work units completed or explicitly deferred
- [ ] Each unit's changes reviewed
- [ ] Full test suite passes
- [ ] No conflicts between units
