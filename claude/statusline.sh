#!/bin/bash
input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name // "unknown"')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
CURRENT_DIR=${CURRENT_DIR/#$HOME/\~}

EFFORT_LEVEL=$(echo "$input" | jq -r '.effort.level // empty')
THINKING_ENABLED=$(echo "$input" | jq -r '.thinking.enabled // false')
if [ -n "$EFFORT_LEVEL" ]; then
  THINKING="$EFFORT_LEVEL"
elif [ "$THINKING_ENABLED" = "true" ]; then
  THINKING="on"
else
  THINKING="off"
fi

SESSION_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$SESSION_PCT" ]; then
  SESSION_USAGE=$(printf "%.0f%%" "$SESSION_PCT")
else
  SESSION_USAGE="n/a"
fi
if [ -n "$WEEK_PCT" ]; then
  WEEK_USAGE=$(printf "%.0f%%" "$WEEK_PCT")
else
  WEEK_USAGE="n/a"
fi

DIM="\033[2m"
RESET="\033[0m"

printf "${DIM}[%s] Thinking:%s Dir:%s Usage:session=%s,week=%s${RESET}\n" \
  "$MODEL_DISPLAY" "$THINKING" "$CURRENT_DIR" "$SESSION_USAGE" "$WEEK_USAGE"
