---
name: daily-report
description: second-brain Vault の inbox/ の当日メモとこのセッションの会話ログを元に、daily/YYYY-MM-DD.mdを生成・更新するスキル。「今日のメモを日報にして」のような発言、または/daily-reportで起動する。日付を引数で指定可能（省略時は当日）。どのディレクトリで実行しても second-brain Vault を対象にする。
---

# daily-report

`$SECOND_BRAIN_VAULT/inbox/`の当日メモとこのセッションの会話ログを元に、`$SECOND_BRAIN_VAULT/daily/YYYY-MM-DD.md`を生成・更新する。

対象Vaultは `$SECOND_BRAIN_VAULT`（未設定の場合はユーザーに確認する）。実行中のカレントディレクトリに関わらず、常にこのVaultを対象にする。

argsに日付（YYYY-MM-DD）が指定されていればその日付、なければ当日の日付を対象とする。

## 手順

1. `echo $SECOND_BRAIN_VAULT` でVaultのパスを確認する
2. 対象日付を決定する（argsで未指定なら `date +%Y-%m-%d`）
3. `$SECOND_BRAIN_VAULT/inbox/` 配下から対象日付に関係しそうなメモを探す（ファイル名やfrontmatterの日付、更新日時などで判断）
4. このセッションでの会話ログのうち、対象日付に行った作業・決定事項・気づきを拾い上げる
5. `$SECOND_BRAIN_VAULT/daily/YYYY-MM-DD.md` が既に存在する場合は内容を読み、重複しないよう追記・統合する。存在しない場合は新規作成する
6. 箇条書き中心で簡潔にまとめる。ユーザーの言葉を勝手に大きく脚色せず、事実ベースで整形する
7. 該当する `projects/personal/` や `projects/partner-2a/` の話題があれば、日報内から `[[wikilink]]` で該当プロジェクトのWikiページにリンクする（Wiki自体の更新は `wiki-update` スキルに任せる）
8. 作成・更新後、ファイルパスと反映した内容の要点をユーザーに報告する

## 出力例

```markdown
---
date: {YYYY-MM-DD}
tags: [daily]
---

## やったこと

- {項目}

## 気づき・メモ

- {項目}

## 関連プロジェクト

- [[projects/personal/xxx]]
```
