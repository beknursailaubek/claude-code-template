#!/usr/bin/env bash
# pre-tool-use.example.sh
#
# PURPOSE: Warn before dangerous shell commands.
# EVENT:   PreToolUse (Bash tool)
# EXIT:    0 = allow, 2 = block with message to Claude
#
# SETUP: Register this for the "Bash" tool matcher in your Claude Code settings.
#
# INPUT: JSON on stdin with at least:
#   { "tool_name": "Bash", "tool_input": { "command": "..." } }

set -euo pipefail

# Read the JSON input from stdin
INPUT=$(cat)

# Extract the command being run (requires jq)
if ! command -v jq &> /dev/null; then
  # jq not available — allow the action and exit cleanly
  exit 0
fi

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# ── Dangerous patterns to warn about ──────────────────────────────────────────

# Force push
if echo "$COMMAND" | grep -qE 'git push.+--force|git push.+-f\b'; then
  echo "BLOCKED: Force push detected. This is a destructive git operation."
  echo "If you intended this, ask the user for explicit confirmation first."
  exit 2
fi

# Hard reset
if echo "$COMMAND" | grep -qE 'git reset --hard'; then
  echo "BLOCKED: 'git reset --hard' will discard uncommitted changes."
  echo "Confirm with the user before running this."
  exit 2
fi

# Recursive delete
if echo "$COMMAND" | grep -qE 'rm\s+-rf?\s+[^-]|rm\s+-fr\s+'; then
  echo "WARNING: Recursive delete detected: $COMMAND"
  echo "Confirm with the user before deleting files or directories."
  exit 2
fi

# DROP TABLE / DROP DATABASE
if echo "$COMMAND" | grep -qiE 'DROP\s+TABLE|DROP\s+DATABASE|TRUNCATE\s+TABLE'; then
  echo "BLOCKED: Destructive SQL detected. Never run DROP/TRUNCATE without explicit user confirmation."
  exit 2
fi

# Production environment access (customize these patterns for your project)
if echo "$COMMAND" | grep -qE '\-\-env=?prod|ENVIRONMENT=production|NODE_ENV=production'; then
  echo "WARNING: Command appears to target the production environment."
  echo "Confirm with the user before running against production."
  exit 2
fi

# Allow everything else
exit 0
