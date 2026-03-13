#!/usr/bin/env bash
# completion-report.example.sh
#
# PURPOSE: Generate a brief completion summary when Claude finishes a task.
# EVENT:   Stop
# EXIT:    0 always (reporting hook, never blocks)
#
# SETUP: Register this for the "Stop" event in your Claude Code settings.
#
# INPUT: JSON on stdin with session metadata (varies by Claude Code version)

set -euo pipefail

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
REPORT_DIR=".claude/sessions"
REPORT_FILE="$REPORT_DIR/session-$(date '+%Y%m%d-%H%M%S').log"

# Create sessions directory if it doesn't exist
mkdir -p "$REPORT_DIR"

INPUT=$(cat)

# Write a basic session completion marker
{
  echo "=== Session Completed: $TIMESTAMP ==="
  echo ""

  # Include session metadata if available
  if command -v jq &> /dev/null; then
    SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")
    echo "Session ID: $SESSION_ID"
  fi

  echo ""
  echo "Git status at completion:"
  git status --short 2>/dev/null || echo "(not a git repo or git not available)"

  echo ""
  echo "Recent changes:"
  git log --oneline -5 2>/dev/null || echo "(no git log available)"

  echo "=== End of Report ==="
} >> "$REPORT_FILE" 2>/dev/null

# Keep only the last 20 session logs (optional cleanup)
ls -t "$REPORT_DIR"/session-*.log 2>/dev/null | tail -n +21 | xargs rm -f 2>/dev/null || true

# Note: .claude/sessions/ is gitignored by default
exit 0
