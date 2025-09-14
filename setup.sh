#!/bin/bash
# [NOTE] ln -fnsv
#   -f (--force): 既存のファイルがある場合でも強制的にリンクを作成します。既存のリンクやファイルがある場合には、それを削除して新しいリンクを作成します。
#   -n (--no-dereference): シンボリックリンクを対象とする場合、そのリンク先ではなくリンク自体を操作します。このオプションは特にリンクを上書きする際に役立ちます。
#   -s (--symbolic): シンボリックリンクを作成します。
#   -v (--verbose): リンク作成の詳細を表示します。実行中に何が行われているかを確認するために使用します。

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# Zsh
ln -fnsv "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -fnsv "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"

# nvim
ln -fnsv "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"


# tmux
ln -fnsv "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# git
ln -fnsv "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

echo "
[setup.sh] 以下のコマンドで、ユーザー情報を別で管理すること

$ git config --file ~/.gitconfig.local --add user.name 'Your Name'
$ git config --file ~/.gitconfig.local --add user.email Your Email
"

echo "[setup.sh] Setup complete!"
echo "[setup.sh] Please restart your terminal or run: source ~/.zshrc"