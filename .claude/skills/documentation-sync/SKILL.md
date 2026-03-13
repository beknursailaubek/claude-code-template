---
name: documentation-sync
description: Keep documentation in sync with code changes. Use after features or refactors that affect public interfaces, module behavior, or architecture.
---

# Skill: Documentation Sync

## Purpose
Prevent documentation drift — the state where code and docs describe different systems.
Run this skill after any change that affects something a developer would look up in the docs.

## When to Use
- After adding or changing a public API endpoint
- After changing a module's public interface or behavior
- After an architectural change that affects how components fit together
- After a migration that changes the data model
- As part of the `feature-delivery` skill's final step

## What Counts as Documentation

| Type | Location |
|---|---|
| API reference | `docs/api/` or inline OpenAPI/docstrings |
| Module README | `src/module-name/README.md` or similar |
| Architecture docs | `docs/workflow.md`, `docs/agent-routing.md` |
| Environment setup | `README.md` setup section |
| Configuration reference | `docs/config.md` or `.env.example` |
| MEMORY.md | Learnings, decisions, caveats |

## Workflow

### Step 1 — Identify What Changed
List the files that changed in the current task. For each:
- Does it have associated documentation?
- Does it change a public interface?
- Does it change behavior that a developer might read about?

### Step 2 — Audit Existing Docs
Read the relevant documentation and compare it to the new code state:
- Is any documented behavior now incorrect?
- Are new behaviors undocumented?
- Are examples still valid?

### Step 3 — Update or Create Documentation
- Update in-place if the doc exists — do not create a new file when updating works.
- Match the existing tone and structure of surrounding docs.
- Use concrete examples wherever the change affects usage.
- For API changes: update endpoint descriptions, request/response shapes, and example payloads.

### Step 4 — Update MEMORY.md
If the change resulted in a decision worth remembering or a non-obvious behavior:
- Add an entry to MEMORY.md with a pointer to a new memory file.
- Create the memory file in `memory/` with proper frontmatter.

### Step 5 — Update .env.example (if applicable)
If new environment variables were added:
- Add them to `.env.example` with a descriptive comment.
- Never add actual values to `.env.example`.

### Step 6 — Verify Links
If documentation references other files or sections, confirm they still exist after the change.

## Expected Outputs
- Updated documentation files (list each)
- Updated MEMORY.md if applicable
- Updated `.env.example` if applicable
- No broken internal links

## Completion Criteria
- [ ] All affected documentation identified
- [ ] Docs reflect the current code state
- [ ] No documented behavior that is now incorrect
- [ ] MEMORY.md updated if applicable
- [ ] `.env.example` updated if new env vars were added
