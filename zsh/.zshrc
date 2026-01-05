for config in "$HOME/.dotfiles/zsh/modules/"*.zsh(N); do
  source "$config"
done

if [[ -r "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if command -v tmux &> /dev/null && [[ -z "$TMUX" && -z "$VIM" && "$TERM_PROGRAM" != "vscode" && $- == *l* ]] ; then
  tmux attach-session -t default || tmux new-session -s default
fi
