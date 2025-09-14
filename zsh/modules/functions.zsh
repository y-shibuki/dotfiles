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

# ghq + fzf + cd
function ghq-cd () {
  local selected_dir=$(ghq list | fzf)
  if [ -n "$selected_dir" ]; then
    cd $(ghq root)/${selected_dir}
  fi
}

# ghq + fzf + code
function ghq-code () {
  local selected_dir=$(ghq list | fzf)
  if [ -n "$selected_dir" ]; then
    code $(ghq root)/${selected_dir}
  fi
}

# ghq + fzf + nvim
function ghq-nvim () {
  local selected_dir=$(ghq list | fzf)
  if [ -n "$selected_dir" ]; then
    nvim $(ghq root)/${selected_dir}
  fi
}

# 新しいリポジトリを作成し、移動する
function ghq-create-new-repository() {
  local root=`ghq root`
  local user=`git config --get github.user`
  if [ -z "$user" ]; then
    echo "you need to set github.user."
    echo "git config --global github.user YOUR_GITHUB_USER_NAME"
    return 1
  fi
  local name=$1
  local repo="$root/github.com/$user/$name"
  if [ -e "$repo" ]; then
    echo "$repo is already exists."
    return 1
  fi
  git init $repo
  cd $repo
  echo "# ${(C)name}" > README.md
  git add .
}

# 過去に実行したコマンドを選択
function select-history() {
  # 時系列を保持しつつ重複を削除
  BUFFER=$(history -n 1 | awk '!seen[$0]++' | fzf --tac)
  CURSOR=$#BUFFER
  zle clear-screen
}