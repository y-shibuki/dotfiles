#!/bin/bash
# [NOTE] ln -fnsv
#   -f (--force): 既存のファイルがある場合でも強制的にリンクを作成します。既存のリンクやファイルがある場合には、それを削除して新しいリンクを作成します。
#   -n (--no-dereference): シンボリックリンクを対象とする場合、そのリンク先ではなくリンク自体を操作します。このオプションは特にリンクを上書きする際に役立ちます。
#   -s (--symbolic): シンボリックリンクを作成します。
#   -v (--verbose): リンク作成の詳細を表示します。実行中に何が行われているかを確認するために使用します。

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# --- Homebrew ---
_setup_brew_env() {
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/Homebrew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

_setup_brew_env

if ! command -v brew &> /dev/null; then
  echo "[setup] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  _setup_brew_env
fi

# --- Packages ---
echo "[setup] Installing packages via Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- zsh ---
if [[ "$SHELL" != */zsh ]]; then
  ZSH_PATH="$(command -v zsh)"
  if ! grep -qF "$ZSH_PATH" /etc/shells; then
    echo "[setup] Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
  fi
  echo "[setup] Changing default shell to zsh..."
  chsh -s "$ZSH_PATH"
fi

# --- Directories ---
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/claude"

# --- Symlinks ---
# Zsh
ln -fnsv "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -fnsv "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"

# nvim
ln -fnsv "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# tmux
ln -fnsv "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# git
ln -fnsv "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# claude
ln -fnsv "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.config/claude/CLAUDE.md"
ln -fnsv "$DOTFILES_DIR/claude/settings.json" "$HOME/.config/claude/settings.json"
ln -fnsv "$DOTFILES_DIR/claude/commands" "$HOME/.config/claude/commands"
ln -fnsv "$DOTFILES_DIR/claude/docs" "$HOME/.config/claude/docs"
ln -fnsv "$DOTFILES_DIR/claude/statusline.sh" "$HOME/.config/claude/statusline.sh"

echo "
[setup] 以下のコマンドで、ユーザー情報を別で管理すること

$ git config --file ~/.gitconfig.local --add user.name 'Your Name'
$ git config --file ~/.gitconfig.local --add user.email 'Your Email'
"

echo "[setup] Setup complete!"
echo "[setup] Please restart your terminal or run: exec zsh"
