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
    local session
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzy -p 'tmux sessions > ' ) && {
      tmux $change -t "$session"
    } || {
      read -q "REPLY?Create session \"${session}\"? "
      echo
      [[ $REPLY == 'y' ]] && tm $session
    }
  fi
}

function _fzy_tmux () {
  local -a sessions
  sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
  compadd -a sessions
}
# doesn't load on 5.0.X?
compdef _fzy_tmux tm 2>/dev/null
