# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# FZF Config
export FZF_DEFAULT_OPTS="\
--exact \
--tmux 80% \
--ansi \
--color=bg+:#363a4f,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#363a4f,label:#cad3f5 \
"

# ghq + fzf + cd
# 選択したリポジトリに移動する
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

# 過去に実行したコマンドを選択
function select-history() {
  BUFFER=$(\history -n -r 1 | sort -u | fzf)
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N select-history
bindkey '^r' select-history

# エラーを返すコマンドは履歴に記録しない
zshaddhistory() {
    [[ "$?" == 0 ]]
}

# 重複を記録しない
setopt hist_ignore_all_dups
# スペース始まりのコマンドは記録しない
setopt hist_ignore_space
# 余分なスペース排除
setopt hist_reduce_blanks
# historyから実行時に確認
setopt hist_verify
# 履歴ファイルを共有
setopt share_history
# zshの開始終了を記録
setopt extended_history

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
