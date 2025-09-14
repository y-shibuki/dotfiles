# 基本環境設定
export EDITOR="nvim"
export VISUAL="$EDITOR"

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
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history_time

setopt no_beep

# bat
export BAT_THEME="Dracula"