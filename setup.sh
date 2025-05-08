#!/bin/bash
# [NOTE] ln -fnsv
#  -f (--force): 既存のファイルがある場合でも強制的にリンクを作成します。既存のリンクやファイルがある場合には、それを削除して新しいリンクを作成します。
#  -n (--no-dereference): シンボリックリンクを対象とする場合、そのリンク先ではなくリンク自体を操作します。このオプションは特にリンクを上書きする際に役立ちます。
#  -s (--symbolic): シンボリックリンクを作成します。
#  -v (--verbose): リンク作成の詳細を表示します。実行中に何が行われているかを確認するために使用します。

HOME_DIR="~"
DOTFILES_DIR="$HOME_DIR/.dotfiles"

# zsh
ln -fnsv "$DOTFILES_DIR/zsh/.zshrc" "$HOME_DIR/.zshrc"

# nvim
ln -fnsv "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"

# tmux
ln -fnsv "$DOTFILES_DIR/tmux/tmux.conf" "$HOME_DIR/.config/tmux/tmux.conf"