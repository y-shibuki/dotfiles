# brew
alias brew-update='brew update && brew upgrade && brew cleanup'

# ghq
alias repo="ghq-cd"
alias repo-code="ghq-code"
alias repo-nvim="ghq-nvim"
alias repo-new="ghq-create-new-repository"

# eza
alias ls="eza --color=always --icons --group-directories-first"
alias ll='ls -alF'
alias ls-tree='ls --tree'

alias lg='lazygit'

# VSCode（WSL環境のみ）
if [[ "$(uname)" == "Linux" ]]; then
  alias code='code --remote wsl+Ubuntu'
fi
