#!/bin/bash
# 現在のブランチがどのブランチから分岐したか（merge-base）を自動検出する。
# 全ブランチとの分岐点を比較し、最も新しい分岐点を持つブランチを「切った元のブランチ」とみなす。
set -euo pipefail

TRUNK_PATTERN='(main|master|develop|release)'

current=$(git rev-parse --abbrev-ref HEAD)
current_sha=$(git rev-parse HEAD)

# 現在のブランチ自体がmain/master/develop/releaseのようなトランク的なブランチの場合、
# 「ブランチを切った地点」という前提が成り立たないため、自動検出はせずユーザー確認を促す。
if echo "$current" | grep -qiE "$TRUNK_PATTERN"; then
  echo "現在のブランチ(${current})はmain/master/develop/releaseに該当する可能性があります。"
  echo "このブランチで本当に処理を進めるか、また直近何コミットを対象にするかをユーザーに確認してください。"
  exit 3
fi

# 分岐元候補は、main/master/develop/releaseのいずれかを名前に含むブランチのみに絞る。
candidates=$(git for-each-ref --format='%(refname:short)' refs/heads/ refs/remotes/ \
  | grep -vE '(^|/)HEAD$' \
  | grep -vE "^${current}$" \
  | grep -vE "^origin/${current}$" \
  | grep -iE "$TRUNK_PATTERN" \
  | sort -u)

if [ -z "$candidates" ]; then
  echo "候補となるブランチ（main/master/develop/releaseを含む名前）が見つかりませんでした。ベースブランチを手動で指定してください。"
  exit 1
fi

results=()
for branch in $candidates; do
  mb=$(git merge-base "$current_sha" "$branch" 2>/dev/null) || continue
  # 分岐点が自分のHEAD自身の場合は、そのブランチは自分の子孫（＝分岐元ではない）なので除外
  if [ "$mb" = "$current_sha" ]; then
    continue
  fi
  date=$(git show -s --format=%ct "$mb")
  results+=("${date}|${mb}|${branch}")
done

if [ ${#results[@]} -eq 0 ]; then
  echo "候補となるブランチが見つかりませんでした。ベースブランチを手動で指定してください。"
  exit 1
fi

sorted=$(printf '%s\n' "${results[@]}" | sort -t'|' -k1,1nr)
top_date=$(echo "$sorted" | head -1 | cut -d'|' -f1)
tied=$(echo "$sorted" | awk -F'|' -v d="$top_date" '$1==d')
tied_count=$(echo "$tied" | wc -l)

if [ "$tied_count" -gt 1 ]; then
  echo "分岐点が同時期の候補が複数あります。どのブランチが分岐元か、ユーザーに確認してください:"
  echo "$tied" | while IFS='|' read -r d mb br; do
    echo "  - branch=${br} merge_base=${mb}"
  done
  exit 2
fi

branch=$(echo "$tied" | cut -d'|' -f3)
mb=$(echo "$tied" | cut -d'|' -f2)

echo "base_branch=${branch}"
echo "merge_base=${mb}"
