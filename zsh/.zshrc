for config in "$HOME/.dotfiles/zsh/modules/"*.zsh(N); do
  source "$config"
done

if [[ -r "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Zsh Syntax Highlighting
if [[ -f ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if command -v tmux &> /dev/null && [[ -z "$TMUX" && -z "$VIM" && "$TERM_PROGRAM" != "vscode" && $- == *l* ]] ; then
  tmux attach-session -t default || tmux new-session -s default
fi
