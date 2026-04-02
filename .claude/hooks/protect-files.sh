#!/bin/bash
# Blocks Claude from editing protected files
# Used as PreToolUse hook for Edit|Write

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

FILE_PATH="${FILE_PATH%/}"

# Protected exact filenames
PROTECTED_FILES=(
  ".env"
  ".env.local"
  ".env.production"
  ".env.staging"
  ".env.development"
  "package-lock.json"
  "yarn.lock"
  "pnpm-lock.yaml"
)

# Protected directories
PROTECTED_DIRS=(
  ".git"
  "node_modules"
  "dist"
  ".next"
)

# Protected extensions
PROTECTED_EXTENSIONS=(
  ".dump"
  ".tar.gz"
  ".sql.gz"
)

# Check exact filenames
BASENAME=$(basename "$FILE_PATH")
for protected in "${PROTECTED_FILES[@]}"; do
  if [[ "$BASENAME" == "$protected" ]]; then
    echo "Blocked: editing '$FILE_PATH' is not allowed (protected file '$protected'). Ask the user if this change is intentional." >&2
    exit 2
  fi
done

# Check directory segments
for dir in "${PROTECTED_DIRS[@]}"; do
  if [[ "$FILE_PATH" == *"/$dir/"* ]] || [[ "$FILE_PATH" == *"/$dir" ]] || [[ "$FILE_PATH" == "$dir/"* ]]; then
    echo "Blocked: editing '$FILE_PATH' is not allowed (inside protected directory '$dir/'). Ask the user if this change is intentional." >&2
    exit 2
  fi
done

# Check extensions
for ext in "${PROTECTED_EXTENSIONS[@]}"; do
  if [[ "$FILE_PATH" == *"$ext" ]]; then
    echo "Blocked: editing '$FILE_PATH' is not allowed (protected extension '$ext'). Ask the user if this change is intentional." >&2
    exit 2
  fi
done

exit 0
