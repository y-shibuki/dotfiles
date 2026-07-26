---
name: note
description: 直前の会話履歴を要約し、Zettelkastenのatomic noteとして second-brain Vault の notes/ に作成するスキル。「これをノートにして」「会話を要約してノート化して」のような発言、または/noteで起動する。どのディレクトリで実行しても second-brain Vault を対象にする。
---

# note

このセッションでのここまでの会話履歴全体を振り返り、後から読んでも文脈が分かるatomic note（1ノート1トピック）としてMarkdownファイルを作成する。

対象Vaultは `$SECOND_BRAIN_VAULT`（未設定の場合はユーザーに確認する）。実行中のカレントディレクトリに関わらず、常にこのVaultを対象にする。

## 手順

1. `echo $SECOND_BRAIN_VAULT` でVaultのパスを確認する
2. 会話履歴を振り返り、ノート化すべき主題を1つ（複数ある場合は主題ごとに複数ノート）特定する
3. 既存の `$SECOND_BRAIN_VAULT/notes/*.md` を確認し、関連しそうなノートがあれば `[[ファイル名（拡張子なし）]]` 形式でリンクする候補を探す
4. 以下の形式で `$SECOND_BRAIN_VAULT/notes/YYYYMMDDHHmm-{slug}.md` を作成する
   - `YYYYMMDDHHmm` は現在日時（`date +%Y%m%d%H%M` などで取得）
   - `{slug}` は内容を表す短い英語のkebab-case
5. frontmatterには `title`, `created`（ISO 8601）, `tags`（関連しそうなタグを`#project/personal` `#project/partner-2a`のように付与、不明なら省略可）を書く
6. 本文はユーザー自身の言葉ではなく、AIが要点を再構成した平易な文章にする。会話の逐語録にはしない
7. 関連ノートへの `[[wikilink]]` を本文中または末尾の「関連」セクションに含める
8. 作成後、ファイルパスと要約した主題をユーザーに報告する

## 出力例

```markdown
---
title: {タイトル}
created: {ISO8601日時}
tags: [{タグ}]
---

## 概要

{要約}

## 詳細

{要点を構造化した本文}

## 関連

- [[{関連ノート1}]]
- [[{関連ノート2}]]
```
