# starship を初期化
eval "$(starship init zsh)"

# Homebrewの環境変数を設定（インストール場所はOS/アーキテクチャで異なる）
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# zoxide を初期化
eval "$(zoxide init zsh)"

# nvm（Node.jsバージョン管理）- 初回利用時まで読み込みを遅延
export NVM_DIR="$HOME/.nvm"

function _load_nvm() {
  unset -f nvm node npm npx corepack
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
}

function nvm() {
  _load_nvm
  nvm "$@"
}

function node() {
  _load_nvm
  node "$@"
}

function npm() {
  _load_nvm
  npm "$@"
}

function npx() {
  _load_nvm
  npx "$@"
}

function corepack() {
  _load_nvm
  corepack "$@"
}

# fzf の設定
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_DEFAULT_OPTS="\
--exact \
--tmux 80% \
--ansi \
--color=bg+:#313244,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=border:#6C7086,label:#CDD6F4"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# fzf補完のプレビューをコマンドごとにカスタマイズする
# - 第1引数がコマンド名、残りの引数はそのままfzfに渡す
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Catppuccin Mocha テーマを bat にインストール（初回のみ。マーカーファイルで bat の起動自体を毎回避ける）
bat_theme_marker="$HOME/.cache/bat-catppuccin-mocha-installed"
if [[ ! -f "$bat_theme_marker" ]]; then
  bat_config_dir="$(bat --config-dir)"
  mkdir -p "$bat_config_dir/themes"
  curl -o "$bat_config_dir/themes/Catppuccin Mocha.tmTheme" \
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme"
  bat cache --build
  mkdir -p "$(dirname "$bat_theme_marker")"
  touch "$bat_theme_marker"
  unset bat_config_dir
fi
unset bat_theme_marker
export BAT_THEME="Catppuccin Mocha"
