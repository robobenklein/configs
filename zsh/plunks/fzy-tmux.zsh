#!/bin/zsh

# original idea from
# http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if (( ${+1} )); then
    tmux $change -t "$1" 2>/dev/null || {
      (tmux new-session -d -s $1 && tmux $change -t "$1")
    }
  else
    local session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzy ) && {
      tmux $change -t "$session"
    } || {
      echo "creating..."
      tm $session
    }
  fi
}

function _fzy_tmux () {
  local -a sessions
  sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
  compadd -a sessions
}
compdef _fzy_tmux tm
