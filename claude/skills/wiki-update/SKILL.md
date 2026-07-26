---
name: wiki-update
description: 指定プロジェクト（personal / partner-2a）の second-brain Vault 内Wikiに、直前の会話や作業内容から得た知見を追記・整理するスキル。「このプロジェクトの知見をWikiにまとめて」のような発言、または/wiki-update <project>で起動する。どのディレクトリで実行しても second-brain Vault を対象にする。
---

# wiki-update

argsとしてプロジェクト名（`personal` または `partner-2a`）を受け取る。指定がない、またはこの2つ以外の場合はユーザーに確認する。

対象Vaultは `$SECOND_BRAIN_VAULT`（未設定の場合はユーザーに確認する）。実行中のカレントディレクトリに関わらず、常にこのVaultを対象にする。

## 手順

1. `echo $SECOND_BRAIN_VAULT` でVaultのパスを確認する
2. argsからプロジェクト名を特定し、対象ディレクトリを `$SECOND_BRAIN_VAULT/projects/{project}/` とする
3. このセッションでの会話・作業内容を振り返り、そのプロジェクトのWikiとして残す価値のある知見（仕様、意思決定の背景、詰まった点と解決策、用語定義など）を抽出する
4. `$SECOND_BRAIN_VAULT/projects/{project}/` 配下の既存ファイルを確認し、関連するトピックのファイルがあれば追記、なければ新規ファイルを作成する
   - 1ファイル1トピックを意識し、何でもかんでも1つのファイルに詰め込まない
   - ファイル名は内容を表す英語kebab-case（例: `architecture.md`, `deploy-flow.md`）
5. frontmatterには `title`, `updated`（ISO 8601）, `tags`（`#project/{project}` を含める）を書く
6. `$SECOND_BRAIN_VAULT/notes/` 内に関連するatomic noteがあれば `[[wikilink]]` で結びつける
7. 更新後、変更したファイルのパスと追記内容の要点をユーザーに報告する

## 出力例

```markdown
---
title: {タイトル}
updated: {ISO8601日時}
tags: [project/{project}]
---

## 概要

{要約}

## 詳細

{知見の本文}

## 関連

- [[{関連ノート}]]
```
