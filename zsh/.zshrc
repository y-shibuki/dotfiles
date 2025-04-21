# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

## ctrl + x でディレクトリ移動を行う
function ghq-cd () {
  local selected_dir=$(ghq list | fzf)
  if [ -n "$selected_dir" ]; then
    cd $(ghq root)/${selected_dir}
  fi
}
alias repo="ghq-cd"

# ghq + fzf + code
# 選択したリポジトリをVSCodeで開く
function ghq-code () {
  local selected_dir=$(ghq list | fzf)
  if [ -n "$selected_dir" ]; then
    code $(ghq root)/${selected_dir}
  fi
}
alias repo-code="ghq-code"

# ghq
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
alias repo-new="ghq-create-new-repository"

## ctrl + r で過去に実行したコマンドを選択できるようにする。
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | sort -u | fzf)
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"