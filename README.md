# .dotfiles

## Setup
```bash
git clone https://github.com/y-shibuki/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash setup.sh
```

## Shell functions

以下は zsh 関数として定義されており、ターミナルで直接実行します。

| コマンド | 説明 |
| --- | --- |
| `reload` | zsh と tmux（セッション内の場合）の設定をリロードする |
| `brew-update` | Homebrew パッケージを更新する |
| `brew-dump` | 現在の環境から Brewfile を再生成する |
