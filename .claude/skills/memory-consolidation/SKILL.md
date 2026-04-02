---
name: memory-consolidation
description: Review, merge, and prune project memories. Removes duplicates, updates stale entries, and consolidates related memories. Run periodically or when MEMORY.md grows large.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
---

# Skill: Memory Consolidation (Dream)

## Purpose
Keep the memory system healthy. Over time, memories accumulate duplicates, become stale, or fragment across too many files. This skill consolidates them.

## When to Use
- MEMORY.md has more than 30 entries
- Memory files in `memory/` exceed 20 files
- After completing a major milestone or sprint
- When memories seem contradictory or outdated
- Periodically (recommended: every 2–4 weeks)

## Workflow

### Step 1 — Inventory
```bash
echo "=== MEMORY.md lines ===" && wc -l MEMORY.md
echo "=== Memory files ===" && ls memory/*.md 2>/dev/null | wc -l
echo "=== Total size ===" && du -sh memory/ 2>/dev/null
```

Read MEMORY.md and all memory files.

### Step 2 — Classify Each Memory
For each memory file, classify:
- **Active** — still relevant, referenced in current code
- **Stale** — code has changed, memory no longer accurate
- **Duplicate** — same information exists in another memory
- **Mergeable** — closely related to another memory, should be combined

### Step 3 — Verify Against Current Code
For memories that reference specific files, functions, or patterns:
```bash
# Check if referenced files still exist
# Check if referenced patterns still match
# Check if decisions are still in effect
```

### Step 4 — Consolidate
- **Merge duplicates** — combine into the more detailed entry, delete the other
- **Update stale** — correct the memory to match current code, or delete if no longer relevant
- **Combine related** — if 3+ memories are about the same topic, merge into one comprehensive entry
- **Archive old** — move memories older than 3 months that haven't been referenced to `memory/archive/`

### Step 5 — Rebuild MEMORY.md Index
Rewrite MEMORY.md to reflect the current state:
- Remove entries pointing to deleted files
- Update descriptions for merged entries
- Keep under 200 lines (hard limit for context injection)
- Group by category: Architecture, Debugging, Deployment, Testing, Decisions, Team

### Step 6 — Summary
Print what was done:
```
=== Consolidation Summary ===
  Memories reviewed:    24
  Merged:               3 (into 1)
  Updated:              5
  Deleted (stale):      2
  Archived:             4
  Remaining:            16
  MEMORY.md lines:      42 (was 68)
```

## Safety Rules
- Never delete without reading the memory first
- Never merge if the memories contradict each other (flag for human decision)
- Always verify against current code before marking stale
- Keep a git-trackable trail — commit after consolidation

## Completion Criteria
- [ ] All memory files reviewed
- [ ] Duplicates merged
- [ ] Stale entries removed or updated
- [ ] MEMORY.md index under 200 lines
- [ ] Changes committed
