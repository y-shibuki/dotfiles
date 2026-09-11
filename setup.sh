#!/bin/bash
# [NOTE] ln -fnsv
#   -f (--force): 既存のファイルがある場合でも強制的にリンクを作成します。既存のリンクやファイルがある場合には、それを削除して新しいリンクを作成します。
#   -n (--no-dereference): シンボリックリンクを対象とする場合、そのリンク先ではなくリンク自体を操作します。このオプションは特にリンクを上書きする際に役立ちます。
#   -s (--symbolic): シンボリックリンクを作成します。
#   -v (--verbose): リンク作成の詳細を表示します。実行中に何が行われているかを確認するために使用します。

set -e

DOTFILES_DIR="$HOME/.dotfiles"
# 私的オーバーレイ（任意）。存在すれば bin/ と skills/ を同じ場所にリンクする
DOTFILES_LOCAL="$HOME/.dotfiles.local"

# --- Homebrew ---
_setup_homebrew_env() {
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/Homebrew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

_setup_homebrew_env

if ! command -v brew &> /dev/null; then
  echo "[setup] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  _setup_homebrew_env
fi

# --- Packages ---
echo "[setup] Installing packages via Brewfile..."
brew bundle --no-upgrade --file="$DOTFILES_DIR/Brewfile"

# --- Starship ---
if ! command -v starship &> /dev/null; then
  echo "[setup] Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
fi

# --- uv ---
echo "[setup] Installing Python and tools via uv..."
uv python install
uv tool install ruff

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
mkdir -p "$HOME/.local/bin"

# --- Symlinks ---
# bin
for script in "$DOTFILES_DIR"/bin/* "$DOTFILES_LOCAL"/bin/*; do
  [[ -f "$script" ]] || continue
  ln -fnsv "$script" "$HOME/.local/bin/$(basename "$script")"
done

# Zsh
ln -fnsv "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -fnsv "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"

# nvim
ln -fnsv "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# tmux
ln -fnsv "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# git
ln -fnsv "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# github.com の認証は gh に委譲する（CodeCommit 等の credential.helper=store はそのまま維持される）
# gh が書き込む helper のパスはマシンごとに異なるため、追跡対象外の ~/.gitconfig.local に書き込む
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
  echo "[setup] Configuring git credential helper for github.com via gh..."
  GIT_CONFIG_GLOBAL="$HOME/.gitconfig.local" gh auth setup-git
fi

# ruff
mkdir -p "$HOME/.config/ruff"
ln -fnsv "$DOTFILES_DIR/ruff/ruff.toml" "$HOME/.config/ruff/ruff.toml"

# claude
ln -fnsv "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.config/claude/CLAUDE.md"
ln -fnsv "$DOTFILES_DIR/claude/settings.json" "$HOME/.config/claude/settings.json"
ln -fnsv "$DOTFILES_DIR/claude/commands" "$HOME/.config/claude/commands"
ln -fnsv "$DOTFILES_DIR/claude/docs" "$HOME/.config/claude/docs"
ln -fnsv "$DOTFILES_DIR/claude/statusline.sh" "$HOME/.config/claude/statusline.sh"
# skills は公開・私的の両方を 1 つのディレクトリに集めるため、スキル単位でリンクする
if [[ -L "$HOME/.config/claude/skills" ]]; then
  rm "$HOME/.config/claude/skills"
fi
mkdir -p "$HOME/.config/claude/skills"
for skill in "$DOTFILES_DIR"/claude/skills/*/ "$DOTFILES_LOCAL"/skills/*/; do
  [[ -d "$skill" ]] || continue
  ln -fnsv "${skill%/}" "$HOME/.config/claude/skills/$(basename "$skill")"
done
ln -fnsv "$DOTFILES_DIR/claude/agents" "$HOME/.config/claude/agents"
ln -fnsv "$DOTFILES_DIR/claude/hooks" "$HOME/.config/claude/hooks"

# vscode
if command -v code &> /dev/null; then
  echo "[setup] Installing VSCode extensions..."
  while IFS= read -r ext || [[ -n "$ext" ]]; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    code --install-extension "$ext" --force
  done < "$DOTFILES_DIR/vscode/extensions.txt"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
  else
    VSCODE_USER_DIR="$HOME/.config/Code/User"
  fi
  mkdir -p "$VSCODE_USER_DIR"
  ln -fnsv "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
fi

echo "
[setup] 以下のコマンドで、ユーザー情報を別で管理すること

$ git config --file ~/.gitconfig.local --add user.name 'Your Name'
$ git config --file ~/.gitconfig.local --add user.email 'Your Email'
"

echo "[setup] Setup complete!"
echo "[setup] Please restart your terminal or run: exec zsh"
