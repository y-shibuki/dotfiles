autoload -U add-zsh-hook

# --- neovim ---

function nvim-update() {
  echo "Updating Neovim..."
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  tar xzvf nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo mv nvim-linux-x86_64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  echo "Neovim updated successfully!"
  nvim --version
  cd - > /dev/null
}

# --- python venv ---

function _auto_activate_venv() {
  local venv_names=("venv" ".venv")
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    for venv_name in "${venv_names[@]}"; do
      local venv_path="$dir/$venv_name"
      if [[ -d "$venv_path/bin" ]]; then
        if [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
          source "$venv_path/bin/activate"
          echo "Activated virtualenv: $venv_path"
        fi
        return
      fi
    done
    dir="$(dirname "$dir")"
  done

  if [[ -n "$VIRTUAL_ENV" ]]; then
    deactivate
    echo "Deactivated virtualenv"
  fi
}

add-zsh-hook -d chpwd _auto_activate_venv
add-zsh-hook chpwd _auto_activate_venv
_auto_activate_venv

# --- ghq ---

function _ghq_select() {
  ghq list | fzf --prompt="Select repository: "
}

function ghq-cd() {
  local selected_dir=$(_ghq_select)
  [[ -n "$selected_dir" ]] && cd "$(ghq root)/$selected_dir"
}

function ghq-code() {
  local selected_dir=$(_ghq_select)
  [[ -n "$selected_dir" ]] && code "$(ghq root)/$selected_dir"
}

function ghq-nvim() {
  local selected_dir=$(_ghq_select)
  [[ -n "$selected_dir" ]] && nvim "$(ghq root)/$selected_dir"
}

function ghq-create-new-repository() {
  if [[ -z "$1" ]]; then
    echo "Usage: ghq-create-new-repository <repository-name>"
    return 1
  fi

  local root=$(ghq root)
  local user=$(git config --get github.user)

  if [[ -z "$user" ]]; then
    echo "Error: github.user not configured"
    echo "Run: git config --global github.user YOUR_GITHUB_USER_NAME"
    return 1
  fi

  local name="$1"
  local repo="$root/github.com/$user/$name"

  if [[ -e "$repo" ]]; then
    echo "Error: $repo already exists"
    return 1
  fi

  git init "$repo" || return 1
  cd "$repo" || return 1
  echo "# ${(C)name}" > README.md
  git add .
  echo "Repository created at: $repo"
}

# --- history ---

function select-history() {
  local selected
  selected=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | awk '!seen[$0]++' | fzf --tac --prompt="History: ")

  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle clear-screen
}

# --- tmux ---

function _update_tmux_window_name() {
  if [ -z "$TMUX" ]; then
    return
  fi

  local window_name=""

  if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ]; then
    local hostname=$(hostname -s)
    local current_dir=$(basename "$PWD")
    window_name="ssh:${hostname}:${current_dir}"
  else
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -n "$git_root" ]; then
      window_name=$(basename "$git_root")
    else
      window_name=$(basename "$PWD")
    fi
  fi

  if [ ${#window_name} -gt 30 ]; then
    window_name="${window_name:0:27}..."
  fi

  tmux rename-window "$window_name"
}

add-zsh-hook -d chpwd _update_tmux_window_name
add-zsh-hook chpwd _update_tmux_window_name

# --- reload ---

function reload() {
  source ~/.zshrc
  if [[ -n "$TMUX" ]]; then
    tmux source ~/.config/tmux/tmux.conf
    echo "zsh + tmux reloaded"
  else
    echo "zsh reloaded"
  fi
}

# --- git ---

function gtidy() {
  git pull -p || return 1

  local branches
  branches=$(git branch --merged | grep -v -E '^\*|main|master|develop')

  if [[ -z "$branches" ]]; then
    echo "削除対象のブランチはありません"
    return 0
  fi

  echo "以下のブランチを削除します："
  echo "$branches"
  echo ""

  read "answer?実行しますか？ [y/N]: "
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "$branches" | xargs git branch -d
    echo "削除しました"
  else
    echo "キャンセルしました"
  fi
}
