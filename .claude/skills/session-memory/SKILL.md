---
name: session-memory
description: Track current session progress in real-time. Maintains a live markdown file with goal, progress, files touched, blockers, and next steps. Use for long-running workflows or transparency.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - TodoWrite
---

# Skill: Session Memory

## Purpose
Maintain a living document of the current session's progress. Unlike MEMORY.md (cross-session learnings), session memory tracks what's happening RIGHT NOW.

## When to Use
- Long-running feature implementations (>30 min)
- Complex debugging sessions
- Multi-step migrations or refactors
- When working with parallel subagents
- When the user needs visibility into background work

## Session File Location
`.claude/session-memory.md` — created at session start, deleted or archived at session end.

## Template

```markdown
# Session Memory — {{DATE}}

## Goal
[One sentence: what we're trying to accomplish this session]

## Progress
- [x] Step 1: explored codebase, identified affected files
- [x] Step 2: created plan with 5 subtasks
- [ ] Step 3: implementing auth middleware
- [ ] Step 4: writing tests
- [ ] Step 5: review and commit

## Files Touched
- `src/auth/middleware.ts` — new file, JWT validation
- `src/auth/guards.ts` — modified, added RoleGuard
- `tests/auth/middleware.test.ts` — new file

## Decisions Made
- Using passport-jwt over manual verification (team preference from MEMORY.md)
- Storing refresh tokens in httpOnly cookies, not localStorage

## Blockers
- None currently

## Next Steps
1. Finish auth middleware implementation
2. Write integration tests
3. Run full test suite
4. Update API docs
```

## Workflow

### At Session Start
1. Create `.claude/session-memory.md` with the template above
2. Fill in the Goal from the user's request
3. Outline initial steps in Progress

### During Session
Update the file after each significant milestone:
- Completing a subtask → check it off, add new ones if discovered
- Touching a new file → add to Files Touched
- Making a decision → add to Decisions Made
- Hitting a blocker → add to Blockers
- Discovering next work → add to Next Steps

### At Session End
- Archive to `memory/session-{{DATE}}.md` if the session produced learnings
- Or delete if routine work with no noteworthy outcomes
- Promote any Decisions Made to MEMORY.md if they're durable

## Completion Criteria
- [ ] Session memory file created at start
- [ ] Updated after each major milestone
- [ ] Decisions documented
- [ ] Archived or cleaned up at end
