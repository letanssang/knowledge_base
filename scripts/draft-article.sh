#!/usr/bin/env bash
# Ask one series notebook to draft an article.
# The notebook id is articles/<series>/notebook.toml.
# The prompt is templates/notebooklm-prompt.md.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

if [[ $# -ne 1 ]]; then
  echo "Usage: scripts/draft-article.sh <series-slug>" >&2
  echo "Example: scripts/draft-article.sh mobile-security" >&2
  exit 1
fi

series="$1"
if [[ ! "$series" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Series slug must be lowercase kebab-case: $series" >&2
  exit 1
fi

config="articles/${series}/notebook.toml"
if [[ ! -f "$config" ]]; then
  echo "No ${config}. This series has no NotebookLM notebook yet." >&2
  exit 1
fi

id="$(awk -F= '/^id[[:space:]]*=/ { gsub(/["[:space:]]/, "", $2); print $2; exit }' "$config")"
if [[ -z "$id" ]]; then
  echo "Set id in ${config}. It is the last segment of the NotebookLM URL." >&2
  exit 1
fi

if ! command -v notebooklm >/dev/null 2>&1; then
  echo "notebooklm is not on PATH. Install and sign in:" >&2
  echo "  uv tool install \"notebooklm-py[browser]\"" >&2
  echo "  notebooklm login" >&2
  exit 1
fi

notebooklm ask \
  -n "$id" \
  --prompt-file "$root/templates/notebooklm-prompt.md" \
  --json \
  --new \
  -y | python3 -c 'import json,sys; data=json.load(sys.stdin); answer=data.get("answer") or data.get("text") or "";
print(answer if isinstance(answer, str) else json.dumps(data, ensure_ascii=False))'
