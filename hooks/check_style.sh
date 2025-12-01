#!/bin/bash
TOOL_PARAMS=$(cat)
FILE_PATH=$(echo "$TOOL_PARAMS" | jq -r '.file_path // empty')

if [[ "$FILE_PATH" =~ \.(js|es)$ ]]; then
  VIOLATIONS=false

  # const/let check
  if grep -E '\b(const|let)\b' "$FILE_PATH" >/dev/null 2>&1; then
    echo "[VIOLATION] Use var, not const/let" >&2
    VIOLATIONS=true
  fi

  # .then() check
  if grep -E '\.then\s*\(' "$FILE_PATH" >/dev/null 2>&1; then
    echo "[VIOLATION] Use async/await, not .then()" >&2
    VIOLATIONS=true
  fi

  # Comments check (except todo/note)
  if grep -P '^\s*//(?!\s*(todo|note):)' "$FILE_PATH" >/dev/null 2>&1; then
    echo "[VIOLATION] Remove comments (except todo/note)" >&2
    VIOLATIONS=true
  fi

  echo "$TOOL_PARAMS"
  if [ "$VIOLATIONS" = true ]; then exit 2; fi
fi

echo "$TOOL_PARAMS"
exit 0
