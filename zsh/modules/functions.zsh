autoload -U add-zsh-hook

# Neovim update function
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

function auto_activate_venv() {
    # venvディレクトリ名の候補
    local venv_names=("venv" ".venv")
    
    # 現在のディレクトリから上位に向かってvenvを探す
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
    
    # venvが見つからない場合、現在アクティブなvenvを無効化
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
        echo "Deactivated virtualenv"
    fi
}

add-zsh-hook chpwd auto_activate_venv
auto_activate_venv

function _ghq-select() {
  ghq list | fzf --prompt="Select repository: "
}

function ghq-cd() {
  local selected_dir=$(_ghq-select)
  [[ -n "$selected_dir" ]] && cd "$(ghq root)/$selected_dir"
}

function ghq-code() {
  local selected_dir=$(_ghq-select)
  [[ -n "$selected_dir" ]] && code "$(ghq root)/$selected_dir"
}

function ghq-nvim() {
  local selected_dir=$(_ghq-select)
  [[ -n "$selected_dir" ]] && nvim "$(ghq root)/$selected_dir"
}

# 新しいリポジトリを作成し、移動する
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

# 過去に実行したコマンドを選択
function select-history() {
  local selected
  selected=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | awk '!seen[$0]++' | fzf --tac --prompt="History: ")
  
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle clear-screen
}

# tmuxのWindow名を更新
function update_tmux_window_name() {
  if [ -z "$TMUX" ]; then
    return
  fi

  local window_name=""

  # SSH接続の場合
  if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ]; then
    local hostname=$(hostname -s)  # ホスト名も含める場合
    local current_dir=$(basename "$PWD")
    window_name="ssh:${hostname}:${current_dir}"
  else
    # Gitリポジトリかどうかチェック
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -n "$git_root" ]; then
        window_name=$(basename "$git_root")
    else
        window_name=$(basename "$PWD")
    fi
  fi

  # 30文字制限
  if [ ${#window_name} -gt 30 ]; then
      window_name="${window_name:0:27}..."
  fi

  tmux rename-window "$window_name"
}

add-zsh-hook chpwd update_tmux_window_name
