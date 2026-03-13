#!/usr/bin/env bash
# post-edit-check.example.sh
#
# PURPOSE: Remind Claude to run validation after editing source code files.
# EVENT:   PostToolUse (Edit or Write tool)
# EXIT:    0 = always allow (this hook only prints reminders, never blocks)
#
# SETUP: Register this for the "Edit" and "Write" tool matchers.
#
# INPUT: JSON on stdin with at least:
#   { "tool_name": "Edit", "tool_input": { "file_path": "..." } }

set -euo pipefail

INPUT=$(cat)

if ! command -v jq &> /dev/null; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Only remind for source code files, not docs or config
if echo "$FILE_PATH" | grep -qE '\.(py|js|ts|tsx|jsx|go|rb|java|rs|cpp|c|cs|php)$'; then
  # Print reminder to stdout — Claude will see this as feedback
  echo "REMINDER: You edited a source file ($FILE_PATH)."
  echo "Before marking this task complete:"
  echo "  1. Run the project's lint command"
  echo "  2. Run the relevant unit tests"
  echo "  3. Confirm nothing unexpected changed"
fi

# Never block — this is informational only
exit 0
