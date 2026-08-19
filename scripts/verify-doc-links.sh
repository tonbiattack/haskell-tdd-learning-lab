#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

while IFS= read -r -d '' file; do
  while IFS= read -r target; do
    case "$target" in
      http://*|https://*|mailto:*|\#*) continue ;;
    esac

    target_path=${target%%#*}
    if [[ ! -e "$repo_root/$(dirname "$file")/$target_path" ]]; then
      printf 'Broken local Markdown link: %s -> %s\n' "$file" "$target" >&2
      exit 1
    fi
  done < <(grep -oE '\]\(([^)]+)\)' "$repo_root/$file" | sed -E 's/^\]\((.*)\)$/\1/' || true)
done < <(cd "$repo_root" && find . -name '*.md' -not -path './.git/*' -print0 | sed -z 's#^./##')

printf 'Markdown local links: ok\n'
