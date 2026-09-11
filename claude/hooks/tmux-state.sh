#!/bin/bash
# Claude Code の hooks から呼ばれ、実行中の tmux ウィンドウに状態を書き込む
#   tmux-state.sh working|attention|done|idle|clear [--bell]
[ -n "$TMUX_PANE" ] || exit 0
state=$1
if [ "$state" = "clear" ]; then
  tmux set-option -w -t "$TMUX_PANE" -u @claude_state 2>/dev/null
else
  tmux set-option -w -t "$TMUX_PANE" @claude_state "$state" 2>/dev/null
fi
if [ "${2:-}" = "--bell" ]; then
  tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null) && printf '\a' > "$tty"
fi
exit 0
