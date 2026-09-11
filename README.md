# .dotfiles

## Setup
```bash
git clone https://github.com/y-shibuki/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash setup.sh
```

## 私的オーバーレイ（~/.dotfiles.local）

公開したくない設定は別リポジトリに置き、`~/.dotfiles.local` にクローンする。存在すれば setup.sh と zsh が自動で取り込む。

| パス | 扱い |
| --- | --- |
| `bin/*` | `~/.local/bin` にリンクされ、PATH に入る |
| `skills/*/` | `~/.config/claude/skills` にスキル単位でリンクされる |
| `zsh/*.zsh` | `.zshrc` から読み込まれる |
| `hub-status` | 実行可能なら hub のヘッダーに出力が差し込まれる |

## Shell functions

以下は zsh 関数として定義されており、ターミナルで直接実行します。

| コマンド | 説明 |
| --- | --- |
| `reload` | zsh と tmux（セッション内の場合）の設定をリロードする |
| `brew-update` | Homebrew パッケージを更新する |
| `brew-dump` | 現在の環境から Brewfile を再生成する |

## hub（tmux デスクトップ）

全 tmux セッションを横断してウィンドウ一覧・Claude Code の状態・git 差分を常時表示するダッシュボード。`bin/hub` を `~/.local/bin/hub` にリンクして使う。

| 操作 | 説明 |
| --- | --- |
| `hub` / `prefix + h` | hub セッションへ移動する（無ければ作成） |
| `prefix + j` | どこからでも popup でウィンドウを選んでジャンプする |
| `prefix + g` | 現在のディレクトリで lazygit を popup で開く |
| hub 内 `Enter` | 選択したウィンドウへジャンプする |
| hub 内 `Ctrl-n` | 新しいタスクを作る（`wt new`） |
| hub 内 `Ctrl-b` | `notes` コマンドがあれば notes セッションへ移動する（私的オーバーレイ） |
| hub 内 `Ctrl-o` | 選択したウィンドウのディレクトリで lazygit を開く |
| hub 内 `Ctrl-x` | 選択したウィンドウを閉じる |

## wt（worktree タスク）

1 タスク = 1 ブランチ = 1 worktree = 1 tmux window として扱う。slug（ブランチ名）をブランチ・worktree ディレクトリ・window 名・PR タイトルで統一する。worktree は `~/worktrees/<repo>/<slug>` に置く。

| コマンド | 説明 |
| --- | --- |
| `wt new [slug] [repo-dir]` | worktree 作成、リポジトリ名のセッションに slug 名の window を作り、Claude を起動する |
| `wt pr` | ブランチを push して draft PR を作る（タイトルは slug） |
| `wt done [slug] [--force]` | worktree と window を削除する。未コミット・未プッシュがあれば拒否する |
| `wt clean` | 全 worktree を一覧し、複数選択して片付ける |
| `wt list` | worktree の一覧と状態を表示する |

Claude Code の状態（作業中 / 入力待ち / 完了）は `claude/hooks/tmux-state.sh` が hooks 経由で tmux のウィンドウオプション `@claude_state` に書き込み、hub がそれを読む。
