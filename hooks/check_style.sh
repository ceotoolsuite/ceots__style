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

  # camelCase check - looks for patterns like varName, functionName, propertyName
  # Excludes: PascalCase (classes), ALL_CAPS, snake_case, built-ins, and common exceptions
  if grep -P '(?<![A-Z_])\b[a-z]+[A-Z][a-zA-Z]*\b(?!\s*\()' "$FILE_PATH" | \
     grep -vE '(getElementById|querySelector|querySelectorAll|addEventListener|removeEventListener|localStorage|sessionStorage|innerHTML|innerText|textContent|className|classList|parentNode|childNodes|firstChild|lastChild|nextSibling|previousSibling|createElement|createTextNode|appendChild|removeChild|insertBefore|getAttribute|setAttribute|removeAttribute|hasAttribute|getBoundingClientRect|getComputedStyle|requestAnimationFrame|cancelAnimationFrame|setTimeout|clearTimeout|setInterval|clearInterval|JSON|forEach|indexOf|toString|valueOf|charCodeAt|fromCharCode|toUpperCase|toLowerCase|toFixed|toArray|fromEntries|DurableObject|WebSocket|ArrayBuffer|Uint8Array|Int32Array|Float64Array|FormData|URLSearchParams|ReadableStream|WritableStream|TransformStream|TextEncoder|TextDecoder|AbortController|AbortSignal|MessageEvent|CloseEvent|ErrorEvent|CustomEvent|MouseEvent|KeyboardEvent|TouchEvent|FocusEvent|InputEvent|PointerEvent|WheelEvent|DragEvent|AnimationEvent|TransitionEvent|ResizeObserver|MutationObserver|IntersectionObserver|PerformanceObserver|contentType|responseText|responseType|statusText|withCredentials|XMLHttpRequest|responseURL|readyState|onreadystatechange|getAllResponseHeaders|getResponseHeader|overrideMimeType|setRequestHeader|WebSocketPair)' >/dev/null 2>&1; then
    echo "[VIOLATION] Use snake_case, not camelCase" >&2
    VIOLATIONS=true
  fi

  # Missing semicolon check - statements that should end with semicolon but don't
  # Checks: var/let/const declarations, return/throw, function calls, assignments
  if grep -P "^[^/]*\b(var|return|throw)\b[^;{]*[^;,{\s]$" "$FILE_PATH" | \
     grep -vE '^\s*//' >/dev/null 2>&1; then
    echo "[VIOLATION] Missing semicolon" >&2
    VIOLATIONS=true
  fi

  # Trailing comma check - multi-line objects/arrays missing trailing comma
  # Looks for lines ending with value followed by newline then closing brace/bracket
  if grep -Pzo "['\"\w\d\]\)]\s*\n\s*[}\]]" "$FILE_PATH" | grep -v ',' >/dev/null 2>&1; then
    echo "[VIOLATION] Missing trailing comma in multi-line structure" >&2
    VIOLATIONS=true
  fi

  # Console.log pattern check - should use ::, >>=, <==, or !!! patterns
  if grep -P "console\.(log|error|warn)\s*\([^)]*\)" "$FILE_PATH" | \
     grep -vE '(::|\>\>=|\<==|!!!)' | \
     grep -vE "console\.(log|error|warn)\s*\(\s*'%c'" >/dev/null 2>&1; then
    echo "[VIOLATION] Console logs should use :: (existing), >>= (modified), <== (response), or !!! (error) patterns" >&2
    VIOLATIONS=true
  fi

  echo "$TOOL_PARAMS"
  if [ "$VIOLATIONS" = true ]; then exit 2; fi
fi

echo "$TOOL_PARAMS"
exit 0
