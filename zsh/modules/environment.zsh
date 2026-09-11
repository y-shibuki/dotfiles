# 基本環境設定
export EDITOR="nvim"
export VISUAL="$EDITOR"
export CLAUDE_CONFIG_DIR=$HOME/.config/claude
# ローカル拡張のディレクトリ。存在すれば bin/ skills/ zsh/ を取り込む
export DOTFILES_LOCAL="$HOME/.dotfiles.local"

# PATH管理（typeset -U で重複防止）
typeset -U path PATH

# Homebrewのパスは tools.zsh の _setup_homebrew_env（brew shellenv）が設定する
path=(
  "$DOTFILES_LOCAL/bin"(N)
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  "/usr/bin"
  "/usr/sbin"
  "/bin"
  "/sbin"
  $path
)

# 履歴設定
HISTFILE=$HOME/.zsh_history
HISTORY_IGNORE="(cd|pwd|l[sal]|man|rm|code|nvim)"
HISTSIZE=10000
SAVEHIST=10000

setopt extended_history
setopt hist_allow_clobber
setopt hist_fcntl_lock
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history_time

setopt no_beep
